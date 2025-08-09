import 'package:convenience_store_food_record_app/theme/custom_colortheme.dart';
import 'package:convenience_store_food_record_app/theme/main_theme.dart';
import 'package:flutter/material.dart';

class LoadingIndicator extends StatelessWidget {
  const LoadingIndicator({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: AppSizes.loadingSize,
      height: AppSizes.loadingSize,
      color: Theme.of(context).colorScheme.loading,
      child: const Icon(Icons.image_not_supported),
    );
  }
}
