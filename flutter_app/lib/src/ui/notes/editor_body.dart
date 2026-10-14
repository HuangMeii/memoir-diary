import 'package:flutter/material.dart';

import '../../data/models.dart';
import '../theme.dart';
import '../tokens.dart';
import 'editor_top_bar.dart';

/// Title, meta strip, body field and the interactive checklist block.
class EditorBody extends StatelessWidget {
  const EditorBody({
    super.key,
    required this.titleController,
    required this.contentController,
    required this.focusNode,
    required this.autofocusTitle,
    required this.updatedAt,
    required this.tags,
    required this.color,
    required this.checklist,
    required this.onToggleChecklist,
    required this.onRemoveChecklist,
    required this.onAddChecklistItem,
  });

  final TextEditingController titleController;
  final TextEditingController contentController;
  final FocusNode focusNode;
  final bool autofocusTitle;
  final DateTime? updatedAt;
  final List<String> tags;
  final String? color;
  final List<NoteChecklistItem> checklist;
  final ValueChanged<int> onToggleChecklist;
  final ValueChanged<int> onRemoveChecklist;
  final VoidCallback onAddChecklistItem;

  int get _words => Note(id: '', content: contentController.text).wordCount;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        TextField(
          controller: titleController,
          autofocus: autofocusTitle,
          style: theme.textTheme.headlineMedium?.copyWith(
            fontFamily: serifFamily,
            fontSize: MemoirType.heading1,
          ),
          decoration: const InputDecoration(
            hintText: 'Tiêu đề ghi chú...',
            border: InputBorder.none,
            enabledBorder: InputBorder.none,
            focusedBorder: InputBorder.none,
            filled: false,
            isDense: true,
            contentPadding: EdgeInsets.zero,
          ),
        ),
        const SizedBox(height: 12),
        _meta(theme),
        const SizedBox(height: 16),
        ListenableBuilder(
          listenable: contentController,
          builder: (context, _) => TextField(
            controller: contentController,
            focusNode: focusNode,
            minLines: 10,
            maxLines: null,
            keyboardType: TextInputType.multiline,
            textInputAction: TextInputAction.newline,
            style: theme.textTheme.bodyMedium?.copyWith(
              fontFamily: sansFamily,
              fontSize: MemoirType.bodyInput,
              color: theme.colorScheme.onSurface,
              height: 1.6,
            ),
            decoration: const InputDecoration(
              hintText: 'Viết nội dung ghi chú...',
              border: InputBorder.none,
              enabledBorder: InputBorder.none,
              focusedBorder: InputBorder.none,
              filled: false,
              isDense: true,
              contentPadding: EdgeInsets.zero,
            ),
          ),
        ),
        const SizedBox(height: 20),
        _checklistBlock(theme),
      ],
    );
  }

  Widget _meta(ThemeData theme) {
    final at = updatedAt;
    return Container(
      padding: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(
              color: theme.colorScheme.outlineVariant.withValues(alpha: .5)),
        ),
      ),
      child: ListenableBuilder(
        listenable: contentController,
        builder: (context, _) => Wrap(
          crossAxisAlignment: WrapCrossAlignment.center,
          spacing: 14,
          runSpacing: 6,
          children: [
            Row(mainAxisSize: MainAxisSize.min, children: [
              Icon(Icons.calendar_today_outlined,
                  size: 14, color: theme.colorScheme.primary),
              const SizedBox(width: 5),
              Text(
                at == null
                    ? 'Ngày cập nhật: —'
                    : 'Ngày cập nhật: ${at.day} Tháng ${at.month}, ${at.year}',
                style: theme.textTheme.bodySmall
                    ?.copyWith(color: theme.colorScheme.primary),
              ),
            ]),
            Row(mainAxisSize: MainAxisSize.min, children: [
              Icon(Icons.notes,
                  size: 14, color: theme.colorScheme.onSurfaceVariant),
              const SizedBox(width: 5),
              Text(
                '$_words từ',
                style: theme.textTheme.bodySmall?.copyWith(
                  color: theme.colorScheme.onSurfaceVariant,
                ),
              ),
            ]),
            if (tags.isNotEmpty)
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                decoration: BoxDecoration(
                  color: theme.colorScheme.surfaceContainerHighest
                      .withValues(alpha: .6),
                  borderRadius: BorderRadius.circular(MemoirRadius.pill),
                ),
                child: Text(
                  '• ${tags.first}',
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: theme.colorScheme.onSurfaceVariant,
                  ),
                ),
              ),
            if (color != null)
              Row(mainAxisSize: MainAxisSize.min, children: [
                Container(
                  width: 8,
                  height: 8,
                  decoration: BoxDecoration(
                      color: colorFromHex(color), shape: BoxShape.circle),
                ),
                const SizedBox(width: 5),
                Text(
                  '• Màu ghi chú: ${noteColorName(color)}',
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: theme.colorScheme.onSurfaceVariant,
                  ),
                ),
              ]),
          ],
        ),
      ),
    );
  }

  Widget _checklistBlock(ThemeData theme) => Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color:
              theme.colorScheme.surfaceContainerHighest.withValues(alpha: .35),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
              color: theme.colorScheme.outlineVariant.withValues(alpha: .6)),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            for (var i = 0; i < checklist.length; i++) _row(theme, i),
            Align(
              alignment: Alignment.centerLeft,
              child: TextButton.icon(
                onPressed: onAddChecklistItem,
                icon: const Icon(Icons.add, size: 16),
                label: const Text('Thêm dòng'),
                style: TextButton.styleFrom(
                  minimumSize: const Size(0, 32),
                  padding: const EdgeInsets.symmetric(horizontal: 8),
                  foregroundColor: theme.colorScheme.onSurfaceVariant,
                ),
              ),
            ),
          ],
        ),
      );

  Widget _row(ThemeData theme, int index) {
    final item = checklist[index];
    return Row(children: [
      SizedBox(
        width: 32,
        height: 32,
        child: Checkbox(
          value: item.isDone,
          onChanged: (_) => onToggleChecklist(index),
          activeColor: theme.colorScheme.primary,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
        ),
      ),
      const SizedBox(width: 4),
      Expanded(
        child: Text(
          item.text,
          style: theme.textTheme.bodyMedium?.copyWith(
            fontFamily: sansFamily,
            color: item.isDone
                ? theme.colorScheme.onSurfaceVariant
                : theme.colorScheme.onSurface,
            decoration: item.isDone ? TextDecoration.lineThrough : null,
          ),
        ),
      ),
      IconButton(
        onPressed: () => onRemoveChecklist(index),
        tooltip: 'Xoá dòng',
        visualDensity: VisualDensity.compact,
        icon: Icon(Icons.close,
            size: 16, color: theme.colorScheme.outlineVariant),
      ),
    ]);
  }
}
