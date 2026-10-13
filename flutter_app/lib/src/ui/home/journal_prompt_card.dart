import 'package:flutter/material.dart';

import '../icons.dart';
import '../theme.dart';
import '../tokens.dart';
import 'home_scale.dart';

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
    final scale = HomeScale.of(context);

    return Container(
      padding: EdgeInsets.all(MemoirSpace.s6 * scale),
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
          SizedBox(height: MemoirSpace.s3 * scale),
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
          SizedBox(height: MemoirSpace.s3 * scale),
          Text(
            written
                ? 'Bạn đã ghi lại hôm nay. Mở lại trang để viết thêm nếu muốn.'
                : 'Chưa có bài viết hôm nay. Bắt đầu từ một điều nhỏ bạn muốn nhớ.',
            style: theme.textTheme.bodySmall?.copyWith(
              color: theme.colorScheme.onSurfaceVariant,
              fontSize: MemoirType.body,
            ),
          ),
          SizedBox(height: MemoirSpace.s5 * scale),
          SizedBox(
            width: double.infinity,
            child: FilledButton.icon(
              // The theme pins the button to 48 px; the home scales with the
              // rest of the design. `Size(0, …)` rather than
              // `Size.fromHeight(…)`: the latter's width is infinite, which a
              // `Row` cannot lay out.
              style: FilledButton.styleFrom(
                minimumSize: Size(0, 48 * scale),
              ),
              onPressed: onOpen,
              icon: MemoirIcon(
                'square-pen',
                size: 18 * scale,
                color: Colors.white,
              ),
              label: Text(written ? 'Mở trang hôm nay' : 'Viết nhật ký hôm nay'),
            ),
          ),
        ],
      ),
    );
  }
}
