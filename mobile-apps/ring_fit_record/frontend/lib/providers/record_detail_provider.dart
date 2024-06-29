import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frontend/models/record.dart';

// レコード詳細画面に表示するレコード情報を管理
final recordDetailProvider = Provider((ref) {
  return Record(
    attachment: '',
    comfort: '',
    memo: '',
    createdAt: DateTime.now(),
  );
});

// レコード詳細画面で現在表示中のレコードの番号を管理
final recordDetailNoProvider = Provider((ref) {
  return 1;
});
