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
import 'package:image_picker/image_picker.dart';
import '../../providers/image_picker_provider.dart';
import '../../providers/record_item_provider.dart';
import '../../models/record_item_model.dart';
import 'package:convenience_store_food_record_app/providers/history_item_provider.dart';

class RecordScreen extends ConsumerStatefulWidget {
  const RecordScreen({super.key});

  @override
  ConsumerState<RecordScreen> createState() => _RecordScreenState();
}

class _RecordScreenState extends ConsumerState<RecordScreen> {
  String? selectedStoreId;
  String? selectedCategoryId;
  late final TextEditingController itemNameTextEditingController;
  late final TextEditingController priceTextEditingController;
  late final TextEditingController memoTextEditingController;
  @override
  void initState() {
    super.initState();
    itemNameTextEditingController = TextEditingController();
    priceTextEditingController = TextEditingController();
    memoTextEditingController = TextEditingController();
  }

  @override
  void dispose() {
    itemNameTextEditingController.dispose();
    priceTextEditingController.dispose();
    memoTextEditingController.dispose();
    super.dispose();
  }

  Future<void> _pickImage(
    BuildContext context,
    WidgetRef ref,
    ImageSource source,
  ) async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: source);
    if (pickedFile != null) {
      ref.read(imagePickerProvider.notifier).setImagePath(pickedFile.path);
    }
  }

  void _showImageSourceActionSheet(BuildContext context, WidgetRef ref) {
    showModalBottomSheet(
      context: context,
      builder: (context) => SafeArea(
        child: Wrap(
          children: [
            ListTile(
              leading: const Icon(Icons.photo_camera),
              title: const Text('カメラで撮影'),
              onTap: () {
                Navigator.pop(context);
                _pickImage(context, ref, ImageSource.camera);
              },
            ),
            ListTile(
              leading: const Icon(Icons.photo_library),
              title: const Text('フォルダから選択'),
              onTap: () {
                Navigator.pop(context);
                _pickImage(context, ref, ImageSource.gallery);
              },
            ),
          ],
        ),
      ),
    );
  }

  @override
  @override
  Widget build(BuildContext context) {
    final ref = this.ref;
    final l10n = L10n.of(context);
    final imagePath = ref.watch(imagePickerProvider);
    // TextEditingControllerはStateで管理

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
              imagePath: imagePath,
              onTap: () => _showImageSourceActionSheet(context, ref),
            ),
            // 商品名
            ItemNameInput(controller: itemNameTextEditingController),
            // コンビニ
            StoreDropdown(
              value: selectedStoreId,
              onChanged: (value) {
                setState(() {
                  selectedStoreId = value;
                });
              },
            ),
            // カテゴリ
            CategoryDropdown(
              value: selectedCategoryId,
              onChanged: (value) {
                setState(() {
                  selectedCategoryId = value;
                });
              },
            ),
            // 金額
            PriceInput(controller: priceTextEditingController),
            // メモ
            MemoInput(controller: memoTextEditingController),
            // 保存ボタン
            CustomButton(
              text: l10n.record_button_text,
              onPressed: () async {
                // 画像アップロード
                final imagePath = ref.read(imagePickerProvider);
                String imageUrl = '';
                if (imagePath != null) {
                  final fileName = imagePath.split('/').last;
                  await ref
                      .read(imagePickerProvider.notifier)
                      .uploadToR2(filePath: imagePath, fileName: fileName);
                  final idx = imagePath.indexOf('image_picker');
                  imageUrl = idx >= 0 ? imagePath.substring(idx) : fileName;
                }
                // 入力値取得
                final productName = itemNameTextEditingController.text;
                final price =
                    int.tryParse(priceTextEditingController.text) ?? 0;
                final memo = memoTextEditingController.text;
                // storeId, categoryIdは選択値を使用
                final storeId = int.tryParse(selectedStoreId ?? '') ?? 0;
                final categoryId = int.tryParse(selectedCategoryId ?? '') ?? 0;
                final purchaseDate = DateTime.now();
                // RecordItemProviderにセット
                ref
                    .read(recordItemProvider.notifier)
                    .setItem(
                      RecordItemModel(
                        imageUrl: imageUrl,
                        productName: productName,
                        storeId: storeId,
                        categoryId: categoryId,
                        memo: memo,
                        price: price,
                        purchaseDate: purchaseDate,
                      ),
                    );
                // Supabase登録
                await ref.read(recordItemProvider.notifier).register();
                // 履歴リストを再取得
                await ref
                    .read(historyItemListProvider.notifier)
                    .fetchPurchasedItems(ref);
                if (context.mounted) {
                  ScaffoldMessenger.of(
                    context,
                  ).showSnackBar(const SnackBar(content: Text('登録完了')));
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}
