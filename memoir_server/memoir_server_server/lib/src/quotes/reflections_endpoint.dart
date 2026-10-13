import 'package:serverpod/serverpod.dart';

import '../generated/protocol.dart';
import '../shared/session_utils.dart';

/// Reflections about the daily pair, mirroring FastAPI `/reflections`.
class ReflectionsEndpoint extends Endpoint {
  @override
  bool get requireLogin => true;

  Future<List<Reflection>> list(Session session, {UuidValue? entryId}) {
    final userId = currentUserId(session);
    return Reflection.db.find(
      session,
      where: (t) {
        var expr = t.userId.equals(userId);
        if (entryId != null) expr = expr & t.entryId.equals(entryId);
        return expr;
      },
      orderBy: (t) => t.createdAt.desc(),
    );
  }

  Future<Reflection> create(
    Session session, {
    required String thought,
    UuidValue? entryId,
    UuidValue? quoteId,
    UuidValue? selfMessageId,
  }) {
    return Reflection.db.insertRow(
      session,
      Reflection(
        userId: currentUserId(session),
        entryId: entryId,
        quoteId: quoteId,
        selfMessageId: selfMessageId,
        thought: thought,
      ),
    );
  }

  Future<Reflection> update(
    Session session, {
    required UuidValue id,
    required String thought,
  }) async {
    final reflection = await _owned(session, id);
    reflection.thought = thought;
    return Reflection.db.updateRow(session, reflection);
  }

  Future<void> delete(Session session, UuidValue id) async {
    final reflection = await _owned(session, id);
    await Reflection.db.deleteRow(session, reflection);
  }

  Future<Reflection> _owned(Session session, UuidValue id) async {
    final reflection = await Reflection.db.findById(session, id);
    ensureOwned(
      reflection != null && reflection.userId == currentUserId(session),
    );
    return reflection!;
  }
}
