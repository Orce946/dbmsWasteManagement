<?php
require_once __DIR__ . '/../config/cors.php';
require_once __DIR__ . '/../config/Database.php';
require_once __DIR__ . '/../models/Bins.php';

$method = $_SERVER['REQUEST_METHOD'];
$database = new Database();
$db = $database->connect();
$bins = new Bins($db);

// Parse the URL to get the ID if provided
$request = explode('/', trim($_SERVER['PATH_INFO'] ?? '', '/'));
$id = isset($request[0]) && is_numeric($request[0]) ? $request[0] : null;

// Check for query parameters
$area_id = $_GET['area_id'] ?? null;

switch ($method) {
    case 'GET':
        if ($id) {
            // For single bin, we'd need to add this method to model
            $result = $bins->getAll(); // Simplified for now
        } elseif ($area_id) {
            $result = $bins->getByArea($area_id);
        } else {
            $result = $bins->getAll();
        }
        http_response_code(200);
        echo json_encode($result);
        break;

    case 'POST':
        $data = json_decode(file_get_contents("php://input"), true);
        $result = $bins->create($data['status'] ?? 'Active', $data['area_id'] ?? '', $data['fill_level'] ?? 0, $data['sensor'] ?? null);
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
        
        // Check if it's a full update (status, area_id) or just fill_level
        if (isset($data['status'])) {
            // Full update
            $result = $bins->update($id, $data['status'] ?? 'Active', $data['area_id'] ?? '', $data['fill_level'] ?? null, $data['sensor'] ?? null);
        } else {
            // Just fill level update
            $result = $bins->updateFillLevel($id, $data['fill_level'] ?? '');
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
        $result = $bins->delete($id);
        http_response_code($result['success'] ? 200 : 400);
        echo json_encode($result);
        break;

    default:
        http_response_code(405);
        echo json_encode(['success' => false, 'error' => 'Method not allowed']);
}

$database->closeConnection();
?>
