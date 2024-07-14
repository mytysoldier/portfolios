import 'dart:convert';

import 'package:frontend/models/record.dart';
import 'package:frontend/models/user_info.dart';
import 'package:http/http.dart' as http;

// 記録履歴取得
Future<List<Record>> fetchRecords() async {
  final response = await http.get(Uri.parse('http://localhost:8080/records'));

  if (response.statusCode == 200) {
    Map<String, dynamic> jsonData = jsonDecode(response.body);
    List<dynamic> recordsJson = jsonData['records'];
    return recordsJson.map((json) => Record.fromJson(json)).toList();
  } else {
    throw Exception('Failed to load records');
  }
}

// ユーザー情報取得
Future<UserInfo> fetchUserInfo() async {
  final response = await http
      .get(Uri.parse('http://localhost:8080/user/nZDt9rrkrDpImT8rso0B'));

  if (response.statusCode == 200) {
    Map<String, dynamic> jsonData = jsonDecode(response.body);
    dynamic userJson = jsonData['user'];
    return UserInfo.fromJson(userJson);
  } else {
    throw Exception('Failed to load user info');
  }
}

// ユーザー情報更新
Future<UserInfo> updateUserInfo(UserInfo user) async {
  final response = await http.post(
    Uri.parse('http://localhost:8080/user/nZDt9rrkrDpImT8rso0B'),
    headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8'
    },
    body: jsonEncode(user.toJson()),
  );

  if (response.statusCode == 200) {
    Map<String, dynamic> jsonData = jsonDecode(response.body);
    dynamic userJson = jsonData['user'];
    return UserInfo.fromJson(userJson);
  } else {
    throw Exception('Failed to update user info');
  }
}
