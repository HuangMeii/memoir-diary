import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../data/models.dart';
import '../../data/providers.dart';
import '../icons.dart';
import '../screens/entry_editor.dart';
import '../theme.dart';

/// "LIÊN KẾT NHẬT KÝ LIÊN QUAN" — linked diary cards + add/unlink actions.
class EditorLinksPanel extends ConsumerStatefulWidget {
  const EditorLinksPanel({
    super.key,
    required this.entryIds,
    required this.linkedEntries,
    required this.onChanged,
  });

  final List<String> entryIds;
  final List<DiaryEntry> linkedEntries;
  final ValueChanged<List<String>> onChanged;

  @override
  ConsumerState<EditorLinksPanel> createState() => _EditorLinksPanelState();
}

class _EditorLinksPanelState extends ConsumerState<EditorLinksPanel> {
  /// Cache of entry payloads by id so cards keep rendering after an unlink.
  final Map<String, DiaryEntry> _byId = {};

  @override
  void initState() {
    super.initState();
    for (final e in widget.linkedEntries) {
      _byId[e.id] = e;
    }
  }

  @override
  void didUpdateWidget(covariant EditorLinksPanel old) {
    super.didUpdateWidget(old);
    for (final e in widget.linkedEntries) {
      _byId[e.id] = e;
    }
  }

  String _ddmmyyyy(DateTime d) {
    final mm = d.month.toString().padLeft(2, '0');
    final dd = d.day.toString().padLeft(2, '0');
    return '$dd.$mm.${d.year}';
  }

  String _excerpt(DiaryEntry e) {
    final text = e.diaryText?.trim();
    if (text == null || text.isEmpty) return '(Trang trống)';
    final first = text.split('\n').first.trim();
    return first.length > 100 ? '${first.substring(0, 100)}…' : first;
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final moods = ref.watch(moodsProvider).valueOrNull;
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        border: Border.all(
            color: theme.colorScheme.outlineVariant.withValues(alpha: .6)),
        borderRadius: BorderRadius.circular(14),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          _header(theme),
          const SizedBox(height: 12),
          if (widget.entryIds.isEmpty)
            Text(
              'Chưa liên kết trang nhật ký nào',
              style: theme.textTheme.bodySmall?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
              ),
            )
          else
            for (final id in widget.entryIds)
              if (_byId[id] != null) ...[
                _card(theme, _byId[id]!, moods),
                const SizedBox(height: 10),
              ],
        ],
      ),
    );
  }

  Widget _header(ThemeData theme) => Row(
        children: [
          Icon(Icons.auto_stories, size: 18, color: theme.colorScheme.primary),
          const SizedBox(width: 8),
          Expanded(
            child: Wrap(
              crossAxisAlignment: WrapCrossAlignment.center,
              spacing: 8,
              children: [
                Text(
                  'LIÊN KẾT NHẬT KÝ LIÊN QUAN',
                  style: theme.textTheme.labelSmall?.copyWith(
                    letterSpacing: .8,
                    fontWeight: FontWeight.w700,
                    color: theme.colorScheme.onSurface,
                  ),
                ),
                Text(
                  '(Đồng bộ với Memoir Diary)',
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: theme.colorScheme.onSurfaceVariant,
                  ),
                ),
              ],
            ),
          ),
          TextButton.icon(
            onPressed: _pick,
            icon: const Icon(Icons.add, size: 16),
            label: const Text('Liên kết thêm trang nhật ký khác'),
            style: TextButton.styleFrom(
              minimumSize: const Size(0, 34),
              foregroundColor: theme.colorScheme.primary,
            ),
          ),
        ],
      );

  Widget _card(ThemeData theme, DiaryEntry entry, List<LookupItem>? moods) =>
      Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color:
              theme.colorScheme.surfaceContainerHighest.withValues(alpha: .3),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
              color: theme.colorScheme.outlineVariant.withValues(alpha: .5)),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: 36,
              height: 36,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: theme.colorScheme.primary.withValues(alpha: .10),
                borderRadius: BorderRadius.circular(9),
              ),
              child:
                  Icon(Icons.book, size: 18, color: theme.colorScheme.primary),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Wrap(
                    crossAxisAlignment: WrapCrossAlignment.center,
                    spacing: 10,
                    runSpacing: 4,
                    children: [
                      Text(
                        'Trang nhật ký ngày ${_ddmmyyyy(entry.entryDate)}',
                        style: theme.textTheme.labelSmall?.copyWith(
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      _moodChip(theme, entry, moods),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Text(
                    _excerpt(entry),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: theme.colorScheme.onSurface,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 8),
            Column(children: [
              TextButton.icon(
                onPressed: () => _open(entry),
                icon: const Icon(Icons.arrow_outward, size: 15),
                label: const Text('Mở trang nhật ký'),
                style: TextButton.styleFrom(
                  minimumSize: const Size(0, 32),
                  padding: const EdgeInsets.symmetric(horizontal: 8),
                  foregroundColor: theme.colorScheme.primary,
                ),
              ),
              TextButton.icon(
                onPressed: () => _unlink(entry.id),
                icon: const Icon(Icons.link_off, size: 15),
                label: const Text('Huỷ liên kết'),
                style: TextButton.styleFrom(
                  minimumSize: const Size(0, 30),
                  padding: const EdgeInsets.symmetric(horizontal: 8),
                  foregroundColor: theme.colorScheme.onSurfaceVariant,
                ),
              ),
            ]),
          ],
        ),
      );

  Widget _moodChip(ThemeData theme, DiaryEntry entry, List<LookupItem>? moods) {
    if (entry.moodId == null || moods == null) return const SizedBox.shrink();
    LookupItem? mood;
    for (final m in moods) {
      if (m.id == entry.moodId) mood = m;
    }
    if (mood == null) return const SizedBox.shrink();
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(
        color: colorFromHex(mood.colorHex,
            fallback: theme.colorScheme.secondaryContainer),
        borderRadius: BorderRadius.circular(999),
      ),
      child: Row(mainAxisSize: MainAxisSize.min, children: [
        MemoirIcon(moodIcon(mood.code),
            size: 13, color: theme.colorScheme.onSurface),
        const SizedBox(width: 5),
        Text(
          'Tâm trạng: ${mood.label}',
          style: theme.textTheme.labelSmall?.copyWith(
            color: theme.colorScheme.onSurface,
            fontWeight: FontWeight.w600,
          ),
        ),
      ]),
    );
  }

  Future<void> _pick() async {
    final now = DateTime.now();
    final key = '${now.year}-${now.month.toString().padLeft(2, '0')}';
    final Map<String, DiaryEntry> month;
    try {
      month = await ref.read(monthEntriesProvider(key).future);
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Không tải được trang nhật ký: $e')),
        );
      }
      return;
    }
    final list = month.values
        .where((e) => !widget.entryIds.contains(e.id))
        .toList()
      ..sort((a, b) => b.entryDate.compareTo(a.entryDate));
    if (!mounted) return;
    final chosen = await showDialog<DiaryEntry>(
      context: context,
      builder: (c) => AlertDialog(
        title: Text('Chọn trang nhật ký (${now.month}/${now.year})'),
        actions: [
          TextButton(
              onPressed: () => Navigator.of(c).pop(),
              child: const Text('Đóng')),
        ],
        content: SizedBox(
          width: 440,
          height: 380,
          child: list.isEmpty
              ? const Center(
                  child: Text('Tháng này chưa có trang nhật ký để liên kết.'))
              : ListView.separated(
                  itemCount: list.length,
                  separatorBuilder: (_, __) => const Divider(height: 1),
                  itemBuilder: (c, i) {
                    final e = list[i];
                    return ListTile(
                      leading: const Icon(Icons.book, size: 20),
                      title:
                          Text('Trang nhật ký ngày ${_ddmmyyyy(e.entryDate)}'),
                      subtitle: Text(_excerpt(e),
                          maxLines: 1, overflow: TextOverflow.ellipsis),
                      onTap: () => Navigator.of(c).pop(e),
                    );
                  },
                ),
        ),
      ),
    );
    if (chosen == null || !mounted) return;
    setState(() => _byId[chosen.id] = chosen);
    widget.onChanged([...widget.entryIds, chosen.id]);
  }

  void _open(DiaryEntry entry) => Navigator.of(context).push(
        MaterialPageRoute(
            builder: (_) => EntryEditorScreen(date: entry.entryDate)),
      );

  void _unlink(String id) => widget.onChanged([...widget.entryIds]..remove(id));
}
