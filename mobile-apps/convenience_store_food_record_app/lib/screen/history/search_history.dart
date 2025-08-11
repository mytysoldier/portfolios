import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:convenience_store_food_record_app/theme/main_theme.dart';
import 'package:convenience_store_food_record_app/l10n/app_localizations.dart';
import 'package:convenience_store_food_record_app/providers/store_master_provider.dart';
import 'package:convenience_store_food_record_app/providers/category_master_provider.dart';

class SearchHistoryBar extends ConsumerWidget {
  final TextEditingController textController;
  final void Function(String?)? onStoreChanged;
  final void Function(String?)? onCategoryChanged;

  const SearchHistoryBar({
    super.key,
    required this.textController,
    this.onStoreChanged,
    this.onCategoryChanged,
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
                value: null,
                items: storeMaster.entries
                    .map(
                      (e) => DropdownMenuItem(
                        value: e.key.toString(),
                        child: Text(
                          e.value,
                          style: Theme.of(context).textTheme.bodyMedium,
                        ),
                      ),
                    )
                    .toList(),
                onChanged: onStoreChanged,
                decoration: const InputDecoration(
                  labelText: 'コンビニ',
                  border: OutlineInputBorder(),
                ),
              ),
            ),
            const SizedBox(width: AppSizes.spacingM),
            // カテゴリ
            Expanded(
              child: DropdownButtonFormField<String>(
                isExpanded: true,
                value: null,
                items: categoryMaster.entries
                    .map(
                      (e) => DropdownMenuItem(
                        value: e.key.toString(),
                        child: Text(
                          e.value,
                          style: Theme.of(context).textTheme.bodyMedium,
                        ),
                      ),
                    )
                    .toList(),
                onChanged: onCategoryChanged,
                decoration: const InputDecoration(
                  labelText: 'カテゴリ',
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
