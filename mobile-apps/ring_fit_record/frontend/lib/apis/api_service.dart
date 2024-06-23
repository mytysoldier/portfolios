import 'dart:convert';

import 'package:frontend/models/record.dart';
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
