require('dotenv').config();
const express = require('express');
const mysql = require('mysql2/promise');

const app = express();
app.use(express.json());

const pool = mysql.createPool({
  host: process.env.DB_HOST || '127.0.0.1',
  port: process.env.DB_PORT || 3307,
  user: process.env.DB_USER || 'wm_user',
  password: process.env.DB_PASS || 'wm_pass',
  database: process.env.DB_NAME || 'waste_management',
  waitForConnections: true,
  connectionLimit: 10,
});

app.get('/api/health', async (req, res) => {
  try {
    const [rows] = await pool.query('SELECT 1 AS ok');
    res.json({ ok: rows[0].ok === 1 });
  } catch (err) {
    res.status(500).json({ error: err.message });
  }
});

app.get('/api/citizens', async (req, res) => {
  try {
    const [rows] = await pool.query('SELECT Citizen_ID AS id, Name AS name, Address AS address, Contact_Info AS contact, DOB, Gender, Registration_Date FROM Citizen');
    res.json(rows);
  } catch (err) {
    res.status(500).json({ error: err.message });
  }
});

app.post('/api/citizens', async (req, res) => {
  const { name, address, contact, dob, gender } = req.body;
  try {
    const [result] = await pool.execute('INSERT INTO Citizen (Name, Address, Contact_Info, DOB, Gender) VALUES (?, ?, ?, ?, ?)', [name, address, contact, dob, gender]);
    res.status(201).json({ id: result.insertId });
  } catch (err) {
    res.status(500).json({ error: err.message });
  }
});

const port = process.env.PORT || 3000;
app.listen(port, () => console.log(`Backend running on http://localhost:${port}`));
