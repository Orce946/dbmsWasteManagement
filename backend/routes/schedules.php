<?php
require_once __DIR__ . '/../config/cors.php';
require_once __DIR__ . '/../config/Database.php';
require_once __DIR__ . '/../models/CollectionSchedule.php';

$method = $_SERVER['REQUEST_METHOD'];
$database = new Database();
$db = $database->connect();
$schedule = new CollectionSchedule($db);

// Parse the URL to get the ID if provided
$request = explode('/', trim($_SERVER['PATH_INFO'] ?? '', '/'));
$id = isset($request[0]) && is_numeric($request[0]) ? $request[0] : null;

// Check for query parameters
$area_id = $_GET['area_id'] ?? null;

switch ($method) {
    case 'GET':
        if ($area_id) {
            $result = $schedule->getByArea($area_id);
        } else {
            $result = $schedule->getAll();
        }
        http_response_code(200);
        echo json_encode($result);
        break;

    case 'POST':
        $data = json_decode(file_get_contents("php://input"), true);
        $result = $schedule->create($data['schedule_date'] ?? '', $data['area_id'] ?? '');
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
        $result = $schedule->update($id, $data['schedule_date'] ?? '', $data['area_id'] ?? '');
        http_response_code($result['success'] ? 200 : 400);
        echo json_encode($result);
        break;

    case 'DELETE':
        if (!$id) {
            http_response_code(400);
            echo json_encode(['success' => false, 'error' => 'ID is required']);
            break;
        }
        $result = $schedule->delete($id);
        http_response_code($result['success'] ? 200 : 400);
        echo json_encode($result);
        break;

    default:
        http_response_code(405);
        echo json_encode(['success' => false, 'error' => 'Method not allowed']);
}

$database->closeConnection();
?>
