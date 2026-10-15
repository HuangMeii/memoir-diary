import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../data/models.dart';
import '../icons.dart';
import '../theme.dart';
import '../tokens.dart';
import 'route_segments.dart';

/// "305 km" / "18,4 km" — the distance labels the route panels use.
String formatKm(num meters) {
  final km = meters / 1000;
  if (km >= 100) return '${km.round()} km';
  return '${km.toStringAsFixed(1).replaceAll('.', ',')} km';
}

/// "3 giờ 54 phút" / "45 phút" / "2 giờ".
String formatDuration(int seconds) {
  final total = (seconds / 60).round();
  final hours = total ~/ 60;
  final minutes = total % 60;
  if (hours == 0) return '$minutes phút';
  if (minutes == 0) return '$hours giờ';
  return '$hours giờ $minutes phút';
}

/// "11.10.2026".
String formatDay(DateTime at) => DateFormat('dd.MM.yyyy').format(at.toLocal());

/// "06:30" in the device's timezone.
String formatClock(DateTime at) => DateFormat('HH:mm').format(at.toLocal());

/// "06:30 · 11.10.2026".
String formatClockDay(DateTime at) => '${formatClock(at)} · ${formatDay(at)}';

/// The colour a severity paints its chip and callout with.
Color routeSeverityColor(BuildContext context, String severity) =>
    switch (severity) {
      RouteSeverity.warning => Theme.of(context).colorScheme.error,
      RouteSeverity.caution => MemoirPalette.of(context).warningText,
      _ => Theme.of(context).colorScheme.primary,
    };

/// The colour the route line is drawn with along a stretch of [bucket].
///
/// The map answers one question - "will this stretch be ridden through rain?" -
/// so the line carries the *weather*, not the severity: a wet stretch takes the
/// route rain blue, a dry one takes the route pale yellow. The chips, the
/// safety callout and the departure comparison
/// keep the severity scale ([routeSeverityColor]), which is another question.
///
/// A stretch the forecast does not cover is never painted: only the grey bed
/// underneath shows there, and it has no entry in the legend.
Color routeWeatherLineColor(BuildContext context, String bucket) {
  final palette = MemoirPalette.of(context);
  return switch (bucket) {
    RouteWeatherBucket.rain => palette.routeRainLine,
    RouteWeatherBucket.sun => palette.routeSunLine,
    _ => palette.textDisabled.withValues(alpha: 0.45),
  };
}

/// The background a severity paints its chip with.
Color routeSeveritySurface(BuildContext context, String severity) =>
    switch (severity) {
      RouteSeverity.warning => Theme.of(context).colorScheme.errorContainer,
      RouteSeverity.caution => MemoirPalette.of(context).warningSurface,
      _ => MemoirPalette.of(context).surfaceBrandSubtle,
    };

/// "Thuận lợi" / "Cần chú ý" / "Cảnh báo".
class RouteSeverityChip extends StatelessWidget {
  const RouteSeverityChip({super.key, required this.severity, this.scale = 1});

  final String severity;
  final double scale;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: MemoirSpace.s2 * scale,
        vertical: 2 * scale,
      ),
      decoration: BoxDecoration(
        color: routeSeveritySurface(context, severity),
        borderRadius: BorderRadius.circular(MemoirRadius.pill),
      ),
      child: Text(
        RouteSeverity.label(severity),
        style: Theme.of(context).textTheme.bodySmall?.copyWith(
              color: routeSeverityColor(context, severity),
              fontSize: MemoirType.caption,
              fontWeight: FontWeight.w600,
            ),
      ),
    );
  }
}

/// A weather icon drawn from the app's own set, so the route panels match the
/// rest of Memoir instead of introducing a second icon language.
class RouteWeatherIcon extends StatelessWidget {
  const RouteWeatherIcon({
    super.key,
    required this.group,
    this.size = 18,
    this.color,
  });

  /// A `weathers.code` group: sunny | cloudy | rainy | storm | other.
  final String? group;
  final double size;
  final Color? color;

  @override
  Widget build(BuildContext context) => MemoirIcon(
        weatherIcon(group),
        size: size,
        color: color ?? Theme.of(context).colorScheme.primary,
      );
}

/// The vehicles the routing API can plan for, in the order the design lists
/// them. `transit` is deliberately absent: OSRM has no transit profile.
const List<({String code, String label})> routeVehicles = [
  (code: 'car', label: 'Ô tô'),
  (code: 'bike', label: 'Xe đạp'),
  (code: 'foot', label: 'Đi bộ'),
];

/// "Ô tô" / "Xe đạp" / "Đi bộ", falling back to the car.
String vehicleLabel(String code) => routeVehicles
    .firstWhere((v) => v.code == code, orElse: () => routeVehicles.first)
    .label;

/// One titled panel: the shape every section of the route screen uses.
class RouteSection extends StatelessWidget {
  const RouteSection({
    super.key,
    required this.title,
    required this.child,
    this.overline,
    this.subtitle,
    this.trailing,
    this.tone,
    this.scale = 1,
  });

  final String title;
  final Widget child;

  /// Small uppercase label above the title.
  final String? overline;

  /// Muted line under the title.
  final String? subtitle;

  /// Optional control on the same row as the title.
  final Widget? trailing;

  /// Overrides the panel background, used by the amber safety callout.
  final Color? tone;

  final double scale;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final palette = MemoirPalette.of(context);

    return Container(
      padding: EdgeInsets.all(MemoirSpace.s5 * scale),
      decoration: BoxDecoration(
        color: tone ?? palette.surfaceCard,
        border: Border.all(color: palette.borderDefault),
        borderRadius: BorderRadius.circular(MemoirRadius.card * scale),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (overline != null) ...[
            Text(
              overline!.toUpperCase(),
              style: theme.textTheme.bodySmall?.copyWith(
                color: theme.colorScheme.primary,
                fontSize: MemoirType.caption,
                letterSpacing: 0.6,
                fontWeight: FontWeight.w600,
              ),
            ),
            SizedBox(height: MemoirSpace.s1 * scale),
          ],
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: theme.textTheme.titleMedium?.copyWith(
                        color: theme.colorScheme.onSurface,
                        fontSize: MemoirType.label + 2,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    if (subtitle != null) ...[
                      SizedBox(height: 2 * scale),
                      Text(
                        subtitle!,
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: theme.colorScheme.onSurfaceVariant,
                          fontSize: MemoirType.body,
                        ),
                      ),
                    ],
                  ],
                ),
              ),
              if (trailing != null) ...[
                SizedBox(width: MemoirSpace.s3 * scale),
                trailing!,
              ],
            ],
          ),
          SizedBox(height: MemoirSpace.s4 * scale),
          child,
        ],
      ),
    );
  }
}

/// The muted line that closes a section: a source, a caveat, a disclaimer.
class RouteNote extends StatelessWidget {
  const RouteNote({
    super.key,
    required this.message,
    this.icon,
    this.scale = 1,
  });

  final String message;
  final IconData? icon;
  final double scale;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final style = theme.textTheme.bodySmall?.copyWith(
      color: theme.colorScheme.onSurfaceVariant,
      fontSize: MemoirType.caption,
    );

    if (icon == null) return Text(message, style: style);

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, size: 13 * scale, color: theme.colorScheme.primary),
        SizedBox(width: MemoirSpace.custom6 * scale),
        Expanded(child: Text(message, style: style)),
      ],
    );
  }
}

/// A figure with a caption: the summary strip and the metric rows.
class RouteMetric extends StatelessWidget {
  const RouteMetric({
    super.key,
    required this.label,
    required this.value,
    this.icon,
    this.scale = 1,
  });

  final String label;
  final String value;
  final IconData? icon;
  final double scale;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Row(
          children: [
            if (icon != null) ...[
              Icon(icon, size: 12 * scale, color: theme.colorScheme.primary),
              SizedBox(width: MemoirSpace.custom6 * scale),
            ],
            Text(
              label,
              style: theme.textTheme.bodySmall?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
                fontSize: MemoirType.caption,
              ),
            ),
          ],
        ),
        SizedBox(height: 2 * scale),
        Text(
          value,
          style: theme.textTheme.titleSmall?.copyWith(
            color: theme.colorScheme.onSurface,
            fontSize: MemoirType.label,
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }
}

/// The rows of figures in the live-data block, ruled like a table.
///
/// Wide enough for the frame's `lg:grid-cols-4`, the cells sit on one row with
/// a line between them; as the window narrows they reflow to two and then one
/// column, with a line between the rows as well. Ruling them into a grid keeps
/// the figures in columns, where a `Wrap` of the same cells lets a long value
/// shuffle its neighbours along.
class RouteMetricTable extends StatelessWidget {
  const RouteMetricTable({
    super.key,
    required this.cells,
    this.scale = 1,
    this.minColumnWidth = 160,
    this.maxColumns = 4,
  });

  /// One cell per figure, in reading order.
  final List<RouteMetric> cells;

  final double scale;

  /// Narrowest a column may get, in design pixels, before the cells reflow.
  final double minColumnWidth;

  /// Columns on the widest window: the frame's four-figure strip.
  final int maxColumns;

  /// How many cells share a row of [width]: at least one, at most [maxColumns].
  static int columnsFor(double width, double minColumnWidth, int maxColumns) {
    if (width <= 0 || minColumnWidth <= 0) return 1;
    return math.max(1, math.min(maxColumns, (width / minColumnWidth).floor()));
  }

  @override
  Widget build(BuildContext context) {
    final palette = MemoirPalette.of(context);

    return LayoutBuilder(
      builder: (context, constraints) {
        final columns = columnsFor(
          constraints.maxWidth / scale,
          minColumnWidth,
          maxColumns,
        );
        final rows = [
          for (var start = 0; start < cells.length; start += columns)
            cells.sublist(start, math.min(start + columns, cells.length)),
        ];

        return Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            for (var row = 0; row < rows.length; row++)
              IntrinsicHeight(
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    for (var column = 0; column < rows[row].length; column++)
                      Expanded(
                        child: Container(
                          padding: EdgeInsets.only(
                            left: column == 0 ? 0 : MemoirSpace.s4 * scale,
                            top: row == 0 ? 0 : MemoirSpace.s3 * scale,
                            right: column == rows[row].length - 1
                                ? 0
                                : MemoirSpace.s4 * scale,
                            bottom: row == rows.length - 1
                                ? 0
                                : MemoirSpace.s3 * scale,
                          ),
                          decoration: BoxDecoration(
                            border: Border(
                              left: column == 0
                                  ? BorderSide.none
                                  : BorderSide(color: palette.borderDefault),
                              top: row == 0
                                  ? BorderSide.none
                                  : BorderSide(color: palette.borderDefault),
                            ),
                          ),
                          child: rows[row][column],
                        ),
                      ),
                  ],
                ),
              ),
          ],
        );
      },
    );
  }
}
