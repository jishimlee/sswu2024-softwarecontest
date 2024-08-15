import 'package:mysql_client/mysql_client.dart';
import 'dbInfo.dart';

Future<MySQLConnection?> dbConnector() async {
  print("Connecting to MySQL server...");

  try {
    final conn = await MySQLConnection.createConnection(
      host: '10.0.2.2', // 또는 '127.0.0.1'
      port: DbInfo.portNumber,
      userName: DbInfo.userName,
      password: DbInfo.password,
      databaseName: DbInfo.dbName,
    );

    await conn.connect();
    print("Connected to MySQL server");
    return conn;
  } catch (e) {
    print("Error connecting to the database: $e");
    return null; // 연결 실패 시 null 반환
  }
}
