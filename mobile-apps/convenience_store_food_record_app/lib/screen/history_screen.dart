import 'package:convenience_store_food_record_app/theme/main_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:convenience_store_food_record_app/l10n/app_localizations.dart';
import 'package:convenience_store_food_record_app/providers/history_item_provider.dart';
import 'package:convenience_store_food_record_app/components/history_screen/history_item.dart';

class HistoryScreen extends ConsumerStatefulWidget {
  const HistoryScreen({super.key});

  @override
  ConsumerState<HistoryScreen> createState() => _HistoryScreenState();
}

class _HistoryScreenState extends ConsumerState<HistoryScreen> {
  @override
  void initState() {
    super.initState();
    // 購入履歴を取得
    Future.microtask(() async {
      await ref.read(historyItemListProvider.notifier).fetchPurchasedItems(ref);
    });
  }

  @override
  Widget build(BuildContext context) {
    final l10n = L10n.of(context);
    final textController = TextEditingController();
    final items = ref.watch(historyItemListProvider);

    return SingleChildScrollView(
      child: Container(
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.surface,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: Colors.grey, width: 1), // グレーの枠線を追加
        ),
        padding: const EdgeInsets.all(16),
        child: Column(
          spacing: 16,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Icon(Icons.history, size: 30),
                const SizedBox(width: 16),
                Text(
                  l10n.history_screen_title,
                  // style: Theme.of(context).textTheme.headlineSmall!.copyWith(
                  //   color: Colors.black,
                  //   fontWeight: FontWeight.bold,
                  // ),
                  style: Theme.of(context).textTheme.sampleTextStyle,
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
                  child: DropdownButtonFormField<String>(
                    value: null,
                    items: const [
                      DropdownMenuItem(value: 'option1', child: Text('プルダウン1')),
                      DropdownMenuItem(value: 'option2', child: Text('プルダウン2')),
                    ],
                    onChanged: (value) {},
                    decoration: const InputDecoration(
                      labelText: 'コンビニ',
                      border: OutlineInputBorder(),
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                // 商品名
                Expanded(
                  child: DropdownButtonFormField<String>(
                    value: null,
                    items: const [
                      DropdownMenuItem(value: 'optionA', child: Text('プルダウンA')),
                      DropdownMenuItem(value: 'optionB', child: Text('プルダウンB')),
                    ],
                    onChanged: (value) {},
                    decoration: const InputDecoration(
                      labelText: 'カテゴリ',
                      border: OutlineInputBorder(),
                    ),
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
                return HistoryItem(item: items[index]);
              },
            ),
          ],
        ),
      ),
    );
  }
}
