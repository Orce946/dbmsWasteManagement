-- Add necessary constraints to wasteManagement Database
USE wasteManagemet;

-- ========================================
-- PRIMARY KEY CONSTRAINTS (Already set during creation)
-- ========================================

-- ========================================
-- UNIQUE CONSTRAINTS
-- ========================================

-- Ensure citizen contact is unique
ALTER TABLE Citizen 
ADD CONSTRAINT uk_citizen_contact UNIQUE (contact);

-- Ensure area name is unique
ALTER TABLE Area 
ADD CONSTRAINT uk_area_name UNIQUE (area_name);

-- Ensure crew name is unique
ALTER TABLE Crew 
ADD CONSTRAINT uk_crew_name UNIQUE (crew_name);

-- Ensure team name is unique
ALTER TABLE Assigned 
ADD CONSTRAINT uk_team_name UNIQUE (team_name);

-- ========================================
-- NOT NULL CONSTRAINTS (Adding/Enforcing)
-- ========================================

-- Ensure Bill status is not null
ALTER TABLE Bill 
MODIFY COLUMN status VARCHAR(50) NOT NULL;

-- Ensure Bill amount is not null
ALTER TABLE Bill 
MODIFY COLUMN amount DECIMAL(10, 2) NOT NULL;

-- Ensure Bill due_date is not null
ALTER TABLE Bill 
MODIFY COLUMN due_date DATE NOT NULL;

-- Ensure Payment amount is not null
ALTER TABLE Payment 
MODIFY COLUMN amount DECIMAL(10, 2) NOT NULL;

-- Ensure Payment method is not null
ALTER TABLE Payment 
MODIFY COLUMN method VARCHAR(50) NOT NULL;

-- Ensure Payment payment_date is not null
ALTER TABLE Payment 
MODIFY COLUMN payment_date DATE NOT NULL;

-- Ensure Waste name is not null
ALTER TABLE Waste 
MODIFY COLUMN name VARCHAR(100) NOT NULL;

-- Ensure Waste category is not null
ALTER TABLE Waste 
MODIFY COLUMN category VARCHAR(50) NOT NULL;

-- Ensure Recycling_Center location is not null
ALTER TABLE Recycling_Center 
MODIFY COLUMN location VARCHAR(255) NOT NULL;

-- Ensure Recycling_Center capacity is not null
ALTER TABLE Recycling_Center 
MODIFY COLUMN capacity INT NOT NULL;

-- ========================================
-- CHECK CONSTRAINTS
-- ========================================

-- Bill status must be one of the allowed values
ALTER TABLE Bill 
ADD CONSTRAINT chk_bill_status CHECK (status IN ('Pending', 'Paid', 'Overdue', 'Cancelled'));

-- Bill amount must be positive
ALTER TABLE Bill 
ADD CONSTRAINT chk_bill_amount CHECK (amount > 0);

-- Payment amount must be positive
ALTER TABLE Payment 
ADD CONSTRAINT chk_payment_amount CHECK (amount > 0);

-- Payment method must be one of the allowed values
ALTER TABLE Payment 
ADD CONSTRAINT chk_payment_method CHECK (method IN ('Cash', 'Credit Card', 'Debit Card', 'Bank Transfer', 'Online'));

-- Bins fill_level must be between 0 and 100
ALTER TABLE Bins 
ADD CONSTRAINT chk_bins_fill_level CHECK (fill_level >= 0 AND fill_level <= 100);

-- Bins status must be one of the allowed values
ALTER TABLE Bins 
ADD CONSTRAINT chk_bins_status CHECK (status IN ('Empty', 'Partially Full', 'Full', 'Maintenance'));

-- Recycling_Center capacity must be positive
ALTER TABLE Recycling_Center 
ADD CONSTRAINT chk_recycling_capacity CHECK (capacity > 0);

-- Waste category must be one of the allowed values
ALTER TABLE Waste 
ADD CONSTRAINT chk_waste_category CHECK (category IN ('Organic', 'Recyclable', 'Hazardous', 'Electronic', 'Construction', 'General'));

-- ========================================
-- DEFAULT VALUE CONSTRAINTS
-- ========================================

-- Set default status for Bins
ALTER TABLE Bins 
MODIFY COLUMN status VARCHAR(50) NOT NULL DEFAULT 'Empty';

-- Set default fill_level for Bins
ALTER TABLE Bins 
MODIFY COLUMN fill_level INT DEFAULT 0;

-- ========================================
-- FOREIGN KEY CONSTRAINTS (Already set, but adding index for performance)
-- ========================================

-- Verify foreign keys are in place
-- Area -> Citizen
-- Area -> Bins
-- Area -> Assigned
-- Area -> Collection_Schedule
-- Area -> Crew
-- Area -> Has_Schedule
-- Citizen -> Waste
-- Citizen -> Bill
-- Citizen -> Payment
-- Waste -> Recycling_Center
-- Collection_Schedule -> Crew
-- Collection_Schedule -> Has_Schedule
-- Assigned -> Crew
-- Crew -> Has_Schedule
-- Bill -> Payment

-- ========================================
-- INDEXES FOR PERFORMANCE
-- ========================================

-- Create composite indexes for common queries
CREATE INDEX idx_bill_citizen_status ON Bill(citizen_id, status);
CREATE INDEX idx_payment_citizen_date ON Payment(citizen_id, payment_date);
CREATE INDEX idx_waste_citizen_category ON Waste(citizen_id, category);
CREATE INDEX idx_bins_area_status ON Bins(area_id, status);
CREATE INDEX idx_collection_schedule_date ON Collection_Schedule(schedule_date);
CREATE INDEX idx_crew_team ON Crew(team_id);

-- ========================================
-- VERIFICATION QUERIES
-- ========================================

-- Verify all tables
SELECT TABLE_NAME FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_SCHEMA = 'wasteManagemet' ORDER BY TABLE_NAME;

-- Verify all constraints
SELECT CONSTRAINT_NAME, TABLE_NAME, CONSTRAINT_TYPE 
FROM INFORMATION_SCHEMA.TABLE_CONSTRAINTS 
WHERE TABLE_SCHEMA = 'wasteManagemet' 
ORDER BY TABLE_NAME, CONSTRAINT_TYPE;
