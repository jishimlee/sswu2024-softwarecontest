import 'package:sqflite/sqflite.dart';
import 'company.dart';
import 'data.dart';

class DataService {
  final DatabaseHelper _dbHelper = DatabaseHelper();

  Future<List<ComData>> fetchStockData() async {
    final db = await _dbHelper.database;

    try {
      final List<Map<String, dynamic>> maps = await db.query('Stock');
      

      return List.generate(maps.length, (i) {
        return ComData(
          stockId: maps[i]['stock_id'] as int,
          companyName: maps[i]['company'] as String,
          price: maps[i]['per_price'] as int,
          changePrice: maps[i]['amount_change'] as int,
          percentChange: maps[i]['rate_change'] as int,
          description: maps[i]['company_explanation'] as String,
        );
      });
    } catch (e) {
      print('Error fetching stock data: $e');
      throw Exception('Failed to load stock data');
    }
  }

  Future<void> insertStock(ComData comData) async {
    final db = await _dbHelper.database;

    await db.insert(
      'Stock',
      comData.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }
}