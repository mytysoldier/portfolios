import 'package:flutter/material.dart';
import 'package:convenience_store_food_record_app/theme/main_theme.dart';
import 'package:convenience_store_food_record_app/l10n/app_localizations.dart';

class TotalExpenditureCard extends StatelessWidget {
  final int totalExpenditure;
  const TotalExpenditureCard({super.key, required this.totalExpenditure});

  @override
  Widget build(BuildContext context) {
    final l10n = L10n.of(context);
    return SizedBox(
      width: double.infinity,
      child: Card(
        color: Colors.lightBlue[50],
        child: Padding(
          padding: const EdgeInsets.all(AppSizes.spacingM),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                "¥$totalExpenditure",
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  color: Colors.blue,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                l10n.statistic_screen_all_expenditure,
                style: Theme.of(
                  context,
                ).textTheme.bodyMedium?.copyWith(color: Colors.grey[600]),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
