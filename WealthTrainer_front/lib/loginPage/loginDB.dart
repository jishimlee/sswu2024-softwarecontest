import '../config/mySqlConnector.dart';
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

  //DB에 유저 정보 추가
  try {
    await conn.execute(
      "INSERT INTO user (name, nickname, user_id, password, affiliation) VALUES (:name, :nickname, :user_id, :password, :affiliation)",
      {
        "name": name,
        "nickname": nickname,
        "user_id": userId, 
        "password": password,
        "affiliation": affiliation
      }
    );
    print("데이터베이스 저장완료");
  } catch (e) {
    print('Error: $e');
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

  try {
    final results = await conn.execute(
      'SELECT * FROM user WHERE user_id = :user_id AND password = :password',
      {
        "user_id": userId,
        "password": password
      }
    );

    if (results.rows.isNotEmpty) {
      // 유저 정보가 존재할 경우
      print('로그인 성공');
      return userId; // 예시로 사용자 ID 반환
    } else {
      // 유저 정보가 존재하지 않을 경우
      print('로그인 실패');
      return '0'; // 로그인 실패 시 에러 코드 반환
    }
  } catch (e) {
    print('Error: $e');
    return '-1'; // 에러 발생 시 에러 코드 반환
  } finally {
    try {
      await conn.close();
      print("Connection closed");
    } catch (e) {
      print('Error during connection close: $e');
    }
  }
}