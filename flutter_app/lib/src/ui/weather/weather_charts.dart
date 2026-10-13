import 'dart:math' as math;

import 'package:flutter/material.dart';

import '../theme.dart';
import '../tokens.dart';

/// Height of the label gutter on the left of both charts, in design pixels.
const double _axisGutter = 30;

/// Breathing room above the plot, and the band below it for the axis labels.
const double _topPad = 8;
const double _bottomPad = 22;

/// The value the top gridline of a rain chart carries.
///
/// [axisTicks] runs from 0 upward, so the scale has to come from the largest
/// tick: taking the first one leaves the top at 0, falls back to 1 and blows
/// every bar far past the canvas.
double rainAxisTop(List<double> ticks) {
  var top = 0.0;
  for (final tick in ticks) {
    if (tick > top) top = tick;
  }
  return top <= 0 ? 1 : top;
}

/// Bar chart of rain accumulation.
///
/// Used for the `Lượng mưa trong tuần` and `Lượng mưa theo giờ` plots: a light
/// grid with the axis values on the left, one bar per slot in the rain colour
/// and the selected slot darker.
class RainChart extends StatelessWidget {
  const RainChart({
    super.key,
    required this.values,
    required this.labels,
    required this.ticks,
    this.selectedIndex = -1,
    this.onBarTap,
    this.plotHeight = 158,
    this.labelEvery = 1,
    this.scale = 1,
  });

  /// Accumulation per slot, in millimetres.
  final List<double> values;

  /// One x axis label per slot.
  final List<String> labels;

  /// Axis values from the top of the plot down to 0.
  final List<double> ticks;

  final int selectedIndex;

  /// Called with a bar's index when it is tapped.
  final ValueChanged<int>? onBarTap;

  final double plotHeight;

  /// Draw every Nth x label; 1 draws all of them.
  final int labelEvery;

  final double scale;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final palette = MemoirPalette.of(context);

    final chart = SizedBox(
      width: double.infinity,
      height: plotHeight * scale,
      // Whatever the caller's axis says, a bar stays inside the plot instead of
      // bleeding over the cards around it.
      child: ClipRect(
        child: RepaintBoundary(
          child: CustomPaint(
            painter: _RainChartPainter(
              values: values,
              labels: labels,
              ticks: ticks,
              selectedIndex: selectedIndex,
              labelEvery: labelEvery,
              scale: scale,
              barColor: palette.rainChart,
              gridColor: theme.colorScheme.outlineVariant,
              labelColor: theme.colorScheme.onSurfaceVariant,
            ),
          ),
        ),
      ),
    );

    if (onBarTap == null || values.isEmpty) return chart;

    return LayoutBuilder(
      builder: (context, constraints) {
        final width = constraints.maxWidth;
        return GestureDetector(
          behavior: HitTestBehavior.opaque,
          onTapDown: (details) {
            if (!width.isFinite || width <= 0) return;
            final plotLeft = _axisGutter * scale;
            final plotWidth = width - plotLeft;
            if (plotWidth <= 0) return;
            final slot = plotWidth / values.length;
            final index = ((details.localPosition.dx - plotLeft) / slot).floor();
            if (index >= 0 && index < values.length) onBarTap!(index);
          },
          child: chart,
        );
      },
    );
  }
}

class _RainChartPainter extends CustomPainter {
  const _RainChartPainter({
    required this.values,
    required this.labels,
    required this.ticks,
    required this.selectedIndex,
    required this.labelEvery,
    required this.scale,
    required this.barColor,
    required this.gridColor,
    required this.labelColor,
  });

  final List<double> values;
  final List<String> labels;
  final List<double> ticks;
  final int selectedIndex;
  final int labelEvery;
  final double scale;
  final Color barColor;
  final Color gridColor;
  final Color labelColor;

  @override
  void paint(Canvas canvas, Size size) {
    if (values.isEmpty || size.width <= 0) return;

    final plotLeft = _axisGutter * scale;
    final plotRight = size.width;
    final plotTop = _topPad * scale;
    final plotBottom = size.height - _bottomPad * scale;
    if (plotRight <= plotLeft || plotBottom <= plotTop) return;

    final plotHeight = plotBottom - plotTop;
    final top = rainAxisTop(ticks);
    final line = Paint()
      ..color = gridColor
      ..strokeWidth = MemoirStroke.weather1;

    for (final tick in ticks) {
      final y = plotBottom - (tick / top) * plotHeight;
      canvas.drawLine(Offset(plotLeft, y), Offset(plotRight, y), line);
      _label(canvas, _format(tick), 0, y - _textHeight() / 2);
    }

    final slot = (plotRight - plotLeft) / values.length;
    final barWidth = math.min(slot * 0.34, 34 * scale);

    for (var i = 0; i < values.length; i++) {
      final value = values[i];
      final centerX = plotLeft + slot * (i + 0.5);
      final barHeight = (value / top) * plotHeight;
      final selected = i == selectedIndex;
      canvas.drawRRect(
        RRect.fromRectAndRadius(
          Rect.fromLTRB(
            centerX - barWidth / 2,
            plotBottom - barHeight,
            centerX + barWidth / 2,
            plotBottom,
          ),
          Radius.circular(3 * scale),
        ),
        Paint()
          ..color = selected ? barColor : barColor.withValues(alpha: 0.45),
      );

      // The bars carry no value label: the axis on the left and the card's
      // total already give the magnitude, and a label on a tall bar would sit
      // right on top of it.
      if (labelEvery > 0 && i % labelEvery == 0 && i < labels.length) {
        final text = labels[i];
        _label(
          canvas,
          text,
          centerX - _textWidth(text) / 2,
          plotBottom + 6 * scale,
        );
      }
    }
  }

  @override
  bool shouldRepaint(_RainChartPainter old) =>
      old.values != values ||
      old.labels != labels ||
      old.ticks != ticks ||
      old.selectedIndex != selectedIndex ||
      old.barColor != barColor;

  TextPainter _text(String value) => TextPainter(
        text: TextSpan(
          text: value,
          style: TextStyle(
            color: labelColor,
            fontSize: MemoirType.caption * scale,
            fontFamily: sansFamily,
          ),
        ),
        textDirection: TextDirection.ltr,
      )..layout();

  void _label(Canvas canvas, String value, double left, double top) =>
      _text(value).paint(canvas, Offset(left, top));

  double _textWidth(String value) => _text(value).width;

  double _textHeight() => _text('0').height;

  static String _format(double value) => value == value.roundToDouble()
      ? value.round().toString()
      : value.toStringAsFixed(1);
}

/// Line chart of the hourly temperature.
///
/// Used by the `Mưa & nhiệt độ · 24 giờ` plot: gridlines for the axis values,
/// the temperature polyline, and a marker on the selected hour.
class TemperatureChart extends StatelessWidget {
  const TemperatureChart({
    super.key,
    required this.values,
    required this.labels,
    required this.ticks,
    this.selectedIndex = -1,
    this.onPointTap,
    this.plotHeight = 130,
    this.labelEvery = 6,
    this.scale = 1,
  });

  /// Temperature per slot, in Celsius.
  final List<double> values;

  /// One x axis label per slot.
  final List<String> labels;

  /// Axis values from the top of the plot down to the bottom.
  final List<double> ticks;

  final int selectedIndex;
  final ValueChanged<int>? onPointTap;
  final double plotHeight;
  final int labelEvery;
  final double scale;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    final chart = SizedBox(
      width: double.infinity,
      height: plotHeight * scale,
      child: ClipRect(
        child: RepaintBoundary(
          child: CustomPaint(
            painter: _TemperatureChartPainter(
              values: values,
              labels: labels,
              ticks: ticks,
              selectedIndex: selectedIndex,
              labelEvery: labelEvery,
              scale: scale,
              lineColor: theme.colorScheme.primary,
              gridColor: theme.colorScheme.outlineVariant,
              labelColor: theme.colorScheme.onSurfaceVariant,
            ),
          ),
        ),
      ),
    );

    if (onPointTap == null || values.isEmpty) return chart;

    return LayoutBuilder(
      builder: (context, constraints) {
        final width = constraints.maxWidth;
        return GestureDetector(
          behavior: HitTestBehavior.opaque,
          onTapDown: (details) {
            if (!width.isFinite || width <= 0) return;
            final plotLeft = _axisGutter * scale;
            final plotWidth = width - plotLeft;
            if (plotWidth <= 0) return;
            final slot = plotWidth / values.length;
            final index = ((details.localPosition.dx - plotLeft) / slot).floor();
            if (index >= 0 && index < values.length) onPointTap!(index);
          },
          child: chart,
        );
      },
    );
  }
}

class _TemperatureChartPainter extends CustomPainter {
  const _TemperatureChartPainter({
    required this.values,
    required this.labels,
    required this.ticks,
    required this.selectedIndex,
    required this.labelEvery,
    required this.scale,
    required this.lineColor,
    required this.gridColor,
    required this.labelColor,
  });

  final List<double> values;
  final List<String> labels;
  final List<double> ticks;
  final int selectedIndex;
  final int labelEvery;
  final double scale;
  final Color lineColor;
  final Color gridColor;
  final Color labelColor;

  @override
  void paint(Canvas canvas, Size size) {
    if (values.isEmpty || ticks.isEmpty || size.width <= 0) return;

    final plotLeft = _axisGutter * scale;
    final plotRight = size.width;
    final plotTop = _topPad * scale;
    final plotBottom = size.height - _bottomPad * scale;
    final plotHeight = plotBottom - plotTop;
    if (plotRight <= plotLeft || plotHeight <= 0) return;

    final top = ticks.reduce(math.max);
    final bottom = ticks.reduce(math.min);
    final span = top - bottom;
    if (span <= 0) return;

    final grid = Paint()
      ..color = gridColor
      ..strokeWidth = MemoirStroke.weather1;
    for (final tick in ticks) {
      final y = plotBottom - ((tick - bottom) / span) * plotHeight;
      canvas.drawLine(Offset(plotLeft, y), Offset(plotRight, y), grid);
      _label(canvas, tick.round().toString(), 0, y - _textHeight() / 2);
    }

    final slot = (plotRight - plotLeft) / values.length;
    double xAt(int i) => plotLeft + slot * (i + 0.5);
    double yAt(double value) =>
        plotBottom - ((value - bottom) / span) * plotHeight;

    final path = Path();
    for (var i = 0; i < values.length; i++) {
      final point = Offset(xAt(i), yAt(values[i]));
      if (i == 0) {
        path.moveTo(point.dx, point.dy);
      } else {
        path.lineTo(point.dx, point.dy);
      }
    }
    canvas.drawPath(
      path,
      Paint()
        ..color = lineColor
        ..style = PaintingStyle.stroke
        ..strokeWidth = MemoirStroke.weather2
        ..strokeCap = StrokeCap.round
        ..strokeJoin = StrokeJoin.round,
    );

    for (var i = 0; i < values.length; i++) {
      if (i == selectedIndex) continue;
      canvas.drawCircle(
        Offset(xAt(i), yAt(values[i])),
        1.6 * scale,
        Paint()..color = lineColor.withValues(alpha: 0.6),
      );
    }

    if (labelEvery > 0) {
      for (var i = 0; i < labels.length && i < values.length; i++) {
        if (i % labelEvery != 0) continue;
        final text = labels[i];
        _label(
          canvas,
          text,
          xAt(i) - _textWidth(text) / 2,
          plotBottom + 6 * scale,
        );
      }
    }

    if (selectedIndex >= 0 && selectedIndex < values.length) {
      final x = xAt(selectedIndex);
      canvas.drawLine(
        Offset(x, plotTop),
        Offset(x, plotBottom),
        Paint()
          ..color = lineColor.withValues(alpha: MemoirOpacity.weather0p6)
          ..strokeWidth = MemoirStroke.weather1,
      );
      canvas.drawCircle(
        Offset(x, yAt(values[selectedIndex])),
        3.5 * scale,
        Paint()..color = lineColor,
      );
    }
  }

  @override
  bool shouldRepaint(_TemperatureChartPainter old) =>
      old.values != values ||
      old.labels != labels ||
      old.ticks != ticks ||
      old.selectedIndex != selectedIndex ||
      old.lineColor != lineColor;

  TextPainter _text(String value) => TextPainter(
        text: TextSpan(
          text: value,
          style: TextStyle(
            color: labelColor,
            fontSize: MemoirType.caption * scale,
            fontFamily: sansFamily,
          ),
        ),
        textDirection: TextDirection.ltr,
      )..layout();

  void _label(Canvas canvas, String value, double left, double top) =>
      _text(value).paint(canvas, Offset(left, top));

  double _textWidth(String value) => _text(value).width;

  double _textHeight() => _text('0').height;
}
