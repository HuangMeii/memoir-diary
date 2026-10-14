import 'package:flutter/material.dart';

import '../tokens.dart';
import 'notes_query.dart';

/// Filter chips, sort menu and grid/list toggle for the notes list.
class NotesFilterBar extends StatelessWidget {
  const NotesFilterBar({
    super.key,
    required this.filter,
    required this.onFilter,
    required this.tagCounts,
    required this.sort,
    required this.onSort,
    required this.isGrid,
    required this.onViewChanged,
    required this.counts,
  });

  final NoteFilter filter;
  final ValueChanged<NoteFilter> onFilter;
  final Map<String, int> tagCounts;
  final NoteSort sort;
  final ValueChanged<NoteSort> onSort;
  final bool isGrid;
  final ValueChanged<bool> onViewChanged;
  final Map<NoteFilter, int> counts;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Row(
      children: [
        Expanded(
          child: SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: [
                _chip(context, 'Tất cả (${counts[NoteFilter.all] ?? 0})',
                    filter == NoteFilter.all, () {
                  onFilter(NoteFilter.all);
                }),
                _chip(context, 'Gần đây (${counts[NoteFilter.recent] ?? 0})',
                    filter == NoteFilter.recent, () {
                  onFilter(NoteFilter.recent);
                }),
                _chip(context, 'Đã ghim (${counts[NoteFilter.pinned] ?? 0})',
                    filter == NoteFilter.pinned, () {
                  onFilter(NoteFilter.pinned);
                }),
                for (final entry in tagCounts.entries)
                  _chip(context, '#${entry.key} (${entry.value})',
                      filter == NoteFilter.tag, () {
                    onFilter(NoteFilter.tag);
                  }),
                _chip(
                    context,
                    'Đã lưu trữ (${counts[NoteFilter.archived] ?? 0})',
                    filter == NoteFilter.archived, () {
                  onFilter(NoteFilter.archived);
                }),
              ],
            ),
          ),
        ),
        const SizedBox(width: 8),
        PopupMenuButton<NoteSort>(
          initialValue: sort,
          onSelected: onSort,
          itemBuilder: (context) => const [
            PopupMenuItem(
                value: NoteSort.updatedDesc, child: Text('Mới cập nhật')),
            PopupMenuItem(value: NoteSort.createdDesc, child: Text('Mới tạo')),
            PopupMenuItem(value: NoteSort.titleAsc, child: Text('Tiêu đề A–Z')),
          ],
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
            decoration: BoxDecoration(
              border: Border.all(color: theme.colorScheme.outlineVariant),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(Icons.sort, size: 16),
                const SizedBox(width: 4),
                Text('Sắp xếp', style: theme.textTheme.labelLarge),
              ],
            ),
          ),
        ),
        const SizedBox(width: 8),
        IconButton(
          tooltip: 'Chế độ lưới',
          color: isGrid ? theme.colorScheme.primary : null,
          onPressed: () => onViewChanged(true),
          icon: const Icon(Icons.grid_view, size: 18),
        ),
        IconButton(
          tooltip: 'Chế độ danh sách',
          color: !isGrid ? theme.colorScheme.primary : null,
          onPressed: () => onViewChanged(false),
          icon: const Icon(Icons.view_list, size: 18),
        ),
      ],
    );
  }

  Widget _chip(
    BuildContext context,
    String label,
    bool selected,
    VoidCallback onTap,
  ) {
    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.only(right: 8),
      child: ChoiceChip(
        label: Text(label),
        selected: selected,
        onSelected: (_) => onTap(),
        selectedColor: theme.colorScheme.primary,
        labelStyle: theme.textTheme.labelLarge?.copyWith(
          fontSize: MemoirType.label,
          color: selected
              ? theme.colorScheme.onPrimary
              : theme.colorScheme.onSurfaceVariant,
        ),
      ),
    );
  }
}
