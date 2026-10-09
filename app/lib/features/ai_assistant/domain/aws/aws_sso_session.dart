import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:vsd/features/ai_assistant/domain/aws/aws_credentials.dart';
import 'package:vsd/features/ai_assistant/domain/aws/aws_sso_config.dart';
import 'package:vsd/features/ai_assistant/domain/aws/aws_sso_token_store.dart';

/// Thrown when no valid SSO access token is held, so the user must sign in.
class AwsSsoLoginRequired implements Exception {
  const AwsSsoLoginRequired([this.message = 'AWS SSO sign-in required.']);

  final String message;

  @override
  String toString() => message;
}

/// Thrown when an SSO or credential call fails outright.
class AwsSsoException implements Exception {
  const AwsSsoException(this.message);

  final String message;

  @override
  String toString() => message;
}

/// A pending device authorization the user has to approve in a browser.
class AwsSsoDeviceAuthorization {
  const AwsSsoDeviceAuthorization({
    required this.clientId,
    required this.clientSecret,
    required this.deviceCode,
    required this.userCode,
    required this.verificationUri,
    required this.verificationUriComplete,
    required this.interval,
    required this.expiresAt,
  });

  final String clientId;
  final String clientSecret;
  final String deviceCode;

  /// Short code the user confirms matches what the browser shows.
  final String userCode;

  final String verificationUri;

  /// Verification URL with [userCode] pre-filled — what to actually open.
  final String verificationUriComplete;

  /// How often the token endpoint permits polling.
  final Duration interval;

  /// When this authorization stops being approvable.
  final DateTime expiresAt;
}

/// Signs in to AWS IAM Identity Center and vends Bedrock credentials.
///
/// Implements the OAuth 2.0 device authorization flow by hand, which is what
/// `aws sso login` does. Doing it in-process is deliberate: on macOS the app is
/// sandboxed, so it can neither read the AWS CLI's SSO token cache nor execute
/// the CLI — and on no platform should it require the CLI to be installed.
/// Every call below is plain HTTPS needing no AWS signing; only the final
/// Bedrock request is signed.
///
/// The flow is: register a client, start a device authorization, let the user
/// approve it in a browser, exchange the device code for an access token
/// (~8h), then trade that token for role credentials (~1h) as needed.
class AwsSsoSession {
  AwsSsoSession({
    required AwsSsoConfig config,
    AwsSsoTokenStore store = const SharedPreferencesSsoTokenStore(),
    http.Client? httpClient,
  }) : _config = config,
       _store = store,
       _http = httpClient ?? http.Client(),
       _ownsHttpClient = httpClient == null;

  final AwsSsoConfig _config;
  final AwsSsoTokenStore _store;
  final http.Client _http;
  final bool _ownsHttpClient;

  /// Role credentials are short-lived and re-fetchable, so they stay in memory.
  AwsCredentials? _cachedCredentials;

  void dispose() {
    if (_ownsHttpClient) {
      _http.close();
    }
  }

  String get _oidcBase => 'https://oidc.${_config.ssoRegion}.amazonaws.com';

  String get _portalBase => 'https://portal.sso.${_config.ssoRegion}.amazonaws.com';

  // ------- Sign-in -------

  /// Registers a client and starts a device authorization.
  ///
  /// The returned [AwsSsoDeviceAuthorization] must be shown to the user and
  /// then passed to [waitForApproval].
  Future<AwsSsoDeviceAuthorization> beginLogin() async {
    final (clientId, clientSecret) = await _registerClient();

    final body = await _postJson('$_oidcBase/device_authorization', {
      'clientId': clientId,
      'clientSecret': clientSecret,
      'startUrl': _config.startUrl.trim(),
    });

    final expiresIn = (body['expiresIn'] as num?)?.toInt() ?? 600;
    final interval = (body['interval'] as num?)?.toInt() ?? 5;

    return AwsSsoDeviceAuthorization(
      clientId: clientId,
      clientSecret: clientSecret,
      deviceCode: body['deviceCode'] as String,
      userCode: body['userCode'] as String,
      verificationUri: body['verificationUri'] as String? ?? '',
      verificationUriComplete: body['verificationUriComplete'] as String? ?? '',
      // Poll no faster than once a second even if the server says 0.
      interval: Duration(seconds: interval < 1 ? 1 : interval),
      expiresAt: DateTime.now().toUtc().add(Duration(seconds: expiresIn)),
    );
  }

  /// Polls until the user approves [auth], then persists the access token.
  Future<void> waitForApproval(AwsSsoDeviceAuthorization auth) async {
    var interval = auth.interval;

    while (true) {
      if (DateTime.now().toUtc().isAfter(auth.expiresAt)) {
        throw const AwsSsoException('Sign-in request expired before it was approved.');
      }

      await Future<void>.delayed(interval);

      final response = await _http.post(
        Uri.parse('$_oidcBase/token'),
        headers: const {'content-type': 'application/json'},
        body: jsonEncode({
          'clientId': auth.clientId,
          'clientSecret': auth.clientSecret,
          'deviceCode': auth.deviceCode,
          'grantType': 'urn:ietf:params:oauth:grant-type:device_code',
        }),
      );

      final body = _decodeBody(response.body);

      if (response.statusCode == 200) {
        final token = body['accessToken'] as String?;
        if (token == null) {
          throw const AwsSsoException('AWS SSO returned no access token.');
        }
        final expiresIn = (body['expiresIn'] as num?)?.toInt() ?? 3600;
        await _store.write({
          'clientId': auth.clientId,
          'clientSecret': auth.clientSecret,
          'accessToken': token,
          'accessTokenExpiresAt': DateTime.now().toUtc().add(Duration(seconds: expiresIn)).toIso8601String(),
        });
        _cachedCredentials = null;
        return;
      }

      switch (body['error']) {
        case 'authorization_pending':
          continue; // Still waiting on the browser.
        case 'slow_down':
          interval += const Duration(seconds: 5);
          continue;
        case 'expired_token':
          throw const AwsSsoException('Sign-in request expired before it was approved.');
        case 'access_denied':
          throw const AwsSsoException('Sign-in was denied.');
        default:
          throw AwsSsoException(_errorMessage(body, response.statusCode));
      }
    }
  }

  /// Whether a usable access token is already held, so sign-in can be skipped.
  Future<bool> hasValidToken() async => (await _accessToken()) != null;

  // ------- Credentials -------

  /// Returns credentials for the configured account and role.
  ///
  /// Throws [AwsSsoLoginRequired] when the access token is absent or expired.
  Future<AwsCredentials> credentials() async {
    final cached = _cachedCredentials;
    if (cached != null && cached.isUsable) {
      return cached;
    }

    final token = await _accessToken();
    if (token == null) {
      throw const AwsSsoLoginRequired();
    }

    final uri = Uri.parse('$_portalBase/federation/credentials').replace(
      queryParameters: {
        'account_id': _config.accountId.trim(),
        'role_name': _config.roleName.trim(),
      },
    );

    final response = await _http.get(uri, headers: {'x-amz-sso_bearer_token': token});

    if (response.statusCode == 401 || response.statusCode == 403) {
      // The access token has been revoked or has aged out server-side.
      await _store.clear();
      throw const AwsSsoLoginRequired('AWS SSO session expired. Please sign in again.');
    }
    if (response.statusCode != 200) {
      final body = _decodeBody(response.body);
      throw AwsSsoException(
        'Could not get credentials for role "${_config.roleName}" in account '
        '"${_config.accountId}": ${_errorMessage(body, response.statusCode)}',
      );
    }

    final roleCredentials = _decodeBody(response.body)['roleCredentials'];
    if (roleCredentials is! Map<String, dynamic>) {
      throw const AwsSsoException('AWS SSO returned malformed role credentials.');
    }

    final credentials = AwsCredentials(
      accessKeyId: roleCredentials['accessKeyId'] as String,
      secretAccessKey: roleCredentials['secretAccessKey'] as String,
      sessionToken: roleCredentials['sessionToken'] as String,
      // `expiration` is epoch milliseconds.
      expiresAt: DateTime.fromMillisecondsSinceEpoch(
        (roleCredentials['expiration'] as num).toInt(),
        isUtc: true,
      ),
    );
    _cachedCredentials = credentials;
    return credentials;
  }

  // ------- Private helpers -------

  /// Returns a stored, unexpired access token, or null.
  Future<String?> _accessToken() async {
    final stored = await _store.read();
    final token = stored?['accessToken'] as String?;
    final expiresAtRaw = stored?['accessTokenExpiresAt'] as String?;
    if (token == null || token.isEmpty || expiresAtRaw == null) {
      return null;
    }
    final expiresAt = DateTime.tryParse(expiresAtRaw);
    if (expiresAt == null || DateTime.now().toUtc().isAfter(expiresAt.subtract(const Duration(minutes: 1)))) {
      return null;
    }
    return token;
  }

  /// Reuses a stored client registration when possible — registering on every
  /// sign-in works but needlessly creates a new client each time.
  Future<(String, String)> _registerClient() async {
    final stored = await _store.read();
    final clientId = stored?['clientId'] as String?;
    final clientSecret = stored?['clientSecret'] as String?;
    if (clientId != null && clientId.isNotEmpty && clientSecret != null && clientSecret.isNotEmpty) {
      return (clientId, clientSecret);
    }

    final body = await _postJson('$_oidcBase/client/register', const {
      'clientName': 'GemDB Stats',
      'clientType': 'public',
      'scopes': ['sso:account:access'],
    });
    return (body['clientId'] as String, body['clientSecret'] as String);
  }

  Future<Map<String, dynamic>> _postJson(String url, Map<String, dynamic> payload) async {
    final response = await _http.post(
      Uri.parse(url),
      headers: const {'content-type': 'application/json'},
      body: jsonEncode(payload),
    );
    final body = _decodeBody(response.body);
    if (response.statusCode != 200) {
      throw AwsSsoException(_errorMessage(body, response.statusCode));
    }
    return body;
  }

  Map<String, dynamic> _decodeBody(String body) {
    if (body.isEmpty) {
      return const {};
    }
    try {
      final decoded = jsonDecode(body);
      return decoded is Map<String, dynamic> ? decoded : const {};
    } on FormatException {
      return const {};
    }
  }

  String _errorMessage(Map<String, dynamic> body, int statusCode) {
    final description = body['error_description'] ?? body['message'] ?? body['error'];
    return description is String && description.isNotEmpty ? description : 'AWS SSO request failed (HTTP $statusCode).';
  }
}
