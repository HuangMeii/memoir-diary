import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:memoir_app/src/data/dicho_csv.dart';
import 'package:memoir_app/src/data/dicho_shopping.dart';
import 'package:memoir_app/src/data/dicho_storage.dart';
import 'package:memoir_app/src/ui/dicho/dicho_format.dart';
import 'package:memoir_app/src/ui/dicho/dicho_shopping_card.dart';
import 'package:memoir_app/src/ui/dicho/dicho_stores_card.dart';
import 'package:memoir_app/src/ui/screens/dicho_screen.dart';

/// The seeded basket of the design: five rows, 353.000 đ of goods.
void main() {
  group('DichoState.seeded', () {
    final state = DichoState.seeded();

    test('starts on the week-41 basket with the design totals', () {
      expect(state.list.name, 'Mua sắm tuần 41');
      expect(state.lists.length, 4);
      expect(state.itemCount, 5);
      expect(state.subtotal, 353000);
      expect(state.budget, 500000);
      expect(state.remaining, 147000);
      expect(state.overBudget, isFalse);
      expect(state.checkedCount, 5);
    });

    test('fills the budget bar to 70.6%', () {
      expect(state.budgetProgress, closeTo(0.706, 0.0005));
    });

    test('has no delivery surcharge while picking up', () {
      expect(state.deliveryMode, ShoppingDeliveryMode.selfPickup);
      expect(state.deliveryFee, 0);
      expect(state.estimatedTotal, 353000);
    });

    test('ticks all eight chains', () {
      expect(state.storeIds.length, dichoStoreChains.length);
    });
  });

  group('DichoNotifier · basket', () {
    late DichoNotifier notifier;

    setUp(() => notifier = DichoNotifier());

    test('a quantity change moves the row and the subtotal', () {
      // Milk: 2 hộp × 38.000 đ.
      notifier.changeQuantity('item-milk', 1);

      expect(notifier.state.items.first.quantity, 3);
      expect(notifier.state.items.first.lineTotal, 114000);
      expect(notifier.state.subtotal, 391000);
      expect(notifier.state.remaining, 109000);
    });

    test('a row never drops below one unit', () {
      notifier.changeQuantity('item-eggs', -1);

      expect(notifier.state.items[1].quantity, 1);
      expect(notifier.state.subtotal, 353000);
    });

    test('a row never grows past the ceiling', () {
      notifier.setQuantity('item-eggs', 500);

      expect(notifier.state.items[1].quantity, DichoNotifier.maxQuantity);
    });

    test('ticking a row leaves the prices alone', () {
      notifier.toggleItem('item-rice');

      expect(notifier.state.checkedCount, 4);
      expect(notifier.state.subtotal, 353000);
    });

    test('removing a row takes its line off the subtotal', () {
      notifier.removeItem('item-rice');

      expect(notifier.state.itemCount, 4);
      expect(notifier.state.subtotal, 178000);
      expect(notifier.state.items.map((item) => item.id),
          isNot(contains('item-rice')));
    });

    test('adding a row appends it unchecked', () {
      notifier.addItem(
        name: '  Hành lá  ',
        unitPrice: 5000,
        unit: 'bó',
        packNote: 'Bó 100 g',
        category: ShoppingCategory.vegetable,
      );

      final added = notifier.state.items.last;
      expect(added.name, 'Hành lá');
      expect(added.unit, 'bó');
      expect(added.quantity, 1);
      expect(added.checked, isFalse);
      expect(added.lineTotal, 5000);
      expect(notifier.state.subtotal, 358000);
    });

    test('a blank name adds nothing', () {
      notifier.addItem(name: '   ');

      expect(notifier.state.itemCount, 5);
    });
  });

  group('DichoNotifier · budget, lists and stores', () {
    late DichoNotifier notifier;

    setUp(() => notifier = DichoNotifier());

    test('a lower budget flags the basket as over budget', () {
      notifier.setBudget(300000);

      expect(notifier.state.remaining, -53000);
      expect(notifier.state.overBudget, isTrue);
      expect(notifier.state.budgetProgress, 1.0);
    });

    test('a negative budget is clamped to zero', () {
      notifier.setBudget(-1);

      expect(notifier.state.budget, 0);
      expect(notifier.state.budgetProgress, 0);
    });

    test('delivery adds its surcharge to the estimate', () {
      notifier.setDeliveryMode(ShoppingDeliveryMode.delivery);

      expect(notifier.state.deliveryFee, 15000);
      expect(notifier.state.estimatedTotal, 368000);
      // Budget is judged on goods only.
      expect(notifier.state.remaining, 147000);
    });

    test('a new list starts empty and becomes the open basket', () {
      notifier.createList(name: 'Đi chợ cuối tuần', budget: 250000);

      expect(notifier.state.lists.length, 5);
      expect(notifier.state.list.name, 'Đi chợ cuối tuần');
      expect(notifier.state.list.budget, 250000);
      expect(notifier.state.items, isEmpty);
      expect(notifier.state.subtotal, 0);
    });

    test('an unknown list id keeps the current basket', () {
      notifier.selectList('list-does-not-exist');

      expect(notifier.state.selectedListId, 'list-week-41');
    });

    test('items stay with their own list', () {
      notifier.createList(name: 'Tuần sau');
      notifier.addItem(name: 'Nước mắm', unitPrice: 40000);
      notifier.selectList('list-week-41');

      expect(notifier.state.itemCount, 5);
      expect(notifier.state.subtotal, 353000);
    });

    test('unticking a chain then clearing removes every tick', () {
      notifier.toggleStore('coopmart');
      expect(notifier.state.storeIds.contains('coopmart'), isFalse);
      expect(notifier.state.storeIds.length, 7);

      notifier.selectAllStores(false);
      expect(notifier.state.storeIds, isEmpty);

      notifier.selectAllStores(true);
      expect(notifier.state.storeIds.length, 8);
    });
  });

  group('định dạng', () {
    test('money uses dot grouping', () {
      expect(formatVnd(353000), '353.000 đ');
      expect(formatVnd(0), '0 đ');
    });

    test('distances switch to metres below a kilometre', () {
      expect(formatDistance(0.45), '450 m');
      expect(formatDistance(1.8), '1.8 km');
    });

    test('a typed price tolerates separators', () {
      expect(parseVnd('38.000'), 38000);
      expect(parseVnd('38 000'), 38000);
      expect(parseVnd(''), 0);
    });
  });

  group('DichoItemRow', () {
    Future<DichoNotifier> pumpRow(WidgetTester tester) async {
      final notifier = DichoNotifier();
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: DichoItemRow(
              item: notifier.state.items.first,
              notifier: notifier,
            ),
          ),
        ),
      );
      return notifier;
    }

    testWidgets('prints the row and its line total', (tester) async {
      await pumpRow(tester);

      expect(
        find.text('Sữa tươi không đường TH True Milk 1 lít'),
        findsOneWidget,
      );
      expect(find.text('76.000 đ'), findsOneWidget);
      expect(find.text('2 hộp'), findsOneWidget);
    });

    testWidgets('the stepper and the tick reach the notifier', (tester) async {
      final notifier = await pumpRow(tester);

      await tester.tap(find.byIcon(Icons.add));
      expect(notifier.state.items.first.quantity, 3);

      await tester.tap(find.byType(Checkbox));
      expect(notifier.state.items.first.checked, isFalse);
    });

    testWidgets('the delete button removes the row', (tester) async {
      final notifier = await pumpRow(tester);

      await tester
          .tap(find.byTooltip('Xoá Sữa tươi không đường TH True Milk 1 lít'));

      expect(notifier.state.itemCount, 4);
      expect(notifier.state.items.map((item) => item.id),
          isNot(contains('item-milk')));
    });
  });

  group('lưu trên thiết bị', () {
    setUp(() => SharedPreferences.setMockInitialValues({}));

    test('an empty device answers null so the seeded basket stays', () async {
      expect(await const DichoStorage().load(), isNull);
    });

    test('the seeded basket survives a save / load round trip', () async {
      const storage = DichoStorage();
      final original = DichoNotifier().state;

      await storage.save(original);
      final restored = await storage.load();

      expect(restored, isNotNull);
      expect(restored!.lists.map((list) => list.name),
          original.lists.map((list) => list.name));
      expect(restored.lists.map((list) => list.budget),
          original.lists.map((list) => list.budget));
      expect(restored.subtotal, original.subtotal);
      expect(restored.selectedListId, original.selectedListId);
      expect(restored.storeIds, original.storeIds);
      expect(restored.items.map((item) => item.name),
          original.items.map((item) => item.name));
      expect(restored.items.map((item) => item.quantity),
          original.items.map((item) => item.quantity));
      expect(restored.items.map((item) => item.category),
          original.items.map((item) => item.category));
      expect(restored.checkedCount, original.checkedCount);
    });

    test('every edit of the screen comes back', () async {
      const storage = DichoStorage();
      final notifier = DichoNotifier()
        ..createList(name: 'Đi chợ cuối tuần', budget: 250000)
        ..addItem(
          name: 'Nước mắm, "loại đặc"',
          unitPrice: 40000,
          unit: 'chai',
          packNote: 'Chai 750 ml',
          category: ShoppingCategory.oil,
          quantity: 2,
        )
        ..setDeliveryMode(ShoppingDeliveryMode.delivery)
        ..toggleStore('coopmart');

      await storage.save(notifier.state);
      final restored = (await storage.load())!;

      expect(restored.list.name, 'Đi chợ cuối tuần');
      expect(restored.list.budget, 250000);
      expect(restored.deliveryMode, ShoppingDeliveryMode.delivery);
      expect(restored.storeIds.length, 7);
      expect(restored.storeIds.contains('coopmart'), isFalse);

      final item = restored.items.single;
      expect(item.name, 'Nước mắm, "loại đặc"');
      expect(item.unit, 'chai');
      expect(item.packNote, 'Chai 750 ml');
      expect(item.category, ShoppingCategory.oil);
      expect(item.quantity, 2);
      expect(item.lineTotal, 80000);
      expect(item.checked, isFalse);
    });

    test('the stored document is readable CSV', () {
      final document = dichoShoppingToCsv(DichoState.seeded());
      final lines = document.split('\n').map((line) => line.trimRight());

      expect(lines.first, dichoStorageHeader);
      expect(
        lines,
        contains('Danh sách ID,Tên danh sách,Ngân sách (đ),Đang chọn'),
      );
      expect(lines, contains('list-week-41,Mua sắm tuần 41,500000,1'));
      expect(
        lines,
        contains(
          'list-week-41,Sữa tươi không đường TH True Milk 1 lít,'
          'Hộp giấy tiệt trùng,dairy,hộp,2,38000,1',
        ),
      );
      expect(lines, contains('Hình thức nhận hàng,selfPickup'));
    });

    test('a document that is not ours is ignored', () async {
      SharedPreferences.setMockInitialValues({
        kDichoStorageKey: 'Tên,Số lượng\nSữa,2',
      });

      expect(await const DichoStorage().load(), isNull);
    });

    test('clear forgets the device basket', () async {
      const storage = DichoStorage();
      await storage.save(DichoNotifier().state);
      expect(await storage.load(), isNotNull);

      await storage.clear();
      expect(await storage.load(), isNull);
    });

    test('restoring keeps new rows on fresh ids', () {
      final first = DichoNotifier()
        ..createList(name: 'Danh sách A')
        ..addItem(name: 'Hành lá');

      final second = DichoNotifier()..restore(first.state);
      second.addItem(name: 'Ớt');

      final ids = second.state.items.map((item) => item.id).toList();
      expect(ids.length, ids.toSet().length);
    });

    test('an edit reaches the device through the provider', () async {
      final container = ProviderContainer();
      addTearDown(container.dispose);

      // Building the provider starts the one-shot restore.
      expect(container.read(dichoProvider).subtotal, 353000);

      container
          .read(dichoProvider.notifier)
          .addItem(name: 'Hành lá', unitPrice: 5000, unit: 'bó');
      await Future<void>.delayed(
        DichoSync.debounce + const Duration(milliseconds: 60),
      );

      final stored = await const DichoStorage().load();
      expect(stored, isNotNull);
      expect(stored!.items.last.name, 'Hành lá');
      expect(stored.items.last.lineTotal, 5000);
    });

    test('the saved basket wins over the seeded one on start', () async {
      final before = DichoNotifier()
        ..selectList('list-dry-goods')
        ..addItem(name: 'Mì gói', unitPrice: 6000);
      await const DichoStorage().save(before.state);

      final container = ProviderContainer();
      addTearDown(container.dispose);

      container.read(dichoProvider);
      await Future<void>.delayed(const Duration(milliseconds: 60));

      final restored = container.read(dichoProvider);
      expect(restored.list.name, 'Đồ khô dự trữ tháng 10');
      expect(restored.items.single.name, 'Mì gói');
    });
  });

  group('bố cục hai cột', () {
    /// Pumps the shop column and the store column the way `DichoScreen` does,
    /// at a given viewport width. A RenderFlex overflow fails the test.
    Future<DichoNotifier> pumpColumns(
      WidgetTester tester,
      double width,
    ) async {
      tester.view.physicalSize = Size(width, 1600);
      tester.view.devicePixelRatio = 1;
      addTearDown(tester.view.reset);

      final notifier = DichoNotifier();
      final wide = width >= kDichoTwoColumnMinWidth;

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: SingleChildScrollView(
              child: wide
                  ? Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          flex: 7,
                          child: DichoShoppingCard(
                            state: notifier.state,
                            notifier: notifier,
                          ),
                        ),
                        const SizedBox(width: kDichoColumnGap),
                        Expanded(
                          flex: 5,
                          child: DichoStoresCard(
                            state: notifier.state,
                            notifier: notifier,
                          ),
                        ),
                      ],
                    )
                  : Column(
                      children: [
                        DichoShoppingCard(
                          state: notifier.state,
                          notifier: notifier,
                        ),
                        const SizedBox(height: kDichoColumnGap),
                        DichoStoresCard(
                          state: notifier.state,
                          notifier: notifier,
                        ),
                      ],
                    ),
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();
      return notifier;
    }

    testWidgets('both cards render side by side at 1280 px', (tester) async {
      await pumpColumns(tester, 1280);

      expect(find.text('Danh sách cần mua'), findsOneWidget);
      expect(find.text('Vị trí & Siêu thị'), findsOneWidget);
      expect(find.text('353.000 đ'), findsWidgets);
      expect(find.text('Co.opmart'), findsOneWidget);
      expect(tester.takeException(), isNull);
    });

    testWidgets('both cards stack on a 390 px phone', (tester) async {
      await pumpColumns(tester, 390);

      expect(find.text('Danh sách cần mua'), findsOneWidget);
      expect(find.text('Bách Hóa Xanh'), findsOneWidget);
      expect(tester.takeException(), isNull);
    });
  });
}
