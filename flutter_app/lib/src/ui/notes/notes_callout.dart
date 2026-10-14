import 'package:flutter/material.dart';

import '../theme.dart';
import '../tokens.dart';

/// Callout at the end of the notes list promoting diary links.
class NotesCallout extends StatelessWidget {
  const NotesCallout({super.key, this.onExplore});

  final VoidCallback? onExplore;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final palette = MemoirPalette.of(context);
    return Container(
      padding: const EdgeInsets.all(MemoirSpace.s6),
      decoration: BoxDecoration(
        color: palette.surfaceBrandSubtle,
        borderRadius: BorderRadius.circular(MemoirRadius.card),
        border: Border.all(color: theme.colorScheme.outlineVariant),
      ),
      child: LayoutBuilder(
        builder: (context, constraints) {
          final narrow = constraints.maxWidth < 600;
          final text = Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  color: theme.colorScheme.primaryContainer,
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  Icons.menu_book,
                  color: theme.colorScheme.primary,
                ),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Kết nối ghi chú cùng dòng nhật ký của bạn',
                      style: theme.textTheme.headlineSmall?.copyWith(
                        fontFamily: serifFamily,
                        fontSize: MemoirType.headingEditorial,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      'Biến từng ý tưởng thoáng qua thành những trang nhật ký '
                      'đong đầy kỷ niệm. Mỗi ghi chú đều có thể liên kết trực '
                      'tiếp vào bài viết ngày tương ứng.',
                      style: theme.textTheme.bodyMedium,
                    ),
                  ],
                ),
              ),
            ],
          );
          final button = OutlinedButton.icon(
            onPressed: onExplore,
            icon: const Icon(Icons.hub_outlined, size: 18),
            label: const Text('Khám phá liên kết'),
          );
          if (narrow) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [text, const SizedBox(height: 14), button],
            );
          }
          return Row(
            children: [
              Expanded(child: text),
              const SizedBox(width: 16),
              button
            ],
          );
        },
      ),
    );
  }
}
