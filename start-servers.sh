#!/bin/bash

# Kill any existing processes
killall -9 php node npm 2>/dev/null
sleep 2

# Get the base directory
BASE_DIR="/Users/punam/Desktop/varsity/3-1/Lab/dbms/Project/codebase"

echo "=========================================="
echo "Starting Waste Management System"
echo "=========================================="
echo ""

# Start Backend
echo "🚀 Starting Backend (PHP)..."
cd "$BASE_DIR/backend"
php -S 127.0.0.1:8000 > /tmp/backend.log 2>&1 &
BACKEND_PID=$!
echo "✅ Backend PID: $BACKEND_PID"
sleep 2

# Start Frontend
echo "🚀 Starting Frontend (Vite)..."
cd "$BASE_DIR/frontend"
npm run dev > /tmp/frontend.log 2>&1 &
FRONTEND_PID=$!
echo "✅ Frontend PID: $FRONTEND_PID"
sleep 3

# Verify
echo ""
echo "=========================================="
echo "Server Status:"
echo "=========================================="
ps aux | grep -E "php|vite|npm" | grep -v grep | grep -v Code | head -5

echo ""
echo "=========================================="
echo "URLs:"
echo "=========================================="
echo "🔗 Backend API:  http://127.0.0.1:8000"
echo "🔗 Frontend UI:  http://127.0.0.1:3000"
echo "=========================================="
echo ""

# Test Backend
echo "🧪 Testing Backend API..."
sleep 1
curl -s http://127.0.0.1:8000/areas | jq . 2>/dev/null && echo "✅ Backend responding" || echo "❌ Backend not responding"

echo ""
echo "✅ All servers started!"
echo ""
echo "Open your browser to: http://127.0.0.1:3000"
echo ""
