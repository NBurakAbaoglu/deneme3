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

    // organization_name parametresini al
    $organization_name = $_GET['organization_name'] ?? null;

    if (!$organization_name) {
        throw new Exception('organization_name parametresi gerekli');
    }

    // tep_teachers tablosundan belirli organization_name için eğitmenleri çek
    $sql = "SELECT 
                tt.id,
                tt.person_name,
                tt.organization_name,
                tt.skill_name,
                tt.created_at,
                tt.updated_at
            FROM tep_teachers tt
            WHERE tt.organization_name = ?
            ORDER BY tt.person_name";

    $stmt = $mysqli->prepare($sql);
    if (!$stmt) {
        throw new Exception('SQL hazırlama hatası: ' . $mysqli->error);
    }

    $stmt->bind_param('s', $organization_name);
    $stmt->execute();
    $result = $stmt->get_result();

    if (!$result) {
        throw new Exception('Sorgu hatası: ' . $stmt->error);
    }

    $data = [];
    while ($row = $result->fetch_assoc()) {
        $data[] = [
            'id' => $row['id'],
            'person_name' => $row['person_name'],
            'organization_name' => $row['organization_name'],
            'skill_name' => $row['skill_name'],
            'created_at' => $row['created_at'],
            'updated_at' => $row['updated_at'],
            'display_text' => $row['person_name']
        ];
    }

    $stmt->close();
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
