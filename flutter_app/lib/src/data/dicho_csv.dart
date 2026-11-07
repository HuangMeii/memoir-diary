/// Local storage format of the shopping baskets.
///
/// Memoir does not keep shopping lists in the database: the whole screen state
/// is written to the device (a CSV document in `shared_preferences`, i.e.
/// `localStorage` on web and the native preferences on mobile/desktop) and read
/// back on the next visit — see [DichoStorage].
///
/// The document is plain CSV with three blocks separated by a blank line, so it
/// stays readable and can be opened by any spreadsheet:
///
/// ```csv
/// # memoir-di-cho v1 — danh sách mua sắm, lưu trên thiết bị
///
/// Danh sách ID,Tên danh sách,Ngân sách (đ),Đang chọn
/// list-week-41,Mua sắm tuần 41,500000,1
///
/// Danh sách ID,Mặt hàng,Quy cách,Nhóm hàng,Đơn vị,Số lượng,Đơn giá (đ),Đã mua
/// list-week-41,Sữa tươi không đường TH True Milk 1 lít,Hộp giấy tiệt trùng,dairy,hộp,2,38000,1
///
/// Hình thức nhận hàng,selfPickup
/// Chuỗi đang chọn,coopmart|winmart|vincom
/// ```
library;

import 'dicho_shopping.dart';

/// First line of the stored document; also tells readers which format they see.
const String dichoStorageHeader =
    '# memoir-di-cho v1 — danh sách mua sắm, lưu trên thiết bị';

/// Column headers of each block, in the order the document writes them.
const List<String> dichoListColumns = [
  'Danh sách ID',
  'Tên danh sách',
  'Ngân sách (đ)',
  'Đang chọn',
];

const List<String> dichoItemColumns = [
  'Danh sách ID',
  'Mặt hàng',
  'Quy cách',
  'Nhóm hàng',
  'Đơn vị',
  'Số lượng',
  'Đơn giá (đ)',
  'Đã mua',
];

/// The whole screen state as the stored CSV document.
String dichoShoppingToCsv(DichoState state) {
  final blocks = <List<List<String>>>[
    [
      dichoListColumns,
      for (final list in state.lists)
        [
          list.id,
          list.name,
          '${list.budget}',
          list.id == state.selectedListId ? '1' : '0',
        ],
    ],
    [
      dichoItemColumns,
      for (final list in state.lists)
        for (final item in list.items)
          [
            list.id,
            item.name,
            item.packNote,
            item.category.name,
            item.unit,
            '${item.quantity}',
            '${item.unitPrice}',
            item.checked ? '1' : '0',
          ],
    ],
    [
      ['Hình thức nhận hàng', state.deliveryMode.name],
      ['Chuỗi đang chọn', state.storeIds.join('|')],
    ],
  ];

  final text = StringBuffer()..writeln(dichoStorageHeader);
  for (final block in blocks) {
    text.writeln();
    for (final row in block) {
      text.writeln(_csvRow(row));
    }
  }
  return text.toString();
}

/// Reads a document written by [dichoShoppingToCsv].
///
/// Answers null when there is nothing usable (empty text, a document from a
/// newer format, no list at all): the caller then keeps the seeded basket
/// instead of wiping the screen with half a state.
DichoState? dichoShoppingFromCsv(String text) {
  // A document without Memoir's marker is not ours: keep the seeded basket
  // rather than guessing at unknown columns.
  if (!text.contains('# memoir-di-cho')) return null;

  final blocks = _splitBlocks(text);
  if (blocks.isEmpty) return null;

  final lists = <String, _ListDraft>{};
  for (final row in blocks[0]) {
    if (row.length < 3) continue;
    final id = row[0].trim();
    if (id.isEmpty) continue;
    lists[id] = _ListDraft(
      id: id,
      name: row[1],
      budget: int.tryParse(row[2].trim()) ?? 0,
      selected: row.length > 3 && row[3].trim() == '1',
    );
  }
  if (lists.isEmpty) return null;

  if (blocks.length > 1) {
    for (final row in blocks[1]) {
      if (row.length < 8) continue;
      final list = lists[row[0].trim()];
      if (list == null) continue;
      list.items.add(
        ShoppingItem(
          id: 'item-${row[0].trim()}-${list.items.length}',
          name: row[1],
          packNote: row[2],
          unit: row[4].trim().isEmpty ? 'món' : row[4].trim(),
          quantity: (int.tryParse(row[5].trim()) ?? 1)
              .clamp(1, DichoNotifier.maxQuantity),
          unitPrice: int.tryParse(row[6].trim()) ?? 0,
          checked: row[7].trim() == '1',
          category: _categoryOf(row[3].trim()),
        ),
      );
    }
  }

  var deliveryMode = ShoppingDeliveryMode.selfPickup;
  var storeIds = {for (final store in dichoStoreChains) store.id};
  if (blocks.length > 2) {
    for (final row in blocks[2]) {
      if (row.length < 2) continue;
      final key = row[0].trim();
      final value = row[1].trim();
      if (key == 'Hình thức nhận hàng') {
        deliveryMode = ShoppingDeliveryMode.values.firstWhere(
          (mode) => mode.name == value,
          orElse: () => ShoppingDeliveryMode.selfPickup,
        );
      } else if (key == 'Chuỗi đang chọn') {
        storeIds = {
          for (final id in value.split('|'))
            if (id.trim().isNotEmpty) id.trim(),
        };
      }
    }
  }

  final selectedId = lists.values
      .firstWhere((draft) => draft.selected, orElse: () => lists.values.first)
      .id;

  return DichoState(
    lists: [for (final draft in lists.values) draft.toList()],
    selectedListId: selectedId,
    deliveryMode: deliveryMode,
    storeIds: storeIds,
  );
}

class _ListDraft {
  _ListDraft({
    required this.id,
    required this.name,
    required this.budget,
    required this.selected,
  });

  final String id;
  final String name;
  final int budget;
  final bool selected;
  final List<ShoppingItem> items = [];

  ShoppingList toList() =>
      ShoppingList(id: id, name: name, budget: budget, items: items);
}

ShoppingCategory _categoryOf(String name) => ShoppingCategory.values.firstWhere(
      (category) => category.name == name,
      orElse: () => ShoppingCategory.other,
    );

/// Splits the document into blocks of rows, dropping the leading comment and
/// the blank lines that separate the blocks. Each block's header row is
/// skipped, so callers only see data.
List<List<List<String>>> _splitBlocks(String text) {
  final blocks = <List<List<String>>>[];
  var current = <List<String>>[];

  void closeBlock() {
    if (current.isEmpty) return;
    blocks.add(current);
    current = <List<String>>[];
  }

  for (final rawLine in text.split(RegExp(r'\r\n|\n|\r'))) {
    final line = rawLine.trimRight();
    if (line.trimLeft().startsWith('#')) continue;
    if (line.trim().isEmpty) {
      closeBlock();
      continue;
    }
    final cells = _splitCsvLine(line);
    if (current.isEmpty && cells.isNotEmpty && cells.first == 'Danh sách ID') {
      continue; // block header
    }
    current.add(cells);
  }
  closeBlock();
  return blocks;
}

/// Minimal RFC-4180 reader: quoted cells, doubled quotes, commas inside them.
List<String> _splitCsvLine(String line) {
  final cells = <String>[];
  final buffer = StringBuffer();
  var quoted = false;

  for (var index = 0; index < line.length; index++) {
    final char = line[index];
    if (quoted) {
      if (char != '"') {
        buffer.write(char);
      } else if (index + 1 < line.length && line[index + 1] == '"') {
        buffer.write('"');
        index++;
      } else {
        quoted = false;
      }
    } else if (char == '"') {
      quoted = true;
    } else if (char == ',') {
      cells.add(buffer.toString());
      buffer.clear();
    } else {
      buffer.write(char);
    }
  }
  cells.add(buffer.toString());
  return cells;
}

String _csvRow(List<String> cells) => cells.map(_csvCell).join(',');

String _csvCell(String value) {
  // Line breaks would break the block structure of the document.
  final flat = value.replaceAll(RegExp(r'[\r\n]+'), ' ');
  if (!flat.contains(',') && !flat.contains('"')) return flat;
  return '"${flat.replaceAll('"', '""')}"';
}
