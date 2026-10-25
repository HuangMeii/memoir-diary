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

/// Window offered by the pills of "Biến động cân nặng" (design: 4 tuần /
/// 3 tháng / 6 tháng).
enum WeightRange {
  fourWeeks('4 tuần'),
  threeMonths('3 tháng'),
  sixMonths('6 tháng');

  const WeightRange(this.label);

  /// Vietnamese chip label.
  final String label;

  /// `Tuần` for the weekly window, `Tháng` for the calendar-month ones.
  String get unit => this == WeightRange.fourWeeks ? 'Tuần' : 'Tháng';
}

/// One card of the "Biến động cân nặng" row.
class WeightCard {
  const WeightCard({
    required this.title,
    required this.caption,
    required this.kg,
    this.isToday = false,
    this.estimated = false,
  });

  /// `Tuần 1` / `Tháng 1` …, or `Hôm nay` for the current period.
  final String title;

  /// `23/09` on the first card, `-0.3 kg` on the following ones, `--` when the
  /// data is missing.
  final String caption;

  /// Average of the period, or `null` when no weigh-in exists at all.
  final double? kg;

  /// The current week/month card, highlighted by the design.
  final bool isToday;

  /// True when the period had no weigh-in and the nearest known value was
  /// carried over, so the UI can mark the number as an estimate.
  final bool estimated;
}

/// One period the cards cover: a 7-day week or a calendar month.
class _WeightPeriod {
  const _WeightPeriod({required this.start, required this.end});

  final DateTime start;
  final DateTime end;
}

/// Builds the cards of "Biến động cân nặng" for [range], ending at [until].
///
/// * `4 tuần` → four 7-day weeks; `3 tháng` / `6 tháng` → real calendar months
///   (Aug, Sep, Oct for 3 tháng), so a `Tháng` card is a month, not 22/45 days.
/// * The last card is the **current** period and is titled `Hôm nay`.
/// * A period without a weigh-in inherits the nearest known value (marked
///   [WeightCard.estimated]) so one weigh-in still lights up the whole row.
/// * Weigh-ins dated after [until] are ignored.
List<WeightCard> weightCardsOf(
  List<HealthLog> logs,
  WeightRange range, {
  required DateTime until,
}) {
  final today = DateTime(until.year, until.month, until.day);
  final entries = logs
      .where((log) => log.weightKg != null)
      .map((log) => (
            date:
                DateTime(log.logDate.year, log.logDate.month, log.logDate.day),
            kg: log.weightKg!,
          ))
      .where((entry) => !entry.date.isAfter(today))
      .toList()
    ..sort((a, b) => a.date.compareTo(b.date));

  final periods = _periodsOf(range, today);
  final averages = <double?>[];
  for (final period in periods) {
    final values = entries
        .where((entry) =>
            !entry.date.isBefore(period.start) &&
            !entry.date.isAfter(period.end))
        .map((entry) => entry.kg)
        .toList();
    averages.add(
      values.isEmpty ? null : values.reduce((a, b) => a + b) / values.length,
    );
  }

  // Carry the nearest known value into the empty periods.
  final kgs = <double?>[];
  double? carry;
  for (final average in averages) {
    if (average != null) carry = average;
    kgs.add(average ?? carry);
  }
  double? backwards;
  for (final kg in kgs) {
    if (kg != null) {
      backwards = kg;
      break;
    }
  }
  for (var index = kgs.length - 1; index >= 0; index--) {
    if (kgs[index] != null) {
      backwards = kgs[index];
    } else {
      kgs[index] = backwards;
    }
  }

  final cards = <WeightCard>[];
  for (var index = 0; index < periods.length; index++) {
    final estimated = averages[index] == null && kgs[index] != null;
    final isToday = index == periods.length - 1;
    cards.add(
      WeightCard(
        title: isToday ? 'Hôm nay' : '${range.unit} ${index + 1}',
        caption: index == 0
            ? _dayMonth(periods[index].start)
            : _delta(kgs[index], kgs[index - 1]),
        kg: kgs[index],
        isToday: isToday,
        estimated: estimated,
      ),
    );
  }
  return cards;
}

/// The periods each pill covers, oldest first.
List<_WeightPeriod> _periodsOf(WeightRange range, DateTime today) {
  if (range == WeightRange.fourWeeks) {
    return [
      for (var index = 0; index < 4; index++)
        _WeightPeriod(
          start: today.subtract(Duration(days: 27 - index * 7)),
          end: today.subtract(Duration(days: 21 - index * 7)),
        ),
    ];
  }
  final months = range == WeightRange.threeMonths ? 3 : 6;
  return [
    for (var index = 0; index < months; index++)
      _WeightPeriod(
        start: DateTime(today.year, today.month - (months - 1 - index), 1),
        // Day 0 of the next month is the last day of this one.
        end: DateTime(today.year, today.month - (months - 2 - index), 0),
      ),
  ];
}

/// `-0.3 kg` / `+0.2 kg`, or `--` when one side is missing.
String _delta(double? kg, double? previous) {
  if (kg == null || previous == null) return '--';
  final delta = kg - previous;
  return '${delta > 0 ? '+' : ''}${delta.toStringAsFixed(1)} kg';
}

String _dayMonth(DateTime value) => '${_two(value.day)}/${_two(value.month)}';

String _two(int value) => value.toString().padLeft(2, '0');
