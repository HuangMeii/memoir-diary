import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../data/models.dart';
import '../../data/providers.dart';
import '../tokens.dart';
import '../widgets/segmented_tabs.dart';

class QuickWorkoutTab extends ConsumerStatefulWidget {
  const QuickWorkoutTab({
    super.key,
    required this.date,
    required this.day,
    required this.onDirtyChanged,
  });

  final DateTime date;
  final HealthDayOverview day;
  final ValueChanged<bool> onDirtyChanged;

  @override
  QuickWorkoutTabState createState() => QuickWorkoutTabState();
}

class QuickWorkoutTabState extends ConsumerState<QuickWorkoutTab> {
  late final TextEditingController _minutes;
  late final TextEditingController _type;
  String _intensity = 'vua';
  String? _minutesError;

  @override
  void initState() {
    super.initState();
    final log = widget.day.log;
    _minutes = TextEditingController(
      text: log?.workoutMinutes?.toString() ?? '',
    )..addListener(_changed);
    _type = TextEditingController(text: log?.workoutType ?? '')
      ..addListener(_changed);
    _intensity = log?.workoutIntensity ?? 'vua';
  }

  @override
  void dispose() {
    _minutes.dispose();
    _type.dispose();
    super.dispose();
  }

  void _changed() {
    widget.onDirtyChanged(true);
  }

  Future<void> save() async {
    final raw = _minutes.text.trim();
    final minutes = raw.isEmpty ? null : int.tryParse(raw);
    if (raw.isNotEmpty && (minutes == null || minutes < 0 || minutes > 1440)) {
      setState(() {
        _minutesError = 'Nhập số phút từ 0 đến 1440';
      });
      throw const FormatException('Số phút tập luyện không hợp lệ');
    }
    setState(() => _minutesError = null);
    await ref.read(healthRepositoryProvider).save(
          logDate: widget.date,
          workoutMinutes: minutes,
          workoutType: _type.text.trim().isEmpty ? null : _type.text.trim(),
          workoutIntensity: raw.isEmpty ? null : _intensity,
        );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Ghi nhận thời lượng luyện tập',
          style: theme.textTheme.titleLarge,
        ),
        const SizedBox(height: MemoirSpace.s2),
        Text(
          'Ghi nhận thời lượng, loại hình vận động và mức độ gắng sức '
          'để đồng bộ nhịp rèn luyện thể chất.',
          style: theme.textTheme.bodyMedium,
        ),
        const SizedBox(height: MemoirSpace.s4),
        TextField(
          controller: _minutes,
          keyboardType: TextInputType.number,
          decoration: InputDecoration(
            labelText: 'Số phút tập luyện',
            suffixText: 'phút',
            errorText: _minutesError,
          ),
        ),
        const SizedBox(height: MemoirSpace.s3),
        TextField(
          controller: _type,
          decoration: const InputDecoration(labelText: 'Loại hình bài tập'),
        ),
        const SizedBox(height: MemoirSpace.s2),
        Wrap(
          spacing: MemoirSpace.s2,
          runSpacing: MemoirSpace.s2,
          children: [
            for (final type in ['Chạy bộ', 'Yoga', 'Đạp xe', 'Bơi'])
              ActionChip(
                label: Text(type),
                onPressed: () => _type.text = type,
              ),
          ],
        ),
        const SizedBox(height: MemoirSpace.s4),
        Text('Mức độ gắng sức', style: theme.textTheme.labelLarge),
        const SizedBox(height: MemoirSpace.s2),
        SegmentedTabs<String>(
          options: const [
            SegmentedTab('nhe', 'Tập nhẹ'),
            SegmentedTab('vua', 'Tập vừa'),
            SegmentedTab('nang', 'Tập nặng'),
          ],
          selected: _intensity,
          onChanged: (value) {
            setState(() => _intensity = value);
            widget.onDirtyChanged(true);
          },
        ),
        const SizedBox(height: MemoirSpace.s4),
        Row(
          children: [
            Icon(Icons.lock_outline,
                size: 16, color: theme.colorScheme.onSurfaceVariant),
            const SizedBox(width: MemoirSpace.s2),
            Expanded(
              child: Text(
                'Dữ liệu được lưu trữ riêng tư trong tài khoản Memoir của bạn.',
                style: theme.textTheme.bodySmall,
              ),
            ),
          ],
        ),
      ],
    );
  }
}
