-- Waste Management System - 10 Table Schema Based on ER Diagram

-- ===== ENTITY TABLES (10 Total) =====

-- 1. Bins table
CREATE TABLE Bins (
    Bin_ID INT PRIMARY KEY AUTO_INCREMENT,
    Status VARCHAR(20) DEFAULT 'active',
    Fill_Level INT DEFAULT 0,
    Sensor BOOLEAN DEFAULT TRUE,
    Location VARCHAR(255),
    Type VARCHAR(50)
);

-- 2. Area table
CREATE TABLE Area (
    Area_ID INT PRIMARY KEY AUTO_INCREMENT,
    Area_Name VARCHAR(100) NOT NULL,
    Area_Code VARCHAR(20) UNIQUE NOT NULL,
    Population INT,
    Supervisor VARCHAR(100),
    Description TEXT
);

-- 3. Citizen table
CREATE TABLE Citizen (
    Citizen_ID INT PRIMARY KEY AUTO_INCREMENT,
    Name VARCHAR(100) NOT NULL,
    Address VARCHAR(255),
    Contact_Info VARCHAR(100),
    DOB DATE,
    Gender VARCHAR(10),
    Registration_Date DATE DEFAULT (CURRENT_DATE)
);

-- 4. Bill table
CREATE TABLE Bill (
    Bill_ID INT PRIMARY KEY AUTO_INCREMENT,
    Status VARCHAR(20) DEFAULT 'unpaid',
    Due_Date DATE,
    Amount DECIMAL(10,2),
    Issue_Date DATE DEFAULT (CURRENT_DATE),
    Description TEXT
);

-- 5. Payment table
CREATE TABLE Payment (
    Payment_ID INT PRIMARY KEY AUTO_INCREMENT,
    Amount DECIMAL(10,2) NOT NULL,
    Method VARCHAR(50),
    Date DATETIME DEFAULT CURRENT_TIMESTAMP,
    Reference_Number VARCHAR(50),
    Notes TEXT
);

-- 6. Crew table
CREATE TABLE Crew (
    Crew_ID INT PRIMARY KEY AUTO_INCREMENT,
    Crew_Name VARCHAR(100) NOT NULL,
    Contact_Info VARCHAR(100),
    Size INT,
    Supervisor VARCHAR(100),
    Specialization VARCHAR(50)
);

-- 7. Recycling_Center table
CREATE TABLE Recycling_Center (
    Center_ID INT PRIMARY KEY AUTO_INCREMENT,
    Capacity INT,
    Location VARCHAR(255),
    Operating_Hours VARCHAR(100),
    Manager VARCHAR(100),
    Contact VARCHAR(100),
    Established_Date DATE
);

-- 8. Collection_Schedules table
CREATE TABLE Collection_Schedules (
    Schedule_ID INT PRIMARY KEY AUTO_INCREMENT,
    Schedule_Date DATE NOT NULL,
    Status VARCHAR(20) DEFAULT 'scheduled',
    Frequency VARCHAR(20),
    Assigned_Vehicle VARCHAR(50),
    Notes TEXT
);

-- 9. Waste table
CREATE TABLE Waste (
    Waste_ID INT PRIMARY KEY AUTO_INCREMENT,
    Name VARCHAR(100) NOT NULL,
    Category VARCHAR(50),
    Weight DECIMAL(10,2),
    Volume DECIMAL(10,2),
    Hazardous BOOLEAN DEFAULT FALSE,
    Description TEXT
);

-- 10. HAS_Schedule table (Junction/Relationship table for Area-Schedule-Crew ternary relationship)
CREATE TABLE HAS_Schedule (
    Area_ID INT NOT NULL,
    Schedule_ID INT NOT NULL,
    Crew_ID INT NOT NULL,
    PRIMARY KEY (Area_ID, Schedule_ID, Crew_ID),
    FOREIGN KEY (Area_ID) REFERENCES Area(Area_ID) ON DELETE CASCADE,
    FOREIGN KEY (Schedule_ID) REFERENCES Collection_Schedules(Schedule_ID) ON DELETE CASCADE,
    FOREIGN KEY (Crew_ID) REFERENCES Crew(Crew_ID) ON DELETE CASCADE
);

-- ===== INSERT DUMMY DATA (BANGLADESH PERSPECTIVE - ENGLISH) =====

-- Insert Bins (10 rows)
INSERT INTO Bins (Status, Fill_Level, Sensor, Location, Type) VALUES
('active', 75, TRUE, 'Gulshan Avenue Corner', 'General Waste'),
('maintenance', 90, FALSE, 'Banani Lake Entrance', 'Recyclables'),
('active', 45, TRUE, 'Dhanmondi Residential Area', 'Organic Waste'),
('full', 100, TRUE, 'New Market Commercial Zone', 'Hazardous Waste'),
('active', 60, TRUE, 'Motijheel Business District', 'Mixed Waste'),
('inactive', 20, FALSE, 'Gulshan Park Maintenance', 'General Waste'),
('active', 85, TRUE, 'Banani Residential Street', 'Recyclables'),
('scheduled_maintenance', 50, TRUE, 'Mirpur Shopping Center', 'Organic Waste'),
('active', 70, TRUE, 'Dhanmondi Lake Side', 'General Waste'),
('active', 55, TRUE, 'Old Dhaka Textile Area', 'Hazardous Waste');

-- Insert Areas (10 rows)
INSERT INTO Area (Area_Name, Area_Code, Population, Supervisor, Description) VALUES
('Gulshan', 'GUL001', 150000, 'Rafiq Ahmed', 'Upscale business and residential district in central Dhaka'),
('Dhanmondi', 'DHM002', 120000, 'Salma Begum', 'Educational and cultural hub near Dhanmondi Lake'),
('Old Dhaka', 'OLD003', 200000, 'Karim Khan', 'Historic commercial and densely populated area with textile industries'),
('Mirpur', 'MIR004', 180000, 'Fatima Akter', 'Family and residential multi-storey housing development'),
('Motijheel', 'MOT005', 160000, 'Hasan Ahmed', 'Central business district with corporate offices and banks'),
('Banani', 'BAN006', 110000, 'Sophia Khan', 'Upscale residential and diplomatic enclave area'),
('Kawran Bazar', 'KWB007', 140000, 'Mohammad Siddiqui', 'Wholesale market and commercial trading hub'),
('Uttara', 'UTT008', 200000, 'Amina Hossain', 'Large planned residential community with multiple zones'),
('Jatrabari', 'JAT009', 130000, 'Rashid Miah', 'Industrial and manufacturing area with multiple factories'),
('Tejgaon', 'TEJ010', 115000, 'Noor Alam', 'Industrial and commercial zone with warehouses');

-- Insert Citizens (10 rows)
INSERT INTO Citizen (Name, Address, Contact_Info, DOB, Gender) VALUES
('Muhammad Ali', 'Block-A, Bashundhara Residential Area, Dhaka', '+8801612345670', '1985-03-15', 'Male'),
('Nasma Akter', 'Apartment 5B, Gulshan Avenue, Dhaka', '+8801712345671', '1990-07-22', 'Female'),
('Rahim Saheb', 'Lake View House, Dhanmondi Lake Area, Dhaka', '+8801812345672', '1978-11-10', 'Male'),
('Halima Khatun', 'Shankhari Bazaar, Old Dhaka', '+8801912345673', '1988-05-05', 'Female'),
('Karim Hassan', 'Motijheel Commercial Building, Dhaka', '+8801012345674', '1982-09-18', 'Male'),
('Jainab Ali', 'Diplomatic Housing, Banani, Dhaka', '+8801112345675', '1992-01-30', 'Female'),
('Tanvir Rahman', 'Kawran Bazar Market Area, Dhaka', '+8801212345676', '1987-06-12', 'Male'),
('Fatma Begum', 'Uttara Housing Scheme, Sector-12, Dhaka', '+8801312345677', '1993-04-08', 'Female'),
('Nasir Uddin', 'Jatrabari Industrial Zone, Dhaka', '+8801412345678', '1980-12-25', 'Male'),
('Salma Khan', 'Tejgaon Warehouse District, Dhaka', '+8801512345679', '1986-08-14', 'Female');

-- Insert Bills (10 rows)
INSERT INTO Bill (Status, Due_Date, Amount, Issue_Date, Description) VALUES
('paid', '2025-11-30', 2500.00, '2025-11-01', 'Monthly waste collection fee'),
('unpaid', '2025-12-15', 3500.00, '2025-12-01', 'Recycling services fee'),
('overdue', '2025-10-20', 1800.00, '2025-10-01', 'Special waste disposal charge'),
('paid', '2025-11-25', 4000.00, '2025-11-15', 'Hazardous waste handling fee'),
('pending', '2025-12-10', 2200.00, '2025-11-20', 'Quarterly maintenance charge'),
('unpaid', '2025-12-05', 1500.00, '2025-11-15', 'General waste removal fee'),
('paid', '2025-11-28', 3200.00, '2025-11-08', 'Bin replacement and repair fee'),
('overdue', '2025-10-31', 2800.00, '2025-10-15', 'Organic waste collection fee'),
('paid', '2025-11-20', 5000.00, '2025-10-20', 'Annual commercial waste contract'),
('unpaid', '2025-12-20', 1950.00, '2025-12-01', 'Street cleaning service fee');

-- Insert Payments (10 rows)
INSERT INTO Payment (Amount, Method, Reference_Number, Date, Notes) VALUES
(2500.00, 'Bkash', 'BKH001', '2025-11-25 10:30:00', 'On time payment received'),
(3500.00, 'Bank Transfer', 'BTR002', '2025-11-28 14:15:00', 'Partial payment processed'),
(1800.00, 'Cash', 'CSH003', '2025-10-22 16:45:00', 'Late fee applied and paid'),
(4000.00, 'Nagad', 'NGD004', '2025-11-20 09:00:00', 'Auto payment processed'),
(2200.00, 'Bkash', 'BKH005', '2025-11-30 11:20:00', 'Quarterly payment received'),
(1500.00, 'Cash', 'CSH006', '2025-11-25 15:45:00', 'General waste fee collected'),
(3200.00, 'Bank Transfer', 'BTR007', '2025-11-22 08:30:00', 'Bin maintenance payment'),
(2800.00, 'Nagad', 'NGD008', '2025-11-18 13:10:00', 'Organic waste service paid'),
(5000.00, 'Check', 'CHK009', '2025-11-15 10:00:00', 'Annual contract payment received'),
(1950.00, 'Bkash', 'BKH010', '2025-12-01 09:45:00', 'Street cleaning service paid');

-- Insert Crews (10 rows)
INSERT INTO Crew (Crew_Name, Contact_Info, Size, Supervisor, Specialization) VALUES
('Alpha Team', 'alpha@crew.bd', 5, 'Karim Supervisor', 'General waste collection'),
('Beta Squad', 'beta@crew.bd', 4, 'Jamila Supervisoress', 'Recycling collection and sorting'),
('Gamma Group', 'gamma@crew.bd', 6, 'Hasan Ahmed', 'Hazardous waste handling'),
('Delta Unit', 'delta@crew.bd', 3, 'Sayma Hossain', 'Maintenance and repairs'),
('Echo Force', 'echo@crew.bd', 7, 'Mahmud Khan', 'Street cleaning and sweeping'),
('Foxtrot Team', 'foxtrot@crew.bd', 5, 'Nasira Begum', 'Organic waste composting'),
('Golf Squad', 'golf@crew.bd', 4, 'Rashid Miah', 'Bin relocation and installation'),
('Hotel Crew', 'hotel@crew.bd', 6, 'Amina Akter', 'Commercial area waste management'),
('India Team', 'india@crew.bd', 5, 'Noor Alam', 'Industrial waste handling'),
('Juliet Unit', 'juliet@crew.bd', 3, 'Sophia Khan', 'Recycling center operations');

-- Insert Recycling Centers (10 rows)
INSERT INTO Recycling_Center (Capacity, Location, Operating_Hours, Manager, Contact, Established_Date) VALUES
(5000, 'Gazipur Recycling Hub, Dhaka', '8:00 AM - 6:00 PM', 'Dr. Mohammad Haque', 'gazpur@recycle.bd', '2018-01-15'),
(3500, 'Savar Eco Center, Dhaka', '7:00 AM - 7:00 PM', 'Mariam Begum', 'savar@recycle.bd', '2019-06-20'),
(6000, 'Tongi Plastic Recycling, Narayanganj', '8:00 AM - 8:00 PM', 'Engineer Abdul Latif', 'tonggi@recycle.bd', '2020-03-10'),
(2500, 'Narsingdi E-waste Hub', '9:00 AM - 5:00 PM', 'Dr. Farhana Khan', 'narayanganj@recycle.bd', '2022-11-05'),
(4200, 'Tejgaon Metals Recycling', '7:30 AM - 5:30 PM', 'Mustafa Karim', 'tejgaon@recycle.bd', '2017-08-22'),
(3800, 'Jatrabari Composting Facility', '6:00 AM - 4:00 PM', 'Runa Das', 'jatrabari@recycle.bd', '2019-03-30'),
(5500, 'Mirpur Waste Processing Plant', '8:00 AM - 6:00 PM', 'Shafiq Ahmed', 'mirpur@recycle.bd', '2021-05-12'),
(2800, 'Kawran Bazar Sorting Center', '8:00 AM - 7:00 PM', 'Nadia Sultana', 'kawran@recycle.bd', '2020-09-18'),
(4100, 'Gulshan Green Initiative Center', '8:00 AM - 6:00 PM', 'Dr. Habib Rahman', 'gulshan@recycle.bd', '2019-11-14'),
(3300, 'Dhanmondi Environmental Center', '9:00 AM - 5:00 PM', 'Professor Aziz Hassan', 'dhanmondi@recycle.bd', '2021-02-08');

-- Insert Collection Schedules (10 rows)
INSERT INTO Collection_Schedules (Schedule_Date, Status, Frequency, Assigned_Vehicle, Notes) VALUES
('2025-11-27', 'completed', 'weekly', 'Truck-01', 'Gulshan and Banani route collection'),
('2025-11-28', 'scheduled', 'daily', 'Truck-02', 'Dhanmondi residential area collection'),
('2025-11-29', 'in_progress', 'bi-weekly', 'Truck-03', 'Old Dhaka textile area sweep'),
('2025-11-30', 'scheduled', 'monthly', 'Truck-04', 'Mirpur deep cleaning operation'),
('2025-12-01', 'completed', 'daily', 'Truck-05', 'Motijheel commercial district pickup'),
('2025-12-02', 'scheduled', 'weekly', 'Truck-06', 'Kawran Bazar wholesale market area'),
('2025-12-03', 'in_progress', 'daily', 'Truck-07', 'Uttara housing scheme collection'),
('2025-12-04', 'scheduled', 'bi-weekly', 'Truck-08', 'Jatrabari industrial zone pickup'),
('2025-12-05', 'pending', 'weekly', 'Truck-09', 'Tejgaon warehouse district sweep'),
('2025-12-06', 'scheduled', 'monthly', 'Truck-10', 'Full city general maintenance route');

-- Insert Waste types (10 rows)
INSERT INTO Waste (Name, Category, Weight, Volume, Hazardous, Description) VALUES
('Plastic Bottles', 'Recyclables', 15.5, 25.0, FALSE, 'Single-use plastic bottles and containers from households'),
('Electronic Waste', 'Hazardous', 8.0, 5.0, TRUE, 'Old computers, mobile phones, televisions, and electronic devices'),
('Organic Waste', 'Biodegradable', 45.0, 60.0, FALSE, 'Food waste and garden leaves from households and markets'),
('Metal Scrap', 'Recyclables', 22.0, 18.0, FALSE, 'Iron and aluminum waste from industrial areas'),
('Paper and Cardboard', 'Recyclables', 12.5, 35.0, FALSE, 'Waste paper, newspaper, and cardboard boxes'),
('Glass Waste', 'Recyclables', 18.0, 12.0, FALSE, 'Broken glass bottles and glass containers'),
('Hazardous Chemicals', 'Hazardous', 5.5, 8.0, TRUE, 'Medical waste, batteries, and chemical containers'),
('Textile Waste', 'Mixed', 25.0, 40.0, FALSE, 'Old clothes and textile scraps from garment factories'),
('Construction Debris', 'Mixed', 50.0, 75.0, FALSE, 'Brick, concrete, and building waste from construction sites'),
('Rubber Tires', 'Recyclables', 30.0, 20.0, FALSE, 'Used rubber tires from vehicles for recycling programs');

-- Insert HAS_Schedule relationships (Area-Schedule-Crew ternary - 10 rows)
INSERT INTO HAS_Schedule (Area_ID, Schedule_ID, Crew_ID) VALUES
(1, 1, 1),
(2, 2, 2),
(3, 3, 3),
(4, 4, 4),
(5, 5, 5),
(6, 6, 1),
(7, 7, 2),
(8, 8, 3),
(9, 9, 4),
(10, 10, 5);
