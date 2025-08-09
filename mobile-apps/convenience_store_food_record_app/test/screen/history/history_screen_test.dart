import 'package:convenience_store_food_record_app/l10n/app_localizations.dart';
import 'package:convenience_store_food_record_app/models/history_item_model.dart';
import 'package:convenience_store_food_record_app/providers/history_item_provider.dart';
import 'package:convenience_store_food_record_app/providers/store_master_provider.dart';
import 'package:convenience_store_food_record_app/providers/category_master_provider.dart';
import 'package:convenience_store_food_record_app/providers/image_picker_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:convenience_store_food_record_app/screen/history/history_screen.dart';
import 'dart:typed_data';

// 1. HistoryItemListNotifierをモックするためのクラスを定義
class MockHistoryItemListNotifier extends HistoryItemListNotifier {
  // fetchPurchasedItemsが呼ばれても何もしないようにオーバーライド
  @override
  Future<void> fetchPurchasedItems(WidgetRef ref) async {
    // 何も実行しない
    return;
  }
}

final dummyItems = [
  HistoryItemModel(
    imageUrl: '',
    productName: 'テスト商品',
    storeName: 'テストコンビニ',
    category: 'テストカテゴリ',
    memo: 'テストメモ',
    price: 100,
    purchaseDate: DateTime.now(),
  ),
];

class MockImagePickerNotifier extends ImagePickerNotifier {
  MockImagePickerNotifier() : super();
  @override
  Future<List<int>?> fetchImageFromR2(String fileName) async {
    // 1x1ピクセルの透明PNG
    return Uint8List.fromList([
      137,
      80,
      78,
      71,
      13,
      10,
      26,
      10,
      0,
      0,
      0,
      13,
      73,
      72,
      68,
      82,
      0,
      0,
      0,
      1,
      0,
      0,
      0,
      1,
      8,
      6,
      0,
      0,
      0,
      31,
      21,
      196,
      137,
      0,
      0,
      0,
      12,
      73,
      68,
      65,
      84,
      8,
      153,
      99,
      0,
      1,
      0,
      0,
      5,
      0,
      1,
      13,
      10,
      26,
      10,
      0,
      0,
      0,
      0,
      73,
      69,
      78,
      68,
      174,
      66,
      96,
      130,
    ]);
  }
}

// 2. プロバイダーの上書き設定を更新
final providerOverrides = [
  historyItemListProvider.overrideWith((ref) {
    // MockNotifierを使い、初期状態としてダミーデータを設定
    final notifier = MockHistoryItemListNotifier();
    notifier.state = dummyItems;
    return notifier;
  }),
  storeMasterProvider.overrideWith((ref) {
    final notifier = StoreMasterNotifier();
    notifier.state = {1: 'テストコンビニ'};
    return notifier;
  }),
  categoryMasterProvider.overrideWith((ref) {
    final notifier = CategoryMasterNotifier();
    notifier.state = {1: 'テストカテゴリ'};
    return notifier;
  }),
  imagePickerProvider.overrideWith((ref) => MockImagePickerNotifier()),
];

void main() {
  testWidgets('HistoryScreen should display item text after async operations', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(
      ProviderScope(
        overrides: providerOverrides,
        child: MaterialApp(
          localizationsDelegates: L10n.localizationsDelegates,
          supportedLocales: L10n.supportedLocales,
          locale: const Locale('ja'),
          home: Scaffold(body: HistoryScreen()),
        ),
      ),
    );

    await tester.pumpAndSettle();

    expect(find.text('テスト商品'), findsOneWidget);
    expect(find.text('テストコンビニ'), findsOneWidget);
    expect(find.text('テストカテゴリ'), findsOneWidget);
    expect(find.text('￥100'), findsOneWidget);
  });
}
