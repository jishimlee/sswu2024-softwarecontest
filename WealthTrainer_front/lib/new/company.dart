import 'dart:convert';
import 'mysql_service.dart';

class ComData {
  final String company;
  final int per_price;
  final int amount_change;
  final int rate_change;
  final String company_explanation;

  ComData({
    required this.company,
    required this.per_price,
    required this.amount_change,
    required this.rate_change,
    required this.company_explanation,
  });

  // JSON 객체를 ComData 객체로 변환하는 팩토리 생성자
  factory ComData.fromJson(Map<String, dynamic> json) {
    return ComData(
      company: json['company'],
      per_price: json['per_price'],
      amount_change: json['amount_change'],
      rate_change: json['rate_change'],
      company_explanation: json['company_explanation'],
    );
  }

  // ComData 객체를 JSON 객체로 변환하는 메서드
  Map<String, dynamic> toJson() {
    return {
      'company': company,
      'per_price': per_price,
      'amount_change': amount_change,
      'rate_change': rate_change,
      'company_explanation': company_explanation,
    };
  }
}

// JSON 문자열을 ComData 객체로 변환
ComData comDataFromJson(String str) => ComData.fromJson(json.decode(str));

// ComData 객체를 JSON 문자열로 변환
String comDataToJson(ComData data) => json.encode(data.toJson());
