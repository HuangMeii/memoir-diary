import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import '../../data/models.dart';
import '../../data/providers.dart';
import '../theme.dart';
import '../tokens.dart';
import '../widgets/segmented_tabs.dart';
import 'route_format.dart';

/// Reports a new stop list from the form.
///
/// [immediate] is false only while the user is still typing a name, so the
/// caller can hold the route request back instead of asking once per letter
/// (docs/12-route-weather.md §11).
typedef StopsChanged = void Function(List<RouteStop> stops, {bool immediate});

/// The planner form: where the trip starts and ends, what it stops at on the
/// way, how the traveller gets there, and when they leave.
///
/// Owns only the search box. Every other edit is handed back through
/// [onStopsChanged] and friends, so the screen keeps a single source of truth
/// for the request it sends to the server.
class RoutePlannerPanel extends ConsumerStatefulWidget {
  const RoutePlannerPanel({
    super.key,
    required this.stops,
    required this.vehicle,
    required this.departureAt,
    required this.plan,
    required this.selectedAlternative,
    required this.pickTarget,
    required this.scale,
    required this.onStopsChanged,
    required this.onVehicleChanged,
    required this.onDepartureChanged,
    required this.onPickTarget,
    required this.onSelectAlternative,
  });

  final List<RouteStop> stops;
  final String vehicle;
  final DateTime departureAt;
  final RoutePlan? plan;

  /// Index of the alternative route in use, or null for the primary one.
  final int? selectedAlternative;

  /// Index of the stop the next map tap fills, or null when not picking.
  final int? pickTarget;

  final double scale;

  final StopsChanged onStopsChanged;
  final ValueChanged<String> onVehicleChanged;
  final ValueChanged<DateTime> onDepartureChanged;

  /// Arms the map so the next tap fills stop [index].
  final ValueChanged<int?> onPickTarget;
  final ValueChanged<int?> onSelectAlternative;

  @override
  ConsumerState<RoutePlannerPanel> createState() => _RoutePlannerPanelState();
}

/// How long the form waits after the last keystroke before it looks the text
/// up. Long enough that a half-typed address never reaches the geocoder,
/// short enough that the list still feels like an answer to the typing.
const Duration _searchDebounce = Duration(seconds: 1);

/// How long the Search button stays disabled after a search. Comfortably
/// over the 1 second a Nominatim request may take, so presses can never
/// queue up into a burst. One counter for the whole form, so pressing fast
/// on two different stops is blocked just the same.
const Duration _throttleSeconds = Duration(milliseconds: 1500);

class _RoutePlannerPanelState extends ConsumerState<RoutePlannerPanel> {
  /// Which stop's suggestions are showing, or null when none are.
  int? _resultsIndex;

  /// The term the suggestions belong to. Empty means "nothing searched yet",
  /// which is what keeps results off the screen until a search has run.
  String _query = '';

  Timer? _throttle;

  /// The pause between the last keystroke and the search it asks for.
  Timer? _debounce;

  @override
  void dispose() {
    _throttle?.cancel();
    _debounce?.cancel();
    super.dispose();
  }

  bool get _coolingDown => _throttle?.isActive ?? false;

  /// True while the last search is still in flight, so a slow answer cannot be
  /// overtaken by a second request once the throttle has expired.
  bool get _inFlight =>
      _query.isNotEmpty && ref.read(placeSearchProvider(_query)).isLoading;

  /// Sends the search for [term] under stop [index].
  ///
  /// Reached three ways: the typing pause running out, Enter in the stop
  /// field, and the Search button beside it — never once per keystroke, which
  /// is what the [_searchDebounce] pause is for (docs/12-route-weather.md
  /// §11). A search arriving while the counter or an earlier request is still
  /// running is held back and tried again rather than dropped, so the list the
  /// user is waiting for always turns up, and Nominatim still sees at most one
  /// request per second.
  void _search(int index, String term) {
    final trimmed = term.trim();
    // Two characters is the server's own floor; asking with one is a wasted
    // round trip that only burns into the throttle.
    if (trimmed.length < 2) return;

    if (_coolingDown || _inFlight) {
      _armSearch(index, term, _throttleSeconds);
      return;
    }

    // The text is on its way now, so the pause that asked for it is spent.
    _debounce?.cancel();

    setState(() {
      _query = trimmed;
      _resultsIndex = index;
    });
    _throttle?.cancel();
    _throttle = Timer(_throttleSeconds, () {
      if (mounted) setState(() {});
    });
  }

  /// Restarts the pause before [term] is looked up: [after] from now.
  void _armSearch(int index, String term, [Duration after = _searchDebounce]) {
    _debounce?.cancel();
    _debounce = Timer(after, () {
      if (mounted) _search(index, term);
    });
  }

  /// The user is editing a stop's name.
  ///
  /// The new name goes up straight away with `immediate: false`, so the screen
  /// holds the route request back until the typing pauses, and the search for
  /// the address starts its own pause.
  void _onNameChanged(int index, String value) {
    _replaceStop(
      index,
      widget.stops[index].copyWith(name: value),
      // Still typing: the route request can wait.
      immediate: false,
    );

    final trimmed = value.trim();
    // Another stop's list must not sit under this field, and text too short to
    // search has no list at all. The same stop's own last answer stays put
    // until the new one lands, so the list does not flicker between keys.
    if (_resultsIndex != index || trimmed.length < 2) _clearResults();

    _debounce?.cancel();
    if (trimmed.length < 2) return;
    _armSearch(index, value);
  }

  /// The results no longer describe what is in the field.
  void _clearResults() {
    if (_resultsIndex == null && _query.isEmpty) return;
    setState(() {
      _resultsIndex = null;
      _query = '';
    });
  }

  void _replaceStop(int index, RouteStop stop, {bool immediate = true}) {
    final stops = [...widget.stops];
    stops[index] = stop;
    widget.onStopsChanged(stops, immediate: immediate);
  }

  void _removeStop(int index) {
    // The origin and the destination always stay; only waypoints go.
    if (index == 0 || index == widget.stops.length - 1) return;
    final stops = [...widget.stops]..removeAt(index);
    widget.onStopsChanged(stops);
  }

  void _addStop() {
    final stops = [...widget.stops];
    if (stops.length < 2) return;
    // Halfway between the last two points: inside the route on screen, and the
    // user can move it afterwards.
    final from = stops[stops.length - 2];
    final to = stops.last;
    stops.insert(
      stops.length - 1,
      RouteStop(
        name: 'Điểm dừng mới',
        lat: (from.lat + to.lat) / 2,
        lon: (from.lon + to.lon) / 2,
      ),
    );
    widget.onStopsChanged(stops);
  }

  void _reverse() => widget.onStopsChanged(widget.stops.reversed.toList());

  Future<void> _pickDeparture() async {
    final current = widget.departureAt.toLocal();
    final date = await showDatePicker(
      context: context,
      initialDate: current,
      firstDate: current.subtract(const Duration(days: 7)),
      lastDate: current.add(const Duration(days: 60)),
      helpText: 'Ngày khởi hành',
    );
    if (date == null || !mounted) return;
    final time = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.fromDateTime(current),
      helpText: 'Giờ khởi hành',
    );
    if (time == null || !mounted) return;
    widget.onDepartureChanged(
      DateTime(date.year, date.month, date.day, time.hour, time.minute),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final palette = MemoirPalette.of(context);
    final stops = widget.stops;
    final scale = widget.scale;
    final clock =
        DateFormat('dd.MM.yyyy · HH:mm').format(widget.departureAt.toLocal());

    return RouteSection(
      overline: 'Quản lý lộ trình',
      title: 'Chọn hành trình và các điểm dừng',
      subtitle: 'Nhập tên đường hoặc địa chỉ vào ô của điểm; danh sách địa '
          'điểm hiện ra sau khi bạn ngừng gõ một giây — hoặc nhấn Enter / nút '
          'tìm kiếm để tìm ngay.',
      scale: scale,
      trailing: TextButton.icon(
        onPressed: stops.length < 2 ? null : _reverse,
        icon: Icon(Icons.swap_vert, size: 16 * scale),
        label: const Text('Đảo chiều', style: TextStyle(fontSize: 13)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          for (var i = 0; i < stops.length; i++) ...[
            _StopRow(
              index: i,
              stop: stops[i],
              searching: _resultsIndex == i,
              picking: widget.pickTarget == i,
              canSearch: !_coolingDown,
              scale: scale,
              onName: (value) => _onNameChanged(i, value),
              onSearch: (term) => _search(i, term),
              onTogglePick: () =>
                  widget.onPickTarget(widget.pickTarget == i ? null : i),
              onDwell: (minutes) =>
                  _replaceStop(i, stops[i].copyWith(dwellMinutes: minutes)),
              onRemove:
                  i == 0 || i == stops.length - 1 ? null : () => _removeStop(i),
            ),
            // Nothing is fetched, and so nothing is shown, until the typing
            // has settled long enough for a search to run.
            if (_resultsIndex == i && _query.length >= 2)
              _PlaceResults(
                query: _query,
                scale: scale,
                onPick: (place) {
                  _replaceStop(i, place.toStop(stops[i].kind));
                  // The stop has its place, so no lookup is owed any more.
                  _debounce?.cancel();
                  setState(() {
                    _resultsIndex = null;
                    _query = '';
                  });
                },
              ),
            if (i != stops.length - 1)
              Padding(
                padding: EdgeInsets.only(
                  left: MemoirSpace.s6 * scale,
                  top: MemoirSpace.s1 * scale,
                ),
                child: Icon(
                  Icons.more_vert,
                  size: 14 * scale,
                  color: palette.textDisabled,
                ),
              ),
          ],
          SizedBox(height: MemoirSpace.s3 * scale),
          Wrap(
            spacing: MemoirSpace.s3 * scale,
            runSpacing: MemoirSpace.s2 * scale,
            crossAxisAlignment: WrapCrossAlignment.center,
            children: [
              OutlinedButton.icon(
                onPressed: _addStop,
                icon: Icon(Icons.add, size: 16 * scale),
                label: const Text('Thêm điểm dừng'),
              ),
              TextButton.icon(
                onPressed: _pickDeparture,
                icon: Icon(
                  Icons.schedule,
                  size: 16 * scale,
                  color: theme.colorScheme.primary,
                ),
                label: Text(
                  'Khởi hành $clock',
                  style: const TextStyle(fontSize: 13),
                ),
              ),
            ],
          ),
          SizedBox(height: MemoirSpace.s4 * scale),
          Text(
            'Phương tiện',
            style: theme.textTheme.bodySmall?.copyWith(
              color: theme.colorScheme.onSurfaceVariant,
              fontSize: MemoirType.caption,
            ),
          ),
          SizedBox(height: MemoirSpace.s2 * scale),
          SegmentedTabs<String>(
            options: [
              for (final vehicle in routeVehicles)
                SegmentedTab(vehicle.code, vehicle.label),
            ],
            selected: widget.vehicle,
            onChanged: widget.onVehicleChanged,
            scale: scale,
          ),
          if (widget.plan != null && widget.plan!.hasAlternatives) ...[
            SizedBox(height: MemoirSpace.s4 * scale),
            _Alternatives(
              plan: widget.plan!,
              selected: widget.selectedAlternative,
              scale: scale,
              onSelect: widget.onSelectAlternative,
            ),
          ],
        ],
      ),
    );
  }
}

/// One stop in the planner: its name, its role, and the actions that apply.
///
/// The name lives in a controller so typing does not fight the rebuild that
/// follows each keystroke; a name set from outside (a search result, a map tap)
/// is copied back in.
class _StopRow extends StatefulWidget {
  const _StopRow({
    required this.index,
    required this.stop,
    required this.searching,
    required this.picking,
    required this.canSearch,
    required this.scale,
    required this.onName,
    required this.onSearch,
    required this.onTogglePick,
    required this.onDwell,
    this.onRemove,
  });

  final int index;
  final RouteStop stop;

  /// True while this stop's suggestions are on screen.
  final bool searching;
  final bool picking;

  /// False while the search counter is running, so the button cannot be
  /// pressed into a burst.
  final bool canSearch;

  final double scale;

  final ValueChanged<String> onName;

  /// Runs a lookup for the text in this stop's field.
  final ValueChanged<String> onSearch;

  final VoidCallback onTogglePick;
  final ValueChanged<int> onDwell;
  final VoidCallback? onRemove;

  @override
  State<_StopRow> createState() => _StopRowState();
}

class _StopRowState extends State<_StopRow> {
  late final TextEditingController _controller =
      TextEditingController(text: widget.stop.name);

  @override
  void didUpdateWidget(_StopRow oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.stop.name != _controller.text) {
      _controller.text = widget.stop.name;
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final palette = MemoirPalette.of(context);
    final scale = widget.scale;
    final stop = widget.stop;
    final role = stop.isOrigin
        ? 'Điểm xuất phát'
        : stop.isDestination
            ? 'Điểm đến'
            : 'Điểm dừng ${widget.index}';

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(
              stop.isDestination ? Icons.place : Icons.circle,
              size: (stop.isDestination ? 14 : 9) * scale,
              color: theme.colorScheme.primary,
            ),
            SizedBox(width: MemoirSpace.s3 * scale),
            Expanded(
              child: TextField(
                controller: _controller,
                onChanged: widget.onName,
                // Enter locates, exactly like the Search button beside it.
                onSubmitted: widget.onSearch,
                textInputAction: TextInputAction.search,
                decoration: InputDecoration(
                  isDense: true,
                  labelText: role,
                  // Shows once the label floats, so it is the first thing the
                  // user reads when they go to type an address.
                  hintText: 'Nhập tên đường hoặc địa chỉ',
                  border: OutlineInputBorder(
                    borderRadius:
                        BorderRadius.circular(MemoirRadius.input * scale),
                  ),
                ),
                style: theme.textTheme.bodyMedium?.copyWith(
                  fontSize: MemoirType.bodyInput,
                ),
              ),
            ),
            SizedBox(width: MemoirSpace.s1 * scale),
            IconButton(
              tooltip: 'Tìm địa chỉ trong ô này',
              isSelected: widget.searching,
              // Disabled while the counter runs, which is what keeps presses
              // inside Nominatim's 1 request per second (docs/12 §11).
              onPressed:
                  widget.canSearch ? () => widget.onSearch(_controller.text) : null,
              icon: Icon(Icons.search, size: 18 * scale),
              visualDensity: VisualDensity.compact,
            ),
            IconButton(
              tooltip: 'Chọn trên bản đồ',
              isSelected: widget.picking,
              onPressed: widget.onTogglePick,
              icon: Icon(Icons.my_location, size: 18 * scale),
              visualDensity: VisualDensity.compact,
              color: widget.picking ? theme.colorScheme.primary : null,
            ),
            if (widget.onRemove != null)
              IconButton(
                tooltip: 'Xoá điểm dừng',
                onPressed: widget.onRemove,
                icon: Icon(Icons.close, size: 18 * scale),
                visualDensity: VisualDensity.compact,
                color: palette.textDisabled,
              ),
          ],
        ),
        // The dwell time only means something at a stopover.
        if (stop.isWaypoint)
          Padding(
            padding: EdgeInsets.only(
              left: MemoirSpace.s6 * scale,
              top: MemoirSpace.s1 * scale,
            ),
            child: Row(
              children: [
                Text(
                  'Thời gian dừng',
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: theme.colorScheme.onSurfaceVariant,
                    fontSize: MemoirType.caption,
                  ),
                ),
                SizedBox(width: MemoirSpace.s2 * scale),
                _StepButton(
                  icon: Icons.remove,
                  scale: scale,
                  onTap: stop.dwellMinutes <= 0
                      ? null
                      : () => widget.onDwell(stop.dwellMinutes - 15),
                ),
                Padding(
                  padding:
                      EdgeInsets.symmetric(horizontal: MemoirSpace.s2 * scale),
                  child: Text(
                    '${stop.dwellMinutes} phút',
                    style: theme.textTheme.bodySmall?.copyWith(
                      fontSize: MemoirType.body,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                _StepButton(
                  icon: Icons.add,
                  scale: scale,
                  onTap: stop.dwellMinutes >= 600
                      ? null
                      : () => widget.onDwell(stop.dwellMinutes + 15),
                ),
              ],
            ),
          ),
      ],
    );
  }
}

class _StepButton extends StatelessWidget {
  const _StepButton({required this.icon, required this.scale, this.onTap});

  final IconData icon;
  final double scale;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final palette = MemoirPalette.of(context);
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(MemoirRadius.pill),
      child: Container(
        width: 22 * scale,
        height: 22 * scale,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          border: Border.all(color: palette.borderDefault),
          borderRadius: BorderRadius.circular(MemoirRadius.pill),
        ),
        child: Icon(
          icon,
          size: 13 * scale,
          color:
              onTap == null ? palette.textDisabled : theme.colorScheme.primary,
        ),
      ),
    );
  }
}

/// The suggestions for one stop. Shown once a search has run: either the
/// typing paused for a second, or the user asked for it straight away with
/// Enter or the Search button — never once per keystroke.
///
/// It holds no state of its own: the term and the counters live in the panel,
/// so one counter covers the whole form and two stops cannot slip a second
/// request past another. See docs/12-route-weather.md §11.
class _PlaceResults extends ConsumerWidget {
  const _PlaceResults({
    required this.query,
    required this.scale,
    required this.onPick,
  });

  final String query;
  final double scale;
  final ValueChanged<PlaceCandidate> onPick;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final palette = MemoirPalette.of(context);

    return Padding(
      padding: EdgeInsets.only(
        left: MemoirSpace.s6 * scale,
        top: MemoirSpace.s2 * scale,
      ),
      child: Container(
        padding: EdgeInsets.all(MemoirSpace.s3 * scale),
        decoration: BoxDecoration(
          color: palette.surfaceBrandSubtle,
          borderRadius: BorderRadius.circular(MemoirRadius.control * scale),
        ),
        child: ref.watch(placeSearchProvider(query)).when(
              loading: () => const LinearProgressIndicator(minHeight: 2),
              error: (error, _) => RouteNote(message: '$error', scale: scale),
              data: (places) => places.isEmpty
                  ? RouteNote(
                      message: 'Không có địa điểm phù hợp.',
                      scale: scale,
                    )
                  : Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        for (final place in places)
                          ListTile(
                            dense: true,
                            visualDensity: VisualDensity.compact,
                            title: Text(
                              place.name,
                              style: theme.textTheme.bodyMedium
                                  ?.copyWith(fontSize: MemoirType.body),
                            ),
                            subtitle: place.subtitle.isEmpty
                                ? null
                                : Text(
                                    place.subtitle,
                                    style:
                                        theme.textTheme.bodySmall?.copyWith(
                                      color: theme.colorScheme.onSurfaceVariant,
                                      fontSize: MemoirType.caption,
                                    ),
                                  ),
                            onTap: () => onPick(place),
                          ),
                      ],
                    ),
            ),
      ),
    );
  }
}

/// The alternative routes the engine offered. Hidden entirely when there are
/// none, which is the common case: OSRM only returns them for some pairs.
class _Alternatives extends StatelessWidget {
  const _Alternatives({
    required this.plan,
    required this.selected,
    required this.scale,
    required this.onSelect,
  });

  final RoutePlan plan;
  final int? selected;
  final double scale;
  final ValueChanged<int?> onSelect;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final palette = MemoirPalette.of(context);
    final primary = plan.distanceMeters;

    Widget card(String title, String detail, int? value) {
      final active = selected == value;
      return InkWell(
        onTap: () => onSelect(value),
        borderRadius: BorderRadius.circular(MemoirRadius.control * scale),
        child: Container(
          margin: EdgeInsets.only(top: MemoirSpace.s2 * scale),
          padding: EdgeInsets.symmetric(
            horizontal: MemoirSpace.s3 * scale,
            vertical: MemoirSpace.s2 * scale,
          ),
          decoration: BoxDecoration(
            color: active ? palette.surfaceBrandSubtle : null,
            border: Border.all(
              color: active ? theme.colorScheme.primary : palette.borderDefault,
            ),
            borderRadius: BorderRadius.circular(MemoirRadius.control * scale),
          ),
          child: Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: theme.textTheme.bodyMedium?.copyWith(
                        fontSize: MemoirType.body,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    Text(
                      detail,
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: theme.colorScheme.onSurfaceVariant,
                        fontSize: MemoirType.caption,
                      ),
                    ),
                  ],
                ),
              ),
              if (active)
                Icon(
                  Icons.check,
                  size: 16 * scale,
                  color: theme.colorScheme.primary,
                ),
            ],
          ),
        ),
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Tuyến thay thế',
          style: theme.textTheme.bodySmall?.copyWith(
            color: theme.colorScheme.onSurfaceVariant,
            fontSize: MemoirType.caption,
          ),
        ),
        card(
          'Tuyến đề xuất',
          '${formatKm(primary)} · ${formatDuration(plan.durationSeconds)}',
          null,
        ),
        for (var i = 0; i < plan.alternatives.length; i++)
          card(
            'Phương án ${i + 1}',
            '${formatKm(plan.alternatives[i].distanceMeters)} · '
                '${formatDuration(plan.alternatives[i].durationSeconds)} · '
                '${plan.alternatives[i].distanceMeters >= primary ? '+' : '−'}'
                '${formatKm((plan.alternatives[i].distanceMeters - primary).abs())}',
            i,
          ),
      ],
    );
  }
}




