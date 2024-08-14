import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'loginDB.dart'; // 여기에 `insertMember` 함수가 정의되어 있어야 합니다.

class MemberRegisterPage extends StatefulWidget {
  const MemberRegisterPage({Key? key}) : super(key: key);

  @override
  State<MemberRegisterPage> createState() => _MemberRegisterState();
}

class _MemberRegisterState extends State<MemberRegisterPage> {
    final TextEditingController nameController = TextEditingController();
  final TextEditingController nicknameController = TextEditingController();
  final TextEditingController userIdController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController passwordVerifyingController = TextEditingController();
  final TextEditingController affiliationController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Sign Up",
          style: TextStyle(fontSize: 28),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: <Widget>[
              CupertinoTextField(
                controller: nameController,
                placeholder: '이름',
              ),
              CupertinoTextField(
                controller: userIdController,
                placeholder: '아이디',
              ),
              CupertinoTextField(
                controller: passwordController,
                obscureText: true,
                placeholder: '비밀번호',
              ),
              CupertinoTextField(
                controller: passwordVerifyingController,
                obscureText: true,
                placeholder: '비밀번호 확인',
              ),
              CupertinoTextField(
                controller: nicknameController,
                placeholder: '닉네임',
              ),
              CupertinoTextField(
                controller: affiliationController,
                placeholder: '소속',
              ),
              Container(
                width: double.infinity,
                margin: const EdgeInsets.only(top: 16),
                child: ElevatedButton(
                  onPressed: () async {
                    if (passwordController.text != passwordVerifyingController.text) {
                      showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return AlertDialog(
                            title: const Text('알림'),
                            content: const Text('입력한 비밀번호가 같지 않습니다.'),
                            actions: [
                              TextButton(
                                child: const Text('닫기'),
                                onPressed: () {
                                  Navigator.of(context).pop();
                                },
                              ),
                            ],
                          );
                        },
                      );
                      return;
                    }

                    // 데이터베이스에 정보 삽입
                    try {
                      await insertMember(
                        nameController.text,
                        nicknameController.text,
                        userIdController.text,
                        passwordController.text,
                        affiliationController.text,
                      );

                      Navigator.of(context).pop(); // 현재 화면 닫기

                      showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return AlertDialog(
                            title: const Text('가입 완료'),
                            content: const Text('회원가입이 완료되었습니다.'),
                            actions: [
                              TextButton(
                                child: const Text('확인'),
                                onPressed: () {
                                  Navigator.of(context).pop(); // 확인 버튼 클릭 시 화면 닫기
                                },
                              ),
                            ],
                          );
                        },
                      );
                    } catch (e) {
                      print('Error during registration: $e');
                      showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return AlertDialog(
                            title: const Text('오류'),
                            content: const Text('회원가입 중 오류가 발생했습니다.'),
                            actions: [
                              TextButton(
                                child: const Text('닫기'),
                                onPressed: () {
                                  Navigator.of(context).pop();
                                },
                              ),
                            ],
                          );
                        },
                      );
                    }
                  },
                  child: const Text('가입하기'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
