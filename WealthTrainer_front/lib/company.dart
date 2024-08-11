class ComData {
  //final String stockId;
  final String companyName;
  final double price;
  final double changePrice;
  final double percentChange;
  //final String logoUrl;
  final String description;

  ComData({
    //required this.stockId,
    required this.companyName, 
    required this.price, 
    required this.changePrice,
    required this.percentChange,
    //required this.logoUrl,
    required this.description,
    });

//객체 변환
factory ComData.fromJson(Map<String, dynamic> json) {
  return ComData(
    //stockId: json['stockId'], 
    companyName: json['companyName'], 
    price: json['price'], 
    changePrice: json['changePrice'], 
    percentChange: json['percentChange'],
    //logoUrl: json['logoUrl'],
    description: json['description'],
    );
  }
}