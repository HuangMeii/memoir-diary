import 'package:flutter/material.dart';

import '../../data/models.dart';
import '../icons.dart';
import '../theme.dart';
import '../tokens.dart';
import 'home_scale.dart';

/// Choice tile width; the design's `Choice` frame is 57×69 and the tokens only
/// carry the height.
const double _choiceWidth = 57;

/// Choice icon size; the design's icon frame is 22×22.
const double _choiceIconSize = 22;

/// Width below which the two quick-choice cards stop sharing a row.
///
/// The design's `Weather and mood row` is 700 wide and holds two 342-wide
/// cards, which keeps every choice tile at its 57 px; narrower than that the
/// mobile frames stack the same two cards, so the breakpoint sits just under
/// 700.
const double kPickerRowBreakpoint = 700;

/// One "quick choice" tile: an icon over its label, sized from the
/// `component.choice.*` tokens.
class ChoiceTile extends StatelessWidget {
  const ChoiceTile({
    super.key,
    required this.item,
    required this.iconName,
    required this.isSelected,
    required this.onTap,
  });

  final LookupItem item;

  /// Figma icon file for this choice, from [weatherIcon] / [moodIcon].
  final String iconName;

  final bool isSelected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final palette = MemoirPalette.of(context);
    final brand = theme.colorScheme.primary;
    final scale = HomeScale.of(context);

    return Semantics(
      button: true,
      selected: isSelected,
      label: item.label,
      child: InkWell(
        borderRadius: BorderRadius.circular(MemoirComponent.choiceRadius * scale),
        onTap: onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 150),
          width: _choiceWidth * scale,
          height: MemoirComponent.choiceHeight * scale,
          padding: EdgeInsets.symmetric(
            vertical: MemoirComponent.choicePadding * scale,
          ),
          decoration: BoxDecoration(
            // Figma's selected `Choice`: a brand-tinted fill (`surface
            // .brand-subtle`) ringed by the brand stroke (`action.primary`,
            // 1.5 px). The unselected tile keeps a neutral fill and a hairline
            // so the selected one clearly stands out.
            color: isSelected
                ? palette.surfaceBrandSubtle
                : theme.colorScheme.surfaceContainerHighest,
            borderRadius:
                BorderRadius.circular(MemoirComponent.choiceRadius * scale),
            border: Border.all(
              color: isSelected ? brand : theme.colorScheme.outlineVariant,
              width: MemoirStroke.weather1p5 * scale,
            ),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              MemoirIcon(
                iconName,
                size: _choiceIconSize * scale,
                color: isSelected ? brand : null,
              ),
              SizedBox(height: MemoirSpace.s1 * scale),
              Text(
                item.label,
                maxLines: 2,
                textAlign: TextAlign.center,
                overflow: TextOverflow.ellipsis,
                style: theme.textTheme.bodySmall?.copyWith(
                  color: isSelected
                      ? theme.colorScheme.onSurface
                      : theme.colorScheme.onSurfaceVariant,
                  fontSize: MemoirType.caption,
                  // Two-line labels (Bình thường, Rất buồn) still have to fit the
                  // 69 px tile, so the label uses the caption line height from
                  // the design instead of the theme's roomier default.
                  height: MemoirType.captionLineHeight / MemoirType.caption,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// A Home picker card: heading, status line, the five quick choices and the
/// save hint, as designed for "HOME-01 · Thời tiết/Cảm xúc hôm nay".
class PickerCard extends StatelessWidget {
  const PickerCard({
    super.key,
    required this.title,
    required this.items,
    required this.iconName,
    required this.selectedId,
    required this.onSelected,
  });

  final String title;
  final List<LookupItem> items;

  /// Resolves a choice to its Figma icon file.
  final String Function(LookupItem item) iconName;

  final int? selectedId;
  final ValueChanged<int?> onSelected;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scale = HomeScale.of(context);

    // The card carries the chosen label and a tick once a value is set; before
    // that it reads as an invitation instead.
    LookupItem? selected;
    for (final item in items) {
      if (item.id == selectedId) {
        selected = item;
        break;
      }
    }

    return Card(
      child: Padding(
        padding: EdgeInsets.all(MemoirSpace.s4 * scale),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: Text(
                    title,
                    style: theme.textTheme.labelLarge?.copyWith(
                      color: theme.colorScheme.onSurface,
                      fontSize: MemoirType.label,
                    ),
                  ),
                ),
                // TODO(design): replace with the Figma `check` SVG once it is
                // exported into assets/icons (only `circle-check` exists today).
                if (selected != null)
                  Icon(Icons.check, size: 15, color: theme.colorScheme.primary),
              ],
            ),
            SizedBox(height: MemoirSpace.s1 * scale),
            Text(
              selected == null
                  ? 'Chọn điều gần với bạn nhất'
                  : selected.label,
              style: theme.textTheme.bodySmall?.copyWith(
                color: selected == null
                    ? theme.colorScheme.onSurfaceVariant
                    : theme.colorScheme.primary,
                fontSize: MemoirType.caption,
              ),
            ),
            SizedBox(height: MemoirSpace.s3 * scale),
            Row(
              children: [
                for (final item in items) ...[
                  Expanded(
                    child: ChoiceTile(
                      item: item,
                      iconName: iconName(item),
                      isSelected: item.id == selectedId,
                      // Tapping the selected tile clears it.
                      onTap: () => onSelected(
                        item.id == selectedId ? null : item.id,
                      ),
                    ),
                  ),
                  if (item != items.last)
                    SizedBox(width: MemoirComponent.choiceGap * scale),
                ],
              ],
            ),
            SizedBox(height: MemoirSpace.s2 * scale),
            Text(
              'Chạm để chọn · Tự động lưu',
              style: theme.textTheme.bodySmall?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
                fontSize: MemoirType.caption,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// The design's `Weather and mood row`: the weather and the mood picker card
/// on a single line when the viewport is wide enough for both, stacked when it
/// is not (the mobile frames show the same two cards one above the other).
///
/// Only the forecast moved to the utilities ("Tiện ích" → Thời tiết); the
/// quick pick belongs to today's overview and stays here.
class WeatherMoodRow extends StatelessWidget {
  const WeatherMoodRow({
    super.key,
    required this.weather,
    required this.mood,
  });

  /// The "Thời tiết hôm nay" card, or its loading/error stand-in.
  final Widget weather;

  /// The "Cảm xúc hôm nay" card, or its loading/error stand-in.
  final Widget mood;

  @override
  Widget build(BuildContext context) {
    final scale = HomeScale.of(context);

    return LayoutBuilder(
      builder: (context, constraints) {
        // One pixel of slack, as in [DashboardColumns]: the breakpoint is a
        // scaled number too.
        if (constraints.maxWidth + 1 < kPickerRowBreakpoint * scale) {
          return Column(
            children: [
              weather,
              SizedBox(height: MemoirSpace.s3 * scale),
              mood,
            ],
          );
        }

        // IntrinsicHeight keeps the two cards the same height even though one
        // of them may carry a longer status line than the other.
        return IntrinsicHeight(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Expanded(child: weather),
              SizedBox(width: MemoirSpace.s4 * scale),
              Expanded(child: mood),
            ],
          ),
        );
      },
    );
  }
}
