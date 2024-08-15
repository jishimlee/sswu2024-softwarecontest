// routes/auth.js
const express = require('express');
const router = express.Router();
const authController = require('../controllers/authController');

// 회원가입 라우트
router.post('/signup', authController.signUp);

// 로그인 라우트
router.post('/login', authController.login);

module.exports = router; // 라우터를 내보내기

