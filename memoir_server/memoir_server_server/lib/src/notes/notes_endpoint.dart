import 'package:serverpod/serverpod.dart';

import '../generated/protocol.dart';
import '../shared/session_utils.dart';

/// Quick notes CRUD, mirroring FastAPI `/notes`.
///
/// Supports title, tags, pin/archive/trash flags, interactive checklist
/// ([NoteChecklistItem]) and many-to-many diary links ([NoteEntryLink]).
class NotesEndpoint extends Endpoint {
  @override
  bool get requireLogin => true;

  Future<List<Note>> list(
    Session session, {
    bool includeArchived = true,
    bool trashedOnly = false,
  }) async {
    final userId = currentUserId(session);
    return Note.db.find(
      session,
      where: (t) {
        var condition =
            t.userId.equals(userId) & t.isTrashed.equals(trashedOnly);
        if (!includeArchived) {
          condition = condition & t.isArchived.equals(false);
        }
        return condition;
      },
      orderByList: (t) => [t.isPinned.desc(), t.updatedAt.desc()],
    );
  }

  Future<NoteDetail> get(Session session, UuidValue id) async {
    final note = await _owned(session, id);
    final checklist = await NoteChecklistItem.db.find(
      session,
      where: (t) => t.noteId.equals(id),
      orderBy: (t) => t.sortOrder.asc(),
    );
    final links = await NoteEntryLink.db.find(
      session,
      where: (t) => t.noteId.equals(id),
      orderBy: (t) => t.createdAt.desc(),
    );
    final entries = <DiaryEntry>[];
    for (final link in links) {
      final entry = await DiaryEntry.db.findById(session, link.entryId);
      if (entry != null && entry.userId == note.userId) {
        entries.add(entry);
      }
    }
    entries.sort((a, b) => b.entryDate.compareTo(a.entryDate));
    return NoteDetail(note: note, checklist: checklist, entries: entries);
  }

  Future<Note> create(
    Session session, {
    required String content,
    String? title,
    String? color,
    List<String>? tags,
    bool? isPinned,
    List<NoteChecklistItem>? checklist,
    List<UuidValue>? entryIds,
  }) async {
    final userId = currentUserId(session);
    final cleanTitle = title?.trim();
    final note = await Note.db.insertRow(
      session,
      Note(
        userId: userId,
        title: cleanTitle == null || cleanTitle.isEmpty ? null : cleanTitle,
        content: content,
        color: color,
        tags: tags ?? [],
        isPinned: isPinned ?? false,
      ),
    );
    final noteId = note.id!;
    await _replaceChecklist(session, noteId, checklist ?? const []);
    await _replaceLinks(session, userId, noteId, entryIds ?? const []);
    return (await get(session, noteId)).note;
  }

  Future<Note> update(
    Session session, {
    required UuidValue id,
    String? title,
    String? content,
    String? color,
    List<String>? tags,
    bool? isPinned,
    bool? isArchived,
    bool? isTrashed,
    List<NoteChecklistItem>? checklist,
    List<UuidValue>? entryIds,
  }) async {
    final note = await _owned(session, id);
    if (title != null) {
      final clean = title.trim();
      note.title = clean.isEmpty ? null : clean;
    }
    if (content != null) note.content = content;
    if (color != null) note.color = color.isEmpty ? null : color;
    if (tags != null) note.tags = tags;
    if (isPinned != null) note.isPinned = isPinned;
    if (isArchived != null) note.isArchived = isArchived;
    if (isTrashed != null) note.isTrashed = isTrashed;
    note.updatedAt = DateTime.now().toUtc();
    await Note.db.updateRow(session, note);
    if (checklist != null) {
      await _replaceChecklist(session, id, checklist);
    }
    if (entryIds != null) {
      await _replaceLinks(session, note.userId, id, entryIds);
    }
    note.updatedAt = DateTime.now().toUtc();
    return Note.db.updateRow(session, note);
  }

  Future<void> restore(Session session, UuidValue id) async {
    final note = await _owned(session, id);
    note.isTrashed = false;
    note.updatedAt = DateTime.now().toUtc();
    await Note.db.updateRow(session, note);
  }

  Future<Note> archive(Session session, UuidValue id, bool isArchived) async {
    final note = await _owned(session, id);
    note.isArchived = isArchived;
    note.updatedAt = DateTime.now().toUtc();
    return Note.db.updateRow(session, note);
  }

  Future<void> purge(Session session, UuidValue id) async {
    final note = await _owned(session, id);
    if (!note.isTrashed) {
      throw ApiException(
        message: 'Only trashed notes can be purged',
        code: 'conflict',
      );
    }
    await NoteChecklistItem.db.deleteWhere(
      session,
      where: (t) => t.noteId.equals(id),
    );
    await NoteEntryLink.db.deleteWhere(
      session,
      where: (t) => t.noteId.equals(id),
    );
    await Note.db.deleteRow(session, note);
  }

  Future<void> delete(Session session, UuidValue id) async {
    final note = await _owned(session, id);
    note.isTrashed = true;
    note.updatedAt = DateTime.now().toUtc();
    await Note.db.updateRow(session, note);
  }

  Future<void> _replaceChecklist(
    Session session,
    UuidValue noteId,
    List<NoteChecklistItem> items,
  ) async {
    await session.db.transaction((transaction) async {
      final existing = await NoteChecklistItem.db.find(
        session,
        where: (t) => t.noteId.equals(noteId),
        transaction: transaction,
      );
      final keepIds = {
        for (final item in items)
          if (item.id != null) item.id.toString(),
      };
      for (final row in existing) {
        if (row.id != null && !keepIds.contains(row.id.toString())) {
          await NoteChecklistItem.db.deleteRow(
            session,
            row,
            transaction: transaction,
          );
        }
      }
      for (var index = 0; index < items.length; index++) {
        final item = items[index];
        NoteChecklistItem? row;
        if (item.id != null) {
          for (final e in existing) {
            if (e.id.toString() == item.id.toString()) {
              row = e;
              break;
            }
          }
        }
        if (row != null) {
          row.text = item.text;
          row.isDone = item.isDone;
          row.sortOrder = index;
          await NoteChecklistItem.db.updateRow(
            session,
            row,
            transaction: transaction,
          );
        } else {
          await NoteChecklistItem.db.insertRow(
            session,
            NoteChecklistItem(
              noteId: noteId,
              text: item.text,
              isDone: item.isDone,
              sortOrder: index,
            ),
            transaction: transaction,
          );
        }
      }
    });
  }

  Future<void> _replaceLinks(
    Session session,
    UuidValue userId,
    UuidValue noteId,
    List<UuidValue> entryIds,
  ) async {
    await session.db.transaction((transaction) async {
      await NoteEntryLink.db.deleteWhere(
        session,
        where: (t) => t.noteId.equals(noteId),
        transaction: transaction,
      );
      final seen = <String>{};
      for (final entryId in entryIds) {
        if (!seen.add(entryId.toString())) continue;
        final entry = await DiaryEntry.db.findById(session, entryId);
        if (entry == null || entry.userId != userId) continue;
        await NoteEntryLink.db.insertRow(
          session,
          NoteEntryLink(noteId: noteId, entryId: entryId),
          transaction: transaction,
        );
      }
    });
  }

  Future<Note> _owned(Session session, UuidValue id) async {
    final note = await Note.db.findById(session, id);
    ensureOwned(note != null && note.userId == currentUserId(session));
    return note!;
  }
}
