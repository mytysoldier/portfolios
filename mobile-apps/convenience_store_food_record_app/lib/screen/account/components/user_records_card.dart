import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:convenience_store_food_record_app/providers/statistic_data_provider.dart';
import 'package:convenience_store_food_record_app/theme/main_theme.dart';
import 'package:convenience_store_food_record_app/l10n/app_localizations.dart';

class UserRecordsCard extends ConsumerWidget {
  const UserRecordsCard({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final statisticData = ref.watch(statisticDataProvider);
    final l10n = L10n.of(context);
    
    return SizedBox(
      width: double.infinity,
      child: Card(
        color: Colors.green[50],
        child: Padding(
          padding: const EdgeInsets.all(AppSizes.spacingM),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'あなたの記録',
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: Colors.green[700],
                ),
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  Expanded(
                    child: _buildStatItem(
                      context,
                      '${statisticData.totalCount}',
                      l10n.statistic_screen_total_number_of_records,
                      Colors.green,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: _buildStatItem(
                      context,
                      '¥${statisticData.totalExpenditure}',
                      l10n.statistic_screen_all_expenditure,
                      Colors.blue,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  Expanded(
                    child: _buildStatItem(
                      context,
                      '¥${statisticData.averageUnitPrice.toStringAsFixed(0)}',
                      l10n.statistic_screen_average_unit_price,
                      Colors.orange,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: _buildStatItem(
                      context,
                      '${statisticData.storeStatistics.length}',
                      ' 利用店舗数',
                      Colors.purple,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStatItem(
    BuildContext context,
    String value,
    String label,
    Color color,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text(
          value,
          style: Theme.of(context).textTheme.titleLarge?.copyWith(
            color: color,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: Theme.of(context).textTheme.bodySmall?.copyWith(
            color: Colors.grey[600],
          ),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }
}

