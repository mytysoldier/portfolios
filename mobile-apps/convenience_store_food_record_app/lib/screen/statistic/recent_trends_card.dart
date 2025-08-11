import 'package:flutter/material.dart';

class RecentTrendsCard extends StatelessWidget {
  final int totalCount;
  final double averageUnitPrice;
  final String totalCountLabel;
  final String averageUnitPriceLabel;
  final TextStyle? valueStyle;

  const RecentTrendsCard({
    super.key,
    required this.totalCount,
    required this.averageUnitPrice,
    required this.totalCountLabel,
    required this.averageUnitPriceLabel,
    this.valueStyle,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Expanded(
              child: Card(
                color: Colors.orange[50],
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(
                        "$totalCount",
                        style:
                            valueStyle?.copyWith(color: Colors.red) ??
                            TextStyle(color: Colors.red),
                      ),
                      const SizedBox(height: 8),
                      Text(totalCountLabel),
                    ],
                  ),
                ),
              ),
            ),
            Expanded(
              child: Card(
                color: Colors.purple[50],
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(
                        "¥${averageUnitPrice.toStringAsFixed(0)}",
                        style:
                            valueStyle?.copyWith(color: Colors.purple) ??
                            TextStyle(color: Colors.purple),
                      ),
                      const SizedBox(height: 8),
                      Text(averageUnitPriceLabel),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
