import 'package:anthropic_sdk_dart/anthropic_sdk_dart.dart' as anthropic;
import 'package:vsd/features/ai_assistant/domain/aws/aws_sso_config.dart';
import 'package:vsd/features/ai_assistant/domain/aws/aws_sso_session.dart';
import 'package:vsd/features/ai_assistant/domain/aws/bedrock_http_client.dart';

/// Which provider the assistant reaches Claude through.
enum AiAuthMode {
  /// Claude on Amazon Bedrock, via AWS IAM Identity Center (AWS SSO).
  bedrock,

  /// Anthropic's own API, via an `sk-ant-…` key.
  anthropicApiKey;

  /// Short label for the provider picker.
  String get label => switch (this) {
    AiAuthMode.bedrock => 'AWS Bedrock',
    AiAuthMode.anthropicApiKey => 'API key',
  };

  static AiAuthMode fromName(String? name) =>
      AiAuthMode.values.firstWhere((m) => m.name == name, orElse: () => AiAuthMode.bedrock);
}

/// A configured way of reaching Claude.
///
/// Exists so [AiService] is indifferent to whether requests are signed with
/// AWS credentials or carry an Anthropic API key — the two providers differ in
/// transport, auth, and model-ID dialect, and nothing else.
sealed class AiBackend {
  const AiBackend();

  /// Model ID in the dialect this provider expects.
  String get modelId;

  /// Message to show when the provider rejects our credentials.
  String get authErrorMessage;

  /// Builds the SDK client for this provider.
  anthropic.AnthropicClient createClient();

  /// Releases anything [createClient] did not hand over to the SDK.
  void dispose();
}

/// Reaches Claude on Bedrock, signing every request with SSO credentials.
class BedrockAiBackend extends AiBackend {
  BedrockAiBackend({required AwsSsoConfig config, required AwsSsoSession session})
    : modelId = config.modelId,
      _httpClient = BedrockHttpClient(session: session, region: config.bedrockRegion);

  final BedrockHttpClient _httpClient;

  @override
  final String modelId;

  @override
  String get authErrorMessage => 'AWS credentials were rejected. Please sign in again.';

  @override
  anthropic.AnthropicClient createClient() => anthropic.AnthropicClient(
    // No key: _httpClient authenticates each request itself.
    config: const anthropic.AnthropicConfig(authProvider: anthropic.NoAuthProvider()),
    httpClient: _httpClient,
  );

  @override
  void dispose() => _httpClient.close();
}

/// Reaches Anthropic's API directly with a user-supplied key.
class AnthropicApiKeyBackend extends AiBackend {
  AnthropicApiKeyBackend({required String apiKey, this.modelId = defaultModelId}) : _apiKey = apiKey.trim() {
    if (_apiKey.isEmpty) {
      throw StateError('API key is empty.');
    }
  }

  /// First-party model IDs carry no provider prefix, unlike Bedrock's.
  static const String defaultModelId = 'claude-sonnet-5-5';

  final String _apiKey;

  @override
  final String modelId;

  @override
  String get authErrorMessage => 'Invalid or unauthorized API key.';

  @override
  anthropic.AnthropicClient createClient() => anthropic.AnthropicClient(
    config: anthropic.AnthropicConfig(authProvider: anthropic.ApiKeyProvider(_apiKey)),
  );

  @override
  void dispose() {
    // The SDK created its own HTTP client here, and closes it itself.
  }
}
