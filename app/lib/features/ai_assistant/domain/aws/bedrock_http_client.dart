import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:vsd/features/ai_assistant/domain/aws/aws_event_stream.dart';
import 'package:vsd/features/ai_assistant/domain/aws/aws_sso_session.dart';
import 'package:vsd/features/ai_assistant/domain/aws/sigv4_signer.dart';

/// Makes the Anthropic SDK talk to Bedrock by rewriting requests in transit.
///
/// Bedrock's `InvokeModel` carries the *same* Messages API body as the
/// first-party API, with three differences:
///
/// 1. the model moves out of the body and into the URL path;
/// 2. the body gains `anthropic_version: bedrock-2023-05-31`;
/// 3. streaming responses use AWS event-stream framing instead of SSE.
///
/// Handling all three in an `http.Client` means the SDK's request models,
/// response parsing, and stream accumulator are reused verbatim, and
/// [AiService] does not need to know Bedrock exists. A custom client is also
/// the only viable seam: the SDK applies auth to streaming requests itself and
/// sends them straight to `httpClient.send`, bypassing its interceptor chain,
/// and its `AuthProvider` can only contribute a static key — never a
/// per-request signature.
class BedrockHttpClient extends http.BaseClient {
  BedrockHttpClient({
    required AwsSsoSession session,
    required String region,
    http.Client? inner,
  }) : _session = session,
       _signer = SigV4Signer(region: region, service: _service),
       _region = region,
       _inner = inner ?? http.Client(),
       _ownsInner = inner == null;

  final AwsSsoSession _session;
  final SigV4Signer _signer;
  final String _region;
  final http.Client _inner;
  final bool _ownsInner;

  /// Signing name of the Bedrock data plane.
  static const _service = 'bedrock';

  /// Required by Bedrock in place of the `anthropic-version` header.
  static const _anthropicVersion = 'bedrock-2023-05-31';

  @override
  Future<http.StreamedResponse> send(http.BaseRequest request) async {
    if (!request.url.path.endsWith('/v1/messages')) {
      // Batches, Models, Files and token counting have no Bedrock equivalent.
      throw UnsupportedError(
        'Claude on Bedrock exposes only the Messages API; '
        '${request.url.path} is not available.',
      );
    }

    final bodyBytes = request is http.Request ? request.bodyBytes : await request.finalize().toBytes();
    final payload = jsonDecode(utf8.decode(bodyBytes)) as Map<String, dynamic>;

    // Bedrock infers streaming from the operation, not a body field.
    final isStreaming = payload.remove('stream') == true;
    final model = payload.remove('model');
    if (model is! String || model.isEmpty) {
      throw ArgumentError('Request is missing a model ID.');
    }
    payload['anthropic_version'] = _anthropicVersion;

    final operation = isStreaming ? 'invoke-with-response-stream' : 'invoke';
    // Encoded here because some Bedrock model IDs contain a colon, and the
    // signature is computed over this exact path.
    final uri = Uri.parse(
      'https://bedrock-runtime.$_region.amazonaws.com'
      '/model/${Uri.encodeComponent(model)}/$operation',
    );

    final signedBody = utf8.encode(jsonEncode(payload));
    final credentials = await _session.credentials();

    final outbound = http.Request('POST', uri)
      ..bodyBytes = signedBody
      ..headers['content-type'] = 'application/json'
      ..headers.addAll(
        _signer.sign(
          method: 'POST',
          uri: uri,
          body: signedBody,
          credentials: credentials,
        ),
      );

    final response = await _inner.send(outbound);

    // Let the SDK read and classify error bodies as it normally would.
    if (isStreaming && response.statusCode < 400) {
      return http.StreamedResponse(
        awsEventStreamToSse(response.stream),
        response.statusCode,
        // Deliberately not forwarding the upstream headers: re-framing changes
        // the body length, so the original `content-length` would be wrong.
        headers: const {'content-type': 'text/event-stream'},
        request: outbound,
        reasonPhrase: response.reasonPhrase,
      );
    }

    return response;
  }

  @override
  void close() {
    if (_ownsInner) {
      _inner.close();
    }
    super.close();
  }
}
