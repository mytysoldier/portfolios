import 'package:convenience_store_food_record_app/components/screen/screen_title.dart';
import 'package:convenience_store_food_record_app/theme/main_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:convenience_store_food_record_app/l10n/app_localizations.dart';
import 'package:convenience_store_food_record_app/providers/history_item_provider.dart';
import 'package:convenience_store_food_record_app/providers/store_master_provider.dart';
import 'package:convenience_store_food_record_app/providers/category_master_provider.dart';
import 'package:convenience_store_food_record_app/screen/history/history_list.dart';
import 'package:convenience_store_food_record_app/screen/history/search_history.dart';

class HistoryScreen extends ConsumerStatefulWidget {
  const HistoryScreen({super.key});

  @override
  ConsumerState<HistoryScreen> createState() => _HistoryScreenState();
}

class _HistoryScreenState extends ConsumerState<HistoryScreen> {
  String? selectedStoreId;
  String? selectedCategoryId;
  String searchText = '';
  late final TextEditingController textController;
  @override
  void initState() {
    super.initState();
    textController = TextEditingController(text: searchText);
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
  void dispose() {
    textController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = L10n.of(context);
    // textControllerはStateで管理
    final items = ref.watch(historyItemListProvider);

    // フィルタ処理（可読性重視で整理）
    final storeMaster = ref.watch(storeMasterProvider);
    final categoryMaster = ref.watch(categoryMasterProvider);
    final selectedStoreText = (selectedStoreId == null)
        ? null
        : storeMaster[int.tryParse(selectedStoreId!)];
    final selectedCategoryText = (selectedCategoryId == null)
        ? null
        : categoryMaster[int.tryParse(selectedCategoryId!)];

    final filteredItems = items.where((item) {
      final storeMatch =
          (selectedStoreText == null) || item.storeName == selectedStoreText;
      final categoryMatch =
          (selectedCategoryText == null) ||
          item.category == selectedCategoryText;
      final textMatch =
          searchText.isEmpty ||
          item.productName.contains(searchText) ||
          item.memo.contains(searchText);
      return storeMatch && categoryMatch && textMatch;
    }).toList();

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
              ScreenTitle(
                icon: Icons.history,
                title: l10n.history_screen_title,
              ),
              // 検索バー部分
              SearchHistoryBar(
                textController: textController,
                selectedStoreId: selectedStoreId,
                selectedCategoryId: selectedCategoryId,
                onStoreChanged: (value) {
                  setState(() {
                    selectedStoreId = value == null || value == ''
                        ? null
                        : value;
                  });
                },
                onCategoryChanged: (value) {
                  setState(() {
                    selectedCategoryId = value == null || value == ''
                        ? null
                        : value;
                  });
                },
                onTextChanged: (value) {
                  setState(() {
                    searchText = value;
                  });
                },
              ),
              // 履歴リスト表示
              HistoryList(items: filteredItems),
            ],
          ),
        ),
      ),
    );
  }
}
