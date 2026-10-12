import 'package:flutter/material.dart';

import '../icons.dart';
import '../theme.dart';
import '../tokens.dart';
import '../utilities.dart';
import '../widgets/app_footer.dart' show openUtility;

/// Height of the web utility bar, matching Figma `Utility navigation` (58 px).
const double kUtilityNavHeight = 58;

/// The top bar of the web layout: the "Tiện ích" label on the left and the
/// utility actions ("Xem thời tiết") on the right.
///
/// This is what the design puts above the app bar; on phones the same utilities
/// stay at the end of the page through [UtilitiesSection].
class UtilityNavigation extends StatelessWidget {
  const UtilityNavigation({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final palette = MemoirPalette.of(context);

    return Container(
      height: kUtilityNavHeight,
      padding: const EdgeInsets.symmetric(horizontal: MemoirSpace.s5),
      decoration: BoxDecoration(
        color: palette.surfaceCard,
        border: Border(bottom: BorderSide(color: palette.borderDefault)),
      ),
      child: Row(
        children: [
          Container(
            width: 28,
            height: 28,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: palette.surfaceBrandSubtle,
              borderRadius: BorderRadius.circular(MemoirRadius.control),
            ),
            child: const MemoirIcon('weather', size: 18),
          ),
          const SizedBox(width: MemoirSpace.s2),
          Text(
            'Tiện ích',
            style: theme.textTheme.bodyMedium?.copyWith(
              color: theme.colorScheme.onSurface,
              fontSize: MemoirType.body,
            ),
          ),
          const Spacer(),
          for (final item in utilityItems) _UtilityPill(item: item),
        ],
      ),
    );
  }
}

/// One utility affordance, e.g. the "Xem thời tiết" pill.
class _UtilityPill extends StatelessWidget {
  const _UtilityPill({required this.item});

  final UtilityItem item;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final palette = MemoirPalette.of(context);
    final brand = theme.colorScheme.primary;

    return InkWell(
      borderRadius: BorderRadius.circular(MemoirRadius.pill),
      onTap: () => openUtility(context, item),
      child: Container(
        padding: const EdgeInsets.symmetric(
          horizontal: MemoirSpace.s3,
          vertical: MemoirSpace.custom7,
        ),
        decoration: BoxDecoration(
          color: palette.surfaceBrandSubtle,
          borderRadius: BorderRadius.circular(MemoirRadius.pill),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (item.iconAsset != null)
              MemoirIcon(item.iconAsset!, size: 18)
            else
              Icon(item.icon, size: 18, color: brand),
            const SizedBox(width: MemoirSpace.custom6),
            Text(
              item.label,
              style: theme.textTheme.bodySmall?.copyWith(
                color: brand,
                fontSize: MemoirType.body,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
