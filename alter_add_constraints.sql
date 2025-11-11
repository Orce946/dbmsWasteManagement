-- Comprehensive ALTER constraints for wasteManagemet Database
USE wasteManagemet;

-- ============================================================================
-- 1. ALTER TABLE - ADD UNIQUE CONSTRAINTS
-- ============================================================================

-- Citizen: Contact should be unique
ALTER TABLE Citizen 
ADD CONSTRAINT uk_citizen_contact UNIQUE (contact);

-- Area: Area name should be unique
ALTER TABLE Area 
ADD CONSTRAINT uk_area_name UNIQUE (area_name);

-- Crew: Crew name should be unique
ALTER TABLE Crew 
ADD CONSTRAINT uk_crew_name UNIQUE (crew_name);

-- Crew: Contact should be unique
ALTER TABLE Crew 
ADD CONSTRAINT uk_crew_contact UNIQUE (contact);

-- Assigned: Team name should be unique
ALTER TABLE Assigned 
ADD CONSTRAINT uk_team_name UNIQUE (team_name);

-- Recycling_Center: Location should be unique
ALTER TABLE Recycling_Center 
ADD CONSTRAINT uk_recycling_location UNIQUE (location);

-- ============================================================================
-- 2. ALTER TABLE - ADD CHECK CONSTRAINTS
-- ============================================================================

-- Bill: Status check - only allow specific values
ALTER TABLE Bill 
ADD CONSTRAINT chk_bill_status CHECK (status IN ('Pending', 'Paid', 'Overdue', 'Cancelled'));

-- Bill: Amount must be positive
ALTER TABLE Bill 
ADD CONSTRAINT chk_bill_amount CHECK (amount > 0);

-- Bill: Due date should not be in the past (optional, can be removed if needed)
-- ALTER TABLE Bill 
-- ADD CONSTRAINT chk_bill_due_date CHECK (due_date >= CURDATE());

-- Payment: Amount must be positive
ALTER TABLE Payment 
ADD CONSTRAINT chk_payment_amount CHECK (amount > 0);

-- Payment: Method check - only allow specific payment methods
ALTER TABLE Payment 
ADD CONSTRAINT chk_payment_method CHECK (method IN ('Cash', 'Credit Card', 'Debit Card', 'Bank Transfer', 'Online'));

-- Payment: Payment date should not be in the future
ALTER TABLE Payment 
ADD CONSTRAINT chk_payment_date CHECK (payment_date <= CURDATE());

-- Bins: Fill level should be between 0 and 100
ALTER TABLE Bins 
ADD CONSTRAINT chk_bins_fill_level CHECK (fill_level >= 0 AND fill_level <= 100);

-- Bins: Status check
ALTER TABLE Bins 
ADD CONSTRAINT chk_bins_status CHECK (status IN ('Empty', 'Partially Full', 'Full', 'Maintenance'));

-- Waste: Category check
ALTER TABLE Waste 
ADD CONSTRAINT chk_waste_category CHECK (category IN ('Organic', 'Recyclable', 'Hazardous', 'Electronic', 'Construction', 'General'));

-- Recycling_Center: Capacity must be positive
ALTER TABLE Recycling_Center 
ADD CONSTRAINT chk_recycling_capacity CHECK (capacity > 0);

-- Collection_Schedule: Schedule date should not be in the past
ALTER TABLE Collection_Schedule 
ADD CONSTRAINT chk_schedule_date CHECK (schedule_date >= CURDATE());

-- ============================================================================
-- 3. ALTER TABLE - MODIFY COLUMNS TO ADD NOT NULL CONSTRAINTS
-- ============================================================================

-- Bill table - ensure critical columns are NOT NULL
ALTER TABLE Bill 
MODIFY COLUMN status VARCHAR(50) NOT NULL;

ALTER TABLE Bill 
MODIFY COLUMN amount DECIMAL(10, 2) NOT NULL;

ALTER TABLE Bill 
MODIFY COLUMN due_date DATE NOT NULL;

-- Payment table - ensure critical columns are NOT NULL
ALTER TABLE Payment 
MODIFY COLUMN amount DECIMAL(10, 2) NOT NULL;

ALTER TABLE Payment 
MODIFY COLUMN method VARCHAR(50) NOT NULL;

ALTER TABLE Payment 
MODIFY COLUMN payment_date DATE NOT NULL;

-- Waste table - ensure critical columns are NOT NULL
ALTER TABLE Waste 
MODIFY COLUMN name VARCHAR(100) NOT NULL;

ALTER TABLE Waste 
MODIFY COLUMN category VARCHAR(50) NOT NULL;

-- Bins table - ensure critical columns are NOT NULL
ALTER TABLE Bins 
MODIFY COLUMN status VARCHAR(50) NOT NULL;

ALTER TABLE Bins 
MODIFY COLUMN fill_level INT NOT NULL DEFAULT 0;

-- Recycling_Center table - ensure critical columns are NOT NULL
ALTER TABLE Recycling_Center 
MODIFY COLUMN location VARCHAR(255) NOT NULL;

ALTER TABLE Recycling_Center 
MODIFY COLUMN capacity INT NOT NULL;

ALTER TABLE Recycling_Center 
MODIFY COLUMN operating_hours VARCHAR(50) NOT NULL;

-- Collection_Schedule table - ensure critical columns are NOT NULL
ALTER TABLE Collection_Schedule 
MODIFY COLUMN schedule_date DATE NOT NULL;

-- Area table - ensure critical columns are NOT NULL
ALTER TABLE Area 
MODIFY COLUMN area_name VARCHAR(100) NOT NULL;

-- ============================================================================
-- 4. ALTER TABLE - ADD DEFAULT VALUES
-- ============================================================================

-- Bins: Default status is Empty
ALTER TABLE Bins 
MODIFY COLUMN status VARCHAR(50) NOT NULL DEFAULT 'Empty';

-- Bins: Default fill level is 0
ALTER TABLE Bins 
MODIFY COLUMN fill_level INT NOT NULL DEFAULT 0;

-- Bill: Default status is Pending
ALTER TABLE Bill 
MODIFY COLUMN status VARCHAR(50) NOT NULL DEFAULT 'Pending';

-- ============================================================================
-- 5. ALTER TABLE - ADD COMPOSITE UNIQUE CONSTRAINTS
-- ============================================================================

-- Has_Schedule: Unique combination of area, crew, and schedule (if not already set)
-- This ensures no duplicate assignments

-- ============================================================================
-- 6. ALTER TABLE - ADD INDEXES FOR FOREIGN KEYS AND COMMON QUERIES
-- ============================================================================

-- Already indexed foreign keys for performance
CREATE INDEX IF NOT EXISTS idx_citizen_area ON Citizen(area_id);
CREATE INDEX IF NOT EXISTS idx_bins_area ON Bins(area_id);
CREATE INDEX IF NOT EXISTS idx_waste_citizen ON Waste(citizen_id);
CREATE INDEX IF NOT EXISTS idx_crew_area ON Crew(area_id);
CREATE INDEX IF NOT EXISTS idx_crew_schedule ON Crew(schedule_id);
CREATE INDEX IF NOT EXISTS idx_crew_team ON Crew(team_id);
CREATE INDEX IF NOT EXISTS idx_bill_citizen ON Bill(citizen_id);
CREATE INDEX IF NOT EXISTS idx_payment_citizen ON Payment(citizen_id);
CREATE INDEX IF NOT EXISTS idx_payment_bill ON Payment(bill_id);
CREATE INDEX IF NOT EXISTS idx_recycling_waste ON Recycling_Center(waste_id);
CREATE INDEX IF NOT EXISTS idx_collection_area ON Collection_Schedule(area_id);
CREATE INDEX IF NOT EXISTS idx_assigned_area ON Assigned(area_id);

-- Composite indexes for common queries
CREATE INDEX IF NOT EXISTS idx_bill_citizen_status ON Bill(citizen_id, status);
CREATE INDEX IF NOT EXISTS idx_payment_citizen_date ON Payment(citizen_id, payment_date);
CREATE INDEX IF NOT EXISTS idx_waste_citizen_category ON Waste(citizen_id, category);
CREATE INDEX IF NOT EXISTS idx_bins_area_status ON Bins(area_id, status);
CREATE INDEX IF NOT EXISTS idx_collection_schedule_date ON Collection_Schedule(schedule_date);

-- ============================================================================
-- 7. VERIFICATION QUERIES
-- ============================================================================

-- Show all tables with their constraints
SELECT 
    CONSTRAINT_NAME,
    TABLE_NAME,
    CONSTRAINT_TYPE
FROM INFORMATION_SCHEMA.TABLE_CONSTRAINTS
WHERE TABLE_SCHEMA = 'wasteManagemet'
ORDER BY TABLE_NAME, CONSTRAINT_TYPE;

-- Show all check constraints
SELECT 
    CONSTRAINT_NAME,
    TABLE_NAME,
    CHECK_CLAUSE
FROM INFORMATION_SCHEMA.CHECK_CONSTRAINTS
WHERE CONSTRAINT_SCHEMA = 'wasteManagemet'
ORDER BY TABLE_NAME;

-- Show all indexes
SELECT 
    INDEX_NAME,
    TABLE_NAME,
    COLUMN_NAME,
    SEQ_IN_INDEX
FROM INFORMATION_SCHEMA.STATISTICS
WHERE TABLE_SCHEMA = 'wasteManagemet'
AND INDEX_NAME != 'PRIMARY'
ORDER BY TABLE_NAME, INDEX_NAME, SEQ_IN_INDEX;
