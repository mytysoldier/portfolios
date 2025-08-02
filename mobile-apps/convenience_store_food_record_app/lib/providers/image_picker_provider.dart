import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'dart:io';
import 'package:minio/minio.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class ImagePickerNotifier extends StateNotifier<String?> {
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
