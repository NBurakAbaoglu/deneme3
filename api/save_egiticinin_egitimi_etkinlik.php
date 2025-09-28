<?php
require_once __DIR__ . '/../config.php';

header('Content-Type: application/json');

try {
    // POST verilerini al
    $coklu_beceri_id = $_POST['coklu_beceri_id'] ?? '';
    $egitmen_adi = $_POST['egitmen_adi'] ?? '';
    $gozetmen_adi = $_POST['gozetmen_adi'] ?? '';
    $baslangic_tarihi = $_POST['baslangic_tarihi'] ?? '';
    $bitis_tarihi = $_POST['bitis_tarihi'] ?? '';
    $kontenjan = $_POST['kontenjan'] ?? '';

    // Validasyon
    if (empty($coklu_beceri_id) || empty($egitmen_adi) || 
        empty($baslangic_tarihi) || empty($bitis_tarihi) || empty($kontenjan)) {
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
    $sql = "INSERT INTO egiticinin_egitimi_etkinlikleri 
            (coklu_beceri_id, egitmen_adi, gozetmen_adi, baslangic_tarihi, bitis_tarihi, kontenjan) 
            VALUES (?, ?, ?, ?, ?, ?)";
    
    $stmt = $mysqli->prepare($sql);
    if (!$stmt) {
        throw new Exception("SQL hazırlama hatası: " . $mysqli->error);
    }
    
    $stmt->bind_param("issssi", $coklu_beceri_id, $egitmen_adi, $gozetmen_adi, $baslangic_tarihi, $bitis_tarihi, $kontenjan);
    
    if ($stmt->execute()) {
        echo json_encode([
            'success' => true,
            'message' => 'Eğiticinin eğitimi etkinliği başarıyla oluşturuldu!',
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
