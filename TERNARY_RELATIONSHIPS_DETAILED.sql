-- ============================================================================
-- TERNARY RELATIONSHIPS - DETAILED EXPLANATION
-- ============================================================================
-- This file explains the 2 ternary relationships in the Waste Management Database

USE wasteManagemet;

-- ============================================================================
-- TERNARY RELATIONSHIP #1: Has_Schedule (Area ↔ Crew ↔ Schedule)
-- ============================================================================

/*
WHAT IS A TERNARY RELATIONSHIP?
A ternary relationship involves three entities (tables) instead of two.
It's represented as a junction/bridge table that stores the relationship.

HAS_SCHEDULE RELATIONSHIP:
═════════════════════════════════════════════════════════════════════════

Three Entities:
1. Area - Where the collection happens
2. Crew - Who performs the collection
3. Collection_Schedule - When the collection happens

THE PROBLEM IT SOLVES:
─────────────────────
Binary relationships would require:
  • Crew.schedule_id (which crew is on which schedule) ✗ Doesn't track AREA
  • Area.crew_id (which crew is in which area) ✗ Doesn't track SCHEDULE
  
Solution: Junction table Has_Schedule that combines all three!

STRUCTURE:
──────────────────────────────────────────────────────────────────────────

Table: Area
┌──────────┐
│ area_id  │ (PK)
│ area_id  │ = 1 (Downtown)
│ area_id  │ = 2 (Uptown)
└──────────┘
     ▲
     │ (1:N relationship)
     │
     │
┌────────────────────────────────────────────────────────┐
│              Has_Schedule (Junction)                   │
├────────────────────────────────────────────────────────┤
│ has_schedule_id (PK)       area_id (FK)               │
│                            crew_id (FK)               │
│                            schedule_id (FK)           │
│                                                        │
│ Example Data:                                          │
│ 1          |  1 (Downtown) | 1 (Crew1) | 1 (11/15)   │
│ 2          |  1 (Downtown) | 2 (Crew2) | 1 (11/15)   │
│ 3          |  2 (Uptown)   | 1 (Crew1) | 2 (11/18)   │
│ 4          |  2 (Uptown)   | 3 (Crew3) | 2 (11/18)   │
│ UNIQUE KEY: (area_id, crew_id, schedule_id)          │
└────────────────────────────────────────────────────────┘
     ▲                          ▲              ▲
     │ (1:N)                    │ (1:N)        │ (1:N)
     │                          │              │
     │                          │              │
┌────┴──┐                  ┌────┴──┐    ┌────┴──────────────┐
│ Crew  │                  │ Crew  │    │ Collection_       │
│       │                  │       │    │ Schedule          │
│crew_id│ = 1 (Crew1)      │crew_id│    │                   │
│crew_id│ = 2 (Crew2)      │ = 2   │    │ schedule_id=1     │
│crew_id│ = 3 (Crew3)      │(Crew2)│    │ date: 2025-11-15  │
└───────┘                  └───────┘    │                   │
                                        │ schedule_id=2     │
                                        │ date: 2025-11-18  │
                                        └───────────────────┘

MEANING OF EACH RECORD:
──────────────────────
Row 1: Crew1 is assigned to Downtown area on 11/15
Row 2: Crew2 is assigned to Downtown area on 11/15
Row 3: Crew1 is assigned to Uptown area on 11/18
Row 4: Crew3 is assigned to Uptown area on 11/18

KEY CHARACTERISTICS:
────────────────────
• Junction table (bridge table) connecting 3 entities
• UNIQUE constraint on (area_id, crew_id, schedule_id) prevents duplicates
• Each combination must be unique (same crew can't be in same area on same date twice)
• All 3 foreign keys are mandatory (NOT NULL)

ADVANTAGES:
───────────
✓ Can answer: "Which crews work in which areas on which dates?"
✓ Can add attributes if needed: (e.g., status, notes, completion_time)
✓ Flexible: Can change relationships without modifying Crew table
✓ Supports many-to-many through 3 tables

QUERIES FOR HAS_SCHEDULE:
───────────────────────────────────────────────────────────────────────
*/

-- Query 1: Get all crew assignments for a specific area
SELECT 
    hs.has_schedule_id,
    a.area_name,
    c.crew_name,
    cs.schedule_date
FROM Has_Schedule hs
JOIN Area a ON hs.area_id = a.area_id
JOIN Crew c ON hs.crew_id = c.crew_id
JOIN Collection_Schedule cs ON hs.schedule_id = cs.schedule_id
WHERE hs.area_id = 1;

-- Query 2: Get all assignments for a specific crew
SELECT 
    hs.has_schedule_id,
    a.area_name,
    c.crew_name,
    cs.schedule_date
FROM Has_Schedule hs
JOIN Area a ON hs.area_id = a.area_id
JOIN Crew c ON hs.crew_id = c.crew_id
JOIN Collection_Schedule cs ON hs.schedule_id = cs.schedule_id
WHERE hs.crew_id = 1;

-- Query 3: Get all crews assigned on a specific date
SELECT 
    hs.has_schedule_id,
    a.area_name,
    c.crew_name,
    cs.schedule_date
FROM Has_Schedule hs
JOIN Area a ON hs.area_id = a.area_id
JOIN Crew c ON hs.crew_id = c.crew_id
JOIN Collection_Schedule cs ON hs.schedule_id = cs.schedule_id
WHERE hs.schedule_id = 1;

-- Query 4: Count crew assignments per area
SELECT 
    a.area_id,
    a.area_name,
    COUNT(DISTINCT c.crew_id) as crew_count,
    GROUP_CONCAT(DISTINCT c.crew_name) as crew_names
FROM Has_Schedule hs
JOIN Area a ON hs.area_id = a.area_id
JOIN Crew c ON hs.crew_id = c.crew_id
GROUP BY a.area_id, a.area_name;

-- Query 5: Find crews with multiple area assignments
SELECT 
    c.crew_id,
    c.crew_name,
    COUNT(DISTINCT hs.area_id) as areas_assigned,
    GROUP_CONCAT(DISTINCT a.area_name) as areas
FROM Has_Schedule hs
JOIN Crew c ON hs.crew_id = c.crew_id
JOIN Area a ON hs.area_id = a.area_id
GROUP BY c.crew_id, c.crew_name
HAVING areas_assigned > 1;


-- ============================================================================
-- TERNARY RELATIONSHIP #2: Assigned (Area ↔ Team ↔ Crew)
-- ============================================================================

/*
ASSIGNED RELATIONSHIP (TEAM ASSIGNMENT):
═════════════════════════════════════════════════════════════════════════

Three Entities:
1. Area - Administrative area
2. Assigned (Team) - Team of workers
3. Crew - Individual crew members (via team reference)

THE PROBLEM IT SOLVES:
─────────────────────
How do you organize crews into teams that work in specific areas?

Binary approach would be limited:
  • Crew.area_id (crew belongs to area) ✗ Doesn't show team organization
  • Crew.team_id (crew belongs to team) ✗ Doesn't directly link team to area
  
Solution: Assigned table links teams to areas, and teams manage crews

STRUCTURE:
──────────────────────────────────────────────────────────────────────────

Table: Area
┌──────────┐
│ area_id  │ (PK)
│ area_id  │ = 1 (Downtown)
│ area_id  │ = 2 (Uptown)
└──────────┘
     ▲
     │ (1:N relationship)
     │
     │
┌────────────────────────────────────────────────────────┐
│           Assigned (Team Assignment Table)             │
├────────────────────────────────────────────────────────┤
│ team_id (PK)  team_name      area_id (FK)             │
│                                                        │
│ Example Data:                                          │
│ 1        | Team A            | 1 (Downtown)           │
│ 2        | Team B            | 1 (Downtown)           │
│ 3        | Team C            | 2 (Uptown)             │
│ UNIQUE KEY: team_name, (area_id, team_id)            │
└────────────────────────────────────────────────────────┘
     ▲
     │ (1:N relationship via team_id)
     │
     │
┌─────────────────────────────────────────────────────────┐
│              Crew (Crew Members)                        │
├─────────────────────────────────────────────────────────┤
│ crew_id (PK)  crew_name    team_id (FK)               │
│                                                        │
│ Example Data:                                          │
│ 1        | Worker1        | 1 (Team A)               │
│ 2        | Worker2        | 1 (Team A)               │
│ 3        | Worker3        | 1 (Team A)               │
│ 4        | Worker4        | 2 (Team B)               │
│ 5        | Worker5        | 3 (Team C)               │
└─────────────────────────────────────────────────────────┘

RELATIONSHIP CHAIN:
──────────────────
Crew → Assigned (via team_id) → Area

Example:
  Worker1 → Team A → Downtown
  Worker2 → Team A → Downtown
  Worker4 → Team B → Downtown
  Worker5 → Team C → Uptown

MEANING:
────────
• Team A works in Downtown area (has Workers 1, 2, 3)
• Team B works in Downtown area (has Worker 4)
• Team C works in Uptown area (has Worker 5)
• Each worker belongs to exactly one team
• Each team is assigned to exactly one area

KEY CHARACTERISTICS:
────────────────────
• Assigned table is the team registry
• Each team has an area_id showing which area it serves
• Crew members reference teams via team_id
• Not a direct many-to-many, but organized through teams

ADVANTAGES:
───────────
✓ Can organize workers into teams
✓ Can track which team manages which area
✓ Easy to find all workers in a team
✓ Easy to find all teams in an area
✓ Flexible team management (can reassign teams to areas)

QUERIES FOR ASSIGNED:
───────────────────────────────────────────────────────────────────────
*/

-- Query 1: Get all teams in a specific area with their crew
SELECT 
    a.area_name,
    a_team.team_id,
    a_team.team_name,
    c.crew_id,
    c.crew_name,
    c.contact
FROM Assigned a_team
JOIN Area a ON a_team.area_id = a.area_id
LEFT JOIN Crew c ON a_team.team_id = c.team_id
WHERE a.area_id = 1
ORDER BY a_team.team_id, c.crew_id;

-- Query 2: Get team composition with area info
SELECT 
    a.area_name,
    a_team.team_name,
    COUNT(c.crew_id) as crew_count,
    GROUP_CONCAT(c.crew_name SEPARATOR ', ') as crew_members
FROM Assigned a_team
JOIN Area a ON a_team.area_id = a.area_id
LEFT JOIN Crew c ON a_team.team_id = c.team_id
GROUP BY a_team.team_id, a_team.team_name, a.area_name;

-- Query 3: Get all crews organized by team and area
SELECT 
    a.area_name,
    a_team.team_name,
    c.crew_name,
    c.contact
FROM Crew c
JOIN Assigned a_team ON c.team_id = a_team.team_id
JOIN Area a ON a_team.area_id = a.area_id
ORDER BY a.area_name, a_team.team_name, c.crew_name;

-- Query 4: Find teams with crew members in each area
SELECT 
    a.area_id,
    a.area_name,
    COUNT(DISTINCT a_team.team_id) as team_count,
    COUNT(DISTINCT c.crew_id) as crew_count
FROM Area a
LEFT JOIN Assigned a_team ON a.area_id = a_team.area_id
LEFT JOIN Crew c ON a_team.team_id = c.team_id
GROUP BY a.area_id, a.area_name;

-- Query 5: Find crews without team assignment (if applicable)
SELECT c.crew_id, c.crew_name
FROM Crew c
WHERE c.team_id NOT IN (SELECT team_id FROM Assigned)
OR c.team_id IS NULL;

-- Query 6: Get area overview with team and crew statistics
SELECT 
    a.area_id,
    a.area_name,
    COUNT(DISTINCT a_team.team_id) as num_teams,
    COUNT(DISTINCT c.crew_id) as total_crew,
    GROUP_CONCAT(DISTINCT a_team.team_name) as team_names
FROM Area a
LEFT JOIN Assigned a_team ON a.area_id = a_team.area_id
LEFT JOIN Crew c ON a_team.team_id = c.team_id
GROUP BY a.area_id, a.area_name;


-- ============================================================================
-- COMPARISON: TERNARY vs BINARY
-- ============================================================================

/*
TERNARY RELATIONSHIP #1: Has_Schedule
──────────────────────────────────────
Involves: Area ↔ Crew ↔ Collection_Schedule
Purpose: Track crew assignments to areas on specific schedules
Type: True ternary (3 entities equally important)
Junction Table: Yes (Has_Schedule)
Use Case: "Which crew is assigned to which area on which date?"

TERNARY RELATIONSHIP #2: Assigned
─────────────────────────────────
Involves: Area ↔ Team ↔ Crew
Purpose: Organize crews into teams assigned to areas
Type: Ternary with hierarchy (Team ← Crew, Team → Area)
Junction Table: Yes (Assigned for teams)
Use Case: "Which team manages which area, and who are the crew?"

KEY DIFFERENCES:
────────────────
Has_Schedule:
  - More symmetric (all 3 tables equally connected)
  - No traversal needed (direct 3-way join)
  - For temporal assignment (date-specific)

Assigned:
  - Hierarchical (team groups crew, team assigned to area)
  - Can traverse: Crew → Team → Area
  - For organizational structure (persistent)
*/

-- ============================================================================
-- INSERTION EXAMPLES FOR TERNARY RELATIONSHIPS
-- ============================================================================

/*
STEP-BY-STEP: How to insert data into ternary relationships

FOR HAS_SCHEDULE:
─────────────────
1. First, ensure Area exists
   INSERT INTO Area (area_name) VALUES ('Downtown');
   -- Returns: area_id = 1

2. Ensure Crew exists
   INSERT INTO Crew (crew_name, contact, area_id, schedule_id, team_id)
   VALUES ('Crew A', '555-0001', 1, 1, 1);
   -- Returns: crew_id = 1

3. Ensure Collection_Schedule exists
   INSERT INTO Collection_Schedule (schedule_date, area_id)
   VALUES ('2025-11-15', 1);
   -- Returns: schedule_id = 1

4. Now create the Has_Schedule relationship
   INSERT INTO Has_Schedule (area_id, crew_id, schedule_id)
   VALUES (1, 1, 1);
   -- Creates: Crew 1 assigned to Area 1 on Schedule 1 (2025-11-15)

FOR ASSIGNED:
─────────────
1. First, ensure Area exists
   INSERT INTO Area (area_name) VALUES ('Downtown');
   -- Returns: area_id = 1

2. Create Team assignment
   INSERT INTO Assigned (team_name, area_id)
   VALUES ('Team A', 1);
   -- Returns: team_id = 1

3. Now assign Crew to Team
   INSERT INTO Crew (crew_name, contact, area_id, schedule_id, team_id)
   VALUES ('Worker 1', '555-0001', 1, 1, 1),
          ('Worker 2', '555-0002', 1, 1, 1),
          ('Worker 3', '555-0003', 1, 1, 1);
   -- Creates: Team A in Downtown with 3 workers
*/

-- ============================================================================
-- SUMMARY
-- ============================================================================

/*
The Waste Management Database includes 2 sophisticated ternary relationships:

1. HAS_SCHEDULE: Efficiently tracks which crews are assigned to which 
   areas on which collection dates using a junction table.

2. ASSIGNED: Organizes crews into teams and assigns those teams to 
   specific areas for management purposes.

Both use junction tables to connect 3 entities, providing:
✓ Flexibility in relationships
✓ Ability to track complex assignments
✓ Data integrity through foreign keys
✓ Efficient querying of multi-entity combinations

These are critical for a waste management system where:
- Multiple crews work in multiple areas
- Schedules vary by area and crew
- Teams need organizational structure
- Management needs visibility into assignments
*/
