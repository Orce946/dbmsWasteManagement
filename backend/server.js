require('dotenv').config();
const express = require('express');
const mysql = require('mysql2/promise');

const app = express();
app.use(express.json());

const pool = mysql.createPool({
  host: process.env.DB_HOST || '127.0.0.1',
  port: process.env.DB_PORT || 3306,
  user: process.env.DB_USER || 'root',
  password: process.env.DB_PASSWORD || '',
  database: process.env.DB_NAME || 'waste_management',
  waitForConnections: true,
  connectionLimit: 10,
});

// ===== HEALTH CHECK =====
app.get('/api/health', async (req, res) => {
  try {
    const [rows] = await pool.query('SELECT 1 AS ok');
    res.json({ ok: rows[0].ok === 1 });
  } catch (err) {
    res.status(500).json({ error: err.message });
  }
});

// ===== CITIZEN ENDPOINTS =====
app.get('/api/citizens', async (req, res) => {
  try {
    const [rows] = await pool.query('SELECT * FROM Citizen');
    res.json(rows);
  } catch (err) {
    res.status(500).json({ error: err.message });
  }
});

app.get('/api/citizens/:id', async (req, res) => {
  try {
    const [rows] = await pool.query('SELECT * FROM Citizen WHERE Citizen_ID = ?', [req.params.id]);
    if (rows.length === 0) return res.status(404).json({ error: 'Citizen not found' });
    res.json(rows[0]);
  } catch (err) {
    res.status(500).json({ error: err.message });
  }
});

app.post('/api/citizens', async (req, res) => {
  const { Name, Address, Contact_Info, DOB, Gender } = req.body;
  try {
    const [result] = await pool.execute('INSERT INTO Citizen (Name, Address, Contact_Info, DOB, Gender) VALUES (?, ?, ?, ?, ?)', 
      [Name, Address, Contact_Info, DOB, Gender]);
    res.status(201).json({ id: result.insertId });
  } catch (err) {
    res.status(500).json({ error: err.message });
  }
});

app.put('/api/citizens/:id', async (req, res) => {
  const { Name, Address, Contact_Info, DOB, Gender } = req.body;
  try {
    await pool.execute('UPDATE Citizen SET Name=?, Address=?, Contact_Info=?, DOB=?, Gender=? WHERE Citizen_ID=?',
      [Name, Address, Contact_Info, DOB, Gender, req.params.id]);
    res.json({ success: true });
  } catch (err) {
    res.status(500).json({ error: err.message });
  }
});

app.delete('/api/citizens/:id', async (req, res) => {
  try {
    await pool.execute('DELETE FROM Citizen WHERE Citizen_ID = ?', [req.params.id]);
    res.json({ success: true });
  } catch (err) {
    res.status(500).json({ error: err.message });
  }
});

// ===== AREA ENDPOINTS =====
app.get('/api/areas', async (req, res) => {
  try {
    const [rows] = await pool.query('SELECT * FROM Area');
    res.json(rows);
  } catch (err) {
    res.status(500).json({ error: err.message });
  }
});

app.post('/api/areas', async (req, res) => {
  const { Area_Name, Area_Code, Population, Supervisor, Description } = req.body;
  try {
    const [result] = await pool.execute('INSERT INTO Area (Area_Name, Area_Code, Population, Supervisor, Description) VALUES (?, ?, ?, ?, ?)',
      [Area_Name, Area_Code, Population, Supervisor, Description]);
    res.status(201).json({ id: result.insertId });
  } catch (err) {
    res.status(500).json({ error: err.message });
  }
});

// ===== BILL ENDPOINTS =====
app.get('/api/bills', async (req, res) => {
  try {
    const [rows] = await pool.query('SELECT * FROM Bill');
    res.json(rows);
  } catch (err) {
    res.status(500).json({ error: err.message });
  }
});

app.post('/api/bills', async (req, res) => {
  const { Status, Due_Date, Amount, Issue_Date, Description } = req.body;
  try {
    const [result] = await pool.execute('INSERT INTO Bill (Status, Due_Date, Amount, Issue_Date, Description) VALUES (?, ?, ?, ?, ?)',
      [Status, Due_Date, Amount, Issue_Date, Description]);
    res.status(201).json({ id: result.insertId });
  } catch (err) {
    res.status(500).json({ error: err.message });
  }
});

// ===== PAYMENT ENDPOINTS =====
app.get('/api/payments', async (req, res) => {
  try {
    const [rows] = await pool.query('SELECT * FROM Payment');
    res.json(rows);
  } catch (err) {
    res.status(500).json({ error: err.message });
  }
});

app.post('/api/payments', async (req, res) => {
  const { Amount, Method, Reference_Number, Notes } = req.body;
  try {
    const [result] = await pool.execute('INSERT INTO Payment (Amount, Method, Reference_Number, Notes) VALUES (?, ?, ?, ?)',
      [Amount, Method, Reference_Number, Notes]);
    res.status(201).json({ id: result.insertId });
  } catch (err) {
    res.status(500).json({ error: err.message });
  }
});

// ===== WASTE ENDPOINTS =====
app.get('/api/waste', async (req, res) => {
  try {
    const [rows] = await pool.query('SELECT * FROM Waste');
    res.json(rows);
  } catch (err) {
    res.status(500).json({ error: err.message });
  }
});

app.post('/api/waste', async (req, res) => {
  const { Name, Category, Weight, Volume, Hazardous, Description } = req.body;
  try {
    const [result] = await pool.execute('INSERT INTO Waste (Name, Category, Weight, Volume, Hazardous, Description) VALUES (?, ?, ?, ?, ?, ?)',
      [Name, Category, Weight, Volume, Hazardous, Description]);
    res.status(201).json({ id: result.insertId });
  } catch (err) {
    res.status(500).json({ error: err.message });
  }
});

// ===== RECYCLING CENTER ENDPOINTS =====
app.get('/api/recycling-centers', async (req, res) => {
  try {
    const [rows] = await pool.query('SELECT * FROM Recycling_Center');
    res.json(rows);
  } catch (err) {
    res.status(500).json({ error: err.message });
  }
});

app.post('/api/recycling-centers', async (req, res) => {
  const { Capacity, Location, Operating_Hours, Manager, Contact, Established_Date } = req.body;
  try {
    const [result] = await pool.execute('INSERT INTO Recycling_Center (Capacity, Location, Operating_Hours, Manager, Contact, Established_Date) VALUES (?, ?, ?, ?, ?, ?)',
      [Capacity, Location, Operating_Hours, Manager, Contact, Established_Date]);
    res.status(201).json({ id: result.insertId });
  } catch (err) {
    res.status(500).json({ error: err.message });
  }
});

// ===== COLLECTION SCHEDULES ENDPOINTS =====
app.get('/api/schedules', async (req, res) => {
  try {
    const [rows] = await pool.query('SELECT * FROM Collection_Schedules');
    res.json(rows);
  } catch (err) {
    res.status(500).json({ error: err.message });
  }
});

app.post('/api/schedules', async (req, res) => {
  const { Schedule_Date, Status, Frequency, Assigned_Vehicle, Notes } = req.body;
  try {
    const [result] = await pool.execute('INSERT INTO Collection_Schedules (Schedule_Date, Status, Frequency, Assigned_Vehicle, Notes) VALUES (?, ?, ?, ?, ?)',
      [Schedule_Date, Status, Frequency, Assigned_Vehicle, Notes]);
    res.status(201).json({ id: result.insertId });
  } catch (err) {
    res.status(500).json({ error: err.message });
  }
});

// ===== BINS ENDPOINTS =====
app.get('/api/bins', async (req, res) => {
  try {
    const [rows] = await pool.query('SELECT * FROM Bins');
    res.json(rows);
  } catch (err) {
    res.status(500).json({ error: err.message });
  }
});

app.post('/api/bins', async (req, res) => {
  const { Status, Fill_Level, Sensor, Location, Type, Last_Emptied } = req.body;
  try {
    const [result] = await pool.execute('INSERT INTO Bins (Status, Fill_Level, Sensor, Location, Type, Last_Emptied) VALUES (?, ?, ?, ?, ?, ?)',
      [Status, Fill_Level, Sensor, Location, Type, Last_Emptied]);
    res.status(201).json({ id: result.insertId });
  } catch (err) {
    res.status(500).json({ error: err.message });
  }
});

// ===== CREW ENDPOINTS =====
app.get('/api/crews', async (req, res) => {
  try {
    const [rows] = await pool.query('SELECT * FROM Crew');
    res.json(rows);
  } catch (err) {
    res.status(500).json({ error: err.message });
  }
});

app.post('/api/crews', async (req, res) => {
  const { Crew_Name, Contact_Info, Size, Supervisor, Specialization } = req.body;
  try {
    const [result] = await pool.execute('INSERT INTO Crew (Crew_Name, Contact_Info, Size, Supervisor, Specialization) VALUES (?, ?, ?, ?, ?)',
      [Crew_Name, Contact_Info, Size, Supervisor, Specialization]);
    res.status(201).json({ id: result.insertId });
  } catch (err) {
    res.status(500).json({ error: err.message });
  }
});

// ===== RELATIONSHIP ENDPOINTS =====

// LIVES: Citizen lives in Area
app.get('/api/relationships/lives', async (req, res) => {
  try {
    const [rows] = await pool.query('SELECT c.Citizen_ID, c.Name, a.Area_ID, a.Area_Name FROM LIVES l JOIN Citizen c ON l.Citizen_ID = c.Citizen_ID JOIN Area a ON l.Area_ID = a.Area_ID');
    res.json(rows);
  } catch (err) {
    res.status(500).json({ error: err.message });
  }
});

app.post('/api/relationships/lives', async (req, res) => {
  const { Citizen_ID, Area_ID } = req.body;
  try {
    await pool.execute('INSERT INTO LIVES (Citizen_ID, Area_ID) VALUES (?, ?)', [Citizen_ID, Area_ID]);
    res.status(201).json({ success: true });
  } catch (err) {
    res.status(500).json({ error: err.message });
  }
});

// HAS_Bill: Citizen has Bill
app.get('/api/relationships/has-bill', async (req, res) => {
  try {
    const [rows] = await pool.query('SELECT c.Citizen_ID, c.Name, b.Bill_ID, b.Status, b.Amount FROM HAS_Bill hb JOIN Citizen c ON hb.Citizen_ID = c.Citizen_ID JOIN Bill b ON hb.Bill_ID = b.Bill_ID');
    res.json(rows);
  } catch (err) {
    res.status(500).json({ error: err.message });
  }
});

app.post('/api/relationships/has-bill', async (req, res) => {
  const { Citizen_ID, Bill_ID } = req.body;
  try {
    await pool.execute('INSERT INTO HAS_Bill (Citizen_ID, Bill_ID) VALUES (?, ?)', [Citizen_ID, Bill_ID]);
    res.status(201).json({ success: true });
  } catch (err) {
    res.status(500).json({ error: err.message });
  }
});

// GENERATES: Citizen generates Waste for Payment (Ternary)
app.get('/api/relationships/generates', async (req, res) => {
  try {
    const [rows] = await pool.query('SELECT c.Name, w.Name as Waste, p.Amount FROM GENERATES g JOIN Citizen c ON g.Citizen_ID = c.Citizen_ID JOIN Waste w ON g.Waste_ID = w.Waste_ID JOIN Payment p ON g.Payment_ID = p.Payment_ID');
    res.json(rows);
  } catch (err) {
    res.status(500).json({ error: err.message });
  }
});

app.post('/api/relationships/generates', async (req, res) => {
  const { Citizen_ID, Waste_ID, Payment_ID } = req.body;
  try {
    await pool.execute('INSERT INTO GENERATES (Citizen_ID, Waste_ID, Payment_ID) VALUES (?, ?, ?)', [Citizen_ID, Waste_ID, Payment_ID]);
    res.status(201).json({ success: true });
  } catch (err) {
    res.status(500).json({ error: err.message });
  }
});

// HAS_Schedule: Area has Collection_Schedules with Crew (Ternary)
app.get('/api/relationships/has-schedule', async (req, res) => {
  try {
    const [rows] = await pool.query('SELECT a.Area_Name, cs.Schedule_Date, c.Crew_Name FROM HAS_Schedule hs JOIN Area a ON hs.Area_ID = a.Area_ID JOIN Collection_Schedules cs ON hs.Schedule_ID = cs.Schedule_ID JOIN Crew c ON hs.Crew_ID = c.Crew_ID');
    res.json(rows);
  } catch (err) {
    res.status(500).json({ error: err.message });
  }
});

app.post('/api/relationships/has-schedule', async (req, res) => {
  const { Area_ID, Schedule_ID, Crew_ID } = req.body;
  try {
    await pool.execute('INSERT INTO HAS_Schedule (Area_ID, Schedule_ID, Crew_ID) VALUES (?, ?, ?)', [Area_ID, Schedule_ID, Crew_ID]);
    res.status(201).json({ success: true });
  } catch (err) {
    res.status(500).json({ error: err.message });
  }
});

const port = process.env.PORT || 3000;
app.listen(port, () => console.log(`Backend running on http://localhost:${port}`));
