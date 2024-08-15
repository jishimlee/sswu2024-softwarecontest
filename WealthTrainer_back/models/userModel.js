const db = require('../config/db');

class User {
  static async findByUsername(username) {
    const [rows] = await db.query('SELECT * FROM users WHERE username = ?', [username]);
    return rows[0];
  }

  static async createUser(username, password, name, nickname, affiliation) {
    const [result] = await db.query(
      'INSERT INTO users (username, password, name, nickname, affiliation) VALUES (?, ?, ?, ?, ?)',
      [username, password, name, nickname, affiliation]
    );
    return result.insertId;
  }
}

module.exports = User;
