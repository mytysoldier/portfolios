import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

final storeMasterProvider = FutureProvider<Map<int, String>>((ref) async {
  final supabase = Supabase.instance.client;
  final storeList = await supabase.from('store_master').select();
  return {for (var s in storeList) s['id'] as int: s['store_name'] as String};
});
