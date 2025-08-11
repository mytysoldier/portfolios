import 'package:convenience_store_food_record_app/components/screen/screen_title.dart';
import 'package:convenience_store_food_record_app/theme/main_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:convenience_store_food_record_app/l10n/app_localizations.dart';
import 'package:convenience_store_food_record_app/providers/history_item_provider.dart';
import 'package:convenience_store_food_record_app/screen/history/history_list.dart';
import 'package:convenience_store_food_record_app/screen/history/search_history.dart';

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
              ScreenTitle(
                icon: Icons.history,
                title: l10n.history_screen_title,
              ),
              // 検索バー部分
              SearchHistoryBar(textController: textController),
              // 履歴リスト表示
              HistoryList(items: items),
            ],
          ),
        ),
      ),
    );
  }
}
