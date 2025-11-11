#!/bin/bash

# Waste Management System - Development Startup Script
# This script starts both backend and frontend servers

echo "🚀 Starting Waste Management System..."
echo ""

# Color codes
GREEN='\033[0;32m'
BLUE='\033[0;34m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# Get the current directory
CODEBASE_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
BACKEND_DIR="$CODEBASE_DIR/backend"
FRONTEND_DIR="$CODEBASE_DIR/frontend"

# Check if directories exist
if [ ! -d "$BACKEND_DIR" ]; then
    echo -e "${YELLOW}❌ Backend directory not found: $BACKEND_DIR${NC}"
    exit 1
fi

if [ ! -d "$FRONTEND_DIR" ]; then
    echo -e "${YELLOW}❌ Frontend directory not found: $FRONTEND_DIR${NC}"
    exit 1
fi

# Start Backend
echo -e "${BLUE}Starting Backend Server...${NC}"
cd "$BACKEND_DIR"
php -S localhost:8000 &
BACKEND_PID=$!
echo -e "${GREEN}✅ Backend started on http://localhost:8000${NC}"
echo "   PID: $BACKEND_PID"
echo ""

# Start Frontend
echo -e "${BLUE}Starting Frontend Server...${NC}"
cd "$FRONTEND_DIR"
npm run dev &
FRONTEND_PID=$!
echo -e "${GREEN}✅ Frontend started on http://localhost:3000${NC}"
echo "   PID: $FRONTEND_PID"
echo ""

# Display information
echo -e "${GREEN}═══════════════════════════════════════════════════════════${NC}"
echo -e "${GREEN}Both servers are running!${NC}"
echo ""
echo "🌐 Frontend:  http://localhost:3000"
echo "⚙️  Backend:   http://localhost:8000"
echo ""
echo "📋 Database:  wasteManagement"
echo ""
echo -e "${YELLOW}To stop the servers, press Ctrl+C${NC}"
echo -e "${GREEN}═══════════════════════════════════════════════════════════${NC}"
echo ""

# Wait for both processes
wait $BACKEND_PID $FRONTEND_PID
