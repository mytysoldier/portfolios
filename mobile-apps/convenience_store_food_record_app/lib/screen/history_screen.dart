import 'package:convenience_store_food_record_app/components/texttheme/custom_texttheme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:convenience_store_food_record_app/l10n/app_localizations.dart';

class HistoryScreen extends ConsumerWidget {
  const HistoryScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = L10n.of(context);
    final textController = TextEditingController();

    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.grey, width: 1), // グレーの枠線を追加
      ),
      padding: const EdgeInsets.all(16),
      child: Column(
        // mainAxisAlignment: MainAxisAlignment.center,
        spacing: 16,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Icon(Icons.history, size: 30),
              const SizedBox(width: 16),
              Text(
                l10n.history_screen_title,
                style: Theme.of(context).textTheme.headlineSmall!.copyWith(
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          // フリーテキストで検索
          TextField(
            controller: textController,
            decoration: InputDecoration(
              labelText: l10n.history_search_input_hint_text,
              border: OutlineInputBorder(),
              prefixIcon: Icon(Icons.search),
            ),
          ),
          // プルダウンで検索
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // コンビニ名
              Expanded(
                child: DropdownButtonFormField<String>(
                  value: null,
                  items: const [
                    DropdownMenuItem(value: 'option1', child: Text('プルダウン1')),
                    DropdownMenuItem(value: 'option2', child: Text('プルダウン2')),
                  ],
                  onChanged: (value) {},
                  decoration: const InputDecoration(
                    labelText: 'カテゴリ',
                    border: OutlineInputBorder(),
                  ),
                ),
              ),
              const SizedBox(width: 16),
              // 商品名
              Expanded(
                child: DropdownButtonFormField<String>(
                  value: null,
                  items: const [
                    DropdownMenuItem(value: 'optionA', child: Text('プルダウンA')),
                    DropdownMenuItem(value: 'optionB', child: Text('プルダウンB')),
                  ],
                  onChanged: (value) {},
                  decoration: const InputDecoration(
                    labelText: '並び順',
                    border: OutlineInputBorder(),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
