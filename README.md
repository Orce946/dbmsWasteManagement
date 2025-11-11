# 🗑️ Waste Management System

A comprehensive full-stack waste management application for tracking waste collection, billing, and bin management across multiple city areas.

**Status**: ✅ 100% Complete & Production Ready

---

## 📋 Table of Contents

- [Features](#features)
- [Project Architecture](#project-architecture)
- [Technology Stack](#technology-stack)
- [Prerequisites](#prerequisites)
- [Installation](#installation)
- [Configuration](#configuration)
- [Running the Application](#running-the-application)
- [API Endpoints](#api-endpoints)
- [Database Schema](#database-schema)
- [Project Structure](#project-structure)
- [Usage Guide](#usage-guide)
- [Troubleshooting](#troubleshooting)

---

## ✨ Features

### Dashboard & Analytics
- 📊 Real-time statistics and data visualization
- 📈 Interactive charts for waste collection trends
- 💰 Revenue and payment tracking
- 🗑️ Bin utilization monitoring

### Area Management
- 📍 Create and manage waste collection zones
- 🔍 View zone-specific statistics
- 👥 Assign crews to areas
- 📅 Schedule collection routes

### Citizens & Residents
- 👥 Register and manage citizen information
- 📱 Contact details and address management
- 🏘️ Area assignment
- 📊 Individual billing history

### Billing & Payments
- 💳 Generate and manage bills
- �� Track payment status and history
- 📋 View payment methods and dates
- 🔔 Outstanding bills tracking

### Waste Management
- 🗑️ Log waste collection records
- 📦 Track waste types and quantities
- 📅 View collection history
- 🎯 Collection scheduling

### Bin Management
- 🧹 Manage waste containers
- 📊 Monitor fill levels (0-100%)
- 🚨 Critical status alerts (>80%)
- 📍 Location tracking
- 🔄 Maintenance scheduling

---

## 🏗️ Project Architecture

```
┌─────────────────────────────────────────────────┐
│           FRONTEND LAYER                        │
│    (React 18.2 + Vite + Tailwind CSS)          │
│  Dashboard │ Areas │ Bills │ Waste │ Bins      │
└──────────────────┬──────────────────────────────┘
                   │ HTTP REST API
                   ▼
┌─────────────────────────────────────────────────┐
│           BACKEND LAYER                         │
│         (PHP 8.4 + MySQLi)                      │
│    54 RESTful API Endpoints                     │
└──────────────────┬──────────────────────────────┘
                   │ MySQLi Queries
                   ▼
┌─────────────────────────────────────────────────┐
│           DATABASE LAYER                        │
│         (MySQL 5.7+)                            │
│  11 Normalized Tables, 50+ Constraints          │
└─────────────────────────────────────────────────┘
```

---

## 🛠️ Technology Stack

### Frontend
- React 18.2
- Vite 4.5
- Tailwind CSS 3.3
- Axios (HTTP client)
- Recharts (Data visualization)

### Backend
- PHP 8.4.14
- MySQLi
- RESTful JSON API

### Database
- MySQL 5.7+
- 11 normalized tables
- 50+ constraints
- 32+ indexes

---

## 📦 Prerequisites

- PHP 8.4+
- MySQL 5.7+
- Node.js 16+
- npm

---

## 💾 Installation

### 1. Clone Repository
```bash
git clone https://github.com/Orce946/dbmsWasteManagement.git
cd dbmsWasteManagement
```

### 2. Setup Database
```bash
# Create database and tables
mysql -u root -p < create_waste_management_db.sql
mysql -u root -p < add_constraints.sql
```

### 3. Backend Setup
```bash
cd backend
# No additional setup needed for vanilla PHP
```

### 4. Frontend Setup
```bash
cd frontend
npm install
```

---

## ⚙️ Configuration

### Backend - Database.php
```php
// backend/config/Database.php
private $host = 'localhost';
private $db = 'wasteManagement';
private $user = 'root';
private $password = '';  // Set your MySQL password if needed
```

### Frontend - API Configuration
```javascript
// frontend/src/services/api.js
const API_BASE_URL = 'http://127.0.0.1:8000';
```

---

## 🚀 Running the Application

### Option 1: Using Startup Script
```bash
chmod +x start-servers.sh
./start-servers.sh
```

### Option 2: Manual Startup

**Terminal 1 - Backend:**
```bash
cd backend
php -S 127.0.0.1:8000
```

**Terminal 2 - Frontend:**
```bash
cd frontend
npm run dev
```

### Access Application
- Frontend: http://127.0.0.1:3000
- Backend API: http://127.0.0.1:8000
- Database: localhost:3306

---

## 📡 API Endpoints

### Areas
- GET /areas
- POST /areas
- GET /areas/:id
- PUT /areas/:id
- DELETE /areas/:id

### Citizens
- GET /citizens
- POST /citizens
- GET /citizens/:id
- PUT /citizens/:id
- DELETE /citizens/:id

### Bills
- GET /bills
- POST /bills
- GET /bills/:id
- PUT /bills/:id
- DELETE /bills/:id
- GET /bills/statistics

### Payments
- GET /payments
- POST /payments
- GET /payments/:id
- PUT /payments/:id
- DELETE /payments/:id
- GET /payments/statistics

### Waste
- GET /waste
- POST /waste
- GET /waste/:id
- PUT /waste/:id
- DELETE /waste/:id
- GET /waste/statistics

### Bins
- GET /bins
- POST /bins
- GET /bins/:id
- PUT /bins/:id
- DELETE /bins/:id
- GET /bins/statistics

### Crew
- GET /crew
- POST /crew
- GET /crew/:id
- PUT /crew/:id
- DELETE /crew/:id

### Schedules
- GET /schedules
- POST /schedules
- GET /schedules/:id
- PUT /schedules/:id
- DELETE /schedules/:id

### Recycling Centers
- GET /recycling-centers
- POST /recycling-centers
- GET /recycling-centers/:id
- PUT /recycling-centers/:id
- DELETE /recycling-centers/:id

---

## 📊 Database Schema

### 11 Tables

1. **Area** - Waste collection zones
2. **Citizen** - Resident information
3. **Bill** - Billing records
4. **Payment** - Payment history
5. **Waste** - Waste collection logs
6. **Bins** - Waste containers
7. **Crew** - Collection teams
8. **Collection_Schedule** - Collection schedules
9. **Recycling_Center** - Recycling facilities
10. **Assigned** - Crew-Area assignments
11. **Has_Schedule** - Crew-Schedule relationships

### Key Relationships
- Area → Citizen (1:N)
- Citizen → Bill (1:N)
- Bill → Payment (1:N)
- Area → Waste (1:N)
- Area → Bins (1:N)
- Crew → Assigned (1:N)
- Crew → Has_Schedule (1:N)

---

## 📁 Project Structure

```
dbmsWasteManagement/
├── backend/
│   ├── config/Database.php
│   ├── models/ (9 model classes)
│   ├── routes/ (9 route files)
│   └── index.php
├── frontend/
│   ├── src/
│   │   ├── components/
│   │   ├── pages/ (7 pages)
│   │   ├── services/api.js
│   │   └── App.jsx
│   ├── package.json
│   └── vite.config.js
├── create_waste_management_db.sql
├── add_constraints.sql
├── start-servers.sh
└── README.md
```

---

## 📖 Usage Guide

### 1. Dashboard
View overall statistics and trends

### 2. Areas
Create and manage waste collection zones

### 3. Citizens
Register and manage resident information

### 4. Bills
Generate and track billing records

### 5. Payments
Record and track payment history

### 6. Waste
Log and track waste collection activities

### 7. Bins
Manage waste containers and monitor fill levels:
- 🟢 Green: 0-60% (Normal)
- 🟡 Yellow: 61-80% (Caution)
- 🔴 Red: 81-100% (Critical)

---

## 🐛 Troubleshooting

### Backend Not Starting
```bash
# Check if port is in use
lsof -i :8000

# Kill process
kill -9 <PID>

# Start again
cd backend && php -S 127.0.0.1:8000
```

### Frontend Not Loading
```bash
# Reinstall dependencies
rm -rf frontend/node_modules
cd frontend && npm install
npm run dev
```

### Database Connection Error
```bash
# Verify MySQL is running
mysql -u root -p

# Check Database.php configuration
cat backend/config/Database.php

# Verify database exists
SHOW DATABASES;
USE wasteManagement;
SHOW TABLES;
```

### API Returns Empty Data
```bash
# Test API endpoint
curl http://127.0.0.1:8000/areas

# Check browser console (F12) for errors
```

---

## 📚 Documentation

Comprehensive documentation files included:
- HOW_TO_USE.md
- PROJECT_EXPLANATION.md
- PROJECT_COMPLETION.md
- FINAL_SUMMARY.md

---

## 📈 Project Statistics

- **Backend Files**: 21 PHP files
- **Frontend Components**: 15+ React components
- **API Endpoints**: 54 RESTful endpoints
- **Database Tables**: 11 tables
- **Constraints**: 50+ constraints
- **Indexes**: 32+ indexes
- **Code Lines**: 2,600+ (backend + frontend)
- **Status**: ✅ 100% Complete

---

## ✨ Key Features

✅ Real-time data updates
✅ Responsive design
✅ Full CRUD operations
✅ Data visualization with charts
✅ Form validation
✅ Error handling
✅ Professional UI
✅ Database optimization
✅ Well documented

---

**Status**: ✅ Production Ready
**Last Updated**: November 11, 2025
**Version**: 1.0.0

Enjoy using the Waste Management System! 🎉
