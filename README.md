# Waste Management System - DBMS Project

A complete waste management system with MySQL database, ER diagram relationships, and REST API backend.

## 📁 Project Structure

```
├── schema.sql              # Complete ER-based database schema with relationships
├── index.html              # Frontend UI (Bootstrap 5, tabbed interface)
├── .env                    # Database credentials
├── docker-compose.yml      # Docker setup (optional)
├── backend/
│   ├── server.js           # Express.js REST API
│   ├── package.json        # Node.js dependencies
│   └── .env.example        # API environment variables
└── README.md               # This file
```

## 🗄️ Database Schema

**9 Entity Tables:**
- Citizen, Area, Bill, Payment, Waste, Recycling_Center, Collection_Schedules, Bins, Crew

**5 Binary Relationships:**
- LIVES (Citizen → Area)
- HAS_Bill (Citizen → Bill)
- MAKES (Citizen → Payment)
- PROCESSED_BY (Waste → Recycling_Center)
- HAS_Bins (Area → Bins)

**2 Ternary Relationships:**
- GENERATES (Citizen + Waste → Payment)
- HAS_Schedule (Area + Schedule → Crew)

All tables include **foreign key constraints** with `ON DELETE CASCADE`.

## 🚀 Setup with XAMPP (Recommended)

### Prerequisites
- XAMPP installed and running
- MySQL service started in XAMPP Control Panel

### Steps

**1. Start XAMPP MySQL:**
   - Open XAMPP Control Panel
   - Click **Start** next to MySQL
   - Verify it shows "Running" (green indicator)

**2. Create Database and Import Schema:**
   - Open phpMyAdmin: http://localhost/phpmyadmin
   - Click **"New"** to create database
   - Name: `waste_management` → Click **Create**
   - Select `waste_management` from left sidebar
   - Click **Import** tab
   - Choose file: `schema.sql` from this project
   - Click **Go** to import all tables and relationships

**3. Create Database User (Optional):**
   - In phpMyAdmin, click **User accounts** tab
   - Click **Add user account**
   - Username: `wm_user`
   - Password: `wm_pass`
   - Host: `localhost`
   - Under "Database-specific privileges", select `waste_management`
   - Click **Check All** for privileges → Click **Go**

**4. Verify Setup:**
   - In phpMyAdmin, select `waste_management` database
   - Run query: `SELECT COUNT(*) FROM Citizen;`
   - Should return: **4 citizens**

## 🔌 Backend API Setup

### Install Dependencies
```bash
cd backend
npm install
```

### Configure .env
Create `.env` file in `backend/` folder:
```
DB_HOST=127.0.0.1
DB_PORT=3306
DB_USER=root
DB_PASSWORD=
DB_NAME=waste_management
PORT=3000
```

Or if using custom XAMPP user:
```
DB_HOST=127.0.0.1
DB_PORT=3306
DB_USER=wm_user
DB_PASSWORD=wm_pass
DB_NAME=waste_management
PORT=3000
```

### Start Backend Server
```bash
cd backend
node server.js
```

Server runs on: http://localhost:3000

### 📚 Complete API Endpoints

**Health & Status:**
- `GET /api/health` → Check API and database connection

**Citizen Endpoints:**
- `GET /api/citizens` → Fetch all citizens
- `GET /api/citizens/:id` → Fetch specific citizen
- `POST /api/citizens` → Add new citizen
- `PUT /api/citizens/:id` → Update citizen
- `DELETE /api/citizens/:id` → Delete citizen

**Area Endpoints:**
- `GET /api/areas` → Fetch all areas
- `POST /api/areas` → Add new area

**Bill Endpoints:**
- `GET /api/bills` → Fetch all bills
- `POST /api/bills` → Add new bill

**Payment Endpoints:**
- `GET /api/payments` → Fetch all payments
- `POST /api/payments` → Add new payment

**Waste Endpoints:**
- `GET /api/waste` → Fetch all waste types
- `POST /api/waste` → Add new waste type

**Recycling Center Endpoints:**
- `GET /api/recycling-centers` → Fetch all recycling centers
- `POST /api/recycling-centers` → Add new recycling center

**Collection Schedule Endpoints:**
- `GET /api/schedules` → Fetch all schedules
- `POST /api/schedules` → Add new schedule

**Bins Endpoints:**
- `GET /api/bins` → Fetch all bins
- `POST /api/bins` → Add new bin

**Crew Endpoints:**
- `GET /api/crews` → Fetch all crews
- `POST /api/crews` → Add new crew

**Relationship Endpoints (Binary & Ternary):**
- `GET /api/relationships/lives` → Citizen-Area relationships
- `POST /api/relationships/lives` → Link citizen to area
- `GET /api/relationships/has-bill` → Citizen-Bill relationships
- `POST /api/relationships/has-bill` → Link citizen to bill
- `GET /api/relationships/generates` → Citizen-Waste-Payment (ternary)
- `POST /api/relationships/generates` → Link citizen waste generation
- `GET /api/relationships/has-schedule` → Area-Schedule-Crew (ternary)
- `POST /api/relationships/has-schedule` → Link area to schedule with crew

### Example API Calls

**Fetch all citizens:**
```bash
curl http://localhost:3000/api/citizens | jq
```

**Add a new citizen:**
```bash
curl -X POST http://localhost:3000/api/citizens \
  -H "Content-Type: application/json" \
  -d '{"Name":"John Smith","Address":"123 Main St","Contact_Info":"john@example.com","DOB":"1990-05-15","Gender":"Male"}'
```

**Fetch citizen-area relationships:**
```bash
curl http://localhost:3000/api/relationships/lives | jq
```

## 💻 Frontend

Open `index.html` in your browser (or serve via backend):
- Bootstrap 5 responsive UI
- Tabbed interface for all 9 entities
- Currently uses localStorage (will be wired to API)

## 🗂️ Alternative Setup with Docker

If you prefer Docker over XAMPP:

```bash
# Start Docker containers
docker compose up -d

# Access Adminer (web UI)
# URL: http://localhost:8080
# System: MySQL
# Server: db
# Username: wm_user
# Password: wm_pass
# Database: waste_management

# Stop containers
docker compose down
```

## 🔐 Database Credentials

| Item | Value |
|------|-------|
| **Database** | `waste_management` |
| **Username** | `wm_user` (or `root` for XAMPP default) |
| **Password** | `wm_pass` (or empty for XAMPP root) |
| **Host** | `localhost` |
| **Port** | `3306` (XAMPP) or `3307` (Docker) |

## 📊 Sample Queries

```sql
-- View all citizens and their areas
SELECT c.Name, a.Area_Name 
FROM Citizen c 
JOIN LIVES l ON c.Citizen_ID = l.Citizen_ID 
JOIN Area a ON l.Area_ID = a.Area_ID;

-- View waste generation records (ternary relationship)
SELECT c.Name, w.Name as Waste, p.Amount 
FROM GENERATES g 
JOIN Citizen c ON g.Citizen_ID = c.Citizen_ID 
JOIN Waste w ON g.Waste_ID = w.Waste_ID 
JOIN Payment p ON g.Payment_ID = p.Payment_ID;

-- View collection schedules with crews
SELECT a.Area_Name, cs.Schedule_Date, c.Crew_Name 
FROM HAS_Schedule hs 
JOIN Area a ON hs.Area_ID = a.Area_ID 
JOIN Collection_Schedules cs ON hs.Schedule_ID = cs.Schedule_ID 
JOIN Crew c ON hs.Crew_ID = c.Crew_ID;
```

## 📝 Notes

- This database uses proper normalization with ER relationships
- All 36 dummy records are pre-populated with consistent relationships
- Foreign key constraints ensure referential integrity
- Supports many-to-many and ternary relationships
