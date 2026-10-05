import 'package:vsd/embed/embed_protocol.dart';

/// Outside the web there is no host page: files are picked locally.

bool get isEmbedded => false;

FileRequest? get initialFileRequest => null;

const Stream<FileRequest> fileRequests = Stream.empty();

void notifyReady() {}

void requestFile() {}

Future<({Stream<List<int>> bytes, int? length})> openUrl(Uri url) =>
    throw UnsupportedError('Opening a URL is only supported on the web');
