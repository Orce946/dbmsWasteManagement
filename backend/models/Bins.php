<?php
class Bins {
    private $conn;
    private $table = 'Bins';

    public function __construct($db) {
        $this->conn = $db;
    }

    // Get all bins
    public function getAll() {
        $query = "SELECT b.*, a.area_name FROM " . $this->table . " b 
                  LEFT JOIN Area a ON b.area_id = a.area_id 
                  ORDER BY b.bin_id DESC";
        $result = $this->conn->query($query);
        
        if (!$result) {
            return ['success' => false, 'error' => $this->conn->error];
        }
        
        $bins = [];
        while ($row = $result->fetch_assoc()) {
            $bins[] = $row;
        }
        return ['success' => true, 'data' => $bins];
    }

    // Get by area
    public function getByArea($area_id) {
        $area_id = intval($area_id);
        $query = "SELECT b.*, a.area_name FROM " . $this->table . " b 
                  LEFT JOIN Area a ON b.area_id = a.area_id 
                  WHERE b.area_id = " . $area_id . " 
                  ORDER BY b.bin_id DESC";
        $result = $this->conn->query($query);
        
        if (!$result) {
            return ['success' => false, 'error' => $this->conn->error];
        }
        
        $bins = [];
        while ($row = $result->fetch_assoc()) {
            $bins[] = $row;
        }
        return ['success' => true, 'data' => $bins];
    }

    // Create bin
    public function create($bin_type, $capacity, $fill_level, $area_id) {
        if (empty($bin_type) || empty($capacity) || empty($area_id)) {
            return ['success' => false, 'error' => 'Required fields are missing'];
        }

        $bin_type = $this->conn->real_escape_string($bin_type);
        $capacity = floatval($capacity);
        $fill_level = floatval($fill_level);
        $area_id = intval($area_id);

        $query = "INSERT INTO " . $this->table . " (bin_type, capacity, fill_level, area_id) 
                  VALUES ('" . $bin_type . "', " . $capacity . ", " . $fill_level . ", " . $area_id . ")";
        
        if ($this->conn->query($query)) {
            return ['success' => true, 'message' => 'Bin created successfully', 'id' => $this->conn->insert_id];
        }
        
        return ['success' => false, 'error' => $this->conn->error];
    }

    // Update bin fill level
    public function updateFillLevel($id, $fill_level) {
        if (empty($fill_level)) {
            return ['success' => false, 'error' => 'Fill level is required'];
        }

        $id = intval($id);
        $fill_level = floatval($fill_level);

        $query = "UPDATE " . $this->table . " SET fill_level = " . $fill_level . " WHERE bin_id = " . $id;
        
        if ($this->conn->query($query)) {
            return ['success' => true, 'message' => 'Bin fill level updated successfully'];
        }
        
        return ['success' => false, 'error' => $this->conn->error];
    }

    // Delete bin
    public function delete($id) {
        $id = intval($id);
        $query = "DELETE FROM " . $this->table . " WHERE bin_id = " . $id;
        
        if ($this->conn->query($query)) {
            return ['success' => true, 'message' => 'Bin deleted successfully'];
        }
        
        return ['success' => false, 'error' => $this->conn->error];
    }
}
?>
