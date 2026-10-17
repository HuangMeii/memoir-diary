import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/auth_provider.dart';
import '../../data/models.dart';
import '../../data/providers.dart';
import '../home/home_scale.dart';
import '../notes/note_actions.dart';
import '../notes/note_card.dart';
import '../notes/notes_callout.dart';
import '../notes/notes_chrome.dart';
import '../notes/notes_filter_bar.dart';
import '../notes/notes_header.dart';
import '../notes/notes_query.dart';
import '../notes/notes_search_field.dart';
import '../notes/notes_states.dart';
import '../widgets/app_header.dart';
import 'note_editor_screen.dart';

/// Notes list with pinned + all sections, trash mode and filters.
class NotesScreen extends ConsumerStatefulWidget {
  const NotesScreen({super.key});
  @override
  ConsumerState<NotesScreen> createState() => _NotesScreenState();
}

class _NotesScreenState extends ConsumerState<NotesScreen> {
  String _search = '';
  NoteFilter _filter = NoteFilter.all;
  String? _tag;
  NoteSort _sort = NoteSort.updatedDesc;
  bool _isGrid = true;
  bool _showTrash = false;

  @override
  Widget build(BuildContext context) {
    final auth = ref.watch(authProvider);
    ref.watch(authReadyProvider);
    final displayName = auth.user?['display_name'] as String?;
    return Scaffold(
      body: LayoutBuilder(builder: (context, constraints) {
        final scale = homeScaleFor(constraints.maxWidth);
        final textScale = homeTextScaleFor(constraints.maxWidth);
        final media = MediaQuery.of(context);
        return MediaQuery(
          data: media.copyWith(
            textScaler: textScale == 1
                ? media.textScaler
                : HomeTextScaler(base: media.textScaler, factor: textScale),
          ),
          child: HomeScale(
            factor: scale,
            textFactor: textScale,
            child: Column(children: [
              AppHeader(
                date: DateTime.now(),
                initials: initialsOf(displayName),
                name: displayName,
                onLogout: () => ref.read(authProvider.notifier).logout(),
              ),
              Expanded(child: _body()),
            ]),
          ),
        );
      }),
    );
  }

  Widget _body() {
    final notesAsync = ref.watch(notesProvider);
    final trashAsync = ref.watch(trashedNotesProvider);
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 1200),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              NotesBreadcrumb(
                onHome: () => Navigator.of(context).maybePop(),
              ),
              const SizedBox(height: 12),
              if (_showTrash) ...[
                NotesTrashHeader(
                  count: trashAsync.valueOrNull?.length ?? 0,
                  onExit: () => setState(() => _showTrash = false),
                ),
                const SizedBox(height: 12),
                _trashBody(trashAsync),
              ] else ...[
                NotesPageHeader(
                  count: notesAsync.valueOrNull?.length ?? 0,
                  onTrash: () => setState(() => _showTrash = true),
                  onCreate: () => _openEditor(null),
                ),
                const SizedBox(height: 16),
                NotesSearchField(
                  onChanged: (v) => setState(() => _search = v),
                ),
                const SizedBox(height: 12),
                _filterBar(notesAsync.valueOrNull ?? const []),
                const SizedBox(height: 16),
                notesAsync.when(
                  loading: () => const NotesLoading(),
                  error: (e, _) => NotesError(
                    error: e,
                    onRetry: () => ref.invalidate(notesProvider),
                  ),
                  data: _listBody,
                ),
                const SizedBox(height: 24),
                const NotesCallout(),
              ],
            ],
          ),
        ),
      ),
    );
  }

  Widget _filterBar(List<Note> notes) {
    final counts = {
      NoteFilter.all: notes.where((n) => !n.isTrashed && !n.isArchived).length,
      NoteFilter.recent: notes
          .where((n) => !n.isTrashed && !n.isArchived && isRecentNote(n))
          .length,
      NoteFilter.pinned: notes
          .where((n) => !n.isTrashed && !n.isArchived && n.isPinned)
          .length,
      NoteFilter.archived:
          notes.where((n) => !n.isTrashed && n.isArchived).length,
    };
    return NotesFilterBar(
      filter: _filter,
      onFilter: (f) => setState(() {
        _filter = f;
        if (f != NoteFilter.tag) {
          _tag = null;
        } else if (_tag == null) {
          final tags = noteTagCounts(notes);
          if (tags.isNotEmpty) _tag = tags.keys.first;
        }
      }),
      tagCounts: noteTagCounts(notes),
      sort: _sort,
      onSort: (s) => setState(() => _sort = s),
      isGrid: _isGrid,
      onViewChanged: (v) => setState(() => _isGrid = v),
      counts: counts,
    );
  }

  Widget _listBody(List<Note> notes) {
    final filtered = applyNotesQuery(
      notes,
      search: _search,
      filter: _filter,
      tag: _tag,
      sort: _sort,
    );
    if (filtered.isEmpty) {
      return NotesEmpty(trashed: false, onCreate: () => _openEditor(null));
    }
    final showSections = _filter == NoteFilter.all && _search.isEmpty;
    if (!showSections) return _grid(filtered);
    final pinned = filtered.where((n) => n.isPinned).toList();
    final rest = filtered.where((n) => !n.isPinned).toList();
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (pinned.isNotEmpty) ...[
          _sectionTitle('ĐÃ GHIM', '${pinned.length} ghi chú ưu tiên'),
          _grid(pinned),
          const SizedBox(height: 20),
        ],
        _sectionTitle('TẤT CẢ GHI CHÚ', '${rest.length} ghi chú thường'),
        _grid(rest),
      ],
    );
  }

  Widget _sectionTitle(String title, String sub) {
    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(children: [
        const Icon(Icons.push_pin, size: 16),
        const SizedBox(width: 6),
        Text(title, style: theme.textTheme.labelLarge),
        const SizedBox(width: 8),
        Text('· $sub', style: theme.textTheme.bodySmall),
      ]),
    );
  }

  Widget _grid(List<Note> notes) {
    return LayoutBuilder(builder: (context, c) {
      final w = c.maxWidth;
      final cols = _isGrid
          ? (w >= 1100
              ? 3
              : w >= 700
                  ? 2
                  : 1)
          : 1;
      if (cols <= 1) {
        return Column(children: [
          for (final n in notes)
            Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: NoteCard(
                note: n,
                isGrid: false,
                onOpen: () => _openEditor(n),
                onPin: (v) => pinNote(context, ref, n, v),
                onArchive: () => archiveNote(context, ref, n),
                onTrash: () => trashNote(context, ref, n),
              ),
            ),
        ]);
      }
      return Wrap(spacing: 12, runSpacing: 12, children: [
        for (final n in notes)
          SizedBox(
            width: (w - (cols - 1) * 12) / cols,
            child: NoteCard(
              note: n,
              isGrid: true,
              onOpen: () => _openEditor(n),
              onPin: (v) => pinNote(context, ref, n, v),
              onArchive: () => archiveNote(context, ref, n),
              onTrash: () => trashNote(context, ref, n),
            ),
          ),
      ]);
    });
  }

  Widget _trashBody(AsyncValue<List<Note>> async) {
    return async.when(
      loading: () => const NotesLoading(),
      error: (e, _) => NotesError(
        error: e,
        onRetry: () => ref.invalidate(trashedNotesProvider),
      ),
      data: (notes) {
        if (notes.isEmpty) {
          return NotesEmpty(
            trashed: true,
            onExit: () => setState(() => _showTrash = false),
          );
        }
        return Column(children: [
          for (final n in notes)
            Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: NoteCard(
                note: n,
                isGrid: false,
                trashed: true,
                onRestore: () => restoreNote(context, ref, n),
                onPurge: () => purgeNoteWithConfirm(context, ref, n),
              ),
            ),
        ]);
      },
    );
  }

  Future<void> _openEditor(Note? note) async {
    await showDialog<void>(
      context: context,
      barrierDismissible: false,
      barrierColor: const Color(0x59000000),
      builder: (c) => Dialog(
        elevation: 0,
        backgroundColor: Colors.transparent,
        clipBehavior: Clip.none,
        insetPadding: const EdgeInsets.all(20),
        child: ConstrainedBox(
          constraints: BoxConstraints(
            maxWidth: 1152,
            maxHeight: MediaQuery.sizeOf(c).height * 0.94,
          ),
          child: NoteEditorScreen(note: note),
        ),
      ),
    );
    refreshNotes(ref);
  }
}
