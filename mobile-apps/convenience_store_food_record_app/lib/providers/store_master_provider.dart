import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class StoreMasterNotifier extends StateNotifier<Map<int, String>> {
  StoreMasterNotifier() : super({});

  Future<void> fetch() async {
    final supabase = Supabase.instance.client;
    final storeList = await supabase.from('store_master').select();
    state = {
      for (var s in storeList) s['id'] as int: s['store_name'] as String,
    };
  }
}

final storeMasterProvider =
    StateNotifierProvider<StoreMasterNotifier, Map<int, String>>(
      (ref) => StoreMasterNotifier(),
    );
