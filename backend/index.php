<?php
require_once 'config/cors.php';

// Simple router
$request_uri = parse_url($_SERVER['REQUEST_URI'], PHP_URL_PATH);
$request_method = $_SERVER['REQUEST_METHOD'];

// Remove base path - handle both /codebase/backend/ and direct paths
$base_path1 = '/codebase/backend/';
$request_path = $request_uri;

if (strpos($request_uri, $base_path1) === 0) {
    $request_path = str_replace($base_path1, '', $request_uri);
} else {
    $request_path = ltrim($request_uri, '/');
}

$request_parts = array_filter(explode('/', $request_path));

// Route to appropriate file
$route = array_shift($request_parts);
$remaining_path = '/' . implode('/', $request_parts);

// Set PATH_INFO for the routes
$_SERVER['PATH_INFO'] = $remaining_path;

switch ($route) {
    case 'areas':
        require 'routes/areas.php';
        break;
    case 'citizens':
        require 'routes/citizens.php';
        break;
    case 'bills':
        require 'routes/bills.php';
        break;
    case 'payments':
        require 'routes/payments.php';
        break;
    case 'waste':
        require 'routes/waste.php';
        break;
    case 'bins':
        require 'routes/bins.php';
        break;
    case 'crew':
        require 'routes/crew.php';
        break;
    case 'schedules':
        require 'routes/schedules.php';
        break;
    case 'centers':
        require 'routes/centers.php';
        break;
    case '':
    case 'api':
        http_response_code(200);
        echo json_encode([
            'success' => true,
            'message' => 'Waste Management API',
            'version' => '1.0',
            'endpoints' => [
                '/areas' => 'Area management',
                '/citizens' => 'Citizen management',
                '/bills' => 'Bill management',
                '/payments' => 'Payment management',
                '/waste' => 'Waste tracking',
                '/bins' => 'Bin management',
                '/crew' => 'Crew management',
                '/schedules' => 'Collection schedules',
                '/centers' => 'Recycling centers'
            ]
        ]);
        break;
    default:
        http_response_code(404);
        echo json_encode(['success' => false, 'error' => 'Endpoint not found']);
}
?>
