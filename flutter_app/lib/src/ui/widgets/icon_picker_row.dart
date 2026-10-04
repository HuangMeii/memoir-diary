import 'package:flutter/material.dart';

import '../../data/models.dart';
import '../theme.dart';

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
    final theme = Theme.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: theme.textTheme.labelLarge?.copyWith(
            color: theme.colorScheme.onSurfaceVariant,
            letterSpacing: 1.1,
          ),
        ),
        const SizedBox(height: 8),
        Row(
          children: items.map((item) {
            final isSelected = item.id == selectedId;
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
                    onTap: () => onSelected(
                      isSelected ? null : item.id,
                    ),
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
                          color: isSelected
                              ? color
                              : Colors.transparent,
                          width: 2,
                        ),
                      ),
                      alignment: Alignment.center,
                      child: Text(
                        item.icon,
                        style: const TextStyle(fontSize: 22),
                      ),
                    ),
                  ),
                ),
              ),
            );
          }).toList(),
        ),
        if (items.isNotEmpty) ...[
          const SizedBox(height: 6),
          // Text label alongside colour, so meaning never relies on hue alone.
          Text(
            selectedId == null
                ? 'Chưa chọn'
                : items.firstWhere((i) => i.id == selectedId).label,
            style: theme.textTheme.bodySmall?.copyWith(
              color: theme.colorScheme.onSurfaceVariant,
            ),
          ),
        ],
      ],
    );
  }
}