import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frontend/models/record.dart';

class InputRecordNotifier extends StateNotifier<Record> {
  InputRecordNotifier()
      : super(Record(
          attachment: '',
          comfort: '',
          memo: '',
          createdAt: DateTime.now(),
        ));

  void updateAttachment(String attachment) {
    state = Record(
      attachment: attachment,
      comfort: state.comfort,
      memo: state.memo,
      createdAt: state.createdAt,
    );
  }

  void updateComfort(String comfort) {
    state = Record(
      attachment: state.attachment,
      comfort: comfort,
      memo: state.memo,
      createdAt: state.createdAt,
    );
  }

  void updateMemo(String memo) {
    state = Record(
      attachment: state.attachment,
      comfort: state.comfort,
      memo: memo,
      createdAt: state.createdAt,
    );
  }

  void updateCreatedAt(DateTime createdAt) {
    state = Record(
      attachment: state.attachment,
      comfort: state.comfort,
      memo: state.memo,
      createdAt: createdAt,
    );
  }
}

// レコード入力状態を管理
final inputRecordProvider =
    StateNotifierProvider<InputRecordNotifier, Record>((ref) {
  return InputRecordNotifier();
});
