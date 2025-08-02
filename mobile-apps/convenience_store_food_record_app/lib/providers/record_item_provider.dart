import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/record_item_model.dart';

class RecordItemNotifier extends StateNotifier<RecordItemModel?> {
  RecordItemNotifier() : super(null);

  void setItem(RecordItemModel item) {
    state = item;
  }

  void clear() {
    state = null;
  }

  Future<void> register() async {
    if (state == null) return;
    final supabase = Supabase.instance.client;
    await supabase.from('purchase_history').insert({
      'user_id': 1,
      'item_img': state!.imageUrl,
      'item_name': state!.productName,
      'store_id': state!.storeId,
      'category_id': state!.categoryId,
      'memo': state!.memo,
      'price': state!.price,
      'purchase_date': state!.purchaseDate.toIso8601String(),
    });
  }
}

final recordItemProvider =
    StateNotifierProvider<RecordItemNotifier, RecordItemModel?>(
      (ref) => RecordItemNotifier(),
    );
