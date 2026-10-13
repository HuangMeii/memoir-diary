import 'package:flutter/material.dart';

import '../../data/models.dart';
import '../theme.dart';
import '../tokens.dart';
import '../widgets/weather_card.dart';
import 'weather_charts.dart';
import 'weather_illustrative.dart';
import 'weather_panels.dart';

/// Gap between the forecast column and the supporting column (design: 24).
const double _columnGap = 24;

/// Width of the supporting column (design: 320).
const double _supportingWidth = 320;

/// The width below which the two forecast columns stack.
const double _twoColumnMin = 900;

/// `12 mm`, `0.5 mm` — rain in millimetres without trailing zeroes.
String mmLabel(double value) =>
    value == value.roundToDouble() ? '${value.round()}' : value.toStringAsFixed(1);

/// A forecast card: an optional heading row, then the body.
class WeatherPanel extends StatelessWidget {
  const WeatherPanel({
    super.key,
    required this.child,
    required this.scale,
    this.title,
    this.trailing,
    this.onTrailingTap,
    this.subtitle,
  });

  final Widget child;
  final double scale;
  final String? title;

  /// Right-aligned note on the heading row, e.g. `Cao / thấp · °C`.
  final String? trailing;

  /// Makes [trailing] a link, e.g. the `24 giờ →` action.
  final VoidCallback? onTrailingTap;

  /// Muted line under the heading.
  final String? subtitle;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final muted = theme.colorScheme.onSurfaceVariant;
    final trailingStyle = theme.textTheme.bodySmall?.copyWith(
      color: muted,
      fontSize: MemoirType.caption,
    );

    return Card(
      margin: EdgeInsets.zero,
      child: Padding(
        padding: EdgeInsets.all(MemoirSpace.s4 * scale),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (title != null) ...[
              Row(
                children: [
                  Expanded(
                    child: Text(
                      title!,
                      style: theme.textTheme.labelLarge?.copyWith(
                        color: theme.colorScheme.onSurface,
                        fontSize: MemoirType.body,
                      ),
                    ),
                  ),
                  if (trailing != null)
                    if (onTrailingTap == null)
                      Text(trailing!, style: trailingStyle)
                    else
                      InkWell(
                        borderRadius: BorderRadius.circular(
                          MemoirRadius.control * scale,
                        ),
                        onTap: onTrailingTap,
                        child: Padding(
                          padding: EdgeInsets.symmetric(
                            horizontal: MemoirSpace.s1 * scale,
                          ),
                          child: Text(
                            trailing!,
                            style: trailingStyle?.copyWith(
                              color: theme.colorScheme.primary,
                            ),
                          ),
                        ),
                      ),
                ],
              ),
              SizedBox(height: MemoirSpace.s2 * scale),
            ],
            if (subtitle != null) ...[
              Text(
                subtitle!,
                style: theme.textTheme.bodySmall?.copyWith(
                  color: muted,
                  fontSize: MemoirType.caption,
                ),
              ),
              SizedBox(height: MemoirSpace.s3 * scale),
            ],
            child,
          ],
        ),
      ),
    );
  }
}

/// Lays the main forecast beside the supporting column, or stacks them when
/// the window is too narrow for both.
class WeatherForecastRegions extends StatelessWidget {
  const WeatherForecastRegions({
    super.key,
    required this.main,
    required this.supporting,
    required this.scale,
  });

  final Widget main;
  final Widget supporting;
  final double scale;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        if (constraints.maxWidth >= _twoColumnMin * scale) {
          return Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(child: main),
              SizedBox(width: _columnGap * scale),
              SizedBox(width: _supportingWidth * scale, child: supporting),
            ],
          );
        }
        return Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            main,
            SizedBox(height: MemoirSpace.s5 * scale),
            supporting,
          ],
        );
      },
    );
  }
}

/// The supporting column: the day/hour preview and the journal note.
///
/// Pass a null [top] when the main column already shows the preview.
Widget supportingColumn({
  Widget? top,
  required double scale,
}) =>
    Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        if (top != null) ...[
          WeatherPanel(scale: scale, child: top),
          SizedBox(height: MemoirSpace.s4 * scale),
        ],
        WeatherPanel(scale: scale, child: ForecastContextCard(scale: scale)),
      ],
    );

/// The four `Daily metrics` rows of a day: rain, chance, wind and humidity.
List<(String, String)> metricRowsFor(WeatherDay day) => [
      ('Lượng mưa trong ngày', '${rainTotalMm(day).round()} mm'),
      ('Xác suất mưa', '${rainChance(day)}%'),
      ('Gió ${windDirection(day)}', '${windKmh(day)} km/h'),
      ('Độ ẩm', '${humidityPercent(day)}%'),
    ];

/// `11–17 tháng 10, 2026` for the forecast window the periods cover.
String weekRangeLabel(List<WeatherDay> days) {
  if (days.isEmpty) return '';
  final first = days.first.date;
  final last = days.last.date;
  if (first.month == last.month) {
    return '${first.day}–${last.day} tháng ${first.month}, ${first.year}';
  }
  return '${first.day} tháng ${first.month} – ${last.day} tháng '
      '${last.month}, ${last.year}';
}

/// One `Giờ / °C / Mưa (mm)` row of the `Chi tiết 24 giờ` table.
class HourTableRow extends StatelessWidget {
  const HourTableRow({
    super.key,
    required this.hour,
    required this.selected,
    required this.onTap,
    required this.scale,
  });

  final WeatherHour hour;
  final bool selected;
  final VoidCallback onTap;
  final double scale;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final palette = MemoirPalette.of(context);

    return InkWell(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.symmetric(
          horizontal: MemoirSpace.s2 * scale,
          vertical: MemoirSpace.custom10 * scale,
        ),
        decoration: BoxDecoration(
          color: selected ? palette.surfaceBrandSubtle : null,
          borderRadius: BorderRadius.circular(MemoirRadius.weather6 * scale),
        ),
        child: Row(
          children: [
            SizedBox(
              width: 46 * scale,
              child: Text(
                hour.label,
                style: theme.textTheme.bodySmall?.copyWith(
                  color: selected
                      ? theme.colorScheme.primary
                      : theme.colorScheme.onSurfaceVariant,
                  fontSize: MemoirType.caption,
                  fontWeight: selected ? FontWeight.w600 : FontWeight.w400,
                ),
              ),
            ),
            SizedBox(width: MemoirSpace.s3 * scale),
            WeatherIcon(condition: hour.condition, size: 16 * scale),
            SizedBox(width: MemoirSpace.s2 * scale),
            Expanded(
              child: Text(
                '${hour.temperature.round()}°',
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: theme.colorScheme.onSurface,
                  fontSize: MemoirType.body,
                ),
              ),
            ),
            Text(
              mmLabel(hour.rainMm),
              style: theme.textTheme.bodyMedium?.copyWith(
                color: theme.colorScheme.onSurface,
                fontSize: MemoirType.body,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// The `Tuần` view: the seven-day table, the weekly rain chart and the
/// supporting column for the day being looked at.
class WeatherWeekTab extends StatelessWidget {
  const WeatherWeekTab({
    super.key,
    required this.days,
    required this.selectedIndex,
    required this.onSelectDay,
    required this.onOpenDay,
    required this.scale,
  });

  final List<WeatherDay> days;
  final int selectedIndex;
  final ValueChanged<int> onSelectDay;
  final VoidCallback onOpenDay;
  final double scale;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final muted = theme.colorScheme.onSurfaceVariant;
    final caption = theme.textTheme.bodySmall?.copyWith(
      color: muted,
      fontSize: MemoirType.caption,
    );
    final index = days.isEmpty ? 0 : selectedIndex.clamp(0, days.length - 1);
    final selected = days.isEmpty ? null : days[index];
    final rain = [for (final day in days) rainTotalMm(day)];
    final axis = rainAxis(rain);

    final main = Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        WeatherPanel(
          scale: scale,
          title: 'Dự báo 7 ngày',
          trailing: 'Cao / thấp · °C',
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              for (var i = 0; i < days.length; i++)
                _weekRow(context, days[i], i, i == index),
              SizedBox(height: MemoirSpace.s2 * scale),
              Text(
                'Chọn bất kỳ ngày nào để xem chi tiết theo giờ. Lượng mưa và '
                'xác suất là hai chỉ số riêng biệt.',
                style: caption,
              ),
            ],
          ),
        ),
        SizedBox(height: MemoirSpace.s4 * scale),
        WeatherPanel(
          scale: scale,
          title: 'Lượng mưa trong tuần',
          trailing: '${rainTotalWeekMm(days).round()} mm',
          subtitle: 'mm / ngày · Tích lũy trong từng ngày',
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              RainChart(
                values: rain,
                labels: [for (final day in days) '${day.date.day}'],
                ticks: axis.ticks,
                selectedIndex: index,
                onBarTap: onSelectDay,
                scale: scale,
              ),
              SizedBox(height: MemoirSpace.s2 * scale),
              Text(
                'Ngày ${weekRangeLabel(days)} · Cột đậm: ngày đang chọn',
                style: caption,
              ),
            ],
          ),
        ),
      ],
    );

    final supporting = supportingColumn(
      top: selected == null
          ? Text('Chưa có dự báo.', style: caption)
          : WeatherDaySummary(
              overline: 'NGÀY ĐANG CHỌN · ${fullDate(selected.date)}',
              dateLabel:
                  '${longWeekday(selected.date)}, ${shortDate(selected.date)}',
              condition: selected.condition,
              temperatureLabel:
                  temperaturePair(selected.tempMax, selected.tempMin),
              metrics: metricRowsFor(selected),
              scale: scale,
              actionLabel: 'Xem ngày & từng giờ',
              onAction: onOpenDay,
            ),
      scale: scale,
    );

    return WeatherForecastRegions(
      main: main,
      supporting: supporting,
      scale: scale,
    );
  }

  /// One `Daily forecast` row of the seven-day table.
  Widget _weekRow(BuildContext context, WeatherDay day, int i, bool selected) {
    final theme = Theme.of(context);
    final muted = theme.colorScheme.onSurfaceVariant;
    final palette = MemoirPalette.of(context);

    return InkWell(
      borderRadius: BorderRadius.circular(MemoirRadius.control * scale),
      onTap: () => onSelectDay(i),
      child: Container(
        padding: EdgeInsets.symmetric(
          vertical: MemoirSpace.s2 * scale,
          horizontal: MemoirSpace.s1 * scale,
        ),
        decoration: BoxDecoration(
          color: selected ? palette.surfaceBrandSubtle : null,
          borderRadius: BorderRadius.circular(MemoirRadius.control * scale),
        ),
        child: Row(
          children: [
            SizedBox(
              width: 86 * scale,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    i == 0 ? 'Hôm nay' : shortWeekday(day.date),
                    style: theme.textTheme.labelLarge?.copyWith(
                      color: selected
                          ? theme.colorScheme.primary
                          : theme.colorScheme.onSurface,
                      fontSize: MemoirType.label,
                    ),
                  ),
                  Text(
                    shortDate(day.date),
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: muted,
                      fontSize: MemoirType.caption,
                    ),
                  ),
                ],
              ),
            ),
            WeatherIcon(condition: day.condition, size: 24 * scale),
            SizedBox(width: MemoirSpace.s3 * scale),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    temperaturePair(day.tempMax, day.tempMin),
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: theme.colorScheme.onSurface,
                      fontSize: MemoirType.body,
                    ),
                  ),
                  Text(
                    day.condition,
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: muted,
                      fontSize: MemoirType.caption,
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(width: MemoirSpace.s3 * scale),
            SizedBox(
              width: 118 * scale,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '${rainTotalMm(day).round()} mm',
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: theme.colorScheme.onSurface,
                      fontSize: MemoirType.body,
                    ),
                  ),
                  Text(
                    'Xác suất ${rainChance(day)}%',
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: muted,
                      fontSize: MemoirType.caption,
                    ),
                  ),
                ],
              ),
            ),
            Icon(Icons.chevron_right, size: 14 * scale, color: muted),
          ],
        ),
      ),
    );
  }
}

/// The `Ngày` view: today's conditions, the day's hourly rhythm and the rain
/// hour by hour.
class WeatherDayTab extends StatelessWidget {
  const WeatherDayTab({
    super.key,
    required this.day,
    required this.scale,
    required this.onOpenHour,
  });

  final WeatherDay day;
  final double scale;

  /// Switches the screen to the `Theo giờ` view.
  final VoidCallback onOpenHour;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final muted = theme.colorScheme.onSurfaceVariant;
    final caption = theme.textTheme.bodySmall?.copyWith(
      color: muted,
      fontSize: MemoirType.caption,
    );
    final hours = hourlySeries(day);
    final preview = [
      for (final hour in previewHours) hours[hour.clamp(0, 23)],
    ];
    final rainValues = [for (final hour in hours) hour.rainMm];
    final rainScale = rainAxis(rainValues);

    final main = Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        WeatherPanel(
          scale: scale,
          child: WeatherDaySummary(
            overline: 'HÔM NAY · ${fullDate(day.date)}',
            dateLabel: '${longWeekday(day.date)}, ${shortDate(day.date)}',
            condition: day.condition,
            temperatureLabel: temperaturePair(day.tempMax, day.tempMin),
            metrics: metricRowsFor(day),
            scale: scale,
          ),
        ),
        SizedBox(height: MemoirSpace.s4 * scale),
        WeatherPanel(
          scale: scale,
          title: 'Nhịp trời trong ngày',
          trailing: '24 giờ →',
          onTrailingTap: onOpenHour,
          child: SizedBox(
            height: 122 * scale,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              itemCount: preview.length,
              separatorBuilder: (_, __) =>
                  SizedBox(width: MemoirSpace.s2 * scale),
              itemBuilder: (_, i) => _hourCard(context, preview[i]),
            ),
          ),
        ),
        SizedBox(height: MemoirSpace.s4 * scale),
        WeatherPanel(
          scale: scale,
          title: 'Lượng mưa theo giờ',
          trailing: '${rainTotalMm(day).round()} mm',
          subtitle: 'Mưa · mm tích lũy trong mỗi giờ',
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              RainChart(
                values: rainValues,
                labels: [for (final hour in hours) '${hour.hour}'],
                ticks: rainScale.ticks,
                labelEvery: 6,
                scale: scale,
              ),
              SizedBox(height: MemoirSpace.s2 * scale),
              Text(
                '00–23 giờ · ${fullDate(day.date)} · Giờ Việt Nam (UTC+7)',
                style: caption,
              ),
            ],
          ),
        ),
      ],
    );

    return WeatherForecastRegions(
      main: main,
      supporting: supportingColumn(
        scale: scale,
      ),
      scale: scale,
    );
  }

  /// One `Hour forecast` tile of the day's rhythm strip.
  Widget _hourCard(BuildContext context, WeatherHour hour) {
    final theme = Theme.of(context);
    final muted = theme.colorScheme.onSurfaceVariant;

    return Container(
      width: 104 * scale,
      padding: EdgeInsets.symmetric(
        vertical: MemoirSpace.s2 * scale,
        horizontal: MemoirSpace.s1 * scale,
      ),
      decoration: BoxDecoration(
        color: theme.colorScheme.surfaceContainerHighest,
        borderRadius: BorderRadius.circular(MemoirRadius.weather10 * scale),
        border: Border.all(color: theme.colorScheme.outlineVariant),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            hour.label,
            style: theme.textTheme.bodySmall?.copyWith(
              color: muted,
              fontSize: MemoirType.caption,
            ),
          ),
          WeatherIcon(condition: hour.condition, size: 22 * scale),
          Text(
            '${hour.temperature.round()}°',
            style: theme.textTheme.labelLarge?.copyWith(
              color: theme.colorScheme.onSurface,
              fontSize: MemoirType.label,
            ),
          ),
          Text(
            '${mmLabel(hour.rainMm)} mm',
            style: theme.textTheme.bodySmall?.copyWith(
              color: muted,
              fontSize: MemoirType.caption,
            ),
          ),
        ],
      ),
    );
  }
}

/// The `Theo giờ` view: rain and temperature across the 24 hours, the hourly
/// table and the conditions of the hour being looked at.
class WeatherHourTab extends StatelessWidget {
  const WeatherHourTab({
    super.key,
    required this.day,
    required this.selectedHour,
    required this.onSelectHour,
    required this.scale,
  });

  final WeatherDay day;
  final int selectedHour;
  final ValueChanged<int> onSelectHour;
  final double scale;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final muted = theme.colorScheme.onSurfaceVariant;
    final caption = theme.textTheme.bodySmall?.copyWith(
      color: muted,
      fontSize: MemoirType.caption,
    );
    final hours = hourlySeries(day);
    final index = selectedHour.clamp(0, 23);
    final selected = hours[index];
    final rainValues = [for (final hour in hours) hour.rainMm];
    final temps = [for (final hour in hours) hour.temperature];
    final rainScale = rainAxis(rainValues);
    final highTemp = (day.tempMax ?? temps.reduce((a, b) => a > b ? a : b))
        .ceilToDouble();
    final lowTemp = (day.tempMin ?? temps.reduce((a, b) => a < b ? a : b))
        .floorToDouble();
    final tempTicks = [highTemp, (highTemp + lowTemp) / 2, lowTemp];

    final main = Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        WeatherPanel(
          scale: scale,
          title: 'Mưa & nhiệt độ · 24 giờ',
          trailing: '${rainTotalMm(day).round()} mm',
          subtitle: 'Mưa · mm tích lũy trong mỗi giờ',
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              RainChart(
                values: rainValues,
                labels: [for (final hour in hours) '${hour.hour}'],
                ticks: rainScale.ticks,
                selectedIndex: index,
                onBarTap: onSelectHour,
                labelEvery: 6,
                scale: scale,
              ),
              SizedBox(height: MemoirSpace.s3 * scale),
              Text('Nhiệt độ · °C', style: caption),
              SizedBox(height: MemoirSpace.s2 * scale),
              TemperatureChart(
                values: temps,
                labels: [for (final hour in hours) '${hour.hour}'],
                ticks: tempTicks,
                selectedIndex: index,
                onPointTap: onSelectHour,
                labelEvery: 6,
                scale: scale,
              ),
              SizedBox(height: MemoirSpace.s3 * scale),
              Text(
                '00–23 giờ · ${fullDate(day.date)} · Giờ Việt Nam (UTC+7)',
                style: caption,
              ),
              SizedBox(height: MemoirSpace.s3 * scale),
              Row(
                children: [
                  Icon(Icons.schedule, size: 16 * scale, color: muted),
                  SizedBox(width: MemoirSpace.s2 * scale),
                  Expanded(
                    child: Text(
                      '${selected.label} · ${selected.temperature.round()}°C · '
                      '${mmLabel(selected.rainMm)} mm trong giờ',
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: theme.colorScheme.onSurface,
                        fontSize: MemoirType.body,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
        SizedBox(height: MemoirSpace.s4 * scale),
        WeatherPanel(
          scale: scale,
          title: 'Chi tiết 24 giờ · ${longWeekday(day.date)}, '
              '${shortDate(day.date)}',
          subtitle: 'Mưa tích lũy trong mỗi giờ · Hàng đậm: '
              '${selected.label} đang chọn',
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              _columnLabels(context),
              SizedBox(height: MemoirSpace.s1 * scale),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(child: _hourColumn(hours, index, 0)),
                  SizedBox(width: MemoirSpace.s4 * scale),
                  Expanded(child: _hourColumn(hours, index, 12)),
                ],
              ),
              SizedBox(height: MemoirSpace.s2 * scale),
              Text(
                'Tổng mưa: ${rainTotalMm(day).round()} mm · Thấp nhất '
                '${lowTemp.round()}°C / cao nhất ${highTemp.round()}°C',
                style: caption,
              ),
            ],
          ),
        ),
      ],
    );

    return WeatherForecastRegions(
      main: main,
      supporting: supportingColumn(
        top: _selectedHourPanel(context, selected),
        scale: scale,
      ),
      scale: scale,
    );
  }

  /// The `Giờ / °C / Mưa (mm)` header above the two hour columns.
  Widget _columnLabels(BuildContext context) {
    final theme = Theme.of(context);
    final style = theme.textTheme.bodySmall?.copyWith(
      color: theme.colorScheme.onSurfaceVariant,
      fontSize: MemoirType.caption,
    );

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: MemoirSpace.s2 * scale),
      child: Row(
        children: [
          SizedBox(width: 46 * scale, child: Text('Giờ', style: style)),
          SizedBox(width: MemoirSpace.s3 * scale),
          SizedBox(width: 16 * scale),
          SizedBox(width: MemoirSpace.s2 * scale),
          Expanded(child: Text('°C', style: style)),
          Text('Mưa (mm)', style: style),
        ],
      ),
    );
  }

  /// Twelve `Hourly record` rows starting at [from].
  Widget _hourColumn(List<WeatherHour> hours, int selectedIndex, int from) =>
      Column(
        children: [
          for (var i = from; i < from + 12 && i < hours.length; i++)
            HourTableRow(
              hour: hours[i],
              selected: i == selectedIndex,
              onTap: () => onSelectHour(i),
              scale: scale,
            ),
        ],
      );

  /// The `GIỜ ĐANG CHỌN` block of the supporting column.
  Widget _selectedHourPanel(BuildContext context, WeatherHour hour) {
    final theme = Theme.of(context);
    final muted = theme.colorScheme.onSurfaceVariant;
    final body = theme.textTheme.bodyMedium?.copyWith(
      color: theme.colorScheme.onSurface,
      fontSize: MemoirType.body,
    );
    final caption = theme.textTheme.bodySmall?.copyWith(
      color: muted,
      fontSize: MemoirType.caption,
      height: 1.5,
    );

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'GIỜ ĐANG CHỌN · ${shortDate(day.date)}',
          style: theme.textTheme.labelSmall?.copyWith(
            color: theme.colorScheme.primary,
            fontSize: MemoirType.overlineEditorial,
            letterSpacing: MemoirType.overlineEditorialLetterSpacing,
          ),
        ),
        SizedBox(height: MemoirSpace.s2 * scale),
        Row(
          children: [
            WeatherIcon(condition: hour.condition, size: 40 * scale),
            SizedBox(width: MemoirSpace.s3 * scale),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    hour.label,
                    style: theme.textTheme.headlineSmall?.copyWith(
                      color: theme.colorScheme.onSurface,
                      fontSize: MemoirType.heading1,
                      height:
                          MemoirType.heading1LineHeight / MemoirType.heading1,
                    ),
                  ),
                  Text(
                    '${hour.temperature.round()}°C · ${hour.condition}',
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: muted,
                      fontSize: MemoirType.body,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        SizedBox(height: MemoirSpace.s3 * scale),
        Text(
          '${mmLabel(hour.rainMm)} mm trong giờ ${hour.rangeLabel}',
          style: body,
        ),
        SizedBox(height: MemoirSpace.s1 * scale),
        Text(
          'Xác suất mưa ${rainChance(day)}% · Gió ${windDirection(day)} '
          '${windKmh(day)} km/h · Độ ẩm ${humidityPercent(day)}%',
          style: caption,
        ),
        SizedBox(height: MemoirSpace.s2 * scale),
        Text(
          'Giờ Việt Nam (UTC+7). Chọn một giờ trên biểu đồ hoặc trong bảng để '
          'xem chi tiết.',
          style: caption,
        ),
      ],
    );
  }
}
