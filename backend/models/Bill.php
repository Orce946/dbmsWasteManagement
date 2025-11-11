<?php
class Bill {
    private $conn;
    private $table = 'Bill';

    public function __construct($db) {
        $this->conn = $db;
    }

    // Get all bills
    public function getAll() {
        $query = "SELECT b.*, c.name as citizen_name FROM " . $this->table . " b 
                  LEFT JOIN Citizen c ON b.citizen_id = c.citizen_id 
                  ORDER BY b.bill_id DESC";
        $result = $this->conn->query($query);
        
        if (!$result) {
            return ['success' => false, 'error' => $this->conn->error];
        }
        
        $bills = [];
        while ($row = $result->fetch_assoc()) {
            $bills[] = $row;
        }
        return ['success' => true, 'data' => $bills];
    }

    // Get by citizen
    public function getByCitizen($citizen_id) {
        $citizen_id = intval($citizen_id);
        $query = "SELECT b.*, c.name as citizen_name FROM " . $this->table . " b 
                  LEFT JOIN Citizen c ON b.citizen_id = c.citizen_id 
                  WHERE b.citizen_id = " . $citizen_id . " 
                  ORDER BY b.bill_id DESC";
        $result = $this->conn->query($query);
        
        if (!$result) {
            return ['success' => false, 'error' => $this->conn->error];
        }
        
        $bills = [];
        while ($row = $result->fetch_assoc()) {
            $bills[] = $row;
        }
        return ['success' => true, 'data' => $bills];
    }

    // Get single bill
    public function getById($id) {
        $query = "SELECT b.*, c.name as citizen_name FROM " . $this->table . " b 
                  LEFT JOIN Citizen c ON b.citizen_id = c.citizen_id 
                  WHERE b.bill_id = " . intval($id);
        $result = $this->conn->query($query);
        
        if (!$result) {
            return ['success' => false, 'error' => $this->conn->error];
        }
        
        if ($result->num_rows == 0) {
            return ['success' => false, 'error' => 'Bill not found'];
        }
        
        return ['success' => true, 'data' => $result->fetch_assoc()];
    }

    // Create bill
    public function create($status, $amount, $due_date, $citizen_id) {
        if (empty($status) || empty($amount) || empty($due_date) || empty($citizen_id)) {
            return ['success' => false, 'error' => 'All fields are required'];
        }

        $status = $this->conn->real_escape_string($status);
        $amount = floatval($amount);
        $due_date = $this->conn->real_escape_string($due_date);
        $citizen_id = intval($citizen_id);

        $query = "INSERT INTO " . $this->table . " (status, amount, due_date, citizen_id) 
                  VALUES ('" . $status . "', " . $amount . ", '" . $due_date . "', " . $citizen_id . ")";
        
        if ($this->conn->query($query)) {
            return ['success' => true, 'message' => 'Bill created successfully', 'id' => $this->conn->insert_id];
        }
        
        return ['success' => false, 'error' => $this->conn->error];
    }

    // Update bill status
    public function updateStatus($id, $status) {
        if (empty($status)) {
            return ['success' => false, 'error' => 'Status is required'];
        }

        $id = intval($id);
        $status = $this->conn->real_escape_string($status);

        $query = "UPDATE " . $this->table . " SET status = '" . $status . "' WHERE bill_id = " . $id;
        
        if ($this->conn->query($query)) {
            return ['success' => true, 'message' => 'Bill status updated successfully'];
        }
        
        return ['success' => false, 'error' => $this->conn->error];
    }

    // Delete bill
    public function delete($id) {
        $id = intval($id);
        $query = "DELETE FROM " . $this->table . " WHERE bill_id = " . $id;
        
        if ($this->conn->query($query)) {
            return ['success' => true, 'message' => 'Bill deleted successfully'];
        }
        
        return ['success' => false, 'error' => $this->conn->error];
    }

    // Get bill statistics
    public function getStatistics() {
        $query = "SELECT 
                    COUNT(*) as total_bills,
                    SUM(amount) as total_amount,
                    COUNT(CASE WHEN status = 'Paid' THEN 1 END) as paid_count,
                    COUNT(CASE WHEN status = 'Pending' THEN 1 END) as pending_count,
                    COUNT(CASE WHEN status = 'Overdue' THEN 1 END) as overdue_count
                  FROM " . $this->table;
        
        $result = $this->conn->query($query);
        
        if (!$result) {
            return ['success' => false, 'error' => $this->conn->error];
        }
        
        return ['success' => true, 'data' => $result->fetch_assoc()];
    }
}
?>
