import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:vsd/features/ai_assistant/domain/aws/aws_credentials.dart';
import 'package:vsd/features/ai_assistant/domain/aws/sigv4_signer.dart';

void main() {
  // Fake credentials and a frozen clock, so the signature is deterministic.
  // The expected value below was produced by an independent implementation
  // that was verified against the live `bedrock-runtime` endpoint.
  final credentials = AwsCredentials(
    accessKeyId: 'ASIAIOSFODNN7EXAMPLE',
    secretAccessKey: 'wJalrXUtnFEMI/K7MDENG/bPxRfiCYEXAMPLEKEY',
    sessionToken: 'FwoGZXIvYXdzEXAMPLETOKEN',
    expiresAt: DateTime.utc(2030),
  );

  final uri = Uri.parse(
    'https://bedrock-runtime.eu-central-1.amazonaws.com'
    '/model/eu.anthropic.claude-sonnet-5-5/invoke-with-response-stream',
  );

  final body = utf8.encode(
    '{"max_tokens":16,"messages":[{"role":"user","content":"hi"}],'
    '"anthropic_version":"bedrock-2023-05-31"}',
  );

  const signer = SigV4Signer(region: 'eu-central-1', service: 'bedrock');

  Map<String, String> sign() => signer.sign(
    method: 'POST',
    uri: uri,
    body: body,
    credentials: credentials,
    now: DateTime.utc(2026, 1, 5, 12),
  );

  test('produces the expected signature for a known request', () {
    expect(
      sign()['authorization'],
      'AWS4-HMAC-SHA256 '
      'Credential=ASIAIOSFODNN7EXAMPLE/20260105/eu-central-1/bedrock/aws4_request, '
      'SignedHeaders=host;x-amz-date;x-amz-security-token, '
      'Signature=f3f337f74790b3fabcd8ff04f049cbdaf38b78b3de67e60ba689d211e256986c',
    );
  });

  test('sends the date and session token it signed over', () {
    final headers = sign();

    expect(headers['x-amz-date'], '20260105T120000Z');
    expect(headers['x-amz-security-token'], credentials.sessionToken);
  });

  test('signature covers the body', () {
    final other = signer.sign(
      method: 'POST',
      uri: uri,
      body: utf8.encode('{"max_tokens":17}'),
      credentials: credentials,
      now: DateTime.utc(2026, 1, 5, 12),
    );

    expect(other['authorization'], isNot(sign()['authorization']));
  });

  test('signature covers the path, so the model ID cannot be swapped', () {
    final other = signer.sign(
      method: 'POST',
      uri: Uri.parse(
        'https://bedrock-runtime.eu-central-1.amazonaws.com'
        '/model/eu.anthropic.claude-opus-5/invoke-with-response-stream',
      ),
      body: body,
      credentials: credentials,
      now: DateTime.utc(2026, 1, 5, 12),
    );

    expect(other['authorization'], isNot(sign()['authorization']));
  });

  test('credentials are treated as expired shortly before they lapse', () {
    final almostExpired = AwsCredentials(
      accessKeyId: 'a',
      secretAccessKey: 'b',
      sessionToken: 'c',
      expiresAt: DateTime.now().toUtc().add(const Duration(seconds: 30)),
    );
    final fresh = AwsCredentials(
      accessKeyId: 'a',
      secretAccessKey: 'b',
      sessionToken: 'c',
      expiresAt: DateTime.now().toUtc().add(const Duration(hours: 1)),
    );

    expect(almostExpired.isUsable, isFalse);
    expect(fresh.isUsable, isTrue);
  });
}
