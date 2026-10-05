/// Short-lived AWS credentials, as issued by IAM Identity Center (AWS SSO).
///
/// These always carry a [sessionToken] — IAM Identity Center only ever hands
/// out temporary credentials, so there is no long-lived-key variant here.
class AwsCredentials {
  const AwsCredentials({
    required this.accessKeyId,
    required this.secretAccessKey,
    required this.sessionToken,
    required this.expiresAt,
  });

  final String accessKeyId;
  final String secretAccessKey;
  final String sessionToken;

  /// When these credentials stop being accepted (UTC).
  final DateTime expiresAt;

  /// Treated as expired a minute early so a request cannot be signed with
  /// credentials that lapse while it is still in flight.
  bool get isUsable => DateTime.now().toUtc().isBefore(expiresAt.subtract(const Duration(minutes: 1)));
}
