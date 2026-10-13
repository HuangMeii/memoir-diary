import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

/// Owns the session tokens for the whole app.
///
/// It is the single home for the access/refresh tokens and for the "session is
/// gone" signal. The Serverpod client reads the access token from here live
/// (see `serverpod_backend.dart`), so a login or logout takes effect on the
/// next request without rebuilding the client.
///
/// The 401 refresh call the FastAPI client used to make is gone with the REST
/// client: the Serverpod backend issues an opaque token stored in `auth_tokens`
/// and returns it as both access and refresh token, so there is nothing to
/// renew on this side.
class SessionStore {
  SessionStore(this._storage);

  final FlutterSecureStorage _storage;

  static const _accessKey = 'memoir_access_token';
  static const _refreshKey = 'memoir_refresh_token';

  String? accessToken;
  String? refreshToken;

  /// Notified when the session cannot be recovered, so the app can log out.
  void Function()? onSessionLost;

  Future<String?> readAccess() => _storage.read(key: _accessKey);

  Future<String?> readRefresh() => _storage.read(key: _refreshKey);

  Future<void> write(String access, String? refresh) async {
    accessToken = access;
    await _storage.write(key: _accessKey, value: access);
    if (refresh != null && refresh.isNotEmpty) {
      refreshToken = refresh;
      await _storage.write(key: _refreshKey, value: refresh);
    }
  }

  Future<void> setAccess(String access) async {
    accessToken = access;
    await _storage.write(key: _accessKey, value: access);
  }

  Future<void> clear() async {
    accessToken = null;
    refreshToken = null;
    await _storage.delete(key: _accessKey);
    await _storage.delete(key: _refreshKey);
  }

  /// Called when a request proves the stored session is no longer usable.
  void sessionLost() => onSessionLost?.call();
}

final sessionStoreProvider = Provider<SessionStore>(
  (ref) => SessionStore(const FlutterSecureStorage()),
);
