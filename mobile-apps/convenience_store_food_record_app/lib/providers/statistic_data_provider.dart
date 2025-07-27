import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:convenience_store_food_record_app/models/statistic_data.dart';
import 'package:convenience_store_food_record_app/providers/history_item_provider.dart';

final statisticDataProvider = Provider<StatisticData>((ref) {
  final items = ref.watch(historyItemListProvider);

  // コンビニ別集計
  final Map<String, StoreStatistic> storeStats = {};
  // カテゴリ別集計
  final Map<String, CategoryStatistic> categoryStats = {};
  int totalExpenditure = 0;

  for (final item in items) {
    // store
    storeStats.update(
      item.storeName,
      (s) => StoreStatistic(
        storeName: s.storeName,
        count: s.count + 1,
        totalAmount: s.totalAmount + item.price,
      ),
      ifAbsent: () => StoreStatistic(
        storeName: item.storeName,
        count: 1,
        totalAmount: item.price,
      ),
    );
    // category
    categoryStats.update(
      item.category,
      (c) => CategoryStatistic(
        categoryName: c.categoryName,
        count: c.count + 1,
        totalAmount: c.totalAmount + item.price,
      ),
      ifAbsent: () => CategoryStatistic(
        categoryName: item.category,
        count: 1,
        totalAmount: item.price,
      ),
    );
    totalExpenditure += item.price;
  }

  final totalCount = items.length;
  final averageUnitPrice = totalCount > 0 ? totalExpenditure / totalCount : 0.0;

  return StatisticData(
    totalExpenditure: totalExpenditure,
    storeStatistics: storeStats.values.toList(),
    categoryStatistics: categoryStats.values.toList(),
    totalCount: totalCount,
    averageUnitPrice: averageUnitPrice.toDouble(),
  );
});
