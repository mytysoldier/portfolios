import 'package:convenience_store_food_record_app/theme/main_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:convenience_store_food_record_app/l10n/app_localizations.dart';
import 'package:convenience_store_food_record_app/providers/statistic_data_provider.dart';
import 'package:convenience_store_food_record_app/providers/store_master_provider.dart';
import 'package:convenience_store_food_record_app/providers/category_master_provider.dart';
import 'package:convenience_store_food_record_app/models/statistic_data.dart';

class StatisticScreen extends ConsumerWidget {
  const StatisticScreen({super.key});

  double calcBarWidth(double value, double max, {double maxWidth = 100}) {
    if (max == 0) return 0;
    return maxWidth * (value / max);
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = L10n.of(context);
    final statistic = ref.watch(statisticDataProvider);
    final storeMaster = ref.watch(storeMasterProvider);
    final categoryMaster = ref.watch(categoryMasterProvider);

    // ローディングやエラー表示は必要に応じて追加してください

    final storeStats = statistic.storeStatistics;
    final categoryStats = statistic.categoryStatistics;
    final maxStoreCount = storeStats.isNotEmpty
        ? storeStats.map((s) => s.count).reduce((a, b) => a > b ? a : b)
        : 0;
    final maxCategoryAmount = categoryStats.isNotEmpty
        ? categoryStats.map((c) => c.totalAmount).reduce((a, b) => a > b ? a : b)
        : 0;

    // 全てのコンビニ・カテゴリを表示するためのリスト生成
    final allStoreNames = storeMaster.values.toList();
    final allCategoryNames = categoryMaster.values.toList();

    return SingleChildScrollView(
      child: Center(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            spacing: 16,
            children: [
              Row(
                children: [
                  Icon(Icons.bar_chart, size: 28, color: Colors.black),
                  const SizedBox(width: 8),
                  Text(
                    l10n.statistic_screen_title,
                    style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
              SizedBox(
                width: double.infinity,
                child: Card(
                  color: Colors.lightBlue[50],
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text(
                          "¥${statistic.totalExpenditure}",
                          style: Theme.of(context).textTheme.headlineSmall
                              ?.copyWith(
                                color: Colors.blue,
                                fontWeight: FontWeight.bold,
                              ),
                        ),
                        Text(
                          l10n.statistic_screen_all_expenditure,
                          style: Theme.of(context).textTheme.bodyMedium
                              ?.copyWith(color: Colors.grey[600]),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              // コンビニ別
              Column(
                spacing: 8,
                children: [
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      l10n.statistic_screen_number_of_purchase_by_convenience_store,
                      style: Theme.of(context).textTheme.bodyHeadTextStyle,
                    ),
                  ),
                  ...allStoreNames.map((storeName) {
                    final stat = storeStats.firstWhere(
                      (s) => s.storeName == storeName,
                      orElse: () => StoreStatistic(storeName: storeName, count: 0, totalAmount: 0),
                    );
                    return Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(storeName),
                        Row(
                          children: [
                            Stack(
                              children: [
                                Container(
                                  width: 100,
                                  height: 4,
                                  color: Colors.grey[300],
                                ),
                                Container(
                                  width: calcBarWidth(
                                    stat.count.toDouble(),
                                    maxStoreCount.toDouble(),
                                  ),
                                  height: 4,
                                  color: Colors.blue,
                                ),
                              ],
                            ),
                            SizedBox(width: 8),
                            Text("${stat.count}回"),
                          ],
                        ),
                      ],
                    );
                  }),
                ],
              ),
              // カテゴリ別
              Column(
                spacing: 8,
                children: [
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      l10n.statistic_screen_expenditure_by_category,
                      style: Theme.of(context).textTheme.bodyHeadTextStyle,
                    ),
                  ),
                  ...allCategoryNames.map((categoryName) {
                    final stat = categoryStats.firstWhere(
                      (c) => c.categoryName == categoryName,
                      orElse: () => CategoryStatistic(categoryName: categoryName, count: 0, totalAmount: 0),
                    );
                    return Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(categoryName),
                        Row(
                          children: [
                            Stack(
                              children: [
                                Container(
                                  width: 100,
                                  height: 4,
                                  color: Colors.grey[300],
                                ),
                                Container(
                                  width: calcBarWidth(
                                    stat.totalAmount.toDouble(),
                                    maxCategoryAmount.toDouble(),
                                  ),
                                  height: 4,
                                  color: Colors.green,
                                ),
                              ],
                            ),
                            SizedBox(width: 8),
                            Text("¥${stat.totalAmount}"),
                          ],
                        ),
                      ],
                    );
                  }),
                ],
              ),
              // 最近の傾向
              Column(
                spacing: 8,
                children: [
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      l10n.statistic_screen_recent_trends,
                      style: Theme.of(context).textTheme.bodyHeadTextStyle,
                    ),
                  ),
                  Row(
                    children: [
                      Expanded(
                        child: Card(
                          color: Colors.orange[50],
                          child: Padding(
                            padding: const EdgeInsets.all(16),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Text(
                                  "${statistic.totalCount}",
                                  style: Theme.of(context)
                                      .textTheme
                                      .bodyHeadTextStyle
                                      .copyWith(color: Colors.red),
                                ),
                                SizedBox(height: 8),
                                Text(
                                  l10n.statistic_screen_total_number_of_records,
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      Expanded(
                        child: Card(
                          color: Colors.purple[50],
                          child: Padding(
                            padding: const EdgeInsets.all(16),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Text(
                                  "¥${statistic.averageUnitPrice.toStringAsFixed(0)}",
                                  style: Theme.of(context)
                                      .textTheme
                                      .bodyHeadTextStyle
                                      .copyWith(color: Colors.purple),
                                ),
                                SizedBox(height: 8),
                                Text(l10n.statistic_screen_average_unit_price),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
