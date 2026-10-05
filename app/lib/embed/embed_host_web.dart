import 'dart:async';
import 'dart:js_interop';
import 'dart:js_interop_unsafe';

import 'package:vsd/embed/embed_protocol.dart';
import 'package:web/web.dart' as web;

/// The web page's side of the embedding protocol (docs/embedding.md). In a
/// VS Code webview, messages go to the extension through the VS Code API;
/// anywhere else, only `?file=` applies.

// acquireVsCodeApi may be called only once per page.
final JSObject? _vscode = globalContext.has('acquireVsCodeApi')
    ? globalContext.callMethod<JSObject>('acquireVsCodeApi'.toJS)
    : null;

/// Whether a host page (a VS Code webview) decides which file is shown.
bool get isEmbedded => _vscode != null;

/// The file the page's own URL asks for, if any. Embedded, only the host
/// chooses the file.
FileRequest? get initialFileRequest => isEmbedded ? null : fileRequestFromQuery(Uri.base);

/// Files the host asks to open. Listen before calling [notifyReady].
final Stream<FileRequest> fileRequests = _listenForRequests();

Stream<FileRequest> _listenForRequests() {
  final requests = StreamController<FileRequest>.broadcast();
  if (_vscode != null) {
    web.window.addEventListener(
      'message',
      (web.MessageEvent event) {
        final request = fileRequestFromMessage(event.data.dartify(), Uri.base);
        if (request != null) {
          requests.add(request);
        }
      }.toJS,
    );
  }
  return requests.stream;
}

/// Tells the host the app is listening for `open` messages.
void notifyReady() => _post(readyMessage);

/// Asks the host to let the user pick a file, which it then sends as `open`.
void requestFile() => _post(pickFileMessage);

void _post(Map<String, Object?> message) => _vscode?.callMethod<JSAny?>('postMessage'.toJS, message.jsify());

/// Streams the file at [url]. [length] is its size when the server says.
Future<({Stream<List<int>> bytes, int? length})> openUrl(Uri url) async {
  final web.Response response;
  try {
    response = await web.window.fetch(url.toString().toJS).toDart;
  } catch (e) {
    throw FetchException('Could not read $url: $e');
  }
  final body = response.body;
  if (!response.ok || body == null) {
    throw FetchException(
      'Could not read $url: ${response.status} ${response.statusText}',
    );
  }
  final reader = body.getReader() as web.ReadableStreamDefaultReader;
  Stream<List<int>> read() async* {
    var done = false;
    try {
      while (true) {
        final chunk = await reader.read().toDart;
        if (chunk.done) {
          done = true;
          break;
        }
        yield (chunk.value as JSUint8Array).toDart;
      }
    } finally {
      // Stopped early, as when the file is rejected: stop the download too.
      if (!done) {
        reader.cancel().toDart.ignore();
      }
    }
  }

  return (
    bytes: read(),
    length: int.tryParse(response.headers.get('content-length') ?? ''),
  );
}
