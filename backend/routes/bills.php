<?php
require_once __DIR__ . '/../config/cors.php';
require_once __DIR__ . '/../config/Database.php';
require_once __DIR__ . '/../models/Bill.php';

$method = $_SERVER['REQUEST_METHOD'];
$database = new Database();
$db = $database->connect();
$bill = new Bill($db);

// Parse the URL to get the ID if provided
$request = explode('/', trim($_SERVER['PATH_INFO'] ?? '', '/'));
$id = isset($request[0]) && is_numeric($request[0]) ? $request[0] : null;

// Check for query parameters
$citizen_id = $_GET['citizen_id'] ?? null;
$action = $request[1] ?? null;

switch ($method) {
    case 'GET':
        if ($id && $action === 'statistics') {
            $result = $bill->getStatistics();
        } elseif ($id) {
            $result = $bill->getById($id);
        } elseif ($citizen_id) {
            $result = $bill->getByCitizen($citizen_id);
        } else {
            if (isset($_GET['statistics'])) {
                $result = $bill->getStatistics();
            } else {
                $result = $bill->getAll();
            }
        }
        http_response_code(200);
        echo json_encode($result);
        break;

    case 'POST':
        $data = json_decode(file_get_contents("php://input"), true);
        $result = $bill->create($data['status'] ?? '', $data['amount'] ?? '', $data['due_date'] ?? '', $data['citizen_id'] ?? '');
        http_response_code($result['success'] ? 201 : 400);
        echo json_encode($result);
        break;

    case 'PUT':
        if (!$id) {
            http_response_code(400);
            echo json_encode(['success' => false, 'error' => 'ID is required']);
            break;
        }
        $data = json_decode(file_get_contents("php://input"), true);
        // If action is set, use it for specific updates
        if ($action === 'status') {
            $result = $bill->updateStatus($id, $data['status'] ?? '');
        } else {
            $result = $bill->updateStatus($id, $data['status'] ?? '');
        }
        http_response_code($result['success'] ? 200 : 400);
        echo json_encode($result);
        break;

    case 'DELETE':
        if (!$id) {
            http_response_code(400);
            echo json_encode(['success' => false, 'error' => 'ID is required']);
            break;
        }
        $result = $bill->delete($id);
        http_response_code($result['success'] ? 200 : 400);
        echo json_encode($result);
        break;

    default:
        http_response_code(405);
        echo json_encode(['success' => false, 'error' => 'Method not allowed']);
}

$database->closeConnection();
?>
