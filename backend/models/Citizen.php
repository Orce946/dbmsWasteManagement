<?php
class Citizen {
    private $conn;
    private $table = 'Citizen';

    public $citizen_id;
    public $name;
    public $address;
    public $contact;
    public $area_id;

    public function __construct($db) {
        $this->conn = $db;
    }

    // Get all citizens
    public function getAll() {
        $query = "SELECT c.*, a.area_name FROM " . $this->table . " c 
                  LEFT JOIN Area a ON c.area_id = a.area_id 
                  ORDER BY c.citizen_id DESC";
        $result = $this->conn->query($query);
        
        if (!$result) {
            return ['success' => false, 'error' => $this->conn->error];
        }
        
        $citizens = [];
        while ($row = $result->fetch_assoc()) {
            $citizens[] = $row;
        }
        return ['success' => true, 'data' => $citizens];
    }

    // Get by area
    public function getByArea($area_id) {
        $area_id = intval($area_id);
        $query = "SELECT c.*, a.area_name FROM " . $this->table . " c 
                  LEFT JOIN Area a ON c.area_id = a.area_id 
                  WHERE c.area_id = " . $area_id . " 
                  ORDER BY c.citizen_id DESC";
        $result = $this->conn->query($query);
        
        if (!$result) {
            return ['success' => false, 'error' => $this->conn->error];
        }
        
        $citizens = [];
        while ($row = $result->fetch_assoc()) {
            $citizens[] = $row;
        }
        return ['success' => true, 'data' => $citizens];
    }

    // Get single citizen
    public function getById($id) {
        $query = "SELECT c.*, a.area_name FROM " . $this->table . " c 
                  LEFT JOIN Area a ON c.area_id = a.area_id 
                  WHERE c.citizen_id = " . intval($id);
        $result = $this->conn->query($query);
        
        if (!$result) {
            return ['success' => false, 'error' => $this->conn->error];
        }
        
        if ($result->num_rows == 0) {
            return ['success' => false, 'error' => 'Citizen not found'];
        }
        
        return ['success' => true, 'data' => $result->fetch_assoc()];
    }

    // Create citizen
    public function create($name, $address, $contact, $area_id) {
        if (empty($name) || empty($address) || empty($area_id)) {
            return ['success' => false, 'error' => 'Name, address, and area are required'];
        }

        $name = $this->conn->real_escape_string($name);
        $address = $this->conn->real_escape_string($address);
        $contact = $this->conn->real_escape_string($contact);
        $area_id = intval($area_id);

        $query = "INSERT INTO " . $this->table . " (name, address, contact, area_id) 
                  VALUES ('" . $name . "', '" . $address . "', '" . $contact . "', " . $area_id . ")";
        
        if ($this->conn->query($query)) {
            return ['success' => true, 'message' => 'Citizen created successfully', 'id' => $this->conn->insert_id];
        }
        
        return ['success' => false, 'error' => $this->conn->error];
    }

    // Update citizen
    public function update($id, $name, $address, $contact, $area_id) {
        if (empty($name) || empty($address) || empty($area_id)) {
            return ['success' => false, 'error' => 'Name, address, and area are required'];
        }

        $id = intval($id);
        $name = $this->conn->real_escape_string($name);
        $address = $this->conn->real_escape_string($address);
        $contact = $this->conn->real_escape_string($contact);
        $area_id = intval($area_id);

        $query = "UPDATE " . $this->table . " SET name = '" . $name . "', address = '" . $address . "', 
                  contact = '" . $contact . "', area_id = " . $area_id . " WHERE citizen_id = " . $id;
        
        if ($this->conn->query($query)) {
            return ['success' => true, 'message' => 'Citizen updated successfully'];
        }
        
        return ['success' => false, 'error' => $this->conn->error];
    }

    // Delete citizen
    public function delete($id) {
        $id = intval($id);
        
        // Check if citizen has bills
        $checkQuery = "SELECT COUNT(*) as count FROM Bill WHERE citizen_id = " . $id;
        $result = $this->conn->query($checkQuery);
        $row = $result->fetch_assoc();
        
        if ($row['count'] > 0) {
            return ['success' => false, 'error' => 'Cannot delete citizen with bills. Delete bills first.'];
        }

        $query = "DELETE FROM " . $this->table . " WHERE citizen_id = " . $id;
        
        if ($this->conn->query($query)) {
            return ['success' => true, 'message' => 'Citizen deleted successfully'];
        }
        
        return ['success' => false, 'error' => $this->conn->error];
    }
}
?>
