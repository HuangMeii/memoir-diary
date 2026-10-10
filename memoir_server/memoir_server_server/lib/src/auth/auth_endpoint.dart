import 'package:serverpod/serverpod.dart';

import '../generated/protocol.dart';
import 'auth_utils.dart';

/// Authentication endpoints, mirroring FastAPI `/auth/*`.
///
/// `register`/`login` are public, so the endpoint itself does not require a
/// login; [me] and [logout] check the session explicitly.
class AuthEndpoint extends Endpoint {
  @override
  bool get requireLogin => false;

  Future<AuthResult> register(
    Session session, {
    required String email,
    required String username,
    required String password,
    String? displayName,
  }) async {
    final normalizedEmail = email.trim().toLowerCase();
    final normalizedUsername = username.trim();

    final existing = await User.db.findFirstRow(
      session,
      where: (t) =>
          t.email.equals(normalizedEmail) |
          t.username.equals(normalizedUsername),
    );
    if (existing != null) {
      throw ApiException(
        message: 'Email or username already registered',
        code: 'conflict',
      );
    }

    final user = await User.db.insertRow(
      session,
      User(
        email: normalizedEmail,
        username: normalizedUsername,
        passwordHash: hashPassword(password),
        displayName: displayName,
      ),
    );

    final token = await _issueToken(session, user);
    return AuthResult(
      accessToken: token,
      refreshToken: token,
      expiresIn: accessTokenTtlSeconds,
      user: user,
    );
  }

  Future<AuthResult> login(
    Session session, {
    required String username,
    required String password,
  }) async {
    final normalized = username.trim();
    final user = await User.db.findFirstRow(
      session,
      where: (t) =>
          t.email.equals(normalized.toLowerCase()) |
          t.username.equals(normalized),
    );

    // One message for all failures: revealing whether the account exists or is
    // disabled would leak that information.
    if (user == null ||
        !user.isActive ||
        user.passwordHash == null ||
        !verifyPassword(password, user.passwordHash!)) {
      throw ApiException(
        message: 'Incorrect email/username or password',
        code: 'unauthorized',
      );
    }

    final token = await _issueToken(session, user);
    return AuthResult(
      accessToken: token,
      refreshToken: token,
      expiresIn: accessTokenTtlSeconds,
      user: user,
    );
  }

  Future<User> me(Session session) => requireUser(session);

  /// Revokes the token used for this call.
  Future<void> logout(Session session) async {
    final authId = session.authenticated?.authId;
    if (authId == null) return;
    await AuthToken.db.deleteWhere(
      session,
      where: (t) => t.id.equals(UuidValue.fromString(authId)),
    );
  }

  Future<String> _issueToken(Session session, User user) async {
    final token = generateToken();
    await AuthToken.db.insertRow(
      session,
      AuthToken(
        userId: user.id!,
        token: token,
        expiresAt: DateTime.now().toUtc().add(
          const Duration(seconds: accessTokenTtlSeconds),
        ),
      ),
    );
    return token;
  }
}
