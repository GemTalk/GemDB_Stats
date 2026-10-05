@TestOn('browser')
library;

import 'dart:async';
import 'dart:math' as math;
import 'dart:typed_data';

import 'package:archive/archive.dart';
import 'package:test/test.dart';
import 'package:vsd_core/src/platform/parse_host_web.dart';

void main() {
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
