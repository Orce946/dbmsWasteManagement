#!/bin/bash

# Waste Management System - Development Server Controller
# This script manages both frontend and backend servers

set -e

PROJECT_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
FRONTEND_DIR="$PROJECT_ROOT/frontend"
BACKEND_DIR="$PROJECT_ROOT/backend"

# Colors for output
GREEN='\033[0;32m'
RED='\033[0;31m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# Function to print colored messages
print_status() {
    echo -e "${GREEN}[$(date +'%H:%M:%S')]${NC} $1"
}

print_error() {
    echo -e "${RED}[$(date +'%H:%M:%S')] ERROR:${NC} $1"
}

print_warning() {
    echo -e "${YELLOW}[$(date +'%H:%M:%S')] WARNING:${NC} $1"
}

# Function to stop servers
stop_servers() {
    print_status "Stopping servers..."
    pkill -f "php -S" 2>/dev/null || true
    pkill -f "npm run dev" 2>/dev/null || true
    pkill -f "node.*vite" 2>/dev/null || true
    sleep 2
    print_status "Servers stopped"
}

# Function to start backend
start_backend() {
    print_status "Starting backend PHP server on port 8000..."
    cd "$BACKEND_DIR"
    php -S 127.0.0.1:8000 router.php > /tmp/php_backend.log 2>&1 &
    PHP_PID=$!
    sleep 2
    
    if kill -0 $PHP_PID 2>/dev/null; then
        print_status "Backend server started successfully (PID: $PHP_PID)"
    else
        print_error "Failed to start backend server"
        cat /tmp/php_backend.log
        exit 1
    fi
}

# Function to start frontend
start_frontend() {
    print_status "Starting frontend Vite server on port 3000..."
    cd "$FRONTEND_DIR"
    npm run dev > /tmp/vite_frontend.log 2>&1 &
    VITE_PID=$!
    sleep 5
    
    if kill -0 $VITE_PID 2>/dev/null; then
        print_status "Frontend server started successfully (PID: $VITE_PID)"
    else
        print_error "Failed to start frontend server"
        cat /tmp/vite_frontend.log
        exit 1
    fi
}

# Function to check servers
check_servers() {
    print_status "Checking server status..."
    
    # Check backend
    if curl -s http://127.0.0.1:8000 > /dev/null 2>&1; then
        print_status "✓ Backend API is responding"
    else
        print_error "✗ Backend API is not responding"
        return 1
    fi
    
    # Check frontend
    if curl -s http://localhost:3000 > /dev/null 2>&1; then
        print_status "✓ Frontend is responding"
    else
        print_warning "✗ Frontend is still starting (this is normal)"
    fi
}

# Main logic
case "${1:-start}" in
    start)
        print_status "Starting Waste Management System..."
        stop_servers
        start_backend
        start_frontend
        sleep 2
        check_servers
        print_status "================================"
        print_status "System ready!"
        print_status "Frontend: http://localhost:3000"
        print_status "Backend:  http://127.0.0.1:8000"
        print_status "================================"
        ;;
    stop)
        stop_servers
        ;;
    restart)
        print_status "Restarting servers..."
        stop_servers
        sleep 1
        $0 start
        ;;
    status)
        print_status "Server Status:"
        ps aux | grep -E "php -S|npm run dev" | grep -v grep || print_warning "No servers running"
        ;;
    logs)
        print_status "Backend logs:"
        tail -20 /tmp/php_backend.log 2>/dev/null || print_warning "No backend logs"
        echo ""
        print_status "Frontend logs:"
        tail -20 /tmp/vite_frontend.log 2>/dev/null || print_warning "No frontend logs"
        ;;
    *)
        echo "Usage: $0 {start|stop|restart|status|logs}"
        echo ""
        echo "Commands:"
        echo "  start    - Start both backend and frontend servers"
        echo "  stop     - Stop both servers"
        echo "  restart  - Restart both servers"
        echo "  status   - Show server status"
        echo "  logs     - Show recent server logs"
        exit 1
        ;;
esac

exit 0
