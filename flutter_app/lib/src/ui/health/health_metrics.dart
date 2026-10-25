/// Pure calculation & formatting helpers for the health dashboard.
///
/// No BuildContext, no network, no `DateTime.now()` — every input is passed
/// in, so `test/health_test.dart` (H5-S1) can exercise all of this without a
/// widget or a backend. Widgets should only draw what these functions compute.
library;

import '../../data/models.dart';

/// Which part of the day a water entry falls into, derived from the recorded
/// time in Vietnam time (UTC+7) — never stored on the row.
enum WaterPeriod {
  morning('Sáng'),
  afternoon('Chiều'),
  evening('Tối');

  const WaterPeriod(this.label);

  /// Vietnamese label shown on the breakdown chips.
  final String label;
}

/// IDI & WPRO BMI classification used by the design.
enum BmiZone {
  underweight('Gầy'),
  normal('Chuẩn'),
  overweight('Thừa cân'),
  obese('Béo phì');

  const BmiZone(this.label);

  /// Vietnamese label shown next to the BMI number.
  final String label;
}

/// Display strings for [HealthMetric]; the enum itself lives in the data
/// layer so repositories and providers never import UI code.
extension HealthMetricDisplay on HealthMetric {
  /// Vietnamese name shown on the metric pill.
  String get label => switch (this) {
        HealthMetric.steps => 'Bước chân',
        HealthMetric.workout => 'Luyện tập',
        HealthMetric.water => 'Nước',
        HealthMetric.sleep => 'Giấc ngủ',
        HealthMetric.weight => 'Cân nặng',
      };

  /// Short unit appended to numbers on the chart.
  String get unit => switch (this) {
        HealthMetric.steps => 'bước',
        HealthMetric.workout => 'phút',
        HealthMetric.water => 'ml',
        HealthMetric.sleep => 'giờ',
        HealthMetric.weight => 'kg',
      };
}

/// BMI rounded to one decimal, or null when either side is missing so the UI
/// can say "chưa đủ dữ liệu" instead of showing `NaN`.
double? bmiOf({double? weightKg, int? heightCm}) {
  if (weightKg == null || heightCm == null || heightCm <= 0) return null;
  final metres = heightCm / 100;
  return double.parse((weightKg / (metres * metres)).toStringAsFixed(1));
}

/// IDI & WPRO thresholds: `<18.5` gầy, `18.5–22.9` chuẩn, `23–24.9` thừa cân,
/// `>=25` béo phì. Written as `< 23` / `< 25` so no gap can slip between the
/// bands.
BmiZone? bmiZoneOf(double? bmi) {
  if (bmi == null) return null;
  if (bmi < 18.5) return BmiZone.underweight;
  if (bmi < 23) return BmiZone.normal;
  if (bmi < 25) return BmiZone.overweight;
  return BmiZone.obese;
}

/// The Vietnam-time part of the day a drink belongs to. [recordedAt] arrives
/// as UTC (or with an offset) and is shifted +7 before reading the hour:
/// `<12h` Sáng, `12–17h` Chiều, `>=18h` Tối.
WaterPeriod periodOf(DateTime recordedAt) {
  final hour = recordedAt.toUtc().add(const Duration(hours: 7)).hour;
  if (hour < 12) return WaterPeriod.morning;
  if (hour < 18) return WaterPeriod.afternoon;
  return WaterPeriod.evening;
}

/// Per-period water totals plus the few numbers the hero card needs: grand
/// total, drink count, the most recent drink and the peak period.
class WaterBreakdown {
  const WaterBreakdown({
    required this.mlByPeriod,
    required this.totalMl,
    required this.count,
    required this.lastAt,
    required this.peakPeriod,
  });

  final Map<WaterPeriod, int> mlByPeriod;
  final int totalMl;
  final int count;
  final DateTime? lastAt;
  final WaterPeriod? peakPeriod;
}

/// Splits [entries] by the Vietnam-time period they were recorded in.
///
/// An empty list gives all-zero buckets with null [WaterBreakdown.lastAt] and
/// [WaterBreakdown.peakPeriod]. Ties on the peak keep the earlier period, so
/// the result never depends on list order.
WaterBreakdown waterBreakdownOf(List<HealthWaterEntry> entries) {
  final mlByPeriod = {
    for (final period in WaterPeriod.values) period: 0,
  };
  var totalMl = 0;
  DateTime? lastAt;
  for (final entry in entries) {
    final period = periodOf(entry.recordedAt);
    mlByPeriod[period] = mlByPeriod[period]! + entry.amountMl;
    totalMl += entry.amountMl;
    if (lastAt == null || entry.recordedAt.isAfter(lastAt)) {
      lastAt = entry.recordedAt;
    }
  }
  WaterPeriod? peak;
  for (final period in WaterPeriod.values) {
    final best = peak == null ? 0 : mlByPeriod[peak]!;
    if (mlByPeriod[period]! > best) peak = period;
  }
  return WaterBreakdown(
    mlByPeriod: Map.unmodifiable(mlByPeriod),
    totalMl: totalMl,
    count: entries.length,
    lastAt: lastAt,
    peakPeriod: peak,
  );
}

/// The daily goal for [metric], falling back to the design defaults when no
/// profile was saved. Weight has no daily goal: it uses the target weight, or
/// 0 so the chart simply draws no target line.
double goalFor(HealthMetric metric, HealthProfile? profile) => switch (metric) {
      HealthMetric.steps => (profile?.stepsGoal ?? 8000).toDouble(),
      HealthMetric.workout => (profile?.workoutGoalMinutes ?? 60).toDouble(),
      HealthMetric.water => (profile?.waterGoalMl ?? 2000).toDouble(),
      HealthMetric.sleep => profile?.sleepGoalHours ?? 8,
      HealthMetric.weight => profile?.weightGoalKg ?? 0,
    };

/// Share of the goal that still counts as "gần đạt"; declared once so the
/// chart, the legend and the tests can never drift apart.
const double partialThreshold = 0.7;

/// Aggregate of one trend series for the stat cards above the chart.
class TrendSummary {
  const TrendSummary({
    required this.total,
    required this.average,
    required this.daysWithData,
    required this.daysOnTarget,
    required this.daysPartial,
    required this.peakValue,
    required this.peakDate,
    required this.goal,
    required this.completionRatio,
  });

  final double total;
  final double average;
  final int daysWithData;
  final int daysOnTarget;
  final int daysPartial;
  final double? peakValue;
  final DateTime? peakDate;
  final double goal;
  final double completionRatio;
}

/// Summarises [points] for the selected metric.
///
/// Days with `value == null` are skipped in every sum and average but still
/// count in the period length, so an empty day honestly lowers
/// [TrendSummary.completionRatio]. A day counts as "đạt chuẩn" at
/// `value >= goal` and as "gần đạt" from [partialThreshold] of the goal.
TrendSummary summarizeTrend({
  required List<HealthTrendPoint> points,
  required HealthMetric metric,
  HealthProfile? profile,
}) {
  final goal = goalFor(metric, profile);
  var total = 0.0;
  var daysOnTarget = 0;
  var daysPartial = 0;
  double? peakValue;
  DateTime? peakDate;
  for (final point in points) {
    final value = point.value;
    if (value == null) continue;
    total += value;
    if (value >= goal) {
      daysOnTarget++;
    } else if (value >= goal * partialThreshold) {
      daysPartial++;
    }
    if (peakValue == null || value > peakValue) {
      peakValue = value;
      peakDate = point.date;
    }
  }
  final daysWithData = points.where((p) => p.value != null).length;
  return TrendSummary(
    total: total,
    average: daysWithData == 0 ? 0 : total / daysWithData,
    daysWithData: daysWithData,
    daysOnTarget: daysOnTarget,
    daysPartial: daysPartial,
    peakValue: peakValue,
    peakDate: peakDate,
    goal: goal,
    completionRatio: points.isEmpty ? 0 : daysOnTarget / points.length,
  );
}

/// `7h 30m` from a decimal hour; rounds to whole minutes, `0m` when null.
String formatSleepDuration(double? hours) {
  if (hours == null) return '0m';
  final total = (hours * 60).round();
  final h = total ~/ 60;
  final m = total % 60;
  if (h == 0) return '${m}m';
  if (m == 0) return '${h}h';
  return '${h}h ${m}m';
}

/// `45 phút`; `0 phút` when null.
String formatMinutes(int? minutes) => '${minutes ?? 0} phút';

/// `1.750 ml` with a dot as the thousands separator; `0 ml` when null.
String formatMl(int? ml) {
  final value = ml ?? 0;
  final digits = value.abs().toString();
  final buffer = StringBuffer();
  for (var i = 0; i < digits.length; i++) {
    if (i > 0 && (digits.length - i) % 3 == 0) buffer.write('.');
    buffer.write(digits[i]);
  }
  return '${value < 0 ? '-' : ''}$buffer ml';
}

/// `58.2 kg` with one decimal; `0.0 kg` when null.
String formatWeight(double? kg) => '${(kg ?? 0).toStringAsFixed(1)} kg';

/// `14:30` in Vietnam time, for "Gần nhất 14:30"-style captions.
String formatClock(DateTime utc) {
  final vn = utc.toUtc().add(const Duration(hours: 7));
  final h = vn.hour.toString().padLeft(2, '0');
  final m = vn.minute.toString().padLeft(2, '0');
  return '$h:$m';
}

/// How the "Biến động cân nặng" series is bucketed.
enum WeightBucket {
  day('Ngày'),
  week('Tuần'),
  month('Tháng');

  const WeightBucket(this.label);

  /// Vietnamese chip label.
  final String label;
}

/// One point of the weight series: a single weigh-in for [WeightBucket.day], or
/// the average of one week / one month.
class WeightPoint {
  const WeightPoint({
    required this.date,
    required this.label,
    required this.kg,
  });

  /// Start of the bucket: the day itself, the Monday of the week, or the first
  /// day of the month.
  final DateTime date;

  /// Short chip label: `25/10`, `Tuần 20/10`, `Th 10/2026`.
  final String label;

  /// Weight in kilograms (averaged for the week/month buckets).
  final double kg;
}

/// Buckets the weigh-ins of [logs] inside the [days] days ending at [until].
///
/// The day bucket keeps every weigh-in; the week bucket averages by ISO week
/// (Monday start) and the month bucket by calendar month, so the same window
/// can be read at three levels of detail.
List<WeightPoint> weightPointsOf(
  List<HealthLog> logs,
  WeightBucket bucket, {
  required DateTime until,
  int days = 180,
}) {
  final last = DateTime(until.year, until.month, until.day);
  final first = last.subtract(Duration(days: days - 1));
  final entries = logs
      .where((log) => log.weightKg != null)
      .map((log) => (
            date:
                DateTime(log.logDate.year, log.logDate.month, log.logDate.day),
            kg: log.weightKg!,
          ))
      .where(
          (entry) => !entry.date.isBefore(first) && !entry.date.isAfter(last))
      .toList()
    ..sort((a, b) => a.date.compareTo(b.date));
  if (bucket == WeightBucket.day) {
    return [
      for (final entry in entries)
        WeightPoint(
          date: entry.date,
          label: '${_two(entry.date.day)}/${_two(entry.date.month)}',
          kg: entry.kg,
        ),
    ];
  }
  final totals = <DateTime, List<double>>{};
  for (final entry in entries) {
    final key = bucket == WeightBucket.week
        ? startOfWeek(entry.date)
        : DateTime(entry.date.year, entry.date.month);
    (totals[key] ??= <double>[]).add(entry.kg);
  }
  final keys = totals.keys.toList()..sort();
  return [
    for (final key in keys)
      WeightPoint(
        date: key,
        label: bucket == WeightBucket.week
            ? 'Tuần ${_two(key.day)}/${_two(key.month)}'
            : 'Th ${_two(key.month)}/${key.year}',
        kg: totals[key]!.reduce((a, b) => a + b) / totals[key]!.length,
      ),
  ];
}

/// Monday 00:00 of [value]'s week, used to group weigh-ins.
DateTime startOfWeek(DateTime value) {
  final day = DateTime(value.year, value.month, value.day);
  return day.subtract(Duration(days: day.weekday - DateTime.monday));
}

String _two(int value) => value.toString().padLeft(2, '0');
