<?php
header('Content-Type: application/json; charset=utf-8');
header('Access-Control-Allow-Origin: *');
header('Access-Control-Allow-Methods: POST, GET, OPTIONS');
header('Access-Control-Allow-Headers: Content-Type');

// OPTIONS isteği için
if ($_SERVER['REQUEST_METHOD'] === 'OPTIONS') {
    http_response_code(200);
    exit();
}

require_once '../config.php';

try {
    // Sadece POST isteklerini kabul et
    if ($_SERVER['REQUEST_METHOD'] !== 'POST') {
        throw new Exception('Sadece POST istekleri kabul edilir');
    }

    // JSON verisini al
    $input = file_get_contents('php://input');
    $data = json_decode($input, true);

    if (!$data) {
        throw new Exception('Geçersiz JSON verisi');
    }

    // Gerekli alanları kontrol et
    $required_fields = ['person_id', 'organization_id', 'etkinlik_id', 'start_date', 'end_date'];
    foreach ($required_fields as $field) {
        if (!isset($data[$field]) || empty($data[$field])) {
            throw new Exception("Gerekli alan eksik: $field");
        }
    }

    // Veritabanı bağlantısı
    $mysqli = getDBConnection();
    if (!$mysqli) {
        throw new Exception('Veritabanı bağlantısı kurulamadı');
    }

    // Verileri temizle ve doğrula
    $person_id = intval($data['person_id']);
    $organization_id = intval($data['organization_id']);
    $etkinlik_id = intval($data['etkinlik_id']);
    $start_date = $data['start_date'];
    $end_date = $data['end_date'];
    $status = isset($data['status']) ? $data['status'] : 'planlandi';
    $description = isset($data['description']) ? trim($data['description']) : '';
    $success_status = 'beklemede';

    // Tarih formatını doğrula
    if (!preg_match('/^\d{4}-\d{2}-\d{2}$/', $start_date) || !preg_match('/^\d{4}-\d{2}-\d{2}$/', $end_date)) {
        throw new Exception('Geçersiz tarih formatı');
    }

    // Başlangıç tarihi bitiş tarihinden önce olmalı
    if (strtotime($start_date) >= strtotime($end_date)) {
        throw new Exception('Başlangıç tarihi bitiş tarihinden önce olmalıdır');
    }

    // Veritabanına kaydet
    $sql = "INSERT INTO planned_training_trainer 
            (person_id, organization_id, etkinlik_id, start_date, end_date, status, description, success_status) 
            VALUES (?, ?, ?, ?, ?, ?, ?, ?)";

    $stmt = $mysqli->prepare($sql);
    if (!$stmt) {
        throw new Exception('SQL hazırlama hatası: ' . $mysqli->error);
    }

    $stmt->bind_param('iiisssss', 
        $person_id, 
        $organization_id, 
        $etkinlik_id, 
        $start_date, 
        $end_date, 
        $status, 
        $description, 
        $success_status
    );

    if (!$stmt->execute()) {
        throw new Exception('Veri kaydetme hatası: ' . $stmt->error);
    }

    $inserted_id = $mysqli->insert_id;
    $stmt->close();
    $mysqli->close();

    // Başarılı yanıt
    echo json_encode([
        'success' => true,
        'message' => 'Eğiticinin eğitimi isteği başarıyla kaydedildi',
        'data' => [
            'id' => $inserted_id,
            'person_id' => $person_id,
            'organization_id' => $organization_id,
            'etkinlik_id' => $etkinlik_id,
            'start_date' => $start_date,
            'end_date' => $end_date,
            'status' => $status,
            'success_status' => $success_status
        ]
    ], JSON_UNESCAPED_UNICODE);

} catch (Exception $e) {
    // Hata yanıtı
    http_response_code(400);
    echo json_encode([
        'success' => false,
        'message' => $e->getMessage()
    ], JSON_UNESCAPED_UNICODE);
}
?>
