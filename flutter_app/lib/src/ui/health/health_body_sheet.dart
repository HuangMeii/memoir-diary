import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../data/models.dart';
import '../../data/providers.dart';
import '../home/home_scale.dart';
import '../theme.dart';
import '../tokens.dart';
import '../widgets/segmented_tabs.dart';
import 'health_metrics.dart';
import 'health_modal.dart';

/// Opens the body-metrics form for the selected calendar day: a bottom sheet on
/// phones and a centred dialog on wide windows (see [showHealthModal]).
Future<void> showHealthBodySheet(
  BuildContext context, {
  required DateTime date,
  required WidgetRef ref,
}) async {
  await showHealthModal<void>(
    context,
    builder: (_) => _HealthBodySheet(date: date),
  );
}

class _HealthBodySheet extends ConsumerStatefulWidget {
  const _HealthBodySheet({required this.date});

  final DateTime date;

  @override
  ConsumerState<_HealthBodySheet> createState() => _HealthBodySheetState();
}

class _HealthBodySheetState extends ConsumerState<_HealthBodySheet> {
  late final TextEditingController _weight;
  late final TextEditingController _height;
  late final TextEditingController _goal;
  bool _saving = false;

  ({String from, String to}) get _range {
    final today = DateTime.now();
    return (
      from: dayKey(today.subtract(const Duration(days: 179))),
      to: dayKey(today),
    );
  }

  @override
  void initState() {
    super.initState();
    _weight = TextEditingController();
    _height = TextEditingController();
    _goal = TextEditingController();
  }

  @override
  void dispose() {
    _weight.dispose();
    _height.dispose();
    _goal.dispose();
    super.dispose();
  }

  void _prefill(HealthProfile? profile, List<HealthLog> logs) {
    if (_height.text.isEmpty && profile?.heightCm != null) {
      _height.text = '${profile!.heightCm}';
    }
    if (_goal.text.isEmpty && profile?.weightGoalKg != null) {
      _goal.text = profile!.weightGoalKg!.toStringAsFixed(1);
    }
    if (_weight.text.isEmpty) {
      final selected = logs.where((log) =>
          dayKey(log.logDate) == dayKey(widget.date) && log.weightKg != null);
      final withWeight = selected.isNotEmpty
          ? selected.first
          : logs.firstWhere(
              (log) => log.weightKg != null,
              orElse: () => HealthLog(id: '', logDate: DateTime(2000)),
            );
      if (withWeight.weightKg != null) {
        _weight.text = withWeight.weightKg!.toStringAsFixed(1);
      }
    }
  }

  double? _number(TextEditingController controller) =>
      double.tryParse(controller.text.trim());

  void _step(double amount) {
    final value = (_number(_weight) ?? 0) + amount;
    _weight.text = (value < 0 ? 0 : value).toStringAsFixed(1);
    setState(() {});
  }

  Future<void> _save() async {
    final weight = _number(_weight);
    final height = int.tryParse(_height.text.trim());
    final goal = _number(_goal);
    if (_weight.text.trim().isNotEmpty && (weight == null || weight < 0) ||
        _height.text.trim().isNotEmpty && (height == null || height < 0) ||
        _goal.text.trim().isNotEmpty && (goal == null || goal < 0)) {
      _toast('Giá trị không hợp lệ. Hãy nhập số không âm.');
      return;
    }
    if (weight == null && height == null && goal == null) {
      _toast('Chưa có thay đổi để lưu');
      return;
    }

    setState(() => _saving = true);
    var weightSaved = weight == null;
    var profileSaved = height == null && goal == null;
    try {
      if (weight != null) {
        await ref.read(healthRepositoryProvider).save(
              logDate: widget.date,
              weightKg: weight,
            );
        weightSaved = true;
      }
      if (height != null || goal != null) {
        final profile = ref.read(healthProfileProvider).valueOrNull;
        await ref.read(healthRepositoryProvider).saveProfile(
              heightCm: height,
              weightGoalKg: goal,
              weightStartKg: profile?.weightStartKg ?? weight,
            );
        profileSaved = true;
      }
      refreshHealth(ref, day: widget.date);
      if (mounted) {
        Navigator.pop(context);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Đã lưu thay đổi')),
        );
      }
    } catch (error) {
      _toast(
        weightSaved && !profileSaved
            ? 'Đã lưu cân nặng nhưng chưa lưu được thông số cá nhân: $error'
            : profileSaved && !weightSaved
                ? 'Đã lưu thông số cá nhân nhưng chưa lưu được cân nặng: $error'
                : '$error',
      );
    } finally {
      if (mounted) setState(() => _saving = false);
    }
  }

  void _toast(String message) {
    if (!mounted) return;
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text(message)));
  }

  @override
  Widget build(BuildContext context) {
    final profileAsync = ref.watch(healthProfileProvider);
    final logsAsync = ref.watch(healthLogsProvider(_range));
    return profileAsync.when(
      loading: () => const _SheetLoading(),
      error: (error, _) => _SheetError(error: error),
      data: (profile) => logsAsync.when(
        loading: () => const _SheetLoading(),
        error: (error, _) => _SheetError(error: error),
        data: (logs) {
          _prefill(profile, logs);
          return _body(profile, logs);
        },
      ),
    );
  }

  Widget _body(HealthProfile? profile, List<HealthLog> logs) {
    final weight = _number(_weight);
    final height = int.tryParse(_height.text.trim());
    final bmi = bmiOf(weightKg: weight, heightCm: height);
    final zone = bmiZoneOf(bmi);
    final scale = HomeScale.textOf(context);
    return SingleChildScrollView(
      padding: EdgeInsets.fromLTRB(
        MemoirSpace.s5 * scale,
        MemoirSpace.s4 * scale,
        MemoirSpace.s5 * scale,
        MediaQuery.viewInsetsOf(context).bottom + MemoirSpace.s5 * scale,
      ),
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 460),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Expanded(
                    child: Text('Thông số cá nhân & Thể trạng',
                        style: Theme.of(context).textTheme.headlineSmall),
                  ),
                  IconButton(
                    tooltip: 'Đóng',
                    onPressed: _saving ? null : () => Navigator.pop(context),
                    icon: const Icon(Icons.close),
                  ),
                ],
              ),
              const SizedBox(height: MemoirSpace.s4),
              _numberField(_weight, 'Cân nặng hiện tại (kg)', decimal: true),
              const SizedBox(height: MemoirSpace.s2),
              Wrap(
                spacing: MemoirSpace.s2,
                children: [
                  for (final amount in [-0.5, -0.1, 0.1, 0.5])
                    OutlinedButton(
                      onPressed: _saving ? null : () => _step(amount),
                      child: Text(amount > 0 ? '+$amount' : '$amount'),
                    ),
                ],
              ),
              const SizedBox(height: MemoirSpace.s4),
              _numberField(_height, 'Chiều cao (cm)'),
              const Text('Cố định · Dùng làm mốc tính chỉ số BMI & BMR'),
              const SizedBox(height: MemoirSpace.s4),
              _BmiCard(bmi: bmi, zone: zone),
              const SizedBox(height: MemoirSpace.s4),
              _numberField(_goal, 'Cân nặng mục tiêu (kg)', decimal: true),
              if (profile?.weightGoalKg != null || _goal.text.isNotEmpty)
                _WeightProgress(
                  current: weight,
                  start: profile?.weightStartKg,
                  goal: double.tryParse(_goal.text),
                ),
              const SizedBox(height: MemoirSpace.s4),
              _WeightVariation(logs: logs),
              const SizedBox(height: MemoirSpace.s4),
              const Text(
                'Cân nặng chỉ là một chỉ số tham khảo, không định nghĩa giá trị '
                'của bạn. Hãy lắng nghe nguồn năng lượng và sự nhẹ nhõm của cơ '
                'thể mỗi ngày.',
              ),
              const SizedBox(height: MemoirSpace.s5),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  TextButton(
                    onPressed: _saving ? null : () => Navigator.pop(context),
                    child: const Text('Huỷ'),
                  ),
                  const SizedBox(width: MemoirSpace.s2),
                  FilledButton(
                    onPressed: _saving ? null : _save,
                    child: Text(_saving ? 'Đang lưu...' : 'Lưu thay đổi'),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _numberField(
    TextEditingController controller,
    String label, {
    bool decimal = false,
  }) =>
      TextField(
        controller: controller,
        keyboardType: TextInputType.numberWithOptions(decimal: decimal),
        onChanged: (_) => setState(() {}),
        decoration: InputDecoration(labelText: label),
      );
}

class _BmiCard extends StatelessWidget {
  const _BmiCard({required this.bmi, required this.zone});

  final double? bmi;
  final BmiZone? zone;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    if (bmi == null) {
      return const Card(
        child: Padding(
          padding: EdgeInsets.all(MemoirSpace.s4),
          child: Text('Chưa đủ dữ liệu để tính BMI'),
        ),
      );
    }
    final position = ((bmi! - 15) / 20).clamp(0.0, 1.0);
    final label = switch (zone) {
      BmiZone.underweight => 'Gầy',
      BmiZone.normal => 'Trọng lượng chuẩn',
      BmiZone.overweight => 'Thừa cân',
      BmiZone.obese => 'Béo phì',
      null => '',
    };
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(MemoirSpace.s4),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('BMI', style: theme.textTheme.labelLarge),
            Text(
              bmi!.toStringAsFixed(1),
              style: theme.textTheme.displaySmall,
            ),
            Text(label, style: theme.textTheme.titleMedium),
            const SizedBox(height: MemoirSpace.s2),
            SizedBox(
              height: 18,
              child: LayoutBuilder(
                builder: (context, constraints) => Stack(
                  alignment: Alignment.centerLeft,
                  children: [
                    DecoratedBox(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(9),
                        gradient: const LinearGradient(
                          colors: [
                            MemoirColorsLight.healthBmiUnder,
                            MemoirColorsLight.healthBmiNormal,
                            MemoirColorsLight.healthBmiOver,
                          ],
                        ),
                      ),
                      child: const SizedBox.expand(),
                    ),
                    Positioned(
                      left: constraints.maxWidth * position - 5,
                      child: Container(
                        width: 10,
                        height: 26,
                        decoration: BoxDecoration(
                          color: theme.colorScheme.onSurface,
                          borderRadius: BorderRadius.circular(5),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: MemoirSpace.s2),
            Text(
              'Thể trạng cân đối theo chuẩn Châu Á (IDI & WPRO)',
              style: theme.textTheme.bodySmall,
            ),
            const SizedBox(height: MemoirSpace.s2),
            Text(
              'Gầy (<18.5) · Chuẩn (18.5 - 22.9) · '
              'Thừa cân (23 - 24.9) · Béo phì (≥25)',
              style: theme.textTheme.bodySmall,
            ),
          ],
        ),
      ),
    );
  }
}

class _WeightProgress extends StatelessWidget {
  const _WeightProgress({this.current, this.start, this.goal});

  final double? current;
  final double? start;
  final double? goal;

  @override
  Widget build(BuildContext context) {
    if (current == null || start == null || goal == null || start == goal) {
      return const SizedBox.shrink();
    }
    final total = (start! - goal!).abs();
    final done = (start! - current!).abs().clamp(0.0, total);
    final progress = (done / total).clamp(0.0, 1.0);
    final remaining = (current! - goal!).abs();
    final direction = goal! < start! ? 'Đã giảm' : 'Đã tăng';
    return Padding(
      padding: const EdgeInsets.only(top: MemoirSpace.s3),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Còn ${remaining.toStringAsFixed(1)} kg'),
          LinearProgressIndicator(value: progress),
          const SizedBox(height: MemoirSpace.s2),
          Text(
            '$direction ${done.toStringAsFixed(1)} kg '
            '(${(progress * 100).round()}% chặng đường)',
          ),
          Text('Khởi điểm: ${start!.toStringAsFixed(1)} kg'),
          Text('Đích: ${goal!.toStringAsFixed(1)} kg'),
        ],
      ),
    );
  }
}

class _WeightVariation extends StatefulWidget {
  const _WeightVariation({required this.logs});

  final List<HealthLog> logs;

  @override
  State<_WeightVariation> createState() => _WeightVariationState();
}

class _WeightVariationState extends State<_WeightVariation> {
  WeightRange _range = WeightRange.fourWeeks;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final cards = weightCardsOf(widget.logs, _range, until: DateTime.now());
    final values = cards.map((card) => card.kg).whereType<double>().toList();
    final change = values.length < 2 ? null : values.last - values.first;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Wrap(
          spacing: MemoirSpace.s2,
          runSpacing: MemoirSpace.s2,
          crossAxisAlignment: WrapCrossAlignment.center,
          children: [
            Icon(Icons.trending_down,
                size: 18, color: theme.colorScheme.primary),
            Text('Biến động cân nặng', style: theme.textTheme.titleMedium),
            SegmentedTabs<WeightRange>(
              options: [
                for (final range in WeightRange.values)
                  SegmentedTab(range, range.label),
              ],
              selected: _range,
              onChanged: (value) => setState(() => _range = value),
            ),
          ],
        ),
        const SizedBox(height: MemoirSpace.s1),
        Text(
          change == null
              ? 'Chưa đủ dữ liệu trong ${_range.label} qua để thấy biến động'
              : '${change < 0 ? 'Giảm' : 'Tăng'} '
                  '${change.abs().toStringAsFixed(1)} kg trong ${_range.label} '
                  'qua một cách lành mạnh',
          style: theme.textTheme.bodySmall
              ?.copyWith(color: theme.colorScheme.onSurfaceVariant),
        ),
        const SizedBox(height: MemoirSpace.s3),
        LayoutBuilder(
          builder: (context, constraints) {
            const gap = MemoirSpace.s2;
            final columns = constraints.maxWidth < 380 ? 2 : 4;
            final width =
                (constraints.maxWidth - gap * (columns - 1)) / columns;
            return Wrap(
              spacing: gap,
              runSpacing: gap,
              children: [
                for (final card in cards)
                  SizedBox(width: width, child: _card(context, card)),
              ],
            );
          },
        ),
      ],
    );
  }

  /// One column of the design: label, value and the date/delta caption. The
  /// "Hôm nay" column uses the brand tint and primary text.
  Widget _card(BuildContext context, WeightCard card) {
    final theme = Theme.of(context);
    final palette = MemoirPalette.of(context);
    final accent = theme.colorScheme.primary;
    final today = card.isToday;
    final labelStyle = theme.textTheme.labelSmall?.copyWith(
      color: today ? accent : theme.colorScheme.onSurfaceVariant,
      fontWeight: today ? FontWeight.w600 : null,
    );
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: MemoirSpace.s2,
        vertical: MemoirSpace.s3,
      ),
      decoration: BoxDecoration(
        color: today ? palette.surfaceBrandSubtle : theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(MemoirRadius.card),
        border: Border.all(
          color: today
              ? accent.withValues(alpha: 0.4)
              : theme.colorScheme.outlineVariant.withValues(alpha: 0.5),
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(card.title, style: labelStyle, textAlign: TextAlign.center),
          const SizedBox(height: MemoirSpace.s1),
          Text(
            card.kg?.toStringAsFixed(1) ?? '--',
            textAlign: TextAlign.center,
            style: theme.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.w600,
              color: today ? accent : theme.colorScheme.onSurface,
            ),
          ),
          const SizedBox(height: MemoirSpace.s1),
          Text(
            card.caption,
            textAlign: TextAlign.center,
            style: theme.textTheme.labelSmall?.copyWith(
              color: card.caption == '--'
                  ? theme.colorScheme.onSurfaceVariant
                  : accent,
            ),
          ),
        ],
      ),
    );
  }
}

class _SheetLoading extends StatelessWidget {
  const _SheetLoading();

  @override
  Widget build(BuildContext context) => const SizedBox(
      height: 300, child: Center(child: CircularProgressIndicator()));
}

class _SheetError extends StatelessWidget {
  const _SheetError({required this.error});

  final Object error;

  @override
  Widget build(BuildContext context) =>
      SizedBox(height: 300, child: Center(child: Text('$error')));
}
