import 'package:flutter/material.dart';

/// One-line text prompt used by the note editor (`Thêm dòng checklist`,
/// `Thêm thẻ`).
///
/// The controller belongs to this widget's [State] on purpose: `showDialog`
/// resolves as soon as the route is popped (`Route.didComplete` runs before the
/// pop transition), while the dialog stays in the tree for the rest of its exit
/// animation. A caller that disposes its own controller right after
/// `await showDialog(...)` leaves the still-mounted [TextField] holding a
/// disposed controller, which throws mid-close.
class TextPromptDialog extends StatefulWidget {
  const TextPromptDialog({
    super.key,
    required this.title,
    required this.hintText,
    this.confirmLabel = 'Thêm',
    this.cancelLabel = 'Huỷ',
  });

  /// Dialog heading, e.g. `Thêm dòng checklist`.
  final String title;

  /// Placeholder inside the field, e.g. `Việc cần làm...`.
  final String hintText;

  /// Label of the confirming action.
  final String confirmLabel;

  /// Label of the dismissing action.
  final String cancelLabel;

  @override
  State<TextPromptDialog> createState() => _TextPromptDialogState();
}

class _TextPromptDialogState extends State<TextPromptDialog> {
  final TextEditingController _text = TextEditingController();

  @override
  void dispose() {
    _text.dispose();
    super.dispose();
  }

  /// Pops the trimmed line. An empty line comes back as `''` — the caller
  /// decides whether it is worth keeping — while `null` means dismissed.
  void _submit() => Navigator.of(context).pop(_text.text.trim());

  @override
  Widget build(BuildContext context) => AlertDialog(
        title: Text(widget.title),
        content: TextField(
          controller: _text,
          autofocus: true,
          decoration: InputDecoration(hintText: widget.hintText),
          onSubmitted: (_) => _submit(),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text(widget.cancelLabel),
          ),
          FilledButton(
            onPressed: _submit,
            child: Text(widget.confirmLabel),
          ),
        ],
      );
}
