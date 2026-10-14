import 'package:flutter/material.dart';

import '../../data/models.dart';

/// Automatic body variant: checklist, progress, quote, or plain text.
class NoteCardBody extends StatelessWidget {
  const NoteCardBody({
    super.key,
    required this.note,
    required this.checklist,
    required this.isGrid,
  });

  final Note note;
  final List<NoteChecklistItem> checklist;
  final bool isGrid;

  @override
  Widget build(BuildContext context) {
    if (checklist.isNotEmpty) return _checklist(context);
    final progress = progressValue(note.content);
    if (progress != null) return _progress(context, progress);
    final quote = quoteText(note.content);
    if (quote != null) return _quote(context, quote);
    final text = note.preview.isEmpty ? note.content.trim() : note.preview;
    return Text(
      text,
      maxLines: isGrid ? 3 : 2,
      overflow: TextOverflow.ellipsis,
      style: Theme.of(context).textTheme.bodyMedium,
    );
  }

  Widget _checklist(BuildContext context) {
    final theme = Theme.of(context);
    final done = checklist.where((e) => e.isDone).length;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        for (final item in checklist.take(3))
          Row(
            children: [
              Checkbox(value: item.isDone, onChanged: null),
              Expanded(
                child: Text(
                  item.text,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: theme.textTheme.bodyMedium?.copyWith(
                    decoration: item.isDone ? TextDecoration.lineThrough : null,
                  ),
                ),
              ),
            ],
          ),
        Text('$done/${checklist.length}', style: theme.textTheme.bodySmall),
      ],
    );
  }

  Widget _progress(BuildContext context, double value) {
    final theme = Theme.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Expanded(child: Text('Tiến độ', style: theme.textTheme.bodyMedium)),
            Text('${(value * 100).round()}%',
                style: theme.textTheme.labelLarge),
          ],
        ),
        const SizedBox(height: 6),
        LinearProgressIndicator(value: value),
      ],
    );
  }

  Widget _quote(BuildContext context, String quote) {
    final theme = Theme.of(context);
    return Container(
      padding: const EdgeInsets.only(left: 10),
      decoration: BoxDecoration(
        border: Border(
          left: BorderSide(color: theme.colorScheme.primary, width: 2),
        ),
      ),
      child: Text(
        quote,
        maxLines: isGrid ? 3 : 2,
        overflow: TextOverflow.ellipsis,
        style: theme.textTheme.bodyMedium?.copyWith(
          fontStyle: FontStyle.italic,
        ),
      ),
    );
  }
}

/// First `> quote` line in markdown content, if any.
String? quoteText(String content) {
  for (final line in content.split('\n')) {
    final trimmed = line.trim();
    if (trimmed.startsWith('>')) return trimmed.substring(1).trim();
  }
  return null;
}

/// `Tiến độ …: N%` parsed to 0–1, if present.
double? progressValue(String content) {
  final match = RegExp(r'Tiến độ[^0-9]*(\d{1,3})\s*%').firstMatch(content);
  if (match == null) return null;
  final value = int.tryParse(match.group(1) ?? '');
  if (value == null) return null;
  return value.clamp(0, 100) / 100;
}
