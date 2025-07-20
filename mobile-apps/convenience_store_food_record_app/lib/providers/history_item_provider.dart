import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/history_item_model.dart';

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
}

final historyItemListProvider =
    StateNotifierProvider<HistoryItemListNotifier, List<HistoryItemModel>>(
      (ref) => HistoryItemListNotifier(),
    );
