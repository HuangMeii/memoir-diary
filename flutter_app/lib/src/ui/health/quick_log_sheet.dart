import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../data/models.dart';
import '../../data/providers.dart';
import '../tokens.dart';
import '../widgets/segmented_tabs.dart';
import 'quick_workout_tab.dart';

enum QuickLogTab {
  sleep('Giờ ngủ', Icons.bedtime),
  workout('Thời gian tập', Icons.fitness_center),
  water('Uống nước', Icons.water_drop);

  const QuickLogTab(this.label, this.icon);

  final String label;
  final IconData icon;
}

Future<void> showQuickLogSheet(
  BuildContext context,
  WidgetRef ref, {
  required DateTime date,
  QuickLogTab initialTab = QuickLogTab.workout,
}) {
  return showModalBottomSheet<void>(
    context: context,
    isScrollControlled: true,
    useSafeArea: true,
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
    final theme = Theme.of(context);
    return DraggableScrollableSheet(
      expand: false,
      initialChildSize: 0.72,
      minChildSize: 0.45,
      maxChildSize: 0.92,
      builder: (context, controller) => Material(
        color: theme.colorScheme.surface,
        child: ListView(
          controller: controller,
          padding: const EdgeInsets.fromLTRB(
            MemoirSpace.s5,
            MemoirSpace.s3,
            MemoirSpace.s5,
            MemoirSpace.s5,
          ),
          children: [
            Row(
              children: [
                Expanded(
                  child: Text(
                    'Ghi nhận sức khoẻ',
                    style: theme.textTheme.headlineSmall,
                  ),
                ),
                IconButton(
                  tooltip: 'Đóng',
                  onPressed: _close,
                  icon: const Icon(Icons.close),
                ),
              ],
            ),
            Text(
              'Cập nhật nhật ký thể trạng cá nhân cho ngày hôm nay',
              style: theme.textTheme.bodyMedium,
            ),
            const SizedBox(height: MemoirSpace.s2),
            Text(
              'Ngày ${widget.date.day.toString().padLeft(2, '0')}/'
              '${widget.date.month.toString().padLeft(2, '0')}/'
              '${widget.date.year}',
              style: theme.textTheme.labelLarge,
            ),
            const SizedBox(height: MemoirSpace.s4),
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: SegmentedTabs<QuickLogTab>(
                options: QuickLogTab.values
                    .map((item) => SegmentedTab(item, item.label))
                    .toList(),
                selected: _tab,
                onChanged: (value) => setState(() => _tab = value),
              ),
            ),
            const SizedBox(height: MemoirSpace.s5),
            IndexedStack(
              index: _tab.index,
              children: [
                _TabPlaceholder(tab: QuickLogTab.sleep, day: day),
                QuickWorkoutTab(
                  key: _workoutKey,
                  date: widget.date,
                  day: day,
                  onDirtyChanged: (dirty) => setState(() => _dirty = dirty),
                ),
                _TabPlaceholder(tab: QuickLogTab.water, day: day),
              ],
            ),
            const SizedBox(height: MemoirSpace.s5),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                TextButton(
                  onPressed: _saving ? null : _close,
                  child: const Text('Huỷ / Để sau'),
                ),
                const SizedBox(width: MemoirSpace.s2),
                FilledButton.icon(
                  onPressed: _saving ? null : _save,
                  icon: const Icon(Icons.save_outlined),
                  label: Text(_saving ? 'Đang lưu...' : 'Lưu vào nhật ký'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _save() async {
    setState(() => _saving = true);
    try {
      if (_tab == QuickLogTab.workout) {
        await _workoutKey.currentState!.save();
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
