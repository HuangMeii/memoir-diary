import 'package:flutter/material.dart';

import '../icons.dart';
import '../theme.dart';
import '../tokens.dart';
import '../utilities.dart';
import 'home_scale.dart';

/// One utility affordance, e.g. the "Xem thời tiết" pill.
///
/// It lives in the app header next to the account actions, so it grows with
/// [HomeScale.textOf] (the calmed-down text factor) rather than the layout
/// factor, and the header is the only place the utilities live: no screen
/// repeats them at the end of the page.
class UtilityPill extends StatelessWidget {
  const UtilityPill({super.key, required this.item});

  final UtilityItem item;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final palette = MemoirPalette.of(context);
    final scale = HomeScale.textOf(context);
    final brand = theme.colorScheme.primary;

    return InkWell(
      borderRadius: BorderRadius.circular(MemoirRadius.pill),
      onTap: () => openUtility(context, item),
      child: Container(
        padding: EdgeInsets.symmetric(
          horizontal: MemoirSpace.s3 * scale,
          vertical: MemoirSpace.custom7 * scale,
        ),
        decoration: BoxDecoration(
          color: palette.surfaceBrandSubtle,
          borderRadius: BorderRadius.circular(MemoirRadius.pill),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (item.iconAsset != null)
              MemoirIcon(item.iconAsset!, size: 18 * scale)
            else
              Icon(item.icon, size: 18 * scale, color: brand),
            SizedBox(width: MemoirSpace.custom6 * scale),
            Text(
              item.shortLabel ?? item.label,
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
