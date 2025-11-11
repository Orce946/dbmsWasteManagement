-- ============================================================================
-- WASTE MANAGEMENT DATABASE - VISUAL RELATIONSHIP DIAGRAM (ASCII)
-- ============================================================================

/*

                                    WASTE MANAGEMENT DATABASE
                                        11 Tables
                                   10 Binary + 2 Ternary Relations

┌─────────────────────────────────────────────────────────────────────────┐
│                            AREA (Hub Table)                             │
│  area_id (PK), area_name (UNIQUE), description, created_at             │
└────────────┬─────────────┬──────────────┬─────────────┬────────────────┘
             │             │              │             │
      1:N    │      1:N    │       1:N    │      1:N    │      1:N
             │             │              │             │
    ┌────────▼──────┐  ┌───▼─────────┐  ┌─▼──────────┐ │ ┌──────────────────────┐
    │   CITIZEN     │  │   BINS      │  │   CREW    │ │ │   COLLECTION_SCHEDULE│
    │  (M:1 to Area)│  │ (Status,    │  │(crew_name)│ │ │  (schedule_date)     │
    │               │  │  fill_level)│  │           │ │ │                      │
    │ citizen_id(PK)│  │ bin_id (PK) │  │crew_id(PK)│ │ │ schedule_id(PK)      │
    │ name          │  │ area_id(FK) │  │area_id(FK)│ │ │ area_id(FK)          │
    │ address       │  └─────────────┘  │team_id(FK)│ │ └──────────────────────┘
    │ contact(UQ)   │                   │schedule(FK) │ │
    │ area_id(FK)   │                   └────────────┘ │
    │               │                                   │
    └───┬───────────┘                                   │
        │ 1:N                                           │
        │                                               │
    ┌───▼──────────┐  ┌─────────────┐                   │
    │     BILL     │  │    WASTE    │                   │
    │(financial)   │  │(generated)  │                   │
    │              │  │             │                   │
    │ bill_id (PK) │  │waste_id(PK) │                   │
    │ status(CHK)  │  │ name        │                   │
    │ amount(CHK)  │  │category(CHK)│                   │
    │ due_date     │  │citizen_id   │                   │
    │ citizen_id   │  │   (FK)      │                   │
    │   (FK)       │  │             │                   │
    └───┬──────────┘  └──────┬──────┘                   │
        │ 1:N                │ 1:N (Optional)           │
        │                    │                          │
        │            ┌───────▼──────────┐               │
        │            │RECYCLING_CENTER  │               │
        │            │(Disposal point)  │               │
        │            │                  │               │
        │            │center_id(PK)     │               │
        │            │location(UQ)      │               │
        │            │capacity(CHK)     │               │
        │            │operating_hours   │               │
        │            │waste_id(FK-Opt)  │               │
        │            └──────────────────┘               │
        │                                               │
    ┌───▼──────────┐                                    │
    │   PAYMENT    │                                    │
    │              │                                    │
    │payment_id(PK)│                                    │
    │amount(CHK)   │                                    │
    │method(CHK)   │                                    │
    │payment_date  │                                    │
    │citizen_id(FK)│                                    │
    │bill_id (FK)  │                                    │
    └──────────────┘                                    │
                                                        │
         ┌─────────────────────────────────────────────┘
         │
         │      ┌──────────────────────────┐
         │      │   ASSIGNED (Team)        │
         │      │  (Ternary Rel. #2)      │
         │      │                          │
         │      │ team_id (PK)             │
         │      │ team_name (UQ)           │
         │      │ area_id (FK) ────────────┼─ Back to AREA
         │      │                          │
         │      └────────┬─────────────────┘
         │               │ 1:N (Crew.team_id references this)
         │               │
         │      ┌────────▼──────────────────┐
         │      │   Has_Schedule            │
         │      │  (Ternary Rel. #1)       │
         │      │ JUNCTION TABLE            │
         │      │                           │
         │      │ has_schedule_id (PK)      │
         │      │ area_id (FK) ─────────┐   │
         │      │ crew_id (FK) ─────────┼─▶ CREW (already above)
         │      │ schedule_id (FK) ──┐  │
         │      │ UNIQUE (area,crew,  │  │
         │      │         schedule)   │  │
         │      └────────────────────┬┘  │
         │                           │   │
         │                    ┌──────▼──┘
         │                    │
         └────────────────────┼─ Back to AREA
                              │
                    ┌─────────▼────────────────────────┐
                    │   COLLECTION_SCHEDULE (above)    │
                    │   Links area to schedules        │
                    └────────────────────────────────────┘


KEY RELATIONSHIPS SUMMARY:
═════════════════════════════════════════════════════════════════════════

BINARY RELATIONSHIPS (1:N = One-to-Many):
  1. Area (1) ──────► Citizen (N)           | Each citizen in one area
  2. Area (1) ──────► Bins (N)              | Multiple bins per area
  3. Area (1) ──────► Crew (N)              | Multiple crew in area
  4. Area (1) ──────► Collection_Schedule(N)| Multiple schedules per area
  5. Area (1) ──────► Assigned Teams (N)    | Multiple teams per area
  6. Citizen (1) ────► Bill (N)             | Multiple bills per citizen
  7. Citizen (1) ────► Waste (N)            | Multiple waste records
  8. Citizen (1) ────► Payment (N)          | Multiple payments made
  9. Bill (1) ───────► Payment (N)          | Multiple payments per bill
  10. Waste (1) ─────► Recycling_Center (N) | Waste routed to center

TERNARY RELATIONSHIPS (3+ Tables):
  1. Has_Schedule: Area ◄──► Crew ◄──► Collection_Schedule
     └─ Junction table linking crew assignments to schedules in areas
     
  2. Assigned: Area ◄──► Team ◄──► Crew
     └─ Links teams to areas with crew members

═════════════════════════════════════════════════════════════════════════

CONSTRAINT LEGEND:
  PK = Primary Key (unique identifier)
  FK = Foreign Key (reference to another table)
  UQ = Unique constraint (duplicate values not allowed)
  CHK = Check constraint (values must meet condition)
  Opt = Optional (can be NULL)

═════════════════════════════════════════════════════════════════════════
*/

-- ============================================================================
-- DETAILED RELATIONSHIP TABLE
-- ============================================================================

/*
┌────┬──────────────────────┬──────────────────┬──────────────┬──────────────┐
│ ID │ RELATIONSHIP         │ CARDINALITY      │ FK COLUMN    │ TYPE         │
├────┼──────────────────────┼──────────────────┼──────────────┼──────────────┤
│ 1  │ Area ─→ Citizen      │ 1:N              │ area_id      │ Mandatory    │
│ 2  │ Area ─→ Bins         │ 1:N              │ area_id      │ Mandatory    │
│ 3  │ Area ─→ Crew         │ 1:N              │ area_id      │ Mandatory    │
│ 4  │ Area ─→ Collection   │ 1:N              │ area_id      │ Mandatory    │
│ 5  │ Area ─→ Assigned     │ 1:N              │ area_id      │ Mandatory    │
│ 6  │ Citizen ─→ Bill      │ 1:N              │ citizen_id   │ Mandatory    │
│ 7  │ Citizen ─→ Waste     │ 1:N              │ citizen_id   │ Mandatory    │
│ 8  │ Citizen ─→ Payment   │ 1:N              │ citizen_id   │ Mandatory    │
│ 9  │ Bill ─→ Payment      │ 1:N              │ bill_id      │ Mandatory    │
│ 10 │ Waste ─→ Recycling   │ 1:N (Optional)   │ waste_id     │ Optional     │
│ 11 │ Has_Schedule (3-way) │ N:N:N (Ternary) │ area,crew,   │ Junction     │
│    │ Area-Crew-Schedule   │                  │ schedule     │ Table        │
│ 12 │ Assigned (3-way)     │ N:N (Ternary)   │ area,team    │ Team Assign  │
│    │ Area-Team-Crew       │                  │ (via crew)   │              │
└────┴──────────────────────┴──────────────────┴──────────────┴──────────────┘

TOTAL: 10 Binary Relationships + 2 Ternary Relationships = 12 Total Relations
*/

-- ============================================================================
-- QUERY PATTERNS FOR EACH RELATIONSHIP
-- ============================================================================

USE wasteManagemet;

-- REL 1: Get all citizens in an area
SELECT c.* FROM Citizen c WHERE c.area_id = 1;

-- REL 2: Get all bins in an area
SELECT b.* FROM Bins b WHERE b.area_id = 1;

-- REL 3: Get all crew members in an area
SELECT c.* FROM Crew c WHERE c.area_id = 1;

-- REL 4: Get all schedules for an area
SELECT cs.* FROM Collection_Schedule cs WHERE cs.area_id = 1;

-- REL 5: Get all teams in an area
SELECT a.* FROM Assigned a WHERE a.area_id = 1;

-- REL 6: Get all bills for a citizen
SELECT b.* FROM Bill b WHERE b.citizen_id = 1;

-- REL 7: Get all waste from a citizen
SELECT w.* FROM Waste w WHERE w.citizen_id = 1;

-- REL 8: Get all payments from a citizen
SELECT p.* FROM Payment p WHERE p.citizen_id = 1;

-- REL 9: Get all payments for a bill
SELECT p.* FROM Payment p WHERE p.bill_id = 1;

-- REL 10: Get recycling center for waste type
SELECT rc.* FROM Recycling_Center rc WHERE rc.waste_id = 1;

-- REL 11 (TERNARY): Get crew assignments with schedule in areas
SELECT hs.*, a.area_name, c.crew_name, cs.schedule_date
FROM Has_Schedule hs
JOIN Area a ON hs.area_id = a.area_id
JOIN Crew c ON hs.crew_id = c.crew_id
JOIN Collection_Schedule cs ON hs.schedule_id = cs.schedule_id;

-- REL 12 (TERNARY): Get teams with crew members in areas
SELECT a_team.*, a.area_name, c.crew_name
FROM Assigned a_team
JOIN Area a ON a_team.area_id = a.area_id
LEFT JOIN Crew c ON a_team.team_id = c.team_id;

