import 'dart:io';

import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart' hide User;
import 'package:crypto/crypto.dart';
import 'dart:convert';

import '../models/user.dart';

// 入力値保持用State
class UserInputState {
  final String nickname;
  final String password;

  UserInputState({this.nickname = '', this.password = ''});

  UserInputState copyWith({String? nickname, String? password}) {
    return UserInputState(
      nickname: nickname ?? this.nickname,
      password: password ?? this.password,
    );
  }
}

class UserInputNotifier extends StateNotifier<UserInputState> {
  UserInputNotifier() : super(UserInputState());

  void setNickname(String value) => state = state.copyWith(nickname: value);
  void setPassword(String value) => state = state.copyWith(password: value);
  void clear() => state = UserInputState();
}

final userInputProvider =
    StateNotifierProvider<UserInputNotifier, UserInputState>((ref) {
      return UserInputNotifier();
    });

class UserNotifier extends StateNotifier<User?> {
  UserNotifier() : super(null);

  void setUser(User user) {
    state = user;
  }

  void clearUser() {
    state = null;
  }

  void logout() {
    clearUser();
    // 今後、ログアウト時の追加処理があればここに記載
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

  /// ユーザー名・パスワード・device_idでユーザー情報を登録（upsert仕様）
  Future<String?> registerUser(String userName, String password) async {
    final supabase = Supabase.instance.client;
    try {
      String deviceId = await getDeviceId();

      // device_idで既存レコードを検索
      final deviceRecord = await supabase
          .from('user')
          .select()
          .eq('device_id', deviceId)
          .maybeSingle();

      // 他のレコードに同じuser_nameがあればエラー（自分のdevice_id以外）
      final userNameExists = await supabase
          .from('user')
          .select()
          .eq('user_name', userName)
          .neq('device_id', deviceId)
          .maybeSingle();
      if (userNameExists != null) {
        return 'このユーザー名は既に使われています';
      }

      // パスワードをSHA-256変換
      final hashedPassword = sha256.convert(utf8.encode(password)).toString();

      if (deviceRecord != null) {
        // device_idのレコードがあり、user_nameが一致する場合はOK
        if (deviceRecord['user_name'] == userName || deviceRecord['user_name'] == null) {
          final updated = await supabase
              .from('user')
              .update({
                'user_name': userName,
                'password': hashedPassword,
                'updated_at': DateTime.now().toIso8601String(),
              })
              .eq('device_id', deviceId)
              .select()
              .single();
          setUser(User.fromJson(updated));
          return null;
        } else {
          // device_idのレコードがあり、user_nameが異なる場合はエラー
          return 'このデバイスには既に別のユーザー名が登録されています';
        }
      } else {
        // device_id未登録なら新規insert
        final inserted = await supabase
            .from('user')
            .insert({
              'user_name': userName,
              'password': hashedPassword,
              'device_id': deviceId,
              'created_at': DateTime.now().toIso8601String(),
            })
            .select()
            .single();
        setUser(User.fromJson(inserted));
        return null;
      }
    } catch (e) {
      print('ユーザー登録失敗: $e');
      clearUser();
      return 'エラーが発生しました。時間をおいてもう一度お試しください。';
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
