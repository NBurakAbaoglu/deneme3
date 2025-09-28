<?php
error_reporting(E_ALL);
ini_set('display_errors', 0);

header('Content-Type: application/json');

require_once 'config.php';

try {
    $mysqli = getDBConnection();
    if (!$mysqli) {
        throw new Exception('Veritabanı bağlantısı kurulamadı');
    }

    $query = "
        SELECT 
            o.name AS organization_name,
            COUNT(DISTINCT os.skill_id) AS skill_count
        FROM organization_skills os
        JOIN organizations o ON os.organization_id = o.id
        GROUP BY o.name
        ORDER BY o.name
    ";

    $result = $mysqli->query($query);
    if (!$result) {
        throw new Exception('Sorgu hatası: ' . $mysqli->error);
    }

    $data = [];
    while ($row = $result->fetch_assoc()) {
        $data[$row['organization_name']] = (int)$row['skill_count'];
    }

    $mysqli->close();

    echo json_encode($data);

} catch (Exception $e) {
    http_response_code(500);
    echo json_encode(['error' => 'Veritabanı hatası: ' . $e->getMessage()]);
}
