import 'package:convenience_store_food_record_app/theme/main_theme.dart';
import 'package:flutter/material.dart';

class ScreenTitle extends StatelessWidget {
  final IconData icon;
  final String title;
  const ScreenTitle({super.key, required this.icon, required this.title});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Icon(icon, size: AppSizes.iconSize),
        SizedBox(width: AppSizes.cardRadius),
        Text(title, style: Theme.of(context).textTheme.bodyHeadTextStyle),
      ],
    );
  }
}
