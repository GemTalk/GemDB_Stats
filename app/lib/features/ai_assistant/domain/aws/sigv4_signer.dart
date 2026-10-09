import 'dart:convert';

import 'package:crypto/crypto.dart';
import 'package:vsd/features/ai_assistant/domain/aws/aws_credentials.dart';

/// Signs requests with AWS Signature Version 4.
///
/// Only the narrow case this app needs is implemented: a POST with a fully
/// buffered body, no query string, and the minimum signed-header set
/// (`host`, `x-amz-date`, `x-amz-security-token`). Keeping the signed set
/// minimal matters — every signed header has to be reproduced byte-for-byte
/// on the wire, so headers the HTTP stack may rewrite (such as
/// `content-length`) are deliberately left out.
class SigV4Signer {
  const SigV4Signer({required this.region, required this.service});

  final String region;
  final String service;

  static const _algorithm = 'AWS4-HMAC-SHA256';

  /// Returns the headers to add to the request so it is accepted by AWS.
  ///
  /// [uri] must already be percent-encoded: its `path` is used verbatim as the
  /// canonical URI, so encoding it again here would produce a signature over a
  /// different path than the one actually requested.
  Map<String, String> sign({
    required String method,
    required Uri uri,
    required List<int> body,
    required AwsCredentials credentials,
    DateTime? now,
  }) {
    final timestamp = (now ?? DateTime.now()).toUtc();
    final amzDate = _amzDate(timestamp);
    final dateStamp = amzDate.substring(0, 8);

    // ── Canonical request ────────────────────────────────────────────────────
    final headersToSign = <String, String>{
      'host': uri.host,
      'x-amz-date': amzDate,
      'x-amz-security-token': credentials.sessionToken,
    };
    final sortedNames = headersToSign.keys.toList()..sort();
    final canonicalHeaders = sortedNames.map((name) => '$name:${headersToSign[name]!.trim()}\n').join();
    final signedHeaders = sortedNames.join(';');
    final payloadHash = sha256.convert(body).toString();

    final canonicalRequest = [
      method,
      uri.path,
      '', // canonical query string — always empty for these calls
      canonicalHeaders,
      signedHeaders,
      payloadHash,
    ].join('\n');

    // ── String to sign ───────────────────────────────────────────────────────
    final scope = '$dateStamp/$region/$service/aws4_request';
    final stringToSign = [
      _algorithm,
      amzDate,
      scope,
      sha256.convert(utf8.encode(canonicalRequest)).toString(),
    ].join('\n');

    // ── Signature ────────────────────────────────────────────────────────────
    final signature = _hex(
      _hmac(_signingKey(credentials.secretAccessKey, dateStamp), utf8.encode(stringToSign)),
    );

    return {
      'authorization':
          '$_algorithm Credential=${credentials.accessKeyId}/$scope, '
          'SignedHeaders=$signedHeaders, Signature=$signature',
      'x-amz-date': amzDate,
      'x-amz-security-token': credentials.sessionToken,
    };
  }

  List<int> _signingKey(String secretAccessKey, String dateStamp) {
    // Explicitly List<int>: utf8.encode returns a Uint8List, which _hmac's
    // return value could not then be assigned back into.
    List<int> key = utf8.encode('AWS4$secretAccessKey');
    for (final part in [dateStamp, region, service, 'aws4_request']) {
      key = _hmac(key, utf8.encode(part));
    }
    return key;
  }

  List<int> _hmac(List<int> key, List<int> data) => Hmac(sha256, key).convert(data).bytes;

  String _hex(List<int> bytes) => bytes.map((b) => b.toRadixString(16).padLeft(2, '0')).join();

  /// Formats a timestamp as `YYYYMMDDTHHMMSSZ`.
  String _amzDate(DateTime utc) {
    String p(int v, [int width = 2]) => v.toString().padLeft(width, '0');
    return '${p(utc.year, 4)}${p(utc.month)}${p(utc.day)}T'
        '${p(utc.hour)}${p(utc.minute)}${p(utc.second)}Z';
  }
}
