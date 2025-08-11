import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:convenience_store_food_record_app/l10n/app_localizations.dart';
import 'package:convenience_store_food_record_app/providers/category_master_provider.dart';

class CategoryDropdown extends ConsumerWidget {
  final String? value;
  final void Function(String?)? onChanged;
  const CategoryDropdown({
    super.key,
    required this.value,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = L10n.of(context);
    final categoryMaster = ref.watch(categoryMasterProvider);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "${l10n.category_name} *",
          style: Theme.of(
            context,
          ).textTheme.bodyLarge!.copyWith(color: Colors.black),
        ),
        DropdownButtonFormField<String>(
          value: value,
          isExpanded: true,
          items: categoryMaster.entries
              .map(
                (e) => DropdownMenuItem(
                  value: e.key.toString(),
                  child: Text(e.value),
                ),
              )
              .toList(),
          onChanged: onChanged,
          decoration: InputDecoration(
            border: const OutlineInputBorder(
              borderSide: BorderSide(color: Colors.grey),
            ),
            hintText: l10n.category_record_input_hint_text,
          ),
        ),
      ],
    );
  }
}
