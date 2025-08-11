import 'package:convenience_store_food_record_app/screen/statistic/recent_trends_card.dart';
import 'package:convenience_store_food_record_app/screen/statistic/category_statistics_bar.dart';
import 'package:convenience_store_food_record_app/screen/statistic/store_statistics_bar.dart';
import 'package:convenience_store_food_record_app/screen/statistic/total_expenditure_card.dart';
import 'package:convenience_store_food_record_app/components/screen/screen_title.dart';
import 'package:convenience_store_food_record_app/theme/main_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:convenience_store_food_record_app/l10n/app_localizations.dart';
import 'package:convenience_store_food_record_app/providers/statistic_data_provider.dart';
import 'package:convenience_store_food_record_app/providers/store_master_provider.dart';
import 'package:convenience_store_food_record_app/providers/category_master_provider.dart';

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

    final storeStats = statistic.storeStatistics;
    final categoryStats = statistic.categoryStatistics;
    final maxStoreCount = storeStats.isNotEmpty
        ? storeStats.map((s) => s.count).reduce((a, b) => a > b ? a : b)
        : 0;
    final maxCategoryAmount = categoryStats.isNotEmpty
        ? categoryStats
              .map((c) => c.totalAmount)
              .reduce((a, b) => a > b ? a : b)
        : 0;

    // 全てのコンビニ・カテゴリを表示するためのリスト生成
    final allStoreNames = storeMaster.values.toList();
    final allCategoryNames = categoryMaster.values.toList();

    return SingleChildScrollView(
      child: Center(
        child: Padding(
          padding: const EdgeInsets.all(AppSizes.spacingM),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            spacing: AppSizes.spacingM,
            children: [
              ScreenTitle(
                icon: Icons.bar_chart,
                title: l10n.statistic_screen_title,
              ),
              TotalExpenditureCard(
                totalExpenditure: statistic.totalExpenditure,
              ),
              StoreStatisticsBar(
                allStoreNames: allStoreNames,
                storeStats: storeStats,
                maxStoreCount: maxStoreCount,
                title: l10n
                    .statistic_screen_number_of_purchase_by_convenience_store,
                titleStyle: Theme.of(context).textTheme.bodyHeadTextStyle,
              ),
              CategoryStatisticsBar(
                allCategoryNames: allCategoryNames,
                categoryStats: categoryStats,
                maxCategoryAmount: maxCategoryAmount,
                title: l10n.statistic_screen_expenditure_by_category,
                titleStyle: Theme.of(context).textTheme.bodyHeadTextStyle,
              ),
              Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  l10n.statistic_screen_recent_trends,
                  style: Theme.of(context).textTheme.bodyHeadTextStyle,
                ),
              ),
              RecentTrendsCard(
                totalCount: statistic.totalCount,
                averageUnitPrice: statistic.averageUnitPrice,
                totalCountLabel: l10n.statistic_screen_total_number_of_records,
                averageUnitPriceLabel: l10n.statistic_screen_average_unit_price,
                valueStyle: Theme.of(context).textTheme.bodyHeadTextStyle,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
