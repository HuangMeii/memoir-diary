import 'package:flutter/material.dart';

import '../icons.dart';
import '../theme.dart';
import '../tokens.dart';

/// Formats "TRANG NHẬT KÝ · dd.MM".
String _journalOverline(DateTime date) =>
    'TRANG NHẬT KÝ · ${date.day.toString().padLeft(2, '0')}.${date.month.toString().padLeft(2, '0')}';

/// The secondary column's invitation into today's journal page.
///
/// It is the web home's only call to action, so it switches wording between
/// "nothing written yet" and "the page is already open".
class JournalPromptCard extends StatelessWidget {
  const JournalPromptCard({
    super.key,
    required this.date,
    required this.written,
    required this.onOpen,
  });

  final DateTime date;

  /// True once the day has diary text — a mood alone still leaves the page open.
  final bool written;

  final VoidCallback onOpen;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final palette = MemoirPalette.of(context);

    return Container(
      padding: const EdgeInsets.all(MemoirSpace.s6),
      decoration: BoxDecoration(
        color: palette.surfaceBrandSubtle,
        borderRadius: BorderRadius.circular(MemoirRadius.card),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            _journalOverline(date),
            style: theme.textTheme.labelSmall?.copyWith(
              color: theme.colorScheme.primary,
              fontSize: MemoirType.overlineEditorial,
              letterSpacing: MemoirType.overlineEditorialLetterSpacing,
            ),
          ),
          const SizedBox(height: MemoirSpace.s3),
          Text(
            written ? 'Hôm nay đã có trang.' : 'Hôm nay còn chờ bạn.',
            style: TextStyle(
              fontFamily: serifFamily,
              fontSize: MemoirType.headingEditorial,
              height: MemoirType.headingEditorialLineHeight /
                  MemoirType.headingEditorial,
              color: theme.colorScheme.onSurface,
            ),
          ),
          const SizedBox(height: MemoirSpace.s3),
          Text(
            written
                ? 'Bạn đã ghi lại hôm nay. Mở lại trang để viết thêm nếu muốn.'
                : 'Chưa có bài viết hôm nay. Bắt đầu từ một điều nhỏ bạn muốn nhớ.',
            style: theme.textTheme.bodySmall?.copyWith(
              color: theme.colorScheme.onSurfaceVariant,
              fontSize: MemoirType.body,
            ),
          ),
          const SizedBox(height: MemoirSpace.s5),
          SizedBox(
            width: double.infinity,
            child: FilledButton.icon(
              onPressed: onOpen,
              icon: const MemoirIcon('square-pen', size: 18, color: Colors.white),
              label: Text(written ? 'Mở trang hôm nay' : 'Viết nhật ký hôm nay'),
            ),
          ),
        ],
      ),
    );
  }
}
