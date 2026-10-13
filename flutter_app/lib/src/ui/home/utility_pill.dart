import 'package:flutter/material.dart';

import '../icons.dart';
import '../theme.dart';
import '../tokens.dart';
import '../utilities.dart';
import '../widgets/app_footer.dart' show openUtility;
import 'home_scale.dart';

/// One utility affordance, e.g. the "Xem thời tiết" pill.
///
/// It lives in the home header next to the account actions, so it grows with
/// [HomeScale.textOf] (the calmed-down text factor) rather than the layout
/// factor, and it is hidden on phones — there the same utilities stay at the
/// end of the page through `UtilitiesSection`.
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
