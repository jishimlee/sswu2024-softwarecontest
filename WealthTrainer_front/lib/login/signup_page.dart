import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class SignUpPage extends StatefulWidget {
  const SignUpPage({Key? key}) : super(key: key);

  @override
  _SignUpPageState createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _idController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _passwordConfirmController = TextEditingController();
  final TextEditingController _nicknameController = TextEditingController();
  final TextEditingController _affiliationController = TextEditingController();

  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  void _signUp() async {
    final name = _nameController.text;
    final id = _idController.text;
    final password = _passwordController.text;
    final passwordConfirm = _passwordConfirmController.text;
    final nickname = _nicknameController.text;
    final affiliation = _affiliationController.text;

    if (password != passwordConfirm) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('비밀번호가 일치하지 않습니다.')),
      );
      return;
    }

      try {
      // Firebase Authentication으로 사용자 생성
      UserCredential userCredential = await _auth.createUserWithEmailAndPassword(
        email: id,
        password: password,
      );

      // Firestore에 사용자 추가 정보 저장
      await _firestore.collection('users').doc(userCredential.user?.uid).set({
        'name': name,
        'nickname': nickname,
        'affiliation': affiliation,
      });

      Navigator.pushReplacementNamed(context, '/home');
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('회원가입 실패: ${e.toString()}')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "회원가입",
          style: TextStyle(fontSize: 28),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              TextField(
                decoration: InputDecoration(labelText: '이름'),
              ),
              TextField(
                decoration: InputDecoration(labelText: '아이디'),
              ),
              TextField(
                obscureText: true,
                decoration: InputDecoration(labelText: '비밀번호'),
              ),
              TextField(
                obscureText: true,
                decoration: InputDecoration(labelText: '비밀번호 확인'),
              ),
              TextField(
                decoration: InputDecoration(labelText: '닉네임'),
              ),
              TextField(
                decoration: InputDecoration(labelText: '소속'),
              ),
              Container(
                width: double.infinity,
                margin: const EdgeInsets.only(top: 16),
                child: ElevatedButton(
                  onPressed: () {
                  },
                  child: Text('가입하기'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}