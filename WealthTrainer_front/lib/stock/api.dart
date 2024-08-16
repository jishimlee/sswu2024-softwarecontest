// import 'package:mysql_client/mysql_client.dart';
// import 'company.dart';
// import '../config/mySqlConnector.dart';

// Future<List<ComData>> fetchStockData() async {
//   final conn = await dbConnector();
//   if (conn == null) {
//     throw Exception("데이터베이스 연결 실패");
//   }

//   try {
//     final results = await conn.execute('SELECT * FROM stock'); // 적절한 쿼리 사용
//     List<ComData> companies = [];
//     for (final row in results.rows) {
//       companies.add(
//         ComData(
//           stockId: row.colByName('stock_id') as int,
//           companyName: row.colByName('company') as String,
//           price: row.colByName('per_price') as int,
//           changePrice: row.colByName('amount_change') as int,
//           percentChange: row.colByName('rate_change') as int,
//           description: row.colByName('company_explanation') as String,
//         ),
//       );
//     }
//     return companies;
//   } catch (e) {
//     print('Error fetching company data: $e');
//     return [];
//   } finally {
//     await conn.close();
//   }
// }