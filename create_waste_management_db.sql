-- Create Waste Management Database
CREATE DATABASE IF NOT EXISTS wasteManagement;
USE wasteManagement;

-- Table 1: Area
CREATE TABLE IF NOT EXISTS Area (
    area_id INT PRIMARY KEY AUTO_INCREMENT,
    area_name VARCHAR(100) NOT NULL,
    description TEXT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Table 2: Citizen
CREATE TABLE IF NOT EXISTS Citizen (
    citizen_id INT PRIMARY KEY AUTO_INCREMENT,
    name VARCHAR(100) NOT NULL,
    address VARCHAR(255) NOT NULL,
    contact VARCHAR(20) NOT NULL,
    area_id INT NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (area_id) REFERENCES Area(area_id)
);

-- Table 3: Bins
CREATE TABLE IF NOT EXISTS Bins (
    bin_id INT PRIMARY KEY AUTO_INCREMENT,
    status VARCHAR(50) NOT NULL,
    fill_level INT DEFAULT 0,
    sensor VARCHAR(100),
    location VARCHAR(255),
    capacity INT DEFAULT 100,
    area_id INT NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (area_id) REFERENCES Area(area_id)
);

-- Table 4: Waste
CREATE TABLE IF NOT EXISTS Waste (
    waste_id INT PRIMARY KEY AUTO_INCREMENT,
    name VARCHAR(100) NOT NULL,
    category VARCHAR(50) NOT NULL,
    citizen_id INT NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (citizen_id) REFERENCES Citizen(citizen_id)
);

-- Table 5: Recycling Center
CREATE TABLE IF NOT EXISTS Recycling_Center (
    center_id INT PRIMARY KEY AUTO_INCREMENT,
    location VARCHAR(255) NOT NULL,
    capacity INT NOT NULL,
    operating_hours VARCHAR(50) NOT NULL,
    waste_id INT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (waste_id) REFERENCES Waste(waste_id)
);

-- Table 6: Collection_Schedule
CREATE TABLE IF NOT EXISTS Collection_Schedule (
    schedule_id INT PRIMARY KEY AUTO_INCREMENT,
    schedule_date DATE NOT NULL,
    area_id INT NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (area_id) REFERENCES Area(area_id)
);

-- Table 7: Assigned (Team)
CREATE TABLE IF NOT EXISTS Assigned (
    team_id INT PRIMARY KEY AUTO_INCREMENT,
    team_name VARCHAR(100) NOT NULL,
    area_id INT NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (area_id) REFERENCES Area(area_id)
);

-- Table 8: Crew
CREATE TABLE IF NOT EXISTS Crew (
    crew_id INT PRIMARY KEY AUTO_INCREMENT,
    crew_name VARCHAR(100) NOT NULL,
    contact VARCHAR(20) NOT NULL,
    area_id INT NOT NULL,
    schedule_id INT NOT NULL,
    team_id INT NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (area_id) REFERENCES Area(area_id),
    FOREIGN KEY (schedule_id) REFERENCES Collection_Schedule(schedule_id),
    FOREIGN KEY (team_id) REFERENCES Assigned(team_id)
);

-- Table 9: Has_Schedule
CREATE TABLE IF NOT EXISTS Has_Schedule (
    has_schedule_id INT PRIMARY KEY AUTO_INCREMENT,
    area_id INT NOT NULL,
    crew_id INT NOT NULL,
    schedule_id INT NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (area_id) REFERENCES Area(area_id),
    FOREIGN KEY (crew_id) REFERENCES Crew(crew_id),
    FOREIGN KEY (schedule_id) REFERENCES Collection_Schedule(schedule_id),
    UNIQUE KEY unique_has_schedule (area_id, crew_id, schedule_id)
);

-- Table 10: Bill
CREATE TABLE IF NOT EXISTS Bill (
    bill_id INT PRIMARY KEY AUTO_INCREMENT,
    status VARCHAR(50) NOT NULL,
    amount DECIMAL(10, 2) NOT NULL,
    due_date DATE NOT NULL,
    citizen_id INT NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (citizen_id) REFERENCES Citizen(citizen_id)
);

-- Table 11: Payment
CREATE TABLE IF NOT EXISTS Payment (
    payment_id INT PRIMARY KEY AUTO_INCREMENT,
    amount DECIMAL(10, 2) NOT NULL,
    method VARCHAR(50) NOT NULL,
    payment_date DATE NOT NULL,
    citizen_id INT NOT NULL,
    bill_id INT NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (citizen_id) REFERENCES Citizen(citizen_id),
    FOREIGN KEY (bill_id) REFERENCES Bill(bill_id)
);

-- Create indexes for better query performance
CREATE INDEX idx_citizen_area ON Citizen(area_id);
CREATE INDEX idx_bins_area ON Bins(area_id);
CREATE INDEX idx_waste_citizen ON Waste(citizen_id);
CREATE INDEX idx_crew_area ON Crew(area_id);
CREATE INDEX idx_crew_schedule ON Crew(schedule_id);
CREATE INDEX idx_bill_citizen ON Bill(citizen_id);
CREATE INDEX idx_payment_citizen ON Payment(citizen_id);
CREATE INDEX idx_payment_bill ON Payment(bill_id);
CREATE INDEX idx_recycling_waste ON Recycling_Center(waste_id);
