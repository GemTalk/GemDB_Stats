import 'dart:io';
import 'dart:isolate';
import 'dart:typed_data';

/// Native implementation of the parse host: files come from disk, gzip uses
/// `dart:io`'s zlib, and the parse runs on a background isolate.

/// Returns a reader for [path] that is safe to send to another isolate.
Uint8List Function() fileReader(String path) =>
    () => File(path).readAsBytesSync();

List<int> decodeGzip(List<int> bytes) => gzip.decode(bytes);

/// Runs [job] on a background isolate so it doesn't block the UI, forwarding
/// its progress to [onProgress]. Any error becomes a [FormatException].
Future<T> runParse<T>(
  Future<T> Function(void Function(double) progress) job, {
  void Function(double)? onProgress,
}) async {
  final receivePort = ReceivePort();
  await Isolate.spawn(_entry(job), receivePort.sendPort);
  try {
    await for (final message in receivePort) {
      if (message is double) {
        onProgress?.call(message);
      } else if (message is String) {
        throw FormatException(message);
      } else {
        return (message as _Done<T>).value;
      }
    }
    throw StateError('Parse isolate exited without a result');
  } finally {
    receivePort.close();
  }
}

// Built outside runParse's async body so the closure captures only [job],
// not the unsendable ReceivePort.
void Function(SendPort) _entry<T>(
  Future<T> Function(void Function(double) progress) job,
) {
  return (SendPort sendPort) async {
    try {
      final result = await job(sendPort.send);
      // Isolate.exit transfers ownership of the result without copying it,
      // unlike sendPort.send which deep-copies the whole object graph.
      Isolate.exit(sendPort, _Done(result));
    } catch (e) {
      sendPort.send(e is FormatException ? e.message : e.toString());
    }
  };
}

class _Done<T> {
  _Done(this.value);
  final T value;
}
