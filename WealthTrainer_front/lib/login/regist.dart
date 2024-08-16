import 'dart:convert';

class User {
  final String name;
  final String nickname;
  final String user_id;
  final String passward;
  final String affiliation;

  User({
    required this.name,
    required this.nickname,
    required this.user_id,
    required this.passward,
    required this.affiliation,
  });

  // JSON 객체를 User 객체로 변환하는 팩토리 생성자
  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      name: json['name'],
      nickname: json['nickname'],
      user_id: json['user_id'],
      passward: json['passward'],
      affiliation: json['affiliation'],
    );
  }

  // User 객체를 JSON 객체로 변환하는 메서드
  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'nickname': nickname,
      'user_id': user_id,
      'passward': passward,
      'affiliation': affiliation,
    };
  }
}

// JSON 문자열을 User 객체로 변환
User userFromJson(String str) => User.fromJson(json.decode(str));

// User 객체를 JSON 문자열로 변환
String userToJson(User data) => json.encode(data.toJson());
