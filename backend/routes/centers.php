<?php
require_once __DIR__ . '/../config/cors.php';
require_once __DIR__ . '/../config/Database.php';
require_once __DIR__ . '/../models/RecyclingCenter.php';

$method = $_SERVER['REQUEST_METHOD'];
$database = new Database();
$db = $database->connect();
$center = new RecyclingCenter($db);

// Parse the URL to get the ID if provided
$request = explode('/', trim($_SERVER['PATH_INFO'] ?? '', '/'));
$id = isset($request[0]) && is_numeric($request[0]) ? $request[0] : null;

switch ($method) {
    case 'GET':
        $result = $center->getAll();
        http_response_code(200);
        echo json_encode($result);
        break;

    case 'POST':
        $data = json_decode(file_get_contents("php://input"), true);
        $result = $center->create(
            $data['location'] ?? '',
            $data['capacity'] ?? '',
            $data['operating_hours'] ?? '',
            $data['waste_id'] ?? null
        );
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
        $result = $center->update(
            $id,
            $data['location'] ?? '',
            $data['capacity'] ?? '',
            $data['operating_hours'] ?? '',
            $data['waste_id'] ?? null
        );
        http_response_code($result['success'] ? 200 : 400);
        echo json_encode($result);
        break;

    case 'DELETE':
        if (!$id) {
            http_response_code(400);
            echo json_encode(['success' => false, 'error' => 'ID is required']);
            break;
        }
        $result = $center->delete($id);
        http_response_code($result['success'] ? 200 : 400);
        echo json_encode($result);
        break;

    default:
        http_response_code(405);
        echo json_encode(['success' => false, 'error' => 'Method not allowed']);
}

$database->closeConnection();
?>
