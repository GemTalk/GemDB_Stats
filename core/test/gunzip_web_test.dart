@TestOn('browser')
library;

import 'dart:async';
import 'dart:convert';
import 'dart:math' as math;
import 'dart:typed_data';

import 'package:archive/archive.dart';
import 'package:test/test.dart';
import 'package:vsd_core/src/platform/parse_host_web.dart';

/// [bytes] in 4 KB chunks, as a file is read.
Stream<List<int>> _chunked(List<int> bytes) => Stream.fromIterable([
  for (var i = 0; i < bytes.length; i += 4096)
    bytes.sublist(i, math.min(i + 4096, bytes.length)),
]);

Future<List<int>> _gunzipAll(List<int> gzipped) async => [
  for (final chunk in await gunzip(_chunked(gzipped)).toList()) ...chunk,
];

void main() {
  // About 400 KB of text: several of the browser's 64 KB output blocks.
  final text = utf8.encode(
    [
      for (var i = 0; i < 6000; i++)
        '1 ${1771546154 + i} ShrPcMonitor 18322 -1 0 ${i * 7} ${i % 13} ${i * i}',
    ].join('\n'),
  );
  final gzipped = const GZipEncoder().encodeBytes(text);

  test('a complete stream decodes', () async {
    expect(await _gunzipAll(gzipped), text);
  });

  // statmonitor writes its file as it goes: until it stops, the file has no
  // gzip trailer, and its last block may be cut short.
  test('a stream with no trailer yields all of it, as zlib does', () async {
    expect(await _gunzipAll(gzipped.sublist(0, gzipped.length - 8)), text);
  });

  test('a stream cut short yields everything decoded up to the cut', () async {
    final out = await _gunzipAll(gzipped.sublist(0, gzipped.length - 200));
    expect(out, text.sublist(0, out.length), reason: 'a prefix of the text');
    // 200 compressed bytes hold far less than one 64 KB output block.
    expect(out.length, greaterThan(text.length - 16 * 1024));
  });

  test('bad data still fails', () async {
    final bad = [
      ...gzipped.sublist(0, 20),
      ...List.filled(64, 0xff),
      ...gzipped.sublist(84),
    ];
    await expectLater(_gunzipAll(bad), throwsA(isA<FormatException>()));
  });

  test('stopping early stops reading the input', () async {
    // Random bytes don't compress, so the input arrives in many chunks.
    final random = math.Random(1);
    final gzipped = const GZipEncoder().encodeBytes(
      Uint8List.fromList(List.generate(4 << 20, (_) => random.nextInt(256))),
    );
    const chunk = 64 * 1024;
    var chunksRead = 0;
    final inputStopped = Completer<bool>();
    Stream<List<int>> input() async* {
      var finished = false;
      try {
        for (var i = 0; i < gzipped.length; i += chunk) {
          chunksRead++;
          yield gzipped.sublist(i, math.min(i + chunk, gzipped.length));
        }
        finished = true;
      } finally {
        inputStopped.complete(finished);
      }
    }

    // Take the first decompressed chunk, then stop.
    await gunzip(input()).first;

    final finished = await inputStopped.future.timeout(
      const Duration(seconds: 5),
    );
    expect(finished, isFalse);
    expect(chunksRead, lessThan(gzipped.length ~/ chunk));
  });
}
