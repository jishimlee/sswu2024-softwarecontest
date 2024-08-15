const db = require('../config/db');

exports.signUp = (req, res) => {
    const { username, password } = req.body;
    const query = 'INSERT INTO users (username, password) VALUES (?, ?)';

    db.execute(query, [username, password])
        .then(() => res.status(201).send('User registered'))
        .catch(err => res.status(500).send(err));
};

exports.login = (req, res) => {
    const { username, password } = req.body;
    const query = 'SELECT * FROM users WHERE username = ? AND password = ?';

    db.execute(query, [username, password])
        .then(([rows]) => {
            if (rows.length > 0) {
                res.status(200).send('User logged in');
            } else {
                res.status(401).send('Invalid credentials');
            }
        })
        .catch(err => res.status(500).send(err));
};
