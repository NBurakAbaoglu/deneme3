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

    // egiticinin_egitimi_etkinlikleri tablosundan verileri çek
    $sql = "SELECT 
                id,
                coklu_beceri_id,
                egitmen_adi,
                gozetmen_adi,
                baslangic_tarihi,
                bitis_tarihi,
                kontenjan,
                olusturulma_tarihi,
                durum
            FROM egiticinin_egitimi_etkinlikleri
            ORDER BY olusturulma_tarihi DESC";

    $result = $mysqli->query($sql);
    if (!$result) {
        throw new Exception('Sorgu hatası: ' . $mysqli->error);
    }

    $data = [];
    while ($row = $result->fetch_assoc()) {
        $data[] = [
            'id' => $row['id'],
            'coklu_beceri_id' => $row['coklu_beceri_id'],
            'egitmen_adi' => $row['egitmen_adi'],
            'gozetmen_adi' => $row['gozetmen_adi'],
            'baslangic_tarihi' => $row['baslangic_tarihi'],
            'bitis_tarihi' => $row['bitis_tarihi'],
            'kontenjan' => $row['kontenjan'],
            'olusturulma_tarihi' => $row['olusturulma_tarihi'],
            'durum' => $row['durum'],
            'display_text' => $row['egitmen_adi'] . ' (' . $row['baslangic_tarihi'] . '-' . $row['bitis_tarihi'] . ')'
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