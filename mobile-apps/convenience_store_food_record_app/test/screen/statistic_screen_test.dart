import 'package:convenience_store_food_record_app/l10n/app_localizations.dart';
import 'package:convenience_store_food_record_app/models/statistic_data.dart';
import 'package:convenience_store_food_record_app/providers/category_master_provider.dart';
import 'package:convenience_store_food_record_app/providers/statistic_data_provider.dart';
import 'package:convenience_store_food_record_app/providers/store_master_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:convenience_store_food_record_app/screen/statistic_screen.dart';

// 1. ダミーデータを作成
final dummyStatisticData = StatisticData(
  totalExpenditure: 5000,
  totalCount: 10,
  averageUnitPrice: 500,
  storeStatistics: [
    StoreStatistic(storeName: 'テストコンビニA', count: 7, totalAmount: 3500),
    StoreStatistic(storeName: 'テストコンビニB', count: 3, totalAmount: 1500),
  ],
  categoryStatistics: [
    CategoryStatistic(categoryName: 'テストカテゴリX', count: 4, totalAmount: 2000),
    CategoryStatistic(categoryName: 'テストカテゴリY', count: 6, totalAmount: 3000),
  ],
);

final dummyStoreMaster = {
  1: 'テストコンビニA',
  2: 'テストコンビニB',
};

final dummyCategoryMaster = {
  1: 'テストカテゴリX',
  2: 'テストカテゴリY',
};

// 2. Providerを上書きするためのリストを作成
final providerOverrides = [
  statisticDataProvider.overrideWith((ref) => dummyStatisticData),
  storeMasterProvider.overrideWith((ref) {
    final notifier = StoreMasterNotifier();
    notifier.state = dummyStoreMaster;
    return notifier;
  }),
  categoryMasterProvider.overrideWith((ref) {
    final notifier = CategoryMasterNotifier();
    notifier.state = dummyCategoryMaster;
    return notifier;
  }),
];

void main() {
  testWidgets('StatisticScreen should display statistic data from providers', (
    WidgetTester tester,
  ) async {
    // 3. Providerを上書きしてウィジェットを描画
    await tester.pumpWidget(
      ProviderScope(
        overrides: providerOverrides,
        child: MaterialApp(
          localizationsDelegates: L10n.localizationsDelegates,
          supportedLocales: L10n.supportedLocales,
          locale: const Locale('ja'),
          home: Scaffold(body: StatisticScreen()),
        ),
      ),
    );
    await tester.pumpAndSettle();

    // 4. ダミーデータが正しく表示されているか具体的に検証
    // 合計支出
    expect(find.text('¥5000'), findsOneWidget);

    // コンビニ別統計
    expect(find.text('テストコンビニA'), findsOneWidget);
    expect(find.text('7回'), findsOneWidget);
    expect(find.text('テストコンビニB'), findsOneWidget);
    expect(find.text('3回'), findsOneWidget);

    // カテゴリ別統計
    expect(find.text('テストカテゴリX'), findsOneWidget);
    expect(find.text('¥2000'), findsOneWidget);
    expect(find.text('テストカテゴリY'), findsOneWidget);
    expect(find.text('¥3000'), findsOneWidget);

    // 最近の傾向
    expect(find.text('10'), findsOneWidget); // 記録合計
    expect(find.text('¥500'), findsOneWidget); // 平均単価
  });
}