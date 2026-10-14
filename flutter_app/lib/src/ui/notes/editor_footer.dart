import 'package:flutter/material.dart';

/// Sticky footer: delete/duplicate on the left, confirm action on the right.
class EditorFooter extends StatelessWidget {
  const EditorFooter({
    super.key,
    required this.isNew,
    required this.dirty,
    required this.onDelete,
    required this.onDuplicate,
    required this.onDone,
  });

  final bool isNew;

  /// Whether the draft still has unsaved changes; the screen decides to
  /// flush them before popping (see `NoteEditorScreen._done`).
  final bool dirty;
  final VoidCallback onDelete;
  final VoidCallback onDuplicate;
  final VoidCallback onDone;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        border:
            Border(top: BorderSide(color: theme.colorScheme.outlineVariant)),
      ),
      child: LayoutBuilder(builder: (context, c) {
        final wide = c.maxWidth >= 640;
        return Row(children: [
          if (!isNew)
            _textAction(
              theme,
              Icons.delete_outline,
              wide ? 'Xoá ghi chú' : null,
              onDelete,
              danger: true,
            ),
          if (!isNew)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 4),
              child: Container(
                width: 1,
                height: 16,
                color: theme.colorScheme.outlineVariant,
              ),
            ),
          _textAction(theme, Icons.content_copy, wide ? 'Lưu bản sao' : null,
              onDuplicate),
          const Spacer(),
          if (wide)
            Padding(
              padding: const EdgeInsets.only(right: 14),
              child: Text(
                'Tất cả thay đổi đều được mã hoá trên thiết bị của bạn',
                style: theme.textTheme.bodySmall?.copyWith(
                  color: theme.colorScheme.onSurfaceVariant,
                ),
              ),
            ),
          Semantics(
            button: true,
            hint: dirty ? 'Lưu thay đổi rồi đóng' : 'Đóng ghi chú',
            child: FilledButton(
              onPressed: onDone,
              style: FilledButton.styleFrom(
                minimumSize: const Size(0, 40),
                padding: const EdgeInsets.symmetric(horizontal: 18),
              ),
              child: const Text('Xong & Đóng'),
            ),
          ),
        ]);
      }),
    );
  }

  Widget _textAction(
    ThemeData theme,
    IconData icon,
    String? label,
    VoidCallback onTap, {
    bool danger = false,
  }) {
    final color =
        danger ? theme.colorScheme.error : theme.colorScheme.onSurfaceVariant;
    return TextButton.icon(
      onPressed: onTap,
      icon: Icon(icon, size: 16, color: color),
      label: label == null
          ? const SizedBox.shrink()
          : Text(label, style: TextStyle(color: color)),
      style: TextButton.styleFrom(
        minimumSize: const Size(0, 36),
        padding: const EdgeInsets.symmetric(horizontal: 8),
        foregroundColor: color,
      ),
    );
  }
}
