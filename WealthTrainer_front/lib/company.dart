class ComData {
  final String companyName;
  final double price;
  final double previousPrice;
  final String description;

  ComData(
    {required this.companyName, 
    required this.price, 
    required this.previousPrice, 
    required this.description}
  );

  //변동 가격
  double get change => price - previousPrice;

  //상승률
  double get changePercentage {
    if (previousPrice==0) {
      return 0;
    }
    return(change / previousPrice) * 100;
  }
}