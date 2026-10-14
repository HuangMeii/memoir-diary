import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/autosave.dart';
import '../../data/models.dart';
import '../../data/providers.dart';
import '../notes/editor_body.dart';
import '../notes/editor_footer.dart';
import '../notes/editor_links_panel.dart';
import '../notes/editor_toolbar.dart';
import '../notes/editor_top_bar.dart';
import '../tokens.dart';

/// How long the note editor waits after a pause before it saves itself.
const Duration kNoteAutoSaveDelay = Duration(seconds: 2);

/// Note editor (`N4` · Figma `taoghichu`): title, markdown-lite body,
/// checklist, diary links, colours/tags and an autosaving footer.
class NoteEditorScreen extends ConsumerStatefulWidget {
  const NoteEditorScreen({super.key, this.note});

  /// The note to edit, or `null` to create a new one.
  final Note? note;

  @override
  ConsumerState<NoteEditorScreen> createState() => _NoteEditorScreenState();
}

class _NoteEditorScreenState extends ConsumerState<NoteEditorScreen> {
  late final TextEditingController _title;
  late final TextEditingController _content;
  final FocusNode _bodyFocus = FocusNode();
  final ScrollController _scroll = ScrollController();

  Note? _note;
  List<String> _tags = [];
  List<NoteChecklistItem> _checklist = [];
  List<DiaryEntry> _linkedEntries = [];
  List<String> _entryIds = [];
  String? _color;
  bool _isPinned = false;

  bool _dirty = false;
  bool _saving = false;
  bool _loadingDetail = false;
  DateTime? _savedAt;

  late final AutosaveDebouncer _debouncer;

  @override
  void initState() {
    super.initState();
    _note = widget.note;
    _title = TextEditingController(text: widget.note?.title ?? '');
    _content = TextEditingController(text: widget.note?.content ?? '');
    _tags = [...?widget.note?.tags];
    _color = widget.note?.color;
    _isPinned = widget.note?.isPinned ?? false;
    _savedAt = widget.note?.updatedAt;
    _debouncer = AutosaveDebouncer(delay: kNoteAutoSaveDelay, onElapsed: _save);
    _title.addListener(_touch);
    _content.addListener(_touch);
    final id = widget.note?.id;
    if (id != null) _loadDetail(id);
  }

  /// Pulls checklist + linked entries for an existing note (`noteDetailProvider`).
  Future<void> _loadDetail(String id) async {
    setState(() => _loadingDetail = true);
    try {
      final detail = await ref.read(noteDetailProvider(id).future);
      if (!mounted) return;
      setState(() {
        _checklist = [...detail.checklist];
        _linkedEntries = [...detail.entries];
        _entryIds = [...detail.entries.map((e) => e.id)];
        _loadingDetail = false;
      });
    } catch (_) {
      if (mounted) setState(() => _loadingDetail = false);
    }
  }

  /// Marks the draft dirty and (re)starts the autosave wait.
  void _touch() {
    if (!_dirty) setState(() => _dirty = true);
    _debouncer.schedule();
  }

  /// Saves once; returns whether the draft is safely on the server.
  Future<bool> _save() async {
    _debouncer.cancel();
    if (!_dirty) return true;
    setState(() => _saving = true);
    try {
      final repo = ref.read(notesRepositoryProvider);
      final title = _title.text.trim();
      final Note saved;
      if (_note == null) {
        saved = await repo.create(
          content: _content.text,
          title: title.isEmpty ? null : title,
          color: _color,
          tags: _tags,
          isPinned: _isPinned,
          checklist: _checklist.isEmpty ? null : _checklist,
          entryIds: _entryIds,
        );
      } else {
        saved = await repo.update(
          _note!,
          title: title,
          content: _content.text,
          color: _color,
          tags: _tags,
          isPinned: _isPinned,
          checklist: _checklist,
          entryIds: _entryIds,
        );
      }
      if (!mounted) return true;
      setState(() {
        _note = saved;
        _dirty = false;
        _saving = false;
        _savedAt = DateTime.now();
      });
      refreshNotes(ref);
      return true;
    } catch (e) {
      if (mounted) {
        setState(() => _saving = false);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Chưa lưu được ghi chú: $e')),
        );
      }
      return false;
    }
  }

  /// Back button / system back: confirm while the draft is dirty.
  Future<void> _confirmBack() async {
    if (!_dirty) {
      Navigator.of(context).pop();
      return;
    }
    final choice = await showDialog<String>(
      context: context,
      builder: (c) => AlertDialog(
        title: const Text('Thay đổi chưa lưu'),
        content: const Text('Ghi chú này có thay đổi chưa được lưu.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(c).pop('stay'),
            child: const Text('Ở lại'),
          ),
          TextButton(
            onPressed: () => Navigator.of(c).pop('discard'),
            child: const Text('Thoát không lưu'),
          ),
          FilledButton(
            onPressed: () => Navigator.of(c).pop('save'),
            child: const Text('Lưu & thoát'),
          ),
        ],
      ),
    );
    if (!mounted || choice == null || choice == 'stay') return;
    if (choice == 'discard') {
      setState(() => _dirty = false);
      if (mounted) Navigator.of(context).pop();
      return;
    }
    final ok = await _save();
    if (ok && mounted) Navigator.of(context).pop();
  }

  Future<void> _addTag() async {
    final field = TextEditingController();
    final tag = await showDialog<String>(
      context: context,
      builder: (c) => AlertDialog(
        title: const Text('Thêm thẻ'),
        content: TextField(
          controller: field,
          autofocus: true,
          decoration: const InputDecoration(hintText: 'VD: du lịch'),
          onSubmitted: (v) => Navigator.of(c).pop(v.trim()),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(c).pop(),
            child: const Text('Huỷ'),
          ),
          FilledButton(
            onPressed: () => Navigator.of(c).pop(field.text.trim()),
            child: const Text('Thêm'),
          ),
        ],
      ),
    );
    field.dispose();
    if (tag == null || tag.isEmpty || _tags.contains(tag) || !mounted) return;
    setState(() => _tags = [..._tags, tag]);
    _touch();
  }

  void _setColor(String hex) {
    if (_color == hex) return;
    setState(() => _color = hex);
    _touch();
  }

  void _togglePin() {
    setState(() => _isPinned = !_isPinned);
    _touch();
  }

  void _toggleChecklist(int index) {
    setState(() => _checklist = [
          for (var i = 0; i < _checklist.length; i++)
            if (i == index)
              _checklist[i].copyWith(isDone: !_checklist[i].isDone)
            else
              _checklist[i],
        ]);
    _touch();
  }

  void _removeChecklist(int index) {
    setState(() => _checklist = [..._checklist]..removeAt(index));
    _touch();
  }

  Future<void> _addChecklistItem() async {
    final field = TextEditingController();
    final text = await showDialog<String>(
      context: context,
      builder: (c) => AlertDialog(
        title: const Text('Thêm dòng checklist'),
        content: TextField(
          controller: field,
          autofocus: true,
          decoration: const InputDecoration(hintText: 'Việc cần làm...'),
          onSubmitted: (v) => Navigator.of(c).pop(v.trim()),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(c).pop(),
            child: const Text('Huỷ'),
          ),
          FilledButton(
            onPressed: () => Navigator.of(c).pop(field.text.trim()),
            child: const Text('Thêm'),
          ),
        ],
      ),
    );
    field.dispose();
    if (text == null || text.isEmpty || !mounted) return;
    setState(() => _checklist = [
          ..._checklist,
          NoteChecklistItem(text: text, sortOrder: _checklist.length),
        ]);
    _touch();
  }

  void _setEntryIds(List<String> ids) {
    setState(() => _entryIds = ids);
    _touch();
  }

  void _scrollToLinks() {
    if (!_scroll.hasClients) return;
    _scroll.animateTo(
      _scroll.position.maxScrollExtent,
      duration: const Duration(milliseconds: 350),
      curve: Curves.easeOut,
    );
  }

  /// Saves a copy (fresh checklist ids) and keeps editing that copy.
  Future<void> _duplicate() async {
    final base = _title.text.trim().isEmpty
        ? (_note?.displayTitle ?? 'Ghi chú')
        : _title.text.trim();
    try {
      final copy = await ref.read(notesRepositoryProvider).create(
            title: '$base (bản sao)',
            content: _content.text,
            color: _color,
            tags: _tags,
            isPinned: _isPinned,
            checklist: _checklist.isEmpty
                ? null
                : [
                    for (final c in _checklist)
                      NoteChecklistItem(
                        text: c.text,
                        isDone: c.isDone,
                        sortOrder: c.sortOrder,
                      ),
                  ],
            entryIds: _entryIds,
          );
      _debouncer.cancel();
      setState(() {
        _note = copy;
        _dirty = false;
        _savedAt = DateTime.now();
      });
      refreshNotes(ref);
      await _loadDetail(copy.id);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Đã tạo bản sao "${copy.displayTitle}"')),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Không nhân bản được ghi chú: $e')),
        );
      }
    }
  }

  Future<void> _delete() async {
    final note = _note;
    if (note == null) return;
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (c) => AlertDialog(
        title: const Text('Xoá ghi chú?'),
        content: const Text('Ghi chú sẽ được chuyển vào thùng rác.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(c).pop(false),
            child: const Text('Huỷ'),
          ),
          FilledButton(
            onPressed: () => Navigator.of(c).pop(true),
            child: const Text('Xoá'),
          ),
        ],
      ),
    );
    if (confirmed != true || !mounted) return;
    try {
      await ref.read(notesRepositoryProvider).trash(note.id);
      refreshNotes(ref);
      if (mounted) Navigator.of(context).pop();
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Không xoá được ghi chú: $e')),
        );
      }
    }
  }

  Future<void> _done() async {
    final ok = await _save();
    if (ok && mounted) Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return PopScope(
      canPop: !_dirty,
      onPopInvokedWithResult: (didPop, _) {
        if (!didPop) _confirmBack();
      },
      child: DecoratedBox(
        decoration: BoxDecoration(
          color: theme.colorScheme.surface,
          borderRadius: BorderRadius.circular(MemoirRadius.card),
          border: Border.all(color: theme.colorScheme.outlineVariant),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: .12),
              blurRadius: 40,
              offset: const Offset(0, 12),
            ),
          ],
        ),
        child: Column(children: [
          EditorTopBar(
            onBack: _confirmBack,
            saving: _saving,
            savedAt: _savedAt,
            color: _color,
            onColorChanged: _setColor,
            isPinned: _isPinned,
            onTogglePin: _togglePin,
            onAddTag: _addTag,
            onLink: _scrollToLinks,
            onSave: _done,
          ),
          EditorToolbar(controller: _content, focusNode: _bodyFocus),
          Expanded(
            child: SingleChildScrollView(
              controller: _scroll,
              padding: const EdgeInsets.fromLTRB(24, 24, 24, 32),
              child: Center(
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 860),
                  child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        EditorBody(
                          titleController: _title,
                          contentController: _content,
                          focusNode: _bodyFocus,
                          autofocusTitle: widget.note == null,
                          updatedAt: _note?.updatedAt,
                          tags: _tags,
                          color: _color,
                          checklist: _checklist,
                          onToggleChecklist: _toggleChecklist,
                          onRemoveChecklist: _removeChecklist,
                          onAddChecklistItem: _addChecklistItem,
                        ),
                        if (_loadingDetail) ...[
                          const SizedBox(height: 16),
                          const LinearProgressIndicator(),
                        ],
                        const SizedBox(height: 20),
                        EditorLinksPanel(
                          entryIds: _entryIds,
                          linkedEntries: _linkedEntries,
                          onChanged: _setEntryIds,
                        ),
                      ]),
                ),
              ),
            ),
          ),
          EditorFooter(
            isNew: _note == null,
            dirty: _dirty,
            onDelete: _delete,
            onDuplicate: _duplicate,
            onDone: _done,
          ),
        ]),
      ),
    );
  }

  @override
  void dispose() {
    _title.removeListener(_touch);
    _content.removeListener(_touch);
    _debouncer.cancel();
    _title.dispose();
    _content.dispose();
    _bodyFocus.dispose();
    _scroll.dispose();
    super.dispose();
  }
}
