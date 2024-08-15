const mysql = require('mysql2');

const pool = mysql.createPool({
  host: 'localhost', // MySQL 서버 호스트
  user: 'root',      // MySQL 사용자 이름
  password: 'password', // MySQL 비밀번호
  database: 'mock_stock_app', // 사용할 데이터베이스 이름
  waitForConnections: true,
  connectionLimit: 10,
  queueLimit: 0
});

module.exports = pool.promise();
