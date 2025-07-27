import 'package:convenience_store_food_record_app/components/texttheme/custom_texttheme.dart';
import 'package:convenience_store_food_record_app/theme/main_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:convenience_store_food_record_app/l10n/app_localizations.dart';

class StatisticScreen extends ConsumerWidget {
  const StatisticScreen({super.key});

  double calcBarWidth(double value, double max, {double maxWidth = 100}) {
    if (max == 0) return 0;
    return maxWidth * (value / max);
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = L10n.of(context);

    // コンビニごとの回数
    final sevenElevenCount = 2.0;
    final rowsonCount = 2.0;
    final familyMartCount = 1.0;
    final otherStoreCount = 1.0;
    final maxStoreCount = [
      sevenElevenCount,
      rowsonCount,
      familyMartCount,
      otherStoreCount,
    ].reduce((a, b) => a > b ? a : b);

    // カテゴリごとの金額
    final onigiri = 120.0;
    final bread = 150.0;
    final dessert = 180.0;
    final lunchBox = 498.0;
    final maxCategory = [
      onigiri,
      bread,
      dessert,
      lunchBox,
    ].reduce((a, b) => a > b ? a : b);

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
                          "¥948",
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
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(l10n.seven_eleven),
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
                                  sevenElevenCount,
                                  maxStoreCount,
                                ),
                                height: 4,
                                color: Colors.blue,
                              ),
                            ],
                          ),
                          SizedBox(width: 8),
                          Text("2回"),
                        ],
                      ),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(l10n.rowson),
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
                                width: calcBarWidth(rowsonCount, maxStoreCount),
                                height: 4,
                                color: Colors.blue,
                              ),
                            ],
                          ),
                          SizedBox(width: 8),
                          Text("2回"),
                        ],
                      ),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(l10n.family_mart),
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
                                  familyMartCount,
                                  maxStoreCount,
                                ),
                                height: 4,
                                color: Colors.blue,
                              ),
                            ],
                          ),
                          SizedBox(width: 8),
                          Text("1回"),
                        ],
                      ),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(l10n.other_store),
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
                                  otherStoreCount,
                                  maxStoreCount,
                                ),
                                height: 4,
                                color: Colors.blue,
                              ),
                            ],
                          ),
                          SizedBox(width: 8),
                          Text("1回"),
                        ],
                      ),
                    ],
                  ),
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
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(l10n.onigiri),
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
                                width: calcBarWidth(onigiri, maxCategory),
                                height: 4,
                                color: Colors.green,
                              ),
                            ],
                          ),
                          SizedBox(width: 8),
                          Text("¥120"),
                        ],
                      ),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(l10n.bread),
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
                                width: calcBarWidth(bread, maxCategory),
                                height: 4,
                                color: Colors.green,
                              ),
                            ],
                          ),
                          SizedBox(width: 8),
                          Text("¥150"),
                        ],
                      ),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(l10n.dessert),
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
                                width: calcBarWidth(dessert, maxCategory),
                                height: 4,
                                color: Colors.green,
                              ),
                            ],
                          ),
                          SizedBox(width: 8),
                          Text("¥180"),
                        ],
                      ),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(l10n.lunch_box),
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
                                width: calcBarWidth(lunchBox, maxCategory),
                                height: 4,
                                color: Colors.green,
                              ),
                            ],
                          ),
                          SizedBox(width: 8),
                          Text("¥498"),
                        ],
                      ),
                    ],
                  ),
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
                                  "4",
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
                                  "¥237",
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
