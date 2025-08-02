class RecordItemModel {
  final String imageUrl;
  final String productName;
  final int storeId;
  final int categoryId;
  final String memo;
  final int price;
  final DateTime purchaseDate;

  RecordItemModel({
    required this.imageUrl,
    required this.productName,
    required this.storeId,
    required this.categoryId,
    required this.memo,
    required this.price,
    required this.purchaseDate,
  });
}
