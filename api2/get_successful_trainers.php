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

    // successful_trainers tablosundan verileri çek
    $sql = "SELECT 
                st.id,
                st.person_id,
                st.organization_id,
                st.etkinlik_id,
                st.start_date,
                st.end_date,
                st.success_date,
                st.created_at,
                st.updated_at,
                p.name as person_name,
                p.registration_no as sicil_no,
                p.title as unvan,
                o.name as organization_name,
                eee.egitmen_adi,
                eee.gozetmen_adi,
                eee.baslangic_tarihi,
                eee.bitis_tarihi
            FROM successful_trainers st
            LEFT JOIN persons p ON st.person_id = p.id
            LEFT JOIN organizations o ON st.organization_id = o.id
            LEFT JOIN egiticinin_egitimi_etkinlikleri eee ON st.etkinlik_id = eee.id
            ORDER BY st.success_date DESC";

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
            'success_date' => $row['success_date'],
            'created_at' => $row['created_at'],
            'updated_at' => $row['updated_at'],
            'person_name' => $row['person_name'],
            'sicil_no' => $row['sicil_no'],
            'unvan' => $row['unvan'],
            'organization_name' => $row['organization_name'],
            'egitmen_adi' => $row['egitmen_adi'],
            'gozetmen_adi' => $row['gozetmen_adi'],
            'baslangic_tarihi' => $row['baslangic_tarihi'],
            'bitis_tarihi' => $row['bitis_tarihi'],
            'display_text' => $row['person_name']
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
