import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../data/dicho_shopping.dart';
import '../theme.dart';
import '../tokens.dart';
import 'dicho_add_item_dialog.dart';
import 'dicho_format.dart';

/// Serif size of the card title; the design's `headline-md` is 22 px.
const double _cardTitleSize = 22;

/// Serif size of the "Tổng dự kiến" amount.
const double _totalSize = 20;

/// "Danh sách cần mua" — the left column of the design.
///
/// Nguồn thiết kế: `ui-figma/dicho/memoir_i_ch_th_ng_minh_y_chu_i_si_u_th`,
/// section "LEFT COLUMN: Card Danh sách cần mua".
class DichoShoppingCard extends StatefulWidget {
  const DichoShoppingCard({
    super.key,
    required this.state,
    required this.notifier,
  });

  final DichoState state;
  final DichoNotifier notifier;

  @override
  State<DichoShoppingCard> createState() => _DichoShoppingCardState();
}

class _DichoShoppingCardState extends State<DichoShoppingCard> {
  final TextEditingController _quickAdd = TextEditingController();

  @override
  void dispose() {
    _quickAdd.dispose();
    super.dispose();
  }

  /// The quick-add field only carries a name; the dialog fills the numbers.
  Future<void> _addItem() async {
    final draft = await showDichoAddItemDialog(
      context,
      initialName: _quickAdd.text,
    );
    if (draft == null) return;
    widget.notifier.addItem(
      name: draft.name,
      unitPrice: draft.unitPrice,
      unit: draft.unit,
      packNote: draft.packNote,
      quantity: draft.quantity,
      category: draft.category,
    );
    _quickAdd.clear();
  }

  Future<void> _editBudget() async {
    final controller = TextEditingController(text: '${widget.state.budget}');
    final value = await showDialog<int>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Ngân sách dự kiến'),
        content: TextField(
          controller: controller,
          autofocus: true,
          keyboardType: TextInputType.number,
          inputFormatters: [FilteringTextInputFormatter.digitsOnly],
          decoration: const InputDecoration(
            labelText: 'Số tiền (đ)',
            hintText: '500000',
          ),
          onSubmitted: (raw) => Navigator.of(context).pop(parseVnd(raw)),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Huỷ'),
          ),
          FilledButton(
            onPressed: () =>
                Navigator.of(context).pop(parseVnd(controller.text)),
            child: const Text('Lưu'),
          ),
        ],
      ),
    );
    controller.dispose();
    if (value != null) widget.notifier.setBudget(value);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final palette = MemoirPalette.of(context);
    final state = widget.state;

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
            _header(context),
            const SizedBox(height: MemoirSpace.s4),
            Divider(height: 1, color: theme.colorScheme.surfaceContainerHigh),
            const SizedBox(height: MemoirSpace.s4),
            _budgetBar(context),
            const SizedBox(height: MemoirSpace.s5),
            _quickAddRow(context),
            const SizedBox(height: MemoirSpace.s4),
            if (state.items.isEmpty)
              _emptyState(context)
            else
              for (final item in state.items)
                Padding(
                  padding: const EdgeInsets.only(bottom: MemoirSpace.custom10),
                  child: DichoItemRow(item: item, notifier: widget.notifier),
                ),
            const SizedBox(height: MemoirSpace.s2),
            _totalBlock(context),
          ],
        ),
      ),
    );
  }

  Widget _header(BuildContext context) {
    final theme = Theme.of(context);
    final state = widget.state;
    final caption = _caption(theme);

    final title = Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Danh sách cần mua',
          style: theme.textTheme.titleLarge?.copyWith(
            fontFamily: serifFamily,
            fontSize: _cardTitleSize,
            color: theme.colorScheme.onSurface,
          ),
        ),
        const SizedBox(height: MemoirSpace.s1),
        Text(
          '${state.itemCount} sản phẩm trong danh sách · '
          'Tạm tính: ${formatVnd(state.subtotal)}',
          style: caption,
        ),
      ],
    );

    final budget = Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Text('Ngân sách dự kiến', style: caption),
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              formatVnd(state.budget),
              style: theme.textTheme.labelLarge?.copyWith(
                color: theme.colorScheme.primary,
                fontSize: MemoirType.label,
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(width: MemoirSpace.s1),
            IconButton(
              onPressed: _editBudget,
              tooltip: 'Sửa ngân sách',
              visualDensity: VisualDensity.compact,
              constraints: const BoxConstraints(minWidth: 28, minHeight: 28),
              padding: EdgeInsets.zero,
              icon: Icon(
                Icons.edit_outlined,
                size: 14,
                color: theme.colorScheme.onSurfaceVariant,
              ),
            ),
          ],
        ),
      ],
    );

    return LayoutBuilder(
      builder: (context, constraints) {
        if (constraints.maxWidth < 480) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              title,
              const SizedBox(height: MemoirSpace.s2),
              budget,
            ],
          );
        }
        return Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(child: title),
            const SizedBox(width: MemoirSpace.s3),
            budget,
          ],
        );
      },
    );
  }

  Widget _budgetBar(BuildContext context) {
    final theme = Theme.of(context);
    final state = widget.state;
    final over = state.overBudget;
    final accent = over ? theme.colorScheme.error : theme.colorScheme.secondary;
    final caption = _caption(theme);

    final label = over
        ? 'Vượt ${formatVnd(-state.remaining)}'
        : 'Còn dư ${formatVnd(state.remaining)} (${_remainingPercent(state)}%)';

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Wrap(
          alignment: WrapAlignment.spaceBetween,
          spacing: MemoirSpace.s3,
          runSpacing: MemoirSpace.s1,
          children: [
            Text(
              'Tiến độ ngân sách: ${formatVnd(state.subtotal)} / '
              '${formatVnd(state.budget)}',
              style: caption,
            ),
            Text(
              label,
              style:
                  caption?.copyWith(color: accent, fontWeight: FontWeight.w600),
            ),
          ],
        ),
        const SizedBox(height: MemoirSpace.s2),
        LayoutBuilder(
          builder: (context, constraints) => Container(
            height: 8,
            decoration: BoxDecoration(
              color: theme.colorScheme.surfaceContainerHigh,
              borderRadius: BorderRadius.circular(MemoirRadius.pill),
            ),
            child: Align(
              alignment: Alignment.centerLeft,
              child: Container(
                width: constraints.maxWidth * state.budgetProgress,
                decoration: BoxDecoration(
                  color: over
                      ? theme.colorScheme.error
                      : theme.colorScheme.primary,
                  borderRadius: BorderRadius.circular(MemoirRadius.pill),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _quickAddRow(BuildContext context) {
    final theme = Theme.of(context);
    final fill = theme.colorScheme.surfaceContainerLow;
    final border = OutlineInputBorder(
      borderRadius: BorderRadius.circular(MemoirRadius.control),
      borderSide: BorderSide(color: theme.colorScheme.outlineVariant),
    );

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: TextField(
            controller: _quickAdd,
            textInputAction: TextInputAction.done,
            onSubmitted: (_) => _addItem(),
            style: theme.textTheme.bodyMedium?.copyWith(
              fontSize: MemoirType.body,
              color: theme.colorScheme.onSurface,
            ),
            decoration: InputDecoration(
              hintText:
                  'Tìm thêm rau củ, thịt, gia vị (vd: Hành lá, Thịt ba chỉ…)',
              hintStyle: theme.textTheme.bodySmall?.copyWith(
                fontSize: MemoirType.body,
                color: theme.colorScheme.onSurfaceVariant,
              ),
              prefixIcon: Icon(
                Icons.search,
                size: 18,
                color: theme.colorScheme.onSurfaceVariant,
              ),
              prefixIconConstraints:
                  const BoxConstraints(minWidth: 38, minHeight: 38),
              isDense: true,
              filled: true,
              fillColor: fill,
              border: border,
              enabledBorder: border,
              focusedBorder: border.copyWith(
                borderSide: BorderSide(color: theme.colorScheme.primary),
              ),
            ),
          ),
        ),
        const SizedBox(width: MemoirSpace.s2),
        FilledButton.icon(
          onPressed: _addItem,
          icon: const Icon(Icons.playlist_add, size: 18),
          label: const Text('Thêm'),
          style: FilledButton.styleFrom(
            backgroundColor: theme.colorScheme.secondary,
            foregroundColor: theme.colorScheme.onSecondary,
            padding: const EdgeInsets.symmetric(
              horizontal: MemoirSpace.s4,
              vertical: MemoirSpace.s3,
            ),
          ),
        ),
      ],
    );
  }

  Widget _emptyState(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      padding: const EdgeInsets.all(MemoirSpace.s5),
      decoration: BoxDecoration(
        color: theme.colorScheme.surfaceContainerLow,
        borderRadius: BorderRadius.circular(MemoirRadius.control),
        border: Border.all(color: theme.colorScheme.outlineVariant),
      ),
      child: Column(
        children: [
          Icon(
            Icons.shopping_basket_outlined,
            size: 28,
            color: theme.colorScheme.outline,
          ),
          const SizedBox(height: MemoirSpace.s2),
          Text(
            'Danh sách đang trống',
            style: theme.textTheme.labelLarge?.copyWith(
              fontSize: MemoirType.label,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: MemoirSpace.s1),
          Text(
            'Gõ tên mặt hàng ở ô phía trên rồi bấm Thêm để bắt đầu.',
            textAlign: TextAlign.center,
            style: _caption(theme),
          ),
        ],
      ),
    );
  }

  Widget _totalBlock(BuildContext context) {
    final theme = Theme.of(context);
    final state = widget.state;

    return Container(
      padding: const EdgeInsets.all(MemoirSpace.s4),
      decoration: BoxDecoration(
        color: theme.colorScheme.surfaceContainerLow,
        borderRadius: BorderRadius.circular(MemoirRadius.control),
        border: Border.all(color: theme.colorScheme.outlineVariant),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // A single row on wide cards, two rows when the pills and the label
          // cannot share the width (phone, or a large accessibility font).
          Wrap(
            alignment: WrapAlignment.spaceBetween,
            crossAxisAlignment: WrapCrossAlignment.center,
            spacing: MemoirSpace.s3,
            runSpacing: MemoirSpace.s2,
            children: [
              Text('Hình thức nhận hàng', style: _caption(theme)),
              Wrap(
                spacing: MemoirSpace.s1,
                runSpacing: MemoirSpace.s1,
                children: [
                  for (final mode in ShoppingDeliveryMode.values)
                    _modePill(context, mode),
                ],
              ),
            ],
          ),
          const SizedBox(height: MemoirSpace.s3),
          _totalRow(context, 'Tạm tính hàng hóa', state.subtotal),
          if (state.deliveryFee > 0) ...[
            const SizedBox(height: MemoirSpace.s1),
            _totalRow(context, 'Phí giao tận nơi', state.deliveryFee),
          ],
          const SizedBox(height: MemoirSpace.s2),
          Divider(height: 1, color: theme.colorScheme.outlineVariant),
          const SizedBox(height: MemoirSpace.s2),
          Wrap(
            alignment: WrapAlignment.spaceBetween,
            crossAxisAlignment: WrapCrossAlignment.center,
            spacing: MemoirSpace.s3,
            runSpacing: MemoirSpace.s1,
            children: [
              Text(
                'Tổng dự kiến',
                style: theme.textTheme.labelLarge?.copyWith(
                  fontSize: MemoirType.label,
                  fontWeight: FontWeight.w700,
                ),
              ),
              Text(
                formatVnd(state.estimatedTotal),
                style: theme.textTheme.titleLarge?.copyWith(
                  fontFamily: serifFamily,
                  fontSize: _totalSize,
                  color: theme.colorScheme.primary,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _totalRow(BuildContext context, String label, int amount) {
    final theme = Theme.of(context);
    return Wrap(
      alignment: WrapAlignment.spaceBetween,
      crossAxisAlignment: WrapCrossAlignment.center,
      spacing: MemoirSpace.s3,
      runSpacing: MemoirSpace.s1,
      children: [
        Text(label, style: _caption(theme)),
        Text(
          formatVnd(amount),
          style: _caption(theme)?.copyWith(
            color: theme.colorScheme.onSurface,
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }

  Widget _modePill(BuildContext context, ShoppingDeliveryMode mode) {
    final theme = Theme.of(context);
    final selected = widget.state.deliveryMode == mode;
    final label = mode == ShoppingDeliveryMode.delivery
        ? '${mode.label} (+${mode.fee ~/ 1000}k)'
        : mode.label;

    return InkWell(
      onTap: () => widget.notifier.setDeliveryMode(mode),
      borderRadius: BorderRadius.circular(MemoirRadius.pill),
      child: Container(
        padding: const EdgeInsets.symmetric(
          horizontal: MemoirSpace.custom10,
          vertical: MemoirSpace.custom5,
        ),
        decoration: BoxDecoration(
          color: selected
              ? theme.colorScheme.primary
              : theme.colorScheme.surfaceContainerLowest,
          borderRadius: BorderRadius.circular(MemoirRadius.pill),
          border: Border.all(
            color: selected
                ? theme.colorScheme.primary
                : theme.colorScheme.outlineVariant,
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              mode == ShoppingDeliveryMode.delivery
                  ? Icons.moped_outlined
                  : Icons.directions_walk,
              size: 13,
              color: selected
                  ? theme.colorScheme.onPrimary
                  : theme.colorScheme.onSurfaceVariant,
            ),
            const SizedBox(width: MemoirSpace.custom5),
            Text(
              label,
              style: _caption(theme)?.copyWith(
                color: selected
                    ? theme.colorScheme.onPrimary
                    : theme.colorScheme.onSurfaceVariant,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }

  int _remainingPercent(DichoState state) {
    if (state.budget <= 0) return 0;
    final share = (state.remaining / state.budget) * 100;
    return share.round().clamp(-999, 100);
  }
}

/// One basket row: tick, category icon, name, stepper, line total and delete.
///
/// Nguồn thiết kế: `ui-figma/dicho/memoir_i_ch_th_ng_minh_y_chu_i_si_u_th`,
/// section "Interactive Grocery Items List".
class DichoItemRow extends StatelessWidget {
  const DichoItemRow({super.key, required this.item, required this.notifier});

  final ShoppingItem item;
  final DichoNotifier notifier;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final palette = MemoirPalette.of(context);
    final done = item.checked;

    final tick = Checkbox(
      value: item.checked,
      onChanged: (_) => notifier.toggleItem(item.id),
      visualDensity: VisualDensity.compact,
      materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
    );

    final icon = Container(
      width: 40,
      height: 40,
      decoration: BoxDecoration(
        color: theme.colorScheme.surfaceContainerLow,
        borderRadius: BorderRadius.circular(MemoirRadius.control),
      ),
      child: Icon(
        dichoCategoryIcon(item.category),
        size: 20,
        color: theme.colorScheme.primary,
      ),
    );

    final info = Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          item.name,
          style: theme.textTheme.bodyMedium?.copyWith(
            fontSize: MemoirType.body,
            fontWeight: FontWeight.w500,
            color: done
                ? theme.colorScheme.onSurfaceVariant
                : theme.colorScheme.onSurface,
            decoration: done ? TextDecoration.lineThrough : null,
          ),
        ),
        const SizedBox(height: 2),
        Text(
          [
            if (item.packNote.isNotEmpty) item.packNote,
            'Đơn giá: ${formatVnd(item.unitPrice)}/${item.unit}',
          ].join(' · '),
          style: _caption(theme),
        ),
      ],
    );

    final trailing = Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        _stepper(theme),
        const SizedBox(width: MemoirSpace.s3),
        SizedBox(
          width: 88,
          child: Text(
            formatVnd(item.lineTotal),
            textAlign: TextAlign.right,
            style: theme.textTheme.labelLarge?.copyWith(
              fontSize: MemoirType.label,
              fontWeight: FontWeight.w600,
              color: done
                  ? theme.colorScheme.onSurfaceVariant
                  : theme.colorScheme.onSurface,
            ),
          ),
        ),
        IconButton(
          onPressed: () => notifier.removeItem(item.id),
          tooltip: 'Xoá ${item.name}',
          visualDensity: VisualDensity.compact,
          constraints: const BoxConstraints(minWidth: 32, minHeight: 32),
          padding: EdgeInsets.zero,
          icon: Icon(
            Icons.delete_outline,
            size: 18,
            color: theme.colorScheme.onSurfaceVariant,
          ),
        ),
      ],
    );

    return Container(
      padding: const EdgeInsets.all(MemoirSpace.s3),
      decoration: BoxDecoration(
        color: palette.surfaceCard,
        borderRadius: BorderRadius.circular(MemoirRadius.control),
        border: Border.all(color: theme.colorScheme.outlineVariant),
      ),
      child: LayoutBuilder(
        builder: (context, constraints) {
          final head = <Widget>[
            tick,
            const SizedBox(width: MemoirSpace.s2),
            icon,
            const SizedBox(width: MemoirSpace.s3),
          ];
          if (constraints.maxWidth < 520) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Row(children: [...head, Expanded(child: info)]),
                const SizedBox(height: MemoirSpace.s2),
                Align(alignment: Alignment.centerRight, child: trailing),
              ],
            );
          }
          return Row(
            children: [
              ...head,
              Expanded(child: info),
              const SizedBox(width: MemoirSpace.s2),
              trailing,
            ],
          );
        },
      ),
    );
  }

  Widget _stepper(ThemeData theme) {
    return Container(
      decoration: BoxDecoration(
        color: theme.colorScheme.surfaceContainerLow,
        borderRadius: BorderRadius.circular(MemoirRadius.control),
        border: Border.all(color: theme.colorScheme.outlineVariant),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          _StepButton(
            icon: Icons.remove,
            tooltip: 'Bớt một ${item.unit}',
            enabled: item.quantity > 1,
            onPressed: () => notifier.changeQuantity(item.id, -1),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: MemoirSpace.s1),
            child: Text(
              '${item.quantity} ${item.unit}',
              style: theme.textTheme.labelLarge?.copyWith(
                fontSize: MemoirType.caption,
                fontWeight: FontWeight.w600,
                color: theme.colorScheme.onSurface,
              ),
            ),
          ),
          _StepButton(
            icon: Icons.add,
            tooltip: 'Thêm một ${item.unit}',
            enabled: item.quantity < DichoNotifier.maxQuantity,
            onPressed: () => notifier.changeQuantity(item.id, 1),
          ),
        ],
      ),
    );
  }
}

/// The tiny +/- inside a row's stepper.
class _StepButton extends StatelessWidget {
  const _StepButton({
    required this.icon,
    required this.tooltip,
    required this.onPressed,
    this.enabled = true,
  });

  final IconData icon;
  final String tooltip;
  final VoidCallback onPressed;
  final bool enabled;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return IconButton(
      onPressed: enabled ? onPressed : null,
      tooltip: tooltip,
      visualDensity: VisualDensity.compact,
      padding: const EdgeInsets.symmetric(horizontal: MemoirSpace.custom5),
      constraints: const BoxConstraints(minWidth: 26, minHeight: 26),
      icon: Icon(
        icon,
        size: 14,
        color: enabled
            ? theme.colorScheme.onSurfaceVariant
            : theme.colorScheme.outlineVariant,
      ),
    );
  }
}

/// The small grey print used across the card.
TextStyle? _caption(ThemeData theme) => theme.textTheme.bodySmall?.copyWith(
      fontSize: MemoirType.caption,
      color: theme.colorScheme.onSurfaceVariant,
    );
