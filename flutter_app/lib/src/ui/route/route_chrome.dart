import 'package:flutter/material.dart';

import '../../data/models.dart';
import '../theme.dart';
import '../tokens.dart';
import 'route_format.dart';

/// Breadcrumb of the route frame: `← Trang chủ / Tiện ích / Hành trình`.
class RouteBreadcrumb extends StatelessWidget {
  const RouteBreadcrumb({super.key, required this.scale, required this.onBack});

  final double scale;
  final VoidCallback onBack;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final brand = theme.colorScheme.primary;
    final muted = theme.textTheme.bodySmall?.copyWith(
      color: theme.colorScheme.onSurfaceVariant,
      fontSize: MemoirType.caption,
    );

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        InkWell(
          borderRadius: BorderRadius.circular(MemoirRadius.control * scale),
          onTap: onBack,
          child: Padding(
            padding: EdgeInsets.symmetric(
              vertical: MemoirSpace.s1 * scale,
              horizontal: 2 * scale,
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.arrow_back, size: 16 * scale, color: brand),
                SizedBox(width: MemoirSpace.s2 * scale),
                Text(
                  'Trang chủ',
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: brand,
                    fontSize: MemoirType.body,
                  ),
                ),
              ],
            ),
          ),
        ),
        SizedBox(width: MemoirSpace.s1 * scale),
        Text('/', style: muted),
        SizedBox(width: MemoirSpace.s1 * scale),
        Text('Tiện ích', style: muted),
        SizedBox(width: MemoirSpace.s1 * scale),
        Text('/', style: muted),
        SizedBox(width: MemoirSpace.s1 * scale),
        Text('Hành trình', style: muted),
      ],
    );
  }
}

/// The hero: what the screen is for, and the two things you can do from it.
class RouteHero extends StatelessWidget {
  const RouteHero({
    super.key,
    required this.scale,
    required this.comparing,
    this.onCompare,
    this.onSave,
    this.onSaved,
  });

  final double scale;

  /// Whether the departure comparison is on screen.
  final bool comparing;

  final VoidCallback? onCompare;
  final VoidCallback? onSave;

  /// Opens the list of trips already saved on the account.
  final VoidCallback? onSaved;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final actions = Wrap(
      spacing: MemoirSpace.s2 * scale,
      runSpacing: MemoirSpace.s2 * scale,
      children: [
        TextButton.icon(
          onPressed: onSaved,
          icon: Icon(Icons.bookmarks_outlined, size: 16 * scale),
          label: const Text('Hành trình đã lưu'),
        ),
        OutlinedButton.icon(
          onPressed: onCompare,
          icon: Icon(Icons.compare_arrows, size: 16 * scale),
          label: Text(comparing ? 'Ẩn so sánh giờ' : 'So sánh giờ khởi hành'),
        ),
        FilledButton.icon(
          onPressed: onSave,
          icon: Icon(Icons.bookmark_add_outlined, size: 16 * scale),
          label: const Text('Lưu vào nhật ký'),
        ),
      ],
    );

    final titles = Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'HÀNH TRÌNH & THỜI TIẾT',
          style: theme.textTheme.bodySmall?.copyWith(
            color: theme.colorScheme.primary,
            fontSize: MemoirType.caption,
            letterSpacing: 0.8,
            fontWeight: FontWeight.w600,
          ),
        ),
        SizedBox(height: MemoirSpace.s1 * scale),
        Text(
          'Thời tiết theo hành trình',
          style: theme.textTheme.headlineSmall?.copyWith(
            color: theme.colorScheme.onSurface,
            fontSize: MemoirType.label + 9,
            fontWeight: FontWeight.w600,
          ),
        ),
        SizedBox(height: MemoirSpace.s1 * scale),
        Text(
          'Chọn điểm đi, các điểm dừng và giờ khởi hành, rồi xem thời tiết dự '
          'kiến tại từng chặng trên đường.',
          style: theme.textTheme.bodyMedium?.copyWith(
            color: theme.colorScheme.onSurfaceVariant,
            fontSize: MemoirType.body,
          ),
        ),
      ],
    );

    return LayoutBuilder(
      builder: (context, constraints) {
        if (constraints.maxWidth < 720) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              titles,
              SizedBox(height: MemoirSpace.s3 * scale),
              actions,
            ],
          );
        }
        return Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(child: titles),
            SizedBox(width: MemoirSpace.s4 * scale),
            actions,
          ],
        );
      },
    );
  }
}

/// The live-data block under the band: where the data came from, and the
/// headline figures of the planned trip.
class RouteSummary extends StatelessWidget {
  const RouteSummary({
    super.key,
    required this.plan,
    required this.report,
    required this.scale,
    this.onRetryForecast,
  });

  final RoutePlan plan;
  final RouteWeatherReport report;
  final double scale;

  /// Reloads only the forecast for the plan already on screen, without
  /// re-planning the route (long routes time out on Open-Meteo, so a
  /// forecast-only retry is cheaper than rebuilding the whole query).
  final VoidCallback? onRetryForecast;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final palette = MemoirPalette.of(context);
    final samples = report.samples;

    // A cached answer is labelled with the moment it was taken, like the weather
    // screen does, so a stale forecast never reads as live.
    final source = report.isUnavailable
        ? 'Chưa có dữ liệu dự báo'
        : report.isStale
            ? 'Dữ liệu cũ · cập nhật ${formatClock(report.generatedAt)}'
            : 'Dữ liệu trực tiếp · OSRM · Open-Meteo';

    return Container(
      padding: EdgeInsets.all(MemoirSpace.s5 * scale),
      decoration: BoxDecoration(
        color: palette.surfaceCard,
        border: Border.all(color: palette.borderDefault),
        borderRadius: BorderRadius.circular(MemoirRadius.card * scale),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                Icons.explore,
                size: 16 * scale,
                color: theme.colorScheme.primary,
              ),
              SizedBox(width: MemoirSpace.s2 * scale),
              Expanded(
                child: Text(
                  source,
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: report.isStale || report.isUnavailable
                        ? palette.warningText
                        : theme.colorScheme.primary,
                    fontSize: MemoirType.caption,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              RouteSeverityChip(severity: report.worstSeverity, scale: scale),
            ],
          ),
          SizedBox(height: MemoirSpace.s4 * scale),
          RouteMetricTable(
            scale: scale,
            cells: [
              RouteMetric(
                label: 'Khoảng cách',
                value: formatKm(plan.distanceMeters),
                icon: Icons.straighten,
                scale: scale,
              ),
              RouteMetric(
                label: 'Thời gian di chuyển',
                value: formatDuration(plan.durationSeconds),
                icon: Icons.timer_outlined,
                scale: scale,
              ),
              RouteMetric(
                label: 'Khởi hành',
                value: samples.isEmpty
                    ? '—'
                    : formatClock(samples.first.arrivalAt),
                icon: Icons.schedule,
                scale: scale,
              ),
              RouteMetric(
                label: 'Đến dự kiến',
                value:
                    samples.isEmpty ? '—' : formatClock(samples.last.arrivalAt),
                icon: Icons.flag_outlined,
                scale: scale,
              ),
            ],
          ),
          for (final note in report.notes) ...[
            SizedBox(height: MemoirSpace.s3 * scale),
            RouteNote(icon: Icons.info_outline, message: note, scale: scale),
          ],
          if (report.isUnavailable && onRetryForecast != null) ...[
            SizedBox(height: MemoirSpace.s3 * scale),
            OutlinedButton.icon(
              onPressed: onRetryForecast,
              icon: const Icon(Icons.refresh, size: 16),
              label: const Text('Tải lại dự báo'),
            ),
          ],
        ],
      ),
    );
  }
}
