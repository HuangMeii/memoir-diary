import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../data/models.dart';
import '../../data/providers.dart';
import '../theme.dart';
import '../tokens.dart';
import 'health_metrics.dart';
import 'health_modal.dart';
import 'quick_sleep_tab.dart';
import 'quick_workout_tab.dart';

enum QuickLogTab {
  sleep('Giờ ngủ', Icons.bedtime),
  workout('Thời gian tập', Icons.fitness_center),
  water('Uống nước', Icons.water_drop);

  const QuickLogTab(this.label, this.icon);

  final String label;
  final IconData icon;
}

/// Opens the quick-log form: a bottom sheet on phones and a centred dialog on
/// wide windows (see [showHealthModal]).
Future<void> showQuickLogSheet(
  BuildContext context,
  WidgetRef ref, {
  required DateTime date,
  QuickLogTab initialTab = QuickLogTab.workout,
}) async {
  await showHealthModal<void>(
    context,
    builder: (_) => _QuickLogSheet(date: date, initialTab: initialTab),
  );
}

class _QuickLogSheet extends ConsumerStatefulWidget {
  const _QuickLogSheet({required this.date, required this.initialTab});

  final DateTime date;
  final QuickLogTab initialTab;

  @override
  ConsumerState<_QuickLogSheet> createState() => _QuickLogSheetState();
}

class _QuickLogSheetState extends ConsumerState<_QuickLogSheet> {
  late QuickLogTab _tab = widget.initialTab;
  bool _saving = false;
  bool _dirty = false;
  final _sleepKey = GlobalKey<QuickSleepTabState>();
  final _workoutKey = GlobalKey<QuickWorkoutTabState>();

  @override
  Widget build(BuildContext context) {
    final overview = ref.watch(healthDayProvider(widget.date));
    return overview.when(
      loading: () => const SizedBox(
        height: 360,
        child: Center(child: CircularProgressIndicator()),
      ),
      error: (error, _) => SizedBox(
        height: 360,
        child: Center(child: Text('$error')),
      ),
      data: (day) => _content(day),
    );
  }

  Widget _content(HealthDayOverview day) {
    // Phones keep the draggable sheet they expect. A wide window already
    // centres the form inside a `Dialog` with a bounded height, so the list can
    // fill that box directly.
    if (MediaQuery.sizeOf(context).width < kHealthModalBreakpoint) {
      return DraggableScrollableSheet(
        expand: false,
        initialChildSize: 0.72,
        minChildSize: 0.45,
        maxChildSize: 0.92,
        builder: (context, controller) => Material(
          color: Theme.of(context).colorScheme.surface,
          child: _form(day, controller),
        ),
      );
    }
    return _form(day, null);
  }

  /// Header, tab strip and footer stay put; only the tab body scrolls, exactly
  /// like the design's modal.
  Widget _form(HealthDayOverview day, ScrollController? controller) {
    return Column(
      children: [
        _header(),
        _tabStrip(),
        Expanded(
          child: ListView(
            controller: controller,
            padding: const EdgeInsets.fromLTRB(
              MemoirSpace.s6,
              MemoirSpace.s5,
              MemoirSpace.s6,
              MemoirSpace.s5,
            ),
            children: [
              IndexedStack(
                index: _tab.index,
                children: [
                  QuickSleepTab(
                    key: _sleepKey,
                    date: widget.date,
                    day: day,
                    profile: day.profile,
                    onDirtyChanged: (dirty) => setState(() => _dirty = dirty),
                  ),
                  QuickWorkoutTab(
                    key: _workoutKey,
                    date: widget.date,
                    day: day,
                    onDirtyChanged: (dirty) => setState(() => _dirty = dirty),
                  ),
                  _TabPlaceholder(tab: QuickLogTab.water, day: day),
                ],
              ),
            ],
          ),
        ),
        _footer(),
      ],
    );
  }

  /// Rounded icon badge + title + subtitle + circular close button, on the
  /// design's tinted band with a hairline under it.
  Widget _header() {
    final theme = Theme.of(context);
    return Container(
      padding: const EdgeInsets.fromLTRB(
        MemoirSpace.s6,
        MemoirSpace.s4,
        MemoirSpace.s5,
        MemoirSpace.s4,
      ),
      decoration: BoxDecoration(
        color: _bandColor(),
        border: Border(bottom: BorderSide(color: _hairline(theme))),
      ),
      child: Row(
        children: [
          Container(
            width: 36,
            height: 36,
            decoration: BoxDecoration(
              color: theme.colorScheme.surfaceContainerLow,
              shape: BoxShape.circle,
            ),
            child: Icon(
              Icons.self_improvement,
              size: 20,
              color: theme.colorScheme.primary,
            ),
          ),
          const SizedBox(width: MemoirSpace.s3),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Ghi nhận sức khoẻ',
                  style: theme.textTheme.headlineSmall,
                ),
                const SizedBox(height: 2),
                Text(_subtitle, style: theme.textTheme.bodySmall),
              ],
            ),
          ),
          const SizedBox(width: MemoirSpace.s2),
          Tooltip(
            message: 'Đóng',
            child: InkWell(
              onTap: _saving ? null : _close,
              customBorder: const CircleBorder(),
              child: Container(
                width: 32,
                height: 32,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(color: theme.colorScheme.outlineVariant),
                ),
                child: Icon(
                  Icons.close,
                  size: 18,
                  color: theme.colorScheme.onSurfaceVariant,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  /// `… cho ngày hôm nay` for today, `… cho ngày dd/MM/yyyy` otherwise: the
  /// design has no separate date line but the sheet can open any day.
  String get _subtitle {
    final now = DateTime.now();
    final today = widget.date.year == now.year &&
        widget.date.month == now.month &&
        widget.date.day == now.day;
    if (today) return 'Cập nhật nhật ký thể trạng cá nhân cho ngày hôm nay';
    return 'Cập nhật nhật ký thể trạng cá nhân cho ngày '
        '${_two(widget.date.day)}/${_two(widget.date.month)}/'
        '${widget.date.year}';
  }

  /// Underline tabs with icons, as drawn in the design. The app's pill
  /// `SegmentedTabs` stays for the weather and calendar switchers.
  Widget _tabStrip() {
    final theme = Theme.of(context);
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: MemoirSpace.s6),
      decoration: BoxDecoration(
        color: _bandColor(),
        border: Border(bottom: BorderSide(color: _hairline(theme))),
      ),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          children: [
            for (final tab in QuickLogTab.values) _tabButton(theme, tab),
          ],
        ),
      ),
    );
  }

  Widget _tabButton(ThemeData theme, QuickLogTab tab) {
    final selected = _tab == tab;
    final color = selected
        ? theme.colorScheme.primary
        : theme.colorScheme.onSurfaceVariant;
    return Semantics(
      selected: selected,
      button: !selected,
      child: InkWell(
        onTap: selected ? null : () => setState(() => _tab = tab),
        child: Container(
          padding: const EdgeInsets.symmetric(
            horizontal: MemoirSpace.custom14,
            vertical: MemoirSpace.s2,
          ),
          decoration: BoxDecoration(
            border: Border(
              bottom: BorderSide(
                color: selected ? theme.colorScheme.primary : Colors.transparent,
                width: 2,
              ),
            ),
          ),
          child: Row(
            children: [
              Icon(
                tab.icon,
                size: 18,
                color: selected ? color : theme.colorScheme.outline,
              ),
              const SizedBox(width: MemoirSpace.custom6),
              Text(
                tab.label,
                style: theme.textTheme.labelLarge?.copyWith(
                  color: color,
                  fontWeight: selected ? FontWeight.w600 : FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// `history` + "Lần ghi nhận gần nhất" on the left, cancel/save on the right.
  Widget _footer() {
    final theme = Theme.of(context);
    final logs = ref.watch(healthLogsProvider(_logRange)).valueOrNull;
    final last = logs == null ? null : lastSleepLogBefore(logs, widget.date);
    final record = last == null
        ? null
        : Row(
            children: [
              Icon(Icons.history, size: 16, color: theme.colorScheme.outline),
              const SizedBox(width: MemoirSpace.custom6),
              Flexible(
                child: Text(
                  'Lần ghi nhận gần nhất: '
                  '${shortDayLabel(last.logDate, widget.date)}',
                  style: theme.textTheme.labelSmall,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          );
    final cancel = OutlinedButton(
      onPressed: _saving ? null : _close,
      child: const Text('Huỷ / Để sau'),
    );
    final save = FilledButton.icon(
      onPressed: _saving ? null : _save,
      icon: const Icon(Icons.save_outlined),
      label: Text(_saving ? 'Đang lưu...' : 'Lưu vào nhật ký'),
    );

    return Container(
      padding: const EdgeInsets.fromLTRB(
        MemoirSpace.s6,
        MemoirSpace.s4,
        MemoirSpace.s6,
        MemoirSpace.s4,
      ),
      decoration: BoxDecoration(
        color: _bandColor(),
        border: Border(top: BorderSide(color: _hairline(theme))),
      ),
      child: LayoutBuilder(
        builder: (context, constraints) {
          // The two buttons alone need ~330 px; under that they stack and the
          // record line takes the row above them.
          if (constraints.maxWidth < 420) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                if (record != null) ...[
                  record,
                  const SizedBox(height: MemoirSpace.s2),
                ],
                save,
                const SizedBox(height: MemoirSpace.s1),
                cancel,
              ],
            );
          }
          return Row(
            children: [
              Expanded(child: record ?? const SizedBox.shrink()),
              const SizedBox(width: MemoirSpace.s2),
              cancel,
              const SizedBox(width: MemoirSpace.s2),
              save,
            ],
          );
        },
      ),
    );
  }

  ({String from, String to}) get _logRange => (
        from: dayKey(widget.date.subtract(const Duration(days: 29))),
        to: dayKey(widget.date),
      );

  /// The design's `bg-surface-bright/40` band behind header, tabs and footer.
  Color _bandColor() =>
      MemoirPalette.of(context).surfaceBrandSubtle.withValues(alpha: 0.35);

  Color _hairline(ThemeData theme) =>
      theme.colorScheme.outlineVariant.withValues(alpha: 0.4);

  Future<void> _save() async {
    setState(() => _saving = true);
    try {
      if (_tab == QuickLogTab.workout) {
        await _workoutKey.currentState!.save();
      } else if (_tab == QuickLogTab.sleep) {
        await _sleepKey.currentState!.save();
      } else {
        throw StateError('Tab ${_tab.label} chưa được triển khai');
      }
      refreshHealth(ref, day: widget.date);
      if (mounted) {
        Navigator.pop(context);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              'Đã ghi nhận vào nhật ký ngày '
              '${widget.date.day.toString().padLeft(2, '0')}/'
              '${widget.date.month.toString().padLeft(2, '0')}',
            ),
          ),
        );
      }
    } catch (error) {
      if (mounted) {
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text('$error')));
      }
    } finally {
      if (mounted) setState(() => _saving = false);
    }
  }

  Future<void> _close() async {
    if (!_dirty) {
      if (mounted) Navigator.pop(context);
      return;
    }
    final leave = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Bỏ thay đổi?'),
        content: const Text('Dữ liệu chưa lưu sẽ bị mất.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Ở lại'),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Bỏ thay đổi'),
          ),
        ],
      ),
    );
    if (leave == true && mounted) Navigator.pop(context);
  }
}

class _TabPlaceholder extends StatelessWidget {
  const _TabPlaceholder({required this.tab, required this.day});

  final QuickLogTab tab;
  final HealthDayOverview day;

  @override
  Widget build(BuildContext context) {
    final summary = switch (tab) {
      QuickLogTab.sleep => 'Ghi nhận thời lượng và chất lượng giấc ngủ.',
      QuickLogTab.workout =>
        'Ghi nhận thời lượng, loại hình vận động và mức độ gắng sức.',
      QuickLogTab.water =>
        'Ghi nhận dung tích nước vừa uống và thời điểm uống.',
    };
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(MemoirSpace.s4),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(tab.icon, color: Theme.of(context).colorScheme.primary),
            const SizedBox(height: MemoirSpace.s2),
            Text(tab.label, style: Theme.of(context).textTheme.titleMedium),
            const SizedBox(height: MemoirSpace.s2),
            Text(summary),
            const SizedBox(height: MemoirSpace.s3),
            Text(
              'Nội dung chi tiết sẽ được bổ sung trong tab ${tab.label}.',
              style: Theme.of(context).textTheme.bodySmall,
            ),
            if (day.log != null)
              Text(
                'Đã có dữ liệu trong ngày này.',
                style: Theme.of(context).textTheme.bodySmall,
              ),
          ],
        ),
      ),
    );
  }
}

String _two(int value) => value.toString().padLeft(2, '0');
