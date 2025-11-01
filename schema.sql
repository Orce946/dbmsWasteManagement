

-- ===== ENTITY TABLES =====

-- Citizen table
CREATE TABLE Citizen (
    Citizen_ID INT PRIMARY KEY AUTO_INCREMENT,
    Name VARCHAR(100) NOT NULL,
    Address VARCHAR(255),
    Contact_Info VARCHAR(100),
    DOB DATE,
    Gender VARCHAR(10),
    Registration_Date DATE DEFAULT (CURRENT_DATE)
);

-- Area table
CREATE TABLE Area (
    Area_ID INT PRIMARY KEY AUTO_INCREMENT,
    Area_Name VARCHAR(100) NOT NULL,
    Area_Code VARCHAR(20) UNIQUE NOT NULL,
    Population INT,
    Supervisor VARCHAR(100),
    Description TEXT
);

-- Bill table
CREATE TABLE Bill (
    Bill_ID INT PRIMARY KEY AUTO_INCREMENT,
    Status VARCHAR(20) DEFAULT 'unpaid',
    Due_Date DATE,
    Amount DECIMAL(10,2),
    Issue_Date DATE DEFAULT (CURRENT_DATE),
    Description TEXT
);

-- Payment table
CREATE TABLE Payment (
    Payment_ID INT PRIMARY KEY AUTO_INCREMENT,
    Amount DECIMAL(10,2) NOT NULL,
    Method VARCHAR(50),
    Date DATETIME DEFAULT CURRENT_TIMESTAMP,
    Reference_Number VARCHAR(50),
    Notes TEXT
);

-- Waste table
CREATE TABLE Waste (
    Waste_ID INT PRIMARY KEY AUTO_INCREMENT,
    Name VARCHAR(100) NOT NULL,
    Category VARCHAR(50),
    Weight DECIMAL(10,2),
    Volume DECIMAL(10,2),
    Hazardous BOOLEAN DEFAULT FALSE,
    Description TEXT
);

-- Recycling_Center table
CREATE TABLE Recycling_Center (
    Center_ID INT PRIMARY KEY AUTO_INCREMENT,
    Capacity INT,
    Location VARCHAR(255),
    Operating_Hours VARCHAR(100),
    Manager VARCHAR(100),
    Contact VARCHAR(100),
    Established_Date DATE
);

-- Collection_Schedules table
CREATE TABLE Collection_Schedules (
    Schedule_ID INT PRIMARY KEY AUTO_INCREMENT,
    Schedule_Date DATE NOT NULL,
    Status VARCHAR(20) DEFAULT 'scheduled',
    Frequency VARCHAR(20),
    Assigned_Vehicle VARCHAR(50),
    Notes TEXT
);

-- Bins table
CREATE TABLE Bins (
    Bin_ID INT PRIMARY KEY AUTO_INCREMENT,
    Status VARCHAR(20) DEFAULT 'active',
    Fill_Level INT DEFAULT 0,
    Sensor BOOLEAN DEFAULT TRUE,
    Location VARCHAR(255),
    Type VARCHAR(50),
    Last_Emptied DATETIME
);

-- Crew table
CREATE TABLE Crew (
    Crew_ID INT PRIMARY KEY AUTO_INCREMENT,
    Crew_Name VARCHAR(100) NOT NULL,
    Contact_Info VARCHAR(100),
    Size INT,
    Supervisor VARCHAR(100),
    Specialization VARCHAR(50)
);

-- ===== RELATIONSHIP TABLES (Binary Relationships) =====

-- LIVES: Citizen lives in Area (Many-to-Many)
CREATE TABLE LIVES (
    Citizen_ID INT NOT NULL,
    Area_ID INT NOT NULL,
    PRIMARY KEY (Citizen_ID, Area_ID),
    FOREIGN KEY (Citizen_ID) REFERENCES Citizen(Citizen_ID) ON DELETE CASCADE,
    FOREIGN KEY (Area_ID) REFERENCES Area(Area_ID) ON DELETE CASCADE
);

-- HAS_Bill: Citizen has Bill (Many-to-Many)
CREATE TABLE HAS_Bill (
    Citizen_ID INT NOT NULL,
    Bill_ID INT NOT NULL,
    PRIMARY KEY (Citizen_ID, Bill_ID),
    FOREIGN KEY (Citizen_ID) REFERENCES Citizen(Citizen_ID) ON DELETE CASCADE,
    FOREIGN KEY (Bill_ID) REFERENCES Bill(Bill_ID) ON DELETE CASCADE
);

-- MAKES: Citizen makes Payment (Many-to-Many)
CREATE TABLE MAKES (
    Citizen_ID INT NOT NULL,
    Payment_ID INT NOT NULL,
    PRIMARY KEY (Citizen_ID, Payment_ID),
    FOREIGN KEY (Citizen_ID) REFERENCES Citizen(Citizen_ID) ON DELETE CASCADE,
    FOREIGN KEY (Payment_ID) REFERENCES Payment(Payment_ID) ON DELETE CASCADE
);

-- PROCESSED_BY: Waste is processed by Recycling_Center (Many-to-Many)
CREATE TABLE PROCESSED_BY (
    Waste_ID INT NOT NULL,
    Center_ID INT NOT NULL,
    PRIMARY KEY (Waste_ID, Center_ID),
    FOREIGN KEY (Waste_ID) REFERENCES Waste(Waste_ID) ON DELETE CASCADE,
    FOREIGN KEY (Center_ID) REFERENCES Recycling_Center(Center_ID) ON DELETE CASCADE
);

-- HAS_Bins: Area has Bins (Many-to-Many)
CREATE TABLE HAS_Bins (
    Area_ID INT NOT NULL,
    Bin_ID INT NOT NULL,
    PRIMARY KEY (Area_ID, Bin_ID),
    FOREIGN KEY (Area_ID) REFERENCES Area(Area_ID) ON DELETE CASCADE,
    FOREIGN KEY (Bin_ID) REFERENCES Bins(Bin_ID) ON DELETE CASCADE
);

-- ===== TERNARY RELATIONSHIP TABLES =====

-- GENERATES: Citizen generates Waste for Payment (Ternary)
CREATE TABLE GENERATES (
    Citizen_ID INT NOT NULL,
    Waste_ID INT NOT NULL,
    Payment_ID INT NOT NULL,
    PRIMARY KEY (Citizen_ID, Waste_ID, Payment_ID),
    FOREIGN KEY (Citizen_ID) REFERENCES Citizen(Citizen_ID) ON DELETE CASCADE,
    FOREIGN KEY (Waste_ID) REFERENCES Waste(Waste_ID) ON DELETE CASCADE,
    FOREIGN KEY (Payment_ID) REFERENCES Payment(Payment_ID) ON DELETE CASCADE
);

-- HAS_Schedule: Area has Collection_Schedules with Crew (Ternary)
CREATE TABLE HAS_Schedule (
    Area_ID INT NOT NULL,
    Schedule_ID INT NOT NULL,
    Crew_ID INT NOT NULL,
    PRIMARY KEY (Area_ID, Schedule_ID, Crew_ID),
    FOREIGN KEY (Area_ID) REFERENCES Area(Area_ID) ON DELETE CASCADE,
    FOREIGN KEY (Schedule_ID) REFERENCES Collection_Schedules(Schedule_ID) ON DELETE CASCADE,
    FOREIGN KEY (Crew_ID) REFERENCES Crew(Crew_ID) ON DELETE CASCADE
);

-- ===== INSERT DUMMY DATA =====

-- Insert Citizens
INSERT INTO Citizen (Name, Address, Contact_Info, DOB, Gender) VALUES
('John Doe', '123 Main St, City A', 'john@example.com', '1985-05-15', 'Male'),
('Jane Smith', '456 Oak Ave, City B', 'jane@example.com', '1990-08-22', 'Female'),
('Alice Johnson', '789 Pine Rd, City C', 'alice@example.com', '1978-12-10', 'Female'),
('Bob Brown', '321 Elm St, City D', 'bob@example.com', '1982-03-05', 'Male');

-- Insert Areas
INSERT INTO Area (Area_Name, Area_Code, Population, Supervisor, Description) VALUES
('Downtown', 'DT001', 50000, 'Mike Wilson', 'Central business district'),
('Suburb North', 'SN002', 30000, 'Sarah Lee', 'Northern residential area'),
('Industrial Zone', 'IZ003', 20000, 'Tom Garcia', 'Manufacturing and warehouses'),
('Residential East', 'RE004', 40000, 'Lisa Chen', 'Eastern residential community');

-- Insert Bills
INSERT INTO Bill (Status, Due_Date, Amount, Issue_Date, Description) VALUES
('paid', '2025-10-31', 150.00, '2025-10-01', 'Monthly waste collection'),
('unpaid', '2025-11-15', 200.00, '2025-11-01', 'Recycling services'),
('overdue', '2025-10-20', 100.00, '2025-10-01', 'Special disposal'),
('paid', '2025-11-01', 175.00, '2025-10-15', 'Hazardous waste handling');

-- Insert Payments
INSERT INTO Payment (Amount, Method, Reference_Number, Date, Notes) VALUES
(150.00, 'Credit Card', 'PAY001', '2025-10-25 10:30:00', 'Paid on time'),
(200.00, 'Bank Transfer', 'PAY002', '2025-10-28 14:15:00', 'Partial payment'),
(100.00, 'Cash', 'PAY003', '2025-10-22 16:45:00', 'Late fee applied'),
(175.00, 'Online', 'PAY004', '2025-10-30 09:00:00', 'Auto payment');

-- Insert Waste types
INSERT INTO Waste (Name, Category, Weight, Volume, Hazardous, Description) VALUES
('Plastic Bottles', 'Recyclable', 5.5, 10.0, FALSE, 'Single-use plastic bottles'),
('Electronic Waste', 'Hazardous', 2.0, 3.0, TRUE, 'Old computers and phones'),
('Organic Waste', 'Biodegradable', 15.0, 20.0, FALSE, 'Food and garden waste'),
('Metal Scrap', 'Recyclable', 8.0, 12.0, FALSE, 'Iron and aluminum scrap');

-- Insert Recycling Centers
INSERT INTO Recycling_Center (Capacity, Location, Operating_Hours, Manager, Contact, Established_Date) VALUES
(1000, '123 Recycle St', '9AM-5PM', 'Dr. Green', 'center1@example.com', '2020-01-15'),
(800, '456 Eco Ave', '8AM-6PM', 'Ms. Earth', 'center2@example.com', '2019-06-20'),
(1200, '789 Planet Rd', '7AM-7PM', 'Mr. Recycle', 'center3@example.com', '2021-03-10'),
(600, '321 Green Ln', '10AM-4PM', 'Prof. Waste', 'center4@example.com', '2022-11-05');

-- Insert Collection Schedules
INSERT INTO Collection_Schedules (Schedule_Date, Status, Frequency, Assigned_Vehicle, Notes) VALUES
('2025-10-27', 'completed', 'weekly', 'Truck A', 'Downtown route'),
('2025-10-28', 'scheduled', 'daily', 'Truck B', 'Suburb North route'),
('2025-10-29', 'in_progress', 'bi-weekly', 'Truck C', 'Industrial zone sweep'),
('2025-10-30', 'cancelled', 'monthly', 'Truck D', 'Rescheduled for weather');

-- Insert Bins
INSERT INTO Bins (Status, Fill_Level, Sensor, Location, Type, Last_Emptied) VALUES
('active', 75, TRUE, 'Corner of Main St', 'General Waste', '2025-10-25 08:00:00'),
('maintenance', 90, FALSE, 'Park Entrance', 'Recycling', '2025-10-24 10:00:00'),
('active', 45, TRUE, 'Residential Area', 'Organic', '2025-10-26 14:00:00'),
('full', 100, TRUE, 'Commercial Zone', 'Hazardous', '2025-10-23 16:00:00');

-- Insert Crews
INSERT INTO Crew (Crew_Name, Contact_Info, Size, Supervisor, Specialization) VALUES
('Alpha Team', 'alpha@crew.com', 5, 'John Leader', 'General Collection'),
('Beta Squad', 'beta@crew.com', 4, 'Jane Supervisor', 'Recycling'),
('Gamma Group', 'gamma@crew.com', 6, 'Bob Manager', 'Hazardous Waste'),
('Delta Unit', 'delta@crew.com', 3, 'Alice Coordinator', 'Maintenance');

-- ===== INSERT RELATIONSHIP DATA =====

-- LIVES: Citizens live in Areas
INSERT INTO LIVES (Citizen_ID, Area_ID) VALUES
(1, 1),
(2, 2),
(3, 3),
(4, 4);

-- HAS_Bill: Citizens have Bills
INSERT INTO HAS_Bill (Citizen_ID, Bill_ID) VALUES
(1, 1),
(2, 2),
(3, 3),
(4, 4);

-- MAKES: Citizens make Payments
INSERT INTO MAKES (Citizen_ID, Payment_ID) VALUES
(1, 1),
(2, 2),
(3, 3),
(4, 4);

-- PROCESSED_BY: Waste is processed by Recycling Centers
INSERT INTO PROCESSED_BY (Waste_ID, Center_ID) VALUES
(1, 1),
(2, 2),
(3, 3),
(4, 1);

-- HAS_Bins: Areas have Bins
INSERT INTO HAS_Bins (Area_ID, Bin_ID) VALUES
(1, 1),
(2, 2),
(3, 3),
(4, 4);

-- GENERATES: Citizens generate Waste for Payment (Ternary)
INSERT INTO GENERATES (Citizen_ID, Waste_ID, Payment_ID) VALUES
(1, 1, 1),
(2, 2, 2),
(3, 3, 3),
(4, 4, 4);

-- HAS_Schedule: Areas have Collection Schedules with Crews (Ternary)
INSERT INTO HAS_Schedule (Area_ID, Schedule_ID, Crew_ID) VALUES
(1, 1, 1),
(2, 2, 2),
(3, 3, 3),
(4, 4, 4);
