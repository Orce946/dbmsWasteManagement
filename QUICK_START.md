# 🚀 Waste Management System - Quick Start Guide

## ✅ Current Status
- **Backend**: Running on `http://127.0.0.1:8000`
- **Frontend**: Running on `http://127.0.0.1:3000`
- **Database**: Connected (wasteManagement)

## 📋 To Start the Application

### Option 1: Manual Start (Two Terminal Windows)

**Terminal 1 - Backend:**
```bash
cd /Users/punam/Desktop/varsity/3-1/Lab/dbms/Project/codebase/backend
php -S 127.0.0.1:8000
```

**Terminal 2 - Frontend:**
```bash
cd /Users/punam/Desktop/varsity/3-1/Lab/dbms/Project/codebase/frontend
npm run dev
```

Then open browser to: **http://127.0.0.1:3000**

### Option 2: Automated Start Script

Create file: `/Users/punam/Desktop/varsity/3-1/Lab/dbms/Project/codebase/start.sh`

```bash
#!/bin/bash
killall -9 php node npm 2>/dev/null
sleep 2
cd /Users/punam/Desktop/varsity/3-1/Lab/dbms/Project/codebase/backend
php -S 127.0.0.1:8000 &
sleep 2
cd /Users/punam/Desktop/varsity/3-1/Lab/dbms/Project/codebase/frontend
npm run dev &
sleep 3
echo "✅ Backend: http://127.0.0.1:8000"
echo "✅ Frontend: http://127.0.0.1:3000"
echo "Open browser to http://127.0.0.1:3000"
```

Then run:
```bash
chmod +x /Users/punam/Desktop/varsity/3-1/Lab/dbms/Project/codebase/start.sh
./start.sh
```

## 🔍 Troubleshooting

**If page won't load:**
1. Check servers are running: `ps aux | grep -E "php|npm|node"`
2. Kill all: `killall -9 php node npm`
3. Restart both servers from top

**If Backend API not responding:**
- Check: `curl http://127.0.0.1:8000/areas`
- Should return: `{"success":true,"data":[]}`

**If Frontend not loading:**
- Check Vite output shows: `Local: http://127.0.0.1:3000/`
- Clear browser cache and refresh

## 📊 Features Available

- **Dashboard** - Overview and statistics
- **Areas** - Manage waste collection areas
- **Bills** - Billing management
- **Payments** - Payment tracking
- **Citizens** - Citizen information
- **Waste** - Waste management

## 🛠️ Technologies

- **Backend**: PHP 8.4.14 with MySQLi
- **Frontend**: React 18.2 + Vite 4.5
- **Database**: MySQL 5.7+
- **Styling**: Tailwind CSS 3.3
- **Charts**: Recharts 2.7

## 📝 Important Files

- Backend routes: `/codebase/backend/routes/*.php`
- Frontend pages: `/codebase/frontend/src/pages/`
- Database config: `/codebase/backend/config/Database.php`
- API config: `/codebase/frontend/src/services/api.js`

---

**Status**: ✅ All systems operational
**Last Updated**: 11 November 2025, 9:50 AM
