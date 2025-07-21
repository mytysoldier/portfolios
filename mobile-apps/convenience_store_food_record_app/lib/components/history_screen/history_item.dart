import 'package:flutter/material.dart';
import '../../models/history_item_model.dart';

class HistoryItem extends StatelessWidget {
  final HistoryItemModel item;
  const HistoryItem({super.key, required this.item});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 0),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: Image.network(
                item.imageUrl,
                width: 64,
                height: 64,
                fit: BoxFit.cover,
                errorBuilder: (c, e, s) => Container(
                  width: 64,
                  height: 64,
                  color: Colors.grey[300],
                  child: const Icon(Icons.image_not_supported),
                ),
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        item.productName,
                        style: Theme.of(context).textTheme.titleMedium,
                        overflow: TextOverflow.ellipsis,
                      ),
                      Text(
                        '￥${item.price}',
                        style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                          color: Colors.green,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),
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
                                  size: 16,
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
                                  size: 16,
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
                                  size: 16,
                                  color: Colors.grey[700],
                                ),
                                const SizedBox(width: 4),
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
                  const SizedBox(height: 4),
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
