import 'dart:typed_data';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ImageCacheNotifier extends StateNotifier<Map<String, Uint8List>> {
  ImageCacheNotifier() : super({});

  void add(String key, Uint8List bytes) {
    state = {...state, key: bytes};
  }

  Uint8List? get(String key) {
    return state[key];
  }

  void remove(String key) {
    final newState = {...state}..remove(key);
    state = newState;
  }

  void clear() {
    state = {};
  }
}

final imageCacheProvider =
    StateNotifierProvider<ImageCacheNotifier, Map<String, Uint8List>>(
      (ref) => ImageCacheNotifier(),
    );
