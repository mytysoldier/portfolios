import 'dart:typed_data';

import 'package:convenience_store_food_record_app/providers/image_picker_provider.dart';
import 'package:convenience_store_food_record_app/theme/main_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:convenience_store_food_record_app/l10n/app_localizations.dart';
import 'package:convenience_store_food_record_app/providers/history_item_provider.dart';
import 'package:convenience_store_food_record_app/providers/store_master_provider.dart';
import 'package:convenience_store_food_record_app/components/history_screen/history_item.dart';
import 'package:convenience_store_food_record_app/providers/category_master_provider.dart';

class HistoryScreen extends ConsumerStatefulWidget {
  const HistoryScreen({super.key});

  @override
  ConsumerState<HistoryScreen> createState() => _HistoryScreenState();
}

class _HistoryScreenState extends ConsumerState<HistoryScreen> {
  @override
  void initState() {
    super.initState();
    // 履歴リストが空のときのみfetch
    Future.microtask(() async {
      if (ref.read(historyItemListProvider).isEmpty) {
        await ref
            .read(historyItemListProvider.notifier)
            .fetchPurchasedItems(ref);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final l10n = L10n.of(context);
    final textController = TextEditingController();
    final items = ref.watch(historyItemListProvider);

    return RefreshIndicator(
      onRefresh: () async {
        await ref
            .read(historyItemListProvider.notifier)
            .fetchPurchasedItems(ref);
      },
      child: SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        child: Container(
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.surface,
            borderRadius: BorderRadius.circular(AppSizes.cardRadius),
            border: Border.all(color: Colors.grey, width: AppSizes.spacingXxxs),
          ),
          padding: const EdgeInsets.all(AppSizes.spacingM),
          child: Column(
            spacing: AppSizes.cardRadius,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Icon(Icons.history, size: AppSizes.iconSize),
                  SizedBox(width: AppSizes.cardRadius),
                  Text(
                    l10n.history_screen_title,
                    style: Theme.of(context).textTheme.bodyHeadTextStyle,
                  ),
                ],
              ),
              // フリーテキストで検索
              TextField(
                controller: textController,
                decoration: InputDecoration(
                  labelText: l10n.history_search_input_hint_text,
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.search),
                ),
              ),
              // プルダウンで検索
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // コンビニ名
                  Expanded(
                    child: Builder(
                      builder: (context) {
                        final storeMaster = ref.watch(storeMasterProvider);
                        return DropdownButtonFormField<String>(
                          isExpanded: true,
                          value: null,
                          items: storeMaster.entries
                              .map(
                                (e) => DropdownMenuItem(
                                  value: e.key.toString(),
                                  child: Text(
                                    e.value,
                                    style: Theme.of(
                                      context,
                                    ).textTheme.bodyMedium,
                                  ),
                                ),
                              )
                              .toList(),
                          onChanged: (value) {},
                          decoration: const InputDecoration(
                            labelText: 'コンビニ',
                            border: OutlineInputBorder(),
                          ),
                        );
                      },
                    ),
                  ),
                  const SizedBox(width: AppSizes.spacingM),
                  // カテゴリ
                  Expanded(
                    child: Builder(
                      builder: (context) {
                        final categoryMaster = ref.watch(
                          categoryMasterProvider,
                        );
                        return DropdownButtonFormField<String>(
                          isExpanded: true,
                          value: null,
                          items: categoryMaster.entries
                              .map(
                                (e) => DropdownMenuItem(
                                  value: e.key.toString(),
                                  child: Text(
                                    e.value,
                                    style: Theme.of(
                                      context,
                                    ).textTheme.bodyMedium,
                                  ),
                                ),
                              )
                              .toList(),
                          onChanged: (value) {},
                          decoration: const InputDecoration(
                            labelText: 'カテゴリ',
                            border: OutlineInputBorder(),
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
              // 履歴リスト表示
              ListView.builder(
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                itemCount: items.length,
                itemBuilder: (context, index) {
                  final item = items[index];
                  return FutureBuilder<List<int>?>(
                    future: ref
                        .read(imagePickerProvider.notifier)
                        .fetchImageFromR2(item.imageUrl),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return HistoryItem(
                          item: item,
                          imageBytes: null,
                          isLoading: true,
                        );
                      }
                      if (snapshot.hasError || snapshot.data == null) {
                        return HistoryItem(
                          item: item,
                          imageBytes: null,
                          isLoading: false,
                        );
                      }
                      return HistoryItem(
                        item: item,
                        imageBytes: Uint8List.fromList(snapshot.data!),
                        isLoading: false,
                      );
                    },
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
