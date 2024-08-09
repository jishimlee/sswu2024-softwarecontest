import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class StockProvider with ChangeNotifier {
  int _quantity = 0;
  double _pricePerUnit = 100.0;

  int get quantity => _quantity;
  double get totalPrice => _quantity * _pricePerUnit;

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
    // 예제 URL, 헤더, 바디 설정
    final url = 'https://example.com/api/purchase';
    
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
