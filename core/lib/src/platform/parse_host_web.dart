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

/// Decompresses [input]. Like zlib, a stream that stops before its end, as a
/// statmon file does while statmonitor is still writing it, yields everything
/// decoded so far rather than failing.
Stream<List<int>> gunzip(Stream<List<int>> input) async* {
  final decompressor = web.DecompressionStream('gzip');
  final writer = decompressor.writable.getWriter();
  final reader =
      decompressor.readable.getReader() as web.ReadableStreamDefaultReader;

  // A read is waiting on an empty queue: everything decoded so far is read.
  var reading = false;
  // Output reading has stopped, done or not.
  var stopped = false;
  // close() has been called: from here, an error means the stream had no end.
  var closing = false;
  Object? inputError;

  // Feed the input in while the output is read below. Writes aren't awaited
  // one by one: with nothing reading, the next one would wait forever.
  final feeding = () async {
    Future<void>? lastWrite;
    try {
      await for (final chunk in input) {
        await writer.ready.toDart;
        final bytes = chunk is Uint8List ? chunk : Uint8List.fromList(chunk);
        lastWrite = writer.write(bytes.toJS).toDart..ignore();
      }
    } catch (e) {
      // A failed read of the input; aborting makes the reader below fail too.
      inputError ??= e;
      writer.abort().toDart.ignore();
      return;
    }
    try {
      // Every chunk has been decoded, so all the output there will be is
      // queued. Bad data has already failed here, and the reader reports it.
      await lastWrite;
    } catch (_) {
      return;
    }
    // close() on a stream with no end fails, and drops any output still
    // queued, so close only once the reader has taken all of it. A read
    // still waiting a task later is waiting on an empty queue.
    do {
      await Future<void>.delayed(Duration.zero);
    } while (!reading && !stopped);
    closing = true;
    try {
      await writer.close().toDart;
    } catch (_) {
      // The stream had no end; the reader ends without error.
    }
  }();

  var done = false;
  try {
    while (true) {
      final web.ReadableStreamReadResult result;
      try {
        reading = true;
        result = await reader.read().toDart;
      } catch (e) {
        if (inputError != null) {
          throw inputError!;
        }
        if (closing) {
          // Everything decoded was read before closing.
          done = true;
          break;
        }
        throw FormatException('Not a valid gzip file: $e');
      } finally {
        reading = false;
      }
      if (result.done) {
        done = true;
        break;
      }
      yield (result.value as JSUint8Array).toDart;
    }
  } finally {
    stopped = true;
    // Stopped early, as when the file is rejected. Cancelling the output
    // fails the next write, which ends the feeding and so the input.
    if (!done) {
      reader.cancel().toDart.ignore();
    }
  }
  await feeding;
}

Future<T> runParse<T>(
  Future<T> Function(void Function(double) progress) job, {
  void Function(double)? onProgress,
}) {
  return job(onProgress ?? (_) {});
}
