<?php
class Area {
    private $conn;
    private $table = 'Area';

    public $area_id;
    public $area_name;
    public $description;
    public $created_at;

    public function __construct($db) {
        $this->conn = $db;
    }

    // Get all areas
    public function getAll() {
        $query = "SELECT * FROM " . $this->table . " ORDER BY area_id DESC";
        $result = $this->conn->query($query);
        
        if (!$result) {
            return ['success' => false, 'error' => $this->conn->error];
        }
        
        $areas = [];
        while ($row = $result->fetch_assoc()) {
            $areas[] = $row;
        }
        return ['success' => true, 'data' => $areas];
    }

    // Get single area
    public function getById($id) {
        $query = "SELECT * FROM " . $this->table . " WHERE area_id = " . intval($id);
        $result = $this->conn->query($query);
        
        if (!$result) {
            return ['success' => false, 'error' => $this->conn->error];
        }
        
        if ($result->num_rows == 0) {
            return ['success' => false, 'error' => 'Area not found'];
        }
        
        return ['success' => true, 'data' => $result->fetch_assoc()];
    }

    // Create area
    public function create($area_name, $description) {
        if (empty($area_name)) {
            return ['success' => false, 'error' => 'Area name is required'];
        }

        $area_name = $this->conn->real_escape_string($area_name);
        $description = $this->conn->real_escape_string($description);

        $query = "INSERT INTO " . $this->table . " (area_name, description) VALUES ('" . $area_name . "', '" . $description . "')";
        
        if ($this->conn->query($query)) {
            return ['success' => true, 'message' => 'Area created successfully', 'id' => $this->conn->insert_id];
        }
        
        return ['success' => false, 'error' => $this->conn->error];
    }

    // Update area
    public function update($id, $area_name, $description) {
        if (empty($area_name)) {
            return ['success' => false, 'error' => 'Area name is required'];
        }

        $id = intval($id);
        $area_name = $this->conn->real_escape_string($area_name);
        $description = $this->conn->real_escape_string($description);

        $query = "UPDATE " . $this->table . " SET area_name = '" . $area_name . "', description = '" . $description . "' WHERE area_id = " . $id;
        
        if ($this->conn->query($query)) {
            return ['success' => true, 'message' => 'Area updated successfully'];
        }
        
        return ['success' => false, 'error' => $this->conn->error];
    }

    // Delete area
    public function delete($id) {
        $id = intval($id);
        
        // Check if area has citizens
        $checkQuery = "SELECT COUNT(*) as count FROM Citizen WHERE area_id = " . $id;
        $result = $this->conn->query($checkQuery);
        $row = $result->fetch_assoc();
        
        if ($row['count'] > 0) {
            return ['success' => false, 'error' => 'Cannot delete area with citizens. Delete citizens first.'];
        }

        $query = "DELETE FROM " . $this->table . " WHERE area_id = " . $id;
        
        if ($this->conn->query($query)) {
            return ['success' => true, 'message' => 'Area deleted successfully'];
        }
        
        return ['success' => false, 'error' => $this->conn->error];
    }
}
?>
