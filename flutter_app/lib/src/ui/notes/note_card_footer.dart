import 'package:flutter/material.dart';
import '../../data/models.dart';

/// Footer line: checklist progress, diary link count, or unlinked label.
class NoteCardFooter extends StatelessWidget {
  const NoteCardFooter({
    super.key,
    required this.note,
    required this.checklist,
    required this.linkedCount,
  });
  final Note note;
  final List<NoteChecklistItem> checklist;
  final int linkedCount;
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    if (checklist.isNotEmpty) {
      final done = checklist.where((e) => e.isDone).length;
      return Text('$done/${checklist.length} mục tiêu',
          style: theme.textTheme.bodySmall);
    }
    if (linkedCount > 0) {
      return Text('Nhật ký liên kết ($linkedCount)',
          style: theme.textTheme.bodySmall
              ?.copyWith(color: theme.colorScheme.primary));
    }
    return Text('Chưa liên kết', style: theme.textTheme.bodySmall);
  }
}
