import 'package:flutter_test/flutter_test.dart';
import 'package:vsd/embed/embed_protocol.dart';

void main() {
  final page = Uri.parse('https://gemtalk.github.io/GemDB_Stats/');

  group('fileRequestFromQuery', () {
    test('resolves ?file= against the page and names it from the path', () {
      final request = fileRequestFromQuery(
        page.replace(queryParameters: {'file': 'data/statmon%20one.out.gz'}),
      );
      expect(
        request?.url,
        Uri.parse('https://gemtalk.github.io/GemDB_Stats/data/statmon%20one.out.gz'),
      );
      expect(request?.name, 'statmon one.out.gz');
    });

    test('takes an absolute URL and an explicit name', () {
      final request = fileRequestFromQuery(
        page.replace(queryParameters: {'file': 'https://example.com/a/b.out', 'name': 'Production'}),
      );
      expect(request?.url, Uri.parse('https://example.com/a/b.out'));
      expect(request?.name, 'Production');
    });

    test('is null without ?file=', () {
      expect(fileRequestFromQuery(page), isNull);
      expect(fileRequestFromQuery(page.replace(queryParameters: {'file': ''})), isNull);
    });
  });

  group('fileRequestFromMessage', () {
    test('reads an open message', () {
      final request = fileRequestFromMessage({
        'type': 'open',
        'url': 'https://file+.vscode-resource.vscode-cdn.net/home/me/statmon.out.gz',
        'name': 'statmon.out.gz',
      }, page);
      expect(request?.url.host, 'file+.vscode-resource.vscode-cdn.net');
      expect(request?.name, 'statmon.out.gz');
    });

    test('names the file from its URL when the message does not', () {
      expect(
        fileRequestFromMessage({'type': 'open', 'url': '/x/y.out'}, page)?.name,
        'y.out',
      );
    });

    test('ignores other messages', () {
      expect(fileRequestFromMessage({'type': 'theme'}, page), isNull);
      expect(fileRequestFromMessage({'type': 'open'}, page), isNull);
      expect(fileRequestFromMessage({'type': 'open', 'url': 42}, page), isNull);
      expect(fileRequestFromMessage('open', page), isNull);
      expect(fileRequestFromMessage(null, page), isNull);
    });
  });
}
