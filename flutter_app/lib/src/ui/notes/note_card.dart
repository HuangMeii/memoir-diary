import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../data/models.dart';
import '../theme.dart';
import '../tokens.dart';
import 'note_card_body.dart';
import 'note_card_footer.dart';

class NoteCard extends StatelessWidget {
  const NoteCard(
      {super.key,
      required this.note,
      required this.isGrid,
      this.checklist = const [],
      this.linkedCount = 0,
      this.onOpen,
      this.onPin,
      this.onArchive,
      this.onTrash,
      this.onRestore,
      this.onPurge,
      this.trashed = false});
  final Note note;
  final bool isGrid;
  final List<NoteChecklistItem> checklist;
  final int linkedCount;
  final VoidCallback? onOpen;
  final ValueChanged<bool>? onPin;
  final VoidCallback? onArchive;
  final VoidCallback? onTrash;
  final VoidCallback? onRestore;
  final VoidCallback? onPurge;
  final bool trashed;
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final palette = MemoirPalette.of(context);
    return Card(
        child: InkWell(
            borderRadius: BorderRadius.circular(MemoirRadius.card),
            onTap: onOpen,
            child: Padding(
                padding: const EdgeInsets.all(MemoirSpace.s5),
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Expanded(
                                child: Text(note.displayTitle,
                                    style: theme.textTheme.headlineSmall
                                        ?.copyWith(
                                            fontFamily: serifFamily,
                                            fontSize:
                                                MemoirType.headingEditorial))),
                            if (!trashed) ...[
                              GestureDetector(
                                  onTap: () => onPin?.call(!note.isPinned),
                                  child: Padding(
                                      padding: const EdgeInsets.all(4),
                                      child: Icon(Icons.push_pin,
                                          size: 18,
                                          color: note.isPinned
                                              ? theme.colorScheme.primary
                                              : theme.colorScheme.outline))),
                              PopupMenuButton<String>(
                                  icon: const Icon(Icons.more_vert, size: 18),
                                  onSelected: (v) {
                                    if (v == 'pin') {
                                      onPin?.call(!note.isPinned);
                                    } else if (v == 'archive') {
                                      onArchive?.call();
                                    } else if (v == 'trash') {
                                      onTrash?.call();
                                    }
                                  },
                                  itemBuilder: (c) => [
                                        PopupMenuItem(
                                            value: 'pin',
                                            child: Text(note.isPinned
                                                ? 'Bỏ ghim'
                                                : 'Ghim')),
                                        PopupMenuItem(
                                            value: 'archive',
                                            child: Text(note.isArchived
                                                ? 'Bỏ lưu trữ'
                                                : 'Lưu trữ')),
                                        const PopupMenuItem(
                                            value: 'trash', child: Text('Xoá'))
                                      ])
                            ]
                          ]),
                      if (note.tags.isNotEmpty) ...[
                        const SizedBox(height: 8),
                        Wrap(spacing: 6, runSpacing: 6, children: [
                          for (final t in note.tags)
                            Container(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 8, vertical: 2),
                                decoration: BoxDecoration(
                                    color: palette.surfaceBrandSubtle,
                                    borderRadius: BorderRadius.circular(
                                        MemoirRadius.pill)),
                                child: Text('#$t',
                                    style: theme.textTheme.bodySmall?.copyWith(
                                        color: theme.colorScheme.primary,
                                        fontSize: MemoirType.caption,
                                        fontWeight: FontWeight.w600)))
                        ])
                      ],
                      const SizedBox(height: 8),
                      NoteCardBody(
                          note: note, checklist: checklist, isGrid: isGrid),
                      const SizedBox(height: 10),
                      Container(
                          decoration: BoxDecoration(
                              border: Border(
                                  top: BorderSide(
                                      color:
                                          theme.colorScheme.outlineVariant))),
                          padding: const EdgeInsets.only(top: 10),
                          child: Row(children: [
                            Expanded(
                                child: NoteCardFooter(
                                    note: note,
                                    checklist: checklist,
                                    linkedCount: linkedCount)),
                            Text(_date(), style: theme.textTheme.bodySmall)
                          ])),
                      if (trashed) ...[
                        const SizedBox(height: 10),
                        Row(children: [
                          Expanded(
                              child: OutlinedButton(
                                  onPressed: onRestore,
                                  child: const Text('Khôi phục'))),
                          const SizedBox(width: 8),
                          Expanded(
                              child: FilledButton(
                                  style: FilledButton.styleFrom(
                                      backgroundColor: theme.colorScheme.error),
                                  onPressed: onPurge,
                                  child: const Text('Xoá vĩnh viễn')))
                        ])
                      ]
                    ]))));
  }

  String _date() {
    final d = note.updatedAt ?? note.createdAt;
    if (d == null) return '';
    return DateFormat('dd/MM/yyyy').format(d.toLocal());
  }
}
