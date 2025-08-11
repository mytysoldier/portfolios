import 'package:flutter/material.dart';
import 'package:convenience_store_food_record_app/theme/main_theme.dart';
import 'package:convenience_store_food_record_app/models/statistic_data.dart';

class StoreStatisticsBar extends StatelessWidget {
  final List<String> allStoreNames;
  final List<StoreStatistic> storeStats;
  final int maxStoreCount;
  final String title;
  final TextStyle? titleStyle;

  const StoreStatisticsBar({
    super.key,
    required this.allStoreNames,
    required this.storeStats,
    required this.maxStoreCount,
    required this.title,
    this.titleStyle,
  });

  double calcBarWidth(double value, double max, {double maxWidth = 100}) {
    if (max == 0) return 0;
    return maxWidth * (value / max);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title, style: titleStyle),
        const SizedBox(height: AppSizes.spacingS),
        ...allStoreNames.map((storeName) {
          final stat = storeStats.firstWhere(
            (s) => s.storeName == storeName,
            orElse: () =>
                StoreStatistic(storeName: storeName, count: 0, totalAmount: 0),
          );
          return Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(storeName),
              Row(
                children: [
                  Stack(
                    children: [
                      Container(width: 100, height: 4, color: Colors.grey[300]),
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
                  const SizedBox(width: 8),
                  Text("${stat.count}回"),
                ],
              ),
            ],
          );
        }),
      ],
    );
  }
}
