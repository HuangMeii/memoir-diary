import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/auth_provider.dart';
import '../../data/providers.dart';
import '../calendar/calendar_views.dart';
import '../home/home_scale.dart';
import '../theme.dart';
import '../tokens.dart';
import '../widgets/app_header.dart';
import '../widgets/segmented_tabs.dart';
import 'month_grids_screen.dart';

/// One event as `/events` returns it.
///
/// Kept tiny on purpose: the calendar only reads a handful of columns, so a
/// dedicated model is easier to read than Map casts spread over the widgets.
class PlannerEvent {
  const PlannerEvent({
    required this.id,
    required this.title,
    required this.startAt,
    this.endAt,
    this.location,
    this.description,
    this.reminderMinutes,
  });

  final String id;
  final String title;
  final DateTime startAt;
  final DateTime? endAt;
  final String? location;
  final String? description;

  /// Minutes before [startAt] the event asks to be reminded.
  final int? reminderMinutes;

  factory PlannerEvent.fromJson(Map<String, dynamic> json) => PlannerEvent(
        id: json['id'] as String? ?? '',
        title: json['title'] as String? ?? '',
        startAt: DateTime.tryParse(json['start_at'] as String? ?? '') ??
            DateTime.fromMillisecondsSinceEpoch(0),
        endAt: json['end_at'] == null
            ? null
            : DateTime.tryParse(json['end_at'] as String),
        location: json['location'] as String?,
        description: json['description'] as String?,
        reminderMinutes: json['reminder_minutes'] as int?,
      );
}

/// Rows from the backend's `/events` list into the calendar's own model.
List<PlannerEvent> eventsFromRows(List<Map<String, dynamic>> rows) =>
    [for (final row in rows) PlannerEvent.fromJson(row)];

/// The 42 cells (6 weeks × 7, Monday first) that frame [month]; null marks a
/// day of the neighbouring month.
List<DateTime?> calendarCells(DateTime month) {
  final first = DateTime(month.year, month.month, 1);
  final start = first.subtract(Duration(days: first.weekday - 1));
  return List<DateTime?>.generate(42, (i) {
    final day = start.add(Duration(days: i));
    return day.month == month.month ? day : null;
  });
}

/// The events of one full local day.
List<PlannerEvent> eventsOn(List<PlannerEvent> events, DateTime day) {
  final start = DateTime(day.year, day.month, day.day);
  return events
      .where((e) =>
          !e.startAt.isBefore(start) &&
          e.startAt.isBefore(start.add(const Duration(days: 1))))
      .toList();
}

/// Events starting at or after [from], oldest first.
List<PlannerEvent> upcomingAfter(List<PlannerEvent> events, DateTime from) {
  final list = events.where((e) => !e.startAt.isBefore(from)).toList()
    ..sort((a, b) => a.startAt.compareTo(b.startAt));
  return list;
}

/// The calendar (`CAL-01`) behind the `Lịch sử kiện` navigation entry: the
/// month grid with one dot per day that has an event, the events of the day
/// being looked at, the upcoming list and a `Tạo sự kiện` dialog — all on the
/// backend's `/events` rows (`events_endpoint.dart`).
class CalendarScreen extends ConsumerStatefulWidget {
  const CalendarScreen({super.key});

  @override
  ConsumerState<CalendarScreen> createState() => _CalendarScreenState();
}

class _CalendarScreenState extends ConsumerState<CalendarScreen> {
  List<PlannerEvent> _events = [];
  bool _loading = true;
  String? _errorMessage;

  /// Which of the design's three views is on.
  CalendarView _view = CalendarView.month;

  /// The day the `Ngày` and `Tuần` views — and the month grid's selection —
  /// point at.
  DateTime _anchor = _today();

  static DateTime _today() {
    final now = DateTime.now();
    return DateTime(now.year, now.month, now.day);
  }

  @override
  void initState() {
    super.initState();
    _load();
  }

  static bool _sameMonth(DateTime a, DateTime b) =>
      a.year == b.year && a.month == b.month;

  DateTime get _month => ref.read(selectedMonthProvider);

  /// Fetches the events of the window the current view shows plus a month of
  /// future events, so the grid's dots and the "sắp tới" list never go out of
  /// sync.
  Future<void> _load() async {
    final (visibleFrom, visibleTo) = _visibleRange;
    // A week of lead-in keeps the neighbouring weeks painted, and a month of
    // future events keeps the upcoming list whole.
    final from = visibleFrom.subtract(const Duration(days: 7));
    final horizon = _today().add(const Duration(days: 30));
    final to = visibleTo.isAfter(horizon) ? visibleTo : horizon;

    setState(() => _loading = true);
    try {
      final rows =
          await ref.read(plannerRepositoryProvider).eventsBetween(from, to);
      if (!mounted) return;
      setState(() {
        _events = eventsFromRows(rows);
        _loading = false;
        _errorMessage = null;
      });
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _loading = false;
        _errorMessage = '$e';
      });
    }
  }

  void _goToMonth(DateTime month) {
    ref.read(selectedMonthProvider.notifier).state =
        DateTime(month.year, month.month);
    _load();
  }

  /// The first and last day the current view shows.
  (DateTime, DateTime) get _visibleRange {
    switch (_view) {
      case CalendarView.day:
        return (_anchor, _anchor);
      case CalendarView.week:
        final monday = mondayOf(_anchor);
        return (monday, monday.add(const Duration(days: 6)));
      case CalendarView.month:
        final month = _month;
        return (
          DateTime(month.year, month.month, 1),
          DateTime(month.year, month.month + 1, 0),
        );
    }
  }

  /// The loaded events in the shape the `Ngày`/`Tuần` views want.
  List<CalendarEntry> get _entries => [
        for (final event in _events)
          CalendarEntry(
            id: event.id,
            title: event.title,
            start: event.startAt,
            end: event.endAt ?? event.startAt.add(const Duration(hours: 1)),
          ),
      ];

  /// Points the calendar at [day] and reloads the window behind it.
  void _setAnchor(DateTime day) {
    final normalized = DateTime(day.year, day.month, day.day);
    final movedMonth = !_sameMonth(normalized, _month);
    setState(() => _anchor = normalized);
    if (movedMonth) {
      ref.read(selectedMonthProvider.notifier).state =
          DateTime(normalized.year, normalized.month);
    }
    _load();
  }

  /// The `Hôm nay` pill.
  void _goToday() => _setAnchor(_today());

  /// The previous/next chevrons: a day, a week or a month, by view.
  void _shiftPeriod(int steps) {
    switch (_view) {
      case CalendarView.day:
        _setAnchor(_anchor.add(Duration(days: steps)));
      case CalendarView.week:
        _setAnchor(_anchor.add(Duration(days: 7 * steps)));
      case CalendarView.month:
        _goToMonth(DateTime(_month.year, _month.month + steps));
    }
  }

  /// The Lora period heading: `Chủ nhật, 11 tháng 10`, `5 – 11 tháng 10` or
  /// `Tháng 10`.
  String _periodTitle() {
    switch (_view) {
      case CalendarView.day:
        return '${weekdayName(_anchor)}, ${_anchor.day} tháng ${_anchor.month}';
      case CalendarView.week:
        final monday = mondayOf(_anchor);
        final sunday = monday.add(const Duration(days: 6));
        return monday.month == sunday.month
            ? '${monday.day} – ${sunday.day} tháng ${monday.month}'
            : '${monday.day} tháng ${monday.month} – ${sunday.day} tháng '
                '${sunday.month}';
      case CalendarView.month:
        return 'Tháng ${_month.month}';
    }
  }

  /// Opens the `Tạo sự kiện` dialog (Figma `42:27239`) and reloads on success.
  Future<void> _createEvent() async {
    final created = await showDialog<bool>(
      context: context,
      builder: (_) => _EventEditorDialog(
        defaultDate: _selectedDay(),
        onSave: (body) =>
            ref.read(plannerRepositoryProvider).create('/events', body),
      ),
    );
    if (created == true) await _load();
  }

  /// Deletes an event after a quick confirmation.
  Future<void> _deleteEvent(PlannerEvent event) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('Xoá sự kiện?'),
        content: Text('“${event.title}” sẽ bị xoá vĩnh viễn.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext, false),
            child: const Text('Không'),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(dialogContext, true),
            child: const Text('Xoá'),
          ),
        ],
      ),
    );
    if (confirmed != true) return;
    try {
      await ref
          .read(plannerRepositoryProvider)
          .delete('/events/${event.id}');
      await _load();
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('$e')));
    }
  }

  /// The day the month grid points at: the anchor while the browsed month holds
  /// it, otherwise today, otherwise the first of the month.
  DateTime _selectedDay() {
    final month = _month;
    if (_sameMonth(_anchor, month)) return _anchor;
    final today = _today();
    if (_sameMonth(today, month)) return today;
    return DateTime(month.year, month.month, 1);
  }

  @override
  Widget build(BuildContext context) {
    final today = DateTime.now();
    final displayName =
        ref.watch(authProvider).user?['display_name'] as String?;

    return Scaffold(
      body: LayoutBuilder(
        builder: (context, constraints) {
          final scale = homeScaleFor(
            constraints.maxWidth,
            designWidth: kMonthDesignWidth,
          );
          final textScale = homeTextScaleFor(
            constraints.maxWidth,
            designWidth: kMonthDesignWidth,
          );
          final gutter = math.max(
            16.0,
            (constraints.maxWidth - kMonthContentWidth * scale) / 2,
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
                      date: today,
                      initials: initialsOf(displayName),
                      name: displayName,
                      destination: AppDestination.eventHistory,
                      onNavigate: (destination) {
                        if (destination == AppDestination.home) {
                          Navigator.of(context)
                              .popUntil((route) => route.isFirst);
                        } else if (destination == AppDestination.monthGrid) {
                          Navigator.of(context).push(
                            MaterialPageRoute<void>(
                              builder: (_) => const MonthGridsScreen(),
                            ),
                          );
                        }
                      },
                      showUtilities: true,
                      gutter: gutter,
                      onLogout: () => ref.read(authProvider.notifier).logout(),
                    ),
                    Expanded(
                      child: _loading
                          ? const Center(child: CircularProgressIndicator())
                          : ListView(
                              padding: EdgeInsets.fromLTRB(
                                gutter,
                                MemoirSpace.s5 * scale,
                                gutter,
                                MemoirSpace.s8 * scale,
                              ),
                              children: [
                                _intro(context, scale),
                                SizedBox(height: MemoirSpace.s4 * scale),
                                _workspace(context, scale),
                                SizedBox(height: MemoirSpace.s5 * scale),
                                _eventsSections(context, scale),
                              ],
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

  /// Breadcrumb, the page title with its create entry point, and the month
  /// toolbar (`Lịch tháng · Web`): a Lora "Tháng 10" heading with a "Hôm nay"
  /// pill and the previous/next chevrons, plus the GMT+7 note.
  Widget _intro(BuildContext context, double scale) {
    final theme = Theme.of(context);
    final brand = theme.colorScheme.primary;
    const letterSpacing = MemoirType.overlineEditorialLetterSpacing;
    final month = _month;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        InkWell(
          onTap: () =>
              Navigator.of(context).popUntil((route) => route.isFirst),
          child: Padding(
            padding: EdgeInsets.symmetric(vertical: MemoirSpace.s1 * scale),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                // The design's `arrow-left` is not exported yet.
                Icon(Icons.arrow_back, size: 16 * scale, color: brand),
                SizedBox(width: MemoirSpace.s2 * scale),
                Text(
                  'Trang chủ',
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: brand,
                    fontSize: MemoirType.body,
                  ),
                ),
              ],
            ),
          ),
        ),
        SizedBox(height: MemoirSpace.s3 * scale),
        Row(
          children: [
            Expanded(
              child: Text(
                'Lịch sự kiện',
                style: TextStyle(
                  fontFamily: serifFamily,
                  fontSize: MemoirType.headingPage,
                  height: MemoirType.headingPageLineHeight /
                      MemoirType.headingPage,
                  color: theme.colorScheme.onSurface,
                ),
              ),
            ),
            FilledButton.icon(
              onPressed: _createEvent,
              icon: const Icon(Icons.add, size: 16),
              label: const Text('Tạo sự kiện'),
            ),
          ],
        ),
        SizedBox(height: MemoirSpace.s1 * scale),
        Row(
          children: [
            Expanded(
              child: Text(
                _periodTitle(),
                style: TextStyle(
                  fontFamily: serifFamily,
                  fontSize: MemoirType.headingEditorial,
                  height: MemoirType.headingEditorialLineHeight /
                      MemoirType.headingEditorial,
                  color: theme.colorScheme.onSurface,
                ),
              ),
            ),
            // `Hôm nay` pill.
            Container(
              padding: EdgeInsets.symmetric(
                horizontal: MemoirSpace.s3 * scale,
                vertical: MemoirSpace.s1 * scale,
              ),
              decoration: BoxDecoration(
                color: theme.colorScheme.surface,
                borderRadius: BorderRadius.circular(MemoirRadius.control * scale),
                border: Border.all(color: theme.colorScheme.outlineVariant),
              ),
              child: InkWell(
                borderRadius:
                    BorderRadius.circular(MemoirRadius.control * scale),
                onTap: _goToday,
                child: Text(
                  'Hôm nay',
                  style: theme.textTheme.labelLarge?.copyWith(
                    color: brand,
                    fontSize: MemoirType.label,
                  ),
                ),
              ),
            ),
            SizedBox(width: MemoirSpace.s1 * scale),
            IconButton(
              tooltip: 'Kỳ trước',
              onPressed: () => _shiftPeriod(-1),
              icon: Icon(
                Icons.chevron_left,
                size: 18 * scale,
                color: theme.colorScheme.onSurfaceVariant,
              ),
            ),
            IconButton(
              tooltip: 'Kỳ sau',
              onPressed: () => _shiftPeriod(1),
              icon: Icon(
                Icons.chevron_right,
                size: 18 * scale,
                color: theme.colorScheme.onSurfaceVariant,
              ),
            ),
            SizedBox(width: MemoirSpace.s3 * scale),
            // `View control`: `Ngày | Tuần | Tháng`.
            SegmentedTabs<CalendarView>(
              scale: scale,
              options: [
                for (final view in CalendarView.values)
                  SegmentedTab(view, view.label),
              ],
              selected: _view,
              onChanged: (view) {
                setState(() => _view = view);
                _load();
              },
            ),
          ],
        ),
        SizedBox(height: MemoirSpace.s1 * scale),
        Text(
          'Tháng ${month.month}, ${month.year} · Giờ Việt Nam (GMT+7)',
          style: theme.textTheme.bodySmall?.copyWith(
            color: theme.colorScheme.onSurfaceVariant,
            fontSize: MemoirType.caption,
            letterSpacing: letterSpacing,
          ),
        ),
      ],
    );
  }

  /// The two-region workspace of `Lịch ngày/tuần/tháng · Web`: the 220 px
  /// sidebar (mini date picker, calendar visibility, reminders) beside the body
  /// of the current view — the month grid, the week canvas or the day timeline.
  /// They stack into one column on narrow screens.
  Widget _workspace(BuildContext context, double scale) {
    final sidebar = _sidebar(context, scale);
    final body = switch (_view) {
      CalendarView.day => _canvasCard(
          context,
          CalendarDaySchedule(date: _anchor, entries: _entries, scale: scale),
        ),
      CalendarView.week => _canvasCard(
          context,
          CalendarWeekGrid(anchor: _anchor, entries: _entries, scale: scale),
        ),
      CalendarView.month => _calendarCard(context, scale),
    };
    return LayoutBuilder(
      builder: (context, constraints) {
        if (constraints.maxWidth >= 960 * scale) {
          return Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(width: 232 * scale, child: sidebar),
              SizedBox(width: MemoirSpace.s5 * scale),
              Expanded(child: body),
            ],
          );
        }
        return Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            body,
            SizedBox(height: MemoirSpace.s4 * scale),
            sidebar,
          ],
        );
      },
    );
  }

  /// The white card the `Ngày`/`Tuần` canvases sit in.
  ///
  /// Unlike the sidebar cards it has no padding: the timeline and its hairlines
  /// run to the card's edges, the way the frames draw them.
  Widget _canvasCard(BuildContext context, Widget child) {
    final theme = Theme.of(context);
    return Container(
      clipBehavior: Clip.antiAlias,
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(MemoirRadius.card),
        border: Border.all(color: theme.colorScheme.outlineVariant),
      ),
      child: child,
    );
  }

  Widget _sidebar(BuildContext context, double scale) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        _miniDatePicker(context, scale),
        SizedBox(height: MemoirSpace.s3 * scale),
        _visibilityCard(context, scale),
        SizedBox(height: MemoirSpace.s3 * scale),
        _reminderCard(context, scale),
      ],
    );
  }

  /// The sidebar's compact month navigator ("Date picker" frame).
  Widget _miniDatePicker(BuildContext context, double scale) {
    final theme = Theme.of(context);
    final month = _month;
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final first = DateTime(month.year, month.month, 1);
    final start = first.subtract(Duration(days: first.weekday - 1));
    final cells35 = List<DateTime?>.generate(35, (i) {
      final day = start.add(Duration(days: i));
      return day.month == month.month ? day : null;
    });

    return _sidebarCard(
      context,
      scale,
      Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  'Tháng ${month.month}',
                  style: theme.textTheme.labelLarge?.copyWith(
                    fontFamily: serifFamily,
                    fontSize: MemoirType.headingEditorial,
                    color: theme.colorScheme.onSurface,
                  ),
                ),
              ),
              IconButton(
                visualDensity: VisualDensity.compact,
                onPressed: () =>
                    _goToMonth(DateTime(month.year, month.month - 1)),
                icon: Icon(
                  Icons.chevron_left,
                  size: 16 * scale,
                  color: theme.colorScheme.onSurfaceVariant,
                ),
              ),
              IconButton(
                visualDensity: VisualDensity.compact,
                onPressed: () =>
                    _goToMonth(DateTime(month.year, month.month + 1)),
                icon: Icon(
                  Icons.chevron_right,
                  size: 16 * scale,
                  color: theme.colorScheme.onSurfaceVariant,
                ),
              ),
            ],
          ),
          SizedBox(height: MemoirSpace.s1 * scale),
          Row(
            children: [
              for (final label in const ['T2', 'T3', 'T4', 'T5', 'T6', 'T7', 'CN'])
                Expanded(
                  child: Center(
                    child: Text(
                      label,
                      style: theme.textTheme.labelSmall?.copyWith(
                        color: theme.colorScheme.onSurfaceVariant,
                        fontSize: MemoirType.caption,
                      ),
                    ),
                  ),
                ),
            ],
          ),
          const SizedBox(height: 4),
          for (var row = 0; row < 5; row++) ...[
            if (row > 0) const SizedBox(height: 4),
            Row(
              children: [
                for (var col = 0; col < 7; col++)
                  Expanded(
                    child: _miniDay(
                      context,
                      today,
                      cells35[row * 7 + col],
                    ),
                  ),
              ],
            ),
          ],
        ],
      ),
    );
  }

  /* PART7 */

  /// One day of the sidebar mini-calendar.
  Widget _miniDay(BuildContext context, DateTime today, DateTime? day) {
    final theme = Theme.of(context);
    if (day == null) return const SizedBox(height: 24);
    final isToday = day == today;
    final isSelected = day == _selectedDay();
    final hasEvent = eventsOn(_events, day).isNotEmpty;
    return SizedBox(
      height: 24,
      child: InkWell(
        onTap: () => _setAnchor(day),
        borderRadius: BorderRadius.circular(100),
        child: Center(
          child: Container(
            width: 22,
            height: 22,
            alignment: Alignment.center,
            decoration: (isToday || isSelected)
                ? BoxDecoration(
                    color: isSelected
                        ? theme.colorScheme.primary
                        : theme.colorScheme.primaryContainer,
                    shape: BoxShape.circle,
                  )
                : null,
            child: Text(
              '${day.day}',
              style: theme.textTheme.labelSmall?.copyWith(
                color: isSelected
                    ? theme.colorScheme.onPrimary
                    : isToday
                        ? theme.colorScheme.primary
                        : hasEvent
                            ? theme.colorScheme.onSurface
                            : theme.colorScheme.onSurfaceVariant,
                fontWeight:
                    isToday || isSelected ? FontWeight.w600 : FontWeight.w400,
                fontSize: MemoirType.caption,
              ),
            ),
          ),
        ),
      ),
    );
  }

  /// Shared chrome of the sidebar cards (white, radius 16, outline).
  Widget _sidebarCard(BuildContext context, double scale, Widget child) {
    final theme = Theme.of(context);
    return Container(
      padding: EdgeInsets.all(MemoirSpace.s4 * scale),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(MemoirRadius.card),
        border: Border.all(color: theme.colorScheme.outlineVariant),
      ),
      child: child,
    );
  }

  /// "Lịch của tôi" — which calendars feed the grid. Only "Sự kiện" is wired
  /// up; the other entries stay dimmed until their data lands.
  Widget _visibilityCard(BuildContext context, double scale) {
    final theme = Theme.of(context);
    Widget row(String label, {required bool active}) => Padding(
          padding: EdgeInsets.symmetric(vertical: MemoirSpace.s1 * scale),
          child: Row(
            children: [
              Icon(
                active ? Icons.check_box : Icons.check_box_outline_blank,
                size: 18 * scale,
                color: active
                    ? theme.colorScheme.primary
                    : theme.colorScheme.outlineVariant,
              ),
              SizedBox(width: MemoirSpace.s2 * scale),
              Expanded(
                child: Text(
                  label,
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: active
                        ? theme.colorScheme.onSurface
                        : theme.colorScheme.onSurfaceVariant
                            .withValues(alpha: 0.6),
                    fontSize: MemoirType.body,
                  ),
                ),
              ),
            ],
          ),
        );

    return _sidebarCard(
      context,
      scale,
      Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Lịch của tôi',
            style: theme.textTheme.labelLarge?.copyWith(
              color: theme.colorScheme.onSurface,
              fontSize: MemoirType.label,
            ),
          ),
          const SizedBox(height: MemoirSpace.s1),
          row('Sự kiện', active: true),
          row('Lịch biểu', active: false),
          row('Nhật ký', active: false),
          Text(
            'Các lịch đang hiển thị',
            style: theme.textTheme.bodySmall?.copyWith(
              color: theme.colorScheme.onSurfaceVariant,
              fontSize: MemoirType.caption,
            ),
          ),
        ],
      ),
    );
  }

  /// The sidebar's reminder summary: the next upcoming event plus a count.
  Widget _reminderCard(BuildContext context, double scale) {
    final theme = Theme.of(context);
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final upcoming = upcomingAfter(_events, today);

    return _sidebarCard(
      context,
      scale,
      Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                Icons.notifications_outlined,
                size: 16 * scale,
                color: theme.colorScheme.primary,
              ),
              SizedBox(width: MemoirSpace.s2 * scale),
              Text(
                'Nhắc nhở',
                style: theme.textTheme.labelLarge?.copyWith(
                  color: theme.colorScheme.onSurface,
                  fontSize: MemoirType.label,
                ),
              ),
            ],
          ),
          SizedBox(height: MemoirSpace.s2 * scale),
          if (upcoming.isEmpty)
            Text(
              'Chưa có sự kiện nào.',
              style: theme.textTheme.bodySmall?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
                fontSize: MemoirType.caption,
              ),
            )
          else ...[
            Text(
              '${upcoming.length} sự kiện sắp tới',
              style: theme.textTheme.bodySmall?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
                fontSize: MemoirType.caption,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              upcoming.first.title,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: theme.textTheme.bodyMedium?.copyWith(
                fontSize: MemoirType.body,
              ),
            ),
          ],
        ],
      ),
    );
  }

  /// The month grid card: weekday headers over six weeks of day cells.
  Widget _calendarCard(BuildContext context, double scale) {
    final theme = Theme.of(context);
    final cells = calendarCells(_month);
    return Card(
      margin: EdgeInsets.zero,
      child: Padding(
        padding: EdgeInsets.all(MemoirSpace.s3 * scale),
        child: Column(
          children: [
            Row(
              children: [
                for (final label
                    in const ['T2', 'T3', 'T4', 'T5', 'T6', 'T7', 'CN'])
                  Expanded(
                    child: Center(
                      child: Text(
                        label,
                        style: theme.textTheme.labelSmall?.copyWith(
                          color: theme.colorScheme.onSurfaceVariant,
                          fontSize: MemoirType.caption,
                        ),
                      ),
                    ),
                  ),
              ],
            ),
            SizedBox(height: MemoirSpace.s1 * scale),
            for (var week = 0; week < 6; week++) ...[
              if (week > 0) SizedBox(height: 6 * scale),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  for (var day = 0; day < 7; day++)
                    Expanded(
                      child: Padding(
                        padding: EdgeInsets.symmetric(horizontal: 2 * scale),
                        child: _dayCell(context, scale, cells[week * 7 + day]),
                      ),
                    ),
                ],
              ),
            ],
          ],
        ),
      ),
    );
  }

  /// One day of the month grid — an outlined white card with the number in a
  /// circle badge and up to two event lines underneath, as in the design's
  /// `Calendar day` frames.
  Widget _dayCell(BuildContext context, double scale, DateTime? day) {
    final theme = Theme.of(context);
    if (day == null) return const SizedBox(height: 124);
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final isToday = day == today;
    final isSelected = day == _selectedDay();
    final outside = !_sameMonth(day, _month);
    final dayEvents = eventsOn(_events, day);

    return Container(
      height: 124 * scale,
      padding: EdgeInsets.all(6 * scale),
      decoration: BoxDecoration(
        color: outside
            ? theme.colorScheme.surfaceContainerLow.withValues(alpha: 0.5)
            : theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(10 * scale),
        border: Border.all(color: theme.colorScheme.outlineVariant),
      ),
      child: InkWell(
        onTap: () => setState(() => _anchor = day),
        borderRadius: BorderRadius.circular(10 * scale),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Container(
                width: 26 * scale,
                height: 26 * scale,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: isSelected
                      ? theme.colorScheme.primary
                      : isToday
                          ? theme.colorScheme.primaryContainer
                          : Colors.transparent,
                  shape: BoxShape.circle,
                ),
                child: Text(
                  '${day.day}',
                  style: theme.textTheme.labelSmall?.copyWith(
                    color: isSelected
                        ? theme.colorScheme.onPrimary
                        : isToday
                            ? theme.colorScheme.primary
                            : outside
                                ? theme.colorScheme.onSurfaceVariant
                                    .withValues(alpha: 0.5)
                                : theme.colorScheme.onSurface,
                    fontWeight: FontWeight.w600,
                    fontSize: MemoirType.caption,
                  ),
                ),
              ),
            ),
            SizedBox(height: 4 * scale),
            for (final event in dayEvents.take(2))
              _eventLine(context, scale, event),
            if (dayEvents.length > 2)
              Text(
                '+${dayEvents.length - 2}',
                style: theme.textTheme.labelSmall?.copyWith(
                  color: theme.colorScheme.primary,
                  fontSize: MemoirType.caption,
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _eventLine(BuildContext context, double scale, PlannerEvent event) {
    final theme = Theme.of(context);
    String two(int n) => n.toString().padLeft(2, '0');
    final start = event.startAt;
    return Padding(
      padding: EdgeInsets.only(bottom: 2 * scale),
      child: Row(
        children: [
          Container(
            width: 6 * scale,
            height: 6 * scale,
            decoration: BoxDecoration(
              color: theme.colorScheme.primary,
              shape: BoxShape.circle,
            ),
          ),
          SizedBox(width: 4 * scale),
          Expanded(
            child: Text(
              '${two(start.hour)}:${two(start.minute)} ${event.title}',
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: theme.textTheme.labelSmall?.copyWith(
                color: theme.colorScheme.onSurface,
                fontSize: MemoirType.caption,
              ),
            ),
          ),
        ],
      ),
    );
  }

  /// The events of the day being looked at, then the ones coming up.
  Widget _eventsSections(BuildContext context, double scale) {
    final theme = Theme.of(context);
    if (_errorMessage != null) {
      return Card(
        child: Padding(
          padding: const EdgeInsets.all(MemoirSpace.s4),
          child: Text(
            'Không tải được sự kiện: $_errorMessage',
            style: TextStyle(color: theme.colorScheme.error),
          ),
        ),
      );
    }

    final selected = _selectedDay();
    final onDay = eventsOn(_events, selected)
      ..sort((a, b) => a.startAt.compareTo(b.startAt));
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _sectionTitle(context, 'Sự kiện ${selected.day}.${selected.month}'),
        const SizedBox(height: MemoirSpace.s2),
        if (onDay.isEmpty)
          Padding(
            padding: const EdgeInsets.symmetric(vertical: MemoirSpace.s3),
            child: Text(
              'Không có sự kiện trong ngày này.',
              style: theme.textTheme.bodySmall?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
                fontSize: MemoirType.body,
              ),
            ),
          )
        else
          for (final event in onDay) _eventTile(context, scale, event),
        SizedBox(height: MemoirSpace.s5 * scale),
        _sectionTitle(context, 'Sắp tới'),
        const SizedBox(height: MemoirSpace.s2),
        for (final event in upcomingAfter(_events, today).take(5))
          _eventTile(context, scale, event, withDate: true),
      ],
    );
  }

  Widget _eventTile(BuildContext context, double scale, PlannerEvent event,
      {bool withDate = false}) {
    final theme = Theme.of(context);
    String two(int n) => n.toString().padLeft(2, '0');
    final start = event.startAt;
    final startLabel = withDate
        ? 'Ngày ${two(start.day)}.${two(start.month)} · '
            '${two(start.hour)}:${two(start.minute)}'
        : '${two(start.hour)}:${two(start.minute)}';
    final end = event.endAt;
    final timePart = [
      startLabel,
      if (end != null) '– ${two(end.hour)}:${two(end.minute)}',
    ].join(' ');
    final reminder = event.reminderMinutes;
    final subtitle = [
      timePart,
      if (event.location != null) '· ${event.location}',
      if (reminder != null) '· Nhắc $reminder phút trước',
    ].join(' ');

    return Padding(
      padding: EdgeInsets.only(bottom: MemoirSpace.s2 * scale),
      child: Card(
        margin: EdgeInsets.zero,
        child: ListTile(
          title: Text(
            event.title,
            style: theme.textTheme.labelLarge?.copyWith(
              color: theme.colorScheme.onSurface,
              fontSize: MemoirType.label,
            ),
          ),
          subtitle: Text(
            subtitle,
            style: theme.textTheme.bodySmall?.copyWith(
              color: theme.colorScheme.onSurfaceVariant,
              fontSize: MemoirType.caption,
            ),
          ),
          trailing: IconButton(
            tooltip: 'Xoá',
            icon: const Icon(Icons.delete_outline, size: 20),
            onPressed: () => _deleteEvent(event),
          ),
        ),
      ),
    );
  }

  Widget _sectionTitle(BuildContext context, String title) {
    final theme = Theme.of(context);
    return Text(
      title,
      style: theme.textTheme.labelLarge?.copyWith(
        color: theme.colorScheme.primary,
        fontSize: MemoirType.label,
        fontWeight: FontWeight.w600,
      ),
    );
  }
}

/// The `Tạo sự kiện` editor (`42:27239`): title, day, start/end time,
/// location, a note and a reminder. Pops `true` once the event is saved.
class _EventEditorDialog extends StatefulWidget {
  const _EventEditorDialog({required this.defaultDate, required this.onSave});

  final DateTime defaultDate;

  /// Sends the form body (`title`, `start_at`, `end_at`, `location`,
  /// `description`, `reminder_minutes`) to the backend's `/events`.
  final Future<void> Function(Map<String, dynamic> body) onSave;

  @override
  State<_EventEditorDialog> createState() => _EventEditorDialogState();
}

/// The "Nhắc nhở" choices of the form, minutes before the start.
const List<(int, String)> _reminderOptions = [
  (0, 'Không nhắc'),
  (10, 'Trước 10 phút'),
  (30, 'Trước 30 phút'),
  (60, 'Trước 1 giờ'),
  (1440, 'Trước 1 ngày'),
];

class _EventEditorDialogState extends State<_EventEditorDialog> {
  final _title = TextEditingController();
  final _location = TextEditingController();
  final _description = TextEditingController();
  int _reminderMinutes = 0;
  late DateTime _date = DateTime(
    widget.defaultDate.year,
    widget.defaultDate.month,
    widget.defaultDate.day,
  );
  TimeOfDay _start = const TimeOfDay(hour: 9, minute: 0);
  TimeOfDay _end = const TimeOfDay(hour: 10, minute: 0);
  bool _saving = false;

  static String _two(int n) => n.toString().padLeft(2, '0');

  @override
  void dispose() {
    _title.dispose();
    _location.dispose();
    _description.dispose();
    super.dispose();
  }

  Future<void> _pickDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _date,
      firstDate: DateTime(DateTime.now().year - 1),
      lastDate: DateTime(DateTime.now().year + 3),
    );
    if (picked != null) setState(() => _date = picked);
  }

  Future<void> _pickTime({required bool start}) async {
    final initial = start ? _start : _end;
    final picked = await showTimePicker(context: context, initialTime: initial);
    if (picked == null) return;
    setState(() {
      if (start) {
        _start = picked;
      } else {
        _end = picked;
      }
    });
  }

  Future<void> _save() async {
    final title = _title.text.trim();
    if (title.isEmpty) {
      ScaffoldMessenger.of(context)
          .showSnackBar(const SnackBar(content: Text('Nhập tên sự kiện')));
      return;
    }
    final startAt = DateTime(
      _date.year, _date.month, _date.day, _start.hour, _start.minute,
    );
    final endAt = DateTime(
      _date.year, _date.month, _date.day, _end.hour, _end.minute,
    );
    if (endAt.isBefore(startAt)) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Giờ kết thúc phải sau giờ bắt đầu')),
      );
      return;
    }

    setState(() => _saving = true);
    try {
      await widget.onSave({
        'title': title,
        'start_at': startAt.toIso8601String(),
        'end_at': endAt.toIso8601String(),
        if (_location.text.trim().isNotEmpty) 'location': _location.text.trim(),
        if (_description.text.trim().isNotEmpty)
          'description': _description.text.trim(),
        if (_reminderMinutes != 0) 'reminder_minutes': _reminderMinutes,
      });
      if (!mounted) return;
      Navigator.of(context).pop(true);
    } catch (error) {
      if (!mounted) return;
      setState(() => _saving = false);
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('$error')));
    }
  }

  Widget _fieldLabel(String label) => Text(
        label,
        style: Theme.of(context).textTheme.labelMedium?.copyWith(
              color: Theme.of(context).colorScheme.onSurfaceVariant,
            ),
      );

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Dialog(
      child: SizedBox(
        width: 520,
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(MemoirSpace.s6),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Tạo sự kiện',
                style: theme.textTheme.headlineSmall?.copyWith(
                  color: theme.colorScheme.onSurface,
                ),
              ),
              const SizedBox(height: MemoirSpace.s5),
              TextField(
                controller: _title,
                autofocus: true,
                decoration: const InputDecoration(
                  labelText: 'Tên sự kiện',
                  hintText: 'Ví dụ: Họp gia đình',
                ),
              ),
              const SizedBox(height: MemoirSpace.s3),
              _fieldLabel('Ngày'),
              ListTile(
                contentPadding: EdgeInsets.zero,
                title: Text(
                  '${_two(_date.day)}/${_two(_date.month)}/${_date.year}',
                  style: theme.textTheme.bodyMedium,
                ),
                trailing: const Icon(Icons.calendar_today_outlined, size: 18),
                onTap: _pickDate,
              ),
              Row(
                children: [
                  Expanded(child: _fieldLabel('Giờ bắt đầu')),
                  const SizedBox(width: MemoirSpace.s4),
                  Expanded(child: _fieldLabel('Giờ kết thúc')),
                ],
              ),
              const SizedBox(height: MemoirSpace.s1),
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () => _pickTime(start: true),
                      child: Text(
                        '${_two(_start.hour)}:${_two(_start.minute)}',
                      ),
                    ),
                  ),
                  const SizedBox(width: MemoirSpace.s4),
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () => _pickTime(start: false),
                      child: Text('${_two(_end.hour)}:${_two(_end.minute)}'),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: MemoirSpace.s3),
              TextField(
                controller: _location,
                decoration: const InputDecoration(
                  labelText: 'Địa điểm',
                  hintText: 'Tuỳ chọn',
                ),
              ),
              const SizedBox(height: MemoirSpace.s3),
              TextField(
                controller: _description,
                maxLines: 2,
                decoration: const InputDecoration(
                  labelText: 'Ghi chú',
                  hintText: 'Tuỳ chọn',
                ),
              ),
              const SizedBox(height: MemoirSpace.s3),
              Row(
                children: [
                  Icon(
                    Icons.notifications_none,
                    size: 18,
                    color: theme.colorScheme.onSurfaceVariant,
                  ),
                  const SizedBox(width: MemoirSpace.s2),
                  Expanded(child: _fieldLabel('Nhắc nhở')),
                ],
              ),
              const SizedBox(height: MemoirSpace.s1),
              DropdownButtonFormField<int>(
                initialValue: _reminderMinutes,
                isExpanded: true,
                items: [
                  for (final (minutes, label) in _reminderOptions)
                    DropdownMenuItem(value: minutes, child: Text(label)),
                ],
                onChanged: (value) =>
                    setState(() => _reminderMinutes = value ?? 0),
                decoration: const InputDecoration(
                  isDense: true,
                  contentPadding: EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 10,
                  ),
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: MemoirSpace.s5),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  TextButton(
                    onPressed: _saving
                        ? null
                        : () => Navigator.of(context).pop(false),
                    child: const Text('Hủy'),
                  ),
                  const SizedBox(width: MemoirSpace.s2),
                  FilledButton.icon(
                    onPressed: _saving ? null : _save,
                    icon: _saving
                        ? const SizedBox(
                            width: 16,
                            height: 16,
                            child: CircularProgressIndicator(strokeWidth: 2),
                          )
                        : const Icon(Icons.check, size: 18),
                    label: const Text('Lưu sự kiện'),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}