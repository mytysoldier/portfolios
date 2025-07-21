import 'package:convenience_store_food_record_app/components/texttheme/custom_texttheme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:convenience_store_food_record_app/l10n/app_localizations.dart';

class StatisticScreen extends ConsumerWidget {
  const StatisticScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = L10n.of(context);

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
            ],
          ),
        ),
      ),
    );
  }
}
