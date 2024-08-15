class ComData {
  final int stockId; // 추가된 필드
  final String companyName;
  final int price;
  final int changePrice;
  final int percentChange;
  final String description;

  ComData({
    required this.stockId, // 추가된 필드
    required this.companyName, 
    required this.price, 
    required this.changePrice,
    required this.percentChange,
    required this.description,
  });
}