import 'dart:io';

import 'package:device_info_plus/device_info_plus.dart';
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

  Future<void> fetchUser() async {
    final supabase = Supabase.instance.client;
    try {
      String deviceId = await getDeviceId();
      final response = await supabase
          .from('user')
          .select()
          .eq('device_id', deviceId)
          .single();
      setUser(User.fromJson(response));
    } catch (e) {
      clearUser();
      // 必要に応じてログ出力や通知も追加可能
      rethrow;
    }
  }

  /// デバイスIDでUserテーブルにInsert
  Future<void> insertUserWithDeviceId() async {
    final supabase = Supabase.instance.client;
    try {
      String deviceId = await getDeviceId();
      final response = await supabase
          .from('user')
          .insert({'device_id': deviceId})
          .select()
          .single();
      setUser(User.fromJson(response));
    } catch (e) {
      print('UserテーブルへのInsert失敗: $e');
      clearUser();
      // 失敗時はログ出力のみでrethrowしない
    }
  }

  Future<String> getDeviceId() async {
    final deviceInfo = DeviceInfoPlugin();
    if (Platform.isAndroid) {
      final androidInfo = await deviceInfo.androidInfo;
      return androidInfo.id; // Android固有ID
    } else if (Platform.isIOS) {
      final iosInfo = await deviceInfo.iosInfo;
      String? iosDeviceId = iosInfo.identifierForVendor; // iOS固有ID
      if (iosDeviceId == null) {
        throw Exception('iOSデバイスIDの取得に失敗しました');
      }
      return iosDeviceId;
    }
    throw Exception('未対応のプラットフォームです');
  }
}

final userProvider = StateNotifierProvider<UserNotifier, User?>((ref) {
  return UserNotifier();
});
