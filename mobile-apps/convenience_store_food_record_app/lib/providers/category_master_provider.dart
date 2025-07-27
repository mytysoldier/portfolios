import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

final categoryMasterProvider = FutureProvider<Map<int, String>>((ref) async {
  final supabase = Supabase.instance.client;
  final categoryList = await supabase.from('category_master').select();
  return {
    for (var c in categoryList) c['id'] as int: c['category_name'] as String,
  };
});
