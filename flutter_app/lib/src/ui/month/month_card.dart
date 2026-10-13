import 'package:flutter/material.dart';

import '../../data/models.dart';
import '../home/home_scale.dart';
import '../theme.dart';
import '../tokens.dart';

/// One card of the `Lưới tháng` row: what the grid counts, how many days are
/// behind it, what it means, the grid, its legend and the caption under it.
///
/// The design's `Month record card` is 387×494, and the three of them make the
/// 1208 px row of the frame.
class MonthRecordCard extends StatelessWidget {
  const MonthRecordCard({
    super.key,
    required this.title,
    required this.countLabel,
    required this.explanation,
    required this.grid,
    required this.legend,
    required this.caption,
  });

  /// Design size of one card; the row is the three of them plus the gaps.
  static const double width = 387;
  static const double height = 494;

  final String title;

  /// E.g. "7 ngày đã viết".
  final String countLabel;

  /// One line explaining what a filled cell means.
  final String explanation;

  final Widget grid;
  final Widget legend;

  /// The "ô viền / ô trống / ô nhạt" line that closes the card.
  final String caption;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final muted = theme.colorScheme.onSurfaceVariant;
    final scale = HomeScale.of(context);

    return SizedBox(
      width: width * scale,
      height: height * scale,
      child: Card(
        child: Padding(
          padding: EdgeInsets.all(MemoirSpace.s6 * scale),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Expanded(
                    child: Text(
                      title,
                      style: theme.textTheme.labelLarge?.copyWith(
                        color: theme.colorScheme.onSurface,
                        fontSize: MemoirType.label,
                      ),
                    ),
                  ),
                  Text(
                    countLabel,
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: theme.colorScheme.primary,
                      fontSize: MemoirType.caption,
                    ),
                  ),
                ],
              ),
              SizedBox(height: MemoirSpace.custom6 * scale),
              Text(
                explanation,
                style: theme.textTheme.bodySmall?.copyWith(
                  color: muted,
                  fontSize: MemoirType.caption,
                ),
              ),
              SizedBox(height: MemoirSpace.s5 * scale),
              grid,
              const Spacer(),
              legend,
              SizedBox(height: MemoirSpace.s3 * scale),
              Text(
                caption,
                style: theme.textTheme.bodySmall?.copyWith(
                  color: muted,
                  fontSize: MemoirType.caption,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// `Ít ▢▢▢▢▢ Nhiều` — the shade ramp the journal grid uses
/// (`Activity legend` in the design).
class ActivityLegend extends StatelessWidget {
  const ActivityLegend({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scale = HomeScale.of(context);
    final shades = journalHeatmapScale(context);
    final label = theme.textTheme.bodySmall?.copyWith(
      color: theme.colorScheme.onSurfaceVariant,
      fontSize: MemoirType.caption,
    );

    return Row(
      children: [
        Text('Ít', style: label),
        SizedBox(width: MemoirSpace.s2 * scale),
        for (final color in shades)
          Container(
            width: 12 * scale,
            height: 12 * scale,
            margin: EdgeInsets.symmetric(horizontal: 1.5 * scale),
            decoration: BoxDecoration(
              color: color,
              borderRadius: BorderRadius.circular(3 * scale),
            ),
          ),
        SizedBox(width: MemoirSpace.s2 * scale),
        Text('Nhiều', style: label),
      ],
    );
  }
}

/// Swatch + label for every mood or weather (`Category legend` in the design).
class CategoryLegend extends StatelessWidget {
  const CategoryLegend({super.key, required this.items});

  final List<LookupItem> items;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scale = HomeScale.of(context);
    final label = theme.textTheme.bodySmall?.copyWith(
      color: theme.colorScheme.onSurfaceVariant,
      fontSize: MemoirType.caption,
    );

    return Wrap(
      spacing: MemoirSpace.s3 * scale,
      runSpacing: MemoirSpace.custom6 * scale,
      children: [
        for (final item in items)
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 12 * scale,
                height: 12 * scale,
                decoration: BoxDecoration(
                  color: colorFromHex(item.colorHex),
                  borderRadius: BorderRadius.circular(3 * scale),
                  border: Border.all(color: theme.colorScheme.outlineVariant),
                ),
              ),
              SizedBox(width: MemoirSpace.custom6 * scale),
              Text(item.label, style: label),
            ],
          ),
      ],
    );
  }
}
