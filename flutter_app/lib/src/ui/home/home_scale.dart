import 'package:flutter/material.dart';

/// Width of the Figma web frames.
///
/// Everything under `ui/home` is authored against this width, so a wider window
/// only means a bigger reproduction of the same design. That matters on a
/// 1536 px desktop: the type tokens carry the mobile frame's 13 px body, which
/// reads as too small when the layout is pinned at 1:1.
const double kHomeDesignWidth = 1120;

/// Ceiling for [homeScaleFor]. Past this the side gutters come back so the page
/// does not turn into one giant card on an ultrawide monitor.
const double kHomeMaxScale = 1.5;

/// Scale factor that makes the 1120 px design fill a [viewportWidth] window.
///
/// Below the design width the factor stays 1, so phones keep the mobile layout
/// untouched, and it never exceeds [kHomeMaxScale].
double homeScaleFor(double viewportWidth) {
  if (!viewportWidth.isFinite || viewportWidth <= 0) return 1;
  return (viewportWidth / kHomeDesignWidth).clamp(1.0, kHomeMaxScale);
}

/// Publishes the home scale factor to the widgets below it.
///
/// [of] answers 1 when there is no ancestor, so widgets shared with the phone
/// layout — and the widget tests that pump them bare — keep their 1:1 sizes.
class HomeScale extends InheritedWidget {
  const HomeScale({super.key, required this.factor, required super.child});

  final double factor;

  static double of(BuildContext context) =>
      context.dependOnInheritedWidgetOfExactType<HomeScale>()?.factor ?? 1;

  @override
  bool updateShouldNotify(HomeScale oldWidget) => oldWidget.factor != factor;
}

/// Scales the fonts of the home on top of the platform's text scaling.
///
/// The reader's accessibility setting is multiplied, never replaced, so the
/// page grows for both reasons at once.
class HomeTextScaler extends TextScaler {
  const HomeTextScaler({required this.base, required this.factor});

  final TextScaler base;
  final double factor;

  @override
  double scale(double fontSize) => base.scale(fontSize * factor);

  /// Derived from [scale] instead of reading [base]'s deprecated getter.
  @override
  double get textScaleFactor => scale(1);

  @override
  bool operator ==(Object other) =>
      other is HomeTextScaler && other.base == base && other.factor == factor;

  @override
  int get hashCode => Object.hash(base, factor);
}
