import 'package:flutter/material.dart';

import '../../data/models.dart';
import '../home/home_scale.dart';
import '../icons.dart';
import '../theme.dart';
import '../tokens.dart';

/// Weekday names in the order [DateTime.weekday] uses them.
const List<String> _weekdays = [
  'Thứ hai',
  'Thứ ba',
  'Thứ tư',
  'Thứ năm',
  'Thứ sáu',
  'Thứ bảy',
  'Chủ nhật',
];

/// "Chủ nhật, 11.10" — how `Lưới tháng` labels the day it points at.
String dayMonthLabel(DateTime date) {
  final day = date.day.toString().padLeft(2, '0');
  final month = date.month.toString().padLeft(2, '0');
  return '${_weekdays[date.weekday - 1]}, $day.$month';
}

/// `NGÀY ĐANG CHỌN` — the day the month grids point at, what is already stored
/// for it, and the way into the editor.
///
/// The design puts the date block on the left and the record on the right; on
/// narrow screens the two stack.
class SelectedDayDetails extends StatelessWidget {
  const SelectedDayDetails({
    super.key,
    required this.date,
    required this.isToday,
    required this.mood,
    required this.weather,
    required this.entry,
    required this.onWrite,
  });

  final DateTime date;

  /// Whether the selected day is today, which the overline spells out.
  final bool isToday;

  final LookupItem? mood;
  final LookupItem? weather;

  /// The day's entry, when it has one.
  final DiaryEntry? entry;

  final VoidCallback onWrite;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final palette = MemoirPalette.of(context);
    final scale = HomeScale.of(context);
    final muted = theme.colorScheme.onSurfaceVariant;
    final saved = [mood, weather].whereType<LookupItem>().toList();
    final written = (entry?.diaryText ?? '').trim().isNotEmpty;

    final dateBlock = Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          isToday ? 'NGÀY ĐANG CHỌN · HÔM NAY' : 'NGÀY ĐANG CHỌN',
          style: theme.textTheme.labelSmall?.copyWith(
            color: theme.colorScheme.primary,
            fontSize: MemoirType.overlineEditorial,
            letterSpacing: MemoirType.overlineEditorialLetterSpacing,
          ),
        ),
        SizedBox(height: MemoirSpace.s2 * scale),
        Text(
          dayMonthLabel(date),
          style: TextStyle(
            fontFamily: serifFamily,
            fontSize: MemoirType.headingEditorial,
            height: MemoirType.headingEditorialLineHeight /
                MemoirType.headingEditorial,
            color: theme.colorScheme.onSurface,
          ),
        ),
        SizedBox(height: MemoirSpace.s2 * scale),
        Text(
          saved.isEmpty
              ? 'Chưa lưu cảm xúc hay thời tiết cho ngày này.'
              : 'Cảm xúc và thời tiết đã được lưu.',
          style: theme.textTheme.bodySmall?.copyWith(
            color: muted,
            fontSize: MemoirType.caption,
          ),
        ),
      ],
    );

    final recordBlock = Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (saved.isNotEmpty) ...[
          Wrap(
            spacing: MemoirSpace.s5 * scale,
            runSpacing: MemoirSpace.s2 * scale,
            children: [
              for (final item in saved) _SavedCategory(item: item, scale: scale),
            ],
          ),
          SizedBox(height: MemoirSpace.s4 * scale),
        ],
        Text(
          written
              ? 'Trang nhật ký của ngày này đã có. Mở lại để viết thêm nếu muốn.'
              : 'Chưa có nhật ký hôm nay. Một điều nhỏ cũng đáng để giữ lại.',
          style: theme.textTheme.bodySmall?.copyWith(
            color: muted,
            fontSize: MemoirType.body,
          ),
        ),
        SizedBox(height: MemoirSpace.s5 * scale),
        // Fills the column. The theme only pins the height now, so the width
        // is asked for here — `Size.fromHeight` would have done it, but its
        // width is infinite, which a `Row` cannot lay out.
        SizedBox(
          width: double.infinity,
          child: FilledButton.icon(
            style: FilledButton.styleFrom(
              minimumSize: Size(0, 44 * scale),
            ),
            onPressed: onWrite,
            icon: MemoirIcon('square-pen', size: 18 * scale, color: Colors.white),
            label: Text(
              written
                  ? 'Mở trang nhật ký'
                  : isToday
                      ? 'Viết nhật ký hôm nay'
                      : 'Viết nhật ký ngày này',
            ),
          ),
        ),
      ],
    );

    return Container(
      padding: EdgeInsets.all(MemoirSpace.s6 * scale),
      decoration: BoxDecoration(
        color: palette.surfaceBrandSubtle,
        borderRadius: BorderRadius.circular(MemoirRadius.card),
      ),
      child: LayoutBuilder(
        builder: (context, constraints) {
          if (constraints.maxWidth < 700 * scale) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                dateBlock,
                SizedBox(height: MemoirSpace.s5 * scale),
                recordBlock,
              ],
            );
          }
          return Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(width: 240 * scale, child: dateBlock),
              SizedBox(width: MemoirSpace.s6 * scale),
              Expanded(child: recordBlock),
            ],
          );
        },
      ),
    );
  }
}

/// One stored mood or weather: the lookup's symbol next to its label.
class _SavedCategory extends StatelessWidget {
  const _SavedCategory({required this.item, required this.scale});

  final LookupItem item;
  final double scale;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(item.icon, style: TextStyle(fontSize: 18 * scale)),
        SizedBox(width: MemoirSpace.s2 * scale),
        Text(
          item.label,
          style: theme.textTheme.labelLarge?.copyWith(
            color: theme.colorScheme.primary,
            fontSize: MemoirType.label,
          ),
        ),
      ],
    );
  }
}
