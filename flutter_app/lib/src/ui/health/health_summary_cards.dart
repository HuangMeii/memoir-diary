import 'package:flutter/material.dart';

import '../home/home_scale.dart';
import '../theme.dart';
import '../tokens.dart';
import 'health_metrics.dart';
import '../../data/models.dart';

/// Ba tháº» tÃ³m táº¯t ngÃ y: **Thá»i gian luyá»‡n táº­p**, **NÆ°á»›c uá»‘ng**, **Giáº¥c ngá»§**.
///
/// KhÃ´ng Ä‘á»c provider â€” nháº­n [HealthDayOverview] + [HealthProfile] tá»« mÃ n
/// (H3-S8) Ä‘á»ƒ widget dá»… test vÃ  khÃ´ng cÃ³ nguá»“n sá»± tháº­t thá»© hai.
class HealthSummaryCards extends StatelessWidget {
  const HealthSummaryCards({
    super.key,
    required this.day,
    required this.profile,
  });

  final HealthDayOverview day;
  final HealthProfile profile;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final narrow = constraints.maxWidth < 768;
        final workout = _WorkoutCard(day: day, profile: profile);
        final water = _WaterCard(day: day, profile: profile);
        final sleep = _SleepCard(day: day, profile: profile);
        if (narrow) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              workout,
              const SizedBox(height: MemoirSpace.s3),
              water,
              const SizedBox(height: MemoirSpace.s3),
              sleep,
            ],
          );
        }
        return Row(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Expanded(child: workout),
            const SizedBox(width: MemoirSpace.s3),
            Expanded(child: water),
            const SizedBox(width: MemoirSpace.s3),
            Expanded(child: sleep),
          ],
        );
      },
    );
  }
}

/// Khung tháº» hero: ná»n card + bo trÃ²n token, khÃ´ng hard-code mÃ u.
class _CardFrame extends StatelessWidget {
  const _CardFrame({required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    final palette = MemoirPalette.of(context);
    return Container(
      decoration: BoxDecoration(
        color: palette.surfaceCard,
        borderRadius: BorderRadius.circular(MemoirRadius.card),
      ),
      child: child,
    );
  }
}

/// Sá»‘ pháº§n trÄƒm so vá»›i má»¥c tiÃªu (lÃ m trÃ²n). Thanh tiáº¿n Ä‘á»™ káº¹p á»Ÿ 100, sá»‘
/// hiá»ƒn thá»‹ giá»¯ giÃ¡ trá»‹ tháº­t (cÃ³ thá»ƒ > 100).
int _goalPct(num current, num goal) {
  if (goal <= 0) return 0;
  return (current / goal * 100).round();
}

/// Tá»· lá»‡ hoÃ n thÃ nh má»¥c tiÃªu káº¹p vá» [0, 1] Ä‘á»ƒ váº½ thanh tiáº¿n Ä‘á»™.
double _goalRatio(num current, num goal) {
  if (goal <= 0) return 0;
  return (current / goal).clamp(0.0, 1.0);
}

TextStyle _caption(BuildContext context, ThemeData theme, double scale) =>
    theme.textTheme.bodySmall?.copyWith(
      fontSize: MemoirType.caption * scale,
      color: theme.colorScheme.onSurfaceVariant,
    ) ??
    const TextStyle();

Widget _cardHeader(BuildContext context, IconData icon, String title) {
  final theme = Theme.of(context);
  final scale = HomeScale.textOf(context);
  return Row(
    children: [
      Icon(icon, size: 18, color: theme.colorScheme.primary),
      const SizedBox(width: MemoirSpace.s2),
      Text(
        title,
        style: theme.textTheme.labelLarge?.copyWith(
          fontSize: MemoirType.label * scale,
          fontWeight: FontWeight.w500,
        ),
      ),
    ],
  );
}

Widget _chip(BuildContext context, String text) {
  final theme = Theme.of(context);
  return Container(
    padding: const EdgeInsets.symmetric(
      horizontal: MemoirSpace.s2,
      vertical: MemoirSpace.s1,
    ),
    decoration: BoxDecoration(
      color: theme.colorScheme.surfaceContainerHighest,
      borderRadius: BorderRadius.circular(MemoirRadius.pill),
    ),
    child: Text(
      text,
      style: _caption(context, theme, HomeScale.textOf(context)).copyWith(
        fontWeight: FontWeight.w600,
        color: theme.colorScheme.onSurface,
      ),
    ),
  );
}

Color _accent(BuildContext context, bool water) {
  final dark = Theme.of(context).brightness == Brightness.dark;
  return water
      ? (dark
          ? MemoirColorsDark.healthWaterAccent
          : MemoirColorsLight.healthWaterAccent)
      : (dark
          ? MemoirColorsDark.healthSleepAccent
          : MemoirColorsLight.healthSleepAccent);
}

class _WorkoutCard extends StatelessWidget {
  const _WorkoutCard({required this.day, required this.profile});

  final HealthDayOverview day;
  final HealthProfile profile;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scale = HomeScale.textOf(context);
    final log = day.log;
    final minutes = log?.workoutMinutes;
    final hasData = minutes != null;
    final goal = profile.workoutGoalMinutes;
    final pct = hasData ? _goalPct(minutes, goal) : 0;
    final progress = hasData ? _goalRatio(minutes, goal) : null;
    final intensity = log?.workoutIntensity;

    return _CardFrame(
      child: Padding(
        padding: const EdgeInsets.all(MemoirSpace.s4),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _cardHeader(
                context, Icons.fitness_center, 'Thá»i gian luyá»‡n táº­p'),
            const SizedBox(height: MemoirSpace.s3),
            Row(
              children: [
                Text(
                  hasData ? formatMinutes(minutes) : '--',
                  style: theme.textTheme.headlineMedium?.copyWith(
                    fontFamily: MemoirType.headingEditorialFamily,
                    fontSize: MemoirType.headingEditorial * scale,
                    fontWeight: FontWeight.normal,
                  ),
                ),
                const SizedBox(width: MemoirSpace.s2),
                Text(
                  hasData ? '/ ${formatMinutes(goal)}' : '',
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: theme.colorScheme.onSurfaceVariant,
                  ),
                ),
              ],
            ),
            const SizedBox(height: MemoirSpace.s2),
            _chip(context, '$pct% Má»¥c tiÃªu'),
            const SizedBox(height: MemoirSpace.s2),
            if (intensity != null && intensity.isNotEmpty)
              Text(
                intensity,
                style: _caption(context, theme, scale),
              ),
            const SizedBox(height: MemoirSpace.s3),
            if (progress != null) ...[
              LinearProgressIndicator(
                value: progress,
                minHeight: 6,
                backgroundColor: MemoirPalette.of(context)
                    .surfaceBrandSubtle
                    .withValues(alpha: 0.5),
                valueColor: AlwaysStoppedAnimation<Color>(
                  theme.colorScheme.primary,
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

class _WaterCard extends StatelessWidget {
  const _WaterCard({required this.day, required this.profile});

  final HealthDayOverview day;
  final HealthProfile profile;

  int _drinkCount(List<HealthWaterEntry> entries, WaterPeriod period) {
    var n = 0;
    for (final e in entries) {
      if (periodOf(e.recordedAt) == period) n++;
    }
    return n;
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scale = HomeScale.textOf(context);
    final breakdown = waterBreakdownOf(day.water);
    final totalMl = breakdown.totalMl;
    final goal = profile.waterGoalMl;
    final hasData = day.water.isNotEmpty;
    final pct = hasData ? _goalPct(totalMl, goal) : 0;
    final progress = hasData ? _goalRatio(totalMl, goal) : null;

    return _CardFrame(
      child: Padding(
        padding: const EdgeInsets.all(MemoirSpace.s4),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _cardHeader(context, Icons.water_drop, 'NÆ°á»›c uá»‘ng'),
            const SizedBox(height: MemoirSpace.s3),
            Row(
              children: [
                Text(
                  hasData ? formatMl(totalMl) : '--',
                  style: theme.textTheme.headlineMedium?.copyWith(
                    fontFamily: MemoirType.headingEditorialFamily,
                    fontSize: MemoirType.headingEditorial * scale,
                    fontWeight: FontWeight.normal,
                  ),
                ),
                const SizedBox(width: MemoirSpace.s2),
                Text(
                  hasData ? '/ ${formatMl(goal)}' : '',
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: theme.colorScheme.onSurfaceVariant,
                  ),
                ),
              ],
            ),
            const SizedBox(height: MemoirSpace.s2),
            _chip(context, '$pct% Má»¥c tiÃªu'),
            const SizedBox(height: MemoirSpace.s3),
            ..._periodLines(context, breakdown),
            const SizedBox(height: MemoirSpace.s3),
            if (breakdown.lastAt != null)
              Text(
                '${breakdown.count} láº§n uá»‘ng Â· Gáº§n nháº¥t '
                '${formatClock(breakdown.lastAt!)}',
                style: _caption(context, theme, scale),
              ),
            const SizedBox(height: MemoirSpace.s3),
            if (progress != null) ...[
              LinearProgressIndicator(
                value: progress,
                minHeight: 6,
                backgroundColor: MemoirPalette.of(context)
                    .surfaceBrandSubtle
                    .withValues(alpha: 0.5),
                valueColor: AlwaysStoppedAnimation<Color>(
                  _accent(context, true),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  List<Widget> _periodLines(BuildContext context, WaterBreakdown b) {
    final theme = Theme.of(context);
    final scale = HomeScale.textOf(context);
    final peak = b.peakPeriod;
    final lines = <Widget>[];
    for (final period in WaterPeriod.values) {
      final ml = b.mlByPeriod[period] ?? 0;
      final count = _drinkCount(day.water, period);
      final isPeak = peak == period && ml > 0;
      lines.add(
        Padding(
          padding: const EdgeInsets.only(bottom: MemoirSpace.s1),
          child: Row(
            children: [
              SizedBox(
                width: 44,
                child: Text(
                  period.label,
                  style: _caption(context, theme, scale),
                ),
              ),
              Text(
                '${formatMl(ml)} Â· $count láº§n náº¡p',
                style: _caption(context, theme, scale),
              ),
              if (isPeak) ...[
                const SizedBox(width: MemoirSpace.s2),
                Text(
                  'Cao nháº¥t',
                  style: _caption(context, theme, scale).copyWith(
                    color: _accent(context, true),
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ],
          ),
        ),
      );
    }
    return lines;
  }
}

class _SleepCard extends StatelessWidget {
  const _SleepCard({required this.day, required this.profile});

  final HealthDayOverview day;
  final HealthProfile profile;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scale = HomeScale.textOf(context);
    final log = day.log;
    final hours = log?.sleepHours;
    final hasData = hours != null;
    final goal = profile.sleepGoalHours;
    final progress = hasData ? _goalRatio(hours, goal) : null;
    final quality = log?.sleepQuality;
    final bedtime = log?.sleepBedtime;
    final wake = log?.sleepWake;
    final deep = log?.sleepDeepMinutes;
    final h = hours ?? 0.0;
    final d = deep ?? 0;
    final deepPct =
        (d > 0 && h > 0) ? (d / (h * 60) * 100).round().clamp(0, 100) : 0;

    return _CardFrame(
      child: Padding(
        padding: const EdgeInsets.all(MemoirSpace.s4),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _cardHeader(context, Icons.bedtime, 'Giáº¥c ngá»§'),
            const SizedBox(height: MemoirSpace.s3),
            Row(
              children: [
                Text(
                  hasData ? formatSleepDuration(hours) : '--',
                  style: theme.textTheme.headlineMedium?.copyWith(
                    fontFamily: MemoirType.headingEditorialFamily,
                    fontSize: MemoirType.headingEditorial * scale,
                    fontWeight: FontWeight.normal,
                  ),
                ),
                const SizedBox(width: MemoirSpace.s2),
                Text(
                  hasData ? '/ ${formatSleepDuration(goal)}' : '',
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: theme.colorScheme.onSurfaceVariant,
                  ),
                ),
              ],
            ),
            const SizedBox(height: MemoirSpace.s2),
            _chip(context, _qualityLabel(quality)),
            const SizedBox(height: MemoirSpace.s2),
            Text(
              '${bedtime ?? '--'} - ${wake ?? '--'}',
              style: _caption(context, theme, scale),
            ),
            if (d > 0 && h > 0) ...[
              const SizedBox(height: MemoirSpace.s2),
              Text(
                'SÃ¢u ${formatMinutes(deep)} Â· $deepPct%',
                style: _caption(context, theme, scale),
              ),
            ],
            const SizedBox(height: MemoirSpace.s3),
            if (progress != null) ...[
              LinearProgressIndicator(
                value: progress,
                minHeight: 6,
                backgroundColor: MemoirPalette.of(context)
                    .surfaceBrandSubtle
                    .withValues(alpha: 0.5),
                valueColor: AlwaysStoppedAnimation<Color>(
                  _accent(context, false),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  String _qualityLabel(String? q) => switch (q) {
        'Ráº¥t tá»‘t' => 'Ráº¥t tá»‘t',
        'BÃ¬nh thÆ°á»ng' => 'BÃ¬nh thÆ°á»ng',
        'Cháº­p chá»n' => 'Cháº­p chá»n',
        _ => '--',
      };
}
