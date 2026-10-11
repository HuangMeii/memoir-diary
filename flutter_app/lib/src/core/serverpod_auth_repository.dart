import 'package:memoir_server_client/memoir_server_client.dart' as sp;

import 'auth_gateway.dart';

/// [AuthGateway] backed by the Serverpod backend.
///
/// Token handling lives in the caller ([SessionStore]); this class only maps
/// the Serverpod `AuthResult`/`User` onto the plain maps the auth notifier and
/// the screens expect.
class ServerpodAuthRepository implements AuthGateway {
  const ServerpodAuthRepository(this._client);

  final sp.Client _client;

  @override
  Future<Map<String, dynamic>> me() async =>
      _userMap(await _client.auth.me());

  @override
  Future<Map<String, dynamic>> login(String username, String password) async {
    final result = await _client.auth.login(
      username: username,
      password: password,
    );
    return _authResultMap(result);
  }

  @override
  Future<Map<String, dynamic>> register({
    required String email,
    required String username,
    required String password,
  }) async {
    final result = await _client.auth.register(
      email: email,
      username: username,
      password: password,
    );
    return _authResultMap(result);
  }

  Map<String, dynamic> _authResultMap(sp.AuthResult result) => {
        'access_token': result.accessToken,
        'refresh_token': result.refreshToken,
        ..._userMap(result.user),
      };

  Map<String, dynamic> _userMap(sp.User user) => {
        'id': user.id?.toString(),
        'email': user.email,
        'username': user.username,
        'display_name': user.displayName,
        'role': user.role,
        'is_active': user.isActive,
      };
}
