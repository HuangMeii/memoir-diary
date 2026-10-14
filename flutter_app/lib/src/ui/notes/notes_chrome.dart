import 'package:flutter/material.dart';

import '../tokens.dart';

/// Breadcrumb "Trang chủ / Ghi chú" for the notes list.
class NotesBreadcrumb extends StatelessWidget {
  const NotesBreadcrumb({super.key, this.onHome});

  final VoidCallback? onHome;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Row(
      children: [
        InkWell(
          onTap: onHome ?? () => Navigator.of(context).maybePop(),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(Icons.arrow_back, size: 14),
              const SizedBox(width: 4),
              Text(
                'Trang chủ',
                style: theme.textTheme.bodySmall?.copyWith(
                  fontSize: MemoirType.caption,
                ),
              ),
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 6),
          child: Text(
            '/',
            style: theme.textTheme.bodySmall?.copyWith(
              color: theme.colorScheme.outline,
            ),
          ),
        ),
        Text(
          'Ghi chú',
          style: theme.textTheme.bodySmall?.copyWith(
            color: theme.colorScheme.primary,
            fontWeight: FontWeight.w600,
            fontSize: MemoirType.caption,
          ),
        ),
      ],
    );
  }
}
