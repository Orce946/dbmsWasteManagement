#!/bin/bash

# Comprehensive Startup Script for Waste Management System
# Shows real-time status and keeps servers running

set -e

CODEBASE_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
BACKEND_DIR="$CODEBASE_DIR/backend"
FRONTEND_DIR="$CODEBASE_DIR/frontend"

echo ""
echo "╔════════════════════════════════════════════════════════════╗"
echo "║  WASTE MANAGEMENT SYSTEM - LOCAL DEVELOPMENT STARTUP       ║"
echo "╚════════════════════════════════════════════════════════════╝"
echo ""

# Kill any existing processes on ports 8000 and 3000
echo "🧹 Cleaning up ports..."
lsof -i :8000 > /dev/null 2>&1 && { echo "   Killing process on port 8000..."; kill -9 $(lsof -i :8000 | awk 'NR==2 {print $2}') 2>/dev/null || true; }
lsof -i :3000 > /dev/null 2>&1 && { echo "   Killing process on port 3000..."; kill -9 $(lsof -i :3000 | awk 'NR==2 {print $2}') 2>/dev/null || true; }
sleep 1
echo "   ✅ Ports cleaned"
echo ""

# Start Backend
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "🚀 STARTING BACKEND SERVER"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "   Directory: $BACKEND_DIR"
echo "   Command: php -S 127.0.0.1:8000"
cd "$BACKEND_DIR"

php -S 127.0.0.1:8000 > /tmp/backend.log 2>&1 &
BACKEND_PID=$!
echo "   PID: $BACKEND_PID"
echo "   Waiting for startup..."
sleep 2

# Test backend
if curl -s "http://127.0.0.1:8000/index.php" > /dev/null 2>&1; then
    echo "   ✅ Backend is responding"
else
    echo "   ❌ Backend not responding yet, but process is running"
fi
echo ""

# Start Frontend
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "⚛️  STARTING FRONTEND SERVER"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "   Directory: $FRONTEND_DIR"
echo "   Command: npm run dev"
cd "$FRONTEND_DIR"

npm run dev > /tmp/frontend.log 2>&1 &
FRONTEND_PID=$!
echo "   PID: $FRONTEND_PID"
echo "   Waiting for startup..."
sleep 3

if curl -s "http://127.0.0.1:3000" > /dev/null 2>&1; then
    echo "   ✅ Frontend is responding"
else
    echo "   ⚠️  Frontend starting (this is normal, may take a moment)"
fi
echo ""

# Display Summary
echo "╔════════════════════════════════════════════════════════════╗"
echo "║                  SERVERS STARTED SUCCESSFULLY              ║"
echo "╠════════════════════════════════════════════════════════════╣"
echo "║                                                            ║"
echo "║  🌐 FRONTEND:                                              ║"
echo "║     http://127.0.0.1:3000                                  ║"
echo "║     PID: $FRONTEND_PID                                              ║"
echo "║                                                            ║"
echo "║  ⚙️  BACKEND API:                                           ║"
echo "║     http://127.0.0.1:8000                                  ║"
echo "║     PID: $BACKEND_PID                                               ║"
echo "║                                                            ║"
echo "║  📊 DATABASE:                                              ║"
echo "║     wasteManagement (MySQL)                                ║"
echo "║                                                            ║"
echo "╠════════════════════════════════════════════════════════════╣"
echo "║  Open your browser and go to:                              ║"
echo "║  👉  http://127.0.0.1:3000                                 ║"
echo "║                                                            ║"
echo "║  Server logs:                                              ║"
echo "║  • Backend:  tail -f /tmp/backend.log                      ║"
echo "║  • Frontend: tail -f /tmp/frontend.log                     ║"
echo "║                                                            ║"
echo "║  To stop servers, press Ctrl+C                             ║"
echo "║                                                            ║"
echo "╚════════════════════════════════════════════════════════════╝"
echo ""

# Keep processes running and wait for interrupt
trap "echo ''; echo '🛑 Shutting down servers...'; kill $BACKEND_PID $FRONTEND_PID 2>/dev/null || true; echo '✅ Servers stopped'; exit" INT

wait $BACKEND_PID $FRONTEND_PID
