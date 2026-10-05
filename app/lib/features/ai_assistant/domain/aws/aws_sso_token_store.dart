import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

/// Persists the SSO client registration and access token between launches.
///
/// Kept behind an interface so [AwsSsoSession] can be exercised in tests
/// without touching platform storage.
abstract interface class AwsSsoTokenStore {
  Future<Map<String, dynamic>?> read();

  Future<void> write(Map<String, dynamic> value);

  Future<void> clear();
}

/// [AwsSsoTokenStore] backed by `SharedPreferences`.
///
/// Note that `SharedPreferences` is **not** encrypted. What is stored here is
/// a bearer token that expires on its own (typically within hours) rather than
/// the indefinitely valid API key this replaced, so the exposure window is far
/// smaller — but moving this to the platform keychain is still worthwhile.
class SharedPreferencesSsoTokenStore implements AwsSsoTokenStore {
  const SharedPreferencesSsoTokenStore();

  static const _prefKey = 'aws_sso_session';

  @override
  Future<Map<String, dynamic>?> read() async {
    final prefs = await SharedPreferences.getInstance();
    final raw = prefs.getString(_prefKey);
    if (raw == null || raw.isEmpty) {
      return null;
    }
    final decoded = jsonDecode(raw);
    return decoded is Map<String, dynamic> ? decoded : null;
  }

  @override
  Future<void> write(Map<String, dynamic> value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_prefKey, jsonEncode(value));
  }

  @override
  Future<void> clear() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_prefKey);
  }
}
