<?php
header('Content-Type: application/json; charset=utf-8');
header('Access-Control-Allow-Origin: *');
header('Access-Control-Allow-Methods: GET, POST, OPTIONS');
header('Access-Control-Allow-Headers: Content-Type');

// OPTIONS isteği için
if ($_SERVER['REQUEST_METHOD'] === 'OPTIONS') {
    http_response_code(200);
    exit();
}

require_once __DIR__ . '/../config.php';

try {
    // Veritabanı bağlantısı
    $mysqli = getDBConnection();
    if (!$mysqli) {
        throw new Exception('Veritabanı bağlantısı kurulamadı');
    }

    // planned_training_trainer tablosundan verileri çek
    $sql = "SELECT 
                ptt.id,
                ptt.person_id,
                ptt.organization_id,
                ptt.etkinlik_id,
                ptt.start_date,
                ptt.end_date,
                ptt.status,
                ptt.created_at,
                ptt.updated_at,
                ptt.success_status,
                ptt.description,
                p.name as person_name,
                p.registration_no as sicil_no,
                p.title as unvan,
                o.name as organization_name
            FROM planned_training_trainer ptt
            LEFT JOIN persons p ON ptt.person_id = p.id
            LEFT JOIN organizations o ON ptt.organization_id = o.id
            ORDER BY ptt.created_at DESC";

    $result = $mysqli->query($sql);
    if (!$result) {
        throw new Exception('Sorgu hatası: ' . $mysqli->error);
    }

    $data = [];
    while ($row = $result->fetch_assoc()) {
        $data[] = [
            'id' => $row['id'],
            'person_id' => $row['person_id'],
            'organization_id' => $row['organization_id'],
            'etkinlik_id' => $row['etkinlik_id'],
            'start_date' => $row['start_date'],
            'end_date' => $row['end_date'],
            'status' => $row['status'],
            'created_at' => $row['created_at'],
            'updated_at' => $row['updated_at'],
            'success_status' => $row['success_status'],
            'description' => $row['description'],
            'person_name' => $row['person_name'],
            'sicil_no' => $row['sicil_no'],
            'unvan' => $row['unvan'],
            'organization_name' => $row['organization_name']
        ];
    }

    $mysqli->close();

    echo json_encode([
        'success' => true,
        'data' => $data
    ], JSON_UNESCAPED_UNICODE);

} catch (Exception $e) {
    http_response_code(500);
    echo json_encode([
        'success' => false,
        'message' => $e->getMessage()
    ], JSON_UNESCAPED_UNICODE);
}
?>
