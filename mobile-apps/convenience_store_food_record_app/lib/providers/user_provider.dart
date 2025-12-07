import 'dart:io';

import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart' hide User;

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
  /// アカウント削除
  Future<String?> deleteAccount() async {
    if (state == null) return 'ユーザーが未ログインです';
    final supabase = Supabase.instance.client;
    try {
      await supabase.from('user').delete().eq('id', state!.id);
      clearUser();
      return null;
    } catch (e) {
      print('アカウント削除失敗: $e');
      return 'アカウントの削除に失敗しました';
    }
  }

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

  Future<String?> registerUser(String userName, String password) async {
    try {
      String deviceId = await getDeviceId();
      final supabase = Supabase.instance.client;
      final response = await supabase.functions.invoke(
        'create_user',
        body: {
          'userName': userName,
          'password': password,
          'deviceId': deviceId,
        },
      );
      final data = response.data;
      if (response.status == 409) {
        return 'このユーザー名は既に使われています';
      }
      if (response.status != 200 && response.status != 201) {
        return data?['error'] ?? 'ユーザー登録に失敗しました';
      }
      // 成功時はfetchUserで最新ユーザー情報を取得
      await fetchUser();
      return null;
    } catch (e) {
      print('ユーザー登録失敗: $e');
      clearUser();
      return 'エラーが発生しました。時間をおいてもう一度お試しください。';
    }
  }

  /// ユーザー名を更新する
  Future<String?> updateUserName(String newUserName) async {
    if (state == null) return 'ユーザーが未ログインです';
    final supabase = Supabase.instance.client;
    try {
      await supabase
          .from('user')
          .update({'user_name': newUserName})
          .eq('id', state!.id);
      // stateを更新
      state = state!.copyWith(userName: newUserName);
      return null;
    } catch (e) {
      print('ユーザー名更新失敗: $e');
      return 'ユーザー名の更新に失敗しました';
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
