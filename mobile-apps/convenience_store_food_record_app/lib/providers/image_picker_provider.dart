import 'package:flutter_riverpod/flutter_riverpod.dart';

class ImagePickerNotifier extends StateNotifier<String?> {
  ImagePickerNotifier() : super(null);

  void setImagePath(String? path) {
    state = path;
  }

  void clear() {
    state = null;
  }
}

final imagePickerProvider = StateNotifierProvider<ImagePickerNotifier, String?>(
  (ref) => ImagePickerNotifier(),
);
