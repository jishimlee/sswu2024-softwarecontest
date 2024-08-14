import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DatabaseHelper {
  static final DatabaseHelper _instance = DatabaseHelper._internal();
  factory DatabaseHelper() => _instance;
  DatabaseHelper._internal();

  Database? _database;

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    String path = join(await getDatabasesPath(), 'app_database.db');
    return await openDatabase(
      path,
      onCreate: (db, version) {
        db.execute('''
          CREATE TABLE Stock (
            stock_id INTEGER PRIMARY KEY AUTOINCREMENT,
            company TEXT NOT NULL,
            per_price INTEGER NOT NULL,
            amount_change INTEGER NOT NULL,
            rate_change INTEGER NOT NULL,
            company_explanation TEXT NOT NULL
          )
        ''');
      },
      version: 1,
    );
  }

  Future<void> close() async {
    final db = await database;
    await db.close();
  }
}