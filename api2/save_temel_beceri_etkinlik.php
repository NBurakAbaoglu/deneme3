<?php
require_once __DIR__ . '/../config.php';

header('Content-Type: application/json');

// Otomatik eğitimci atama fonksiyonu
function autoAssignTeacherToEvent($mysqli, $etkinlikId, $temelBeceriAdi, $cokluBeceriId) {
    // Bu etkinlik için kontenjanı olan eğitmenleri bul
    $sql = "SELECT 
                tbe.egitmen_adi,
                tbe.kontenjan,
                COUNT(ps.id) as mevcut_atama_sayisi,
                (tbe.kontenjan - COUNT(ps.id)) as kalan_kontenjan
            FROM temel_beceri_etkinlikleri tbe
            LEFT JOIN planned_skills ps ON ps.teacher_id = tbe.egitmen_adi 
                AND ps.skill_id = (SELECT id FROM skills WHERE skill_name = ?)
                AND ps.organization_id = ?
                AND ps.status = 'planlandi'
            WHERE tbe.temel_beceri_adi = ? 
                AND tbe.durum = 'aktif'
                AND tbe.id = ?
            GROUP BY tbe.id, tbe.egitmen_adi, tbe.kontenjan
            HAVING kalan_kontenjan > 0
            ORDER BY kalan_kontenjan DESC, tbe.baslangic_tarihi ASC
            LIMIT 1";

    $stmt = $mysqli->prepare($sql);
    if (!$stmt) {
        throw new Exception("Otomatik atama SQL hazırlama hatası: " . $mysqli->error);
    }

    $stmt->bind_param("iisi", $cokluBeceriId, $cokluBeceriId, $temelBeceriAdi, $etkinlikId);
    $stmt->execute();
    $result = $stmt->get_result();

    if ($result->num_rows > 0) {
        $row = $result->fetch_assoc();
        $assignedTeacher = $row['egitmen_adi'];
        $kalanKontenjan = $row['kalan_kontenjan'];
        
        // Eğitmeni otomatik ata
        $updateSql = "UPDATE planned_skills 
                      SET teacher_id = ?, 
                          success_status = 'planlandi',
                          status = 'planlandi'
                      WHERE organization_id = ? 
                        AND skill_id = (SELECT id FROM skills WHERE skill_name = ?)
                        AND teacher_id IS NULL
                        AND status = 'planlandi'";
        
        $updateStmt = $mysqli->prepare($updateSql);
        if (!$updateStmt) {
            throw new Exception("Otomatik atama güncelleme SQL hazırlama hatası: " . $mysqli->error);
        }
        
        $updateStmt->bind_param("iis", $assignedTeacher, $cokluBeceriId, $temelBeceriAdi);
        
        if ($updateStmt->execute()) {
            error_log("Otomatik atama başarılı: {$assignedTeacher} - Kalan kontenjan: " . ($kalanKontenjan - 1));
        } else {
            throw new Exception("Otomatik atama güncelleme hatası: " . $updateStmt->error);
        }
        
        $updateStmt->close();
    } else {
        error_log("Otomatik atama: Bu beceri için kontenjanı olan eğitmen bulunamadı");
    }

    $stmt->close();
}

try {
    // POST verilerini al
    $coklu_beceri_id = $_POST['coklu_beceri_id'] ?? '';
    $temel_beceri_adi = $_POST['temel_beceri_adi'] ?? '';
    $egitmen_adi = $_POST['egitmen_adi'] ?? '';
    $baslangic_tarihi = $_POST['baslangic_tarihi'] ?? '';
    $bitis_tarihi = $_POST['bitis_tarihi'] ?? '';
    $kontenjan = $_POST['kontenjan'] ?? '';

    // Validasyon
    if (empty($coklu_beceri_id) || empty($temel_beceri_adi) || empty($egitmen_adi) || 
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
    $sql = "INSERT INTO temel_beceri_etkinlikleri 
            (coklu_beceri_id, temel_beceri_adi, egitmen_adi, baslangic_tarihi, bitis_tarihi, kontenjan) 
            VALUES (?, ?, ?, ?, ?, ?)";
    
    $stmt = $mysqli->prepare($sql);
    if (!$stmt) {
        throw new Exception("SQL hazırlama hatası: " . $mysqli->error);
    }
    
    $stmt->bind_param("issssi", $coklu_beceri_id, $temel_beceri_adi, $egitmen_adi, $baslangic_tarihi, $bitis_tarihi, $kontenjan);
    
    if ($stmt->execute()) {
        $etkinlikId = $mysqli->insert_id;
        
        // Otomatik eğitimci ataması yap
        try {
            autoAssignTeacherToEvent($mysqli, $etkinlikId, $temel_beceri_adi, $coklu_beceri_id);
        } catch (Exception $e) {
            // Otomatik atama hatası etkinlik oluşturmayı engellemez
            error_log("Otomatik atama hatası: " . $e->getMessage());
        }
        
        echo json_encode([
            'success' => true,
            'message' => 'Temel beceri etkinliği başarıyla oluşturuldu!',
            'id' => $etkinlikId
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
