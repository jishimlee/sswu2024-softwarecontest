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

  factory ComData.fromMap(Map<String, dynamic> map) {
    return ComData(
      stockId: map['stock_id'],
      companyName: map['company'],
      price: map['per_price'],
      changePrice: map['amount_change'],
      percentChange: map['rate_change'],
      description: map['company_explanation'],
    );
  }

  // 객체를 데이터베이스에 저장하기 위한 Map 생성
  Map<String, dynamic> toMap() {
    return {
      'stock_id': stockId,
      'company': companyName,
      'per_price': price,
      'amount_change': changePrice,
      'rate_change': percentChange,
      'company_explanation': description,
    };
  }
}