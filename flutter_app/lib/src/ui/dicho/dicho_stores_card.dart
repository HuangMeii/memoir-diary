import 'package:flutter/material.dart';

import '../../data/dicho_shopping.dart';
import '../theme.dart';
import '../tokens.dart';
import 'dicho_format.dart';

/// "Vị trí & Siêu thị" — the right column of the design.
///
/// Nguồn thiết kế: `ui-figma/dicho/memoir_i_ch_th_ng_minh_y_chu_i_si_u_th`,
/// section "RIGHT COLUMN: Card Chọn siêu thị & Vị trí". The map snippet and
/// the price comparison behind the ticked chains arrive with tasks DC-05 and
/// DC-06.
class DichoStoresCard extends StatelessWidget {
  const DichoStoresCard({
    super.key,
    required this.state,
    required this.notifier,
  });

  final DichoState state;
  final DichoNotifier notifier;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final palette = MemoirPalette.of(context);
    final selectedCount = state.storeIds.length;
    final allSelected = selectedCount == dichoStoreChains.length;

    return Card(
      margin: EdgeInsets.zero,
      elevation: 0,
      color: palette.surfaceCard,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(MemoirRadius.card),
        side: BorderSide(color: theme.colorScheme.outlineVariant),
      ),
      child: Padding(
        padding: const EdgeInsets.all(MemoirSpace.s6),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Row(
              children: [
                Expanded(
                  child: Text(
                    'Vị trí & Siêu thị',
                    style: theme.textTheme.titleLarge?.copyWith(
                      fontFamily: serifFamily,
                      fontSize: 22,
                      color: theme.colorScheme.onSurface,
                    ),
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: MemoirSpace.s2,
                    vertical: 2,
                  ),
                  decoration: BoxDecoration(
                    color: palette.surfaceBrandSubtle,
                    borderRadius: BorderRadius.circular(MemoirRadius.pill),
                  ),
                  child: Text(
                    'Bán kính 3 km',
                    style: theme.textTheme.labelSmall?.copyWith(
                      color: theme.colorScheme.secondary,
                      fontSize: MemoirType.caption,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: MemoirSpace.s5),
            Row(
              children: [
                Expanded(
                  child: Text(
                    'Chuỗi siêu thị & TTTM so sánh ($selectedCount chuỗi đang chọn)',
                    style: theme.textTheme.bodySmall?.copyWith(
                      fontSize: MemoirType.caption,
                      fontWeight: FontWeight.w600,
                      color: theme.colorScheme.onSurfaceVariant,
                    ),
                  ),
                ),
                TextButton(
                  onPressed: () => notifier.selectAllStores(!allSelected),
                  child: Text(allSelected ? 'Bỏ chọn' : 'Chọn tất cả'),
                ),
              ],
            ),
            const SizedBox(height: MemoirSpace.s2),
            LayoutBuilder(
              builder: (context, constraints) {
                final twoColumns = constraints.maxWidth >= 420;
                final width = twoColumns
                    ? (constraints.maxWidth - MemoirSpace.s2) / 2
                    : constraints.maxWidth;
                return Wrap(
                  spacing: MemoirSpace.s2,
                  runSpacing: MemoirSpace.s2,
                  children: [
                    for (final store in dichoStoreChains)
                      DichoStoreTile(
                        store: store,
                        width: width,
                        selected: state.storeIds.contains(store.id),
                        onToggle: () => notifier.toggleStore(store.id),
                      ),
                  ],
                );
              },
            ),
            const SizedBox(height: MemoirSpace.s5),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Icon(
                  Icons.near_me_outlined,
                  size: 14,
                  color: theme.colorScheme.secondary,
                ),
                const SizedBox(width: MemoirSpace.s1),
                Expanded(
                  child: Text(
                    'Khoảng cách và thời gian đi tính từ vị trí đã lưu của bạn. '
                    'Các chuỗi được chọn sẽ là nguồn so sánh giá ở bước tiếp theo.',
                    style: theme.textTheme.bodySmall?.copyWith(
                      fontSize: MemoirType.caption,
                      color: theme.colorScheme.onSurfaceVariant,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

/// One chain of the grid: tick, name, distance and travel time.
class DichoStoreTile extends StatelessWidget {
  const DichoStoreTile({
    super.key,
    required this.store,
    required this.selected,
    required this.onToggle,
    this.width,
  });

  final StoreChain store;
  final bool selected;
  final VoidCallback onToggle;

  /// Fixed width set by the two-column grid; null lets the tile size itself.
  final double? width;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final palette = MemoirPalette.of(context);

    final tile = Semantics(
      checked: selected,
      child: InkWell(
        onTap: onToggle,
        borderRadius: BorderRadius.circular(MemoirRadius.control),
        child: Container(
          padding: const EdgeInsets.symmetric(
            horizontal: MemoirSpace.s2,
            vertical: MemoirSpace.s2,
          ),
          decoration: BoxDecoration(
            color: selected
                ? theme.colorScheme.secondaryContainer.withValues(alpha: 0.35)
                : palette.surfaceCard,
            borderRadius: BorderRadius.circular(MemoirRadius.control),
            border: Border.all(
              color: selected
                  ? theme.colorScheme.secondary
                  : theme.colorScheme.outlineVariant,
            ),
          ),
          child: Row(
            children: [
              Checkbox(
                value: selected,
                onChanged: (_) => onToggle(),
                visualDensity: VisualDensity.compact,
                materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
              ),
              const SizedBox(width: MemoirSpace.s1),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      store.name,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: theme.textTheme.labelLarge?.copyWith(
                        fontSize: MemoirType.caption,
                        fontWeight: FontWeight.w600,
                        color: theme.colorScheme.onSurface,
                      ),
                    ),
                    Text(
                      '${formatDistance(store.distanceKm)} · '
                      '${formatMinutes(store.minutes)}',
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: theme.textTheme.bodySmall?.copyWith(
                        fontSize: MemoirType.caption,
                        color: theme.colorScheme.onSurfaceVariant,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );

    return width == null ? tile : SizedBox(width: width, child: tile);
  }
}
