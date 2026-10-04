import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../data/models.dart';
import '../../data/providers.dart';
import '../widgets/month_grid.dart';
import 'entry_editor.dart';

/// Two month grids for the same month: mood on top, weather underneath.
class MonthGridsScreen extends ConsumerWidget {
  const MonthGridsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final month = ref.watch(selectedMonthProvider);
    final key = monthKey(month);
    final moods = ref.watch(moodsProvider);
    final weathers = ref.watch(weathersProvider);
    final moodCells = ref.watch(moodGridProvider(key));
    final weatherCells = ref.watch(weatherGridProvider(key));
    final summary = ref.watch(monthSummaryProvider(key));

    void openDay(DateTime date) {
      Navigator.of(context).push(MaterialPageRoute(
        builder: (_) => EntryEditorScreen(date: date),
      ));
    }

    return Scaffold(
      appBar: AppBar(title: const Text('Lưới tháng')),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(16, 8, 16, 40),
        children: [
          // Month switcher
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              IconButton(
                icon: const Icon(Icons.chevron_left),
                onPressed: () => ref.read(selectedMonthProvider.notifier).state =
                    DateTime(month.year, month.month - 1),
              ),
              Text(
                'Tháng ${month.month}/${month.year}',
                style: theme.textTheme.titleMedium,
              ),
              IconButton(
                icon: const Icon(Icons.chevron_right),
                onPressed: () => ref.read(selectedMonthProvider.notifier).state =
                    DateTime(month.year, month.month + 1),
              ),
            ],
          ),
          const SizedBox(height: 6),

          // ---- CẢM XÚC ----
          _GridSection(
            title: 'CẢM XÚC',
            month: month,
            cells: moodCells.valueOrNull ?? const [],
            child: moodCells.when(
              loading: () => const LinearProgressIndicator(),
              error: (e, _) => Text('$e'),
              data: (cells) => MonthGrid(
                cells: cells,
                selectedDate: month,
                onDayTap: openDay,
              ),
            ),
          ),
          const SizedBox(height: 18),

          // ---- THỜI TIẾT ----
          _GridSection(
            title: 'THỜI TIẾT',
            month: month,
            cells: weatherCells.valueOrNull ?? const [],
            child: weatherCells.when(
              loading: () => const LinearProgressIndicator(),
              error: (e, _) => Text('$e'),
              data: (cells) => MonthGrid(
                cells: cells,
                selectedDate: month,
                onDayTap: openDay,
              ),
            ),
          ),

          // ---- Legend ----
          const SizedBox(height: 22),
          Text('Chú giải',
              style: theme.textTheme.titleSmall),
          const SizedBox(height: 8),
          moods.when(
            loading: () => const SizedBox.shrink(),
            error: (e, _) => Text('$e'),
            data: (items) => GridLegend(items: items),
          ),
          const SizedBox(height: 8),
          weathers.when(
            loading: () => const SizedBox.shrink(),
            error: (e, _) => Text('$e'),
            data: (items) => GridLegend(items: items),
          ),

          // ---- Month summary ----
          const SizedBox(height: 22),
          summary.when(
            loading: () => const SizedBox.shrink(),
            error: (e, _) => Text('$e'),
            data: (s) => Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Tóm tắt tháng', style: theme.textTheme.titleSmall),
                    const SizedBox(height: 8),
                    Text('📅 Số ngày đã ghi: ${s.daysLogged}'),
                    Text('👟 Tổng bước chân: ${s.totalSteps}'),
                    Text('🏃 Tổng phút tập luyện: ${s.totalWorkoutMinutes}'),
                    if (s.moodCounts.isNotEmpty) ...[
                      const SizedBox(height: 8),
                      Text('Cảm xúc:', style: theme.textTheme.labelMedium),
                      Text(s.moodCounts.entries
                          .map((e) => '${e.key}: ${e.value}')
                          .join(' · ')),
                    ],
                    if (s.weatherCounts.isNotEmpty) ...[
                      const SizedBox(height: 6),
                      Text('Thời tiết:', style: theme.textTheme.labelMedium),
                      Text(s.weatherCounts.entries
                          .map((e) => '${e.key}: ${e.value}')
                          .join(' · ')),
                    ],
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _GridSection extends StatelessWidget {
  const _GridSection({
    required this.title,
    required this.child,
    this.cells = const [],
    required this.month,
  });

  final String title;
  final Widget child;

  /// Used to show "n / total ngày" next to the title.
  final List<GridCell> cells;

  /// The month being displayed, so the total matches the browsed month rather
  /// than always the current one.
  final DateTime month;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final logged = cells.where((c) => c.hasData).length;
    final daysInMonth = DateTime(month.year, month.month + 1, 0).day;

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: Text(
                    title,
                    style: theme.textTheme.labelLarge?.copyWith(
                      letterSpacing: 1.1,
                      color: theme.colorScheme.onSurfaceVariant,
                    ),
                  ),
                ),
                if (logged > 0)
                  Text(
                    '$logged / $daysInMonth ngày',
                    style: theme.textTheme.labelSmall?.copyWith(
                      color: theme.colorScheme.onSurfaceVariant,
                    ),
                  ),
              ],
            ),
            const SizedBox(height: 10),
            child,
          ],
        ),
      ),
    );
  }
}