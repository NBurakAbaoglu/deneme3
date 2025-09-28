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

require_once __DIR__ . '/../config.php';

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
    if (!isset($data['id']) || !isset($data['success_status'])) {
        throw new Exception('Gerekli alanlar eksik: id ve success_status');
    }

    $id = intval($data['id']);
    $success_status = trim($data['success_status']);

    // Geçerli durumları kontrol et
    $valid_statuses = ['başarılı', 'başarısız', ''];
    if (!in_array($success_status, $valid_statuses)) {
        throw new Exception('Geçersiz başarı durumu');
    }

    // Veritabanı bağlantısı
    $mysqli = getDBConnection();
    if (!$mysqli) {
        throw new Exception('Veritabanı bağlantısı kurulamadı');
    }

    // Başarı durumunu güncelle
    $sql = "UPDATE planned_training_trainer SET success_status = ?, updated_at = NOW() WHERE id = ?";
    $stmt = $mysqli->prepare($sql);
    
    if (!$stmt) {
        throw new Exception('SQL hazırlama hatası: ' . $mysqli->error);
    }

    $stmt->bind_param('si', $success_status, $id);

    if (!$stmt->execute()) {
        throw new Exception('Güncelleme hatası: ' . $stmt->error);
    }

    $affected_rows = $mysqli->affected_rows;
    $stmt->close();
    $mysqli->close();

    if ($affected_rows === 0) {
        throw new Exception('Güncellenecek kayıt bulunamadı');
    }

    // Başarılı yanıt
    echo json_encode([
        'success' => true,
        'message' => 'Başarı durumu başarıyla güncellendi',
        'affected_rows' => $affected_rows
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
