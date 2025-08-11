import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:convenience_store_food_record_app/theme/main_theme.dart';
import 'package:convenience_store_food_record_app/l10n/app_localizations.dart';
import 'package:convenience_store_food_record_app/providers/store_master_provider.dart';
import 'package:convenience_store_food_record_app/providers/category_master_provider.dart';

class SearchHistoryBar extends ConsumerWidget {
  final TextEditingController textController;
  final String? selectedStoreId;
  final String? selectedCategoryId;
  final void Function(String?)? onStoreChanged;
  final void Function(String?)? onCategoryChanged;
  final void Function(String)? onTextChanged;

  const SearchHistoryBar({
    super.key,
    required this.textController,
    required this.selectedStoreId,
    required this.selectedCategoryId,
    this.onStoreChanged,
    this.onCategoryChanged,
    this.onTextChanged,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = L10n.of(context);
    final storeMaster = ref.watch(storeMasterProvider);
    final categoryMaster = ref.watch(categoryMasterProvider);

    return Column(
      spacing: 16,
      children: [
        // フリーテキストで検索
        TextField(
          controller: textController,
          onChanged: onTextChanged,
          decoration: InputDecoration(
            labelText: l10n.history_search_input_hint_text,
            border: const OutlineInputBorder(),
            prefixIcon: const Icon(Icons.search),
          ),
        ),
        // プルダウンで検索
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            // コンビニ名
            Expanded(
              child: DropdownButtonFormField<String>(
                isExpanded: true,
                value: selectedStoreId,
                items: [
                  DropdownMenuItem(
                    value: null,
                    child: Text(
                      l10n.pulldown_convenience_store_all,
                      style: Theme.of(
                        context,
                      ).textTheme.bodySmall?.copyWith(color: Colors.black),
                    ),
                  ),
                  ...storeMaster.entries.map(
                    (e) => DropdownMenuItem(
                      value: e.key.toString(),
                      child: Text(
                        e.value,
                        style: Theme.of(
                          context,
                        ).textTheme.bodySmall?.copyWith(color: Colors.black),
                      ),
                    ),
                  ),
                ],
                selectedItemBuilder: (context) {
                  return [
                    Text(
                      l10n.pulldown_convenience_store_all,
                      style: Theme.of(
                        context,
                      ).textTheme.bodySmall?.copyWith(color: Colors.black),
                    ),
                    ...storeMaster.entries.map(
                      (e) => Text(
                        e.value,
                        style: Theme.of(
                          context,
                        ).textTheme.bodySmall?.copyWith(color: Colors.black),
                      ),
                    ),
                  ];
                },
                onChanged: onStoreChanged,
                decoration: InputDecoration(
                  labelText: l10n.item_convenience_store_name,
                  border: OutlineInputBorder(),
                ),
              ),
            ),
            const SizedBox(width: AppSizes.spacingM),
            // カテゴリ
            Expanded(
              child: DropdownButtonFormField<String>(
                isExpanded: true,
                value: selectedCategoryId,
                items: [
                  DropdownMenuItem(
                    value: null,
                    child: Text(
                      l10n.pulldown_item_all,
                      style: Theme.of(
                        context,
                      ).textTheme.bodySmall?.copyWith(color: Colors.black),
                    ),
                  ),
                  ...categoryMaster.entries.map(
                    (e) => DropdownMenuItem(
                      value: e.key.toString(),
                      child: Text(
                        e.value,
                        style: Theme.of(
                          context,
                        ).textTheme.bodySmall?.copyWith(color: Colors.black),
                      ),
                    ),
                  ),
                ],
                selectedItemBuilder: (context) {
                  return [
                    Text(
                      l10n.pulldown_item_all,
                      style: Theme.of(
                        context,
                      ).textTheme.bodySmall?.copyWith(color: Colors.black),
                    ),
                    ...categoryMaster.entries.map(
                      (e) => Text(
                        e.value,
                        style: Theme.of(
                          context,
                        ).textTheme.bodySmall?.copyWith(color: Colors.black),
                      ),
                    ),
                  ];
                },
                onChanged: onCategoryChanged,
                decoration: InputDecoration(
                  labelText: l10n.category_name,
                  border: OutlineInputBorder(),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
