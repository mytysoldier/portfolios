import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart' hide User;

import '../models/user.dart';

class UserNotifier extends StateNotifier<User?> {
  UserNotifier() : super(null);

  void setUser(User user) {
    state = user;
  }

  void clearUser() {
    state = null;
  }

  Future<void> fetchUser({required int id}) async {
    final supabase = Supabase.instance.client;
    try {
      final response = await supabase
          .from('user')
          .select()
          .eq('id', id)
          .single();
      setUser(User.fromJson(response));
    } catch (e) {
      clearUser();
      // 必要に応じてログ出力や通知も追加可能
      rethrow;
    }
  }
}

final userProvider = StateNotifierProvider<UserNotifier, User?>((ref) {
  return UserNotifier();
});
