import 'package:serverpod/serverpod.dart';

import '../generated/protocol.dart';

/// Admin-only operations, mirroring FastAPI `/admin`.
///
/// The endpoint requires the `admin` scope; a regular user is refused before
/// any method body runs.
class AdminEndpoint extends Endpoint {
  @override
  bool get requireLogin => true;

  @override
  Set<Scope> get requiredScopes => {const Scope('admin')};

  Future<List<User>> listUsers(Session session) =>
      User.db.find(session, orderBy: (t) => t.createdAt);

  Future<User> setUserActive(
    Session session, {
    required UuidValue id,
    required bool isActive,
  }) async {
    final user = await _user(session, id);
    user.isActive = isActive;
    return User.db.updateRow(session, user);
  }

  /// Promotes/demotes a user. `role` is `user` or `admin`.
  Future<User> setUserRole(
    Session session, {
    required UuidValue id,
    required String role,
  }) async {
    if (role != 'user' && role != 'admin') {
      throw ApiException(message: 'Invalid role', code: 'validation');
    }
    final user = await _user(session, id);
    user.role = role;
    return User.db.updateRow(session, user);
  }

  /// System quotes have a null owner and are visible to everyone.
  Future<List<Quote>> systemQuotes(Session session) async {
    final all = await Quote.db.find(
      session,
      orderBy: (t) => t.createdAt,
    );
    return all.where((q) => q.userId == null).toList();
  }

  Future<Quote> createSystemQuote(
    Session session, {
    required String text,
    String? author,
    String? source,
    String? category,
  }) {
    return Quote.db.insertRow(
      session,
      Quote(
        text: text,
        author: author,
        source: source,
        category: category,
      ),
    );
  }

  Future<Quote> updateSystemQuote(
    Session session, {
    required UuidValue id,
    String? text,
    String? author,
    String? source,
    String? category,
    bool? isActive,
  }) async {
    final quote = await _systemQuote(session, id);
    if (text != null) quote.text = text;
    quote.author = author;
    quote.source = source;
    quote.category = category;
    if (isActive != null) quote.isActive = isActive;
    quote.updatedAt = DateTime.now().toUtc();
    return Quote.db.updateRow(session, quote);
  }

  Future<void> deleteSystemQuote(Session session, UuidValue id) async {
    final quote = await _systemQuote(session, id);
    await Quote.db.deleteRow(session, quote);
  }

  Future<User> _user(Session session, UuidValue id) async {
    final user = await User.db.findById(session, id);
    if (user == null) {
      throw ApiException(message: 'User not found', code: 'notFound');
    }
    return user;
  }

  Future<Quote> _systemQuote(Session session, UuidValue id) async {
    final quote = await Quote.db.findById(session, id);
    if (quote == null || quote.userId != null) {
      throw ApiException(message: 'Quote not found', code: 'notFound');
    }
    return quote;
  }
}
