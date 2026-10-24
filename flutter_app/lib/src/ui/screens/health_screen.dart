import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/auth_provider.dart';
import '../../data/models.dart';
import '../../data/providers.dart';
import '../health/health_body_sheet.dart';
import '../health/health_chrome.dart';
import '../health/health_quote_card.dart';
import '../health/health_quick_form.dart';
import '../health/health_summary_cards.dart';
import '../health/health_timeline.dart';
import '../health/health_trends.dart';
import '../health/quick_log_sheet.dart';
import '../home/home_scale.dart';
import '../tokens.dart';
import '../widgets/app_header.dart';
import 'calendar_screen.dart';
import 'entry_editor.dart';
import 'month_grids_screen.dart';

/// The full daily health dashboard.
class HealthScreen extends ConsumerStatefulWidget {
  const HealthScreen({super.key});

  @override
  ConsumerState<HealthScreen> createState() => _HealthScreenState();
}

class _HealthScreenState extends ConsumerState<HealthScreen> {
  DateTime _date = _midnight(DateTime.now());
  HealthMetric _metric = HealthMetric.steps;
  HealthTrendRange _range = HealthTrendRange.month;

  static DateTime _midnight(DateTime value) =>
      DateTime(value.year, value.month, value.day);

  void _setDate(DateTime value) {
    final today = _midnight(DateTime.now());
    final day = _midnight(value);
    if (day.isAfter(today)) return;
    setState(() => _date = day);
  }

  void _showQuickLog([QuickLogTab tab = QuickLogTab.workout]) {
    showQuickLogSheet(
      context,
      ref,
      date: _date,
      initialTab: tab,
    );
  }

  void _openJournal() {
    Navigator.of(context).push(
      MaterialPageRoute<void>(
        builder: (_) => EntryEditorScreen(date: _date),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final auth = ref.watch(authProvider);
    ref.watch(authReadyProvider);
    if (auth.isLoading) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }
    final displayName = auth.user?['display_name'] as String?;
    final day = ref.watch(healthDayProvider(_date));
    final profile = ref.watch(healthProfileProvider);

    return Scaffold(
      body: LayoutBuilder(
        builder: (context, constraints) {
          final scale = homeScaleFor(constraints.maxWidth);
          final horizontal = (constraints.maxWidth - 1200 * scale) / 2;
          final gutter = horizontal.clamp(16.0, double.infinity);
          return HomeScale(
            factor: scale,
            textFactor: homeTextScaleFor(constraints.maxWidth),
            child: Column(
              children: [
                AppHeader(
                  date: _date,
                  initials: initialsOf(displayName),
                  name: displayName,
                  destination: AppDestination.health,
                  gutter: gutter,
                  onLogout: () => ref.read(authProvider.notifier).logout(),
                  onNavigate: (destination) {
                    if (destination == AppDestination.home) {
                      Navigator.of(context).pop();
                    } else if (destination == AppDestination.monthGrid) {
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
                      Navigator.of(context).pop();
                    }
                  },
                ),
                Expanded(
                  child: day.when(
                    loading: () =>
                        const Center(child: CircularProgressIndicator()),
                    error: (error, _) => Center(child: Text('$error')),
                    data: (overview) => profile.when(
                      loading: () =>
                          const Center(child: CircularProgressIndicator()),
                      error: (error, _) => Center(child: Text('$error')),
                      data: (savedProfile) => _Dashboard(
                        date: _date,
                        overview: overview,
                        profile: savedProfile ?? const HealthProfile(),
                        metric: _metric,
                        range: _range,
                        displayName: displayName,
                        gutter: gutter,
                        onPrevious: () =>
                            _setDate(_date.subtract(const Duration(days: 1))),
                        onNext: () =>
                            _setDate(_date.add(const Duration(days: 1))),
                        onDatePicked: _setDate,
                        onQuickLog: _showQuickLog,
                        onOpenJournal: _openJournal,
                        onOpenBodySheet: () => showHealthBodySheet(
                          context,
                          date: _date,
                          ref: ref,
                        ),
                        onAddWater: () => _showQuickLog(QuickLogTab.water),
                        onOpenSleepSheet: () =>
                            _showQuickLog(QuickLogTab.sleep),
                        onMetricChanged: (value) =>
                            setState(() => _metric = value),
                        onRangeChanged: (value) =>
                            setState(() => _range = value),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}

class _Dashboard extends StatelessWidget {
  const _Dashboard({
    required this.date,
    required this.overview,
    required this.profile,
    required this.metric,
    required this.range,
    required this.displayName,
    required this.gutter,
    required this.onPrevious,
    required this.onNext,
    required this.onDatePicked,
    required this.onQuickLog,
    required this.onOpenJournal,
    required this.onOpenBodySheet,
    required this.onAddWater,
    required this.onOpenSleepSheet,
    required this.onMetricChanged,
    required this.onRangeChanged,
  });

  final DateTime date;
  final HealthDayOverview overview;
  final HealthProfile profile;
  final HealthMetric metric;
  final HealthTrendRange range;
  final String? displayName;
  final double gutter;
  final VoidCallback onPrevious;
  final VoidCallback onNext;
  final ValueChanged<DateTime> onDatePicked;
  final VoidCallback onQuickLog;
  final VoidCallback onOpenJournal;
  final VoidCallback onOpenBodySheet;
  final VoidCallback onAddWater;
  final VoidCallback onOpenSleepSheet;
  final ValueChanged<HealthMetric> onMetricChanged;
  final ValueChanged<HealthTrendRange> onRangeChanged;

  @override
  Widget build(BuildContext context) {
    final scale = HomeScale.textOf(context);
    return SingleChildScrollView(
      padding: EdgeInsets.fromLTRB(
        gutter,
        MemoirSpace.s5 * scale,
        gutter,
        MemoirSpace.s8 * scale,
      ),
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 1200),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              const HealthBreadcrumb(),
              SizedBox(height: MemoirSpace.s3 * scale),
              HealthPageHeader(
                date: date,
                onPrevious: onPrevious,
                onNext: onNext,
                onDatePicked: onDatePicked,
                onQuickLog: onQuickLog,
              ),
              SizedBox(height: MemoirSpace.s3 * scale),
              HealthContextBanner(firstName: displayName, date: date),
              SizedBox(height: MemoirSpace.s5 * scale),
              HealthSummaryCards(day: overview, profile: profile),
              SizedBox(height: MemoirSpace.s5 * scale),
              LayoutBuilder(
                builder: (context, constraints) {
                  final left = Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      HealthQuickForm(
                        date: date,
                        day: overview,
                        profile: profile,
                        onSaved: () {},
                        onOpenBodySheet: onOpenBodySheet,
                        onAddWater: onAddWater,
                        onOpenSleepSheet: onOpenSleepSheet,
                      ),
                      const SizedBox(height: MemoirSpace.s4),
                      HealthTrends(
                        date: date,
                        metric: metric,
                        onMetricChanged: onMetricChanged,
                        range: range,
                        onRangeChanged: onRangeChanged,
                      ),
                    ],
                  );
                  final right = Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      HealthJournalBridgeCard(onOpenJournal: onOpenJournal),
                      const SizedBox(height: MemoirSpace.s4),
                      HealthTimeline(
                        date: date,
                        day: overview,
                        onChanged: () {},
                      ),
                      const SizedBox(height: MemoirSpace.s4),
                      const HealthGentleReminderCard(),
                    ],
                  );
                  if (constraints.maxWidth < 1000) {
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        left,
                        const SizedBox(height: MemoirSpace.s5),
                        right,
                      ],
                    );
                  }
                  return Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(flex: 65, child: left),
                      const SizedBox(width: MemoirSpace.s5),
                      Expanded(flex: 35, child: right),
                    ],
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
