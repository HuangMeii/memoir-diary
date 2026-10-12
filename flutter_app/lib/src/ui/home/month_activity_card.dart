import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../data/models.dart';
import '../../data/providers.dart';
import '../theme.dart';
import '../tokens.dart';
import 'activity_heatmap.dart';

/// "Nhịp viết của bạn": this month's writing rhythm as a shaded month grid.
///
/// A day is shaded by how complete its entry is — only the mood and weather
/// tapped scores the lightest step, a page with every question answered the
/// darkest. The month's entries are already fetched by [monthEntriesProvider],
/// so nothing new is asked of the server.
class MonthActivityCard extends ConsumerWidget {
  const MonthActivityCard({super.key, required this.month});

  final DateTime month;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final entries = ref.watch(monthEntriesProvider(monthKey(month)));

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(MemoirSpace.s6),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Nhịp viết của bạn',
                      style: theme.textTheme.labelLarge?.copyWith(
                        color: theme.colorScheme.onSurface,
                        fontSize: MemoirType.label,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      'Tháng ${month.month}, ${month.year}',
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: theme.colorScheme.onSurfaceVariant,
                        fontSize: MemoirType.caption,
                      ),
                    ),
                  ],
                ),
                const Spacer(),
                const _PeriodControl(),
              ],
            ),
            const SizedBox(height: MemoirSpace.s5),
            entries.when(
              loading: () => const Padding(
                padding: EdgeInsets.symmetric(vertical: MemoirSpace.s6),
                child: LinearProgressIndicator(),
              ),
              error: (e, _) => Padding(
                padding: const EdgeInsets.symmetric(vertical: MemoirSpace.s6),
                child: Text(
                  'Chưa tải được nhịp viết. $e',
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: theme.colorScheme.error,
                    fontSize: MemoirType.caption,
                  ),
                ),
              ),
              data: (byDate) => _ActivityBody(month: month, byDate: byDate),
            ),
          ],
        ),
      ),
    );
  }
}
class _ActivityBody extends StatelessWidget {
  const _ActivityBody({required this.month, required this.byDate});

  final DateTime month;
  final Map<String, DiaryEntry> byDate;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scale = journalHeatmapScale(context);

    final days = <String, ActivityDay>{
      for (final entry in byDate.entries)
        entry.key: ActivityDay(
          filled: entry.value.filledFields,
          total: DiaryEntry.contentFieldCount,
        ),
    };
    final written = days.values.where((day) => day.filled > 0).length;

    final now = DateTime.now();
    final todayWritten = days[dayKey(now)]?.filled ?? 0;
    final muted = theme.textTheme.bodySmall?.copyWith(
      color: theme.colorScheme.onSurfaceVariant,
      fontSize: MemoirType.caption,
    );

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ActivityHeatmap(month: month, days: days, monthLabel: 'Tuần'),
            const SizedBox(width: MemoirSpace.s6),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '$written ngày',
                    style: TextStyle(
                      fontFamily: serifFamily,
                      fontSize: MemoirType.heading1,
                      height: 1.2,
                      color: theme.colorScheme.primary,
                    ),
                  ),
                  const SizedBox(height: MemoirSpace.custom6),
                  Text(
                    'đã viết trong tháng này. Mỗi ô nhỏ là một lần dành thời gian cho mình.',
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: theme.colorScheme.onSurfaceVariant,
                      fontSize: MemoirType.body,
                    ),
                  ),
                  const SizedBox(height: MemoirSpace.s3),
                  Text(
                    '${now.day.toString().padLeft(2, '0')}.'
                    '${now.month.toString().padLeft(2, '0')} · '
                    '${todayWritten > 0 ? 'Hôm nay đã viết' : 'Hôm nay chưa viết'}',
                    style: muted,
                  ),
                ],
              ),
            ),
          ],
        ),
        const SizedBox(height: MemoirSpace.s5),
        Row(
          children: [
            Expanded(
              child: Text('Ô viền: hôm nay · Ô nhạt: ngày tới', style: muted),
            ),
            Text('Ít', style: muted),
            const SizedBox(width: MemoirSpace.custom6),
            for (final color in scale)
              Container(
                width: 10,
                height: 10,
                margin: const EdgeInsets.symmetric(horizontal: 1.5),
                decoration: BoxDecoration(
                  color: color,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            const SizedBox(width: MemoirSpace.custom6),
            Text('Nhiều', style: muted),
          ],
        ),
      ],
    );
  }
}
/// The `Tuần | Tháng | Năm` segmented control.
///
/// Only "Tháng" has data behind it so far, so the other two render dimmed
/// instead of pretending to switch the view.
class _PeriodControl extends StatelessWidget {
  const _PeriodControl();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    Widget segment(String label, {required bool selected}) {
      return Container(
        padding: const EdgeInsets.symmetric(
          horizontal: MemoirSpace.s3,
          vertical: MemoirSpace.custom7,
        ),
        decoration: BoxDecoration(
          color: selected ? theme.colorScheme.surface : Colors.transparent,
          borderRadius: BorderRadius.circular(MemoirRadius.control),
        ),
        child: Text(
          label,
          style: theme.textTheme.bodySmall?.copyWith(
            color: selected
                ? theme.colorScheme.primary
                : theme.colorScheme.onSurfaceVariant.withValues(alpha: 0.5),
            fontSize: MemoirType.body,
            fontWeight: selected ? FontWeight.w600 : FontWeight.w400,
          ),
        ),
      );
    }

    return Tooltip(
      message: 'Chế độ Tuần và Năm sẽ có sau',
      child: Container(
        padding: const EdgeInsets.all(3),
        decoration: BoxDecoration(
          color: theme.colorScheme.surfaceContainerHighest,
          borderRadius: BorderRadius.circular(MemoirRadius.control + 3),
          border: Border.all(color: theme.colorScheme.outlineVariant),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            segment('Tuần', selected: false),
            segment('Tháng', selected: true),
            segment('Năm', selected: false),
          ],
        ),
      ),
    );
  }
}


