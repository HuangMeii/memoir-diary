import 'package:flutter/material.dart';

import '../../data/models.dart';
import '../theme.dart';
import '../tokens.dart';
import 'route_format.dart';

/// One card per leg of the route: the `Chi tiết N chặng` row of the design.
///
/// A leg is described by the weather where it ends, and flagged by the worst
/// reading anywhere inside it, so a storm halfway through shows on the leg it
/// belongs to instead of only on the stop after it.
class RouteTimeline extends StatelessWidget {
  const RouteTimeline({
    super.key,
    required this.plan,
    required this.report,
    required this.selectedSeq,
    required this.onSelect,
    required this.scale,
  });

  final RoutePlan plan;
  final RouteWeatherReport report;
  final int? selectedSeq;
  final ValueChanged<RouteWeatherSample> onSelect;
  final double scale;

  @override
  Widget build(BuildContext context) {
    final stops = report.stopSamples;
    if (stops.length < 2) {
      return RouteNote(
        message: 'Chưa có điểm dừng nào để chia chặng.',
        scale: scale,
      );
    }

    return LayoutBuilder(
      builder: (context, constraints) {
        final columns = constraints.maxWidth >= 650
            ? 2
            : 1;
        final spacing = MemoirSpace.s3 * scale;
        final width =
            (constraints.maxWidth - spacing * (columns - 1)) / columns;

        return Wrap(
          spacing: spacing,
          runSpacing: spacing,
          children: [
            for (var i = 0; i < stops.length - 1; i++)
              SizedBox(
                width: width,
                child: _LegCard(
                  index: i,
                  from: stops[i],
                  to: stops[i + 1],
                  durationSeconds: i < plan.legs.length
                      ? plan.legs[i].durationSeconds
                      : plan.durationSeconds ~/ (stops.length - 1),
                  severity: _worstSeverity(stops[i], stops[i + 1]),
                  selected: selectedSeq == stops[i + 1].seq,
                  scale: scale,
                  onTap: () => onSelect(stops[i + 1]),
                ),
              ),
          ],
        );
      },
    );
  }

  /// Worst severity among the samples sitting between two stops.
  String _worstSeverity(RouteWeatherSample from, RouteWeatherSample to) {
    final inside = report.samples.where(
      (sample) =>
          sample.distanceFromStartMeters >= from.distanceFromStartMeters &&
          sample.distanceFromStartMeters <= to.distanceFromStartMeters,
    );
    return RouteSeverity.highest(inside.map((sample) => sample.severity));
  }
}

/// One leg: its clock window, where it ends, and the weather on the way.
class _LegCard extends StatelessWidget {
  const _LegCard({
    required this.index,
    required this.from,
    required this.to,
    required this.durationSeconds,
    required this.severity,
    required this.selected,
    required this.scale,
    required this.onTap,
  });

  final int index;
  final RouteWeatherSample from;
  final RouteWeatherSample to;
  final int durationSeconds;
  final String severity;
  final bool selected;
  final double scale;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final palette = MemoirPalette.of(context);
    final meta = theme.textTheme.bodySmall?.copyWith(
      color: theme.colorScheme.onSurfaceVariant,
      fontSize: MemoirType.caption,
    );

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(MemoirRadius.control * scale),
      child: Container(
        padding: EdgeInsets.all(MemoirSpace.s2 * scale),
        decoration: BoxDecoration(
          color: selected ? palette.surfaceBrandSubtle : palette.surfaceCard,
          border: Border.all(
            color: selected ? theme.colorScheme.primary : palette.borderDefault,
          ),
          borderRadius: BorderRadius.circular(MemoirRadius.control * scale),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: Text(
                    '${formatClock(from.arrivalAt)} — Chặng ${index + 1}',
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: theme.colorScheme.onSurface,
                      fontSize: MemoirType.caption,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                RouteSeverityChip(severity: severity, scale: scale),
              ],
            ),
            SizedBox(height: MemoirSpace.s1 * scale),
            Text(
              to.label,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: theme.textTheme.bodyMedium?.copyWith(
                color: theme.colorScheme.onSurface,
                fontSize: MemoirType.body,
                fontWeight: FontWeight.w600,
              ),
            ),
            Text(
              'Km ${(to.distanceFromStartMeters / 1000).round()} · '
              '${formatDuration(durationSeconds)} · '
              'đến ${formatClock(to.arrivalAt)}',
              style: meta,
            ),
            SizedBox(height: MemoirSpace.s1 * scale),
            Row(
              children: [
                RouteWeatherIcon(group: to.weatherGroup, size: 16 * scale),
                SizedBox(width: MemoirSpace.s1 * scale),
                Text(
                  to.tempC == null ? '—' : '${to.tempC!.round()}°C',
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: theme.colorScheme.onSurface,
                    fontSize: MemoirType.body,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const Spacer(),
                Text(
                  to.condition ?? (to.hasWeather ? '' : 'Không có dữ liệu'),
                  style: meta,
                ),
              ],
            ),
            SizedBox(height: MemoirSpace.s1 * scale),
            Text(
              'Mưa: ${to.precipitationProbability ?? 0}%'
              '${to.precipitationMm == null ? '' : ' · ${to.precipitationMm!.toStringAsFixed(1)} mm'}'
              ' · Gió: ${to.windSpeedKmh == null ? '—' : '${to.windSpeedKmh!.round()} km/h'}',
              style: meta,
            ),
            if (to.reasons.isNotEmpty) ...[
              SizedBox(height: MemoirSpace.s2 * scale),
              Text(
                to.reasons.join(' · '),
                style: theme.textTheme.bodySmall?.copyWith(
                  color: routeSeverityColor(context, severity),
                  fontSize: MemoirType.caption,
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

