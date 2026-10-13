import 'dart:convert';
import 'dart:math';

import 'package:bcrypt/bcrypt.dart';
import 'package:serverpod/serverpod.dart';

import '../generated/protocol.dart';

/// Access-token lifetime in seconds, matching `ACCESS_TOKEN_EXPIRE_MINUTES`.
const int accessTokenTtlSeconds = 60 * 60;

/// bcrypt only considers the first 72 bytes of a password.
const int _bcryptMaxBytes = 72;

/// Hashes a password with bcrypt so existing FastAPI hashes stay compatible.
String hashPassword(String password) {
  return BCrypt.hashpw(_truncate(password), BCrypt.gensalt());
}

/// Verifies a plaintext password against a stored bcrypt hash.
bool verifyPassword(String password, String hashed) {
  try {
    return BCrypt.checkpw(_truncate(password), hashed);
  } catch (_) {
    return false;
  }
}

String _truncate(String password) {
  final bytes = utf8.encode(password);
  if (bytes.length <= _bcryptMaxBytes) return password;
  return utf8.decode(bytes.sublist(0, _bcryptMaxBytes), allowMalformed: true);
}

/// Creates an opaque, URL-safe session token.
String generateToken() {
  final random = Random.secure();
  final bytes = List<int>.generate(32, (_) => random.nextInt(256));
  return base64Url.encode(bytes);
}

/// Resolves the authenticated [User] or throws when the session is anonymous.
Future<User> requireUser(Session session) async {
  final identifier = session.authenticated?.userIdentifier;
  if (identifier == null) {
    throw ApiException(message: 'Not authenticated', code: 'unauthorized');
  }
  final user = await User.db.findById(session, _parseUserId(identifier));
  if (user == null || !user.isActive) {
    throw ApiException(message: 'Not authenticated', code: 'unauthorized');
  }
  return user;
}

/// Parses a user id coming from an authentication handler.
UuidValue _parseUserId(String value) => UuidValue.fromString(value);

/// True when the user holds the admin scope.
bool isAdmin(User user) => user.role == 'admin';

/// Custom [AuthenticationHandler] backing token-based sessions.
///
/// The token is an opaque row in `auth_tokens` so logout can revoke it. The
/// account is re-loaded and re-checked on every request: a deactivated user
/// must not be able to keep using an old token.
Future<AuthenticationInfo?> authenticationHandler(
  Session session,
  String token,
) async {
  if (token.isEmpty) return null;

  final stored = await AuthToken.db.findFirstRow(
    session,
    where: (t) => t.token.equals(token),
  );
  if (stored == null) return null;
  if (stored.expiresAt.isBefore(DateTime.now().toUtc())) return null;

  final user = await User.db.findById(session, stored.userId);
  if (user == null || !user.isActive) return null;

  final scopes = <Scope>{Scope('user')};
  if (isAdmin(user)) scopes.add(Scope('admin'));

  return AuthenticationInfo(
    user.id!.toString(),
    scopes,
    authId: stored.id!.toString(),
  );
}
