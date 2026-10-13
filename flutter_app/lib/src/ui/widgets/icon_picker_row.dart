import 'package:flutter/material.dart';

import '../../data/models.dart';
import '../theme.dart';

/// Narrowest a cell may get before the strip stops trying to fit one row.
const double _kMinCellWidth = 44;

/// Gap between the weather half and the mood half of a single row.
const double _kGroupGap = 18;

/// One tappable icon. Always an `Expanded` so it can sit directly in a `Row`.
///
/// Shared by [IconPickerRow] and [IconPickerStrip] so the two layouts cannot
/// drift apart in behaviour or styling.
class _IconCell extends StatelessWidget {
  const _IconCell({
    required this.item,
    required this.isSelected,
    required this.onTap,
  });

  final LookupItem item;
  final bool isSelected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final color = colorFromHex(item.colorHex);
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 3),
        child: Semantics(
          button: true,
          selected: isSelected,
          label: item.label,
          child: InkWell(
            borderRadius: BorderRadius.circular(14),
            onTap: onTap,
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 150),
              // 48dp tall keeps the tap target comfortable.
              height: 48,
              decoration: BoxDecoration(
                color: isSelected
                    ? color.withValues(alpha: 0.22)
                    : theme.colorScheme.surfaceContainerHighest
                        .withValues(alpha: 0.35),
                borderRadius: BorderRadius.circular(14),
                border: Border.all(
                  color: isSelected ? color : Colors.transparent,
                  width: 2,
                ),
              ),
              alignment: Alignment.center,
              child: Text(item.icon, style: const TextStyle(fontSize: 22)),
            ),
          ),
        ),
      ),
    );
  }
}

/// The name of the selected item, or a prompt when nothing is selected.
///
/// Shown as text so the meaning never depends on colour alone.
String _selectedLabel(List<LookupItem> items, int? selectedId) {
  if (selectedId == null) return 'Chưa chọn';
  for (final item in items) {
    if (item.id == selectedId) return item.label;
  }
  return 'Chưa chọn';
}

TextStyle? _labelStyle(BuildContext context) =>
    Theme.of(context).textTheme.labelLarge?.copyWith(
          color: Theme.of(context).colorScheme.onSurfaceVariant,
          letterSpacing: 1.1,
        );

TextStyle? _captionStyle(BuildContext context) =>
    Theme.of(context).textTheme.bodySmall?.copyWith(
          color: Theme.of(context).colorScheme.onSurfaceVariant,
        );

/// A horizontal row of 5 tappable icons used for mood and weather selection.
///
/// Accessibility: every button carries a semantic label, not just a colour.
class IconPickerRow extends StatelessWidget {
  const IconPickerRow({
    super.key,
    required this.label,
    required this.items,
    required this.selectedId,
    required this.onSelected,
  });

  final String label;
  final List<LookupItem> items;
  final int? selectedId;
  final ValueChanged<int?> onSelected;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: _labelStyle(context)),
        const SizedBox(height: 8),
        Row(
          children: [
            for (final item in items)
              _IconCell(
                item: item,
                isSelected: item.id == selectedId,
                // Tap the selected icon again to clear it.
                onTap: () => onSelected(item.id == selectedId ? null : item.id),
              ),
          ],
        ),
        if (items.isNotEmpty) ...[
          const SizedBox(height: 6),
          Text(_selectedLabel(items, selectedId), style: _captionStyle(context)),
        ],
      ],
    );
  }
}

/// Weather and mood on a single row when there is room for ten cells.
///
/// Two stacked [IconPickerRow]s give each group half the width, which on a wide
/// window wastes space and reads as two unrelated blocks. When the window cannot
/// fit ten comfortable cells - a phone, or a narrow window - it falls back to
/// the two-row layout rather than squeezing the tap targets below 44dp.
class IconPickerStrip extends StatelessWidget {
  const IconPickerStrip({
    super.key,
    required this.weatherLabel,
    required this.weatherItems,
    required this.weatherSelectedId,
    required this.onWeatherSelected,
    required this.moodLabel,
    required this.moodItems,
    required this.moodSelectedId,
    required this.onMoodSelected,
  });

  final String weatherLabel;
  final List<LookupItem> weatherItems;
  final int? weatherSelectedId;
  final ValueChanged<int?> onWeatherSelected;

  final String moodLabel;
  final List<LookupItem> moodItems;
  final int? moodSelectedId;
  final ValueChanged<int?> onMoodSelected;

  @override
  Widget build(BuildContext context) {
    final total = weatherItems.length + moodItems.length;
    return LayoutBuilder(
      builder: (context, constraints) {
        final fitsOneRow =
            total > 0 && (constraints.maxWidth - _kGroupGap) / total >= _kMinCellWidth;
        if (!fitsOneRow) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              IconPickerRow(
                label: weatherLabel,
                items: weatherItems,
                selectedId: weatherSelectedId,
                onSelected: onWeatherSelected,
              ),
              const SizedBox(height: 18),
              IconPickerRow(
                label: moodLabel,
                items: moodItems,
                selectedId: moodSelectedId,
                onSelected: onMoodSelected,
              ),
            ],
          );
        }

        final labelStyle = _labelStyle(context);
        final caption = _captionStyle(context);
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Headers sit over their own half so one row of ten still reads as
            // two labelled groups.
            Row(
              children: [
                Expanded(child: Text(weatherLabel, style: labelStyle)),
                const SizedBox(width: _kGroupGap),
                Expanded(child: Text(moodLabel, style: labelStyle)),
              ],
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                for (final item in weatherItems)
                  _IconCell(
                    item: item,
                    isSelected: item.id == weatherSelectedId,
                    onTap: () => onWeatherSelected(
                      item.id == weatherSelectedId ? null : item.id,
                    ),
                  ),
                const SizedBox(width: _kGroupGap),
                for (final item in moodItems)
                  _IconCell(
                    item: item,
                    isSelected: item.id == moodSelectedId,
                    onTap: () => onMoodSelected(
                      item.id == moodSelectedId ? null : item.id,
                    ),
                  ),
              ],
            ),
            const SizedBox(height: 6),
            Row(
              children: [
                Expanded(
                  child: Text(
                    _selectedLabel(weatherItems, weatherSelectedId),
                    style: caption,
                  ),
                ),
                const SizedBox(width: _kGroupGap),
                Expanded(
                  child: Text(
                    _selectedLabel(moodItems, moodSelectedId),
                    style: caption,
                  ),
                ),
              ],
            ),
          ],
        );
      },
    );
  }
}