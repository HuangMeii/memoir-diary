import 'package:flutter/material.dart';

import '../icons.dart';
import '../tokens.dart';

/// The design's "saved" bar: a dark pill with a check, the confirmation and a
/// close button.
///
/// It is rendered inline, right under the quick picks, instead of using a
/// [SnackBar] — Material always docks snackbars at the bottom of the screen,
/// while the design keeps this bar in the main column next to what changed.
class SavedBar extends StatelessWidget {
  const SavedBar({super.key, required this.message, required this.onClose});

  final String message;
  final VoidCallback onClose;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final onPrimary = theme.colorScheme.onPrimary;

    return Container(
      height: 45,
      padding: const EdgeInsets.symmetric(horizontal: MemoirSpace.s4),
      decoration: BoxDecoration(
        color: theme.colorScheme.primary,
        borderRadius: BorderRadius.circular(MemoirRadius.feedback),
      ),
      child: Row(
        children: [
          MemoirIcon('circle-check', size: 18, color: onPrimary),
          const SizedBox(width: MemoirSpace.s3),
          Expanded(
            child: Text(
              message,
              style: TextStyle(color: onPrimary, fontSize: MemoirType.body),
            ),
          ),
          IconButton(
            tooltip: 'Đóng',
            visualDensity: VisualDensity.compact,
            icon: Icon(Icons.close, size: 16, color: onPrimary),
            onPressed: onClose,
          ),
        ],
      ),
    );
  }
}
