import 'dart:math' as math;

import 'package:flutter/material.dart';

import '../../data/models.dart';
import '../theme.dart';
import 'route_format.dart';

/// Gutter for the rain axis on the left, in design pixels.
const double _axisGutter = 34;

const double _plotTop = 8;
const double _plotBottom = 30;

/// Bar chart of the rain along the route with the temperature drawn over it.
///
/// One plot, because the design reads the two together: the bars answer "will it
/// rain here", the line answers "how cold will it be", and both are indexed by
/// the kilometre marks underneath.
class RouteProgressChart extends StatelessWidget {
  const RouteProgressChart({
    super.key,
    required this.samples,
    required this.selectedSeq,
    required this.onSelect,
    this.height = 176,
    this.scale = 1,
  });

  final List<RouteWeatherSample> samples;
  final int? selectedSeq;
  final ValueChanged<RouteWeatherSample> onSelect;
  final double height;
  final double scale;

  @override
  Widget build(BuildContext context) {
    if (samples.length < 2) {
      return RouteNote(message: 'Chưa đủ điểm mẫu để vẽ biểu đồ.', scale: scale);
    }

    final theme = Theme.of(context);
    final palette = MemoirPalette.of(context);

    final chart = SizedBox(
      width: double.infinity,
      height: height * scale,
      child: ClipRect(
        child: CustomPaint(
          painter: _RouteProgressPainter(
            samples: samples,
            selectedSeq: selectedSeq,
            scale: scale,
            rainColor: palette.rainChart,
            lineColor: theme.colorScheme.primary,
            gridColor: theme.colorScheme.outlineVariant,
            labelColor: theme.colorScheme.onSurfaceVariant,
          ),
        ),
      ),
    );

    return LayoutBuilder(
      builder: (context, constraints) {
        final width = constraints.maxWidth;
        return GestureDetector(
          behavior: HitTestBehavior.opaque,
          onTapDown: (details) {
            if (!width.isFinite || width <= 0 || samples.isEmpty) return;
            final plotWidth = width - _axisGutter * scale;
            if (plotWidth <= 0) return;
            final step = plotWidth / (samples.length - 1);
            final index =
                ((details.localPosition.dx - _axisGutter * scale) / step)
                    .round()
                    .clamp(0, samples.length - 1);
            onSelect(samples[index]);
          },
          child: chart,
        );
      },
    );
  }
}

class _RouteProgressPainter extends CustomPainter {
  const _RouteProgressPainter({
    required this.samples,
    required this.selectedSeq,
    required this.scale,
    required this.rainColor,
    required this.lineColor,
    required this.gridColor,
    required this.labelColor,
  });

  final List<RouteWeatherSample> samples;
  final int? selectedSeq;
  final double scale;
  final Color rainColor;
  final Color lineColor;
  final Color gridColor;
  final Color labelColor;

  @override
  void paint(Canvas canvas, Size size) {
    final left = _axisGutter * scale;
    final top = _plotTop * scale;
    final bottom = size.height - _plotBottom * scale;
    final plotWidth = size.width - left;
    final plotHeight = bottom - top;
    if (plotWidth <= 0 || plotHeight <= 0) return;

    var maxRain = 0.0;
    for (final sample in samples) {
      final rain = sample.precipitationMm ?? 0;
      if (rain > maxRain) maxRain = rain;
    }
    // A dry route still needs a readable frame instead of a flat zero axis.
    if (maxRain <= 0) maxRain = 1;

    var minTemp = double.infinity;
    var maxTemp = -double.infinity;
    for (final sample in samples) {
      final temp = sample.tempC;
      if (temp == null) continue;
      minTemp = math.min(minTemp, temp);
      maxTemp = math.max(maxTemp, temp);
    }
    final hasTemp = minTemp.isFinite && maxTemp.isFinite;
    // A one degree spread would fill the whole plot; keep a floor on the range.
    final tempSpan = hasTemp ? math.max(1.0, maxTemp - minTemp) : 1.0;

    final gridPaint = Paint()
      ..color = gridColor
      ..strokeWidth = 1 * scale;
    for (var i = 0; i <= 3; i++) {
      final y = top + plotHeight * i / 3;
      canvas.drawLine(Offset(left, y), Offset(size.width, y), gridPaint);
    }

    final step = samples.length == 1 ? 0.0 : plotWidth / (samples.length - 1);
    double xOf(int index) => left + step * index;
    double yOfRain(double mm) => bottom - plotHeight * (mm / maxRain);
    double yOfTemp(double temp) =>
        bottom - plotHeight * 0.1 - plotHeight * 0.8 * ((temp - minTemp) / tempSpan);

    // Rain bars.
    final barWidth = math.max(2.0, step * 0.5);
    final barPaint = Paint()..color = rainColor;
    for (var i = 0; i < samples.length; i++) {
      final mm = samples[i].precipitationMm ?? 0;
      if (mm <= 0) continue;
      canvas.drawRRect(
        RRect.fromRectAndCorners(
          Rect.fromLTRB(
            xOf(i) - barWidth / 2,
            yOfRain(mm),
            xOf(i) + barWidth / 2,
            bottom,
          ),
          topLeft: Radius.circular(3 * scale),
          topRight: Radius.circular(3 * scale),
        ),
        barPaint,
      );
    }

    // Temperature line over the bars.
    if (hasTemp) {
      final linePaint = Paint()
        ..color = lineColor
        ..strokeWidth = 1.5 * scale
        ..style = PaintingStyle.stroke;
      final path = Path();
      var started = false;
      for (var i = 0; i < samples.length; i++) {
        final temp = samples[i].tempC;
        if (temp == null) continue;
        final point = Offset(xOf(i), yOfTemp(temp));
        if (!started) {
          path.moveTo(point.dx, point.dy);
          started = true;
        } else {
          path.lineTo(point.dx, point.dy);
        }
      }
      canvas.drawPath(path, linePaint);

      final dotPaint = Paint()..color = lineColor;
      for (var i = 0; i < samples.length; i++) {
        final temp = samples[i].tempC;
        if (temp == null) continue;
        canvas.drawCircle(Offset(xOf(i), yOfTemp(temp)), 2 * scale, dotPaint);
      }
    }

    // Axis numbers: the rain scale on the left, marks and kilometres below.
    _label(canvas, '${maxRain.round()} mm', Offset(left - 4 * scale, top),
        alignRight: true);
    _label(canvas, '0', Offset(left - 4 * scale, bottom - 6 * scale),
        alignRight: true);

    for (final index in _labelIndexes()) {
      _label(
        canvas,
        formatClock(samples[index].arrivalAt),
        Offset(xOf(index), bottom + 3 * scale),
        center: true,
      );
      _label(
        canvas,
        'Km ${(samples[index].distanceFromStartMeters / 1000).round()}',
        Offset(xOf(index), bottom + 15 * scale),
        center: true,
      );
    }

    // The selected sample: a line down to the axis and a marker on it.
    final selected = selectedSeq;
    if (selected == null) return;
    for (var i = 0; i < samples.length; i++) {
      if (samples[i].seq != selected) continue;
      final x = xOf(i);
      canvas.drawLine(
        Offset(x, top),
        Offset(x, bottom),
        Paint()
          ..color = lineColor.withValues(alpha: 0.4)
          ..strokeWidth = 1 * scale,
      );
      canvas.drawCircle(Offset(x, bottom), 3 * scale, Paint()..color = lineColor);
      break;
    }
  }

  /// Up to five evenly spaced x labels, so a 25 sample route stays readable.
  List<int> _labelIndexes() {
    final count = samples.length;
    if (count <= 5) return [for (var i = 0; i < count; i++) i];
    final marks = <int>{0, count - 1};
    for (var i = 1; i <= 3; i++) {
      marks.add(((count - 1) * i / 4).round());
    }
    return marks.toList()..sort();
  }

  void _label(
    Canvas canvas,
    String text,
    Offset at, {
    bool center = false,
    bool alignRight = false,
  }) {
    final painter = TextPainter(
      text: TextSpan(
        text: text,
        style: TextStyle(color: labelColor, fontSize: 9 * scale),
      ),
      textDirection: TextDirection.ltr,
    )..layout();
    var dx = at.dx;
    if (center) dx -= painter.width / 2;
    if (alignRight) dx -= painter.width;
    painter.paint(canvas, Offset(dx, at.dy));
  }

  @override
  bool shouldRepaint(_RouteProgressPainter oldDelegate) =>
      oldDelegate.samples != samples ||
      oldDelegate.selectedSeq != selectedSeq ||
      oldDelegate.scale != scale;
}

