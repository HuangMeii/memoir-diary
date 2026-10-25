import 'dart:async';
import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/api_exception.dart';
import '../../core/auth_provider.dart';
import '../../data/models.dart';
import '../../data/providers.dart';
import '../home/home_scale.dart';
import '../route/route_chrome.dart';
import '../route/route_format.dart';
import '../route/route_map_view.dart';
import '../route/route_panels.dart';
import '../route/route_progress_chart.dart';
import '../route/route_timeline.dart';
import '../route/save_journey_dialog.dart';
import '../route/saved_journeys_dialog.dart';
import '../tokens.dart';
import '../widgets/app_header.dart';
import 'calendar_screen.dart';
import 'entry_editor.dart';
import 'health_screen.dart';
import 'month_grids_screen.dart';
import '../route/route_planner_panel.dart';

/// Width of the `Thời tiết theo hành trình` frame: 1280 with 36 px gutters.
const double kRouteDesignWidth = 1280;

/// Content width of that frame.
const double kRouteContentWidth = 1208;

/// Width of the planner column in the band above the map.
///
/// It is the frame's `lg:col-span-4` panel: 4 of the 12 columns of the
/// 1208 px content, which works out at 384 px.
const double kRoutePlannerColumnWidth = 384;

/// Narrowest the map column may get before the band stacks instead.
///
/// Roughly the frame's `lg:col-span-8` column shrunk to its readable floor, so
/// the split still happens on a 1024 px window rather than only at the full
/// design width.
const double kRouteMapColumnMinWidth = 520;

/// Height of the map block when the band stacks.
///
/// Side by side the map takes the height of the planner column instead, so the
/// two columns end on the same line; stacked there is no row to take it from,
/// and this is the height the map draws itself at.
const double kRouteMapHeight = 360;

/// Gap between the two columns of the band: the frame's 28 px `gap-7`.
const double kRouteColumnGap = MemoirSpace.s7;

/// Narrowest the legs + safety-alerts row may get before it stacks instead.
///
/// Below this the two panels fall back to a column (legs on top, alerts
/// below) so neither card gets squeezed.
const double kRouteLegAlertsMinWidth = 720;

/// How long a stop name has to stay unchanged before it becomes part of the
/// route query (docs/12-route-weather.md §11).
///
/// The stop field is also the address field, so without this, typing an
/// address asks OSRM for a route once per letter.
const Duration kPlanDebounce = Duration(milliseconds: 400);

/// Route weather planner (`ROUTE-01`): manage the trip, read the forecast along
/// it, and save the trip to the journal.
///
/// The screen only ever sends the route query to the server. Sampling, the
/// travel-time estimate and the adverse-weather rules all live there, so the two
/// halves cannot drift apart.
class RouteWeatherScreen extends ConsumerStatefulWidget {
  const RouteWeatherScreen({super.key});

  @override
  ConsumerState<RouteWeatherScreen> createState() => _RouteWeatherScreenState();
}

class _RouteWeatherScreenState extends ConsumerState<RouteWeatherScreen> {
  /// Origin and destination, with any stopovers inserted between them.
  ///
  /// The origin starts at Ha Noi, the app's documented default location; the
  /// destination starts empty so the screen never invents a trip for the user.
  static const List<RouteStop> _initialStops = [
    RouteStop(name: 'Hà Nội', lat: 21.0285, lon: 105.8542, kind: 'origin'),
    RouteStop(name: '', lat: 0, lon: 0, kind: 'destination'),
  ];

  /// What the form shows. Follows every keystroke, so the field never lags.
  List<RouteStop> _stops = _initialStops;

  /// What the route query asks for: [_stops] once the typing has paused.
  ///
  /// Keeping the two apart is what lets the field stay responsive without the
  /// screen asking for a route once per letter (see [kPlanDebounce]).
  List<RouteStop> _plannedStops = _initialStops;

  Timer? _planTimer;

  String _vehicle = 'car';
  DateTime _departure = _nextHour();

  /// Which sample the timeline and the map are pointing at.
  int? _selectedSeq;

  /// Index of the stop the next tap on the map fills, or null when not picking.
  int? _pickTarget;

  /// The alternative route in use, and the forecast computed for it.
  int? _alternative;
  RoutePlan? _alternativePlan;
  RouteWeatherReport? _alternativeReport;

  bool _showDepartures = false;

  /// The next whole hour: a departure time already gone would look like a bug.
  static DateTime _nextHour() {
    final now = DateTime.now();
    return DateTime(now.year, now.month, now.day, now.hour)
        .add(const Duration(hours: 1));
  }

  bool get _ready =>
      _plannedStops.where((stop) => stop.name.trim().isNotEmpty).length >= 2;

  RouteQuery get _query => RouteQuery(
        stops: _plannedStops,
        vehicle: _vehicle,
        departureAt: _departure,
      );

  @override
  void dispose() {
    _planTimer?.cancel();
    super.dispose();
  }

  /// The route on screen: the chosen alternative when there is one.
  RoutePlan _displayPlan(RoutePlan plan) =>
      _alternative == null ? plan : (_alternativePlan ?? plan);

  RouteWeatherReport _displayReport(RouteWeatherReport report) =>
      _alternative == null ? report : (_alternativeReport ?? report);

  /// The trip changed, so an alternative picked for the old route is stale.
  ///
  /// [immediate] is for a discrete edit — picking a suggestion, a tap on the
  /// map, a dwell change, adding or removing a stop — where making the user
  /// wait would only feel slow. Typing a name passes `immediate: false`, so
  /// the route request waits until they stop (see [kPlanDebounce]).
  void _setStops(List<RouteStop> stops, {bool immediate = true}) {
    setState(() {
      _stops = stops;
      _alternative = null;
      _alternativePlan = null;
      _alternativeReport = null;
      _selectedSeq = null;
    });

    _planTimer?.cancel();
    if (immediate) {
      setState(() => _plannedStops = stops);
      return;
    }
    // Read [_stops] inside the callback rather than closing over [stops], so
    // the last keystroke wins even if an earlier timer somehow survives.
    _planTimer = Timer(kPlanDebounce, () {
      if (mounted) setState(() => _plannedStops = _stops);
    });
  }

  /// A tap on the map fills the stop the form has armed.
  ///
  /// The coordinates land at once — the marker should not wait for the
  /// network — and the name follows when the reverse lookup answers, so the
  /// field never keeps an address the pin has moved away from
  /// (docs/12-route-weather.md §11).
  void _onPickPoint(double lat, double lon) {
    final target = _pickTarget;
    if (target == null || target >= _stops.length) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'Chọn biểu tượng vị trí ở điểm cần đặt trước, rồi bấm lên bản đồ.',
          ),
        ),
      );
      return;
    }

    setState(() => _pickTarget = null);

    // A field that had no name yet — empty, or still showing the coordinates
    // of where the pin used to sit — takes the new label straight away, so
    // the stop is never named after the wrong point in the route request; a
    // field the user actually wrote in keeps its text until the lookup says
    // what is actually there.
    final current = _stops[target];
    final previousName = current.name;
    final unlabelled = previousName.trim().isEmpty ||
        previousName == _pickedPlaceLabel(current.lat, current.lon);
    final provisional = unlabelled ? _pickedPlaceLabel(lat, lon) : previousName;
    _setStops([
      for (var i = 0; i < _stops.length; i++)
        if (i != target)
          _stops[i]
        else
          _stops[i].copyWith(
            lat: lat,
            lon: lon,
            name: provisional,
          ),
    ]);

    unawaited(_resolvePickedName(target, lat, lon, provisional));
  }

  /// What the stop field says while the address at the tapped point is not
  /// known yet: the coordinates themselves.
  static String _pickedPlaceLabel(double lat, double lon) =>
      'Điểm đã chọn (${lat.toStringAsFixed(4)}, ${lon.toStringAsFixed(4)})';

  /// Names the stop a map tap moved, once the geocoder has answered.
  ///
  /// The answer is dropped if the stop has moved on — another tap, a
  /// keystroke — so it can never overwrite something newer. A lookup that
  /// finds nothing (or fails) falls back to the coordinates label: the field
  /// must always describe the point the marker sits on.
  Future<void> _resolvePickedName(
    int target,
    double lat,
    double lon,
    String nameAtPick,
  ) async {
    String? resolved;
    try {
      final place = await ref
          .read(routeRepositoryProvider)
          .reversePlace(lat: lat, lon: lon);
      resolved = place?.name.trim();
    } catch (_) {
      resolved = null;
    }
    if (!mounted) return;
    // Another edit owns the stop now; this answer belongs to the past.
    if (target >= _stops.length) return;
    final current = _stops[target];
    if (current.lat != lat || current.lon != lon) return;
    if (current.name != nameAtPick) return;

    final name = (resolved == null || resolved.isEmpty)
        ? _pickedPlaceLabel(lat, lon)
        : resolved;
    if (name == current.name) return;
    // Only the name is new — the geometry was planned when the tap landed —
    // so the follow-up request waits out the typing pause instead of firing
    // a second OSRM call straight away.
    _setStops(
      [
        for (var i = 0; i < _stops.length; i++)
          if (i != target) _stops[i] else current.copyWith(name: name),
      ],
      immediate: false,
    );
  }

  /// Re-reads the forecast for the route the user just picked.
  Future<void> _selectAlternative(int? index) async {
    if (index == null) {
      setState(() {
        _alternative = null;
        _alternativePlan = null;
        _alternativeReport = null;
      });
      return;
    }

    final planned = ref.read(routePlanProvider(_query)).valueOrNull;
    if (planned == null || index >= planned.plan.alternatives.length) return;

    final route = _planForAlternative(planned.plan, index);
    setState(() {
      _alternative = index;
      _alternativePlan = route;
      _alternativeReport = null;
    });

    try {
      final report = await ref
          .read(routeRepositoryProvider)
          .forecast(plan: route, departureAt: _departure);
      if (!mounted || _alternative != index) return;
      setState(() {
        _alternativeReport = report;
      });
    } catch (error) {
      if (!mounted) return;
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('$error')));
    }
  }

  /// The alternative, expressed as a plan the forecast endpoint accepts.
  ///
  /// It keeps the stops and their dwell times and swaps in the alternative
  /// geometry, distance and duration, which is exactly what changed.
  RoutePlan _planForAlternative(RoutePlan plan, int index) {
    final alternative = plan.alternatives[index];
    return RoutePlan(
      stops: plan.stops,
      distanceMeters: alternative.distanceMeters,
      durationSeconds: alternative.durationSeconds,
      geometry: alternative.geometry,
      legs: const [],
      alternatives: const [],
      source: plan.source,
      vehicle: plan.vehicle,
    );
  }

  /// Opens the save modal and reports what happened afterwards.
  Future<void> _save(RoutePlan plan, RouteWeatherReport report) async {
    final detail = await showDialog<JourneyDetail>(
      context: context,
      builder: (_) => SaveJourneyDialog(
        plan: plan,
        report: report,
        departureAt: _departure,
        vehicle: _vehicle,
        defaultTitle: '${plan.stops.first.name} → ${plan.stops.last.name}',
        defaultEntryText: _weatherSummary(plan, report),
        scale: HomeScale.of(context),
      ),
    );
    if (detail == null || !mounted) return;

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: const Text('Đã lưu hành trình vào nhật ký.'),
        action: detail.journey.isLinkedToEntry
            ? SnackBarAction(
                label: 'Mở nhật ký',
                onPressed: () => Navigator.of(context).push(
                  MaterialPageRoute<void>(
                    builder: (_) =>
                        EntryEditorScreen(date: _departure.toLocal()),
                  ),
                ),
              )
            : null,
      ),
    );
  }

  /// The weather summary the save modal offers to write into the diary entry.
  String _weatherSummary(RoutePlan plan, RouteWeatherReport report) {
    final stops = report.stopSamples;
    final buffer = StringBuffer()
      ..writeln('${plan.stops.first.name} → ${plan.stops.last.name} · '
          '${formatKm(plan.distanceMeters)} · '
          '${formatDuration(plan.durationSeconds)}')
      ..writeln('Khởi hành ${formatClockDay(_departure)}'
          '${stops.isEmpty ? '' : ', đến dự kiến ${formatClock(stops.last.arrivalAt)}'}.');

    for (final sample in stops) {
      buffer.writeln('- ${formatClock(sample.arrivalAt)} ${sample.label}: '
          '${sample.condition ?? 'chưa có dữ liệu'}'
          '${sample.tempC == null ? '' : ', ${sample.tempC!.round()}°C'}'
          '${sample.precipitationProbability == null ? '' : ', mưa ${sample.precipitationProbability}%'}');
    }
    for (final alert in report.alerts) {
      buffer.writeln('Lưu ý ${formatClock(alert.startAt)}–'
          '${formatClock(alert.endAt)}: ${alert.summary}');
    }
    buffer.write('Dự báo từ Open-Meteo, chỉ mang tính tham khảo.');
    return buffer.toString();
  }

  @override
  Widget build(BuildContext context) {
    final displayName =
        ref.watch(authProvider).user?['display_name'] as String?;

    return Scaffold(
      body: LayoutBuilder(
        builder: (context, constraints) {
          final scale = homeScaleFor(
            constraints.maxWidth,
            designWidth: kRouteDesignWidth,
          );
          final textScale = homeTextScaleFor(
            constraints.maxWidth,
            designWidth: kRouteDesignWidth,
          );
          final gutter = math.max(
            16.0,
            (constraints.maxWidth - kRouteContentWidth * scale) / 2,
          );
          final media = MediaQuery.of(context);

          return MediaQuery(
            data: media.copyWith(
              textScaler: textScale == 1
                  ? media.textScaler
                  : HomeTextScaler(base: media.textScaler, factor: textScale),
            ),
            child: HomeScale(
              factor: scale,
              textFactor: textScale,
              child: SafeArea(
                bottom: false,
                child: Column(
                  children: [
                    AppHeader(
                      date: DateTime.now(),
                      initials: initialsOf(displayName),
                      name: displayName,
                      destination: AppDestination.home,
                      onNavigate: (destination) {
                        if (destination == AppDestination.monthGrid) {
                          Navigator.of(context).push(
                            MaterialPageRoute<void>(
                              builder: (_) => const MonthGridsScreen(),
                            ),
                          );
                        } else if (destination == AppDestination.eventHistory) {
                          Navigator.of(context).push(
                            MaterialPageRoute<void>(
                              builder: (_) => const CalendarScreen(),
                            ),
                          );
                        } else if (destination == AppDestination.health) {
                          Navigator.of(context).push(
                            MaterialPageRoute<void>(
                              builder: (_) => const HealthScreen(),
                            ),
                          );
                        }
                      },
                      showUtilities: true,
                      gutter: gutter,
                      onLogout: () => ref.read(authProvider.notifier).logout(),
                    ),
                    Expanded(
                      child: ListView(
                        padding: EdgeInsets.fromLTRB(
                          gutter,
                          MemoirSpace.s4 * scale,
                          gutter,
                          MemoirSpace.s8 * scale,
                        ),
                        children: _sections(context, scale),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  /// The whole page, top to bottom.
  List<Widget> _sections(BuildContext context, double scale) {
    final async = _ready ? ref.watch(routePlanProvider(_query)) : null;
    final planned = async?.valueOrNull;
    final plan = planned == null ? null : _displayPlan(planned.plan);
    final report = planned == null ? null : _displayReport(planned.weather);

    return [
      RouteBreadcrumb(
        scale: scale,
        onBack: () => Navigator.of(context).maybePop(),
      ),
      SizedBox(height: MemoirSpace.s3 * scale),
      RouteHero(
        scale: scale,
        comparing: _showDepartures,
        onCompare: plan == null
            ? null
            : () => setState(() => _showDepartures = !_showDepartures),
        onSave:
            plan == null || report == null ? null : () => _save(plan, report),
        onSaved: () => showSavedJourneys(context),
      ),
      SizedBox(height: MemoirSpace.s4 * scale),
      _plannerBand(context, scale, plan, report, async),
      ..._belowMap(scale, plan, report),
    ];
  }

  void _changeVehicle(String value) => setState(() {
        _vehicle = value;
        _resetAlternative();
      });

  void _changeDeparture(DateTime value) => setState(() {
        _departure = value;
        _selectedSeq = null;
        _resetAlternative();
      });

  /// Drops an alternative picked for a route, vehicle or time that changed.
  void _resetAlternative() {
    _alternative = null;
    _alternativePlan = null;
    _alternativeReport = null;
  }

  /// The band above the analysis: the planner form and the map share one row on
  /// a wide window, and the live-data block runs the full width under them.
  ///
  /// This is the `lg:col-span-4 / 8` split of the reference frame: the form
  /// keeps the left column at its fixed width and the map takes the right one.
  /// Narrower than the breakpoint the blocks stack: form, map, live data.
  Widget _plannerBand(
    BuildContext context,
    double scale,
    RoutePlan? plan,
    RouteWeatherReport? report,
    AsyncValue<RoutePlanWithWeather>? async,
  ) {
    final panel = RoutePlannerPanel(
      stops: _stops,
      vehicle: _vehicle,
      departureAt: _departure,
      plan: plan,
      selectedAlternative: _alternative,
      pickTarget: _pickTarget,
      scale: scale,
      onStopsChanged: _setStops,
      onVehicleChanged: _changeVehicle,
      onDepartureChanged: _changeDeparture,
      onPickTarget: (value) => setState(() => _pickTarget = value),
      onSelectAlternative: _selectAlternative,
    );

    // The map and the live-data block both need a route; until there is one the
    // right column carries the card that says why there is no map yet.
    final hasRoute = plan != null && report != null;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        LayoutBuilder(
          builder: (context, constraints) {
            // Side by side only where the map still has room to read: a
            // squeezed row is worse than a stacked one.
            final sideBySide = constraints.maxWidth >=
                (kRoutePlannerColumnWidth +
                        kRouteColumnGap +
                        kRouteMapColumnMinWidth) *
                    scale;
            if (!sideBySide) {
              return Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  panel,
                  SizedBox(height: MemoirSpace.s4 * scale),
                  hasRoute
                      ? _mapSection(
                          scale,
                          plan,
                          report,
                          height: kRouteMapHeight,
                        )
                      : _statusCard(context, scale, plan, report, async),
                ],
              );
            }
            final planner = SizedBox(
              width: kRoutePlannerColumnWidth * scale,
              child: panel,
            );
            final gap = SizedBox(width: kRouteColumnGap * scale);

            // Without a route the right column is one short card, and stretching
            // it to the form's height would only draw an empty panel, so the
            // columns keep their own heights.
            if (!hasRoute) {
              return Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  planner,
                  gap,
                  Expanded(
                    child: _statusCard(context, scale, plan, report, async),
                  ),
                ],
              );
            }

            // With a route the map runs the whole height of the form, so the two
            // columns end on the same line. `IntrinsicHeight` is what gives the
            // row a height to hand out — the page this band sits in is a vertical
            // `ListView`, so a stretched row on its own would ask for an infinite
            // height and take the page's layout down with it.
            //
            // The map then takes that height through a `Stack`: `flutter_map`
            // builds a `LayoutBuilder`, which refuses intrinsic queries, and a
            // positioned child is left out of the stack's own intrinsics, so the
            // map is never asked for a height it cannot give.
            return IntrinsicHeight(
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  planner,
                  gap,
                  Expanded(
                    child: Stack(
                      children: [
                        Positioned.fill(
                          child: _mapSection(scale, plan, report),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            );
          },
        ),
        if (hasRoute) ...[
          SizedBox(height: MemoirSpace.s4 * scale),
          RouteSummary(
            plan: plan,
            report: report,
            scale: scale,
            onRetryForecast: report.isUnavailable
                ? () => ref.invalidate(routePlanProvider(_query))
                : null,
          ),
        ],
      ],
    );
  }

  /// What the band's right column carries until the route is known: the state
  /// the page is in, in place of the map.
  ///
  /// Keeping every state in this one column — the map included — is what lets
  /// the form stay put on the left, whether the route is still typed, loading,
  /// or failed.
  Widget _statusCard(
    BuildContext context,
    double scale,
    RoutePlan? plan,
    RouteWeatherReport? report,
    AsyncValue<RoutePlanWithWeather>? async,
  ) {
    if (async == null) {
      return _messageCard(
        context,
        scale,
        Icons.travel_explore,
        'Chọn điểm xuất phát và điểm đến để xem thời tiết dọc đường.',
      );
    }
    if (async.hasError && !async.isLoading) {
      return _errorCard(context, scale, async.error!);
    }
    if (plan == null || report == null) return _loadingCard(context, scale);
    return RouteSummary(
      plan: plan,
      report: report,
      scale: scale,
      onRetryForecast: report.isUnavailable
          ? () => ref.invalidate(routePlanProvider(_query))
          : null,
    );
  }

  /// Everything under the map: the progress chart, the legs, the safety
  /// callout, the departure comparison and the source disclaimer.
  ///
  /// Empty until a route is on screen, because the band already shows the state
  /// the page is in.
  List<Widget> _belowMap(
    double scale,
    RoutePlan? plan,
    RouteWeatherReport? report,
  ) {
    if (plan == null || report == null) return const [];

    return [
      SizedBox(height: MemoirSpace.s4 * scale),
      RouteSection(
        overline: 'Phân tích hành trình',
        title: 'Dự báo thời tiết dọc hành trình',
        subtitle: 'Cột là lượng mưa từng điểm, đường là nhiệt độ.',
        scale: scale,
        child: RouteProgressChart(
          samples: report.samples,
          selectedSeq: _selectedSeq,
          scale: scale,
          onSelect: (sample) => setState(() => _selectedSeq = sample.seq),
        ),
      ),
      SizedBox(height: MemoirSpace.s4 * scale),
      _legsAlertsRow(scale, plan, report),
      if (_showDepartures) ...[
        SizedBox(height: MemoirSpace.s4 * scale),
        RouteDepartureCompare(
          options: ref.watch(routeDeparturesProvider(_query)).valueOrNull ??
              const [],
          scale: scale,
          onApply: (option) => _changeDeparture(option.departureAt.toLocal()),
        ),
      ],
      SizedBox(height: MemoirSpace.s5 * scale),
      RouteNote(
        icon: Icons.verified_outlined,
        scale: scale,
        message: 'Nguồn: OSRM (tuyến đường) · Open-Meteo (thời tiết) · '
            'bản đồ © OpenStreetMap contributors. Thời tiết có thể thay đổi và '
            'Memoir không tự dự đoán — hãy quan sát biển báo và điều kiện giao '
            'thông thực tế khi lái xe.',
      ),
    ];
  }

  /// Legs + safety alerts on one row: legs left, alerts right, half each.
  ///
  /// Wide enough for [kRouteLegAlertsMinWidth] the two cards sit side by side;
  /// narrower they stack (legs on top) so neither is squeezed.
  ///
  /// No `IntrinsicHeight` here on purpose: `RouteTimeline` sizes itself with a
  /// `LayoutBuilder`, which refuses intrinsic queries, so asking the row for
  /// equal heights freezes the page as soon as this section scrolls into view.
  /// Each card keeps its natural height instead.
  Widget _legsAlertsRow(
    double scale,
    RoutePlan plan,
    RouteWeatherReport report,
  ) {
    final legs = RouteSection(
      overline: 'Chi tiết chặng',
      title: '${math.max(0, report.stopSamples.length - 1)} chặng di chuyển',
      subtitle: 'Chọn một chặng để làm nổi vị trí trên bản đồ.',
      scale: scale,
      child: RouteTimeline(
        plan: plan,
        report: report,
        selectedSeq: _selectedSeq,
        scale: scale,
        onSelect: (sample) => setState(() => _selectedSeq = sample.seq),
      ),
    );
    final alerts = RouteAlertsPanel(
      report: report,
      scale: scale,
      onSelect: (seq) => setState(() => _selectedSeq = seq),
    );

    return LayoutBuilder(
      builder: (context, constraints) {
        if (constraints.maxWidth < kRouteLegAlertsMinWidth * scale) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              legs,
              SizedBox(height: MemoirSpace.s4 * scale),
              alerts,
            ],
          );
        }
        final fixedHeight = 720 * scale;
        return Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: SizedBox(
                height: fixedHeight,
                child: SingleChildScrollView(child: legs),
              ),
            ),
            SizedBox(width: MemoirSpace.s4 * scale),
            Expanded(
              child: SizedBox(
                height: fixedHeight,
                child: SingleChildScrollView(child: alerts),
              ),
            ),
          ],
        );
      },
    );
  }

  /// The map of the route.
  ///
  /// [height] is what the map draws itself at when it has to size itself, which
  /// is the stacked band on a narrow window. Side by side it stays null: the
  /// band's row already hands out a height — the planner column's — and the map
  /// takes all of it, so the two columns end on the same line.
  Widget _mapSection(
    double scale,
    RoutePlan plan,
    RouteWeatherReport report, {
    double? height,
  }) {
    return RouteMapView(
      plan: plan,
      report: report,
      selectedSeq: _selectedSeq,
      height: height,
      scale: scale,
      onPickPoint: _onPickPoint,
    );
  }

  /// Shown while the route is planned and the forecast fetched.
  Widget _loadingCard(BuildContext context, double scale) {
    final theme = Theme.of(context);
    return Card(
      margin: EdgeInsets.zero,
      child: Padding(
        padding: EdgeInsets.all(MemoirSpace.s8 * scale),
        child: Column(
          children: [
            const CircularProgressIndicator(),
            SizedBox(height: MemoirSpace.s4 * scale),
            Text(
              'Đang tính tuyến đường và lấy dự báo…',
              style: theme.textTheme.bodyMedium?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
                fontSize: MemoirType.body,
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// Shown when the planner has no usable route yet.
  Widget _messageCard(
    BuildContext context,
    double scale,
    IconData icon,
    String message,
  ) {
    final theme = Theme.of(context);
    return Card(
      margin: EdgeInsets.zero,
      child: Padding(
        padding: EdgeInsets.all(MemoirSpace.s6 * scale),
        child: Row(
          children: [
            Icon(icon, size: 22 * scale, color: theme.colorScheme.primary),
            SizedBox(width: MemoirSpace.s3 * scale),
            Expanded(
              child: Text(
                message,
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: theme.colorScheme.onSurfaceVariant,
                  fontSize: MemoirType.body,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// Shown when planning failed, with the message the server sent.
  ///
  /// The backend's codes get their own wording: a missing route is not the same
  /// problem as a provider that refused too many requests, and neither is the
  /// same as a stop that was never given a position.
  Widget _errorCard(BuildContext context, double scale, Object error) {
    final theme = Theme.of(context);
    final code = error is ApiException ? error.code : null;
    final message = switch (code) {
      // OSRM refused the request outright, which in practice means a stop is
      // still sitting at 0,0 because its name was typed rather than searched.
      'noPoints' => 'Điểm đi hoặc điểm đến chưa xác định được vị trí. Bấm nút '
          'tìm kiếm rồi chọn từ danh sách, hoặc chọn trực tiếp trên bản đồ.',
      'noRoute' => 'Không tìm thấy tuyến đường giữa các điểm đã chọn. '
          'Thử đổi điểm hoặc phương tiện.',
      'rateLimited' =>
        'Đã vượt giới hạn truy vấn. Vui lòng thử lại sau ít phút.',
      'unavailable' => 'Không kết nối được tới máy chủ dữ liệu.',
      _ => '$error',
    };

    return Card(
      margin: EdgeInsets.zero,
      child: Padding(
        padding: EdgeInsets.all(MemoirSpace.s6 * scale),
        child: Column(
          children: [
            Icon(
              code == 'noPoints'
                  ? Icons.location_off_outlined
                  : code == 'noRoute'
                      ? Icons.wrong_location_outlined
                      : Icons.wifi_off_outlined,
              size: 22 * scale,
              color: theme.colorScheme.error,
            ),
            SizedBox(height: MemoirSpace.s3 * scale),
            Text(
              message,
              textAlign: TextAlign.center,
              style: theme.textTheme.bodyMedium?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
                fontSize: MemoirType.body,
              ),
            ),
            SizedBox(height: MemoirSpace.s3 * scale),
            FilledButton.icon(
              onPressed: () => ref.invalidate(routePlanProvider(_query)),
              icon: const Icon(Icons.refresh, size: 16),
              label: const Text('Thử lại'),
            ),
          ],
        ),
      ),
    );
  }
}
