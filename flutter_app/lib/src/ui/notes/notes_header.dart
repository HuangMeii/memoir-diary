import 'package:flutter/material.dart';

import '../home/home_scale.dart';
import '../theme.dart';
import '../tokens.dart';

/// Page header: serif title, count chip, subtitle and two actions.
class NotesPageHeader extends StatelessWidget {
  const NotesPageHeader({
    super.key,
    required this.count,
    required this.onTrash,
    required this.onCreate,
  });

  final int count;
  final VoidCallback onTrash;
  final VoidCallback onCreate;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scale = HomeScale.textOf(context);
    return LayoutBuilder(
      builder: (context, constraints) {
        final narrow = constraints.maxWidth < 768;
        final title = Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Wrap(
              crossAxisAlignment: WrapCrossAlignment.center,
              spacing: 10,
              children: [
                Text(
                  'Ghi chú',
                  style: theme.textTheme.displaySmall?.copyWith(
                    fontFamily: serifFamily,
                    fontSize: MemoirType.headingPage * scale,
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 3,
                  ),
                  decoration: BoxDecoration(
                    color: MemoirPalette.of(context).surfaceBrandSubtle,
                    borderRadius: BorderRadius.circular(MemoirRadius.pill),
                  ),
                  child: Text(
                    '$count ghi chú',
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: theme.colorScheme.primary,
                      fontSize: MemoirType.caption,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 6),
            Text(
              'Lưu giữ ý tưởng, thông tin và những điều quan trọng của bạn '
              'trong không gian giấy mộc tĩnh lặng.',
              style: theme.textTheme.bodyMedium?.copyWith(
                fontSize: MemoirType.body * scale,
              ),
            ),
          ],
        );
        if (narrow) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              title,
              const SizedBox(height: 14),
              OutlinedButton.icon(
                onPressed: onTrash,
                icon: const Icon(Icons.delete_outline, size: 18),
                label: const Text('Xem thùng rác'),
              ),
              const SizedBox(height: 10),
              FilledButton.icon(
                onPressed: onCreate,
                icon: const Icon(Icons.add, size: 18),
                label: const Text('Ghi chú mới'),
              ),
              const Divider(height: 28),
            ],
          );
        }
        return Column(
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Expanded(child: title),
                OutlinedButton.icon(
                  onPressed: onTrash,
                  icon: const Icon(Icons.delete_outline, size: 18),
                  label: const Text('Xem thùng rác'),
                ),
                const SizedBox(width: 12),
                FilledButton.icon(
                  onPressed: onCreate,
                  icon: const Icon(Icons.add, size: 18),
                  label: const Text('Ghi chú mới'),
                ),
              ],
            ),
            const Divider(height: 28),
          ],
        );
      },
    );
  }
}

/// Slim banner shown when browsing trash.
class NotesTrashHeader extends StatelessWidget {
  const NotesTrashHeader({
    super.key,
    required this.count,
    required this.onExit,
  });

  final int count;
  final VoidCallback onExit;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final palette = MemoirPalette.of(context);
    return Container(
      padding: const EdgeInsets.all(MemoirSpace.s4),
      decoration: BoxDecoration(
        color: palette.warningSurface,
        borderRadius: BorderRadius.circular(MemoirRadius.card),
        border: Border.all(color: theme.colorScheme.outlineVariant),
      ),
      child: Row(
        children: [
          Icon(Icons.delete_outline, color: palette.warningText),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              'Đang xem thùng rác · $count ghi chú',
              style: theme.textTheme.labelLarge?.copyWith(
                fontSize: MemoirType.label,
              ),
            ),
          ),
          TextButton(onPressed: onExit, child: const Text('Thoát thùng rác')),
        ],
      ),
    );
  }
}
