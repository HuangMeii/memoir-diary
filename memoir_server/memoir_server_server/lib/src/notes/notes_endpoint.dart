import 'package:serverpod/serverpod.dart';

import '../generated/protocol.dart';
import '../shared/session_utils.dart';

/// Quick notes CRUD, mirroring FastAPI `/notes`.
class NotesEndpoint extends Endpoint {
  @override
  bool get requireLogin => true;

  Future<List<Note>> list(Session session) {
    final userId = currentUserId(session);
    return Note.db.find(
      session,
      where: (t) => t.userId.equals(userId),
      orderByList: (t) => [t.isPinned.desc(), t.createdAt.desc()],
    );
  }

  Future<Note> create(
    Session session, {
    required String content,
    String? title,
    String? color,
    bool? isPinned,
  }) {
    return Note.db.insertRow(
      session,
      Note(
        userId: currentUserId(session),
        // `title` is accepted for parity with the FastAPI schema but the note
        // body is the only stored text.
        content: content,
        color: color,
        isPinned: isPinned ?? false,
      ),
    );
  }

  Future<Note> update(
    Session session, {
    required UuidValue id,
    String? content,
    String? color,
    bool? isPinned,
  }) async {
    final note = await _owned(session, id);
    if (content != null) note.content = content;
    note.color = color;
    if (isPinned != null) note.isPinned = isPinned;
    note.updatedAt = DateTime.now().toUtc();
    return Note.db.updateRow(session, note);
  }

  Future<void> delete(Session session, UuidValue id) async {
    final note = await _owned(session, id);
    await Note.db.deleteRow(session, note);
  }

  Future<Note> _owned(Session session, UuidValue id) async {
    final note = await Note.db.findById(session, id);
    ensureOwned(note != null && note.userId == currentUserId(session));
    return note!;
  }
}
