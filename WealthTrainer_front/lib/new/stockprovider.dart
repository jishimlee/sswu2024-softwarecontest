import 'package:flutter/material.dart';
import '../new/company.dart';

class StockProvider with ChangeNotifier {
  int _quantity = 0;
  ComData? comData;

  StockProvider() {
    notifyListeners();
  }

  int get quantity => _quantity;
  int get pricePerUnit => comData?.per_price ?? 0;
  int get totalPrice => _quantity * pricePerUnit;

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
}