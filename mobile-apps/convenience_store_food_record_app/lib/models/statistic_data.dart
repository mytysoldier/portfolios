class StoreStatistic {
  final String storeName;
  final int count;
  final int totalAmount;

  StoreStatistic({
    required this.storeName,
    required this.count,
    required this.totalAmount,
  });
}

class CategoryStatistic {
  final String categoryName;
  final int count;
  final int totalAmount;

  CategoryStatistic({
    required this.categoryName,
    required this.count,
    required this.totalAmount,
  });
}

class StatisticData {
  final int totalExpenditure;
  final List<StoreStatistic> storeStatistics;
  final List<CategoryStatistic> categoryStatistics;
  final int totalCount;
  final double averageUnitPrice;

  StatisticData({
    required this.totalExpenditure,
    required this.storeStatistics,
    required this.categoryStatistics,
    required this.totalCount,
    required this.averageUnitPrice,
  });
}
