class ComData {
  final String companyName;
  final double price;
  final double changePrice;
  final double percentChange;
  final String description;

  ComData({
    required this.companyName, 
    required this.price, 
    required this.changePrice,
    required this.percentChange,
    required this.description,
    });

//객체 변환
factory ComData.fromJson(Map<String, dynamic> json) {
  return ComData(
    companyName: json['company'] as String,
    price: (json['per_price'] as int).toDouble(),
    changePrice: (json['amount_change'] as int).toDouble(), 
    percentChange: (json['rate_change'] as int).toDouble(),
    description: json['company_explanation'] as String,
    );
  }
}