/// Pure helpers for the notes list: search, filter, sort and tag counts.
library;

import '../../data/models.dart';

/// Which chip is selected on the notes list.
enum NoteFilter { all, recent, pinned, archived, tag }

/// Sort order of the notes list.
enum NoteSort { updatedDesc, createdDesc, titleAsc }

/// Lowercases and strips Vietnamese diacritics for accent-free search.
String normalizeNoteText(String value) {
  const withDia = 'àáảãạăằắẳẵặâầấẩẫậèéẻẽẹêềếểễệ'
      'ìíỉĩịòóỏõọôồốổỗộơờớởỡợùúủũụưừứửữựỳýỷỹỵđ'
      'ÀÁẢÃẠĂẰẮẲẴẶÂẦẤẨẪẬÈÉẺẼẸÊỀẾỂỄỆÌÍỈĨỊÒÓỎÕỌ'
      'ÔỒỐỔỖỘƠỜỚỞỠỢÙÚỦŨỤƯỪỨỬỮỰỲÝỶỸỴĐ';
  const withoutDia = 'aaaaaaaaaaaaaaaaaeeeeeeeeeeeiiiii'
      'ooooooooooooooooouuuuuuuuuuuyyyyyd'
      'AAAAAAAAAAAAAAAAAEEEEEEEEEEEIIIII'
      'OOOOOOOOOOOOOOOOOUUUUUUUUUUUYYYYYD';
  final buffer = StringBuffer();
  for (final rune in value.runes) {
    final char = String.fromCharCode(rune);
    final index = withDia.indexOf(char);
    buffer.write(index < 0 ? char : withoutDia[index]);
  }
  return buffer.toString().toLowerCase();
}

/// A note updated in the last 7 days counts as "recent".
bool isRecentNote(Note note, {DateTime? now}) {
  final updated = note.updatedAt;
  if (updated == null) return false;
  final at = now ?? DateTime.now();
  return at.difference(updated).inDays < 7;
}

/// Filters and sorts notes on the client (lists are small).
List<Note> applyNotesQuery(
  List<Note> notes, {
  String search = '',
  NoteFilter filter = NoteFilter.all,
  String? tag,
  NoteSort sort = NoteSort.updatedDesc,
}) {
  final query = normalizeNoteText(search.trim());
  var result = notes.where((note) {
    if (note.isTrashed) return false;
    switch (filter) {
      case NoteFilter.all:
        if (note.isArchived) return false;
        break;
      case NoteFilter.recent:
        if (note.isArchived || !isRecentNote(note)) return false;
        break;
      case NoteFilter.pinned:
        if (!note.isPinned || note.isArchived) return false;
        break;
      case NoteFilter.archived:
        if (!note.isArchived) return false;
        break;
      case NoteFilter.tag:
        if (tag == null || !note.tags.contains(tag)) return false;
        break;
    }
    if (query.isEmpty) return true;
    final haystack = normalizeNoteText(
      '${note.title ?? ''}\n${note.content}\n${note.tags.join(' ')}',
    );
    return haystack.contains(query);
  }).toList();
  switch (sort) {
    case NoteSort.updatedDesc:
      result.sort((a, b) => _time(b.updatedAt).compareTo(_time(a.updatedAt)));
      break;
    case NoteSort.createdDesc:
      result.sort((a, b) => _time(b.createdAt).compareTo(_time(a.createdAt)));
      break;
    case NoteSort.titleAsc:
      result.sort((a, b) =>
          a.displayTitle.toLowerCase().compareTo(b.displayTitle.toLowerCase()));
      break;
  }
  return result;
}

DateTime _time(DateTime? value) =>
    value ?? DateTime.fromMillisecondsSinceEpoch(0);

/// Counts tags across non-trashed notes for the `#tag` chips.
Map<String, int> noteTagCounts(List<Note> notes) {
  final counts = <String, int>{};
  for (final note in notes) {
    if (note.isTrashed) continue;
    for (final tag in note.tags) {
      counts[tag] = (counts[tag] ?? 0) + 1;
    }
  }
  return counts;
}
