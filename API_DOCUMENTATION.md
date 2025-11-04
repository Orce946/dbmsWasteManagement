# Waste Management System - API Documentation

## Overview
Complete REST API for the Waste Management System with CRUD operations on all entities and relationship management.

## Base URL
```
http://localhost:3000
```

## Health Check

### Check API Status
- **Endpoint:** `GET /api/health`
- **Response:** `{ "ok": true }`
- **Example:**
```bash
curl http://localhost:3000/api/health
```

---

## Citizen Endpoints

### Get All Citizens
- **Endpoint:** `GET /api/citizens`
- **Response:** Array of citizen objects
- **Example:**
```bash
curl http://localhost:3000/api/citizens | jq
```

### Get Specific Citizen
- **Endpoint:** `GET /api/citizens/:id`
- **Response:** Single citizen object
- **Example:**
```bash
curl http://localhost:3000/api/citizens/1 | jq
```

### Create Citizen
- **Endpoint:** `POST /api/citizens`
- **Body:**
```json
{
  "Name": "John Smith",
  "Address": "123 Main Street",
  "Contact_Info": "john@example.com",
  "DOB": "1990-05-15",
  "Gender": "Male"
}
```
- **Response:** `{ "id": 5 }`
- **Example:**
```bash
curl -X POST http://localhost:3000/api/citizens \
  -H "Content-Type: application/json" \
  -d '{
    "Name":"John Smith",
    "Address":"123 Main St",
    "Contact_Info":"john@example.com",
    "DOB":"1990-05-15",
    "Gender":"Male"
  }' | jq
```

### Update Citizen
- **Endpoint:** `PUT /api/citizens/:id`
- **Body:** Same as Create
- **Response:** `{ "success": true }`

### Delete Citizen
- **Endpoint:** `DELETE /api/citizens/:id`
- **Response:** `{ "success": true }`

---

## Area Endpoints

### Get All Areas
- **Endpoint:** `GET /api/areas`
- **Example:**
```bash
curl http://localhost:3000/api/areas | jq
```

### Create Area
- **Endpoint:** `POST /api/areas`
- **Body:**
```json
{
  "Area_Name": "Downtown Central",
  "Area_Code": "DC001",
  "Population": 50000,
  "Supervisor": "Mike Wilson",
  "Description": "Central business district"
}
```
- **Response:** `{ "id": 5 }`

---

## Bill Endpoints

### Get All Bills
- **Endpoint:** `GET /api/bills`
- **Example:**
```bash
curl http://localhost:3000/api/bills | jq
```

### Create Bill
- **Endpoint:** `POST /api/bills`
- **Body:**
```json
{
  "Status": "unpaid",
  "Due_Date": "2025-12-31",
  "Amount": 250.00,
  "Issue_Date": "2025-11-01",
  "Description": "Monthly waste collection"
}
```
- **Response:** `{ "id": 5 }`

---

## Payment Endpoints

### Get All Payments
- **Endpoint:** `GET /api/payments`
- **Example:**
```bash
curl http://localhost:3000/api/payments | jq
```

### Create Payment
- **Endpoint:** `POST /api/payments`
- **Body:**
```json
{
  "Amount": 250.00,
  "Method": "Credit Card",
  "Reference_Number": "PAY005",
  "Notes": "Payment for Bill #5"
}
```
- **Response:** `{ "id": 5 }`

---

## Waste Endpoints

### Get All Waste Types
- **Endpoint:** `GET /api/waste`
- **Example:**
```bash
curl http://localhost:3000/api/waste | jq
```

### Create Waste Type
- **Endpoint:** `POST /api/waste`
- **Body:**
```json
{
  "Name": "Plastic Bags",
  "Category": "Recyclable",
  "Weight": 3.5,
  "Volume": 5.0,
  "Hazardous": false,
  "Description": "Used plastic shopping bags"
}
```
- **Response:** `{ "id": 5 }`

---

## Recycling Center Endpoints

### Get All Recycling Centers
- **Endpoint:** `GET /api/recycling-centers`
- **Example:**
```bash
curl http://localhost:3000/api/recycling-centers | jq
```

### Create Recycling Center
- **Endpoint:** `POST /api/recycling-centers`
- **Body:**
```json
{
  "Capacity": 1500,
  "Location": "456 Eco Boulevard",
  "Operating_Hours": "9AM-5PM",
  "Manager": "Dr. Environment",
  "Contact": "center@example.com",
  "Established_Date": "2020-01-15"
}
```
- **Response:** `{ "id": 5 }`

---

## Collection Schedule Endpoints

### Get All Schedules
- **Endpoint:** `GET /api/schedules`
- **Example:**
```bash
curl http://localhost:3000/api/schedules | jq
```

### Create Schedule
- **Endpoint:** `POST /api/schedules`
- **Body:**
```json
{
  "Schedule_Date": "2025-11-15",
  "Status": "scheduled",
  "Frequency": "weekly",
  "Assigned_Vehicle": "Truck E",
  "Notes": "Downtown collection route"
}
```
- **Response:** `{ "id": 5 }`

---

## Bins Endpoints

### Get All Bins
- **Endpoint:** `GET /api/bins`
- **Example:**
```bash
curl http://localhost:3000/api/bins | jq
```

### Create Bin
- **Endpoint:** `POST /api/bins`
- **Body:**
```json
{
  "Status": "active",
  "Fill_Level": 60,
  "Sensor": true,
  "Location": "Harbor Street Corner",
  "Type": "General Waste",
  "Last_Emptied": "2025-11-01 10:00:00"
}
```
- **Response:** `{ "id": 5 }`

---

## Crew Endpoints

### Get All Crews
- **Endpoint:** `GET /api/crews`
- **Example:**
```bash
curl http://localhost:3000/api/crews | jq
```

### Create Crew
- **Endpoint:** `POST /api/crews`
- **Body:**
```json
{
  "Crew_Name": "Echo Team",
  "Contact_Info": "echo@crew.com",
  "Size": 5,
  "Supervisor": "Charlie Manager",
  "Specialization": "Heavy Equipment"
}
```
- **Response:** `{ "id": 5 }`

---

## Relationship Endpoints

### Binary Relationship: LIVES (Citizen ↔ Area)

**Get Citizen-Area Relationships:**
- **Endpoint:** `GET /api/relationships/lives`
- **Response:** Array with Citizen_ID, Name, Area_ID, Area_Name
- **Example:**
```bash
curl http://localhost:3000/api/relationships/lives | jq
```

**Link Citizen to Area:**
- **Endpoint:** `POST /api/relationships/lives`
- **Body:**
```json
{
  "Citizen_ID": 1,
  "Area_ID": 2
}
```
- **Response:** `{ "success": true }`

---

### Binary Relationship: HAS_Bill (Citizen ↔ Bill)

**Get Citizen-Bill Relationships:**
- **Endpoint:** `GET /api/relationships/has-bill`
- **Response:** Array with Citizen_ID, Name, Bill_ID, Status, Amount
- **Example:**
```bash
curl http://localhost:3000/api/relationships/has-bill | jq
```

**Link Citizen to Bill:**
- **Endpoint:** `POST /api/relationships/has-bill`
- **Body:**
```json
{
  "Citizen_ID": 1,
  "Bill_ID": 2
}
```
- **Response:** `{ "success": true }`

---

### Ternary Relationship: GENERATES (Citizen + Waste → Payment)

**Get Waste Generation Records:**
- **Endpoint:** `GET /api/relationships/generates`
- **Response:** Array with Citizen Name, Waste Type, Payment Amount
- **Example:**
```bash
curl http://localhost:3000/api/relationships/generates | jq
```

**Record Waste Generation:**
- **Endpoint:** `POST /api/relationships/generates`
- **Body:**
```json
{
  "Citizen_ID": 1,
  "Waste_ID": 2,
  "Payment_ID": 3
}
```
- **Response:** `{ "success": true }`

---

### Ternary Relationship: HAS_Schedule (Area + Schedule → Crew)

**Get Collection Schedule Assignments:**
- **Endpoint:** `GET /api/relationships/has-schedule`
- **Response:** Array with Area_Name, Schedule_Date, Crew_Name
- **Example:**
```bash
curl http://localhost:3000/api/relationships/has-schedule | jq
```

**Assign Schedule to Area with Crew:**
- **Endpoint:** `POST /api/relationships/has-schedule`
- **Body:**
```json
{
  "Area_ID": 1,
  "Schedule_ID": 2,
  "Crew_ID": 3
}
```
- **Response:** `{ "success": true }`

---

## Error Responses

All endpoints return appropriate HTTP status codes:
- `200 OK` - Successful GET request
- `201 Created` - Successful POST request
- `400 Bad Request` - Invalid input data
- `404 Not Found` - Resource not found
- `500 Internal Server Error` - Server error

**Error Response Format:**
```json
{
  "error": "Error message describing what went wrong"
}
```

---

## Example Workflow

### 1. Create a Citizen
```bash
curl -X POST http://localhost:3000/api/citizens \
  -H "Content-Type: application/json" \
  -d '{
    "Name":"Alice Cooper",
    "Address":"789 Oak Lane",
    "Contact_Info":"alice@example.com",
    "DOB":"1988-03-20",
    "Gender":"Female"
  }'
```
Response: `{ "id": 5 }`

### 2. Create an Area
```bash
curl -X POST http://localhost:3000/api/areas \
  -H "Content-Type: application/json" \
  -d '{
    "Area_Name":"North Gardens",
    "Area_Code":"NG001",
    "Population":25000,
    "Supervisor":"Sarah Johnson",
    "Description":"Northern residential area"
  }'
```
Response: `{ "id": 5 }`

### 3. Link Citizen to Area (LIVES relationship)
```bash
curl -X POST http://localhost:3000/api/relationships/lives \
  -H "Content-Type: application/json" \
  -d '{
    "Citizen_ID":5,
    "Area_ID":5
  }'
```
Response: `{ "success": true }`

### 4. Verify the Relationship
```bash
curl http://localhost:3000/api/relationships/lives | jq '.[] | select(.Citizen_ID==5)'
```

---

## Database Schema Reference

**9 Entity Tables:** Citizen, Area, Bill, Payment, Waste, Recycling_Center, Collection_Schedules, Bins, Crew

**5 Binary Relationships:** LIVES, HAS_Bill, MAKES, PROCESSED_BY, HAS_Bins

**2 Ternary Relationships:** GENERATES, HAS_Schedule

All tables include proper foreign key constraints with CASCADE delete for referential integrity.
