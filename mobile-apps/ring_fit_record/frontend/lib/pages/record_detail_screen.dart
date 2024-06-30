import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frontend/apis/api_service.dart';
import 'package:frontend/models/record.dart';
import 'package:frontend/providers/record_detail_provider.dart';
import 'package:intl/intl.dart';

class RecordDetailScreen extends ConsumerWidget {
  const RecordDetailScreen({
    super.key,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = L10n.of(context);

    final record = ref.watch(recordDetailProvider);

    final dateformatter = DateFormat('yyyy年M月dd日HH:ss');

    return Column(
      children: [
        Container(
          width: double.infinity,
          height: 40,
          color: Colors.brown,
          alignment: Alignment.center,
          child: Text(
            l10n.recordDetailScreenTitle,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
        ),
        Container(
          width: double.infinity,
          alignment: Alignment.centerLeft,
          padding: const EdgeInsets.all(10),
          child: Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '記録日時：${dateformatter.format(record.createdAt)}',
                  textAlign: TextAlign.start,
                ),
                const SizedBox(height: 10),
                Text('・${l10n.recordDetailItemAttachment}'),
                Text('　${record.attachment}'),
                const SizedBox(height: 10),
                Text('・${l10n.recordDetailItemComfort}'),
                Text('　${record.comfort}'),
                const SizedBox(height: 10),
                Text('・${l10n.recordDetailItemMemo}'),
                Container(
                  decoration: BoxDecoration(
                    border: Border.all(),
                  ),
                  width: double.infinity,
                  height: 62,
                  padding: const EdgeInsets.all(5),
                  child: Text('　${record.memo}'),
                ),
                const SizedBox(height: 50),
                Container(
                  alignment: Alignment.center,
                  child: ElevatedButton(
                    onPressed: () {
                      // TODO 削除処理
                    },
                    style: ElevatedButton.styleFrom(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(0),
                      ),
                      backgroundColor: Colors.black,
                    ),
                    child: Text(
                      l10n.buttonTextRecordDelete,
                      style: const TextStyle(
                          color: Colors.white, fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
        // 以降のAlignウィジェットを画面下部に固定するための領域をスペーサーで確保
        const Spacer(),
        Align(
          alignment: Alignment.bottomCenter,
          child: GestureDetector(
            onTap: () {
              // TODO
              // widget.onSubmit();
            },
            child: Row(
              children: [
                Expanded(
                  flex: 1,
                  child: Container(
                    color: Colors.red,
                    height: 100,
                    child: Center(child: Text('Container 1')),
                  ),
                ),
                Expanded(
                  flex: 1,
                  child: Container(
                    color: Colors.green,
                    height: 100,
                    child: Center(child: Text('Container 2')),
                  ),
                ),
                Expanded(
                  flex: 1,
                  child: Container(
                    color: Colors.blue,
                    height: 100,
                    child: Center(child: Text('Container 3')),
                  ),
                ),
              ],
            ),
          ),
        )
      ],
    );
  }
}
