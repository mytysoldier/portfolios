import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class CategoryMasterNotifier extends StateNotifier<Map<int, String>> {
  CategoryMasterNotifier() : super({});

  Future<void> fetch() async {
    final supabase = Supabase.instance.client;
    final categoryList = await supabase.from('category_master').select();
    state = {
      for (var c in categoryList) c['id'] as int: c['category_name'] as String,
    };
  }
}

final categoryMasterProvider =
    StateNotifierProvider<CategoryMasterNotifier, Map<int, String>>(
      (ref) => CategoryMasterNotifier(),
    );
