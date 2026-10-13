/// The authentication surface the app depends on.
///
/// [ServerpodAuthRepository] implements it, and the auth notifier only knows
/// this interface, so the transport can change without touching the UI.
abstract class AuthGateway {
  Future<dynamic> me();

  Future<Map<String, dynamic>> login(String username, String password);

  Future<Map<String, dynamic>> register({
    required String email,
    required String username,
    required String password,
  });
}
