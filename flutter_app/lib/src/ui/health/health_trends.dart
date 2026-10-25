import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fl_chart/fl_chart.dart';

import '../../data/models.dart';
import '../../data/providers.dart';
import '../home/home_scale.dart';
import '../theme.dart';
import '../tokens.dart';
import '../widgets/segmented_tabs.dart';
import 'health_metrics.dart';

/// Kỳ xem lại trên biểu đồ xu hướng → số ngày.
enum HealthTrendRange {
  week('7 ngày', 7),
  month('30 ngày', 30),
  quarter('3 tháng', 90);

  const HealthTrendRange(this.label, this.days);

  final String label;
  final int days;
}

/// Khối “Xu hướng 30 ngày gần nhất”: chọn metric, chọn kỳ, 4 ô số tổng hợp,
/// biểu đồ cột có đường mốc + đường trung bình, nhãn ngày và legend 3 mức.
///
/// Tính toán từ `healthTrendsProvider` (dữ liệu thật) qua `summarizeTrend`.
/// Không vẽ số mẫu: khi thiếu dữ liệu hiện trạng thái trống.
class HealthTrends extends ConsumerWidget {
  const HealthTrends({
    super.key,
    required this.date,
    required this.metric,
    required this.onMetricChanged,
    required this.range,
    required this.onRangeChanged,
  });

  final DateTime date;
  final HealthMetric metric;
  final ValueChanged<HealthMetric> onMetricChanged;
  final HealthTrendRange range;
  final ValueChanged<HealthTrendRange> onRangeChanged;

  /// Bounds `[from, to]` (YYYY-MM-DD) của kỳ kết thúc ở ngày đang chọn.
  ({String from, String to}) _period(DateTime selectedDay) {
    final from = selectedDay.subtract(Duration(days: range.days - 1));
    return (from: dayKey(from), to: dayKey(selectedDay));
  }

  String _statValue(double value) {
    switch (metric) {
      case HealthMetric.sleep:
        return formatSleepDuration(value);
      case HealthMetric.weight:
        return formatWeight(value);
      case HealthMetric.water:
        return formatMl(value.round());
      case HealthMetric.workout:
        return '${value.round()} phút';
      case HealthMetric.steps:
        return _intWithDot(value.round());
    }
  }

  String _intWithDot(int n) {
    final digits = n.abs().toString();
    final buffer = StringBuffer();
    for (var i = 0; i < digits.length; i++) {
      if (i > 0 && (digits.length - i) % 3 == 0) buffer.write('.');
      buffer.write(digits[i]);
    }
    return n < 0 ? '-${buffer.toString()}' : buffer.toString();
  }

  String _weekdayName(DateTime d) {
    switch (d.weekday) {
      case DateTime.monday:
        return 'Thứ Hai';
      case DateTime.tuesday:
        return 'Thứ Ba';
      case DateTime.wednesday:
        return 'Thứ Tư';
      case DateTime.thursday:
        return 'Thứ Năm';
      case DateTime.friday:
        return 'Thứ Sáu';
      case DateTime.saturday:
        return 'Thứ Bảy';
      case DateTime.sunday:
        return 'Chủ Nhật';
    }
    return '';
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final scale = HomeScale.textOf(context);
    final period = _period(date);
    final pointsAsync = ref.watch(
      healthTrendsProvider((
        from: period.from,
        to: period.to,
        metric: metric,
      )),
    );

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // ---------- header: pill metric + chip range ----------
        Padding(
          padding: const EdgeInsets.fromLTRB(
            MemoirSpace.s4,
            MemoirSpace.s4,
            MemoirSpace.s4,
            MemoirSpace.s2,
          ),
          child: LayoutBuilder(
            builder: (context, constraints) {
              final metricTabs = SegmentedTabs<HealthMetric>(
                options: HealthMetric.values
                    .map((m) => SegmentedTab(m, m.label))
                    .toList(),
                selected: metric,
                onChanged: onMetricChanged,
                scale: 1,
              );
              final rangeTabs = SizedBox(
                width: 150,
                child: SegmentedTabs<HealthTrendRange>(
                  options: HealthTrendRange.values
                      .map((r) => SegmentedTab(r, r.label))
                      .toList(),
                  selected: range,
                  onChanged: onRangeChanged,
                  scale: 0.85,
                ),
              );
              if (constraints.maxWidth < 700) {
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    metricTabs,
                    const SizedBox(height: MemoirSpace.s2),
                    Align(
                      alignment: Alignment.centerLeft,
                      child: rangeTabs,
                    ),
                  ],
                );
              }
              return Row(
                children: [
                  Expanded(child: metricTabs),
                  const SizedBox(width: MemoirSpace.s3),
                  rangeTabs,
                ],
              );
            },
          ),
        ),
        const Divider(height: 1),
        // ---------- 4 ô số ----------
        pointsAsync.when(
          data: (points) => _buildBody(context, scale, points, date),
          loading: () => _statCardSkeleton(context, scale),
          error: (e, st) => _statCardSkeleton(context, scale),
        ),
      ],
    );
  }

  Widget _buildStats(
      BuildContext context, double scale, List<HealthTrendPoint> points) {
    final theme = Theme.of(context);
    final summary =
        summarizeTrend(points: points, metric: metric, profile: null);
    final goal = summary.goal;
    final hasData = summary.daysWithData > 0;
    final unit = metric.unit;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: MemoirSpace.s4),
      child: Row(
        children: [
          Expanded(
            child: _statCard(
              context,
              'Tổng ${metric.label}',
              hasData ? _statValue(summary.total) : '--',
              hasData ? '${summary.total.round()} $unit' : '',
              theme,
              scale,
            ),
          ),
          const SizedBox(width: MemoirSpace.s3),
          Expanded(
            child: _statCard(
              context,
              'Trung bình ngày',
              hasData ? _statValue(summary.average) : '--',
              'Mục tiêu: ${_goalLabel(goal, unit)}',
              theme,
              scale,
            ),
          ),
          const SizedBox(width: MemoirSpace.s3),
          Expanded(
            child: _statCard(
              context,
              'Ngày đạt chuẩn',
              hasData ? '${summary.daysOnTarget} / ${points.length}' : '--',
              'Tỷ lệ hoàn thành ${(summary.completionRatio * 100).round()}%',
              theme,
              scale,
            ),
          ),
          const SizedBox(width: MemoirSpace.s3),
          Expanded(
            child: _statCard(
              context,
              'Ngày đỉnh cao',
              hasData ? _statValue(summary.peakValue ?? 0) : '--',
              hasData && summary.peakDate != null
                  ? '${_weekdayName(summary.peakDate!)}, '
                      '${summary.peakDate!.day}/${summary.peakDate!.month}'
                  : '',
              theme,
              scale,
            ),
          ),
        ],
      ),
    );
  }

  String _goalLabel(double goal, String unit) {
    if (goal <= 0) return 'Không có mục tiêu';
    switch (metric) {
      case HealthMetric.sleep:
        return '${goal.toInt()} giờ';
      case HealthMetric.weight:
        return formatWeight(goal);
      case HealthMetric.water:
        return formatMl(goal.round());
      case HealthMetric.workout:
        return '${goal.toInt()} phút';
      case HealthMetric.steps:
        return '${_intWithDot(goal.toInt())} bước';
    }
  }

  Widget _statCard(
    BuildContext context,
    String title,
    String value,
    String subtitle,
    ThemeData theme,
    double scale,
  ) {
    final palette = MemoirPalette.of(context);
    return Container(
      padding: const EdgeInsets.all(MemoirSpace.s3),
      decoration: BoxDecoration(
        color: palette.surfaceCard,
        borderRadius: BorderRadius.circular(MemoirRadius.card),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: theme.textTheme.labelSmall?.copyWith(
              fontSize: MemoirType.caption * scale,
              fontWeight: FontWeight.w600,
              color: theme.colorScheme.onSurfaceVariant,
            ),
          ),
          const SizedBox(height: MemoirSpace.s1),
          Text(
            value,
            style: theme.textTheme.headlineSmall?.copyWith(
              fontSize: MemoirType.heading1 * scale * 0.75,
              fontWeight: FontWeight.w600,
              color: theme.colorScheme.onSurface,
            ),
          ),
          if (subtitle.isNotEmpty) ...[
            const SizedBox(height: MemoirSpace.s1),
            Text(
              subtitle,
              style: theme.textTheme.bodySmall?.copyWith(
                fontSize: MemoirType.caption * scale,
                color: theme.colorScheme.onSurfaceVariant,
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _statCardSkeleton(BuildContext context, double scale) {
    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: MemoirSpace.s4),
      child: Row(
        children: List.generate(
          4,
          (i) => Expanded(
            child: Container(
              height: 110,
              margin: i == 0 ? null : const EdgeInsets.only(left: 12),
              decoration: BoxDecoration(
                color: theme.colorScheme.surfaceContainerHighest,
                borderRadius: BorderRadius.circular(MemoirRadius.card),
              ),
            ),
          ),
        ),
      ),
    );
  }

  bool _isSameDay(DateTime a, DateTime b) =>
      a.year == b.year && a.month == b.month && a.day == b.day;

  Color _barColor(double value, double goal, bool isToday, ThemeData theme) {
    if (isToday) return theme.colorScheme.primary;
    if (goal <= 0) {
      return theme.colorScheme.primary; // weight: không có mục tiêu
    }
    final dark = theme.brightness == Brightness.dark;
    final partial = dark
        ? MemoirColorsDark.healthBmiNormal
        : MemoirColorsLight.healthBmiNormal;
    if (value >= goal) return theme.colorScheme.primary;
    if (value >= goal * partialThreshold) return partial;
    return theme.colorScheme.outlineVariant;
  }

  String _compactNum(double v) {
    if (v >= 10000) return '${(v / 1000).toStringAsFixed(0)}K';
    if (v >= 1000) return '${(v / 1000).toStringAsFixed(1)}K';
    return v.round().toString();
  }

  Widget _buildChart(
    BuildContext context,
    double scale,
    List<HealthTrendPoint> points,
    TrendSummary summary,
    ThemeData theme,
    DateTime today,
  ) {
    final palette = MemoirPalette.of(context);
    final goal = summary.goal;
    final hasData = summary.daysWithData > 0;

    double maxY = 0;
    double minVal = 0;
    for (final pt in points) {
      final v = pt.value ?? 0;
      if (v > maxY) maxY = v;
      if (minVal == 0 || v < minVal) minVal = v;
    }
    if (goal > 0 && goal > maxY) maxY = goal;
    if (hasData && summary.average > maxY) maxY = summary.average;
    maxY = (maxY <= 0 ? 1 : maxY) * 1.2;

    double minY = 0;
    if (metric == HealthMetric.weight && hasData) {
      minY = (minVal * 0.9).clamp(0, double.infinity);
    }

    final horizontalLines = <HorizontalLine>[];
    if (goal > 0 && hasData) {
      horizontalLines.add(
        HorizontalLine(
          y: goal,
          color: theme.colorScheme.primary,
          strokeWidth: 1,
          dashArray: const [6, 4],
          label: HorizontalLineLabel(
            show: true,
            labelResolver: (line) => 'Mục tiêu ${_statValue(goal)}',
            style: TextStyle(
              color: theme.colorScheme.primary,
              fontSize: 10 * scale,
            ),
          ),
        ),
      );
    }
    if (hasData) {
      horizontalLines.add(
        HorizontalLine(
          y: summary.average,
          color: theme.colorScheme.onSurfaceVariant.withValues(alpha: 0.6),
          strokeWidth: 1,
          dashArray: const [4, 4],
          label: HorizontalLineLabel(
            show: true,
            labelResolver: (line) => 'TB: ${_statValue(summary.average)}',
            style: TextStyle(
              color: theme.colorScheme.onSurfaceVariant,
              fontSize: 10 * scale,
            ),
          ),
        ),
      );
    }

    final barGroups = <BarChartGroupData>[];
    for (var i = 0; i < points.length; i++) {
      final pt = points[i];
      final value = pt.value ?? 0;
      final isToday = _isSameDay(pt.date, today);
      barGroups.add(
        BarChartGroupData(
          x: i,
          barRods: [
            BarChartRodData(
              toY: value,
              width: 14,
              borderRadius: BorderRadius.circular(3),
              color: _barColor(value, goal, isToday, theme),
              borderSide: isToday
                  ? BorderSide(
                      color: theme.colorScheme.primary,
                      width: 2,
                    )
                  : BorderSide.none,
            ),
          ],
        ),
      );
    }

    final interval = (points.length / 4).ceil().toDouble();
    return SizedBox(
      height: 180 * scale,
      child: BarChart(
        BarChartData(
          maxY: maxY,
          minY: minY,
          barTouchData: const BarTouchData(enabled: false),
          alignment: BarChartAlignment.spaceEvenly,
          barGroups: barGroups,
          extraLinesData: ExtraLinesData(horizontalLines: horizontalLines),
          titlesData: FlTitlesData(
            topTitles: const AxisTitles(
              sideTitles: SideTitles(showTitles: false),
            ),
            rightTitles: const AxisTitles(
              sideTitles: SideTitles(showTitles: false),
            ),
            bottomTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                reservedSize: 30 * scale,
                interval: interval,
                getTitlesWidget: (value, meta) {
                  final i = value.toInt();
                  if (i < 0 || i >= points.length) {
                    return const SizedBox.shrink();
                  }
                  final d = points[i].date;
                  final isToday = _isSameDay(d, today);
                  return Text(
                    '${d.day}/${d.month}${isToday ? ' (Hôm nay)' : ''}',
                    style: theme.textTheme.bodySmall?.copyWith(
                      fontSize: 10 * scale,
                      color: theme.colorScheme.onSurfaceVariant,
                    ),
                  );
                },
              ),
            ),
            leftTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                reservedSize: 44 * scale,
                interval: maxY / 4,
                getTitlesWidget: (value, meta) {
                  return Text(
                    _compactNum(value),
                    style: theme.textTheme.bodySmall?.copyWith(
                      fontSize: 10 * scale,
                      color: theme.colorScheme.onSurfaceVariant,
                    ),
                  );
                },
              ),
            ),
          ),
          borderData: FlBorderData(
            show: true,
            border: Border(
              bottom: BorderSide(color: palette.borderDefault, width: 1),
              left: BorderSide(color: palette.borderDefault, width: 1),
            ),
          ),
          gridData: FlGridData(
            show: true,
            drawVerticalLine: false,
            horizontalInterval: maxY / 4,
            drawHorizontalLine: true,
            getDrawingHorizontalLine: (value) {
              return FlLine(
                color: palette.borderDefault.withValues(alpha: 0.3),
                strokeWidth: 1,
              );
            },
          ),
        ),
      ),
    );
  }

  Widget _buildBody(
    BuildContext context,
    double scale,
    List<HealthTrendPoint> points,
    DateTime today,
  ) {
    final theme = Theme.of(context);
    final summary =
        summarizeTrend(points: points, metric: metric, profile: null);
    final hasData = summary.daysWithData > 0;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildStats(context, scale, points),
        const SizedBox(height: MemoirSpace.s4),
        if (!hasData)
          _emptyState(context, scale, theme)
        else ...[
          _buildChart(context, scale, points, summary, theme, today),
          const SizedBox(height: MemoirSpace.s3),
          _buildLegend(context, scale, theme, summary.goal),
        ],
      ],
    );
  }

  Widget _emptyState(
    BuildContext context,
    double scale,
    ThemeData theme,
  ) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: MemoirSpace.s4),
      child: Container(
        padding: const EdgeInsets.all(MemoirSpace.s4),
        decoration: BoxDecoration(
          color: theme.colorScheme.surfaceContainerHighest,
          borderRadius: BorderRadius.circular(MemoirRadius.card),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(
              Icons.insert_chart_outlined,
              size: 40 * scale,
              color: theme.colorScheme.onSurfaceVariant,
            ),
            const SizedBox(height: MemoirSpace.s3),
            Text(
              'Chưa có dữ liệu trong kỳ này',
              style: theme.textTheme.titleMedium?.copyWith(
                fontSize: MemoirType.label * scale,
                fontWeight: FontWeight.w600,
                color: theme.colorScheme.onSurface,
              ),
            ),
            const SizedBox(height: MemoirSpace.s1),
            Text(
              'Lưu chỉ số hoặc thêm lần uống để xu hướng hiện thị ở đây.',
              style: theme.textTheme.bodySmall?.copyWith(
                fontSize: MemoirType.caption * scale,
                color: theme.colorScheme.onSurfaceVariant,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLegend(
    BuildContext context,
    double scale,
    ThemeData theme,
    double goal,
  ) {
    final dark = theme.brightness == Brightness.dark;
    final partial = dark
        ? MemoirColorsDark.healthBmiNormal
        : MemoirColorsLight.healthBmiNormal;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: MemoirSpace.s4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          if (goal > 0)
            _legendItem(
              context,
              scale,
              theme,
              'Đạt mục tiêu (≥ ${_statValue(goal)})',
              theme.colorScheme.primary,
            ),
          _legendItem(
            context,
            scale,
            theme,
            'Đạt 70–99%',
            partial,
          ),
          _legendItem(
            context,
            scale,
            theme,
            'Chưa đạt (< 70%)',
            theme.colorScheme.outlineVariant,
          ),
        ],
      ),
    );
  }

  Widget _legendItem(
    BuildContext context,
    double scale,
    ThemeData theme,
    String label,
    Color color,
  ) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 12 * scale,
          height: 12 * scale,
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(2),
          ),
        ),
        const SizedBox(width: MemoirSpace.s1),
        Text(
          label,
          style: theme.textTheme.bodySmall?.copyWith(
            fontSize: 10 * scale,
            color: theme.colorScheme.onSurfaceVariant,
          ),
        ),
      ],
    );
  }
}
