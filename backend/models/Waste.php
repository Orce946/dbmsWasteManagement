<?php
class Waste {
    private $conn;
    private $table = 'Waste';

    public function __construct($db) {
        $this->conn = $db;
    }

    // Get all waste records
    public function getAll() {
        $query = "SELECT w.*, c.name as citizen_name, a.area_name FROM " . $this->table . " w 
                  LEFT JOIN Citizen c ON w.citizen_id = c.citizen_id 
                  LEFT JOIN Area a ON w.area_id = a.area_id 
                  ORDER BY w.waste_id DESC";
        $result = $this->conn->query($query);
        
        if (!$result) {
            return ['success' => false, 'error' => $this->conn->error];
        }
        
        $waste = [];
        while ($row = $result->fetch_assoc()) {
            $waste[] = $row;
        }
        return ['success' => true, 'data' => $waste];
    }

    // Get by category
    public function getByCategory($category) {
        $category = $this->conn->real_escape_string($category);
        $query = "SELECT w.*, c.name as citizen_name, a.area_name FROM " . $this->table . " w 
                  LEFT JOIN Citizen c ON w.citizen_id = c.citizen_id 
                  LEFT JOIN Area a ON w.area_id = a.area_id 
                  WHERE w.category = '" . $category . "' 
                  ORDER BY w.waste_id DESC";
        $result = $this->conn->query($query);
        
        if (!$result) {
            return ['success' => false, 'error' => $this->conn->error];
        }
        
        $waste = [];
        while ($row = $result->fetch_assoc()) {
            $waste[] = $row;
        }
        return ['success' => true, 'data' => $waste];
    }

    // Create waste record
    public function create($waste_type, $quantity, $citizen_id, $area_id, $collection_date = null, $status = 'Pending') {
        if (empty($waste_type) || empty($quantity) || empty($citizen_id) || empty($area_id)) {
            return ['success' => false, 'error' => 'All fields are required'];
        }

        $waste_type = $this->conn->real_escape_string($waste_type);
        $quantity = floatval($quantity);
        $citizen_id = intval($citizen_id);
        $area_id = intval($area_id);
        $status = $this->conn->real_escape_string($status);
        $collection_date = $collection_date ? $this->conn->real_escape_string($collection_date) : date('Y-m-d');

        $query = "INSERT INTO " . $this->table . " (waste_type, quantity, citizen_id, area_id, collection_date, status, category, name) 
                  VALUES ('" . $waste_type . "', " . $quantity . ", " . $citizen_id . ", " . $area_id . ", '" . $collection_date . "', '" . $status . "', '" . $waste_type . "', 'Waste Record')";
        
        if ($this->conn->query($query)) {
            return ['success' => true, 'message' => 'Waste record created successfully', 'id' => $this->conn->insert_id];
        }
        
        return ['success' => false, 'error' => $this->conn->error];
    }

    // Update waste record
    public function update($id, $waste_type, $quantity, $citizen_id, $area_id, $collection_date = null, $status = 'Pending') {
        if (empty($waste_type) || empty($quantity) || empty($citizen_id) || empty($area_id)) {
            return ['success' => false, 'error' => 'All fields are required'];
        }

        $id = intval($id);
        $waste_type = $this->conn->real_escape_string($waste_type);
        $quantity = floatval($quantity);
        $citizen_id = intval($citizen_id);
        $area_id = intval($area_id);
        $status = $this->conn->real_escape_string($status);
        $collection_date = $collection_date ? $this->conn->real_escape_string($collection_date) : date('Y-m-d');

        $query = "UPDATE " . $this->table . " SET waste_type = '" . $waste_type . "', quantity = " . $quantity . ", citizen_id = " . $citizen_id . ", area_id = " . $area_id . ", collection_date = '" . $collection_date . "', status = '" . $status . "', category = '" . $waste_type . "' WHERE waste_id = " . $id;
        
        if ($this->conn->query($query)) {
            return ['success' => true, 'message' => 'Waste record updated successfully'];
        }
        
        return ['success' => false, 'error' => $this->conn->error];
    }

    // Delete waste record
    public function delete($id) {
        $id = intval($id);
        $query = "DELETE FROM " . $this->table . " WHERE waste_id = " . $id;
        
        if ($this->conn->query($query)) {
            return ['success' => true, 'message' => 'Waste record deleted successfully'];
        }
        
        return ['success' => false, 'error' => $this->conn->error];
    }

    // Get waste statistics
    public function getStatistics() {
        $query = "SELECT 
                    category,
                    COUNT(*) as total_items
                  FROM " . $this->table . " 
                  GROUP BY category
                  ORDER BY total_items DESC";
        
        $result = $this->conn->query($query);
        
        if (!$result) {
            return ['success' => false, 'error' => $this->conn->error];
        }
        
        $stats = [];
        while ($row = $result->fetch_assoc()) {
            $stats[] = $row;
        }
        return ['success' => true, 'data' => $stats];
    }
}
?>
