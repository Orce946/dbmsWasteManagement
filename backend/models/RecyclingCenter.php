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
    public function create($center_name, $location, $contact) {
        if (empty($center_name) || empty($location)) {
            return ['success' => false, 'error' => 'Center name and location are required'];
        }

        $center_name = $this->conn->real_escape_string($center_name);
        $location = $this->conn->real_escape_string($location);
        $contact = $this->conn->real_escape_string($contact);

        $query = "INSERT INTO " . $this->table . " (center_name, location, contact) 
                  VALUES ('" . $center_name . "', '" . $location . "', '" . $contact . "')";
        
        if ($this->conn->query($query)) {
            return ['success' => true, 'message' => 'Recycling center created successfully', 'id' => $this->conn->insert_id];
        }
        
        return ['success' => false, 'error' => $this->conn->error];
    }

    // Update recycling center
    public function update($id, $center_name, $location, $contact) {
        if (empty($center_name) || empty($location)) {
            return ['success' => false, 'error' => 'Center name and location are required'];
        }

        $id = intval($id);
        $center_name = $this->conn->real_escape_string($center_name);
        $location = $this->conn->real_escape_string($location);
        $contact = $this->conn->real_escape_string($contact);

        $query = "UPDATE " . $this->table . " SET center_name = '" . $center_name . "', location = '" . $location . "', contact = '" . $contact . "' WHERE center_id = " . $id;
        
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
