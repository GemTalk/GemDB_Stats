/// Everything needed to reach Claude on Bedrock through IAM Identity Center.
///
/// The first four are the same values an AWS CLI SSO profile holds
/// (`sso_start_url`, `sso_region`, `sso_account_id`, `sso_role_name`), plus the
/// Bedrock region and model.
///
/// The user supplies them once and they are persisted, rather than being read
/// from the AWS CLI's config file. On macOS that is forced: the app is
/// sandboxed and cannot reach it (see `macos/Runner/Release.entitlements`).
/// Windows and Linux builds could read it, but deliberately do not — one code
/// path everywhere, and no dependency on the AWS CLI being installed at all.
class AwsSsoConfig {
  const AwsSsoConfig({
    required this.startUrl,
    required this.ssoRegion,
    required this.accountId,
    required this.roleName,
    required this.bedrockRegion,
    this.modelId = defaultModelId,
  });

  factory AwsSsoConfig.fromJson(Map<String, dynamic> json) => AwsSsoConfig(
    startUrl: json['startUrl'] as String? ?? '',
    ssoRegion: json['ssoRegion'] as String? ?? '',
    accountId: json['accountId'] as String? ?? '',
    roleName: json['roleName'] as String? ?? '',
    bedrockRegion: json['bedrockRegion'] as String? ?? '',
    modelId: json['modelId'] as String? ?? defaultModelId,
  );

  /// Bedrock serves Claude under an `anthropic.` provider prefix, and newer
  /// models are reachable only through a cross-region inference profile — the
  /// leading `eu.` here. Change the prefix if [bedrockRegion] leaves the EU.
  static const String defaultModelId = 'eu.anthropic.claude-sonnet-5-5';

  /// e.g. `https://my-org.awsapps.com/start/`
  final String startUrl;

  /// Region the Identity Center directory lives in, e.g. `eu-central-1`.
  final String ssoRegion;

  /// 12-digit AWS account ID holding the Bedrock access.
  final String accountId;

  /// Permission-set role to assume, e.g. `MyBedrockRole`.
  final String roleName;

  /// Region to call `bedrock-runtime` in.
  final String bedrockRegion;

  /// Bedrock model ID, including provider and inference-profile prefixes.
  final String modelId;

  bool get isComplete =>
      startUrl.trim().isNotEmpty &&
      ssoRegion.trim().isNotEmpty &&
      accountId.trim().isNotEmpty &&
      roleName.trim().isNotEmpty &&
      bedrockRegion.trim().isNotEmpty &&
      modelId.trim().isNotEmpty;

  Map<String, dynamic> toJson() => {
    'startUrl': startUrl,
    'ssoRegion': ssoRegion,
    'accountId': accountId,
    'roleName': roleName,
    'bedrockRegion': bedrockRegion,
    'modelId': modelId,
  };
}
