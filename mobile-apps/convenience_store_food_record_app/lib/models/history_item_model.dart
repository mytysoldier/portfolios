class HistoryItemModel {
  final int id;
  final String imageUrl;
  final String productName;
  final String storeName;
  final String category;
  final String memo;
  final int price;
  final DateTime purchaseDate;

  HistoryItemModel({
    required this.id,
    required this.imageUrl,
    required this.productName,
    required this.storeName,
    required this.category,
    required this.memo,
    required this.price,
    required this.purchaseDate,
  });
}
