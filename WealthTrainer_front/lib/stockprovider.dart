import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'company.dart';

class StockProvider with ChangeNotifier {
  int _quantity = 0;
  final ComData comData;

  StockProvider({required this.comData});

  int get quantity => _quantity;
  double get pricePerUnit => comData.price;
  double get totalPrice => _quantity * pricePerUnit;

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

  Future<void> purchase() async {
    final url = 'https://example.com/api/purchase';
    //구매량 값 보낼 경로
    
    try {
      final response = await http.post(
        Uri.parse(url),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({
          'quantity': _quantity,
          'totalPrice': totalPrice,
        }),
      );

      if (response.statusCode == 200) {
        // 구매 성공 시 초기화
        _quantity = 0;
        notifyListeners();
      } else {
        // 오류 처리
        _quantity = 0;
        notifyListeners();
        throw Exception('구매 실패');
      }
    } catch (error) {
      // 네트워크 오류 처리
      _quantity = 0;
      notifyListeners();
      print('구매 실패: $error');
      throw error;
    }
  }
}
