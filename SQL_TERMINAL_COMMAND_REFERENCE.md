# SQL TERMINAL COMMAND REFERENCE CARD

## Quick Copy-Paste Commands for Testing SQL JOINs

All commands are ready to copy and paste directly into terminal.

---

## CITIZENS AND AREAS

### Show all citizens with their areas
```bash
mysql -u root wasteManagement -e "SELECT c.citizen_id, c.name, a.area_name FROM Citizen c INNER JOIN Area a ON c.area_id = a.area_id;"
```

### Show areas with citizen counts
```bash
mysql -u root wasteManagement -e "SELECT a.area_id, a.area_name, COUNT(c.citizen_id) AS total_citizens FROM Area a LEFT JOIN Citizen c ON a.area_id = c.area_id GROUP BY a.area_id, a.area_name;"
```

### Show all areas including empty ones
```bash
mysql -u root wasteManagement -e "SELECT a.area_id, a.area_name FROM Area a;"
```

---

## WASTE MANAGEMENT

### Show waste records with citizen and area information
```bash
mysql -u root wasteManagement -e "SELECT w.waste_id, w.waste_type, w.quantity, w.status, c.name AS citizen_name, a.area_name FROM Waste w LEFT JOIN Citizen c ON w.citizen_id = c.citizen_id LEFT JOIN Area a ON w.area_id = a.area_id;"
```

### Show waste statistics by type
```bash
mysql -u root wasteManagement -e "SELECT w.waste_type, COUNT(w.waste_id) AS count, SUM(w.quantity) AS total_kg, ROUND(AVG(w.quantity), 2) AS avg_kg FROM Waste w GROUP BY w.waste_type;"
```

### Show waste statistics by status
```bash
mysql -u root wasteManagement -e "SELECT w.status, COUNT(w.waste_id) AS count, SUM(w.quantity) AS total_kg FROM Waste w GROUP BY w.status;"
```

---

## BILLING AND PAYMENTS

### Show all bills with citizen information
```bash
mysql -u root wasteManagement -e "SELECT b.bill_id, b.amount, b.status, b.due_date, c.name FROM Bill b LEFT JOIN Citizen c ON b.citizen_id = c.citizen_id;"
```

### Show bill payment status
```bash
mysql -u root wasteManagement -e "SELECT b.bill_id, b.amount, b.status, COUNT(p.payment_id) AS payments, SUM(p.amount) AS paid FROM Bill b LEFT JOIN Payment p ON b.bill_id = p.bill_id GROUP BY b.bill_id, b.amount, b.status;"
```

### Show payments by method
```bash
mysql -u root wasteManagement -e "SELECT p.method, COUNT(p.payment_id) AS count, SUM(p.amount) AS total FROM Payment p GROUP BY p.method;"
```

### Show citizen billing summary
```bash
mysql -u root wasteManagement -e "SELECT c.citizen_id, c.name, COUNT(b.bill_id) AS total_bills, SUM(b.amount) AS total_amount FROM Citizen c LEFT JOIN Bill b ON c.citizen_id = b.citizen_id GROUP BY c.citizen_id, c.name;"
```

---

## BINS AND AREAS

### Show bins with area information
```bash
mysql -u root wasteManagement -e "SELECT b.bin_id, b.status, b.fill_level, b.location, a.area_name FROM Bins b LEFT JOIN Area a ON b.area_id = a.area_id;"
```

### Show area bin statistics
```bash
mysql -u root wasteManagement -e "SELECT a.area_name, COUNT(b.bin_id) AS total_bins, SUM(CASE WHEN b.status = 'Full' THEN 1 ELSE 0 END) AS full_bins, ROUND(AVG(b.fill_level), 2) AS avg_fill FROM Area a LEFT JOIN Bins b ON a.area_id = b.area_id GROUP BY a.area_id, a.area_name;"
```

---

## CREW AND SCHEDULES

### Show crew members with area assignments
```bash
mysql -u root wasteManagement -e "SELECT c.crew_id, c.crew_name, c.contact, a.area_name FROM Crew c LEFT JOIN Area a ON c.area_id = a.area_id;"
```

### Show areas with assigned crew
```bash
mysql -u root wasteManagement -e "SELECT a.area_name, COUNT(c.crew_id) AS total_crew, GROUP_CONCAT(c.crew_name) AS crew_members FROM Area a LEFT JOIN Crew c ON a.area_id = c.area_id GROUP BY a.area_id, a.area_name;"
```

### Show collection schedules
```bash
mysql -u root wasteManagement -e "SELECT cs.schedule_id, cs.schedule_date, a.area_name, DAYNAME(cs.schedule_date) AS day FROM Collection_Schedule cs LEFT JOIN Area a ON cs.area_id = a.area_id;"
```

---

## MULTI-TABLE JOINS (Complex)

### Complete citizen profile with all related data (5-table join)
```bash
mysql -u root wasteManagement -e "SELECT c.citizen_id, c.name, a.area_name, COUNT(DISTINCT b.bill_id) AS bills, COUNT(DISTINCT w.waste_id) AS waste_records FROM Citizen c LEFT JOIN Area a ON c.area_id = a.area_id LEFT JOIN Bill b ON c.citizen_id = b.citizen_id LEFT JOIN Waste w ON c.citizen_id = w.citizen_id GROUP BY c.citizen_id, c.name, a.area_name;"
```

### Area operations overview (6-table join)
```bash
mysql -u root wasteManagement -e "SELECT a.area_id, a.area_name, COUNT(DISTINCT c.citizen_id) AS citizens, COUNT(DISTINCT b.bill_id) AS bills, COUNT(DISTINCT crew.crew_id) AS crew_members, COUNT(DISTINCT bin.bin_id) AS total_bins FROM Area a LEFT JOIN Citizen c ON a.area_id = c.area_id LEFT JOIN Bill b ON c.citizen_id = b.citizen_id LEFT JOIN Crew crew ON a.area_id = crew.area_id LEFT JOIN Bins bin ON a.area_id = bin.area_id GROUP BY a.area_id, a.area_name;"
```

### Billing and payment tracking
```bash
mysql -u root wasteManagement -e "SELECT c.citizen_id, c.name, b.bill_id, b.amount, COUNT(p.payment_id) AS payments, SUM(p.amount) AS paid, (b.amount - COALESCE(SUM(p.amount), 0)) AS outstanding FROM Citizen c LEFT JOIN Bill b ON c.citizen_id = b.citizen_id LEFT JOIN Payment p ON b.bill_id = p.bill_id GROUP BY c.citizen_id, b.bill_id;"
```

---

## TERNARY RELATIONSHIPS

### Show crew assignments to areas with schedules
```bash
mysql -u root wasteManagement -e "SELECT a.area_name, c.crew_name, cs.schedule_date, DAYNAME(cs.schedule_date) AS day FROM Has_Schedule hs INNER JOIN Area a ON hs.area_id = a.area_id INNER JOIN Crew c ON hs.crew_id = c.crew_id INNER JOIN Collection_Schedule cs ON hs.schedule_id = cs.schedule_id;"
```

### Show schedule assignments
```bash
mysql -u root wasteManagement -e "SELECT cs.schedule_date, a.area_name, COUNT(DISTINCT c.crew_id) AS assigned_crews, GROUP_CONCAT(DISTINCT c.crew_name) AS crew_names FROM Collection_Schedule cs LEFT JOIN Has_Schedule hs ON cs.schedule_id = hs.schedule_id LEFT JOIN Area a ON cs.area_id = a.area_id LEFT JOIN Crew c ON hs.crew_id = c.crew_id GROUP BY cs.schedule_id, cs.schedule_date, a.area_name;"
```

---

## DATA INTEGRITY CHECKS

### Find orphaned bills (bills without citizens)
```bash
mysql -u root wasteManagement -e "SELECT b.bill_id FROM Bill b WHERE b.citizen_id NOT IN (SELECT citizen_id FROM Citizen);"
```

### Find unused areas (no citizens assigned)
```bash
mysql -u root wasteManagement -e "SELECT a.area_id, a.area_name FROM Area a LEFT JOIN Citizen c ON a.area_id = c.area_id WHERE c.citizen_id IS NULL GROUP BY a.area_id, a.area_name;"
```

### Check all relationships summary
```bash
mysql -u root wasteManagement -e "SELECT 'Citizens' AS entity, COUNT(*) AS count FROM Citizen UNION ALL SELECT 'Areas', COUNT(*) FROM Area UNION ALL SELECT 'Bills', COUNT(*) FROM Bill UNION ALL SELECT 'Waste Records', COUNT(*) FROM Waste UNION ALL SELECT 'Payments', COUNT(*) FROM Payment UNION ALL SELECT 'Crew', COUNT(*) FROM Crew UNION ALL SELECT 'Bins', COUNT(*) FROM Bins;"
```

---

## DATABASE INFO

### Show all tables
```bash
mysql -u root wasteManagement -e "SHOW TABLES;"
```

### Show table structure
```bash
mysql -u root wasteManagement -e "DESCRIBE Citizen;"
mysql -u root wasteManagement -e "DESCRIBE Area;"
mysql -u root wasteManagement -e "DESCRIBE Bill;"
mysql -u root wasteManagement -e "DESCRIBE Waste;"
```

### Count records in each table
```bash
mysql -u root wasteManagement -e "SELECT 'Citizen' AS table_name, COUNT(*) AS records FROM Citizen UNION ALL SELECT 'Area', COUNT(*) FROM Area UNION ALL SELECT 'Bill', COUNT(*) FROM Bill UNION ALL SELECT 'Waste', COUNT(*) FROM Waste UNION ALL SELECT 'Payment', COUNT(*) FROM Payment;"
```

---

## FILE-BASED OPERATIONS

### Run all JOIN queries
```bash
mysql -u root wasteManagement < SQL_JOIN_QUERIES_TERMINAL.sql
```

### Run and save results
```bash
mysql -u root wasteManagement -e "SELECT * FROM Citizen;" > citizen_results.txt
cat citizen_results.txt
```

### Load SQL file and save output
```bash
mysql -u root wasteManagement < SQL_JOIN_QUERIES_TERMINAL.sql > all_results.txt
```

---

## TIPS AND TRICKS

### Limit results for testing (always good practice)
```bash
mysql -u root wasteManagement -e "SELECT * FROM Citizen LIMIT 5;"
```

### Sort results
```bash
mysql -u root wasteManagement -e "SELECT * FROM Citizen ORDER BY name ASC LIMIT 10;"
```

### Search for specific data
```bash
mysql -u root wasteManagement -e "SELECT * FROM Citizen WHERE name LIKE '%Ahmed%';"
```

### Format output in columns
```bash
mysql -u root wasteManagement -e "SELECT c.citizen_id, c.name, a.area_name FROM Citizen c LEFT JOIN Area a ON c.area_id = a.area_id" | column -t
```

---

## COMMON MYSQL CONNECTION OPTIONS

```bash
# Standard connection
mysql -u root wasteManagement

# With password
mysql -u root -p wasteManagement

# Execute query directly
mysql -u root wasteManagement -e "QUERY"

# Execute from file
mysql -u root wasteManagement < file.sql

# Save output to file
mysql -u root wasteManagement -e "QUERY" > output.txt

# Pipe through other commands
mysql -u root wasteManagement -e "QUERY" | grep "pattern"

# Format as table
mysql -u root wasteManagement -e "QUERY" | column -t
```

---

## DOCUMENTATION FILES

📄 **SQL_JOINS_DOCUMENTATION.md** - Complete guide with explanations
📄 **SQL_JOINS_QUICK_REFERENCE.md** - 15 most useful queries
📄 **SQL_JOIN_QUERIES_TERMINAL.sql** - 50+ executable queries
📄 **SQL_JOINS_PROJECT_SUMMARY.md** - Project overview
📄 **SQL_TERMINAL_COMMAND_REFERENCE.md** - This file

---

## SCHEMA QUICK REFERENCE

```
TABLES:
- Citizen (citizen_id, name, address, contact, area_id)
- Area (area_id, area_name, description)
- Bill (bill_id, citizen_id, amount, status, due_date)
- Payment (payment_id, citizen_id, bill_id, amount, method, payment_date)
- Waste (waste_id, citizen_id, area_id, waste_type, quantity, status, collection_date)
- Crew (crew_id, area_id, crew_name, contact)
- Bins (bin_id, area_id, status, fill_level, location, capacity, sensor)
- Collection_Schedule (schedule_id, area_id, schedule_date)
- Has_Schedule (has_schedule_id, area_id, crew_id, schedule_id)
- Assigned (team_id, area_id, team_name)
- Recycling_Center (center_id, waste_id, location, capacity)
```

---

## KEYBOARD SHORTCUTS IN MYSQL

```
Ctrl+C       - Exit query/cancel
exit         - Exit MySQL
quit         - Exit MySQL
clear        - Clear screen
status       - Show connection status
help         - Show help
```

---

**Last Updated:** 2025-11-23
**Database:** wasteManagement
**MySQL User:** root
**Testing Status:** ✅ All queries verified and working
