import 'package:flutter/material.dart';

import '../theme.dart';
import '../tokens.dart';

/// Invites the user to continue caring for a day in the journal.
class HealthJournalBridgeCard extends StatelessWidget {
  const HealthJournalBridgeCard({
    super.key,
    required this.onOpenJournal,
  });

  final VoidCallback onOpenJournal;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final palette = MemoirPalette.of(context);

    return Container(
      padding: const EdgeInsets.all(MemoirSpace.s5),
      decoration: BoxDecoration(
        color: palette.surfaceBrandSubtle,
        borderRadius: BorderRadius.circular(MemoirRadius.card),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(
            Icons.menu_book_outlined,
            color: theme.colorScheme.primary,
            size: 24,
          ),
          const SizedBox(height: MemoirSpace.s3),
          Text(
            'Kết nối sức khoẻ với Memoir Diary',
            style: theme.textTheme.titleMedium,
          ),
          const SizedBox(height: MemoirSpace.s2),
          Text(
            'Ghi lại điều cơ thể đang nói với bạn, để hôm nay được nhớ trọn vẹn hơn.',
            style: theme.textTheme.bodyMedium,
          ),
          const SizedBox(height: MemoirSpace.s3),
          TextButton(
            onPressed: onOpenJournal,
            child: const Text('Mở nhật ký hôm nay'),
          ),
        ],
      ),
    );
  }
}

/// A quiet editorial reminder shown beside the health dashboard.
class HealthGentleReminderCard extends StatelessWidget {
  const HealthGentleReminderCard({
    super.key,
    this.text,
    this.source,
  });

  static const defaultText =
      'Cơ thể bạn là ngôi đền duy nhất bạn có suốt cuộc đời. '
      'Đừng quá khắt khe với những ngày chưa chạm đến mục tiêu, chỉ cần '
      'lắng nghe và tiếp tục bước đi.';
  static const defaultSource = 'Trích Memoir Mindful Journal';

  final String? text;
  final String? source;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final palette = MemoirPalette.of(context);
    final quote = text?.trim().isNotEmpty == true ? text!.trim() : defaultText;
    final attribution =
        source?.trim().isNotEmpty == true ? source!.trim() : defaultSource;

    return Container(
      padding: const EdgeInsets.all(MemoirSpace.s5),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(MemoirRadius.card),
        border: Border.all(color: palette.borderDefault),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(
            Icons.spa_outlined,
            color: theme.colorScheme.primary,
            size: 22,
          ),
          const SizedBox(height: MemoirSpace.s3),
          Text(
            '“$quote”',
            style: TextStyle(
              color: theme.colorScheme.onSurface,
              fontFamily: serifFamily,
              fontSize: MemoirType.headingEditorial,
              height: MemoirType.headingEditorialLineHeight /
                  MemoirType.headingEditorial,
            ),
          ),
          const SizedBox(height: MemoirSpace.s3),
          Text(
            attribution,
            style: theme.textTheme.bodySmall?.copyWith(
              fontStyle: FontStyle.italic,
            ),
          ),
        ],
      ),
    );
  }
}
