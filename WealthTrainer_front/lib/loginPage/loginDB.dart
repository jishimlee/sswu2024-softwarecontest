import '../config/mySqlConnector.dart';
import '../config/hashPassword.dart';
import 'package:mysql_client/mysql_client.dart';

//계정 생성
Future<void> insertMember(
  String name,
  String nickname,
  String userId,
  String password,
  String affiliation
) async {
  //MySQL 접속 설정
  final conn = await dbConnector();
    if (conn == null) {
    print("Failed to connect to database");
    return;
  }
  final hash = hashPassword(password);

  //DB에 유저 정보 추가
  try {
    await conn.execute(
      "INSERT INTO user (name,, nickname, user_id, password, affiliation) VALUES (:name, :nickname, :user_id, :password, :affiliation)",
      {
        "name": name,
        "nickname": nickname,
        "user_id": userId, 
        "password": hash,
        "affiliation": affiliation
      }
    );
    print("데이터베이스 저장완료");
  } catch (e) {
    print('Error : $e');
  } finally {
    try {
      await conn.close();
      print("Connection closed");
    } catch (e) {
      print('Error during connection close: $e');
    }
  }
}

Future<String?> login(String userId, String password) async {
  final conn = await dbConnector();
    if (conn == null) {
    print("Failed to connect to database");
    return '-1'; // 연결 실패 시 에러 코드 반환
  }
  final hash = hashPassword(password);

  IResultSet? result;

  try {
    result = await conn.execute(
        "SELECT id FROM user WHERE user_id = :user_id and password = :password",
        {"user_id": userId, "password": hash});

    if (result.isNotEmpty) {
      for (final row in result.rows) {
        print('User ID: ${row.colAt(0)}');
        // 유저 정보가 존재하면 유저의 index 값 반환
        return row.colAt(0);
      }
    }
  } catch (e) {
    print('Error : $e');
  } finally {
    try {
      await conn.close();
      print("Connection closed");
    } catch (e) {
      print('Error during connection close: $e');
    }
  }
  // 예외처리용 에러코드 '-1' 반환
  return '-1';
}