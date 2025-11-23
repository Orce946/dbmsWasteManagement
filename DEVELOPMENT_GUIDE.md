# Quick Start Guide - Waste Management System

## Starting the System (New Method)

From the project root directory, simply run:

```bash
./dev-server.sh start
```

This will:
- Stop any existing servers
- Start the backend PHP server on port 8000
- Start the frontend Vite server on port 3000
- Verify both servers are running
- Show you the access URLs

## Common Commands

### Check Status
```bash
./dev-server.sh status
```

### View Logs
```bash
./dev-server.sh logs
```

### Restart Servers
```bash
./dev-server.sh restart
```

### Stop Servers
```bash
./dev-server.sh stop
```

## Accessing the Application

Once servers are started:
- **Frontend:** http://localhost:3000
- **Backend API:** http://127.0.0.1:8000

## What to Do If localhost Still Fails

1. **Check status:**
   ```bash
   ./dev-server.sh status
   ```

2. **View logs:**
   ```bash
   ./dev-server.sh logs
   ```

3. **Force restart:**
   ```bash
   ./dev-server.sh restart
   ```

4. **Manual restart (if needed):**
   ```bash
   # Stop everything
   pkill -f "php -S"
   pkill -f "npm run dev"
   
   # Wait a moment
   sleep 2
   
   # Start again
   ./dev-server.sh start
   ```

## Why Servers Might Stop

1. File changes with compilation errors
2. Port conflicts
3. Out of memory
4. Network issues

The new vite config includes:
- File watching with polling (more stable on macOS)
- HMR (Hot Module Replacement) configuration
- Better error handling
- Auto-restart capability

## Troubleshooting

### Port 3000 Already in Use
```bash
lsof -i :3000
```
This will show what's using the port. Kill it with:
```bash
kill -9 <PID>
```

### Port 8000 Already in Use
```bash
lsof -i :8000
```
Kill the process similarly.

### Vite Server Won't Start
1. Check `/tmp/vite_frontend.log` for errors
2. Delete node_modules and reinstall:
   ```bash
   rm -rf frontend/node_modules
   npm install --prefix frontend
   ```
3. Then restart with `./dev-server.sh start`

### Backend PHP Server Won't Start
1. Check `/tmp/php_backend.log` for errors
2. Make sure MySQL/Database is running
3. Check database connection in `backend/config/Database.php`

## Notes

- The script automatically handles cleanup of old processes
- Both servers log to `/tmp/` for debugging
- The frontend uses Vite with hot module reloading
- Backend uses PHP built-in server with router.php
- Both services are designed to be stable during development

## Next Steps

- Make your changes to the code
- The frontend will automatically reload (HMR)
- Backend changes require manual reload if they're in routes or models
- Always commit changes with descriptive messages
