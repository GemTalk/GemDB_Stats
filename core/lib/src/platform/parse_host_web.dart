import 'dart:js_interop';
import 'dart:typed_data';

import 'package:web/web.dart' as web;

/// Web implementation of the parse host: there is no file system, gzip uses
/// the browser's native DecompressionStream, and the parse runs on the main
/// thread. The parser yields now and then so the UI can still paint progress.

({Stream<List<int>> bytes, int? length}) Function() fileSource(String path) =>
    throw UnsupportedError(
      'Loading from a path is not supported on the web; use loadFromStream.',
    );

Stream<List<int>> gunzip(Stream<List<int>> input) async* {
  final decompressor = web.DecompressionStream('gzip');
  final writer = decompressor.writable.getWriter();
  final reader =
      decompressor.readable.getReader() as web.ReadableStreamDefaultReader;

  // Feed the input in while the output is read below. Writes aren't awaited:
  // each one settles only once its output has been read.
  Object? inputError;
  final feeding = () async {
    try {
      await for (final chunk in input) {
        await writer.ready.toDart;
        final bytes = chunk is Uint8List ? chunk : Uint8List.fromList(chunk);
        writer.write(bytes.toJS).toDart.ignore();
      }
      await writer.close().toDart;
    } catch (e) {
      // A failed read of the input; aborting makes the reader below fail too.
      inputError ??= e;
      writer.abort().toDart.ignore();
    }
  }();

  while (true) {
    final web.ReadableStreamReadResult result;
    try {
      result = await reader.read().toDart;
    } catch (e) {
      if (inputError != null) {
        throw inputError!;
      }
      throw FormatException('Not a valid gzip file: $e');
    }
    if (result.done) {
      break;
    }
    yield (result.value as JSUint8Array).toDart;
  }
  await feeding;
}

Future<T> runParse<T>(
  Future<T> Function(void Function(double) progress) job, {
  void Function(double)? onProgress,
}) {
  return job(onProgress ?? (_) {});
}
