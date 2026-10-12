import 'package:flutter/material.dart';

import '../home/home_scale.dart';
import '../tokens.dart';

/// The `Tuần | Tháng | Năm` segmented control.
///
/// Only "Tháng" has data behind it so far, so the other two render dimmed
/// instead of pretending to switch the view. Shared by the home's "Nhịp viết"
/// card and the `Lưới tháng` hero, which the design draws the same way.
class PeriodControl extends StatelessWidget {
  const PeriodControl({super.key});

  /// The segment that is actually wired up.
  static const String selectedLabel = 'Tháng';

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scale = HomeScale.of(context);

    Widget segment(String label, {required bool selected}) {
      return Container(
        padding: EdgeInsets.symmetric(
          horizontal: MemoirSpace.s3 * scale,
          vertical: MemoirSpace.custom7 * scale,
        ),
        decoration: BoxDecoration(
          color: selected ? theme.colorScheme.surface : Colors.transparent,
          borderRadius: BorderRadius.circular(MemoirRadius.control * scale),
        ),
        child: Text(
          label,
          style: theme.textTheme.bodySmall?.copyWith(
            color: selected
                ? theme.colorScheme.primary
                : theme.colorScheme.onSurfaceVariant.withValues(alpha: 0.5),
            fontSize: MemoirType.body,
            fontWeight: selected ? FontWeight.w600 : FontWeight.w400,
          ),
        ),
      );
    }

    return Tooltip(
      message: 'Chế độ Tuần và Năm sẽ có sau',
      child: Container(
        padding: EdgeInsets.all(3 * scale),
        decoration: BoxDecoration(
          color: theme.colorScheme.surfaceContainerHighest,
          borderRadius:
              BorderRadius.circular(MemoirRadius.control * scale + 3),
          border: Border.all(color: theme.colorScheme.outlineVariant),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            segment('Tuần', selected: false),
            segment('Tháng', selected: true),
            segment('Năm', selected: false),
          ],
        ),
      ),
    );
  }
}
