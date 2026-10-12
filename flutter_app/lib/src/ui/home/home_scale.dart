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

/// Ceiling for [homeTextScaleFor]. The layout may zoom up to [kHomeMaxScale]
/// to fill a wide window, but the type stops well before that: past ~1.1 a
/// desktop page reads like a blown-up phone screen.
const double kHomeTextMaxScale = 1.1;

/// Scale factor that makes the 1120 px design fill a [viewportWidth] window.
///
/// Below the design width the factor stays 1, so phones keep the mobile layout
/// untouched, and it never exceeds [kHomeMaxScale].
double homeScaleFor(double viewportWidth) {
  if (!viewportWidth.isFinite || viewportWidth <= 0) return 1;
  return (viewportWidth / kHomeDesignWidth).clamp(1.0, kHomeMaxScale);
}

/// Factor the home's type and header chrome grow by.
///
/// The boxes keep [homeScaleFor] so the design still fills the window; only
/// the text is calmed down, otherwise a 1536 px screen renders a 17.8 px body
/// and a 49 px greeting.
double homeTextScaleFor(double viewportWidth) =>
    homeScaleFor(viewportWidth).clamp(1.0, kHomeTextMaxScale);

/// Publishes the home scale factors to the widgets below it.
///
/// Both getters answer 1 when there is no ancestor, so widgets shared with the
/// phone layout — and the widget tests that pump them bare — keep their 1:1
/// sizes.
class HomeScale extends InheritedWidget {
  const HomeScale({
    super.key,
    required this.factor,
    required this.textFactor,
    required super.child,
  });

  /// Grows boxes, paddings and the spacing between blocks.
  final double factor;

  /// Grows type and everything inside the header.
  final double textFactor;

  static double of(BuildContext context) =>
      context.dependOnInheritedWidgetOfExactType<HomeScale>()?.factor ?? 1;

  /// The text and header factor.
  static double textOf(BuildContext context) =>
      context.dependOnInheritedWidgetOfExactType<HomeScale>()?.textFactor ?? 1;

  @override
  bool updateShouldNotify(HomeScale oldWidget) =>
      oldWidget.factor != factor || oldWidget.textFactor != textFactor;
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
