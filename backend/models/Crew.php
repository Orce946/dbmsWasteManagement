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
    public function create($crew_name, $contact, $area_id, $schedule_id, $team_id) {
        if (empty($crew_name) || empty($area_id) || empty($schedule_id) || empty($team_id)) {
            return ['success' => false, 'error' => 'Required fields are missing'];
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
    public function update($id, $crew_name, $contact) {
        if (empty($crew_name)) {
            return ['success' => false, 'error' => 'Crew name is required'];
        }

        $id = intval($id);
        $crew_name = $this->conn->real_escape_string($crew_name);
        $contact = $this->conn->real_escape_string($contact);

        $query = "UPDATE " . $this->table . " SET crew_name = '" . $crew_name . "', contact = '" . $contact . "' WHERE crew_id = " . $id;
        
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
