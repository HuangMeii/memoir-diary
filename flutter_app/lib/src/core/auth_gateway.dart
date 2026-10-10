/// The authentication surface the app depends on.
///
/// Both the FastAPI implementation ([AuthRepository]) and the Serverpod one
/// ([ServerpodAuthRepository]) implement it, so the auth notifier can switch
/// backend with the same build flag the data layer uses.
abstract class AuthGateway {
  Future<dynamic> me();

  Future<Map<String, dynamic>> login(String username, String password);

  Future<Map<String, dynamic>> register({
    required String email,
    required String username,
    required String password,
  });
}
