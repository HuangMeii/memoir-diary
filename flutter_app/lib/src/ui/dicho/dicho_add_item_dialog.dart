import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../data/dicho_shopping.dart';
import '../tokens.dart';
import 'dicho_format.dart';

/// What the "Thêm mặt hàng" dialog hands back to the screen.
///
/// The quick-add field only carries a name, so the dialog collects the price,
/// unit and pack size — the three numbers the basket rows print.
class DichoDraftItem {
  const DichoDraftItem({
    required this.name,
    required this.unitPrice,
    required this.unit,
    required this.packNote,
    required this.quantity,
    required this.category,
  });

  final String name;
  final int unitPrice;
  final String unit;
  final String packNote;
  final int quantity;
  final ShoppingCategory category;
}

/// Opens the dialog and resolves with the typed row, or null when cancelled.
Future<DichoDraftItem?> showDichoAddItemDialog(
  BuildContext context, {
  String? initialName,
}) =>
    showDialog<DichoDraftItem>(
      context: context,
      builder: (_) => _DichoAddItemDialog(initialName: initialName),
    );

class _DichoAddItemDialog extends StatefulWidget {
  const _DichoAddItemDialog({this.initialName});

  final String? initialName;

  @override
  State<_DichoAddItemDialog> createState() => _DichoAddItemDialogState();
}

class _DichoAddItemDialogState extends State<_DichoAddItemDialog> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  late final TextEditingController _name =
      TextEditingController(text: widget.initialName ?? '');
  final TextEditingController _price = TextEditingController();
  final TextEditingController _unit = TextEditingController(text: 'hộp');
  final TextEditingController _packNote = TextEditingController();
  final TextEditingController _quantity = TextEditingController(text: '1');
  ShoppingCategory _category = ShoppingCategory.other;

  @override
  void dispose() {
    _name.dispose();
    _price.dispose();
    _unit.dispose();
    _packNote.dispose();
    _quantity.dispose();
    super.dispose();
  }

  void _submit() {
    if (!(_formKey.currentState?.validate() ?? false)) return;
    Navigator.of(context).pop(
      DichoDraftItem(
        name: _name.text.trim(),
        unitPrice: parseVnd(_price.text),
        unit: _unit.text.trim(),
        packNote: _packNote.text.trim(),
        quantity: (int.tryParse(_quantity.text.trim()) ?? 1)
            .clamp(1, DichoNotifier.maxQuantity),
        category: _category,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Thêm mặt hàng'),
      content: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 420),
        child: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextFormField(
                  controller: _name,
                  autofocus: true,
                  textInputAction: TextInputAction.next,
                  decoration: const InputDecoration(
                    labelText: 'Tên mặt hàng',
                    hintText: 'Hành lá, thịt ba chỉ, nước mắm…',
                  ),
                  validator: (value) =>
                      (value ?? '').trim().isEmpty ? 'Nhập tên mặt hàng' : null,
                ),
                const SizedBox(height: MemoirSpace.s3),
                Row(
                  children: [
                    Expanded(
                      child: TextFormField(
                        controller: _price,
                        keyboardType: TextInputType.number,
                        inputFormatters: [
                          FilteringTextInputFormatter.digitsOnly
                        ],
                        decoration: const InputDecoration(
                          labelText: 'Đơn giá (đ)',
                          hintText: '38000',
                        ),
                      ),
                    ),
                    const SizedBox(width: MemoirSpace.s3),
                    SizedBox(
                      width: 96,
                      child: TextFormField(
                        controller: _quantity,
                        keyboardType: TextInputType.number,
                        inputFormatters: [
                          FilteringTextInputFormatter.digitsOnly
                        ],
                        decoration:
                            const InputDecoration(labelText: 'Số lượng'),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: MemoirSpace.s3),
                Row(
                  children: [
                    SizedBox(
                      width: 110,
                      child: TextFormField(
                        controller: _unit,
                        decoration: const InputDecoration(labelText: 'Đơn vị'),
                      ),
                    ),
                    const SizedBox(width: MemoirSpace.s3),
                    Expanded(
                      child: DropdownButtonFormField<ShoppingCategory>(
                        initialValue: _category,
                        decoration:
                            const InputDecoration(labelText: 'Nhóm hàng'),
                        items: [
                          for (final category in ShoppingCategory.values)
                            DropdownMenuItem(
                              value: category,
                              child: Text(category.label),
                            ),
                        ],
                        onChanged: (value) => setState(
                          () => _category = value ?? ShoppingCategory.other,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: MemoirSpace.s3),
                TextFormField(
                  controller: _packNote,
                  decoration: const InputDecoration(
                    labelText: 'Quy cách / ghi chú',
                    hintText: 'Hộp giấy tiệt trùng',
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('Huỷ'),
        ),
        FilledButton(onPressed: _submit, child: const Text('Thêm')),
      ],
    );
  }
}
