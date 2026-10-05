/// How a page that embeds GemDB Stats, such as a VS Code webview, tells it
/// which file to show. See docs/embedding.md.
library;

/// A file to fetch from [url] and show as [name].
typedef FileRequest = ({Uri url, String name});

/// Sent to the host once the app listens for `open` messages.
const readyMessage = {'type': 'ready'};

/// Sent to the host when the user asks to open a file: the host, not the
/// browser, has the files.
const pickFileMessage = {'type': 'pickFile'};

/// The file named by the page's URL: `?file=<url>`, optionally `&name=`.
/// A relative URL is resolved against [page].
FileRequest? fileRequestFromQuery(Uri page) {
  final file = page.queryParameters['file'];
  if (file == null || file.isEmpty) {
    return null;
  }
  return _request(page.resolve(file), page.queryParameters['name']);
}

/// The file in an `open` message from the host:
/// `{type: 'open', url: '<url>', name?: '<name>'}`, or null for any other
/// message.
FileRequest? fileRequestFromMessage(Object? message, Uri base) {
  if (message is! Map || message['type'] != 'open') {
    return null;
  }
  final url = message['url'];
  if (url is! String || url.isEmpty) {
    return null;
  }
  final name = message['name'];
  return _request(base.resolve(url), name is String ? name : null);
}

FileRequest _request(Uri url, String? name) => (
  url: url,
  name: name != null && name.isNotEmpty ? name : url.pathSegments.lastWhere((s) => s.isNotEmpty, orElse: () => '$url'),
);

/// A file the host asked for could not be read.
class FetchException implements Exception {
  FetchException(this.message);

  final String message;

  @override
  String toString() => message;
}
