import 'package:flutter/material.dart';

import 'markdown_lite.dart';

/// Markdown-lite formatting toolbar for the note body (`taoghichu` design).
class EditorToolbar extends StatefulWidget {
  const EditorToolbar({
    super.key,
    required this.controller,
    required this.focusNode,
  });

  final TextEditingController controller;
  final FocusNode focusNode;

  @override
  State<EditorToolbar> createState() => _EditorToolbarState();
}

class _EditorToolbarState extends State<EditorToolbar> {
  /// Current line around the caret, used for heading/list active states.
  String get _line {
    final text = widget.controller.text;
    final sel = widget.controller.selection;
    final offset = sel.isValid ? sel.start : text.length;
    if (text.isEmpty) return '';
    final start = text.lastIndexOf('\n', offset.clamp(0, text.length) - 1) + 1;
    final end = text.indexOf('\n', start);
    return end == -1 ? text.substring(start) : text.substring(start, end);
  }

  bool _heading(int level) {
    final prefix = '#' * level;
    final line = _line;
    if (!line.startsWith('$prefix ')) return false;
    return level == 3 || !line.startsWith('${'#' * (level + 1)} ');
  }

  bool get _bullet =>
      _line.startsWith('- ') &&
      !_line.startsWith('- [') &&
      !_line.startsWith('- [x');

  bool get _numbered => _line.startsWith('1. ');

  bool get _quote => _line.startsWith('> ');

  bool get _checklist => lineHasChecklist(
        widget.controller.text,
        widget.controller.selection.isValid
            ? widget.controller.selection.start
            : 0,
      );

  void _apply(MarkdownEdit Function(String, TextSelection) edit) {
    final c = widget.controller;
    final result = edit(c.text, c.selection);
    c.value = TextEditingValue(text: result.text, selection: result.selection);
    widget.focusNode.requestFocus();
  }

  void _prefix(String p) => _apply((t, s) => prefixLine(t, s, p));

  void _inline(String m) => _apply((t, s) => toggleInline(t, s, m));

  void _insert(String payload) => _apply((t, s) {
        if (!s.isValid) return (text: t, selection: s);
        final updated = t.replaceRange(s.start, s.end, payload);
        return (
          text: updated,
          selection: TextSelection.collapsed(offset: s.start + payload.length),
        );
      });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        border:
            Border(bottom: BorderSide(color: theme.colorScheme.outlineVariant)),
      ),
      child: ListenableBuilder(
        listenable: widget.controller,
        builder: (context, _) {
          return SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(children: [
              _text('B', 'In đậm (Ctrl+B)', () => _inline('**'),
                  style: const TextStyle(fontWeight: FontWeight.w700)),
              _text('I', 'In nghiêng (Ctrl+I)', () => _inline('*'),
                  style: const TextStyle(fontStyle: FontStyle.italic)),
              _text('U', 'Gạch chân', () => _inline('__'),
                  style: const TextStyle(decoration: TextDecoration.underline)),
              _text('S', 'Gạch ngang', () => _inline('~~'),
                  style:
                      const TextStyle(decoration: TextDecoration.lineThrough)),
              _sep(),
              _text('H1', 'Tiêu đề lớn', () => _prefix('# '),
                  active: _heading(1)),
              _text('H2', 'Tiêu đề vừa', () => _prefix('## '),
                  active: _heading(2)),
              _text('H3', 'Tiêu đề nhỏ', () => _prefix('### '),
                  active: _heading(3)),
              _sep(),
              _icon(Icons.format_list_bulleted, 'Danh sách ghi',
                  () => _prefix('- '),
                  active: _bullet),
              _icon(Icons.format_list_numbered, 'Danh sách số',
                  () => _prefix('1. '),
                  active: _numbered),
              _icon(Icons.checklist, 'Checklist', () {
                _apply(insertChecklist);
                setState(() {});
              }, active: _checklist),
              _icon(Icons.format_quote, 'Trích dẫn', () => _prefix('> '),
                  active: _quote),
              _icon(Icons.horizontal_rule, 'Ngăn cách',
                  () => _apply(insertDivider)),
              _icon(Icons.image, 'Chèn ảnh', () => _insert('![](https://)')),
              _icon(Icons.link, 'Chèn liên kết', () => _insert('[]()')),
              _icon(Icons.table_chart, 'Bảng',
                  () => _insert('|  |  |\n|---|---|\n|  |  |')),
              const SizedBox(width: 16),
              Text(
                'Phím tắt: Tab để thụt dòng',
                style: theme.textTheme.bodySmall?.copyWith(
                  color: theme.colorScheme.outlineVariant,
                ),
              ),
            ]),
          );
        },
      ),
    );
  }

  Widget _sep() => Padding(
        padding: const EdgeInsets.symmetric(horizontal: 6),
        child: Container(
          width: 1,
          height: 18,
          color: Theme.of(context).colorScheme.outlineVariant,
        ),
      );

  Widget _text(String label, String tooltip, VoidCallback onTap,
          {TextStyle? style, bool active = false}) =>
      _wrap(
        tooltip: tooltip,
        onTap: onTap,
        active: active,
        child: Text(
          label,
          style: style?.copyWith(color: _fg(active), fontSize: 13) ??
              TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                  color: _fg(active)),
        ),
      );

  Widget _icon(IconData icon, String tooltip, VoidCallback onTap,
          {bool active = false}) =>
      _wrap(
        tooltip: tooltip,
        onTap: onTap,
        active: active,
        child: Icon(icon, size: 18, color: _fg(active)),
      );

  Color _fg(bool active) => active
      ? Theme.of(context).colorScheme.primary
      : Theme.of(context).colorScheme.onSurfaceVariant;

  Widget _wrap({
    required String tooltip,
    required VoidCallback onTap,
    required Widget child,
    bool active = false,
  }) =>
      Padding(
        padding: const EdgeInsets.symmetric(horizontal: 2),
        child: Tooltip(
          message: tooltip,
          child: InkWell(
            onTap: onTap,
            borderRadius: BorderRadius.circular(6),
            child: Container(
              constraints: const BoxConstraints(minWidth: 30, minHeight: 28),
              alignment: Alignment.center,
              padding: const EdgeInsets.symmetric(horizontal: 6),
              decoration: BoxDecoration(
                color: active
                    ? Theme.of(context)
                        .colorScheme
                        .primary
                        .withValues(alpha: .10)
                    : Colors.transparent,
                borderRadius: BorderRadius.circular(6),
              ),
              child: child,
            ),
          ),
        ),
      );
}
