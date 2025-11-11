<?php
// Database Connection Configuration
class Database {
    private $host = 'localhost';
    private $db_name = 'wasteManagement';
    private $user = 'root';
    private $password = ''; // Change if you have a password
    private $conn;

    public function connect() {
        $this->conn = null;

        try {
            $this->conn = new mysqli($this->host, $this->user, $this->password, $this->db_name);
            
            if ($this->conn->connect_error) {
                throw new Exception('Connection Error: ' . $this->conn->connect_error);
            }
            
            $this->conn->set_charset("utf8");
            return $this->conn;
        } catch (Exception $e) {
            echo json_encode(['success' => false, 'error' => $e->getMessage()]);
            exit();
        }
    }

    public function closeConnection() {
        if ($this->conn) {
            $this->conn->close();
        }
    }
}
?>
