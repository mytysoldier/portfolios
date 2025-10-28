import 'dart:io';

import 'package:convenience_store_food_record_app/l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:minio/minio.dart';

class ImagePickerNotifier extends StateNotifier<String?> {
  static const int _maxImageSizeInBytes = 5 * 1024 * 1024; // 5 MB

  Future<void> pickImage(
    BuildContext context,
    ImageSource source,
    void Function(String path)? onImagePathChanged,
  ) async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: source);
    if (pickedFile != null) {
      final file = File(pickedFile.path);
      final fileSize = await file.length();
      if (fileSize > _maxImageSizeInBytes) {
        if (!context.mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(L10n.of(context).error_image_too_large)),
        );
        return;
      }
      setImagePath(pickedFile.path);
      if (onImagePathChanged != null) {
        onImagePathChanged(pickedFile.path);
      }
    }
  }

  void showImageSourceActionSheet(
    BuildContext context, {
    void Function(String path)? onImagePathChanged,
  }) {
    final l10n = L10n.of(context);
    final parentContext = context;
    showModalBottomSheet(
      context: parentContext,
      builder: (sheetContext) => SafeArea(
        child: Wrap(
          children: [
            ListTile(
              leading: const Icon(Icons.photo_camera),
              title: Text(l10n.photo_from_camera),
              onTap: () {
                Navigator.pop(sheetContext);
                pickImage(
                  parentContext,
                  ImageSource.camera,
                  onImagePathChanged,
                );
              },
            ),
            ListTile(
              leading: const Icon(Icons.photo_library),
              title: Text(l10n.photo_from_folder),
              onTap: () {
                Navigator.pop(sheetContext);
                pickImage(
                  parentContext,
                  ImageSource.gallery,
                  onImagePathChanged,
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  ImagePickerNotifier() : super(null);

  void setImagePath(String? path) {
    state = path;
  }

  void clear() {
    state = null;
  }

  Future<String?> uploadToR2({
    required String filePath,
    required String fileName,
  }) async {
    final accessKey = dotenv.env['CLOUD_R2_ACCESS_KEY'] ?? '';
    final secretKey = dotenv.env['CLOUD_R2_SECRET_KEY'] ?? '';
    final endpoint = dotenv.env['CLOUD_R2_ENDPOINT'] ?? '';
    final file = File(filePath);
    if (!file.existsSync()) return null;
    final bytes = await file.readAsBytes();

    final minio = Minio(
      endPoint: endpoint,
      accessKey: accessKey,
      secretKey: secretKey,
      region: 'us-east-1',
      useSSL: true,
    );
    await minio.putObject(
      'convenience-store-food-record',
      fileName,
      Stream.value(bytes),
      metadata: {'Content-Type': 'image/jpeg'},
    );
    return '$endpoint/convenience-store-food-record/$fileName';
  }

  /// Cloudflare R2から画像データ（バイト列）を取得
  Future<List<int>?> fetchImageFromR2(String fileName) async {
    if (fileName.isEmpty) return null;
    final accessKey = dotenv.env['CLOUD_R2_ACCESS_KEY'] ?? '';
    final secretKey = dotenv.env['CLOUD_R2_SECRET_KEY'] ?? '';
    final endpoint = dotenv.env['CLOUD_R2_ENDPOINT'] ?? '';
    final minio = Minio(
      endPoint: endpoint,
      accessKey: accessKey,
      secretKey: secretKey,
      region: 'us-east-1',
      useSSL: true,
    );
    final stream = await minio.getObject(
      'convenience-store-food-record',
      fileName,
    );
    return await stream.expand((x) => x).toList();
  }
}

final imagePickerProvider = StateNotifierProvider<ImagePickerNotifier, String?>(
  (ref) => ImagePickerNotifier(),
);
