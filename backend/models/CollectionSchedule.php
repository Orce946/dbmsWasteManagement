<?php
class CollectionSchedule {
    private $conn;
    private $table = 'Collection_Schedule';

    public function __construct($db) {
        $this->conn = $db;
    }

    // Get all schedules
    public function getAll() {
        $query = "SELECT cs.*, a.area_name FROM " . $this->table . " cs 
                  LEFT JOIN Area a ON cs.area_id = a.area_id 
                  ORDER BY cs.schedule_date DESC";
        $result = $this->conn->query($query);
        
        if (!$result) {
            return ['success' => false, 'error' => $this->conn->error];
        }
        
        $schedules = [];
        while ($row = $result->fetch_assoc()) {
            $schedules[] = $row;
        }
        return ['success' => true, 'data' => $schedules];
    }

    // Get by area
    public function getByArea($area_id) {
        $area_id = intval($area_id);
        $query = "SELECT cs.*, a.area_name FROM " . $this->table . " cs 
                  LEFT JOIN Area a ON cs.area_id = a.area_id 
                  WHERE cs.area_id = " . $area_id . " 
                  ORDER BY cs.schedule_date DESC";
        $result = $this->conn->query($query);
        
        if (!$result) {
            return ['success' => false, 'error' => $this->conn->error];
        }
        
        $schedules = [];
        while ($row = $result->fetch_assoc()) {
            $schedules[] = $row;
        }
        return ['success' => true, 'data' => $schedules];
    }

    // Create schedule
    public function create($schedule_date, $area_id) {
        if (empty($schedule_date) || empty($area_id)) {
            return ['success' => false, 'error' => 'Schedule date and area are required'];
        }

        $schedule_date = $this->conn->real_escape_string($schedule_date);
        $area_id = intval($area_id);

        $query = "INSERT INTO " . $this->table . " (schedule_date, area_id) 
                  VALUES ('" . $schedule_date . "', " . $area_id . ")";
        
        if ($this->conn->query($query)) {
            return ['success' => true, 'message' => 'Schedule created successfully', 'id' => $this->conn->insert_id];
        }
        
        return ['success' => false, 'error' => $this->conn->error];
    }

    // Update schedule
    public function update($id, $schedule_date, $area_id) {
        if (empty($schedule_date) || empty($area_id)) {
            return ['success' => false, 'error' => 'Schedule date and area are required'];
        }

        $id = intval($id);
        $schedule_date = $this->conn->real_escape_string($schedule_date);
        $area_id = intval($area_id);

        $query = "UPDATE " . $this->table . " SET schedule_date = '" . $schedule_date . "', area_id = " . $area_id . " WHERE schedule_id = " . $id;
        
        if ($this->conn->query($query)) {
            return ['success' => true, 'message' => 'Schedule updated successfully'];
        }
        
        return ['success' => false, 'error' => $this->conn->error];
    }

    // Delete schedule
    public function delete($id) {
        $id = intval($id);
        $query = "DELETE FROM " . $this->table . " WHERE schedule_id = " . $id;
        
        if ($this->conn->query($query)) {
            return ['success' => true, 'message' => 'Schedule deleted successfully'];
        }
        
        return ['success' => false, 'error' => $this->conn->error];
    }
}
?>
