<?php
require_once __DIR__ . '/../config/cors.php';
require_once __DIR__ . '/../config/Database.php';
require_once __DIR__ . '/../models/Waste.php';

$method = $_SERVER['REQUEST_METHOD'];
$database = new Database();
$db = $database->connect();
$waste = new Waste($db);

// Parse the URL to get the ID if provided
$request = explode('/', trim($_SERVER['PATH_INFO'] ?? '', '/'));
$id = isset($request[0]) && is_numeric($request[0]) ? $request[0] : null;

// Check for query parameters
$category = $_GET['category'] ?? null;
$action = $request[1] ?? null;

switch ($method) {
    case 'GET':
        if ($id && $action === 'statistics') {
            $result = $waste->getStatistics();
        } elseif ($category) {
            $result = $waste->getByCategory($category);
        } else {
            if (isset($_GET['statistics'])) {
                $result = $waste->getStatistics();
            } else {
                $result = $waste->getAll();
            }
        }
        http_response_code(200);
        echo json_encode($result);
        break;

    case 'POST':
        $data = json_decode(file_get_contents("php://input"), true);
        $result = $waste->create($data['waste_type'] ?? '', $data['quantity'] ?? '', $data['citizen_id'] ?? '', $data['area_id'] ?? '', $data['collection_date'] ?? null, $data['status'] ?? 'Pending');
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
        $result = $waste->update($id, $data['waste_type'] ?? '', $data['quantity'] ?? '', $data['citizen_id'] ?? '', $data['area_id'] ?? '', $data['collection_date'] ?? null, $data['status'] ?? 'Pending');
        http_response_code($result['success'] ? 200 : 400);
        echo json_encode($result);
        break;

    case 'DELETE':
        if (!$id) {
            http_response_code(400);
            echo json_encode(['success' => false, 'error' => 'ID is required']);
            break;
        }
        $result = $waste->delete($id);
        http_response_code($result['success'] ? 200 : 400);
        echo json_encode($result);
        break;

    default:
        http_response_code(405);
        echo json_encode(['success' => false, 'error' => 'Method not allowed']);
}

$database->closeConnection();
?>
