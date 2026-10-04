import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/api_client.dart';
import '../../data/models.dart';
import '../../data/providers.dart';

/// Daily health tracking: a quick form for one day plus a 30-day trend chart.
class HealthScreen extends ConsumerStatefulWidget {
  const HealthScreen({super.key});

  @override
  ConsumerState<HealthScreen> createState() => _HealthScreenState();
}

class _HealthScreenState extends ConsumerState<HealthScreen> {
  final _steps = TextEditingController();
  final _workout = TextEditingController();
  final _water = TextEditingController();
  final _sleep = TextEditingController();
  final _weight = TextEditingController();
  final _note = TextEditingController();

  DateTime _day = DateTime.now();
  bool _saving = false;

  @override
  void dispose() {
    for (final c in [_steps, _workout, _water, _sleep, _weight, _note]) {
      c.dispose();
    }
    super.dispose();
  }

  /// Inclusive YYYY-MM-DD bounds covering the last 30 days.
  ({String from, String to}) get _range => (
        from: DateTime.now()
            .subtract(const Duration(days: 29))
            .toIso8601String()
            .substring(0, 10),
        to: DateTime.now().toIso8601String().substring(0, 10),
      );

  /// Prefill the form with whatever is already stored for the selected day.
  void _prefill(List<HealthLog> logs) {
    final iso = _day.toIso8601String().substring(0, 10);
    HealthLog? match;
    for (final log in logs) {
      if (log.logDate.toIso8601String().substring(0, 10) == iso) {
        match = log;
        break;
      }
    }
    _steps.text = match?.steps?.toString() ?? '';
    _workout.text = match?.workoutMinutes?.toString() ?? '';
    _water.text = match?.waterMl?.toString() ?? '';
    _sleep.text = match?.sleepHours?.toString() ?? '';
    _weight.text = match?.weightKg?.toString() ?? '';
    _note.text = match?.note ?? '';
  }

  /// POST upserts on log_date, so saving twice a day updates a single row.
  Future<void> _save() async {
    final log = HealthLog(
      id: '',
      logDate: _day,
      steps: int.tryParse(_steps.text.trim()),
      workoutMinutes: int.tryParse(_workout.text.trim()),
      waterMl: int.tryParse(_water.text.trim()),
      sleepHours: double.tryParse(_sleep.text.trim()),
      weightKg: double.tryParse(_weight.text.trim()),
      note: _note.text.trim(),
    );

    final payload = log.toPayload();
    if (payload.isEmpty) {
      _toast('Chưa nhập gì để lưu');
      return;
    }

    setState(() => _saving = true);
    try {
      await ref.read(apiClientProvider).post('/health-logs', data: {
        'log_date': log.logDate.toIso8601String().substring(0, 10),
        ...payload,
      });
      ref.invalidate(healthLogsProvider(_range));
      // The month summary aggregates health data too, so refresh it as well.
      ref.invalidate(
        monthSummaryProvider(monthKey(DateTime(_day.year, _day.month))),
      );
      _toast('Đã lưu ngày ${log.logDate.day}/${log.logDate.month}');
    } catch (e) {
      _toast('$e');
    } finally {
      if (mounted) setState(() => _saving = false);
    }
  }

  void _toast(String message) {
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(message)));
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final logs = ref.watch(healthLogsProvider(_range));

    return Scaffold(
      appBar: AppBar(title: const Text('Sức khoẻ')),
      body: logs.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(child: Text('$e')),
        data: (items) {
          _prefill(items);
          return ListView(
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 40),
            children: [
              _DayPicker(day: _day, onChanged: (d) => setState(() => _day = d)),
              const SizedBox(height: 16),
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('NHẬP NHANH', style: theme.textTheme.labelLarge),
                      const SizedBox(height: 12),
                      Row(
                        children: [
                          Expanded(
                            child: _NumField(
                              controller: _steps,
                              label: 'Bước chân',
                              hint: '8000',
                            ),
                          ),
                          const SizedBox(width: 10),
                          Expanded(
                            child: _NumField(
                              controller: _workout,
                              label: 'Tập (phút)',
                              hint: '45',
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 10),
                      Row(
                        children: [
                          Expanded(
                            child: _NumField(
                              controller: _water,
                              label: 'Nước (ml)',
                              hint: '2000',
                            ),
                          ),
                          const SizedBox(width: 10),
                          Expanded(
                            child: _NumField(
                              controller: _sleep,
                              label: 'Ngủ (giờ)',
                              hint: '7.5',
                              decimal: true,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 10),
                      _NumField(
                        controller: _weight,
                        label: 'Cân nặng (kg)',
                        hint: '65.5',
                        decimal: true,
                      ),
                      const SizedBox(height: 10),
                      TextField(
                        controller: _note,
                        maxLines: 2,
                        decoration: const InputDecoration(labelText: 'Ghi chú'),
                      ),
                      const SizedBox(height: 14),
                      FilledButton.icon(
                        onPressed: _saving ? null : _save,
                        icon: const Icon(Icons.save_outlined),
                        label: Text(_saving ? 'Đang lưu...' : 'Lưu'),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 18),
              _TrendSection(logs: items),
            ],
          );
        },
      ),
    );
  }
}

/// Day selector bounded to the last 30 days (no future entries).
class _DayPicker extends StatelessWidget {
  const _DayPicker({required this.day, required this.onChanged});

  final DateTime day;
  final ValueChanged<DateTime> onChanged;

  @override
  Widget build(BuildContext context) {
    final today = DateTime.now();
    final label = '${day.day}/${day.month}/${day.year}';
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        IconButton(
          icon: const Icon(Icons.chevron_left),
          onPressed: day.isAfter(today)
              ? null
              : () => onChanged(day.subtract(const Duration(days: 1))),
        ),
        Text(label, style: Theme.of(context).textTheme.titleMedium),
        IconButton(
          icon: const Icon(Icons.chevron_right),
          onPressed: day.isBefore(today) ? null : () => onChanged(today),
        ),
      ],
    );
  }
}

/// Numeric input; an empty field means not recorded, not zero.
class _NumField extends StatelessWidget {
  const _NumField({
    required this.controller,
    required this.label,
    required this.hint,
    this.decimal = false,
  });

  final TextEditingController controller;
  final String label;
  final String hint;
  final bool decimal;

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      keyboardType: TextInputType.numberWithOptions(decimal: decimal),
      decoration: InputDecoration(labelText: label, hintText: hint),
    );
  }
}

/// Totals plus the steps / workout trend for the fetched window.
class _TrendSection extends StatelessWidget {
  const _TrendSection({required this.logs});

  final List<HealthLog> logs;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    // The API returns newest first; the chart x axis needs chronological order.
    final points = [...logs]..sort((a, b) => a.logDate.compareTo(b.logDate));
    final withSteps = points.where((l) => l.steps != null).toList();
    final withWorkout = points.where((l) => l.workoutMinutes != null).toList();

    var totalSteps = 0;
    var totalWorkout = 0;
    for (final log in points) {
      totalSteps += log.steps ?? 0;
      totalWorkout += log.workoutMinutes ?? 0;
    }

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('30 NGÀY GẦN NHẤT', style: theme.textTheme.labelLarge),
            const SizedBox(height: 10),
            Row(
              children: [
                Expanded(
                  child: _Stat(
                    icon: Icons.directions_walk,
                    label: 'Tổng bước',
                    value: '$totalSteps',
                  ),
                ),
                Expanded(
                  child: _Stat(
                    icon: Icons.timer_outlined,
                    label: 'Phút tập',
                    value: '$totalWorkout',
                  ),
                ),
                Expanded(
                  child: _Stat(
                    icon: Icons.event_note,
                    label: 'Ngày có data',
                    value: '${points.length}',
                  ),
                ),
              ],
            ),
            const SizedBox(height: 18),
            if (withSteps.isEmpty)
              Text(
                'Chưa có dữ liệu bước chân. Nhập ở trên để xem biểu đồ.',
                style: theme.textTheme.bodySmall?.copyWith(
                  color: theme.colorScheme.onSurfaceVariant,
                ),
              )
            else
              _LineChart(
                points: withSteps,
                valueOf: (l) => l.steps!.toDouble(),
                color: theme.colorScheme.primary,
                title: 'Bước chân',
              ),
            if (withWorkout.isNotEmpty) ...[
              const SizedBox(height: 22),
              _LineChart(
                points: withWorkout,
                valueOf: (l) => l.workoutMinutes!.toDouble(),
                color: theme.colorScheme.tertiary,
                title: 'Phút tập luyện',
              ),
            ],
          ],
        ),
      ),
    );
  }
}

class _Stat extends StatelessWidget {
  const _Stat({required this.icon, required this.label, required this.value});

  final IconData icon;
  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Column(
      children: [
        Icon(icon, size: 18, color: theme.colorScheme.primary),
        const SizedBox(height: 4),
        Text(value, style: theme.textTheme.titleMedium),
        Text(
          label,
          style: theme.textTheme.bodySmall?.copyWith(
            color: theme.colorScheme.onSurfaceVariant,
            fontSize: 11,
          ),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }
}
/// Line chart over the fixed 30-day window.
///
/// The x axis spans the whole window so unlogged days still advance it,
/// instead of squeezing logged days together.
class _LineChart extends StatelessWidget {
  const _LineChart({
    required this.points,
    required this.valueOf,
    required this.color,
    required this.title,
  });

  final List<HealthLog> points;
  final double Function(HealthLog) valueOf;
  final Color color;
  final String title;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final start = DateTime.now().subtract(const Duration(days: 29));
    final span = DateTime.now().difference(start).inDays + 1;

    final spots = <FlSpot>[];
    for (final log in points) {
      final idx = log.logDate.difference(start).inDays;
      if (idx >= 0 && idx < span) {
        spots.add(FlSpot(idx.toDouble(), valueOf(log)));
      }
    }
    spots.sort((a, b) => a.x.compareTo(b.x));
    if (spots.isEmpty) return const SizedBox.shrink();

    var maxY = 0.0;
    for (final spot in spots) {
      if (spot.y > maxY) maxY = spot.y;
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: theme.textTheme.labelMedium?.copyWith(
            color: theme.colorScheme.onSurfaceVariant,
          ),
        ),
        const SizedBox(height: 8),
        SizedBox(
          height: 160,
          child: LineChart(
            LineChartData(
              minX: 0,
              maxX: (span - 1).toDouble(),
              minY: 0,
              // Headroom so the peak does not touch the top border.
              maxY: maxY <= 0 ? 1 : maxY * 1.2,
              lineBarsData: [
                LineChartBarData(
                  spots: spots,
                  isCurved: true,
                  curveSmoothness: 0.25,
                  color: color,
                  barWidth: 2.5,
                  dotData: const FlDotData(show: true),
                  belowBarData: BarAreaData(
                    show: true,
                    color: color.withValues(alpha: 0.12),
                  ),
                ),
              ],
              titlesData: FlTitlesData(
                topTitles:
                    const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                rightTitles:
                    const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                leftTitles: const AxisTitles(
                  sideTitles: SideTitles(showTitles: true, reservedSize: 38),
                ),
                bottomTitles: AxisTitles(
                  sideTitles: SideTitles(
                    showTitles: true,
                    reservedSize: 26,
                    // Label every 7th day to avoid overlapping tick text.
                    getTitlesWidget: (value, meta) {
                      final day = value.toInt() + 1;
                      if (day % 7 != 0) return const SizedBox.shrink();
                      return Padding(
                        padding: const EdgeInsets.only(top: 6),
                        child: Text('$day', style: theme.textTheme.bodySmall),
                      );
                    },
                  ),
                ),
              ),
              gridData: const FlGridData(show: true, drawVerticalLine: false),
              borderData: FlBorderData(show: false),
            ),
          ),
        ),
      ],
    );
  }
}
