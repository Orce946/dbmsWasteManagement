# SQL JOIN QUERIES - QUICK REFERENCE FOR TERMINAL

## Copy-Paste Ready Queries

All these queries can be directly run in terminal with:
```bash
mysql -u root wasteManagement -e "QUERY_HERE"
```

---

## 1. CITIZENS WITH THEIR AREAS

### Simple Join
```sql
SELECT c.citizen_id, c.name, a.area_name FROM Citizen c INNER JOIN Area a ON c.area_id = a.area_id;
```

### Terminal Command
```bash
mysql -u root wasteManagement -e "SELECT c.citizen_id, c.name, a.area_name FROM Citizen c INNER JOIN Area a ON c.area_id = a.area_id;"
```

---

## 2. AREA SUMMARY WITH CITIZEN COUNT

```sql
SELECT a.area_id, a.area_name, COUNT(c.citizen_id) AS total_citizens FROM Area a LEFT JOIN Citizen c ON a.area_id = c.area_id GROUP BY a.area_id, a.area_name;
```

### Terminal Command
```bash
mysql -u root wasteManagement -e "SELECT a.area_id, a.area_name, COUNT(c.citizen_id) AS total_citizens FROM Area a LEFT JOIN Citizen c ON a.area_id = c.area_id GROUP BY a.area_id, a.area_name;"
```

---

## 3. WASTE WITH CITIZEN AND AREA INFO

```sql
SELECT w.waste_id, w.waste_type, w.quantity, w.status, c.name AS citizen_name, a.area_name FROM Waste w LEFT JOIN Citizen c ON w.citizen_id = c.citizen_id LEFT JOIN Area a ON w.area_id = a.area_id;
```

### Terminal Command
```bash
mysql -u root wasteManagement -e "SELECT w.waste_id, w.waste_type, w.quantity, c.name, a.area_name FROM Waste w LEFT JOIN Citizen c ON w.citizen_id = c.citizen_id LEFT JOIN Area a ON w.area_id = a.area_id;"
```

---

## 4. CITIZEN BILL SUMMARY

```sql
SELECT c.citizen_id, c.name, COUNT(b.bill_id) AS total_bills, SUM(b.amount) AS total_amount, COUNT(CASE WHEN b.status = 'Paid' THEN 1 END) AS paid_bills FROM Citizen c LEFT JOIN Bill b ON c.citizen_id = b.citizen_id GROUP BY c.citizen_id, c.name;
```

### Terminal Command
```bash
mysql -u root wasteManagement -e "SELECT c.citizen_id, c.name, COUNT(b.bill_id) AS bills, SUM(b.amount) AS total FROM Citizen c LEFT JOIN Bill b ON c.citizen_id = b.citizen_id GROUP BY c.citizen_id, c.name;"
```

---

## 5. AREA WITH BINS STATUS

```sql
SELECT a.area_name, COUNT(b.bin_id) AS total_bins, SUM(CASE WHEN b.status = 'Full' THEN 1 ELSE 0 END) AS full_bins, ROUND(AVG(b.fill_level), 2) AS avg_fill FROM Area a LEFT JOIN Bins b ON a.area_id = b.area_id GROUP BY a.area_id, a.area_name;
```

### Terminal Command
```bash
mysql -u root wasteManagement -e "SELECT a.area_name, COUNT(b.bin_id) AS total_bins, SUM(CASE WHEN b.status = 'Full' THEN 1 ELSE 0 END) AS full_bins FROM Area a LEFT JOIN Bins b ON a.area_id = b.area_id GROUP BY a.area_id, a.area_name;"
```

---

## 6. AREA WITH CREW MEMBERS

```sql
SELECT a.area_name, COUNT(c.crew_id) AS total_crew, GROUP_CONCAT(c.crew_name SEPARATOR ', ') AS crews FROM Area a LEFT JOIN Crew c ON a.area_id = c.area_id GROUP BY a.area_id, a.area_name;
```

### Terminal Command
```bash
mysql -u root wasteManagement -e "SELECT a.area_name, COUNT(c.crew_id) AS total_crew, GROUP_CONCAT(c.crew_name) AS crews FROM Area a LEFT JOIN Crew c ON a.area_id = c.area_id GROUP BY a.area_id, a.area_name;"
```

---

## 7. BILLS WITH PAYMENTS (Join across 3 tables)

```sql
SELECT c.name, b.bill_id, b.amount, b.status, COUNT(p.payment_id) AS payments, SUM(p.amount) AS paid_amount FROM Bill b LEFT JOIN Citizen c ON b.citizen_id = c.citizen_id LEFT JOIN Payment p ON b.bill_id = p.bill_id GROUP BY b.bill_id, b.amount, b.status, c.name;
```

### Terminal Command
```bash
mysql -u root wasteManagement -e "SELECT c.name, b.bill_id, b.amount, COUNT(p.payment_id) AS payments FROM Bill b LEFT JOIN Citizen c ON b.citizen_id = c.citizen_id LEFT JOIN Payment p ON b.bill_id = p.bill_id GROUP BY b.bill_id;"
```

---

## 8. COMPLETE CITIZEN PROFILE (5-Table Join!)

```sql
SELECT c.citizen_id, c.name, a.area_name, COUNT(DISTINCT b.bill_id) AS bills, COUNT(DISTINCT w.waste_id) AS waste_records FROM Citizen c LEFT JOIN Area a ON c.area_id = a.area_id LEFT JOIN Bill b ON c.citizen_id = b.citizen_id LEFT JOIN Waste w ON c.citizen_id = w.citizen_id GROUP BY c.citizen_id, c.name, a.area_name;
```

### Terminal Command
```bash
mysql -u root wasteManagement -e "SELECT c.citizen_id, c.name, a.area_name, COUNT(DISTINCT b.bill_id) AS bills, COUNT(DISTINCT w.waste_id) AS waste FROM Citizen c LEFT JOIN Area a ON c.area_id = a.area_id LEFT JOIN Bill b ON c.citizen_id = b.citizen_id LEFT JOIN Waste w ON c.citizen_id = w.citizen_id GROUP BY c.citizen_id, c.name, a.area_name;"
```

---

## 9. AREA OPERATIONS OVERVIEW (6-Table Join)

```sql
SELECT a.area_id, a.area_name, COUNT(DISTINCT c.citizen_id) AS citizens, COUNT(DISTINCT b.bill_id) AS bills, COUNT(DISTINCT crew.crew_id) AS crew_members, COUNT(DISTINCT bin.bin_id) AS bins FROM Area a LEFT JOIN Citizen c ON a.area_id = c.area_id LEFT JOIN Bill b ON c.citizen_id = b.citizen_id LEFT JOIN Crew crew ON a.area_id = crew.area_id LEFT JOIN Bins bin ON a.area_id = bin.area_id GROUP BY a.area_id, a.area_name;
```

### Terminal Command
```bash
mysql -u root wasteManagement -e "SELECT a.area_id, a.area_name, COUNT(DISTINCT c.citizen_id) AS citizens, COUNT(DISTINCT b.bill_id) AS bills, COUNT(DISTINCT crew.crew_id) AS crew FROM Area a LEFT JOIN Citizen c ON a.area_id = c.area_id LEFT JOIN Bill b ON c.citizen_id = b.citizen_id LEFT JOIN Crew crew ON a.area_id = crew.area_id GROUP BY a.area_id;"
```

---

## 10. HAS_SCHEDULE - TERNARY RELATIONSHIP (Crew assignments)

```sql
SELECT a.area_name, c.crew_name, cs.schedule_date, DAYNAME(cs.schedule_date) AS day FROM Has_Schedule hs INNER JOIN Area a ON hs.area_id = a.area_id INNER JOIN Crew c ON hs.crew_id = c.crew_id INNER JOIN Collection_Schedule cs ON hs.schedule_id = cs.schedule_id;
```

### Terminal Command
```bash
mysql -u root wasteManagement -e "SELECT a.area_name, c.crew_name, cs.schedule_date FROM Has_Schedule hs INNER JOIN Area a ON hs.area_id = a.area_id INNER JOIN Crew c ON hs.crew_id = c.crew_id INNER JOIN Collection_Schedule cs ON hs.schedule_id = cs.schedule_id;"
```

---

## 11. SCHEDULE WITH ASSIGNED CREWS

```sql
SELECT cs.schedule_date, a.area_name, COUNT(DISTINCT c.crew_id) AS assigned_crews, GROUP_CONCAT(DISTINCT c.crew_name) AS crew_names FROM Collection_Schedule cs LEFT JOIN Has_Schedule hs ON cs.schedule_id = hs.schedule_id LEFT JOIN Area a ON cs.area_id = a.area_id LEFT JOIN Crew c ON hs.crew_id = c.crew_id GROUP BY cs.schedule_id, cs.schedule_date, a.area_name ORDER BY cs.schedule_date DESC;
```

### Terminal Command
```bash
mysql -u root wasteManagement -e "SELECT cs.schedule_date, a.area_name, COUNT(c.crew_id) AS crews FROM Collection_Schedule cs LEFT JOIN Has_Schedule hs ON cs.schedule_id = hs.schedule_id LEFT JOIN Area a ON cs.area_id = a.area_id LEFT JOIN Crew c ON hs.crew_id = c.crew_id GROUP BY cs.schedule_id;"
```

---

## 12. WASTE STATISTICS BY TYPE AND STATUS

```sql
SELECT w.waste_type, w.status, COUNT(w.waste_id) AS count, SUM(w.quantity) AS total_qty, ROUND(AVG(w.quantity), 2) AS avg_qty FROM Waste w GROUP BY w.waste_type, w.status;
```

### Terminal Command
```bash
mysql -u root wasteManagement -e "SELECT w.waste_type, w.status, COUNT(w.waste_id) AS count, SUM(w.quantity) AS total FROM Waste w GROUP BY w.waste_type, w.status;"
```

---

## 13. PAYMENT METHODS BY AREA

```sql
SELECT a.area_name, p.method, COUNT(p.payment_id) AS count, SUM(p.amount) AS total FROM Payment p LEFT JOIN Citizen c ON p.citizen_id = c.citizen_id LEFT JOIN Area a ON c.area_id = a.area_id GROUP BY a.area_name, p.method;
```

### Terminal Command
```bash
mysql -u root wasteManagement -e "SELECT a.area_name, p.method, COUNT(p.payment_id) AS count FROM Payment p LEFT JOIN Citizen c ON p.citizen_id = c.citizen_id LEFT JOIN Area a ON c.area_id = a.area_id GROUP BY a.area_name, p.method;"
```

---

## 14. ORPHANED RECORDS (Data Integrity Check)

```sql
SELECT b.bill_id FROM Bill b WHERE b.citizen_id NOT IN (SELECT citizen_id FROM Citizen);
```

### Terminal Command
```bash
mysql -u root wasteManagement -e "SELECT b.bill_id FROM Bill b WHERE b.citizen_id NOT IN (SELECT citizen_id FROM Citizen);"
```

---

## 15. AREAS WITH NO CITIZENS

```sql
SELECT a.area_id, a.area_name FROM Area a LEFT JOIN Citizen c ON a.area_id = c.area_id WHERE c.citizen_id IS NULL GROUP BY a.area_id, a.area_name;
```

### Terminal Command
```bash
mysql -u root wasteManagement -e "SELECT a.area_id, a.area_name FROM Area a LEFT JOIN Citizen c ON a.area_id = c.area_id WHERE c.citizen_id IS NULL GROUP BY a.area_id;"
```

---

## HOW TO USE

### Option 1: Copy Full Command
Simply copy the entire command under "Terminal Command" and paste in your terminal.

### Option 2: Copy Just the Query
1. Copy the SQL query
2. Open terminal
3. Type: `mysql -u root wasteManagement -e "`
4. Paste the query
5. Type: `"`

### Option 3: Run the Entire File
```bash
mysql -u root wasteManagement < SQL_JOIN_QUERIES_TERMINAL.sql
```

### Option 4: Save to File and View
```bash
mysql -u root wasteManagement -e "QUERY_HERE" > results.txt
cat results.txt
```

---

## UNDERSTANDING JOIN TYPES

### INNER JOIN
Returns only rows where BOTH tables have matching values.
```sql
SELECT * FROM TableA INNER JOIN TableB ON TableA.id = TableB.id;
```
**Use when:** You only want matching records

### LEFT JOIN
Returns all rows from LEFT table, plus matching rows from RIGHT table.
```sql
SELECT * FROM TableA LEFT JOIN TableB ON TableA.id = TableB.id;
```
**Use when:** You want all records from first table even if no match

### MULTIPLE JOINS
You can join 3, 4, 5+ tables together!
```sql
SELECT * FROM A 
JOIN B ON A.id = B.a_id 
JOIN C ON B.id = C.b_id 
JOIN D ON C.id = D.c_id;
```
**Use when:** You need data from multiple related tables

---

## COMMON AGGREGATE FUNCTIONS

| Function | Purpose | Example |
|----------|---------|---------|
| COUNT() | Count records | COUNT(bill_id) |
| SUM() | Add values | SUM(amount) |
| AVG() | Calculate average | AVG(quantity) |
| MIN() | Find minimum | MIN(date) |
| MAX() | Find maximum | MAX(date) |
| GROUP_CONCAT() | Combine into string | GROUP_CONCAT(name) |

---

## TIPS

1. **Always use WHERE or GROUP BY filters** to limit results if dataset is large
2. **Use LIMIT 10** to test queries before running on full dataset
3. **Check column names** match exactly (case-sensitive in some systems)
4. **Use aliases** to make queries shorter: `AS c` for Citizen, `AS a` for Area
5. **Test incrementally** - build complex joins one table at a time

---

## DATABASE STRUCTURE

```
Tables:
- Citizen (citizen_id, name, area_id)
- Area (area_id, area_name)
- Bill (bill_id, citizen_id, amount, status)
- Payment (payment_id, citizen_id, bill_id, amount)
- Waste (waste_id, citizen_id, area_id, waste_type, quantity, status)
- Crew (crew_id, area_id, crew_name)
- Bins (bin_id, area_id, status, fill_level)
- Collection_Schedule (schedule_id, area_id, schedule_date)
- Has_Schedule (has_schedule_id, area_id, crew_id, schedule_id)
- Assigned (team_id, area_id, team_name)
- Recycling_Center (center_id, waste_id, location)
```

---

## EXPECTED RESULTS PREVIEW

When you run these queries, you should see data like:

### Citizens with Areas
```
citizen_id | name | area_name
2 | Jane Smith | Uttarkhan
15 | zubayer Ahmed | Uttara
```

### Area Summary
```
area_id | area_name | total_citizens
1 | Downtown | 0
3 | Uttara | 2
```

### Complete Profile (5-table join)
```
citizen_id | name | area_name | bills | waste
15 | zubayer Ahmed | Uttara | 1 | 2
```

---

For more detailed documentation, see: **SQL_JOINS_DOCUMENTATION.md**
