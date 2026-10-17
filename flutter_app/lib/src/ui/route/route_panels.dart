import 'package:flutter/material.dart';

import '../../data/models.dart';
import '../theme.dart';
import '../tokens.dart';
import 'route_format.dart';

/// The amber `Khuyến cáo an toàn` callout: the stretches where the forecast is
/// notable, already merged into one block per stretch by the server.
class RouteAlertsPanel extends StatelessWidget {
  const RouteAlertsPanel({
    super.key,
    required this.report,
    required this.onSelect,
    required this.scale,
  });

  final RouteWeatherReport report;

  /// Jumps to the first sample of a stretch when the callout is tapped.
  final ValueChanged<int> onSelect;

  final double scale;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final palette = MemoirPalette.of(context);
    final alerts = report.alerts;

    if (alerts.isEmpty) {
      return RouteSection(
        overline: 'Khuyến cáo an toàn',
        title: 'Chưa thấy đoạn nào đáng chú ý',
        scale: scale,
        child: RouteNote(
          icon: Icons.check_circle_outline,
          message: report.isUnavailable
              ? 'Chưa có dữ liệu thời tiết nên chưa đánh giá được hành trình.'
              : 'Theo dữ liệu hiện có, không đoạn nào vượt ngưỡng cảnh báo của '
                  'Memoir.',
          scale: scale,
        ),
      );
    }

    final worst = RouteSeverity.highest(alerts.map((alert) => alert.severity));

    return RouteSection(
      overline: 'Khuyến cáo an toàn · Cấp độ ${RouteSeverity.label(worst)}',
      title: alerts.length == 1
          ? alerts.first.title
          : '${alerts.length} đoạn cần chú ý trên hành trình',
      tone: routeSeveritySurface(context, worst),
      scale: scale,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          for (var i = 0; i < alerts.length; i++) ...[
            if (i > 0) SizedBox(height: MemoirSpace.s2 * scale),
            InkWell(
              onTap: () => onSelect(alerts[i].fromSeq),
              borderRadius:
                  BorderRadius.circular(MemoirRadius.control * scale),
              child: Padding(
                padding: EdgeInsets.symmetric(vertical: MemoirSpace.s3 * scale),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Icon(
                          Icons.warning_amber_rounded,
                          size: 16 * scale,
                          color: routeSeverityColor(context, alerts[i].severity),
                        ),
                        SizedBox(width: MemoirSpace.s2 * scale),
                        Expanded(
                          child: Text(
                            '${alerts[i].title} '
                            '(dự kiến ${formatClock(alerts[i].startAt)} – '
                            '${formatClock(alerts[i].endAt)})',
                            style: theme.textTheme.bodyMedium?.copyWith(
                              color: theme.colorScheme.onSurface,
                              fontSize: MemoirType.body,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                        RouteSeverityChip(
                          severity: alerts[i].severity,
                          scale: scale,
                        ),
                      ],
                    ),
                    SizedBox(height: MemoirSpace.s1 * scale),
                    Text(
                      alerts[i].summary,
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: theme.colorScheme.onSurfaceVariant,
                        fontSize: MemoirType.body,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
          Divider(height: MemoirSpace.s5 * scale, color: palette.borderDefault),
          RouteNote(
            icon: Icons.info_outline,
            message: 'Đây là ngưỡng hiển thị của Memoir dựa trên dữ liệu '
                'Open-Meteo, không phải khuyến nghị an toàn giao thông chính '
                'thức. Thời tiết có thể thay đổi; hãy quan sát thực tế khi đi.',
            scale: scale,
          ),
        ],
      ),
    );
  }
}

/// The `So sánh giờ khởi hành` panel: a few departure times, each with the
/// verdict of its own forecast.
class RouteDepartureCompare extends StatelessWidget {
  const RouteDepartureCompare({
    super.key,
    required this.options,
    required this.onApply,
    required this.scale,
  });

  final List<RouteDepartureOption> options;

  /// Moves the departure time to the picked option.
  final ValueChanged<RouteDepartureOption> onApply;

  final double scale;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final palette = MemoirPalette.of(context);

    if (options.isEmpty) {
      return RouteSection(
        overline: 'So sánh giờ khởi hành',
        title: 'Chưa có phương án nào',
        scale: scale,
        child: RouteNote(
          message: 'Hành trình cần được tính trước khi so sánh giờ khởi hành.',
          scale: scale,
        ),
      );
    }

    return RouteSection(
      overline: 'So sánh giờ khởi hành',
      title: 'Chọn khung giờ ít bất lợi nhất',
      subtitle: 'Mỗi khung giờ dùng dự báo tại đúng thời điểm đi qua.',
      scale: scale,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          for (final option in options)
            Container(
              margin: EdgeInsets.only(bottom: MemoirSpace.s2 * scale),
              padding: EdgeInsets.all(MemoirSpace.s3 * scale),
              decoration: BoxDecoration(
                color: option.isCurrent ? palette.surfaceBrandSubtle : null,
                border: Border.all(
                  color: option.isCurrent
                      ? theme.colorScheme.primary
                      : palette.borderDefault,
                ),
                borderRadius:
                    BorderRadius.circular(MemoirRadius.control * scale),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Text(
                              '${formatClock(option.departureAt)} → '
                              '${formatClock(option.arrivalAt)}',
                              style: theme.textTheme.bodyMedium?.copyWith(
                                color: theme.colorScheme.onSurface,
                                fontSize: MemoirType.body,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            SizedBox(width: MemoirSpace.s2 * scale),
                            if (option.isCurrent)
                              Text(
                                'Đang chọn',
                                style: theme.textTheme.bodySmall?.copyWith(
                                  color: theme.colorScheme.primary,
                                  fontSize: MemoirType.caption,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                          ],
                        ),
                        Text(
                          option.headline,
                          style: theme.textTheme.bodySmall?.copyWith(
                            color: routeSeverityColor(context, option.severity),
                            fontSize: MemoirType.caption,
                          ),
                        ),
                      ],
                    ),
                  ),
                  if (option.isCurrent)
                    RouteSeverityChip(severity: option.severity, scale: scale)
                  else
                    TextButton(
                      onPressed: () => onApply(option),
                      child: const Text(
                        'Áp dụng',
                        style: TextStyle(fontSize: 13),
                      ),
                    ),
                ],
              ),
            ),
        ],
      ),
    );
  }
}

