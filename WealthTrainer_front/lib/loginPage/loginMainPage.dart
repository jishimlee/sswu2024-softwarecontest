import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../main.dart';
import 'loginDB.dart';
import 'memberRegisterPage.dart';
import 'package:shared_preferences/shared_preferences.dart';

class TokenCheck extends StatefulWidget {
  const TokenCheck({super.key});

  @override
  State<TokenCheck> createState() => _TokenCheckState();
}

class _TokenCheckState extends State<TokenCheck> {
  bool isToken = false;

  @override
  void initState() {
    super.initState();
    _autoLoginCheck();
  }

  void _autoLoginCheck() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final String? token = prefs.getString('token');

    if (token != null) {
      setState(() {
        isToken = true;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: isToken ? EpisodeSelectionPage() : LoginPage(),
    );
  }
}

class LoginMainPage extends StatelessWidget {
  const LoginMainPage({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: LoginPage(),
    );
  }
}

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginState();
}

class _LoginState extends State<LoginPage> {
  bool switchValue = false;

  final TextEditingController userIdController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  void _setAutoLogin(String token) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('token', token);
  }

  void _delAutoLogin() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.remove('token');
  }

  void _login() {
    final id = userIdController.text;
    final password = passwordController.text;

    if (id == 'admin' && password == 'password') {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => EpisodeSelectionPage()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Wealth Trainer",
          style: TextStyle(fontSize: 28),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: <Widget>[
              CupertinoTextField(
                controller: userIdController,
                placeholder: 'ID',
              ),
              CupertinoTextField(
                controller: passwordController,
                obscureText: true,
                placeholder: 'PASSWORD',
              ),
              SizedBox(
                width: 300,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      '자동로그인 ',
                      style: TextStyle(
                          color: CupertinoColors.activeBlue,
                          fontWeight: FontWeight.bold),
                    ),
                    CupertinoSwitch(
                      value: switchValue,
                      activeColor: CupertinoColors.activeBlue,
                      onChanged: (bool? value) {
                        setState(() {
                          switchValue = value ?? false;
                        });
                      },
                    ),
                    Text('    '),
                    OutlinedButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => MemberRegisterPage(),
                          ),
                        );
                      },
                      child: Text('회원가입'),
                    ),
                  ],
                ),
              ),
              Container(
                width: double.infinity,
                margin: const EdgeInsets.only(top: 16),
                child: ElevatedButton(
                  onPressed: () async {
                    final loginCheck = await login(
                      userIdController.text,
                      passwordController.text,
                    );
                    print('로그인 체크 결과: $loginCheck');

                    if (loginCheck == '0') {
                      print('로그인 실패');
                      showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return AlertDialog(
                            title: Text('알림'),
                            content: Text('아이디 또는 비밀번호가 올바르지 않습니다.'),
                            actions: [
                              TextButton(
                                child: Text('닫기'),
                                onPressed: () {
                                  Navigator.of(context).pop();
                                },
                              ),
                            ],
                          );
                        },
                      );
                    } else {
                      print('로그인 성공');

                      if (switchValue == true) {
                        _setAutoLogin(loginCheck!);
                      } else {
                        _delAutoLogin();
                      }

                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                          builder: (context) => EpisodeSelectionPage(),
                        ),
                      );
                    }
                  },
                  child: Text('로그인'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
