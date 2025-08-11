import 'package:flutter/material.dart';
import 'package:convenience_store_food_record_app/l10n/app_localizations.dart';

class PriceInput extends StatelessWidget {
  final TextEditingController controller;
  const PriceInput({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    final l10n = L10n.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "${l10n.price_name} *",
          style: Theme.of(
            context,
          ).textTheme.bodyLarge!.copyWith(color: Colors.black),
        ),
        const SizedBox(height: 8),
        TextField(
          controller: controller,
          decoration: InputDecoration(
            hintText: l10n.price_record_input_hint_text,
            border: const OutlineInputBorder(
              borderSide: BorderSide(color: Colors.grey),
            ),
          ),
        ),
      ],
    );
  }
}
