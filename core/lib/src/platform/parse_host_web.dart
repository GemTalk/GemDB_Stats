import 'dart:typed_data';

import 'package:archive/archive.dart';

/// Web implementation of the parse host: there is no file system, gzip comes
/// from `package:archive`, and the parse runs on the main thread. The parser
/// yields between chunks so the UI can still paint progress.

Uint8List Function() fileReader(String path) => throw UnsupportedError(
  'Loading from a path is not supported on the web; use loadFromBytes.',
);

List<int> decodeGzip(List<int> bytes) => const GZipDecoder().decodeBytes(bytes);

Future<T> runParse<T>(
  Future<T> Function(void Function(double) progress) job, {
  void Function(double)? onProgress,
}) {
  return job(onProgress ?? (_) {});
}
