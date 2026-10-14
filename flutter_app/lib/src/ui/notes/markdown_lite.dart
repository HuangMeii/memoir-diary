/// Pure markdown-lite helpers for the note editor toolbar.
///
/// Every function takes the current text plus selection and returns the new
/// text plus selection, so they are unit-testable without a widget.
library;

import 'package:flutter/material.dart';

/// Result of a markdown edit: new text and where the caret should land.
typedef MarkdownEdit = ({String text, TextSelection selection});

/// Toggles `marker` around the selection (bold/italic/underline/strike).
MarkdownEdit toggleInline(String text, TextSelection sel, String marker) {
  if (!sel.isValid || sel.start < 0 || sel.end > text.length) {
    return (text: text, selection: sel);
  }
  final start = sel.start;
  final end = sel.end;
  if (start == end) {
    final updated = text.replaceRange(start, start, '$marker$marker');
    final caret = start + marker.length;
    return (
      text: updated,
      selection: TextSelection.collapsed(offset: caret),
    );
  }
  final selected = text.substring(start, end);
  if (selected.startsWith(marker) &&
      selected.endsWith(marker) &&
      selected.length >= marker.length * 2) {
    final inner = selected.substring(
      marker.length,
      selected.length - marker.length,
    );
    final updated = text.replaceRange(start, end, inner);
    return (
      text: updated,
      selection:
          TextSelection(baseOffset: start, extentOffset: start + inner.length),
    );
  }
  final updated = text.replaceRange(start, end, '$marker$selected$marker');
  return (
    text: updated,
    selection: TextSelection(
      baseOffset: start,
      extentOffset: end + marker.length * 2,
    ),
  );
}

/// Toggles a line prefix (`# `, `- `, `> `, …) on the current line.
MarkdownEdit prefixLine(String text, TextSelection sel, String prefix) {
  if (!sel.isValid || sel.start < 0 || sel.end > text.length) {
    return (text: text, selection: sel);
  }
  final lineStart = text.lastIndexOf('\n', sel.start - 1) + 1;
  final lineEnd = text.indexOf('\n', sel.start);
  final end = lineEnd < 0 ? text.length : lineEnd;
  final line = text.substring(lineStart, end);
  if (line.startsWith(prefix)) {
    final updated = text.replaceRange(
      lineStart,
      lineStart + prefix.length,
      '',
    );
    final shift = prefix.length;
    return (
      text: updated,
      selection: TextSelection(
        baseOffset: (sel.start - shift).clamp(lineStart, updated.length),
        extentOffset: (sel.end - shift).clamp(lineStart, updated.length),
      ),
    );
  }
  final updated = text.replaceRange(lineStart, lineStart, prefix);
  return (
    text: updated,
    selection: TextSelection(
      baseOffset: sel.start + prefix.length,
      extentOffset: sel.end + prefix.length,
    ),
  );
}

/// Inserts a `- [ ] ` checklist line at the caret.
MarkdownEdit insertChecklist(String text, TextSelection sel) {
  const insert = '- [ ] ';
  if (!sel.isValid) return (text: text, selection: sel);
  final atLineStart = sel.start == 0 || text[sel.start - 1] == '\n';
  final payload = atLineStart ? insert : '\n$insert';
  final updated = text.replaceRange(sel.start, sel.end, payload);
  final caret = sel.start + payload.length;
  return (text: updated, selection: TextSelection.collapsed(offset: caret));
}

/// Inserts a `---` divider on its own line.
MarkdownEdit insertDivider(String text, TextSelection sel) {
  if (!sel.isValid) return (text: text, selection: sel);
  final before = sel.start == 0 || text[sel.start - 1] == '\n' ? '' : '\n';
  final payload = '$before---\n';
  final updated = text.replaceRange(sel.start, sel.end, payload);
  final caret = sel.start + payload.length;
  return (text: updated, selection: TextSelection.collapsed(offset: caret));
}

/// Whether the caret line currently carries a checklist marker.
bool lineHasChecklist(String text, int offset) {
  if (text.isEmpty) return false;
  final safe = offset.clamp(0, text.length);
  final lineStart = text.lastIndexOf('\n', safe - 1) + 1;
  return text.substring(lineStart).startsWith('- [ ] ') ||
      text.substring(lineStart).startsWith('- [x] ');
}
