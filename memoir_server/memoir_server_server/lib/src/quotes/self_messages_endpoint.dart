import 'package:serverpod/serverpod.dart';

import '../generated/protocol.dart';
import '../shared/session_utils.dart';

/// The user's own messages to self, mirroring FastAPI `/self-messages`.
class SelfMessagesEndpoint extends Endpoint {
  @override
  bool get requireLogin => true;

  Future<List<SelfMessage>> list(Session session) {
    final userId = currentUserId(session);
    return SelfMessage.db.find(
      session,
      where: (t) => t.userId.equals(userId),
      orderBy: (t) => t.createdAt.desc(),
    );
  }

  Future<SelfMessage> create(
    Session session, {
    required String content,
    UuidValue? entryId,
  }) {
    return SelfMessage.db.insertRow(
      session,
      SelfMessage(
        userId: currentUserId(session),
        entryId: entryId,
        content: content,
      ),
    );
  }

  Future<SelfMessage> update(
    Session session, {
    required UuidValue id,
    required String content,
  }) async {
    final message = await _owned(session, id);
    message.content = content;
    return SelfMessage.db.updateRow(session, message);
  }

  Future<void> delete(Session session, UuidValue id) async {
    final message = await _owned(session, id);
    await SelfMessage.db.deleteRow(session, message);
  }

  Future<SelfMessage> _owned(Session session, UuidValue id) async {
    final message = await SelfMessage.db.findById(session, id);
    ensureOwned(message != null && message.userId == currentUserId(session));
    return message!;
  }
}
