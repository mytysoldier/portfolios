import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:convenience_store_food_record_app/l10n/app_localizations.dart';
import 'dart:io';
import 'package:minio/minio.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class ImagePickerNotifier extends StateNotifier<String?> {
  Future<void> pickImage(BuildContext context, ImageSource source) async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: source);
    if (pickedFile != null) {
      setImagePath(pickedFile.path);
    }
  }

  void showImageSourceActionSheet(BuildContext context) {
    final l10n = L10n.of(context);
    showModalBottomSheet(
      context: context,
      builder: (context) => SafeArea(
        child: Wrap(
          children: [
            ListTile(
              leading: const Icon(Icons.photo_camera),
              title: Text(l10n.photo_from_camera),
              onTap: () {
                Navigator.pop(context);
                pickImage(context, ImageSource.camera);
              },
            ),
            ListTile(
              leading: const Icon(Icons.photo_library),
              title: Text(l10n.photo_from_folder),
              onTap: () {
                Navigator.pop(context);
                pickImage(context, ImageSource.gallery);
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
