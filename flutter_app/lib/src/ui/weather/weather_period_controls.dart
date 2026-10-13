import 'package:flutter/material.dart';

import '../../data/models.dart';
import '../theme.dart';
import '../tokens.dart';
import '../widgets/segmented_tabs.dart';
import 'weather_panels.dart';

/// The `Period controls` row: the view switcher on the left and the period
/// navigation (`‹ 11–17 tháng 10, 2026 ›`) on the right.
class WeatherPeriodControls<T> extends StatelessWidget {
  const WeatherPeriodControls({
    super.key,
    required this.options,
    required this.selected,
    required this.onChanged,
    required this.rangeLabel,
    required this.scale,
    this.inertTooltip,
    this.onPrevious,
    this.onNext,
  });

  final List<SegmentedTab<T>> options;
  final T selected;
  final ValueChanged<T> onChanged;

  /// `11–17 tháng 10, 2026`.
  final String rangeLabel;

  final double scale;

  /// Why both chevrons are inert, when no other period is stored yet.
  final String? inertTooltip;

  final VoidCallback? onPrevious;
  final VoidCallback? onNext;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    Widget chevron(IconData icon, String tooltip, VoidCallback? onTap) =>
        IconButton(
          tooltip: onTap == null ? (inertTooltip ?? tooltip) : tooltip,
          onPressed: onTap,
          visualDensity: VisualDensity.compact,
          icon: Icon(
            icon,
            size: 18 * scale,
            color: onTap == null
                ? theme.colorScheme.onSurfaceVariant.withValues(alpha: 0.4)
                : theme.colorScheme.onSurfaceVariant,
          ),
        );

    final navigation = Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        chevron(Icons.chevron_left, 'Kỳ trước', onPrevious),
        SizedBox(width: MemoirSpace.s2 * scale),
        Text(
          rangeLabel,
          style: theme.textTheme.labelLarge?.copyWith(
            color: theme.colorScheme.onSurface,
            fontSize: MemoirType.label,
          ),
        ),
        SizedBox(width: MemoirSpace.s2 * scale),
        chevron(Icons.chevron_right, 'Kỳ sau', onNext),
      ],
    );

    final switcher = SegmentedTabs<T>(
      options: options,
      selected: selected,
      onChanged: onChanged,
      scale: scale,
    );

    return LayoutBuilder(
      builder: (context, constraints) {
        if (constraints.maxWidth >= 640 * scale) {
          return Row(
            children: [switcher, const Spacer(), navigation],
          );
        }
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            switcher,
            SizedBox(height: MemoirSpace.s2 * scale),
            navigation,
          ],
        );
      },
    );
  }
}

/// The `Day selection` chip row of the `Ngày` and `Theo giờ` frames: one chip
/// per forecast day, carrying its weekday and date.
class WeatherDaySelection extends StatelessWidget {
  const WeatherDaySelection({
    super.key,
    required this.days,
    required this.selectedIndex,
    required this.onSelect,
    required this.scale,
  });

  final List<WeatherDay> days;
  final int selectedIndex;
  final ValueChanged<int> onSelect;
  final double scale;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final palette = MemoirPalette.of(context);

    return SizedBox(
      height: 58 * scale,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: days.length,
        separatorBuilder: (_, __) => SizedBox(width: MemoirSpace.s2 * scale),
        itemBuilder: (_, index) {
          final day = days[index];
          final selected = index == selectedIndex;
          return InkWell(
            borderRadius: BorderRadius.circular(MemoirRadius.weather10 * scale),
            onTap: () => onSelect(index),
            child: Container(
              width: 118 * scale,
              decoration: BoxDecoration(
                color: selected
                    ? palette.surfaceBrandSubtle
                    : theme.colorScheme.surfaceContainerHighest,
                borderRadius:
                    BorderRadius.circular(MemoirRadius.weather10 * scale),
                border: Border.all(
                  color: selected
                      ? theme.colorScheme.primary
                      : theme.colorScheme.outlineVariant,
                ),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    shortWeekday(day.date),
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: selected
                          ? theme.colorScheme.primary
                          : theme.colorScheme.onSurfaceVariant,
                      fontSize: MemoirType.caption,
                    ),
                  ),
                  SizedBox(height: 2 * scale),
                  Text(
                    shortDate(day.date),
                    style: theme.textTheme.labelLarge?.copyWith(
                      color: theme.colorScheme.onSurface,
                      fontSize: MemoirType.label,
                      fontWeight:
                          selected ? FontWeight.w600 : FontWeight.w400,
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
