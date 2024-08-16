import 'package:mysql1/mysql1.dart';
import 'company.dart'; // ComData 클래스 임포트

class MySQLService {
  late MySqlConnection _connection;

  // 데이터베이스 연결
  Future<void> connect() async {
    final settings = ConnectionSettings(
      host: 'localhost',
      port: 3306,
      user: 'root',
      password: 'password',
      db: '2024_swcontest',
    );

    _connection = await MySqlConnection.connect(settings);
    print('Connected to MySQL database');
  }

  // 데이터 쿼리
  Future<List<ComData>> fetchStockData() async {
    var results = await _connection.query('SELECT * FROM stock');
    List<ComData> comDataList = [];
    for (var row in results) {
      comDataList.add(ComData(
        company: row[1], // stock 테이블에서의 컬럼 인덱스
        per_price: row[2],
        amount_change: row[3],
        rate_change: row[4],
        company_explanation: row[5],
      ));
    }
    return comDataList;
  }

  // 데이터 삽입
  Future<void> insertData(String companyName, int price, int changePrice, int percentChange, String description) async {
    await _connection.query(
      'INSERT INTO stock (companyName, price, changePrice, percentChange, description) VALUES (?, ?, ?, ?, ?)',
      [companyName, price, changePrice, percentChange, description],
    );
    print('Inserted data into MySQL database');
  }

  // 연결 종료
  Future<void> close() async {
    await _connection.close();
    print('Connection closed');
  }
}
