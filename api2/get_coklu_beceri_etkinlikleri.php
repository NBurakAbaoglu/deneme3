<?php
require_once __DIR__ . '/../config.php';

header('Content-Type: application/json');

try {
    $mysqli = getDBConnection();
    if (!$mysqli) {
        throw new Exception("Veritabanı bağlantısı kurulamadı.");
    }

    $sql = "SELECT 
                cbe.*,
                o.name as organizasyon_adi
            FROM coklu_beceri_etkinlikleri cbe
            LEFT JOIN organizations o ON cbe.coklu_beceri_id = o.id
            WHERE cbe.durum = 'aktif'
            ORDER BY cbe.baslangic_tarihi ASC";
    
    $result = executeQuery($mysqli, $sql);
    
    if (!$result) {
        throw new Exception("Sorgu hatası: " . $mysqli->error);
    }
    
    $etkinlikler = [];
    while ($row = $result->fetch_assoc()) {
        $etkinlikler[] = $row;
    }
    
    echo json_encode([
        'success' => true,
        'etkinlikler' => $etkinlikler,
        'count' => count($etkinlikler)
    ]);
    
    closeDBConnection($mysqli);
    
} catch (Exception $e) {
    echo json_encode([
        'success' => false,
        'message' => $e->getMessage()
    ]);
}
?>
