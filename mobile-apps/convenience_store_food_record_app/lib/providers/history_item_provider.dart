import 'package:convenience_store_food_record_app/providers/user_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/history_item_model.dart';
import '../providers/store_master_provider.dart';
import '../providers/category_master_provider.dart';

class HistoryItemListNotifier extends StateNotifier<List<HistoryItemModel>> {
  HistoryItemListNotifier() : super([]);

  void addItem(HistoryItemModel item) {
    state = [...state, item];
  }

  void removeItem(int index) {
    state = List.of(state)..removeAt(index);
  }

  void clear() {
    state = [];
  }

  Future<void> fetchPurchasedItems(WidgetRef ref) async {
    final supabase = Supabase.instance.client;
    await ref.read(storeMasterProvider.notifier).fetch();
    await ref.read(categoryMasterProvider.notifier).fetch();
    final storeMap = ref.read(storeMasterProvider);
    final categoryMap = ref.read(categoryMasterProvider);
    final user = ref.read(userProvider);
    if (user == null) return; // ユーザー未取得時は何もしない

    final response = await supabase
        .from('purchase_history')
        .select()
        .eq('user_id', user.id);
    state = response
        .map(
          (item) => HistoryItemModel(
            id: item['id'] ?? 0,
            imageUrl: item['item_img'] ?? '',
            productName: item['item_name'] ?? '',
            storeName: storeMap[item['store_id']] ?? '',
            category: categoryMap[item['category_id']] ?? '',
            memo: item['memo'] ?? '',
            price: item['price'] ?? 0,
            purchaseDate:
                DateTime.tryParse(item['purchase_date'] ?? '') ??
                DateTime.now(),
          ),
        )
        .toList();
  }
}

final historyItemListProvider =
    StateNotifierProvider<HistoryItemListNotifier, List<HistoryItemModel>>(
      (ref) => HistoryItemListNotifier(),
    );
