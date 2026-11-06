import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../data/models.dart';
import '../../data/providers.dart';
import '../theme.dart';
import '../tokens.dart';
import 'health_metrics.dart';

/// One of the three sleep-quality cards. [code] is exactly what
/// `health_logs.sleep_quality` stores (`chapChon|binhThuong|ngonSau`), so the
/// dashboard cards keep decoding it without a mapping table.
class _QualityOption {
  const _QualityOption(this.code, this.label, this.caption, this.icon);

  final String code;
  final String label;
  final String caption;
  final IconData icon;
}

const List<_QualityOption> _qualityOptions = [
  _QualityOption(
    'chapChon',
    'Chập chờn',
    'Khó vào giấc, thức giấc nhiều lần',
    Icons.nights_stay_outlined,
  ),
  _QualityOption(
    'binhThuong',
    'Bình thường',
    'Đủ giấc, không quá mệt mỏi',
    Icons.bed_outlined,
  ),
  _QualityOption(
    'ngonSau',
    'Ngủ ngon & sâu',
    'Thức dậy tràn đầy năng lượng',
    Icons.hotel_class_outlined,
  ),
];

/// The `Giờ ngủ` tab of the quick-log sheet (H4-S4).
///
/// Mirrors `ui-figma/suckhoe/memoir_ghi_nh_n_gi_ng/code.html`: a total-sleep
/// hero box, the bedtime/wake/deep-sleep tiles, the three quality cards and the
/// morning note. The sheet owns the save button; this tab only collects the
/// draft and writes it in [QuickSleepTabState.save].
class QuickSleepTab extends ConsumerStatefulWidget {
  const QuickSleepTab({
    super.key,
    required this.date,
    required this.day,
    this.profile,
    required this.onDirtyChanged,
  });

  final DateTime date;
  final HealthDayOverview day;
  final HealthProfile? profile;
  final ValueChanged<bool> onDirtyChanged;

  @override
  QuickSleepTabState createState() => QuickSleepTabState();
}

class QuickSleepTabState extends ConsumerState<QuickSleepTab> {
  late final TextEditingController _hours;
  late final TextEditingController _minutes;
  late final TextEditingController _deep;
  late final TextEditingController _note;
  String? _quality;
  String? _bedtime;
  String? _wake;
  String? _hoursError;
  String? _minutesError;
  String? _deepError;

  @override
  void initState() {
    super.initState();
    final log = widget.day.log;
    final total =
        log?.sleepHours == null ? null : (log!.sleepHours! * 60).round();
    _hours = TextEditingController(
      text: total == null ? '' : '${total ~/ 60}',
    )..addListener(_touch);
    _minutes = TextEditingController(
      text: total == null ? '' : '${total % 60}',
    )..addListener(_touch);
    _deep = TextEditingController(text: log?.sleepDeepMinutes?.toString() ?? '')
      ..addListener(_touch);
    _note = TextEditingController(text: log?.sleepNote ?? '')
      ..addListener(_touch);
    _quality = log?.sleepQuality;
    _bedtime = log?.sleepBedtime;
    _wake = log?.sleepWake;
  }

  @override
  void dispose() {
    _hours.dispose();
    _minutes.dispose();
    _deep.dispose();
    _note.dispose();
    super.dispose();
  }

  void _touch() {
    widget.onDirtyChanged(true);
    if (!mounted) return;
    // Editing a field is how the user fixes a rejected value, so drop the
    // messages instead of leaving them under the numbers.
    setState(() {
      _hoursError = null;
      _minutesError = null;
      _deepError = null;
    });
  }

  /// Goal used by the hero and the recommended range; the design default is 8h.
  double get _goal {
    final goal = widget.profile?.sleepGoalHours;
    if (goal == null || goal <= 0) return 8;
    return goal > 24 ? 24 : goal;
  }

  int? get _totalMinutes {
    final hoursRaw = _hours.text.trim();
    final minutesRaw = _minutes.text.trim();
    if (hoursRaw.isEmpty && minutesRaw.isEmpty) return null;
    return (int.tryParse(hoursRaw) ?? 0) * 60 + (int.tryParse(minutesRaw) ?? 0);
  }

  int? _number(TextEditingController controller) =>
      int.tryParse(controller.text.trim());

  /// Writes the draft. Throws a [FormatException] whose message the sheet shows
  /// when a value is out of range; blank fields are not sent, so they never
  /// overwrite a stored value with null.
  Future<void> save() async {
    final hours = _number(_hours);
    final minutes = _number(_minutes);
    final deep = _number(_deep);

    final hoursFilled = _hours.text.trim().isNotEmpty;
    final minutesFilled = _minutes.text.trim().isNotEmpty;
    var hoursError = hoursFilled && (hours == null || hours < 0 || hours > 24)
        ? 'Nhập số giờ từ 0 đến 24'
        : null;
    final minutesError =
        minutesFilled && (minutes == null || minutes < 0 || minutes > 59)
            ? 'Phút phải nhỏ hơn 60'
            : null;
    final total =
        hoursError == null && minutesError == null && (hoursFilled || minutesFilled)
            ? (hours ?? 0) * 60 + (minutes ?? 0)
            : null;
    if (hoursError == null && total != null && total > 24 * 60) {
      hoursError = 'Thời lượng ngủ không vượt quá 24 giờ';
    }

    String? deepError;
    if (_deep.text.trim().isNotEmpty && (deep == null || deep < 0)) {
      deepError = 'Nhập số phút ngủ sâu hợp lệ';
    } else if (deep != null && total != null && deep > total) {
      deepError = 'Ngủ sâu không được lớn hơn tổng thời lượng ngủ';
    }

    setState(() {
      _hoursError = hoursError;
      _minutesError = minutesError;
      _deepError = deepError;
    });
    if (hoursError != null) throw FormatException(hoursError);
    if (minutesError != null) throw FormatException(minutesError);
    if (deepError != null) throw FormatException(deepError);

    final note = _note.text.trim();
    await ref.read(healthRepositoryProvider).save(
          logDate: widget.date,
          sleepHours: total == null
              ? null
              : double.parse((total / 60).toStringAsFixed(2)),
          sleepBedtime: _bedtime,
          sleepWake: _wake,
          sleepDeepMinutes: deep,
          sleepQuality: _quality,
          sleepNote: note.isEmpty ? null : note,
        );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final total = _totalMinutes;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _hero(context, total),
        const SizedBox(height: MemoirSpace.s5),
        _rhythmTiles(context, total),
        const SizedBox(height: MemoirSpace.s5),
        Text('Chất lượng giấc ngủ', style: theme.textTheme.titleSmall),
        const SizedBox(height: MemoirSpace.s1),
        Text(
          'Chọn trạng thái thực tế nhất để hệ thống cân bằng nhịp sinh học',
          style: theme.textTheme.bodySmall,
        ),
        const SizedBox(height: MemoirSpace.s2),
        _qualityGrid(context),
        const SizedBox(height: MemoirSpace.s5),
        Row(
          children: [
            Expanded(
              child: Text(
                'Ghi chú cảm nhận buổi sáng',
                style: theme.textTheme.titleSmall,
              ),
            ),
            Text('Ghi chép tự do', style: theme.textTheme.labelSmall),
          ],
        ),
        const SizedBox(height: MemoirSpace.s2),
        TextField(
          controller: _note,
          maxLines: 3,
          textInputAction: TextInputAction.newline,
          decoration: const InputDecoration(
            hintText: 'Thức dậy tỉnh táo, cơ thể sảng khoái…',
            alignLabelWithHint: true,
          ),
        ),
      ],
    );
  }

  Widget _hero(BuildContext context, int? totalMinutes) {
    final theme = Theme.of(context);
    final goal = _goal;
    final lower = goal > 1 ? goal - 1 : 0.0;
    final hours = totalMinutes == null ? null : totalMinutes / 60;
    // The design's "Đạt chuẩn" marks the recommended band (goal - 1h … goal),
    // so 7h30m against an 8h goal still counts as a good night.
    final reached = hours != null && hours >= lower;
    final chipLabel = hours == null
        ? 'Chưa có dữ liệu'
        : reached
            ? 'Đạt chuẩn'
            : 'Thiếu ${formatSleepDuration(lower - hours)}';
    final chipTone = hours == null
        ? theme.colorScheme.onSurfaceVariant
        : _tone(context, reached);
    final durationError = _hoursError ?? _minutesError;

    final summary = Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Expanded(
              child: Text(
                'TỔNG THỜI GIAN NGỦ ĐÊM QUA',
                style: theme.textTheme.labelSmall?.copyWith(
                  letterSpacing: 1,
                  color: theme.colorScheme.onSurfaceVariant,
                ),
              ),
            ),
            const SizedBox(width: MemoirSpace.s2),
            _pill(context, chipLabel, chipTone),
          ],
        ),
        const SizedBox(height: MemoirSpace.s1),
        Row(
          crossAxisAlignment: CrossAxisAlignment.baseline,
          textBaseline: TextBaseline.alphabetic,
          children: [
            Text(
              hours == null ? '--' : formatSleepDuration(hours),
              style: theme.textTheme.headlineMedium?.copyWith(
                color: theme.colorScheme.primary,
                fontWeight: FontWeight.w500,
                letterSpacing: -0.5,
              ),
            ),
            if (totalMinutes != null) ...[
              const SizedBox(width: MemoirSpace.s2),
              Text('($totalMinutes phút)', style: theme.textTheme.bodySmall),
            ],
          ],
        ),
        const SizedBox(height: MemoirSpace.s2),
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(
              Icons.check_circle_outline,
              size: 16,
              color: theme.colorScheme.secondary,
            ),
            const SizedBox(width: MemoirSpace.custom6),
            Expanded(
              child: Text.rich(
                TextSpan(
                  children: [
                    const TextSpan(text: 'Mục tiêu đề xuất: '),
                    TextSpan(
                      text: '${_hm(lower)} — ${_hm(goal)}',
                      style: const TextStyle(fontWeight: FontWeight.w600),
                    ),
                    const TextSpan(text: ' mỗi đêm'),
                  ],
                ),
                style: theme.textTheme.labelSmall,
              ),
            ),
          ],
        ),
      ],
    );

    return Container(
      padding: const EdgeInsets.all(MemoirSpace.s5),
      decoration: BoxDecoration(
        color:
            MemoirPalette.of(context).surfaceBrandSubtle.withValues(alpha: 0.45),
        borderRadius: BorderRadius.circular(MemoirRadius.card),
        border: Border.all(
          color: theme.colorScheme.outlineVariant.withValues(alpha: 0.5),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          LayoutBuilder(
            builder: (context, constraints) {
              // `flex-col sm:flex-row` in the design: the stepper sits on the
              // right on the 560 px modal and drops under the summary on a phone.
              if (constraints.maxWidth < 340) {
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    summary,
                    const SizedBox(height: MemoirSpace.s3),
                    _durationBox(context),
                  ],
                );
              }
              return Row(
                children: [
                  Expanded(child: summary),
                  const SizedBox(width: MemoirSpace.s3),
                  _durationBox(context),
                ],
              );
            },
          ),
          if (durationError != null) ...[
            const SizedBox(height: MemoirSpace.s2),
            Text(
              durationError,
              style: theme.textTheme.labelSmall
                  ?.copyWith(color: theme.colorScheme.error),
            ),
          ],
        ],
      ),
    );
  }

  Widget _pill(BuildContext context, String label, Color tone) => Container(
        padding: const EdgeInsets.symmetric(
          horizontal: MemoirSpace.s2,
          vertical: 2,
        ),
        decoration: BoxDecoration(
          color: tone.withValues(alpha: 0.14),
          borderRadius: BorderRadius.circular(MemoirRadius.pill),
        ),
        child: Text(
          label,
          style: Theme.of(context).textTheme.labelSmall?.copyWith(
                color: tone,
                fontWeight: FontWeight.w600,
              ),
        ),
      );

  /// The design's stepper: `7 giờ │ 30 phút` in a bordered white box.
  Widget _durationBox(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: MemoirSpace.s3,
        vertical: MemoirSpace.custom6,
      ),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(MemoirRadius.control),
        border: Border.all(
          color: theme.colorScheme.outlineVariant.withValues(alpha: 0.7),
        ),
        boxShadow: const [
          BoxShadow(
            color: MemoirColorsLight.elevationDropShadow3,
            blurRadius: 8,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          _compactNumber(theme, _hours, 'giờ'),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: MemoirSpace.s2),
            child: Text(
              '│',
              style: theme.textTheme.bodyMedium?.copyWith(
                color: theme.colorScheme.outlineVariant,
              ),
            ),
          ),
          _compactNumber(theme, _minutes, 'phút'),
        ],
      ),
    );
  }

  /// One half of the stepper: a borderless number box and its unit.
  Widget _compactNumber(
    ThemeData theme,
    TextEditingController controller,
    String unit,
  ) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        SizedBox(
          width: 30,
          child: TextField(
            controller: controller,
            keyboardType: TextInputType.number,
            textAlign: TextAlign.center,
            style: theme.textTheme.labelLarge?.copyWith(
              fontWeight: FontWeight.w600,
              color: theme.colorScheme.onSurface,
            ),
            decoration: InputDecoration(
              isDense: true,
              contentPadding:
                  const EdgeInsets.symmetric(vertical: MemoirSpace.custom3),
              border: InputBorder.none,
              hintText: '0',
              hintStyle: theme.textTheme.labelLarge?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
              ),
            ),
          ),
        ),
        const SizedBox(width: MemoirSpace.custom3),
        Text(unit, style: theme.textTheme.bodySmall),
      ],
    );
  }

  /// Green when the night reached the goal, warning amber when it fell short.
  Color _tone(BuildContext context, bool good) {
    final dark = Theme.of(context).brightness == Brightness.dark;
    if (good) {
      return dark
          ? MemoirColorsDark.healthTrendUp
          : MemoirColorsLight.healthTrendUp;
    }
    return dark
        ? MemoirColorsDark.feedbackWarning
        : MemoirColorsLight.feedbackWarning;
  }

  Widget _rhythmTiles(BuildContext context, int? totalMinutes) {
    const gap = MemoirSpace.s3;
    return LayoutBuilder(
      builder: (context, constraints) {
        final columns = constraints.maxWidth < 420 ? 1 : 3;
        final width = (constraints.maxWidth - gap * (columns - 1)) / columns;
        return Wrap(
          spacing: gap,
          runSpacing: gap,
          children: [
            SizedBox(width: width, child: _timeTile(context, bedtime: true)),
            SizedBox(width: width, child: _timeTile(context, bedtime: false)),
            SizedBox(width: width, child: _deepTile(context, totalMinutes)),
          ],
        );
      },
    );
  }

  Widget _tileFrame(
    BuildContext context,
    String label,
    IconData icon,
    Widget child, {
    Color? iconColor,
  }) {
    final theme = Theme.of(context);
    return Container(
      padding: const EdgeInsets.all(MemoirSpace.s3),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(MemoirRadius.card),
        border: Border.all(
          color: theme.colorScheme.outlineVariant.withValues(alpha: 0.6),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(child: Text(label, style: theme.textTheme.labelSmall)),
              Icon(
                icon,
                size: 18,
                color: iconColor ?? theme.colorScheme.outline,
              ),
            ],
          ),
          const SizedBox(height: MemoirSpace.s2),
          child,
        ],
      ),
    );
  }

  Widget _timeTile(BuildContext context, {required bool bedtime}) {
    final theme = Theme.of(context);
    final value = bedtime ? _bedtime : _wake;
    return InkWell(
      borderRadius: BorderRadius.circular(MemoirRadius.card),
      onTap: () => _pickTime(bedtime: bedtime),
      child: _tileFrame(
        context,
        bedtime ? 'Bắt đầu đi ngủ' : 'Giờ thức dậy',
        bedtime ? Icons.bedtime_outlined : Icons.wb_sunny_outlined,
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: Text(
                    value == null ? '--' : _twelveHour(value),
                    style: theme.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                Icon(
                  Icons.schedule,
                  size: 17,
                  color: theme.colorScheme.outline,
                ),
              ],
            ),
            const SizedBox(height: 2),
            Text(
              _timeCaption(value, bedtime: bedtime),
              style: theme.textTheme.labelSmall,
            ),
          ],
        ),
        // The design tints only the sun icon, amber like `text-amber-600/80`.
        iconColor: bedtime ? null : _amber(context),
      ),
    );
  }

  Widget _deepTile(BuildContext context, int? totalMinutes) {
    final theme = Theme.of(context);
    final deep = _number(_deep);
    final percent =
        deep != null && deep > 0 && totalMinutes != null && totalMinutes > 0
            ? (deep / totalMinutes * 100).round().clamp(0, 100)
            : null;
    return _tileFrame(
      context,
      'Ngủ sâu (ước tính)',
      Icons.waves,
      Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          TextField(
            controller: _deep,
            keyboardType: TextInputType.number,
            style: theme.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.w600,
              color: theme.colorScheme.primary,
            ),
            decoration: InputDecoration(
              isDense: true,
              contentPadding: const EdgeInsets.symmetric(vertical: 2),
              border: InputBorder.none,
              hintText: '0',
              hintStyle: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w600,
                color: theme.colorScheme.outlineVariant,
              ),
              suffixText: 'phút',
            ),
          ),
          const SizedBox(height: 2),
          Text(
            _deepError ??
                (percent == null
                    ? 'Chưa đủ dữ liệu'
                    : 'Chiếm $percent% chu kỳ ngủ'),
            style: theme.textTheme.labelSmall?.copyWith(
              color: _deepError == null ? null : theme.colorScheme.error,
            ),
          ),
        ],
      ),
    );
  }

  Widget _qualityGrid(BuildContext context) {
    const gap = MemoirSpace.s3;
    return LayoutBuilder(
      builder: (context, constraints) {
        final columns = constraints.maxWidth < 460 ? 1 : 3;
        final width = (constraints.maxWidth - gap * (columns - 1)) / columns;
        return Wrap(
          spacing: gap,
          runSpacing: gap,
          children: [
            for (final option in _qualityOptions)
              SizedBox(
                width: width,
                child: _QualityCard(
                  option: option,
                  selected: _quality == option.code,
                  onTap: () {
                    setState(() => _quality = option.code);
                    widget.onDirtyChanged(true);
                  },
                ),
              ),
          ],
        );
      },
    );
  }

  Future<void> _pickTime({required bool bedtime}) async {
    final initial = _parseTime(bedtime ? _bedtime : _wake) ??
        (bedtime
            ? const TimeOfDay(hour: 23, minute: 0)
            : const TimeOfDay(hour: 6, minute: 30));
    final picked = await showTimePicker(
      context: context,
      initialTime: initial,
      helpText: bedtime ? 'Bắt đầu đi ngủ' : 'Giờ thức dậy',
    );
    if (picked == null || !mounted) return;
    setState(() {
      if (bedtime) {
        _bedtime = _hhmm(picked);
      } else {
        _wake = _hhmm(picked);
      }
    });
    widget.onDirtyChanged(true);
  }

  /// `23:00` → `TimeOfDay`; anything unparseable falls back to `null`.
  TimeOfDay? _parseTime(String? value) {
    if (value == null) return null;
    final parts = value.split(':');
    if (parts.length != 2) return null;
    final hour = int.tryParse(parts[0]);
    final minute = int.tryParse(parts[1]);
    if (hour == null || minute == null) return null;
    if (hour < 0 || hour > 23 || minute < 0 || minute > 59) return null;
    return TimeOfDay(hour: hour, minute: minute);
  }

  String _hhmm(TimeOfDay value) =>
      '${value.hour.toString().padLeft(2, '0')}:'
      '${value.minute.toString().padLeft(2, '0')}';

  String _timeCaption(String? value, {required bool bedtime}) {
    if (value == null) return 'Chưa ghi nhận';
    final clock = _twelveHour(value);
    final hour = int.tryParse(value.split(':').first) ?? 0;
    if (bedtime) {
      return '$clock ${hour >= 18 || hour < 4 ? 'tối qua' : 'hôm qua'}';
    }
    return '$clock ${hour < 12 ? 'sáng nay' : 'hôm nay'}';
  }

  /// The design's amber sun (`text-amber-600/80`) on the wake tile.
  Color _amber(BuildContext context) {
    final dark = Theme.of(context).brightness == Brightness.dark;
    return dark
        ? MemoirColorsDark.healthMetricPeak
        : MemoirColorsLight.healthMetricPeak;
  }
}

/// `7h 00m` — always both halves, so the recommended range reads as a range.
String _hm(double hours) {
  final total = (hours * 60).round();
  return '${total ~/ 60}h ${(total % 60).toString().padLeft(2, '0')}m';
}

/// `23:00` → `11:00 PM`, the way the design labels the two clock tiles.
String _twelveHour(String value) {
  final parts = value.split(':');
  if (parts.length != 2) return value;
  final hour = int.tryParse(parts[0]);
  final minute = int.tryParse(parts[1]);
  if (hour == null || minute == null) return value;
  final display = hour % 12 == 0 ? 12 : hour % 12;
  return '${display.toString().padLeft(2, '0')}:'
      '${minute.toString().padLeft(2, '0')} '
      '${hour < 12 ? 'AM' : 'PM'}';
}

/// One selectable sleep-quality card: icon + radio on top, label and the
/// design's one-line explanation under it.
class _QualityCard extends StatelessWidget {
  const _QualityCard({
    required this.option,
    required this.selected,
    required this.onTap,
  });

  final _QualityOption option;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final accent = theme.colorScheme.primary;
    return InkWell(
      borderRadius: BorderRadius.circular(MemoirRadius.card),
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(MemoirSpace.s3),
        decoration: BoxDecoration(
          color: selected
              ? MemoirPalette.of(context).surfaceBrandSubtle
              : theme.colorScheme.surface,
          borderRadius: BorderRadius.circular(MemoirRadius.card),
          border: Border.all(
            color: selected
                ? accent
                : theme.colorScheme.outlineVariant.withValues(alpha: 0.6),
            width: selected ? 2 : 1,
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(
                  option.icon,
                  size: 20,
                  color: selected ? accent : theme.colorScheme.onSurfaceVariant,
                ),
                const Spacer(),
                _Radio(selected: selected, accent: accent, theme: theme),
              ],
            ),
            const SizedBox(height: MemoirSpace.s1),
            Text(
              option.label,
              style: theme.textTheme.labelLarge?.copyWith(
                fontWeight: selected ? FontWeight.w700 : FontWeight.w600,
                color: selected ? accent : theme.colorScheme.onSurface,
              ),
            ),
            const SizedBox(height: 2),
            Text(
              option.caption,
              style: theme.textTheme.labelSmall?.copyWith(
                color: selected
                    ? theme.colorScheme.secondary
                    : theme.colorScheme.onSurfaceVariant,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Empty circle, or a filled one with a tick when the option is on.
class _Radio extends StatelessWidget {
  const _Radio({
    required this.selected,
    required this.accent,
    required this.theme,
  });

  final bool selected;
  final Color accent;
  final ThemeData theme;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 16,
      height: 16,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: selected ? accent : Colors.transparent,
        border: Border.all(
          color: selected ? accent : theme.colorScheme.outlineVariant,
        ),
      ),
      child: selected
          ? Icon(Icons.check, size: 12, color: theme.colorScheme.onPrimary)
          : null,
    );
  }
}

