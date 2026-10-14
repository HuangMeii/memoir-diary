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
import 'month_grids_screen.dart';
import '../route/route_planner_panel.dart';

/// Width of the `Thời tiết theo hành trình` frame: 1280 with 36 px gutters.
const double kRouteDesignWidth = 1280;

/// Content width of that frame.
const double kRouteContentWidth = 1208;

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
  List<RouteStop> _stops = const [
    RouteStop(name: 'Hà Nội', lat: 21.0285, lon: 105.8542, kind: 'origin'),
    RouteStop(name: '', lat: 0, lon: 0, kind: 'destination'),
  ];

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
  bool _loadingAlternative = false;

  bool _showDepartures = false;

  /// The next whole hour: a departure time already gone would look like a bug.
  static DateTime _nextHour() {
    final now = DateTime.now();
    return DateTime(now.year, now.month, now.day, now.hour)
        .add(const Duration(hours: 1));
  }

  bool get _ready =>
      _stops.where((stop) => stop.name.trim().isNotEmpty).length >= 2;

  RouteQuery get _query => RouteQuery(
        stops: _stops,
        vehicle: _vehicle,
        departureAt: _departure,
      );

  /// The route on screen: the chosen alternative when there is one.
  RoutePlan _displayPlan(RoutePlan plan) =>
      _alternative == null ? plan : (_alternativePlan ?? plan);

  RouteWeatherReport _displayReport(RouteWeatherReport report) =>
      _alternative == null ? report : (_alternativeReport ?? report);

  /// The trip changed, so an alternative picked for the old route is stale.
  void _setStops(List<RouteStop> stops) => setState(() {
        _stops = stops;
        _alternative = null;
        _alternativePlan = null;
        _alternativeReport = null;
        _selectedSeq = null;
      });

  /// A tap on the map fills the stop the form has armed.
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

    final stops = [
      for (var i = 0; i < _stops.length; i++)
        if (i != target)
          _stops[i]
        else
          _stops[i].copyWith(
            lat: lat,
            lon: lon,
            name: _stops[i].name.trim().isEmpty
                ? 'Điểm đã chọn (${lat.toStringAsFixed(4)}, '
                    '${lon.toStringAsFixed(4)})'
                : _stops[i].name,
          ),
    ];
    setState(() => _pickTarget = null);
    _setStops(stops);
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
      _loadingAlternative = true;
    });

    try {
      final report = await ref
          .read(routeRepositoryProvider)
          .forecast(plan: route, departureAt: _departure);
      if (!mounted || _alternative != index) return;
      setState(() {
        _alternativeReport = report;
        _loadingAlternative = false;
      });
    } catch (error) {
      if (!mounted) return;
      setState(() => _loadingAlternative = false);
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
                    builder: (_) => EntryEditorScreen(date: _departure.toLocal()),
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
    final displayName = ref.watch(authProvider).user?['display_name'] as String?;

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
                        } else if (destination ==
                            AppDestination.eventHistory) {
                          Navigator.of(context).push(
                            MaterialPageRoute<void>(
                              builder: (_) => const CalendarScreen(),
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
      RoutePlannerPanel(
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
      ),
      SizedBox(height: MemoirSpace.s4 * scale),
      ..._results(context, scale, plan, report, async),
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

  /// The part of the page that depends on the planned route.
  List<Widget> _results(
    BuildContext context,
    double scale,
    RoutePlan? plan,
    RouteWeatherReport? report,
    AsyncValue<RoutePlanWithWeather>? async,
  ) {
    if (async == null) {
      return [
        _messageCard(
          context,
          scale,
          Icons.travel_explore,
          'Chọn điểm xuất phát và điểm đến để xem thời tiết dọc đường.',
        ),
      ];
    }
    if (async.hasError && !async.isLoading) {
      return [_errorCard(context, scale, async.error!)];
    }
    if (plan == null || report == null) return [_loadingCard(context, scale)];

    return [
      RouteSummary(plan: plan, report: report, scale: scale),
      SizedBox(height: MemoirSpace.s4 * scale),
      _mapSection(context, scale, plan, report),
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
      RouteSection(
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
      ),
      SizedBox(height: MemoirSpace.s4 * scale),
      RouteAlertsPanel(
        report: report,
        scale: scale,
        onSelect: (seq) => setState(() => _selectedSeq = seq),
      ),
      if (_showDepartures) ...[
        SizedBox(height: MemoirSpace.s4 * scale),
        RouteDepartureCompare(
          options:
              ref.watch(routeDeparturesProvider(_query)).valueOrNull ?? const [],
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

  Widget _mapSection(
    BuildContext context,
    double scale,
    RoutePlan plan,
    RouteWeatherReport report,
  ) {
    final target = _pickTarget;
    final role = target == null || target >= _stops.length
        ? null
        : _stops[target].isOrigin
            ? 'điểm xuất phát'
            : _stops[target].isDestination
                ? 'điểm đến'
                : 'điểm dừng';

    return RouteSection(
      overline: 'Bản đồ lộ trình',
      title: 'Tuyến đường & trạm quan sát thời tiết',
      subtitle: role == null
          ? 'Bấm vào một điểm trên hành trình để xem chi tiết.'
          : 'Bấm lên bản đồ để đặt $role.',
      scale: scale,
      trailing: _alternative == null
          ? null
          : TextButton.icon(
              onPressed: () => _selectAlternative(null),
              icon: Icon(Icons.undo, size: 16 * scale),
              label: const Text(
                'Về tuyến đề xuất',
                style: TextStyle(fontSize: 13),
              ),
            ),
      child: Column(
        children: [
          if (_loadingAlternative)
            const Padding(
              padding: EdgeInsets.only(bottom: 8),
              child: LinearProgressIndicator(minHeight: 2),
            ),
          RouteMapView(
            plan: plan,
            report: report,
            selectedSeq: _selectedSeq,
            scale: scale,
            onSelectSample: (sample) =>
                setState(() => _selectedSeq = sample.seq),
            onPickPoint: _onPickPoint,
          ),
        ],
      ),
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
  /// problem as a provider that refused too many requests.
  Widget _errorCard(BuildContext context, double scale, Object error) {
    final theme = Theme.of(context);
    final code = error is ApiException ? error.code : null;
    final message = switch (code) {
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
              code == 'noRoute'
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




