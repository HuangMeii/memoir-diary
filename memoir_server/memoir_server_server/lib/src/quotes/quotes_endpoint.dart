import 'package:serverpod/serverpod.dart';

import '../generated/protocol.dart';
import '../shared/session_utils.dart';

/// Quote library CRUD, mirroring FastAPI `/quotes`.
///
/// System quotes (null owner) are read-only here; admins manage them through
/// the admin endpoint.
class QuotesEndpoint extends Endpoint {
  @override
  bool get requireLogin => true;

  Future<List<Quote>> list(Session session, {String? category}) async {
    final userId = currentUserId(session);
    // Null-owner comparison is done in Dart: the visible library is small and
    // this keeps the query portable.
    final all = await Quote.db.find(
      session,
      where: (t) => t.isActive.equals(true),
      orderBy: (t) => t.createdAt,
    );
    return all
        .where(
          (q) =>
              (q.userId == null || q.userId == userId) &&
              (category == null || q.category == category),
        )
        .toList();
  }

  Future<Quote> create(
    Session session, {
    required String text,
    String? author,
    String? source,
    String? category,
  }) {
    return Quote.db.insertRow(
      session,
      Quote(
        userId: currentUserId(session),
        text: text,
        author: author,
        source: source,
        category: category,
      ),
    );
  }

  Future<Quote> update(
    Session session, {
    required UuidValue id,
    String? text,
    String? author,
    String? source,
    String? category,
    bool? isActive,
  }) async {
    final quote = await _owned(session, id);
    if (text != null) quote.text = text;
    quote.author = author;
    quote.source = source;
    quote.category = category;
    if (isActive != null) quote.isActive = isActive;
    quote.updatedAt = DateTime.now().toUtc();
    return Quote.db.updateRow(session, quote);
  }

  Future<void> delete(Session session, UuidValue id) async {
    final quote = await _owned(session, id);
    await Quote.db.deleteRow(session, quote);
  }

  /// Only the caller's own quotes can be edited here.
  Future<Quote> _owned(Session session, UuidValue id) async {
    final quote = await Quote.db.findById(session, id);
    ensureOwned(quote != null && quote.userId == currentUserId(session));
    return quote!;
  }
}
