import 'dart:typed_data';
import 'package:convenience_store_food_record_app/models/history_item_model.dart';
import 'package:convenience_store_food_record_app/providers/image_cache_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:convenience_store_food_record_app/providers/image_picker_provider.dart';
import 'package:convenience_store_food_record_app/components/history_screen/history_item.dart';

class HistoryList extends ConsumerWidget {
  final List<HistoryItemModel> items;
  const HistoryList({super.key, required this.items});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: items.length,
      itemBuilder: (context, index) {
        final item = items[index];
        final imageCache = ref.watch(imageCacheProvider);
        final imageId = item.id.toString();
        final cachedBytes = imageCache[imageId];

        if (cachedBytes != null) {
          return HistoryItem(
            item: item,
            imageBytes: cachedBytes,
            isLoading: false,
          );
        }

        return FutureBuilder<List<int>?>(
          future: ref
              .read(imagePickerProvider.notifier)
              .fetchImageFromR2(item.imageUrl),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return HistoryItem(item: item, imageBytes: null, isLoading: true);
            }
            if (snapshot.hasError || snapshot.data == null) {
              return HistoryItem(
                item: item,
                imageBytes: null,
                isLoading: false,
              );
            }
            final bytes = Uint8List.fromList(snapshot.data!);
            // キャッシュに保存（フレーム後に実行）
            WidgetsBinding.instance.addPostFrameCallback((_) {
              ref.read(imageCacheProvider.notifier).add(imageId, bytes);
            });
            return HistoryItem(item: item, imageBytes: bytes, isLoading: false);
          },
        );
      },
    );
  }
}
