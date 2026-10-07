import 'dart:convert';
import 'dart:math' as math;
import 'dart:typed_data';

import 'package:archive/archive.dart';
import 'package:test/test.dart';
import 'package:vsd_core/vsd_core.dart';

// Runs on the VM and in a browser (`dart test -p chrome`), so it can't read
// fixture files: the statmon file is built inline.
const _statmon = '''
STATMON "4"
Time = "2026-02-19T16:09:13.930-08:00"
StatTypes = [
Shrpc  ( StatTypeNum Time ProcessName ProcessId SessionId CacheSerialNum DataPageReads ) 1
]
ENDHEADER
1 1771546154 ShrPcMonitor 18322 -1 0 10
1 1771546155 ShrPcMonitor 18322 -1 0 12
1 1771546156 ShrPcMonitor 18322 -1 0 15
''';

void main() {
  setUpAll(() => DataManager().loadStatistics());
  tearDown(() => DisplayTime.fileZone = FileZone.unknown);

  final plain = Uint8List.fromList(utf8.encode(_statmon));
  final gzipped = Uint8List.fromList(const GZipEncoder().encodeBytes(plain));

  for (final (label, bytes) in [('plain', plain), ('gzipped', gzipped)]) {
    test('loadFromBytes parses a $label statmon file', () async {
      final dm = DataManager();
      final progress = <double>[];
      await dm.loadFromBytes(bytes, onProgress: progress.add);

      expect(progress, isNotEmpty);
      expect(dm.allProcesses, hasLength(1));
      final process = dm.allProcesses.single;
      expect(process.name, 'ShrPcMonitor');
      expect(process.samples, 3);
      expect(process.startTime, DateTime.utc(2026, 2, 20, 0, 9, 14));
      expect(
        process.statisticData['DataPageReads']!.points.map((p) => p.value),
        [10, 12, 15],
      );
      expect(DisplayTime.fileZone.offsetMs, -8 * 3600000);
    });
  }

  for (final (label, bytes) in [('plain', plain), ('gzipped', gzipped)]) {
    for (final size in [1, 7]) {
      test(
        'loadFromStream parses a $label file arriving in $size-byte chunks',
        () async {
          // An empty first chunk, then chunks that split the gzip magic
          // number, lines and numbers.
          final chunks = [
            <int>[],
            for (var i = 0; i < bytes.length; i += size)
              bytes.sublist(i, math.min(i + size, bytes.length)),
          ];
          final dm = DataManager();
          final progress = <double>[];
          await dm.loadFromStream(
            Stream.fromIterable(chunks),
            length: bytes.length,
            onProgress: progress.add,
          );

          expect(progress.last, 1.0);
          final process = dm.allProcesses.single;
          expect(process.samples, 3);
          expect(
            process.statisticData['DataPageReads']!.points.map((p) => p.value),
            [10, 12, 15],
          );
        },
      );
    }
  }

  test('a process\'s series share one set of timestamps', () async {
    const twoStats = '''
STATMON "4"
StatTypes = [
Shrpc  ( StatTypeNum Time ProcessName ProcessId SessionId CacheSerialNum DataPageReads BitmapPageReads ) 1
]
ENDHEADER
1 1771546154 ShrPcMonitor 18322 -1 0 10 1
1 1771546155 ShrPcMonitor 18322 -1 0 12 2
''';
    final dm = DataManager();
    await dm.loadFromBytes(Uint8List.fromList(utf8.encode(twoStats)));

    final series = dm.allProcesses.single.statisticData.values.toList();
    expect(series, hasLength(2));
    expect(identical(series[0].timestamps, series[1].timestamps), isTrue);
    expect(series[0].timestamps.length, 2);
    expect(series[1].points.map((p) => p.value), [1, 2]);
    expect(
      series[1].points.last.timestamp,
      DateTime.utc(2026, 2, 20, 0, 9, 15),
    );
  });

  test(
    'parses an older file: fewer header fields, unknown statistics',
    () async {
      // STATMON "2" lines have no CacheSerialNum, write -1 as an unsigned 32-bit
      // number, and can name statistics with no definition. The last line was
      // cut short as statmonitor stopped.
      const v2 = '''
STATMON "2"
Time = "Tue 30 Sep 1997 17:36:09 PDT"
StatTypes = [
Shrpc ( StatTypeNum Time ProcessName ProcessId SessionId DataPageReads sessionStat0 BitmapPageReads ) 1
]
ENDHEADER
1 875666169 ShrPcMonitor 47984 4294967295 10 99 1
1 875666170 ShrPcMonitor 47984 4294967295 12 99 2
1 875666171 ShrPcMonitor 47984 42949
''';
      final dm = DataManager();
      await dm.loadFromBytes(Uint8List.fromList(utf8.encode(v2)));

      final process = dm.allProcesses.single;
      expect(process.processId, 47984);
      expect(process.sessionId, isNull);
      expect(process.samples, 2);
      expect(process.statisticData.keys, ['DataPageReads', 'BitmapPageReads']);
      expect(
        process.statisticData['DataPageReads']!.points.map((p) => p.value),
        [10, 12],
      );
      expect(
        process.statisticData['BitmapPageReads']!.points.map((p) => p.value),
        [1, 2],
      );
    },
  );

  test('a last line cut short anywhere is skipped', () async {
    // Type 2 has no statistics, so its lines are only the leading fields.
    const header = '''
STATMON "4"
StatTypes = [
Shrpc  ( StatTypeNum Time ProcessName ProcessId SessionId CacheSerialNum DataPageReads ) 1 ,
AppStat  ( StatTypeNum Time ProcessName ProcessId SessionId ) 2
]
ENDHEADER
1 1771546154 ShrPcMonitor 18322 -1 0 10
2 1771546154 app 7 3
''';
    for (final last in [
      '1 1771546155 ShrPcMonitor 18322 -1 0 12',
      '2 1771546155 app 7 3',
    ]) {
      // Cut after each whole field, short of the complete line.
      final fields = last.split(' ');
      for (var n = 1; n < fields.length; n++) {
        final cut = fields.take(n).join(' ');
        final dm = DataManager();
        await dm.loadFromBytes(Uint8List.fromList(utf8.encode('$header$cut')));
        expect(dm.allProcesses.map((p) => p.samples), [
          1,
          1,
        ], reason: 'last line "$cut"');
      }
    }
  });

  test('loads a gzipped file statmonitor is still writing', () async {
    // Until statmonitor stops, its file lacks the gzip trailer. zlib (on
    // native platforms) and the web's decompressor must both still read it.
    final unfinished = gzipped.sublist(0, gzipped.length - 8);
    final dm = DataManager();
    await dm.loadFromStream(
      Stream.value(unfinished),
      length: unfinished.length,
    );

    final process = dm.allProcesses.single;
    expect(process.samples, 3);
    expect(process.statisticData['DataPageReads']!.points.map((p) => p.value), [
      10,
      12,
      15,
    ]);
  });

  test(
    'loadFromStream gives up early on a large file with no header',
    () async {
      // 64 MB of lines that never reach ENDHEADER.
      final line = Uint8List.fromList(utf8.encode('${'x' * 1023}\n'));
      final chunks = Stream.fromIterable(List.filled(64 * 1024, line));
      await expectLater(
        DataManager().loadFromStream(chunks),
        throwsA(isA<FormatException>()),
      );
    },
  );

  test('loadFromBytes rejects a file without ENDHEADER', () {
    expect(
      DataManager().loadFromBytes(Uint8List.fromList(utf8.encode('nope'))),
      throwsA(isA<FormatException>()),
    );
  });
}
