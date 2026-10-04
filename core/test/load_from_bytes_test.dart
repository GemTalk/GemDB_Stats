import 'dart:convert';
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
    test(
      'loadFromStream parses a $label file arriving in small chunks',
      () async {
        // 7-byte chunks split lines, numbers and the gzip stream mid-way.
        final chunks = [
          for (var i = 0; i < bytes.length; i += 7)
            bytes.sublist(i, i + 7 > bytes.length ? bytes.length : i + 7),
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
