import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../data/models.dart';
import '../../data/providers.dart';
import '../home/home_scale.dart';
import '../theme.dart';
import '../tokens.dart';
import '../widgets/segmented_tabs.dart';
import 'health_metrics.dart';

/// Form "Nhập nhanh chỉ số hôm nay" — thay form 6 ô cũ của `health_screen.dart`.
///
/// Ghi qua [HealthRepository.save] (chỉ gửi field khác null) và làm mới dữ liệu
/// bằng [refreshHealth]. Không đọc provider trực tiếp: nhận [date]/[day]/[profile]
/// từ màn (H3-S8) để tránh hai nguồn sự thật.
class HealthQuickForm extends ConsumerStatefulWidget {
  const HealthQuickForm({
    super.key,
    required this.date,
    required this.day,
    required this.profile,
    required this.onSaved,
    required this.onOpenBodySheet,
    this.onAddWater,
    this.onOpenSleepSheet,
  });

  final DateTime date;
  final HealthDayOverview day;
  final HealthProfile? profile;
  final VoidCallback onSaved;
  final VoidCallback onOpenBodySheet;
  final VoidCallback? onAddWater;
  final VoidCallback? onOpenSleepSheet;

  @override
  ConsumerState<HealthQuickForm> createState() => _HealthQuickFormState();
}

class _HealthQuickFormState extends ConsumerState<HealthQuickForm> {
  final _workoutMinutes = TextEditingController();
  final _sleepHours = TextEditingController();
  final _weightKg = TextEditingController();
  final _heightCm = TextEditingController();
  final _note = TextEditingController();

  String? _bedtime;
  String? _wake;
  String _intensity = 'vua';
  bool _expanded = true;
  bool _saving = false;

  @override
  void initState() {
    super.initState();
    _prefill();
  }

  @override
  void didUpdateWidget(HealthQuickForm oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.date != widget.date) {
      _clear();
      _prefill();
    }
  }

  @override
  void dispose() {
    for (final c in [
      _workoutMinutes,
      _sleepHours,
      _weightKg,
      _heightCm,
      _note,
    ]) {
      c.dispose();
    }
    super.dispose();
  }

  void _clear() {
    _workoutMinutes.clear();
    _sleepHours.clear();
    _weightKg.clear();
    _heightCm.clear();
    _note.clear();
    _bedtime = null;
    _wake = null;
    _intensity = 'vua';
  }

  void _prefill() {
    final log = widget.day.log;
    _workoutMinutes.text = log?.workoutMinutes?.toString() ?? '';
    _intensity = log?.workoutIntensity ?? 'vua';
    _sleepHours.text = log?.sleepHours?.toString() ?? '';
    _bedtime = log?.sleepBedtime;
    _wake = log?.sleepWake;
    _weightKg.text = log?.weightKg?.toString() ?? '';
    _heightCm.text = widget.profile?.heightCm?.toString() ?? '';
    _note.text = log?.note ?? '';
  }

  static int? _parseNonNegativeInt(String text) {
    final v = int.tryParse(text.trim());
    if (v == null || v < 0) return null;
    return v;
  }

  static double? _parseNonNegativeDouble(String text) {
    final v = double.tryParse(text.trim());
    if (v == null || v < 0) return null;
    return v;
  }

  bool _validate() {
    if (_workoutMinutes.text.trim().isNotEmpty &&
        _parseNonNegativeInt(_workoutMinutes.text) == null) {
      return false;
    }
    if (_sleepHours.text.trim().isNotEmpty &&
        _parseNonNegativeDouble(_sleepHours.text) == null) {
      return false;
    }
    if (_weightKg.text.trim().isNotEmpty &&
        _parseNonNegativeDouble(_weightKg.text) == null) {
      return false;
    }
    if (_heightCm.text.trim().isNotEmpty &&
        _parseNonNegativeInt(_heightCm.text) == null) {
      return false;
    }
    return true;
  }

  bool _hasAnyInput() {
    return _workoutMinutes.text.trim().isNotEmpty ||
        _sleepHours.text.trim().isNotEmpty ||
        _weightKg.text.trim().isNotEmpty ||
        _heightCm.text.trim().isNotEmpty ||
        _note.text.trim().isNotEmpty ||
        _bedtime != null ||
        _wake != null;
  }

  void _toast(String message) {
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message), duration: const Duration(seconds: 3)),
    );
  }

  Future<void> _save() async {
    if (!_validate()) {
      _toast('Giá trị nhập không hợp lệ (không được âm, phải là số).');
      return;
    }
    if (!_hasAnyInput()) {
      _toast('Chưa nhập gì để lưu');
      return;
    }

    final log = HealthLog(
      id: '',
      logDate: widget.date,
      workoutMinutes: _parseNonNegativeInt(_workoutMinutes.text),
      workoutIntensity:
          _workoutMinutes.text.trim().isNotEmpty ? _intensity : null,
      sleepHours: _parseNonNegativeDouble(_sleepHours.text),
      sleepBedtime: _bedtime,
      sleepWake: _wake,
      weightKg: _parseNonNegativeDouble(_weightKg.text),
      note: _note.text.trim().isEmpty ? null : _note.text.trim(),
    );
    final payload = log.toPayload();
    if (payload.isEmpty) {
      _toast('Chưa nhập gì để lưu');
      return;
    }

    setState(() => _saving = true);
    try {
      await ref.read(healthRepositoryProvider).save(
            logDate: widget.date,
            steps: null,
            workoutMinutes: log.workoutMinutes,
            workoutType: null,
            workoutIntensity: log.workoutIntensity,
            waterMl: null,
            sleepHours: log.sleepHours,
            sleepBedtime: log.sleepBedtime,
            sleepWake: log.sleepWake,
            sleepDeepMinutes: null,
            sleepQuality: null,
            sleepNote: null,
            weightKg: log.weightKg,
            note: log.note,
          );
      refreshHealth(ref, day: widget.date);
      _toast('Đã lưu ngày ${widget.date.day}/${widget.date.month}');
      widget.onSaved();
    } catch (e) {
      _toast('$e');
    } finally {
      if (mounted) setState(() => _saving = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scale = HomeScale.textOf(context);
    final palette = MemoirPalette.of(context);
    final breakdown = waterBreakdownOf(widget.day.water);
    final waterGoal = widget.profile?.waterGoalMl ?? 2000;
    final waterPct = widget.day.water.isNotEmpty
        ? _goalPct(breakdown.totalMl, waterGoal)
        : 0;

    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            decoration: BoxDecoration(
              color: palette.surfaceCard,
              borderRadius: BorderRadius.circular(MemoirRadius.card),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.all(MemoirSpace.s4),
                  child: Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'NHẬP NHANH CHỈ SỐ HÔM NAY',
                              style: theme.textTheme.labelSmall?.copyWith(
                                fontSize: MemoirType.caption * scale,
                                fontWeight: FontWeight.w600,
                                letterSpacing: 1,
                              ),
                            ),
                            const SizedBox(height: MemoirSpace.s1),
                            Text(
                              'Ngày ${widget.date.day.toString().padLeft(2, '0')}/'
                              '${widget.date.month.toString().padLeft(2, '0')}/'
                              '${widget.date.year}',
                              style: theme.textTheme.bodyMedium?.copyWith(
                                fontSize: MemoirType.body * scale,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                      ),
                      IconButton(
                        icon: Icon(
                          _expanded ? Icons.expand_less : Icons.expand_more,
                          size: 20,
                          color: theme.colorScheme.primary,
                        ),
                        onPressed: () => setState(() => _expanded = !_expanded),
                        tooltip: _expanded ? 'Đóng' : 'Sửa',
                      ),
                    ],
                  ),
                ),
                if (_expanded) ...[
                  const Divider(height: 1),
                  _sectionTitle(context, 'Vận động'),
                  const SizedBox(height: MemoirSpace.s3),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        flex: 2,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Thời lượng (phút)',
                              style: theme.textTheme.labelLarge?.copyWith(
                                fontSize: MemoirType.label * scale,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            const SizedBox(height: MemoirSpace.s2),
                            TextField(
                              controller: _workoutMinutes,
                              keyboardType: TextInputType.number,
                              decoration: const InputDecoration(
                                hintText: 'Số phút',
                                border: OutlineInputBorder(),
                                contentPadding: EdgeInsets.symmetric(
                                  horizontal: MemoirSpace.s3,
                                  vertical: MemoirSpace.s2,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: MemoirSpace.s3),
                      Expanded(
                        flex: 3,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Cường độ',
                              style: theme.textTheme.labelLarge?.copyWith(
                                fontSize: MemoirType.label * scale,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            const SizedBox(height: MemoirSpace.s2),
                            SegmentedTabs<String>(
                              options: const [
                                SegmentedTab('nhe', 'Tập nhẹ'),
                                SegmentedTab('vua', 'Tập vừa'),
                                SegmentedTab('nang', 'Tập nặng'),
                              ],
                              selected: _intensity,
                              onChanged: (v) => setState(() => _intensity = v),
                              scale: 1,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: MemoirSpace.s4),
                  _sectionTitle(context, 'Nước uống (chỉ đọc)'),
                  const SizedBox(height: MemoirSpace.s3),
                  Row(
                    children: [
                      Expanded(
                        child: _readOnlyPair(
                          context,
                          'Tổng lượng',
                          '${formatMl(breakdown.totalMl)} / '
                              '${formatMl(waterGoal)}',
                          scale,
                        ),
                      ),
                      Expanded(
                        child: _readOnlyPair(
                          context,
                          'Số lần',
                          '${breakdown.count} lần',
                          scale,
                        ),
                      ),
                      Expanded(
                        child: _readOnlyPair(
                          context,
                          'Gần nhất',
                          breakdown.lastAt != null
                              ? formatClock(breakdown.lastAt!)
                              : '–',
                          scale,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: MemoirSpace.s3),
                  ..._periodRows(context, breakdown, scale),
                  const SizedBox(height: MemoirSpace.s2),
                  Text(
                    'Đã nạp $waterPct% mục tiêu',
                    style: theme.textTheme.bodySmall?.copyWith(
                      fontSize: MemoirType.caption * scale,
                      color: theme.colorScheme.onSurfaceVariant,
                    ),
                  ),
                  const SizedBox(height: MemoirSpace.s3),
                  Align(
                    alignment: Alignment.centerRight,
                    child: OutlinedButton.icon(
                      icon: const Icon(Icons.add, size: 18),
                      label: const Text('+ Thêm ly'),
                      onPressed: widget.onAddWater == null
                          ? () => _toast('Sẽ có sau (sheet ghi nhận nhanh)')
                          : widget.onAddWater!,
                    ),
                  ),
                  const SizedBox(height: MemoirSpace.s4),
                  _sectionTitle(context, 'Giấc ngủ'),
                  const SizedBox(height: MemoirSpace.s3),
                  Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Thời lượng ngủ (giờ)',
                              style: theme.textTheme.labelLarge?.copyWith(
                                fontSize: MemoirType.label * scale,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            const SizedBox(height: MemoirSpace.s2),
                            TextField(
                              controller: _sleepHours,
                              keyboardType: TextInputType.number,
                              decoration: const InputDecoration(
                                hintText: 'Số giờ',
                                border: OutlineInputBorder(),
                                contentPadding: EdgeInsets.symmetric(
                                  horizontal: MemoirSpace.s3,
                                  vertical: MemoirSpace.s2,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: MemoirSpace.s3),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Khung giờ ngủ',
                              style: theme.textTheme.labelLarge?.copyWith(
                                fontSize: MemoirType.label * scale,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            const SizedBox(height: MemoirSpace.s2),
                            Row(
                              children: [
                                Expanded(
                                  child: _timeField(
                                    context,
                                    'Giờ ngủ',
                                    _bedtime,
                                    (v) => setState(() => _bedtime = v),
                                  ),
                                ),
                                const SizedBox(width: MemoirSpace.s2),
                                Expanded(
                                  child: _timeField(
                                    context,
                                    'Giờ thức',
                                    _wake,
                                    (v) => setState(() => _wake = v),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: MemoirSpace.s3),
                  Align(
                    alignment: Alignment.centerRight,
                    child: OutlinedButton(
                      onPressed: widget.onOpenSleepSheet == null
                          ? () => _toast('Sẽ có sau (sheet giờ ngủ)')
                          : widget.onOpenSleepSheet!,
                      child: const Text('Mở sheet giờ ngủ'),
                    ),
                  ),
                  const SizedBox(height: MemoirSpace.s4),
                  _sectionTitle(context, 'Thông số cá nhân'),
                  const SizedBox(height: MemoirSpace.s3),
                  Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Cân nặng (kg)',
                              style: theme.textTheme.labelLarge?.copyWith(
                                fontSize: MemoirType.label * scale,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            const SizedBox(height: MemoirSpace.s2),
                            TextField(
                              controller: _weightKg,
                              keyboardType: TextInputType.number,
                              decoration: const InputDecoration(
                                hintText: 'kg',
                                border: OutlineInputBorder(),
                                contentPadding: EdgeInsets.symmetric(
                                  horizontal: MemoirSpace.s3,
                                  vertical: MemoirSpace.s2,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: MemoirSpace.s3),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Chiều cao (cm)',
                              style: theme.textTheme.labelLarge?.copyWith(
                                fontSize: MemoirType.label * scale,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            const SizedBox(height: MemoirSpace.s2),
                            TextField(
                              controller: _heightCm,
                              keyboardType: TextInputType.number,
                              decoration: const InputDecoration(
                                hintText: 'cm',
                                border: OutlineInputBorder(),
                                contentPadding: EdgeInsets.symmetric(
                                  horizontal: MemoirSpace.s3,
                                  vertical: MemoirSpace.s2,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: MemoirSpace.s3),
                  Align(
                    alignment: Alignment.centerRight,
                    child: OutlinedButton(
                      onPressed: widget.onOpenBodySheet,
                      child: const Text('Thông số cá nhân & Thể trạng'),
                    ),
                  ),
                  const SizedBox(height: MemoirSpace.s4),
                  _sectionTitle(context, 'Ghi chú cơ thể hôm nay'),
                  const SizedBox(height: MemoirSpace.s2),
                  TextField(
                    controller: _note,
                    maxLines: 3,
                    minLines: 1,
                    decoration: const InputDecoration(
                      hintText: 'Hôm nay cơ thể nhẹ nhõm…',
                      border: OutlineInputBorder(),
                      contentPadding: EdgeInsets.symmetric(
                        horizontal: MemoirSpace.s3,
                        vertical: MemoirSpace.s2,
                      ),
                    ),
                  ),
                  const SizedBox(height: MemoirSpace.s4),
                  SizedBox(
                    width: double.infinity,
                    child: FilledButton.icon(
                      icon: _saving
                          ? const SizedBox(
                              width: 16,
                              height: 16,
                              child: CircularProgressIndicator(strokeWidth: 2),
                            )
                          : const Icon(Icons.save, size: 18),
                      label: Text(_saving ? 'Đang lưu…' : 'Lưu chỉ số'),
                      onPressed: _saving ? null : _save,
                    ),
                  ),
                  const Padding(
                    padding: EdgeInsets.only(bottom: MemoirSpace.s4),
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _sectionTitle(BuildContext context, String title) {
    final theme = Theme.of(context);
    final scale = HomeScale.textOf(context);
    return Text(
      title,
      style: theme.textTheme.labelLarge?.copyWith(
        fontSize: MemoirType.label * scale,
        fontWeight: FontWeight.w600,
        color: theme.colorScheme.primary,
      ),
    );
  }

  TextStyle _captionStyle(
          BuildContext context, ThemeData theme, double scale) =>
      theme.textTheme.bodySmall?.copyWith(
        fontSize: MemoirType.caption * scale,
        color: theme.colorScheme.onSurfaceVariant,
      ) ??
      const TextStyle();

  Widget _readOnlyPair(
    BuildContext context,
    String label,
    String value,
    double scale,
  ) {
    final theme = Theme.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: _captionStyle(context, theme, scale).copyWith(
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: MemoirSpace.s1),
        Text(
          value,
          style: theme.textTheme.bodyMedium?.copyWith(
            fontSize: MemoirType.body * scale,
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }

  Widget _timeField(
    BuildContext context,
    String label,
    String? value,
    ValueChanged<String> onChanged,
  ) {
    final theme = Theme.of(context);
    final scale = HomeScale.textOf(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: _captionStyle(context, theme, scale).copyWith(
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: MemoirSpace.s1),
        InkWell(
          onTap: () async {
            final picked = await showTimePicker(
              context: context,
              initialTime: TimeOfDay.now(),
            );
            if (picked != null) {
              onChanged(
                '${picked.hour.toString().padLeft(2, '0')}:'
                '${picked.minute.toString().padLeft(2, '0')}',
              );
            }
          },
          child: InputDecorator(
            decoration: const InputDecoration(
              border: OutlineInputBorder(),
              contentPadding: EdgeInsets.symmetric(
                horizontal: MemoirSpace.s3,
                vertical: MemoirSpace.s2,
              ),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  value ?? '--:--',
                  style: theme.textTheme.bodyMedium?.copyWith(
                    fontSize: MemoirType.body * scale,
                  ),
                ),
                const SizedBox(width: MemoirSpace.s2),
                const Icon(Icons.access_time, size: 18),
              ],
            ),
          ),
        ),
      ],
    );
  }

  List<Widget> _periodRows(
    BuildContext context,
    WaterBreakdown b,
    double scale,
  ) {
    final theme = Theme.of(context);
    final peak = b.peakPeriod;
    final rows = <Widget>[];
    for (final period in WaterPeriod.values) {
      final ml = b.mlByPeriod[period] ?? 0;
      var count = 0;
      for (final e in widget.day.water) {
        if (periodOf(e.recordedAt) == period) count++;
      }
      final isPeak = peak == period && ml > 0;
      rows.add(
        Padding(
          padding: const EdgeInsets.only(bottom: MemoirSpace.s1),
          child: Row(
            children: [
              SizedBox(
                width: 52,
                child: Text(
                  period.label,
                  style: _captionStyle(context, theme, scale),
                ),
              ),
              Text(
                '${formatMl(ml)} · $count lần nạp',
                style: _captionStyle(context, theme, scale),
              ),
              if (isPeak) ...[
                const SizedBox(width: MemoirSpace.s2),
                Text(
                  'Cao nhất',
                  style: _captionStyle(context, theme, scale).copyWith(
                    color: theme.colorScheme.primary,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ],
          ),
        ),
      );
    }
    return rows;
  }

  static int _goalPct(num current, num goal) {
    if (goal <= 0) return 0;
    return (current / goal * 100).round();
  }
}
