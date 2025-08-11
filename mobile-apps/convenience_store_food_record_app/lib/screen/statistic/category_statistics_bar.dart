import 'package:flutter/material.dart';
import 'package:convenience_store_food_record_app/theme/main_theme.dart';
import 'package:convenience_store_food_record_app/models/statistic_data.dart';

class CategoryStatisticsBar extends StatelessWidget {
  final List<String> allCategoryNames;
  final List<CategoryStatistic> categoryStats;
  final int maxCategoryAmount;
  final String title;
  final TextStyle? titleStyle;

  const CategoryStatisticsBar({
    super.key,
    required this.allCategoryNames,
    required this.categoryStats,
    required this.maxCategoryAmount,
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
        ...allCategoryNames.map((categoryName) {
          final stat = categoryStats.firstWhere(
            (c) => c.categoryName == categoryName,
            orElse: () => CategoryStatistic(
              categoryName: categoryName,
              count: 0,
              totalAmount: 0,
            ),
          );
          return Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(categoryName),
              Row(
                children: [
                  Stack(
                    children: [
                      Container(width: 100, height: 4, color: Colors.grey[300]),
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
                  const SizedBox(width: 8),
                  Text("¥${stat.totalAmount}"),
                ],
              ),
            ],
          );
        }).toList(),
      ],
    );
  }
}
