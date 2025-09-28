<?php
require_once __DIR__ . '/../config.php';

header('Content-Type: application/json');

try {
    // POST verilerini al
    $coklu_beceri_id = $_POST['coklu_beceri_id'] ?? '';
    $egitmen_adi = $_POST['egitmen_adi'] ?? '';
    $baslangic_tarihi = $_POST['baslangic_tarihi'] ?? '';
    $bitis_tarihi = $_POST['bitis_tarihi'] ?? '';

    // Validasyon
    if (empty($coklu_beceri_id) || empty($egitmen_adi) || 
        empty($baslangic_tarihi) || empty($bitis_tarihi)) {
        throw new Exception("Tüm alanlar doldurulmalıdır.");
    }

    // Tarih validasyonu
    $baslangic = new DateTime($baslangic_tarihi);
    $bitis = new DateTime($bitis_tarihi);
    
    if ($baslangic > $bitis) {
        throw new Exception("Başlangıç tarihi, bitiş tarihinden sonra olamaz!");
    }
    
    if ($baslangic->format('Y-m-d') === $bitis->format('Y-m-d')) {
        throw new Exception("Başlangıç ve bitiş tarihleri aynı olamaz!");
    }

    // Veritabanı bağlantısı
    $mysqli = getDBConnection();
    if (!$mysqli) {
        throw new Exception("Veritabanı bağlantısı kurulamadı.");
    }

    // Veriyi kaydet
    $sql = "INSERT INTO coklu_beceri_etkinlikleri 
            (coklu_beceri_id, egitmen_adi, baslangic_tarihi, bitis_tarihi) 
            VALUES (?, ?, ?, ?)";
    
    $stmt = $mysqli->prepare($sql);
    if (!$stmt) {
        throw new Exception("SQL hazırlama hatası: " . $mysqli->error);
    }
    
    $stmt->bind_param("isss", $coklu_beceri_id, $egitmen_adi, $baslangic_tarihi, $bitis_tarihi);
    
    if ($stmt->execute()) {
        echo json_encode([
            'success' => true,
            'message' => 'Çoklu beceri etkinliği başarıyla oluşturuldu!',
            'id' => $mysqli->insert_id
        ]);
    } else {
        throw new Exception("Veri kaydetme hatası: " . $stmt->error);
    }
    
    $stmt->close();
    closeDBConnection($mysqli);

} catch (Exception $e) {
    echo json_encode([
        'success' => false,
        'message' => $e->getMessage()
    ]);
}
?>
