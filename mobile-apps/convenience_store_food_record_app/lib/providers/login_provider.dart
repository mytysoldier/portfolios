import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'dart:convert';
import 'package:convenience_store_food_record_app/models/user.dart';

final loginProvider = Provider<LoginService>((ref) => LoginService());

class LoginService {
  Future<User> login({
    required String userName,
    required String password,
  }) async {
    if (userName.isEmpty || password.isEmpty) {
      throw Exception('ユーザー名とパスワードを入力してください');
    }

    final supabaseUrl = dotenv.env['SUPABASE_URL'];
    final anonKey = dotenv.env['SUPABASE_ANON_KEY'];
    if (supabaseUrl == null || anonKey == null) {
      throw Exception('環境変数が設定されていません');
    }
    final url = Uri.parse('$supabaseUrl/functions/v1/username_login');
    final response = await http.post(
      url,
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $anonKey',
      },
      body: '{"userName":"$userName","password":"$password"}',
    );

    if (response.statusCode == 200) {
      final Map<String, dynamic> json = response.body.isNotEmpty
          ? Map<String, dynamic>.from(jsonDecode(response.body))
          : {};
      if (json['user'] == null) {
        throw Exception('ユーザー情報が取得できませんでした');
      }
      return User.fromJson(json['user'] as Map<String, dynamic>);
    } else {
      final error = response.body;
      throw Exception('ログイン失敗: $error');
    }
  }

  Future<void> resetPassword({
    required String userName,
    required String newPassword,
  }) async {
    if (userName.isEmpty || newPassword.isEmpty) {
      throw Exception('ユーザー名と新しいパスワードを入力してください');
    }

    final supabaseUrl = dotenv.env['SUPABASE_URL'];
    final anonKey = dotenv.env['SUPABASE_ANON_KEY'];
    if (supabaseUrl == null || anonKey == null) {
      throw Exception('環境変数が設定されていません');
    }
    final url = Uri.parse('$supabaseUrl/functions/v1/reset_password');
    final response = await http.post(
      url,
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $anonKey',
      },
      body: jsonEncode({'userName': userName, 'newPassword': newPassword}),
    );

    final Map<String, dynamic> json = response.body.isNotEmpty
        ? Map<String, dynamic>.from(jsonDecode(response.body))
        : {};

    if (response.statusCode == 200 && json['success'] == true) {
      return;
    } else {
      final error = json['error'] ?? response.body;
      throw Exception('パスワードリセット失敗: $error');
    }
  }
}
