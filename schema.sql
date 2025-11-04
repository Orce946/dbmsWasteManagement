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

-- ===== INSERT DUMMY DATA =====

-- Insert Bins
INSERT INTO Bins (Status, Fill_Level, Sensor, Location, Type) VALUES
('active', 75, TRUE, 'Gulshan Avenue কোণে', 'সাধারণ বর্জ্য'),
('maintenance', 90, FALSE, 'Banani লেক এন্ট্রান্স', 'পুনর্ব্যবহারযোগ্য'),
('active', 45, TRUE, 'Dhanmondi আবাসিক এলাকা', 'জৈব বর্জ্য'),
('full', 100, TRUE, 'নিউ মার্কেট বাণিজ্যিক অঞ্চল', 'বিপজ্জনক বর্জ্য');

-- Insert Areas
INSERT INTO Area (Area_Name, Area_Code, Population, Supervisor, Description) VALUES
('Gulshan', 'GUL001', 150000, 'রফিক আহমেদ', 'উপশহর ব্যবসায়িক কেন্দ্র এবং আবাসিক এলাকা'),
('Dhanmondi', 'DHM002', 120000, 'সালমা বেগম', 'শিক্ষা ও সংস্কৃতির কেন্দ্রবিন্দু এলাকা'),
('Old Dhaka', 'OLD003', 200000, 'করিম খান', 'ঐতিহ্যবাহী বাণিজ্য এবং ঘনবসতিপূর্ণ এলাকা'),
('Mirpur', 'MIR004', 180000, 'ফাতিমা আক্তার', 'পরিবার ও আবাসিক বহুতল নির্মাণ এলাকা');

-- Insert Citizens
INSERT INTO Citizen (Name, Address, Contact_Info, DOB, Gender) VALUES
('মুহাম্মদ আলী', 'বসুন্ধরা আবাসিক এলাকা, ঢাকা', '+880161234567', '1985-03-15', 'Male'),
('নাজমা আক্তার', 'গুলশান এভিনিউ, ঢাকা', '+880171234567', '1990-07-22', 'Female'),
('রহিম সাহেব', 'ধানমন্ডি লেক এরিয়া, ঢাকা', '+880181234567', '1978-11-10', 'Male'),
('হালিমা খাতুন', 'পুরনো ঢাকা, শাঁখারি বাজার', '+880191234567', '1988-05-05', 'Female');

-- Insert Bills
INSERT INTO Bill (Status, Due_Date, Amount, Issue_Date, Description) VALUES
('paid', '2025-11-30', 2500.00, '2025-11-01', 'মাসিক বর্জ্য সংগ্রহ ফি'),
('unpaid', '2025-12-15', 3500.00, '2025-12-01', 'পুনর্ব্যবহার সেবা'),
('overdue', '2025-10-20', 1800.00, '2025-10-01', 'বিশেষ বর্জ্য নিষ্কাশন'),
('paid', '2025-11-25', 4000.00, '2025-11-15', 'বিপজ্জনক বর্জ্য হ্যান্ডলিং');

-- Insert Payments
INSERT INTO Payment (Amount, Method, Reference_Number, Date, Notes) VALUES
(2500.00, 'বিকাশ', 'BKH001', '2025-11-25 10:30:00', 'সময়মতো পেমেন্ট'),
(3500.00, 'ব্যাংক ট্রান্সফার', 'BTR002', '2025-11-28 14:15:00', 'আংশিক পেমেন্ট'),
(1800.00, 'নগদ', 'CSH003', '2025-10-22 16:45:00', 'বিলম্ব ফি যোগ'),
(4000.00, 'নগদ', 'CSH004', '2025-11-20 09:00:00', 'স্বয়ংক্রিয় পেমেন্ট');

-- Insert Crews
INSERT INTO Crew (Crew_Name, Contact_Info, Size, Supervisor, Specialization) VALUES
('আলফা টিম', 'alfa@crew.bd', 5, 'করিম সাহেব', 'সাধারণ সংগ্রহ'),
('বিটা স্কোয়াড', 'beta@crew.bd', 4, 'জামিলা খাতুন', 'পুনর্ব্যবহার সংগ্রহ'),
('গামা গ্রুপ', 'gamma@crew.bd', 6, 'হাসান আহমেদ', 'বিপজ্জনক বর্জ্য সেবা'),
('ডেল্টা ইউনিট', 'delta@crew.bd', 3, 'সায়মা হোসেন', 'রক্ষণাবেক্ষণ কাজ');

-- Insert Recycling Centers
INSERT INTO Recycling_Center (Capacity, Location, Operating_Hours, Manager, Contact, Established_Date) VALUES
(5000, 'গাজীপুর রিসাইক্লিং হাব, ঢাকা', '৮টা-৬টা', 'ডাক্তার মোহাম্মদ', 'gazpur@recycle.bd', '2018-01-15'),
(3500, 'সাভার ইকো সেন্টার, ঢাকা', '৭টা-৭টা', 'মারিয়াম বেগম', 'savar@recycle.bd', '2019-06-20'),
(6000, 'টনগী প্লাস্টিক রিসাইক্লিং, নারায়ণগঞ্জ', '৮টা-৮টা', 'ইঞ্জিনিয়ার আবদুল', 'tonggi@recycle.bd', '2020-03-10'),
(2500, 'নারসিংদী ই-ওয়েস্ট হাব', '৯টা-৫টা', 'ডক্টর ফারহানা', 'narayanganj@recycle.bd', '2022-11-05');

-- Insert Collection Schedules
INSERT INTO Collection_Schedules (Schedule_Date, Status, Frequency, Assigned_Vehicle, Notes) VALUES
('2025-11-27', 'completed', 'সাপ্তাহিক', 'ট্রাক-১', 'গুলশান ও বনানী রুট'),
('2025-11-28', 'scheduled', 'দৈনিক', 'ট্রাক-২', 'ধানমন্ডি রুট'),
('2025-11-29', 'in_progress', 'দ্বি-সাপ্তাহিক', 'ট্রাক-৩', 'পুরনো ঢাকা সংগ্রহ'),
('2025-11-30', 'scheduled', 'মাসিক', 'ট্রাক-৪', 'মিরপুর গভীর পরিষ্কার');

-- Insert Waste types
INSERT INTO Waste (Name, Category, Weight, Volume, Hazardous, Description) VALUES
('প্লাস্টিক বোতল', 'পুনর্ব্যবহারযোগ্য', 15.5, 25.0, FALSE, 'একক ব্যবহারের প্লাস্টিক বোতল ও ব্যাগ'),
('ইলেকট্রনিক বর্জ্য', 'বিপজ্জনক', 8.0, 5.0, TRUE, 'পুরানো কম্পিউটার, মোবাইল, টিভি'),
('জৈব বর্জ্য', 'বায়োডিগ্রেডেবল', 45.0, 60.0, FALSE, 'খাবার অবশেষ এবং বাগানের পাতা'),
('ধাতব স্ক্র্যাপ', 'পুনর্ব্যবহারযোগ্য', 22.0, 18.0, FALSE, 'লোহা এবং অ্যালুমিনিয়াম বর্জ্য');

-- Insert HAS_Schedule relationships (Area-Schedule-Crew ternary)
INSERT INTO HAS_Schedule (Area_ID, Schedule_ID, Crew_ID) VALUES
(1, 1, 1),
(2, 2, 2),
(3, 3, 3),
(4, 4, 4);
