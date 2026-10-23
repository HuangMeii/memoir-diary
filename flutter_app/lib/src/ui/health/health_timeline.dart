import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../data/models.dart';
import '../../data/providers.dart';
import '../tokens.dart';
import 'health_metrics.dart';

/// The day's inferred health events and milestones the user added themselves.
class HealthTimeline extends ConsumerStatefulWidget {
  const HealthTimeline({
    super.key,
    required this.date,
    required this.day,
    required this.onChanged,
  });

  final DateTime date;
  final HealthDayOverview day;
  final VoidCallback onChanged;

  @override
  ConsumerState<HealthTimeline> createState() => _HealthTimelineState();
}

class _HealthTimelineState extends ConsumerState<HealthTimeline> {
  static const _visibleItemCount = 5;
  bool _busy = false;

  Future<void> _addMilestone() async {
    final draft = await showDialog<_MilestoneDraft>(
      context: context,
      builder: (_) => const _AddMilestoneDialog(),
    );
    if (draft == null) return;

    setState(() => _busy = true);
    try {
      await ref.read(healthRepositoryProvider).addActivity(
            logDate: widget.date,
            atTime: draft.atTime,
            title: draft.title,
            detail: draft.detail,
          );
      refreshHealth(ref, day: widget.date);
      widget.onChanged();
    } catch (error) {
      _showError(error);
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  Future<void> _removeMilestone(HealthActivity activity) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Xoá mốc hoạt động?'),
        content: Text('Bạn muốn xoá “${activity.title}” khỏi hôm nay?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Huỷ'),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Xoá'),
          ),
        ],
      ),
    );
    if (confirmed != true) return;

    setState(() => _busy = true);
    try {
      await ref.read(healthRepositoryProvider).removeActivity(activity.id);
      refreshHealth(ref, day: widget.date);
      widget.onChanged();
    } catch (error) {
      _showError(error);
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  void _showError(Object error) {
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('$error')),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final items = _timelineItems(widget.day);
    final visibleItems = items.take(_visibleItemCount).toList();

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(MemoirSpace.s4),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: Text(
                    'DÒNG THỜI GIAN HOẠT ĐỘNG',
                    style: theme.textTheme.labelLarge,
                  ),
                ),
                TextButton.icon(
                  onPressed: _busy ? null : _addMilestone,
                  icon: const Icon(Icons.add, size: 18),
                  label: const Text('Thêm mốc'),
                ),
              ],
            ),
            const SizedBox(height: MemoirSpace.s3),
            if (visibleItems.isEmpty)
              _EmptyTimeline(onAdd: _busy ? null : _addMilestone)
            else ...[
              for (var i = 0; i < visibleItems.length; i++)
                _TimelineRow(
                  item: visibleItems[i],
                  isLast: i == visibleItems.length - 1,
                  onRemove: visibleItems[i].activity == null || _busy
                      ? null
                      : () => _removeMilestone(visibleItems[i].activity!),
                ),
              if (items.length > _visibleItemCount)
                const Tooltip(
                  message: 'Lịch sử 7 ngày sẽ được bổ sung sau',
                  child: TextButton(
                    onPressed: null,
                    child: Text('Xem toàn bộ lịch sử 7 ngày'),
                  ),
                ),
            ],
          ],
        ),
      ),
    );
  }

  List<_TimelineItem> _timelineItems(HealthDayOverview day) {
    final items = <_TimelineItem>[];
    final log = day.log;
    if (log?.workoutMinutes != null) {
      final type = _workoutType(log!.workoutType);
      final intensity = _workoutIntensity(log.workoutIntensity);
      items.add(
        _TimelineItem(
          title: 'Buổi tập',
          detail: '${formatMinutes(log.workoutMinutes)} · $type · $intensity',
          isUserAdded: false,
        ),
      );
    }

    final lastWater = waterBreakdownOf(day.water).lastAt;
    if (lastWater != null) {
      final amount = day.water
          .where((entry) => entry.recordedAt == lastWater)
          .fold<int>(0, (sum, entry) => sum + entry.amountMl);
      items.add(
        _TimelineItem(
          time: _formatTime(lastWater),
          title: 'Bổ sung nước',
          detail: '$amount ml',
          sortTime: _timeValue(_formatTime(lastWater)),
          isUserAdded: false,
        ),
      );
    }

    if (log?.sleepHours != null) {
      final bedtime = log!.sleepBedtime;
      items.add(
        _TimelineItem(
          time: bedtime,
          title: 'Giấc ngủ',
          detail: formatSleepDuration(log.sleepHours),
          sortTime: _timeValue(bedtime),
          isUserAdded: false,
        ),
      );
    }

    items.addAll(
      day.activities.map(
        (activity) => _TimelineItem(
          time: activity.atTime,
          title: activity.title,
          detail: activity.detail,
          sortTime: _timeValue(activity.atTime),
          activity: activity,
          isUserAdded: true,
        ),
      ),
    );
    items.sort((a, b) {
      final aTime = a.sortTime;
      final bTime = b.sortTime;
      if (aTime == null && bTime == null) return 0;
      if (aTime == null) return 1;
      if (bTime == null) return -1;
      return aTime.compareTo(bTime);
    });
    return items;
  }

  static String _workoutType(String? type) => switch (type) {
        'run' => 'Chạy bộ',
        'walk' => 'Đi bộ',
        'yoga' => 'Yoga',
        _ => type?.isNotEmpty == true ? type! : 'vận động',
      };

  static String _workoutIntensity(String? intensity) => switch (intensity) {
        'nhe' => 'nhẹ',
        'nang' => 'nặng',
        'vua' => 'vừa',
        _ => 'vừa',
      };

  static String? _timeValue(String? value) {
    if (value == null || !RegExp(r'^\d{2}:\d{2}$').hasMatch(value)) {
      return null;
    }
    return value;
  }

  static String _formatTime(DateTime value) {
    final vietnamTime = value.toUtc().add(const Duration(hours: 7));
    return '${vietnamTime.hour.toString().padLeft(2, '0')}:'
        '${vietnamTime.minute.toString().padLeft(2, '0')}';
  }
}

class _TimelineItem {
  const _TimelineItem({
    this.time,
    required this.title,
    this.detail,
    this.sortTime,
    this.activity,
    required this.isUserAdded,
  });

  final String? time;
  final String title;
  final String? detail;
  final String? sortTime;
  final HealthActivity? activity;
  final bool isUserAdded;
}

class _TimelineRow extends StatelessWidget {
  const _TimelineRow({
    required this.item,
    required this.isLast,
    required this.onRemove,
  });

  final _TimelineItem item;
  final bool isLast;
  final VoidCallback? onRemove;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final color = item.isUserAdded
        ? theme.colorScheme.primary
        : theme.colorScheme.outlineVariant;
    final detail = item.detail;
    return IntrinsicHeight(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          SizedBox(
            width: 24,
            child: Column(
              children: [
                Container(
                  width: 10,
                  height: 10,
                  margin: const EdgeInsets.only(top: 6),
                  decoration: BoxDecoration(
                    color: color,
                    shape: BoxShape.circle,
                  ),
                ),
                if (!isLast) Expanded(child: Container(width: 1, color: color)),
              ],
            ),
          ),
          const SizedBox(width: MemoirSpace.s2),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(bottom: MemoirSpace.s3),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    [
                      if (item.time?.isNotEmpty == true) item.time!,
                      item.title,
                    ].join(' · '),
                    style: theme.textTheme.titleSmall,
                  ),
                  if (detail?.isNotEmpty == true)
                    Text(detail!, style: theme.textTheme.bodySmall),
                ],
              ),
            ),
          ),
          if (onRemove != null)
            IconButton(
              tooltip: 'Xoá mốc',
              onPressed: onRemove,
              icon: const Icon(Icons.close, size: 18),
              visualDensity: VisualDensity.compact,
            ),
        ],
      ),
    );
  }
}

class _EmptyTimeline extends StatelessWidget {
  const _EmptyTimeline({required this.onAdd});

  final VoidCallback? onAdd;

  @override
  Widget build(BuildContext context) => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Chưa có mốc nào hôm nay. Thêm mốc đầu tiên.'),
          const SizedBox(height: MemoirSpace.s2),
          TextButton.icon(
            onPressed: onAdd,
            icon: const Icon(Icons.add, size: 18),
            label: const Text('Thêm mốc'),
          ),
        ],
      );
}

class _MilestoneDraft {
  const _MilestoneDraft({
    required this.atTime,
    required this.title,
    this.detail,
  });

  final String atTime;
  final String title;
  final String? detail;
}

class _AddMilestoneDialog extends StatefulWidget {
  const _AddMilestoneDialog();

  @override
  State<_AddMilestoneDialog> createState() => _AddMilestoneDialogState();
}

class _AddMilestoneDialogState extends State<_AddMilestoneDialog> {
  final _title = TextEditingController();
  final _detail = TextEditingController();
  TimeOfDay _time = TimeOfDay.now();

  @override
  void dispose() {
    _title.dispose();
    _detail.dispose();
    super.dispose();
  }

  Future<void> _pickTime() async {
    final selected = await showTimePicker(
      context: context,
      initialTime: _time,
    );
    if (selected != null) setState(() => _time = selected);
  }

  void _submit() {
    final title = _title.text.trim();
    if (title.isEmpty) return;
    final time =
        '${_time.hour.toString().padLeft(2, '0')}:${_time.minute.toString().padLeft(2, '0')}';
    final detail = _detail.text.trim();
    Navigator.pop(
      context,
      _MilestoneDraft(
        atTime: time,
        title: title,
        detail: detail.isEmpty ? null : detail,
      ),
    );
  }

  @override
  Widget build(BuildContext context) => AlertDialog(
        title: const Text('Thêm mốc hoạt động'),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                contentPadding: EdgeInsets.zero,
                leading: const Icon(Icons.schedule),
                title: const Text('Giờ'),
                subtitle: Text(_time.format(context)),
                onTap: _pickTime,
              ),
              TextField(
                controller: _title,
                autofocus: true,
                textInputAction: TextInputAction.next,
                decoration: const InputDecoration(labelText: 'Tiêu đề *'),
                onChanged: (_) => setState(() {}),
              ),
              TextField(
                controller: _detail,
                textInputAction: TextInputAction.done,
                decoration: const InputDecoration(labelText: 'Ghi chú'),
                onSubmitted: (_) => _submit(),
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Huỷ'),
          ),
          FilledButton(
            onPressed: _title.text.trim().isEmpty ? null : _submit,
            child: const Text('Thêm'),
          ),
        ],
      );
}
