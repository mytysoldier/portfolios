import 'package:convenience_store_food_record_app/components/network/loading_indicator.dart';
import 'package:convenience_store_food_record_app/providers/image_cache_provider.dart';
import 'package:convenience_store_food_record_app/theme/main_theme.dart';
import 'package:flutter/material.dart';
import 'dart:typed_data';
import '../../models/history_item_model.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:convenience_store_food_record_app/providers/record_item_provider.dart';

class HistoryItem extends ConsumerWidget {
  final HistoryItemModel item;
  final Uint8List? imageBytes;
  final bool isLoading;
  const HistoryItem({
    super.key,
    required this.item,
    this.imageBytes,
    this.isLoading = false,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Card(
      margin: const EdgeInsets.symmetric(
        vertical: AppSizes.spacingS,
        horizontal: 0,
      ),
      child: Padding(
        padding: const EdgeInsets.all(AppSizes.spacingS + AppSizes.spacingXS),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: isLoading
                  ? Container(
                      width: 64,
                      height: 64,
                      color: Colors.grey[300],
                      child: const Center(
                        child: CircularProgressIndicator(strokeWidth: 2),
                      ),
                    )
                  : (imageBytes == null
                        ? LoadingIndicator()
                        : Image.memory(
                            imageBytes!,
                            width: 64,
                            height: 64,
                            fit: BoxFit.cover,
                          )),
            ),
            const SizedBox(width: AppSizes.spacingM),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          item.productName,
                          style: Theme.of(context).textTheme.titleMedium,
                          overflow: TextOverflow.ellipsis,
                          maxLines: 2,
                          softWrap: true,
                        ),
                      ),
                      const SizedBox(width: 8),
                      SizedBox(
                        width: 70,
                        child: Text(
                          '￥${item.price}',
                          style: Theme.of(context).textTheme.bodyLarge!
                              .copyWith(
                                color: Colors.green,
                                fontWeight: FontWeight.bold,
                              ),
                          overflow: TextOverflow.ellipsis,
                          maxLines: 1,
                          textAlign: TextAlign.right,
                        ),
                      ),
                      const SizedBox(width: 8),
                      SizedBox(
                        width: 40,
                        child: Align(
                          alignment: Alignment.centerRight,
                          child: IconButton(
                            icon: const Icon(Icons.delete, color: Colors.red),
                            tooltip: '削除',
                            onPressed: () async {
                              await ref
                                  .read(recordFormProvider.notifier)
                                  .deleteRecord(
                                    id: item.id,
                                    context: context,
                                    ref: ref,
                                  );
                              // 画像キャッシュも削除
                              final imageId = item.id.toString();
                              ref
                                  .read(imageCacheProvider.notifier)
                                  .remove(imageId);
                            },
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: AppSizes.spacingXS),
                  // 2行目：storeName, category, purchaseDateを縦並びで表示
                  Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Icon(
                                  Icons.store,
                                  size: AppSizes.iconSize,
                                  color: Colors.grey[700],
                                ),
                                const SizedBox(width: 4),
                                Flexible(
                                  child: Text(
                                    item.storeName,
                                    style: Theme.of(
                                      context,
                                    ).textTheme.bodySmall,
                                    overflow: TextOverflow.visible,
                                    softWrap: true,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Icon(
                                  Icons.category,
                                  size: AppSizes.iconSize,
                                  color: Colors.grey[700],
                                ),
                                const SizedBox(width: 4),
                                Flexible(
                                  child: Text(
                                    item.category,
                                    style: Theme.of(
                                      context,
                                    ).textTheme.bodySmall,
                                    overflow: TextOverflow.visible,
                                    softWrap: true,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Icon(
                                  Icons.calendar_today,
                                  size: AppSizes.iconSize,
                                  color: Colors.grey[700],
                                ),
                                const SizedBox(width: AppSizes.spacingXS),
                                Flexible(
                                  child: Text(
                                    '${item.purchaseDate.year}/${item.purchaseDate.month}/${item.purchaseDate.day}',
                                    style: Theme.of(
                                      context,
                                    ).textTheme.bodySmall,
                                    overflow: TextOverflow.visible,
                                    softWrap: true,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: AppSizes.spacingXS),
                  Text(item.memo, style: Theme.of(context).textTheme.bodySmall),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
