<?php
require_once __DIR__ . '/../config/cors.php';
require_once __DIR__ . '/../config/Database.php';
require_once __DIR__ . '/../models/Payment.php';

$method = $_SERVER['REQUEST_METHOD'];
$database = new Database();
$db = $database->connect();
$payment = new Payment($db);

// Parse the URL to get the ID if provided
$request = explode('/', trim($_SERVER['PATH_INFO'] ?? '', '/'));
$id = isset($request[0]) && is_numeric($request[0]) ? $request[0] : null;

// Check for query parameters
$bill_id = $_GET['bill_id'] ?? null;
$action = $request[1] ?? null;

switch ($method) {
    case 'GET':
        if ($id && $action === 'statistics') {
            $result = $payment->getStatistics();
        } else if ($bill_id) {
            $result = $payment->getByBill($bill_id);
        } else {
            if (isset($_GET['statistics'])) {
                $result = $payment->getStatistics();
            } else {
                $result = $payment->getAll();
            }
        }
        http_response_code(200);
        echo json_encode($result);
        break;

    case 'POST':
        $data = json_decode(file_get_contents("php://input"), true);
        $result = $payment->create($data['amount'] ?? '', $data['payment_method'] ?? '', $data['bill_id'] ?? '');
        http_response_code($result['success'] ? 201 : 400);
        echo json_encode($result);
        break;

    default:
        http_response_code(405);
        echo json_encode(['success' => false, 'error' => 'Method not allowed']);
}

$database->closeConnection();
?>
