<?php
class Crew {
    private $conn;
    private $table = 'Crew';

    public function __construct($db) {
        $this->conn = $db;
    }

    // Get all crew members
    public function getAll() {
        $query = "SELECT c.*, a.area_name, cs.schedule_date, t.team_name FROM " . $this->table . " c 
                  LEFT JOIN Area a ON c.area_id = a.area_id 
                  LEFT JOIN Collection_Schedule cs ON c.schedule_id = cs.schedule_id 
                  LEFT JOIN Assigned t ON c.team_id = t.team_id 
                  ORDER BY c.crew_id DESC";
        $result = $this->conn->query($query);
        
        if (!$result) {
            return ['success' => false, 'error' => $this->conn->error];
        }
        
        $crew = [];
        while ($row = $result->fetch_assoc()) {
            $crew[] = $row;
        }
        return ['success' => true, 'data' => $crew];
    }

    // Get by area
    public function getByArea($area_id) {
        $area_id = intval($area_id);
        $query = "SELECT c.*, a.area_name, cs.schedule_date, t.team_name FROM " . $this->table . " c 
                  LEFT JOIN Area a ON c.area_id = a.area_id 
                  LEFT JOIN Collection_Schedule cs ON c.schedule_id = cs.schedule_id 
                  LEFT JOIN Assigned t ON c.team_id = t.team_id 
                  WHERE c.area_id = " . $area_id . " 
                  ORDER BY c.crew_id DESC";
        $result = $this->conn->query($query);
        
        if (!$result) {
            return ['success' => false, 'error' => $this->conn->error];
        }
        
        $crew = [];
        while ($row = $result->fetch_assoc()) {
            $crew[] = $row;
        }
        return ['success' => true, 'data' => $crew];
    }

    // Create crew member
    public function create($crew_name, $contact, $area_id, $schedule_id = null, $team_id = null) {
        if (empty($crew_name) || empty($area_id)) {
            return ['success' => false, 'error' => 'Crew name and area are required'];
        }

        // If schedule_id or team_id are not provided, get defaults or use 1
        if (empty($schedule_id)) {
            // Try to get a default schedule for the area, otherwise use 1
            $scheduleQuery = "SELECT schedule_id FROM Collection_Schedule WHERE area_id = " . intval($area_id) . " LIMIT 1";
            $scheduleResult = $this->conn->query($scheduleQuery);
            if ($scheduleResult && $row = $scheduleResult->fetch_assoc()) {
                $schedule_id = $row['schedule_id'];
            } else {
                $schedule_id = 1; // Default to first schedule
            }
        }
        
        if (empty($team_id)) {
            // Try to get a default team for the area, otherwise use 1
            $teamQuery = "SELECT team_id FROM Assigned WHERE area_id = " . intval($area_id) . " LIMIT 1";
            $teamResult = $this->conn->query($teamQuery);
            if ($teamResult && $row = $teamResult->fetch_assoc()) {
                $team_id = $row['team_id'];
            } else {
                $team_id = 1; // Default to first team
            }
        }

        $crew_name = $this->conn->real_escape_string($crew_name);
        $contact = $this->conn->real_escape_string($contact);
        $area_id = intval($area_id);
        $schedule_id = intval($schedule_id);
        $team_id = intval($team_id);

        $query = "INSERT INTO " . $this->table . " (crew_name, contact, area_id, schedule_id, team_id) 
                  VALUES ('" . $crew_name . "', '" . $contact . "', " . $area_id . ", " . $schedule_id . ", " . $team_id . ")";
        
        if ($this->conn->query($query)) {
            return ['success' => true, 'message' => 'Crew member created successfully', 'id' => $this->conn->insert_id];
        }
        
        return ['success' => false, 'error' => $this->conn->error];
    }

    // Update crew member
    public function update($id, $crew_name, $contact, $area_id = null) {
        if (empty($crew_name)) {
            return ['success' => false, 'error' => 'Crew name is required'];
        }

        $id = intval($id);
        $crew_name = $this->conn->real_escape_string($crew_name);
        $contact = $this->conn->real_escape_string($contact);
        
        $updateFields = "crew_name = '" . $crew_name . "', contact = '" . $contact . "'";
        
        if ($area_id !== null) {
            $area_id = intval($area_id);
            $updateFields .= ", area_id = " . $area_id;
        }

        $query = "UPDATE " . $this->table . " SET " . $updateFields . " WHERE crew_id = " . $id;
        
        if ($this->conn->query($query)) {
            return ['success' => true, 'message' => 'Crew member updated successfully'];
        }
        
        return ['success' => false, 'error' => $this->conn->error];
    }

    // Delete crew member
    public function delete($id) {
        $id = intval($id);
        $query = "DELETE FROM " . $this->table . " WHERE crew_id = " . $id;
        
        if ($this->conn->query($query)) {
            return ['success' => true, 'message' => 'Crew member deleted successfully'];
        }
        
        return ['success' => false, 'error' => $this->conn->error];
    }
}
?>
