import 'package:flutter/material.dart';

import '../home/home_scale.dart';
import '../theme.dart';
import '../tokens.dart';

/// Breadcrumb "Trang chủ / Sức khoẻ & Thể chất" above the health dashboard.
///
/// Follows [NotesBreadcrumb]: tapping "Trang chủ" pops the route by default,
/// because the dashboard is pushed from the home shortcut card.
class HealthBreadcrumb extends StatelessWidget {
  const HealthBreadcrumb({super.key, this.onHome});

  final VoidCallback? onHome;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scale = HomeScale.textOf(context);
    final captionStyle = theme.textTheme.bodySmall?.copyWith(
      fontSize: MemoirType.caption * scale,
    );
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        InkWell(
          onTap: onHome ?? () => Navigator.of(context).maybePop(),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(Icons.arrow_back, size: 16),
              const SizedBox(width: 4),
              Text('Trang chủ', style: captionStyle),
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 6),
          child: Text('/', style: captionStyle),
        ),
        Flexible(
          child: Text(
            'Sức khoẻ & Thể chất',
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: captionStyle?.copyWith(
              color: theme.colorScheme.primary,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ],
    );
  }
}

/// Pill date navigator: ‹ [label] › from the design's sub-header.
///
/// The screen (H3-S8) owns the date; this widget keeps no state of its own so
/// there is never a second source of truth. Tapping the label opens the
/// material date picker and reports the chosen day through [onDatePicked].
class HealthDateNavigator extends StatelessWidget {
  const HealthDateNavigator({
    super.key,
    required this.date,
    required this.onPrevious,
    required this.onNext,
    required this.onDatePicked,
  });

  /// The day currently shown, already normalised by the screen.
  final DateTime date;

  /// Step one day back; called exactly once per tap of the `‹` button.
  final VoidCallback onPrevious;

  /// Step one day forward; called exactly once per tap of the `›` button.
  final VoidCallback onNext;

  /// The user picked another day in the date picker.
  final ValueChanged<DateTime> onDatePicked;

  bool _isToday(DateTime day) {
    final now = DateTime.now();
    return day.year == now.year && day.month == now.month && day.day == now.day;
  }

  String _labelOf(DateTime day) {
    final dd = day.day.toString().padLeft(2, '0');
    final mm = day.month.toString().padLeft(2, '0');
    final yyyy = day.year.toString().padLeft(4, '0');
    return _isToday(day) ? 'Hôm nay, $dd/$mm/$yyyy' : '$dd/$mm/$yyyy';
  }

  Future<void> _pickDate(BuildContext context) async {
    final now = DateTime.now();
    final picked = await showDatePicker(
      context: context,
      initialDate: date.isAfter(now) ? date : now,
      firstDate: DateTime(2020),
      lastDate: date.isAfter(now) ? date : now,
    );
    if (picked != null) onDatePicked(picked);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scale = HomeScale.textOf(context);
    return Container(
      padding: const EdgeInsets.all(MemoirSpace.s1),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(MemoirRadius.pill),
        border: Border.all(color: theme.colorScheme.outlineVariant),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          IconButton(
            visualDensity: VisualDensity.compact,
            padding: EdgeInsets.zero,
            constraints: const BoxConstraints.tightFor(width: 32, height: 32),
            tooltip: 'Ngày hôm trước',
            onPressed: onPrevious,
            icon: const Icon(Icons.chevron_left, size: 18),
          ),
          Flexible(
            child: InkWell(
              onTap: () => _pickDate(context),
              borderRadius: BorderRadius.circular(MemoirRadius.pill),
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: MemoirSpace.s2,
                  vertical: MemoirSpace.s1,
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.calendar_today,
                        size: 16, color: theme.colorScheme.primary),
                    const SizedBox(width: 6),
                    Flexible(
                      child: Text(
                        _labelOf(date),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: theme.textTheme.bodyMedium?.copyWith(
                          fontSize: MemoirType.label * scale,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          IconButton(
            visualDensity: VisualDensity.compact,
            padding: EdgeInsets.zero,
            constraints: const BoxConstraints.tightFor(width: 32, height: 32),
            tooltip: 'Ngày kế tiếp',
            onPressed: onNext,
            icon: const Icon(Icons.chevron_right, size: 18),
          ),
        ],
      ),
    );
  }
}

/// Editorial page header: serif h1, design subtitle, date navigator and the
/// three action buttons (report, body metrics, quick log).
///
/// Narrow screens (<768px) stack vertically with the actions underneath; the
/// filled button spans the column via `SizedBox(width: double.infinity)` —
/// never an infinite `minimumSize` (see the warning in `ui/theme.dart`).
class HealthPageHeader extends StatelessWidget {
  const HealthPageHeader({
    super.key,
    required this.date,
    required this.onPrevious,
    required this.onNext,
    required this.onDatePicked,
    required this.onQuickLog,
    required this.onOpenBodySheet,
  });

  final DateTime date;
  final VoidCallback onPrevious;
  final VoidCallback onNext;
  final ValueChanged<DateTime> onDatePicked;

  /// Opens the quick-log sheet (H4-S1).
  final VoidCallback onQuickLog;

  /// Opens the body-metrics drawer — weight, height and BMI (H3-S7). It is the
  /// only entry point left for those numbers now that the inline quick form is
  /// gone from the dashboard.
  final VoidCallback onOpenBodySheet;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scale = HomeScale.textOf(context);
    final title = Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Sức khoẻ & Thể chất',
          style: theme.textTheme.displaySmall?.copyWith(
            fontFamily: serifFamily,
            fontSize: MemoirType.headingPage * scale,
            color: theme.colorScheme.primary,
          ),
        ),
        const SizedBox(height: MemoirSpace.s1),
        Text(
          'Lắng nghe cơ thể, nuôi dưỡng nhịp sống cân bằng '
          'và chăm sóc bản thân mỗi ngày.',
          style: theme.textTheme.bodyMedium?.copyWith(
            fontSize: MemoirType.body * scale,
            color: theme.colorScheme.onSurfaceVariant,
          ),
        ),
      ],
    );
    final navigator = HealthDateNavigator(
      date: date,
      onPrevious: onPrevious,
      onNext: onNext,
      onDatePicked: onDatePicked,
    );
    // Out of scope for now (README §9): the button only promises a
    // future report instead of pretending to work.
    final exportButton = Tooltip(
      message: 'Sẽ có sau',
      child: OutlinedButton.icon(
        onPressed: null,
        icon: const Icon(Icons.file_download, size: 18),
        label: const Text('Xuất báo cáo'),
      ),
    );
    final bodyButton = Tooltip(
      message: 'Cân nặng · Chiều cao · BMI',
      child: OutlinedButton.icon(
        onPressed: onOpenBodySheet,
        icon: const Icon(Icons.monitor_weight_outlined, size: 18),
        label: const Text('Thông số'),
      ),
    );
    final quickLogButton = FilledButton.icon(
      onPressed: onQuickLog,
      icon: const Icon(Icons.add_circle, size: 18),
      label: const Text('+ Ghi nhận nhanh'),
    );
    return LayoutBuilder(
      builder: (context, constraints) {
        final narrow = constraints.maxWidth < 768;
        if (narrow) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              title,
              const SizedBox(height: MemoirSpace.s4),
              Wrap(
                spacing: MemoirSpace.s3,
                runSpacing: MemoirSpace.s2,
                crossAxisAlignment: WrapCrossAlignment.center,
                children: [navigator, exportButton, bodyButton],
              ),
              const SizedBox(height: MemoirSpace.s2),
              // Full-width only through the parent constraint — never an
              // infinite minimumSize (see `ui/theme.dart`).
              SizedBox(width: double.infinity, child: quickLogButton),
            ],
          );
        }
        return Row(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Expanded(child: title),
            const SizedBox(width: MemoirSpace.s5),
            // A Row hands its non-flex children an *unbounded* main axis, so
            // an unbounded Wrap would never wrap and would crush the title's
            // Expanded to zero width. Cap the actions so they wrap instead.
            ConstrainedBox(
              constraints: BoxConstraints(maxWidth: constraints.maxWidth * 0.6),
              child: Wrap(
                spacing: MemoirSpace.s3,
                runSpacing: MemoirSpace.s2,
                crossAxisAlignment: WrapCrossAlignment.center,
                children: [
                  navigator,
                  exportButton,
                  bodyButton,
                  quickLogButton,
                ],
              ),
            ),
          ],
        );
      },
    );
  }
}

/// Soft context banner under the header ("Nhật ký sức khoẻ cá nhân…").
///
/// The wording is verbatim from the design; [firstName] personalises it and a
/// day other than today swaps "hôm nay" for the actual date.
class HealthContextBanner extends StatelessWidget {
  const HealthContextBanner({super.key, this.firstName, required this.date});

  final String? firstName;
  final DateTime date;

  bool get _isToday {
    final now = DateTime.now();
    return date.year == now.year &&
        date.month == now.month &&
        date.day == now.day;
  }

  String get _sentence {
    final owner = firstName == null ? '' : ' của $firstName';
    final when = _isToday
        ? 'hôm nay'
        : '${date.day.toString().padLeft(2, '0')}/'
            '${date.month.toString().padLeft(2, '0')}/${date.year}';
    return 'Nhật ký sức khoẻ cá nhân$owner $when sẵn sàng để ghi nhận và theo dõi.';
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scale = HomeScale.textOf(context);
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: MemoirSpace.s3,
        vertical: MemoirSpace.s1,
      ),
      decoration: BoxDecoration(
        color: MemoirPalette.of(context).surfaceBrandSubtle,
        borderRadius: BorderRadius.circular(MemoirRadius.page),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(Icons.edit_calendar, size: 15),
          const SizedBox(width: MemoirSpace.s1),
          Flexible(
            child: Text(
              _sentence,
              style: theme.textTheme.bodySmall?.copyWith(
                fontSize: MemoirType.caption * scale,
                color: theme.colorScheme.onSurfaceVariant,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
