#!/bin/bash

# Waste Management System - Quick Start Script
# This script sets up and runs the entire full-stack application

set -e

BASEDIR="/Users/punam/Desktop/varsity/3-1/Lab/dbms/Project/codebase"
BACKEND_DIR="$BASEDIR/backend"
FRONTEND_DIR="$BASEDIR/frontend"

echo "╔════════════════════════════════════════════════════════════════╗"
echo "║   Waste Management System - Full Stack Quick Start            ║"
echo "╚════════════════════════════════════════════════════════════════╝"
echo ""

# Color codes
GREEN='\033[0;32m'
BLUE='\033[0;34m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# Check prerequisites
echo -e "${BLUE}Checking prerequisites...${NC}"
echo ""

# Check PHP
if ! command -v php &> /dev/null; then
    echo -e "${YELLOW}⚠ PHP not found. Please install PHP 7.4+${NC}"
    exit 1
fi
PHP_VERSION=$(php -v | head -n 1)
echo -e "${GREEN}✓ PHP installed: $PHP_VERSION${NC}"

# Check Node.js
if ! command -v node &> /dev/null; then
    echo -e "${YELLOW}⚠ Node.js not found. Please install Node.js 16+${NC}"
    exit 1
fi
NODE_VERSION=$(node -v)
echo -e "${GREEN}✓ Node.js installed: $NODE_VERSION${NC}"

# Check npm
if ! command -v npm &> /dev/null; then
    echo -e "${YELLOW}⚠ npm not found.${NC}"
    exit 1
fi
NPM_VERSION=$(npm -v)
echo -e "${GREEN}✓ npm installed: v$NPM_VERSION${NC}"

# Check MySQL
if ! command -v mysql &> /dev/null; then
    echo -e "${YELLOW}⚠ MySQL not found. Installing...${NC}"
    brew install mysql
fi
MYSQL_VERSION=$(mysql --version)
echo -e "${GREEN}✓ MySQL installed: $MYSQL_VERSION${NC}"

echo ""
echo -e "${BLUE}Starting MySQL service...${NC}"
brew services start mysql || true
sleep 2

echo ""
echo -e "${BLUE}Installation Summary:${NC}"
echo "  Backend Path:  $BACKEND_DIR"
echo "  Frontend Path: $FRONTEND_DIR"
echo ""

# Ask user what to start
echo -e "${YELLOW}What would you like to do?${NC}"
echo "1) Setup database + start everything"
echo "2) Start backend only (port 8000)"
echo "3) Start frontend only (port 3000)"
echo "4) Start both backend and frontend"
read -p "Enter choice (1-4): " choice

case $choice in
    1)
        echo ""
        echo -e "${BLUE}Setting up database...${NC}"
        mysql -u root -p < "$BASEDIR/create_waste_management_db.sql" 2>/dev/null || echo "⚠ Database already exists"
        mysql -u root -p < "$BASEDIR/alter_add_constraints.sql" 2>/dev/null || echo "⚠ Constraints already applied"
        
        echo -e "${GREEN}✓ Database setup complete${NC}"
        echo ""
        echo -e "${BLUE}Installing frontend dependencies...${NC}"
        cd "$FRONTEND_DIR"
        npm install > /dev/null 2>&1
        echo -e "${GREEN}✓ Frontend dependencies installed${NC}"
        
        echo ""
        echo -e "${GREEN}🎉 System ready! Starting services...${NC}"
        echo ""
        
        # Start backend in background
        echo -e "${BLUE}Starting Backend API (port 8000)...${NC}"
        cd "$BACKEND_DIR"
        php -S localhost:8000 &
        BACKEND_PID=$!
        sleep 2
        echo -e "${GREEN}✓ Backend running (PID: $BACKEND_PID)${NC}"
        
        # Start frontend
        echo -e "${BLUE}Starting Frontend (port 3000)...${NC}"
        cd "$FRONTEND_DIR"
        npm run dev
        ;;
        
    2)
        echo ""
        echo -e "${BLUE}Starting Backend API (port 8000)...${NC}"
        cd "$BACKEND_DIR"
        php -S localhost:8000
        ;;
        
    3)
        echo ""
        echo -e "${BLUE}Installing frontend dependencies...${NC}"
        cd "$FRONTEND_DIR"
        npm install > /dev/null 2>&1
        
        echo -e "${BLUE}Starting Frontend (port 3000)...${NC}"
        npm run dev
        ;;
        
    4)
        echo ""
        echo -e "${BLUE}Installing frontend dependencies...${NC}"
        cd "$FRONTEND_DIR"
        npm install > /dev/null 2>&1
        echo -e "${GREEN}✓ Dependencies installed${NC}"
        
        echo ""
        echo -e "${GREEN}Starting both services...${NC}"
        echo ""
        
        # Start backend
        echo -e "${BLUE}Backend API: http://localhost:8000${NC}"
        cd "$BACKEND_DIR"
        php -S localhost:8000 &
        BACKEND_PID=$!
        sleep 2
        echo -e "${GREEN}✓ Backend running (PID: $BACKEND_PID)${NC}"
        
        echo ""
        echo -e "${BLUE}Frontend: http://localhost:3000${NC}"
        cd "$FRONTEND_DIR"
        echo "Press Ctrl+C to stop all services"
        
        # Start frontend (will block)
        npm run dev
        
        # Cleanup on exit
        trap "kill $BACKEND_PID 2>/dev/null" EXIT
        ;;
        
    *)
        echo "Invalid choice"
        exit 1
        ;;
esac
