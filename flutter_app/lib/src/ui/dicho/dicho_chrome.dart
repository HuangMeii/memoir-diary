import 'package:flutter/material.dart';

import '../../data/dicho_shopping.dart';
import '../home/home_scale.dart';
import '../theme.dart';
import '../tokens.dart';

/// Breadcrumb "Trang chủ / Tiện ích / Đi chợ thông minh".
///
/// Nguồn thiết kế: `ui-figma/dicho/memoir_i_ch_th_ng_minh_y_chu_i_si_u_th`,
/// section "BREADCRUMB & HEADER".
class DichoBreadcrumb extends StatelessWidget {
  const DichoBreadcrumb({super.key, this.onHome});

  final VoidCallback? onHome;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final caption = theme.textTheme.bodySmall?.copyWith(
      color: theme.colorScheme.onSurfaceVariant,
      fontSize: MemoirType.caption,
    );

    return Row(
      children: [
        InkWell(
          onTap: onHome ?? () => Navigator.of(context).maybePop(),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(Icons.arrow_back, size: 14),
              const SizedBox(width: 4),
              Text('Trang chủ', style: caption),
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 6),
          child: Text('/',
              style: caption?.copyWith(color: theme.colorScheme.outline)),
        ),
        Text('Tiện ích', style: caption),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 6),
          child: Text('/',
              style: caption?.copyWith(color: theme.colorScheme.outline)),
        ),
        Text(
          'Đi chợ thông minh',
          style: caption?.copyWith(
            color: theme.colorScheme.primary,
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }
}

/// Overline, serif title, subtitle and the basket actions.
///
/// The design also carries a primary "Lưu vào nhật ký" button; it arrives with
/// task DC-08, once the journal can store a basket.
class DichoPageHeader extends StatelessWidget {
  const DichoPageHeader({
    super.key,
    required this.lists,
    required this.selectedListId,
    required this.onSelectList,
    required this.onCreateList,
  });

  final List<ShoppingList> lists;
  final String selectedListId;
  final ValueChanged<String> onSelectList;
  final VoidCallback onCreateList;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final textScale = HomeScale.textOf(context);

    final title = Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'BÁCH HÓA & GIA ĐÌNH',
          style: theme.textTheme.labelSmall?.copyWith(
            color: theme.colorScheme.secondary,
            fontSize: MemoirType.overline,
            letterSpacing: MemoirType.overlineLetterSpacing,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: MemoirSpace.s1),
        Text(
          'Đi chợ thông minh',
          style: theme.textTheme.displaySmall?.copyWith(
            fontFamily: serifFamily,
            fontSize: MemoirType.headingPage * textScale,
            color: theme.colorScheme.onSurface,
          ),
        ),
        const SizedBox(height: MemoirSpace.s1),
        Text(
          'So sánh giá, tìm siêu thị phù hợp và tiết kiệm chi phí mua sắm gia đình.',
          style: theme.textTheme.bodyMedium?.copyWith(
            color: theme.colorScheme.onSurfaceVariant,
            fontSize: MemoirType.body * textScale,
          ),
        ),
      ],
    );

    final actions = Wrap(
      spacing: MemoirSpace.custom10,
      runSpacing: MemoirSpace.s2,
      crossAxisAlignment: WrapCrossAlignment.center,
      children: [
        DichoListSelector(
          lists: lists,
          selectedListId: selectedListId,
          onSelected: onSelectList,
        ),
        OutlinedButton.icon(
          onPressed: onCreateList,
          icon: const Icon(Icons.add, size: 18),
          label: const Text('Danh sách mới'),
        ),
      ],
    );

    return LayoutBuilder(
      builder: (context, constraints) {
        if (constraints.maxWidth < 900) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              title,
              const SizedBox(height: MemoirSpace.s4),
              actions,
            ],
          );
        }
        return Row(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Expanded(child: title),
            const SizedBox(width: MemoirSpace.s4),
            actions,
          ],
        );
      },
    );
  }
}

/// Pill-shaped dropdown that switches the basket being edited.
class DichoListSelector extends StatelessWidget {
  const DichoListSelector({
    super.key,
    required this.lists,
    required this.selectedListId,
    required this.onSelected,
  });

  final List<ShoppingList> lists;
  final String selectedListId;
  final ValueChanged<String> onSelected;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final palette = MemoirPalette.of(context);
    final selected = lists.firstWhere(
      (list) => list.id == selectedListId,
      orElse: () => lists.first,
    );

    return PopupMenuButton<String>(
      tooltip: 'Đổi danh sách',
      onSelected: onSelected,
      itemBuilder: (context) => [
        for (final list in lists)
          PopupMenuItem<String>(
            value: list.id,
            child: Text(
              list.id == selectedListId
                  ? '${list.name} (Đang chọn)'
                  : list.name,
              style: theme.textTheme.bodyMedium?.copyWith(
                fontSize: MemoirType.body,
              ),
            ),
          ),
      ],
      child: Container(
        padding: const EdgeInsets.symmetric(
          horizontal: MemoirSpace.s4,
          vertical: MemoirSpace.s2,
        ),
        decoration: BoxDecoration(
          color: palette.surfaceCard,
          borderRadius: BorderRadius.circular(MemoirRadius.pill),
          border: Border.all(color: theme.colorScheme.outlineVariant),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Flexible(
              child: Text(
                selected.name,
                overflow: TextOverflow.ellipsis,
                style: theme.textTheme.labelLarge?.copyWith(
                  color: theme.colorScheme.onSurface,
                  fontSize: MemoirType.label,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            const SizedBox(width: MemoirSpace.s1),
            Icon(
              Icons.arrow_drop_down,
              size: 18,
              color: theme.colorScheme.onSurfaceVariant,
            ),
          ],
        ),
      ),
    );
  }
}

/// Info banner under the header.
///
/// The design prints "Dữ liệu giá cập nhật tự động lúc 08:30 hôm nay"; Memoir
/// has no price feed yet, so the banner states what the numbers really are —
/// and, since DC-11, that the basket itself is kept on the device.
class DichoNoticeBanner extends StatelessWidget {
  const DichoNoticeBanner({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final text = theme.textTheme.bodySmall?.copyWith(
      color: theme.colorScheme.onSurfaceVariant,
      fontSize: MemoirType.body,
    );

    return Container(
      padding: const EdgeInsets.all(MemoirSpace.s3),
      decoration: BoxDecoration(
        color: theme.colorScheme.surfaceContainerLow,
        borderRadius: BorderRadius.circular(MemoirRadius.control),
        border: Border.all(color: theme.colorScheme.outlineVariant),
      ),
      child: LayoutBuilder(
        builder: (context, constraints) {
          final note = Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Icon(Icons.info_outline,
                  size: 16, color: theme.colorScheme.primary),
              const SizedBox(width: MemoirSpace.s2),
              Flexible(
                child: RichText(
                  text: TextSpan(
                    style: text,
                    children: const [
                      TextSpan(text: 'Danh sách được '),
                      TextSpan(
                        text: 'lưu ngay trên thiết bị này',
                        style: TextStyle(fontWeight: FontWeight.w700),
                      ),
                      TextSpan(
                        text:
                            '. Mức giá là dữ liệu mẫu của Memoir; giá thật sẽ '
                            'đến khi nối được hệ thống niêm yết của các chuỗi '
                            'bán lẻ.',
                      ),
                    ],
                  ),
                ),
              ),
            ],
          );
          final chip = Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 8,
                height: 8,
                decoration: BoxDecoration(
                  color: theme.colorScheme.secondary,
                  shape: BoxShape.circle,
                ),
              ),
              const SizedBox(width: MemoirSpace.s1),
              Text(
                'Lưu trên thiết bị',
                style: text?.copyWith(
                  color: theme.colorScheme.secondary,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          );

          if (constraints.maxWidth < 640) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [note, const SizedBox(height: MemoirSpace.s2), chip],
            );
          }
          return Row(
            children: [
              Expanded(child: note),
              const SizedBox(width: MemoirSpace.s3),
              chip,
            ],
          );
        },
      ),
    );
  }
}
