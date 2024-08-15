// index.js
const express = require('express');
const app = express();

// auth.js 라우터 가져오기
const authRoutes = require('./routes/auth');

app.use(express.json());

// /api/auth 경로로 라우터 사용
app.use('/api/auth', authRoutes);

app.listen(3000, () => {
    console.log('Server is running on port 3000');
});


