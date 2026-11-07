/// Local state behind the "Đi chợ thông minh" screen.
///
/// Nguồn thiết kế: `ui-figma/dicho/memoir_i_ch_th_ng_minh_y_chu_i_si_u_th`
/// (section "Danh sách cần mua" + "Vị trí & Siêu thị").
///
/// The basket is not stored in the database: `dicho_storage.dart` keeps it on
/// the device as a CSV document and restores it on the next visit. Widgets only
/// read [DichoState] and call [DichoNotifier].
library;

import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Bucket an item belongs to; the widgets map it to an icon.
///
/// The label lives here (not in the widgets) so the CSV export can print the
/// same wording without importing the UI layer.
enum ShoppingCategory {
  dairy('Sữa & đồ uống'),
  eggs('Trứng'),
  grain('Gạo & ngũ cốc'),
  vegetable('Rau củ'),
  oil('Dầu & gia vị'),
  other('Khác');

  const ShoppingCategory(this.label);

  /// Vietnamese name shown in the add-item dialog and the CSV export.
  final String label;
}

/// How the basket is collected.
///
/// The surcharge is the design's "Giao tận nơi (+15k)" option.
enum ShoppingDeliveryMode {
  selfPickup('Tự đi mua', 0),
  delivery('Giao tận nơi', 15000);

  const ShoppingDeliveryMode(this.label, this.fee);

  /// Vietnamese wording for the segmented control.
  final String label;

  /// Surcharge added to the basket total, in VND.
  final int fee;
}

/// One row of a shopping list.
class ShoppingItem {
  const ShoppingItem({
    required this.id,
    required this.name,
    required this.packNote,
    required this.unitPrice,
    required this.unit,
    this.quantity = 1,
    this.checked = false,
    this.category = ShoppingCategory.other,
  });

  final String id;
  final String name;

  /// Packaging hint under the name, e.g. "Hộp giấy tiệt trùng".
  final String packNote;

  /// Price of one [unit], in VND.
  final int unitPrice;

  /// Unit shown inside the stepper, e.g. "hộp", "vỉ", "túi".
  final String unit;

  final int quantity;

  /// Whether the shopper already dropped it in the trolley.
  final bool checked;

  final ShoppingCategory category;

  /// Price × quantity — what the row contributes to the basket.
  int get lineTotal => unitPrice * quantity;

  ShoppingItem copyWith({
    String? name,
    String? packNote,
    int? unitPrice,
    String? unit,
    int? quantity,
    bool? checked,
    ShoppingCategory? category,
  }) =>
      ShoppingItem(
        id: id,
        name: name ?? this.name,
        packNote: packNote ?? this.packNote,
        unitPrice: unitPrice ?? this.unitPrice,
        unit: unit ?? this.unit,
        quantity: quantity ?? this.quantity,
        checked: checked ?? this.checked,
        category: category ?? this.category,
      );
}

/// A supermarket chain the basket can be priced against.
class StoreChain {
  const StoreChain({
    required this.id,
    required this.name,
    required this.distanceKm,
    required this.minutes,
  });

  final String id;
  final String name;

  /// Distance from the saved location, in kilometres.
  final double distanceKm;

  /// Rough travel time with the design's motorbike assumption.
  final int minutes;
}

/// The eight chains of the design, distances included.
const List<StoreChain> dichoStoreChains = [
  StoreChain(id: 'coopmart', name: 'Co.opmart', distanceKm: 1.8, minutes: 8),
  StoreChain(
      id: 'winmart', name: 'WinMart / WinMart+', distanceKm: 0.45, minutes: 3),
  StoreChain(
      id: 'emart', name: 'Emart (Sala / GV)', distanceKm: 3.8, minutes: 12),
  StoreChain(
      id: 'vincom',
      name: 'Vincom Plaza (WinMart)',
      distanceKm: 0.8,
      minutes: 4),
  StoreChain(
      id: 'aeon', name: 'AEON Mall / MaxValu', distanceKm: 5.2, minutes: 16),
  StoreChain(id: 'lotte', name: 'Lotte Mart', distanceKm: 4.5, minutes: 15),
  StoreChain(id: 'go', name: 'GO! / Big C', distanceKm: 3.2, minutes: 14),
  StoreChain(
      id: 'bachhoaxanh', name: 'Bách Hóa Xanh', distanceKm: 1.2, minutes: 6),
];

/// One named basket ("Mua sắm tuần 41") with its own budget and items.
class ShoppingList {
  const ShoppingList({
    required this.id,
    required this.name,
    required this.budget,
    this.items = const [],
  });

  final String id;
  final String name;

  /// Planned spend for this basket, in VND.
  final int budget;

  final List<ShoppingItem> items;

  /// Sum of every row, checked or not.
  int get subtotal => items.fold(0, (sum, item) => sum + item.lineTotal);

  int get checkedCount => items.where((item) => item.checked).length;

  ShoppingList copyWith(
          {String? name, int? budget, List<ShoppingItem>? items}) =>
      ShoppingList(
        id: id,
        name: name ?? this.name,
        budget: budget ?? this.budget,
        items: items ?? this.items,
      );
}

/// Everything the "Đi chợ thông minh" screen renders.
class DichoState {
  const DichoState({
    required this.lists,
    required this.selectedListId,
    required this.deliveryMode,
    required this.storeIds,
  });

  /// The design's first-load state: one basket of five items, 500.000 đ of
  /// budget and every chain ticked.
  factory DichoState.seeded() => DichoState(
        lists: [
          const ShoppingList(
            id: 'list-week-41',
            name: 'Mua sắm tuần 41',
            budget: 500000,
            items: [
              ShoppingItem(
                id: 'item-milk',
                name: 'Sữa tươi không đường TH True Milk 1 lít',
                packNote: 'Hộp giấy tiệt trùng',
                unitPrice: 38000,
                unit: 'hộp',
                quantity: 2,
                checked: true,
                category: ShoppingCategory.dairy,
              ),
              ShoppingItem(
                id: 'item-eggs',
                name: 'Trứng gà ta Ba Huân',
                packNote: 'Hộp 10 quả kiểm dịch',
                unitPrice: 32000,
                unit: 'vỉ',
                checked: true,
                category: ShoppingCategory.eggs,
              ),
              ShoppingItem(
                id: 'item-rice',
                name: 'Gạo thơm thượng hạng ST25',
                packNote: 'Túi 5 kg hút chân không',
                unitPrice: 175000,
                unit: 'túi',
                checked: true,
                category: ShoppingCategory.grain,
              ),
              ShoppingItem(
                id: 'item-greens',
                name: 'Rau cải ngọt VietGAP',
                packNote: 'Gói sơ chế 500 g',
                unitPrice: 18000,
                unit: 'gói',
                checked: true,
                category: ShoppingCategory.vegetable,
              ),
              ShoppingItem(
                id: 'item-oil',
                name: 'Dầu ăn Tường An Cooking Oil',
                packNote: 'Chai 1 lít dinh dưỡng',
                unitPrice: 52000,
                unit: 'chai',
                checked: true,
                category: ShoppingCategory.oil,
              ),
            ],
          ),
          const ShoppingList(
            id: 'list-family-party',
            name: 'Tiệc cuối tuần gia đình',
            budget: 800000,
          ),
          const ShoppingList(
            id: 'list-dry-goods',
            name: 'Đồ khô dự trữ tháng 10',
            budget: 400000,
          ),
          const ShoppingList(
            id: 'list-light-menu',
            name: 'Thực đơn thanh đạm 7 ngày',
            budget: 350000,
          ),
        ],
        selectedListId: 'list-week-41',
        deliveryMode: ShoppingDeliveryMode.selfPickup,
        storeIds: {for (final store in dichoStoreChains) store.id},
      );

  final List<ShoppingList> lists;

  /// Id of the basket the screen is editing.
  final String selectedListId;

  final ShoppingDeliveryMode deliveryMode;

  /// Chains ticked in "Chuỗi siêu thị & TTTM so sánh".
  final Set<String> storeIds;

  /// The basket being edited. Falls back to the first list so a stale id can
  /// never crash a rebuild.
  ShoppingList get list => lists.firstWhere(
        (item) => item.id == selectedListId,
        orElse: () => lists.first,
      );

  List<ShoppingItem> get items => list.items;

  int get itemCount => items.length;

  int get checkedCount => list.checkedCount;

  /// Goods only, before delivery.
  int get subtotal => list.subtotal;

  /// Delivery surcharge of the chosen [deliveryMode].
  int get deliveryFee => deliveryMode.fee;

  /// What the shopper should expect to pay.
  int get estimatedTotal => subtotal + deliveryFee;

  int get budget => list.budget;

  /// Budget left after the goods; negative when the basket busts it.
  int get remaining => budget - subtotal;

  bool get overBudget => remaining < 0;

  /// Share of the budget already used, 0…1 — the width of the progress bar.
  double get budgetProgress =>
      budget <= 0 ? 0 : (subtotal / budget).clamp(0.0, 1.0);

  DichoState copyWith({
    List<ShoppingList>? lists,
    String? selectedListId,
    ShoppingDeliveryMode? deliveryMode,
    Set<String>? storeIds,
  }) =>
      DichoState(
        lists: lists ?? this.lists,
        selectedListId: selectedListId ?? this.selectedListId,
        deliveryMode: deliveryMode ?? this.deliveryMode,
        storeIds: storeIds ?? this.storeIds,
      );
}

/// Mutations the screen is allowed to make on [DichoState].
///
/// The notifier owns no storage: `DichoSync` in `dicho_storage.dart` restores
/// the saved basket and writes every change to the device.
class DichoNotifier extends StateNotifier<DichoState> {
  DichoNotifier({DichoState? initial, this.onChanged})
      : super(initial ?? DichoState.seeded());

  /// Called after every user edit, never for [restore]: `DichoSync` listens
  /// here to write the basket back to the device.
  final void Function(DichoState state)? onChanged;

  /// Upper bound of one row, so a stuck finger cannot price a 9-digit basket.
  static const int maxQuantity = 99;

  int _itemSeq = 0;
  int _listSeq = 0;

  /// Replaces the whole state with the basket read from the device.
  ///
  /// The id counters jump past the restored local ids, otherwise a new row
  /// would reuse the id of a row that is already in the list.
  void restore(DichoState restored) {
    state = restored;
    _itemSeq = _seqOf(restored.items.map((item) => item.id));
    _listSeq = _seqOf(restored.lists.map((list) => list.id));
  }

  static int _seqOf(Iterable<String> ids) {
    var highest = 0;
    for (final id in ids) {
      final match = RegExp(r'-local-(\d+)$').firstMatch(id);
      final value = int.tryParse(match?.group(1) ?? '') ?? 0;
      if (value > highest) highest = value;
    }
    return highest;
  }

  /// Publishes a new state and tells the listener, so the edit reaches the
  /// device. Every mutation goes through here.
  void _set(DichoState next) {
    state = next;
    onChanged?.call(next);
  }

  void selectList(String id) {
    if (!state.lists.any((list) => list.id == id)) return;
    _set(state.copyWith(selectedListId: id));
  }

  /// Adds an empty basket and switches to it.
  void createList({required String name, int budget = 500000}) {
    final trimmed = name.trim();
    if (trimmed.isEmpty) return;
    final list = ShoppingList(
      id: 'list-local-${++_listSeq}',
      name: trimmed,
      budget: budget,
    );
    _set(state.copyWith(
      lists: [...state.lists, list],
      selectedListId: list.id,
    ));
  }

  void setBudget(int value) =>
      _replaceList(state.list.copyWith(budget: value < 0 ? 0 : value));

  /// Appends a row to the open basket; the quick-add field only supplies a
  /// name, the dialog supplies the rest.
  void addItem({
    required String name,
    int unitPrice = 0,
    String unit = 'món',
    String packNote = '',
    ShoppingCategory category = ShoppingCategory.other,
    int quantity = 1,
  }) {
    final trimmed = name.trim();
    if (trimmed.isEmpty) return;
    final item = ShoppingItem(
      id: 'item-local-${++_itemSeq}',
      name: trimmed,
      packNote: packNote.trim(),
      unitPrice: unitPrice < 0 ? 0 : unitPrice,
      unit: unit.trim().isEmpty ? 'món' : unit.trim(),
      quantity: quantity.clamp(1, maxQuantity),
      category: category,
    );
    _replaceList(state.list.copyWith(items: [...state.items, item]));
  }

  void toggleItem(String id) => _updateItem(
        id,
        (item) => item.copyWith(checked: !item.checked),
      );

  /// Moves one row up or down, clamped to 1…[maxQuantity].
  void changeQuantity(String id, int delta) => _updateItem(
        id,
        (item) => item.copyWith(
            quantity: (item.quantity + delta).clamp(1, maxQuantity)),
      );

  void setQuantity(String id, int value) => _updateItem(
        id,
        (item) => item.copyWith(quantity: value.clamp(1, maxQuantity)),
      );

  void removeItem(String id) {
    final items = state.items.where((item) => item.id != id).toList();
    if (items.length == state.items.length) return;
    _replaceList(state.list.copyWith(items: items));
  }

  void toggleStore(String id) {
    if (!dichoStoreChains.any((store) => store.id == id)) return;
    final storeIds = {...state.storeIds};
    if (!storeIds.remove(id)) storeIds.add(id);
    _set(state.copyWith(storeIds: storeIds));
  }

  void selectAllStores(bool selected) => _set(state.copyWith(
        storeIds: selected
            ? {for (final store in dichoStoreChains) store.id}
            : <String>{},
      ));

  void setDeliveryMode(ShoppingDeliveryMode mode) =>
      _set(state.copyWith(deliveryMode: mode));

  void _updateItem(String id, ShoppingItem Function(ShoppingItem item) change) {
    final index = state.items.indexWhere((item) => item.id == id);
    if (index < 0) return;
    final items = [...state.items];
    items[index] = change(items[index]);
    _replaceList(state.list.copyWith(items: items));
  }

  void _replaceList(ShoppingList list) => _set(state.copyWith(
        lists: [
          for (final candidate in state.lists)
            candidate.id == list.id ? list : candidate,
        ],
      ));
}
