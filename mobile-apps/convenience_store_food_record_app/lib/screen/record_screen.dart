import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:convenience_store_food_record_app/l10n/app_localizations.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import '../providers/image_picker_provider.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class RecordScreen extends ConsumerWidget {
  const RecordScreen({super.key});

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

  Future<void> _uploadImageToR2(BuildContext context, WidgetRef ref) async {
    final imagePath = ref.read(imagePickerProvider);
    if (imagePath == null) return;
    final fileName = imagePath.split('/').last;
    final url = await ref
        .read(imagePickerProvider.notifier)
        .uploadToR2(filePath: imagePath, fileName: fileName);
    if (url != null) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('画像アップロード成功: $url')));
    } else {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('画像アップロード失敗')));
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = L10n.of(context);
    final imagePath = ref.watch(imagePickerProvider);
    final itemNameTextEditingController = TextEditingController();
    final priceTextEditingController = TextEditingController();
    final memoTextEditingController = TextEditingController();

    return SingleChildScrollView(
      child: Container(
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.surface,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: Colors.grey, width: 1),
        ),
        padding: const EdgeInsets.all(16),
        child: Column(
          spacing: 16,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Icon(Icons.add, size: 30),
                const SizedBox(width: 4),
                Text(
                  l10n.record_screen_title,
                  style: Theme.of(context).textTheme.headlineSmall!.copyWith(
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            // 商品写真
            Column(
              children: [
                Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    l10n.item_photo_name,
                    style: Theme.of(
                      context,
                    ).textTheme.bodyLarge!.copyWith(color: Colors.black),
                  ),
                ),
                const SizedBox(height: 8),
                GestureDetector(
                  onTap: () => _showImageSourceActionSheet(context, ref),
                  child: Container(
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: Colors.grey[200],
                      border: Border.all(color: Colors.grey),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    padding: const EdgeInsets.all(32),
                    child: imagePath == null
                        ? Column(
                            children: [
                              Icon(
                                Icons.add_a_photo,
                                size: 48,
                                color: Colors.grey,
                              ),
                              Text(
                                l10n.description_upload_or_take_a_photo,
                                style: Theme.of(context).textTheme.bodyLarge!
                                    .copyWith(color: Colors.black),
                              ),
                            ],
                          )
                        : ClipRRect(
                            borderRadius: BorderRadius.circular(8),
                            child: Image.file(
                              File(imagePath),
                              fit: BoxFit.cover,
                              width: double.infinity,
                              height: 160,
                            ),
                          ),
                  ),
                ),
              ],
            ),
            // 商品名
            Column(
              spacing: 8,
              children: [
                Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    "${l10n.item_name} *",
                    style: Theme.of(
                      context,
                    ).textTheme.bodyLarge!.copyWith(color: Colors.black),
                  ),
                ),
                TextField(
                  controller: itemNameTextEditingController,
                  decoration: InputDecoration(
                    hintText: l10n.item_name_record_input_hint_text,
                    border: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.grey),
                    ),
                  ),
                ),
              ],
            ),
            // コンビニ
            Column(
              spacing: 8,
              children: [
                Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    "${l10n.item_convenience_store_name} *",
                    style: Theme.of(
                      context,
                    ).textTheme.bodyLarge!.copyWith(color: Colors.black),
                  ),
                ),
                DropdownButtonFormField<String>(
                  value: null,
                  items: const [
                    DropdownMenuItem(value: 'seven', child: Text('セブンイレブン')),
                    DropdownMenuItem(value: 'lawson', child: Text('ローソン')),
                    DropdownMenuItem(
                      value: 'familymart',
                      child: Text('ファミリーマート'),
                    ),
                    DropdownMenuItem(value: 'ministop', child: Text('ミニストップ')),
                    DropdownMenuItem(value: 'other', child: Text('その他')),
                  ],
                  onChanged: (value) {
                    // 必要に応じて状態管理を追加
                  },
                  decoration: InputDecoration(
                    border: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.grey),
                    ),
                  ),
                  hint: Text(l10n.convenience_store_record_input_hint_text),
                ),
              ],
            ),
            // カテゴリ
            Column(
              spacing: 8,
              children: [
                Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    "${l10n.category_name} *",
                    style: Theme.of(
                      context,
                    ).textTheme.bodyLarge!.copyWith(color: Colors.black),
                  ),
                ),
                DropdownButtonFormField<String>(
                  value: null,
                  items: const [
                    DropdownMenuItem(value: 'seven', child: Text('おにぎり')),
                    DropdownMenuItem(value: 'lawson', child: Text('パン')),
                    DropdownMenuItem(value: 'familymart', child: Text('弁当')),
                    DropdownMenuItem(value: 'ministop', child: Text('デザート')),
                    DropdownMenuItem(value: 'ministop', child: Text('飲み物')),
                    DropdownMenuItem(value: 'other', child: Text('その他')),
                  ],
                  onChanged: (value) {
                    // 必要に応じて状態管理を追加
                  },
                  decoration: InputDecoration(
                    border: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.grey),
                    ),
                  ),
                  hint: Text(l10n.category_record_input_hint_text),
                ),
              ],
            ),
            // 金額
            Column(
              spacing: 8,
              children: [
                Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    "${l10n.price_name} *",
                    style: Theme.of(
                      context,
                    ).textTheme.bodyLarge!.copyWith(color: Colors.black),
                  ),
                ),
                TextField(
                  controller: priceTextEditingController,
                  decoration: InputDecoration(
                    hintText: l10n.price_record_input_hint_text,
                    border: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.grey),
                    ),
                  ),
                ),
              ],
            ),
            // メモ
            Column(
              spacing: 8,
              children: [
                Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    l10n.memo_name,
                    style: Theme.of(
                      context,
                    ).textTheme.bodyLarge!.copyWith(color: Colors.black),
                  ),
                ),
                TextField(
                  controller: memoTextEditingController,
                  maxLines: 3,
                  decoration: InputDecoration(
                    hintText: l10n.memo_record_input_hint_text,
                    border: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.grey),
                    ),
                  ),
                ),
              ],
            ),
            // 保存ボタン
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.black,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                onPressed: () {
                  _uploadImageToR2(context, ref);
                },
                child: Text(l10n.record_button_text),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
