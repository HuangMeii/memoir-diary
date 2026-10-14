import '../datasources/backend_data_source.dart';
import '../models.dart';

class NotesRepository {
  const NotesRepository(this._source);
  final BackendDataSource _source;

  Future<List<Note>> list({
    bool archived = true,
    bool trashed = false,
  }) async {
    final rows = await _source.get('/notes', query: {
      'archived': '$archived',
      'trashed': '$trashed',
    });
    return ((rows as List).cast<Map<String, dynamic>>())
        .map(Note.fromJson)
        .toList();
  }

  Future<NoteDetail> get(String id) async {
    final raw =
        await _source.get('/notes/$id') as Map<String, dynamic>;
    return NoteDetail.fromJson(raw);
  }

  Future<Note> create({
    required String content,
    String? title,
    String? color,
    List<String>? tags,
    bool? isPinned,
    List<NoteChecklistItem>? checklist,
    List<String>? entryIds,
  }) async {
    final raw = await _source.post('/notes', data: {
      'content': content,
      if (title != null) 'title': title,
      if (color != null) 'color': color,
      if (tags != null) 'tags': tags,
      if (isPinned != null) 'is_pinned': isPinned,
      if (checklist != null)
        'checklist': checklist.map((e) => e.toJson()).toList(),
      if (entryIds != null) 'entry_ids': entryIds,
    });
    return Note.fromJson((raw as Map).cast<String, dynamic>());
  }

  Future<Note> update(
    Note current, {
    String? title,
    String? content,
    String? color,
    List<String>? tags,
    bool? isPinned,
    bool? isArchived,
    bool? isTrashed,
    List<NoteChecklistItem>? checklist,
    List<String>? entryIds,
  }) async {
    final raw = await _source.put('/notes/${current.id}', data: {
      'title': title ?? current.title,
      'content': content ?? current.content,
      'color': color ?? current.color,
      'tags': tags ?? current.tags,
      'is_pinned': isPinned ?? current.isPinned,
      'is_archived': isArchived ?? current.isArchived,
      'is_trashed': isTrashed ?? current.isTrashed,
      if (checklist != null)
        'checklist': checklist.map((e) => e.toJson()).toList(),
      if (entryIds != null) 'entry_ids': entryIds,
    });
    return Note.fromJson((raw as Map).cast<String, dynamic>());
  }

  Future<void> setPinned(Note current, bool value) =>
      update(current, isPinned: value);

  Future<void> setArchived(Note current, bool value) =>
      update(current, isArchived: value);

  Future<void> trash(String id) => _source.delete('/notes/$id');

  /// Kept for old callers; now moves the note to trash.
  Future<void> delete(String id) => trash(id);

  Future<void> restore(String id) =>
      _source.post('/notes/$id/restore');

  Future<void> purge(String id) => _source.delete('/notes/$id/purge');
}

