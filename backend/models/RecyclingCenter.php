<?php
class RecyclingCenter {
    private $conn;
    private $table = 'Recycling_Center';

    public function __construct($db) {
        $this->conn = $db;
    }

    // Get all recycling centers
    public function getAll() {
        $query = "SELECT * FROM " . $this->table . " ORDER BY center_id DESC";
        $result = $this->conn->query($query);
        
        if (!$result) {
            return ['success' => false, 'error' => $this->conn->error];
        }
        
        $centers = [];
        while ($row = $result->fetch_assoc()) {
            $centers[] = $row;
        }
        return ['success' => true, 'data' => $centers];
    }

    // Create recycling center
    public function create($location, $capacity, $operating_hours, $waste_id = null) {
        if (empty($location) || empty($capacity)) {
            return ['success' => false, 'error' => 'Location and capacity are required'];
        }

        $location = $this->conn->real_escape_string($location);
        $capacity = intval($capacity);
        $operating_hours = $this->conn->real_escape_string($operating_hours);
        $waste_id = !empty($waste_id) ? intval($waste_id) : 'NULL';

        $query = "INSERT INTO " . $this->table . " (location, capacity, operating_hours, waste_id) 
                  VALUES ('" . $location . "', " . $capacity . ", '" . $operating_hours . "', " . $waste_id . ")";
        
        if ($this->conn->query($query)) {
            return ['success' => true, 'message' => 'Recycling center created successfully', 'id' => $this->conn->insert_id];
        }
        
        return ['success' => false, 'error' => $this->conn->error];
    }

    // Update recycling center
    public function update($id, $location, $capacity, $operating_hours, $waste_id = null) {
        if (empty($location) || empty($capacity)) {
            return ['success' => false, 'error' => 'Location and capacity are required'];
        }

        $id = intval($id);
        $location = $this->conn->real_escape_string($location);
        $capacity = intval($capacity);
        $operating_hours = $this->conn->real_escape_string($operating_hours);
        $waste_id = !empty($waste_id) ? intval($waste_id) : 'NULL';

        $query = "UPDATE " . $this->table . " SET location = '" . $location . "', capacity = " . $capacity . ", operating_hours = '" . $operating_hours . "', waste_id = " . $waste_id . " WHERE center_id = " . $id;
        
        if ($this->conn->query($query)) {
            return ['success' => true, 'message' => 'Recycling center updated successfully'];
        }
        
        return ['success' => false, 'error' => $this->conn->error];
    }

    // Delete recycling center
    public function delete($id) {
        $id = intval($id);
        $query = "DELETE FROM " . $this->table . " WHERE center_id = " . $id;
        
        if ($this->conn->query($query)) {
            return ['success' => true, 'message' => 'Recycling center deleted successfully'];
        }
        
        return ['success' => false, 'error' => $this->conn->error];
    }
}
?>
