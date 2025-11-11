<?php
class Payment {
    private $conn;
    private $table = 'Payment';

    public function __construct($db) {
        $this->conn = $db;
    }

    // Get all payments
    public function getAll() {
        $query = "SELECT p.*, b.citizen_id, c.name as citizen_name FROM " . $this->table . " p 
                  LEFT JOIN Bill b ON p.bill_id = b.bill_id 
                  LEFT JOIN Citizen c ON b.citizen_id = c.citizen_id 
                  ORDER BY p.payment_id DESC";
        $result = $this->conn->query($query);
        
        if (!$result) {
            return ['success' => false, 'error' => $this->conn->error];
        }
        
        $payments = [];
        while ($row = $result->fetch_assoc()) {
            $payments[] = $row;
        }
        return ['success' => true, 'data' => $payments];
    }

    // Get by bill
    public function getByBill($bill_id) {
        $bill_id = intval($bill_id);
        $query = "SELECT p.*, b.citizen_id, c.name as citizen_name FROM " . $this->table . " p 
                  LEFT JOIN Bill b ON p.bill_id = b.bill_id 
                  LEFT JOIN Citizen c ON b.citizen_id = c.citizen_id 
                  WHERE p.bill_id = " . $bill_id . " 
                  ORDER BY p.payment_id DESC";
        $result = $this->conn->query($query);
        
        if (!$result) {
            return ['success' => false, 'error' => $this->conn->error];
        }
        
        $payments = [];
        while ($row = $result->fetch_assoc()) {
            $payments[] = $row;
        }
        return ['success' => true, 'data' => $payments];
    }

    // Create payment
    public function create($amount, $payment_method, $bill_id) {
        if (empty($amount) || empty($payment_method) || empty($bill_id)) {
            return ['success' => false, 'error' => 'All fields are required'];
        }

        $amount = floatval($amount);
        $payment_method = $this->conn->real_escape_string($payment_method);
        $bill_id = intval($bill_id);

        $query = "INSERT INTO " . $this->table . " (amount, payment_method, bill_id) 
                  VALUES (" . $amount . ", '" . $payment_method . "', " . $bill_id . ")";
        
        if ($this->conn->query($query)) {
            // Update bill status to Paid
            $updateQuery = "UPDATE Bill SET status = 'Paid' WHERE bill_id = " . $bill_id;
            $this->conn->query($updateQuery);
            
            return ['success' => true, 'message' => 'Payment recorded successfully', 'id' => $this->conn->insert_id];
        }
        
        return ['success' => false, 'error' => $this->conn->error];
    }

    // Get payment statistics
    public function getStatistics() {
        $query = "SELECT 
                    COUNT(*) as total_payments,
                    SUM(amount) as total_received,
                    AVG(amount) as average_payment
                  FROM " . $this->table;
        
        $result = $this->conn->query($query);
        
        if (!$result) {
            return ['success' => false, 'error' => $this->conn->error];
        }
        
        return ['success' => true, 'data' => $result->fetch_assoc()];
    }
}
?>
