import 'package:convenience_store_food_record_app/screen/record/memo_input.dart';
import 'package:convenience_store_food_record_app/screen/record/category_dropdown.dart';
import 'package:convenience_store_food_record_app/screen/record/price_input.dart';
import 'package:convenience_store_food_record_app/screen/record/store_dropdown.dart';
import 'package:convenience_store_food_record_app/screen/record/item_name_input.dart';
import 'package:convenience_store_food_record_app/screen/record/item_photo_input.dart';
import 'package:convenience_store_food_record_app/components/screen/screen_title.dart';
import 'package:convenience_store_food_record_app/components/button/custom_button.dart';
import 'package:convenience_store_food_record_app/theme/main_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:convenience_store_food_record_app/l10n/app_localizations.dart';
import '../../providers/record_item_provider.dart';

import 'package:convenience_store_food_record_app/components/screen/custom_snack_bar.dart';

class RecordScreen extends ConsumerStatefulWidget {
  const RecordScreen({super.key});

  @override
  ConsumerState<RecordScreen> createState() => _RecordScreenState();
}

class _RecordScreenState extends ConsumerState<RecordScreen> {
  @override
  Widget build(BuildContext context) {
    final ref = this.ref;
    final l10n = L10n.of(context);
    final formState = ref.watch(recordFormProvider);
    final formNotifier = ref.read(recordFormProvider.notifier);

    final itemNameController = TextEditingController(text: formState.itemName);
    final priceController = TextEditingController(text: formState.price);
    final memoController = TextEditingController(text: formState.memo);

    return SingleChildScrollView(
      child: Container(
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.surface,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: Colors.grey, width: AppSizes.spacingXxxs),
        ),
        padding: const EdgeInsets.all(AppSizes.spacingM),
        child: Column(
          spacing: AppSizes.spacingM,
          children: [
            ScreenTitle(icon: Icons.add, title: l10n.record_screen_title),
            // 商品写真
            ItemPhotoInput(
              imagePath: formState.imagePath,
              onImagePathChanged: (path) => formNotifier.setImagePath(path),
            ),
            // 商品名
            ItemNameInput(
              controller: itemNameController,
              onChanged: (value) => formNotifier.setItemName(value),
            ),
            // コンビニ
            StoreDropdown(
              value: formState.storeId,
              onChanged: (value) => formNotifier.setStoreId(value),
            ),
            // カテゴリ
            CategoryDropdown(
              value: formState.categoryId,
              onChanged: (value) => formNotifier.setCategoryId(value),
            ),
            // 金額
            PriceInput(
              controller: priceController,
              onChanged: (value) => formNotifier.setPrice(value),
            ),
            // メモ
            MemoInput(
              controller: memoController,
              onChanged: (value) => formNotifier.setMemo(value),
            ),
            // 保存ボタン
            CustomButton(
              text: l10n.record_button_text,
              onPressed: () async {
                final success = await formNotifier.submit(
                  context: context,
                  ref: ref,
                );
                if (success && context.mounted) {
                  ScaffoldMessenger.of(
                    context,
                  ).showSnackBar(CustomSnackBar.show(message: '登録完了'));
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}
