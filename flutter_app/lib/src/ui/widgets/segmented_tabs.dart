import 'package:flutter/material.dart';

import '../tokens.dart';

/// One option of a [SegmentedTabs] row: its value and the label on screen.
class SegmentedTab<T> {
  const SegmentedTab(this.value, this.label);

  final T value;
  final String label;
}

/// The segmented control the Figma frames draw for period switching.
///
/// A raised row where the selected option sits on the page surface and the
/// others read as plain labels. Shared by the weather's `Tuần | Ngày | Theo
/// giờ` switcher and the calendar's `Ngày | Tuần | Tháng` one, which the design
/// draws the same way.
class SegmentedTabs<T> extends StatelessWidget {
  const SegmentedTabs({
    super.key,
    required this.options,
    required this.selected,
    required this.onChanged,
    this.scale = 1,
  });

  final List<SegmentedTab<T>> options;

  /// The option currently on.
  final T selected;

  final ValueChanged<T> onChanged;

  /// Layout zoom of the surrounding screen; 1 renders the frame 1:1.
  final double scale;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      padding: EdgeInsets.all(3 * scale),
      decoration: BoxDecoration(
        color: theme.colorScheme.surfaceContainerHighest,
        borderRadius: BorderRadius.circular(MemoirRadius.control * scale + 3),
        border: Border.all(color: theme.colorScheme.outlineVariant),
      ),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            for (final option in options) _option(context, option),
          ],
        ),
      ),
    );
  }

  Widget _option(BuildContext context, SegmentedTab<T> option) {
    final theme = Theme.of(context);
    final isSelected = option.value == selected;

    return Semantics(
      selected: isSelected,
      button: !isSelected,
      child: InkWell(
        borderRadius: BorderRadius.circular(MemoirRadius.control * scale),
        onTap: isSelected ? null : () => onChanged(option.value),
        child: Container(
          padding: EdgeInsets.symmetric(
            horizontal: MemoirSpace.s4 * scale,
            vertical: MemoirSpace.custom7 * scale,
          ),
          decoration: BoxDecoration(
            color: isSelected ? theme.colorScheme.surface : Colors.transparent,
            borderRadius: BorderRadius.circular(MemoirRadius.control * scale),
          ),
          child: Text(
            option.label,
            style: theme.textTheme.labelLarge?.copyWith(
              color: isSelected
                  ? theme.colorScheme.primary
                  : theme.colorScheme.onSurfaceVariant,
              fontSize: MemoirType.label,
              fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
            ),
          ),
        ),
      ),
    );
  }
}
