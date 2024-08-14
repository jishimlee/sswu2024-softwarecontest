import 'dart:convert';
import 'package:http/http.dart' as http;
import 'company.dart';

Future<List<ComData>> fetchStockData() async {
  final response = await http.get(Uri.parse('https://example.com/api/stock'));

  if (response.statusCode == 200) {
    List<dynamic> data = json.decode(response.body);
    return data.map((json) => ComData.fromJson(json)).toList();
  } else {
    throw Exception('데이터를 불러오는 데 실패하였습니다.');
  }
}