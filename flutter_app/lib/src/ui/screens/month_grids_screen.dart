import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/auth_provider.dart';
import '../../data/models.dart';
import '../../data/providers.dart';
import '../home/home_scale.dart';
import '../month/day_details.dart';
import '../month/month_card.dart';
import '../month/month_heatmaps.dart';
import '../tokens.dart';
import '../widgets/app_header.dart';
import '../widgets/period_control.dart';
import 'calendar_screen.dart';
import 'entry_editor.dart';

/// Content width of the `Lưới tháng · Web` frame: 1280 minus its 36 px gutters.
const double kMonthContentWidth = 1208;

/// Width the three cards need: 3 × 387 plus the two 24 px gaps.
const double kMonthCardsWidth = MonthRecordCard.width * 3 + 2 * 24;

/// `JOURNAL-01 · Lưới tháng`: one month of moods, weather and writing, laid out
/// like the design's `Lưới tháng · Web` frame.
///
/// The three cards share one grid geometry, so a given day sits at the same
/// place in all of them. The day the grids point at is what the block underneath
/// describes, and its button is the way into the editor.
class MonthGridsScreen extends ConsumerStatefulWidget {
  const MonthGridsScreen({super.key});

  @override
  ConsumerState<MonthGridsScreen> createState() => _MonthGridsScreenState();
}

class _MonthGridsScreenState extends ConsumerState<MonthGridsScreen> {
  /// The day the grids point at; null until the user picks one.
  DateTime? _selected;

  static bool _sameMonth(DateTime a, DateTime b) =>
      a.year == b.year && a.month == b.month;

  void _openEditor(DateTime date) {
    Navigator.of(context).push(
      MaterialPageRoute<void>(builder: (_) => EntryEditorScreen(date: date)),
    );
  }

  @override
  Widget build(BuildContext context) {
    final month = ref.watch(selectedMonthProvider);
    final key = monthKey(month);
    final displayName =
        ref.watch(authProvider).user?['display_name'] as String?;
    final moods = ref.watch(moodsProvider);
    final weathers = ref.watch(weathersProvider);
    final moodCells = ref.watch(moodGridProvider(key));
    final weatherCells = ref.watch(weatherGridProvider(key));
    final entries = ref.watch(monthEntriesProvider(key));

    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    // Follow the browsed month: today while it holds today, otherwise its first
    // day, and whatever the user picked in between.
    final selected = _selected != null && _sameMonth(_selected!, month)
        ? _selected!
        : _sameMonth(today, month)
            ? today
            : DateTime(month.year, month.month, 1);
    final byDate = entries.valueOrNull ?? const <String, DiaryEntry>{};
    final day = byDate[dayKey(selected)];

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
          final sideBySide =
              constraints.maxWidth >= (kMonthCardsWidth + 2 * 16) * scale;
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
                      destination: AppDestination.monthGrid,
                      onNavigate: (destination) {
                        if (destination == AppDestination.home) {
                          Navigator.of(context)
                              .popUntil((route) => route.isFirst);
                        } else if (destination == AppDestination.eventHistory) {
                          Navigator.of(context).push(
                            MaterialPageRoute<void>(
                              builder: (_) => const CalendarScreen(),
                            ),
                          );
                        }
                      },
                      gutter: gutter,
                      onLogout: () => ref.read(authProvider.notifier).logout(),
                    ),
                    Expanded(
                      child: ListView(
                        padding: EdgeInsets.fromLTRB(
                          gutter,
                          MemoirSpace.s6 * scale,
                          gutter,
                          MemoirSpace.s8 * scale,
                        ),
                        children: [
                          _Introduction(
                            month: month,
                            selected: selected,
                            onBack: () => Navigator.of(context)
                                .popUntil((route) => route.isFirst),
                            onMonth: (value) => ref
                                .read(selectedMonthProvider.notifier)
                                .state = value,
                          ),
                          SizedBox(height: MemoirSpace.s6 * scale),
                          _cards(
                            month: month,
                            byDate: byDate,
                            moods: moods,
                            weathers: weathers,
                            moodCells: moodCells,
                            weatherCells: weatherCells,
                            sideBySide: sideBySide,
                            onDayTap: (date) =>
                                setState(() => _selected = date),
                          ),
                          SizedBox(height: MemoirSpace.s6 * scale),
                          SelectedDayDetails(
                            date: selected,
                            isToday: selected == today,
                            mood: _lookupOf(moods.valueOrNull, day?.moodId),
                            weather:
                                _lookupOf(weathers.valueOrNull, day?.weatherId),
                            entry: day,
                            onWrite: () => _openEditor(selected),
                          ),
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

  /// The three synchronized cards: the journal shaded by how complete each day
  /// is, plus one filled tile per mood and per weather.
  Widget _cards({
    required DateTime month,
    required MonthEntries byDate,
    required AsyncValue<List<LookupItem>> moods,
    required AsyncValue<List<LookupItem>> weathers,
    required AsyncValue<List<GridCell>> moodCells,
    required AsyncValue<List<GridCell>> weatherCells,
    required bool sideBySide,
    required ValueChanged<DateTime> onDayTap,
  }) {
    int logged(AsyncValue<List<GridCell>> cells) =>
        cells.valueOrNull?.where((cell) => cell.hasData).length ?? 0;

    final cards = [
      MonthRecordCard(
        title: 'Nhật ký',
        countLabel: '${byDate.length} ngày đã viết',
        explanation: 'Mỗi ô nhỏ là một lần dành thời gian cho mình.',
        grid: JournalMonthHeatmap(
          month: month,
          byDate: byDate,
          onDayTap: onDayTap,
        ),
        legend: const ActivityLegend(),
        caption: 'Ô viền: hôm nay · Ô trống: chưa ghi · Ô nhạt: ngày tới',
      ),
      MonthRecordCard(
        title: 'Cảm xúc',
        countLabel: '${logged(moodCells)} ngày đã ghi',
        explanation: 'Mỗi màu là một trạng thái · không hiển thị ngày',
        grid: _data(
          moodCells,
          (cells) => CategoryMonthHeatmap(
            month: month,
            cells: cells,
            onDayTap: onDayTap,
          ),
        ),
        legend: _data(
          moods,
          (items) => CategoryLegend(items: items),
          compact: true,
        ),
        caption: 'Ô viền: hôm nay · —: chưa ghi · Ô nhạt: ngày tới',
      ),
      MonthRecordCard(
        title: 'Thời tiết',
        countLabel: '${logged(weatherCells)} ngày đã ghi',
        explanation: 'Mỗi màu là một kiểu trời · không hiển thị ngày',
        grid: _data(
          weatherCells,
          (cells) => CategoryMonthHeatmap(
            month: month,
            cells: cells,
            onDayTap: onDayTap,
          ),
        ),
        legend: _data(
          weathers,
          (items) => CategoryLegend(items: items),
          compact: true,
        ),
        caption: 'Ô viền: hôm nay · —: chưa ghi · Ô nhạt: ngày tới',
      ),
    ];

    final scale = HomeScale.of(context);
    if (!sideBySide) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          for (final card in cards) ...[
            if (card != cards.first) SizedBox(height: MemoirSpace.s5 * scale),
            card,
          ],
        ],
      );
    }
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        for (final card in cards) ...[
          if (card != cards.first) SizedBox(width: MemoirSpace.s6 * scale),
          card,
        ],
      ],
    );
  }

  /// Keeps a card readable while its half of the month loads or fails.
  Widget _data<T>(
    AsyncValue<T> value,
    Widget Function(T data) build, {
    bool compact = false,
  }) =>
      value.when(
        loading: () => compact
            ? const SizedBox.shrink()
            : const Padding(
                padding: EdgeInsets.symmetric(vertical: 12),
                child: LinearProgressIndicator(),
              ),
        error: (error, _) => Text(
          'Chưa tải được dữ liệu tháng. $error',
          style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: Theme.of(context).colorScheme.error,
                fontSize: MemoirType.caption,
              ),
        ),
        data: build,
      );

  /// The lookup row behind an id, or null when the day stored no value for it.
  static LookupItem? _lookupOf(List<LookupItem>? items, int? id) {
    if (items == null || id == null) return null;
    for (final item in items) {
      if (item.id == id) return item;
    }
    return null;
  }
}

/// The `Month introduction` block: the way back to the home, the overline, the
/// browsed month's title and description, the `Tuần | Tháng | Năm` control and
/// the month navigation.
class _Introduction extends StatelessWidget {
  const _Introduction({
    required this.month,
    required this.selected,
    required this.onBack,
    required this.onMonth,
  });

  final DateTime month;

  /// The day the grids point at, named on the right of the navigation row.
  final DateTime selected;

  final VoidCallback onBack;
  final ValueChanged<DateTime> onMonth;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final muted = theme.colorScheme.onSurfaceVariant;
    final brand = theme.colorScheme.primary;
    final scale = HomeScale.of(context);
    final now = DateTime.now();
    final caption = theme.textTheme.bodySmall?.copyWith(
      color: muted,
      fontSize: MemoirType.caption,
    );

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        InkWell(
          borderRadius: BorderRadius.circular(MemoirRadius.control * scale),
          onTap: onBack,
          child: Padding(
            padding: EdgeInsets.symmetric(
              vertical: MemoirSpace.s1 * scale,
              horizontal: 2 * scale,
            ),
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
        SizedBox(height: MemoirSpace.s5 * scale),
        Text(
          'NHÌN LẠI TỪNG NGÀY',
          style: theme.textTheme.labelSmall?.copyWith(
            color: brand,
            fontSize: MemoirType.overlineEditorial,
            letterSpacing: MemoirType.overlineEditorialLetterSpacing,
          ),
        ),
        SizedBox(height: MemoirSpace.s2 * scale),
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Lưới tháng · Tháng ${month.month}',
                    // The design's title box is 996×46, the page heading step.
                    style: theme.textTheme.headlineSmall?.copyWith(
                      color: theme.colorScheme.onSurface,
                      fontSize: MemoirType.headingPage,
                      height: MemoirType.headingPageLineHeight /
                          MemoirType.headingPage,
                    ),
                  ),
                  SizedBox(height: MemoirSpace.s1 * scale),
                  Text(
                    'Nhịp viết, cảm xúc và bầu trời — đặt cạnh nhau '
                    'để hiểu mình hơn.',
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: muted,
                      fontSize: MemoirType.body,
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(width: MemoirSpace.s6 * scale),
            const PeriodControl(),
          ],
        ),
        SizedBox(height: MemoirSpace.s5 * scale),
        Row(
          children: [
            TextButton(
              onPressed: () => onMonth(DateTime(now.year, now.month)),
              child: const Text('Hôm nay'),
            ),
            SizedBox(width: MemoirSpace.s2 * scale),
            IconButton(
              onPressed: () => onMonth(DateTime(month.year, month.month - 1)),
              icon: Icon(Icons.chevron_left, size: 18 * scale, color: brand),
            ),
            IconButton(
              onPressed: () => onMonth(DateTime(month.year, month.month + 1)),
              icon: Icon(Icons.chevron_right, size: 18 * scale, color: brand),
            ),
            const Spacer(),
            Text(
              'Đang xem ngày ${selected.day}.${selected.month}',
              style: caption?.copyWith(color: brand),
            ),
          ],
        ),
      ],
    );
  }
}
