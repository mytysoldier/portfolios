import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frontend/models/record.dart';

class RecordListState extends StateNotifier<AsyncValue<List<Record>>> {
  RecordListState(super.state);
}
