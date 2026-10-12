import 'package:flutter/material.dart';

import '../theme.dart';
import '../tokens.dart';
import '../screens/health_screen.dart';
import '../screens/month_grids_screen.dart';
import '../screens/notes_screen.dart';
import '../screens/planner_screen.dart';
import '../screens/quote_history_screen.dart';

/// One shortcut tile in the "GÓC NHỎ CỦA BẠN" grid.
class _Shortcut {
  const _Shortcut(this.title, this.detail, this.icon, this.builder);

  final String title;
  final String detail;
  final IconData icon;
  final Widget Function() builder;
}

/// The five shortcuts the design puts under the journal prompt.
///
/// Icons fall back to Material until the matching Figma SVGs are exported
/// (`calendar-days`, `sticky-note`, `list-checks`, `heart-pulse`).
const List<_Shortcut> _shortcuts = [
  _Shortcut('Lưới tháng', 'Nhìn lại từng ngày', Icons.calendar_month,
      MonthGridsScreen.new),
  _Shortcut('Ghi chú', 'Giữ một ý nghĩ nhỏ', Icons.sticky_note_2_outlined,
      NotesScreen.new),
  _Shortcut('Kế hoạch', 'Đi từng bước chậm', Icons.checklist, PlannerScreen.new),
  _Shortcut('Sức khỏe', 'Lắng nghe cơ thể', Icons.monitor_heart_outlined,
      HealthScreen.new),
  _Shortcut('Lịch sử câu nói', 'Những lời muốn giữ',
      Icons.format_quote_outlined, QuoteHistoryScreen.new),
];

/// Two-column shortcut grid for the dashboard's secondary column.
class ShortcutCards extends StatelessWidget {
  const ShortcutCards({super.key});

  /// One tile's width: two per 300 px column with a 10 px gap.
  static const double _tileWidth = 145;

  /// One tile's height, from the design.
  static const double _tileHeight = 92;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final palette = MemoirPalette.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'GÓC NHỎ CỦA BẠN',
          style: theme.textTheme.labelSmall?.copyWith(
            color: theme.colorScheme.primary,
            fontSize: MemoirType.overlineEditorial,
            letterSpacing: MemoirType.overlineEditorialLetterSpacing,
          ),
        ),
        const SizedBox(height: MemoirSpace.s3),
        Wrap(
          spacing: 10,
          runSpacing: 10,
          children: [
            for (final shortcut in _shortcuts)
              _ShortcutTile(shortcut: shortcut, palette: palette),
          ],
        ),
      ],
    );
  }
}

class _ShortcutTile extends StatelessWidget {
  const _ShortcutTile({required this.shortcut, required this.palette});

  final _Shortcut shortcut;
  final MemoirPalette palette;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return SizedBox(
      width: ShortcutCards._tileWidth,
      height: ShortcutCards._tileHeight,
      child: Material(
        color: palette.surfaceBrandSubtle,
        borderRadius: BorderRadius.circular(MemoirRadius.page),
        child: InkWell(
          borderRadius: BorderRadius.circular(MemoirRadius.page),
          onTap: () => Navigator.of(context).push(
            MaterialPageRoute<void>(builder: (_) => shortcut.builder()),
          ),
          child: Padding(
            padding: const EdgeInsets.all(MemoirSpace.s3),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Icon(shortcut.icon, size: 20, color: theme.colorScheme.primary),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      shortcut.title,
                      style: theme.textTheme.labelLarge?.copyWith(
                        color: theme.colorScheme.onSurface,
                        fontSize: MemoirType.label,
                      ),
                    ),
                    Text(
                      shortcut.detail,
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: theme.colorScheme.onSurfaceVariant,
                        fontSize: MemoirType.caption,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
