import 'package:flutter/material.dart';
import 'api.dart';
import 'company.dart';

class StockProvider with ChangeNotifier {
  int _quantity = 0;
  ComData? comData;

  final DataService _dataService = DataService();

  StockProvider() {
    _loadData();
  }

  int get quantity => _quantity;
  int get pricePerUnit => comData?.price ?? 0;
  int get totalPrice => _quantity * pricePerUnit;

  Future<void> _loadData() async {
    try {
      List<ComData> data = await _dataService.fetchStockData();
      if (data.isNotEmpty) {
        comData = data[0];
        notifyListeners();
      }
    } catch (e) {
      print('데이터 로드 오류: $e');
    }
  }

  void incrementQuantity() {
    _quantity++;
    notifyListeners();
  }

  void decrementQuantity() {
    if (_quantity > 0) {
      _quantity--;
      notifyListeners();
    }
  }

  void setQuantity(int quantity) {
    _quantity = quantity;
    notifyListeners();
  }

  // Future<void> purchase() async {
  //   if (_quantity > 0) {
  //     try {
  //       await DataService().purchaseStock(comData.companyName, _quantity, totalPrice);
  //     } catch (e) {
  //       throw Exception('구매 실패: $e');
  //     }
  //   } else {
  //     throw Exception('구매 수량이 0입니다.');
  //   }
  // }
}