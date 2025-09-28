<?php
require_once 'config.php';

header('Content-Type: application/json');

try {
    $input = json_decode(file_get_contents('php://input'), true);
    
    if (!$input) {
        throw new Exception('Geçersiz veri formatı');
    }

    $person_id = $input['person_id'] ?? null;
    $organization_id = $input['organization_id'] ?? null;
    $event_id = $input['event_id'] ?? null;
    $success_status = $input['success_status'] ?? 'istek_gonderildi';
    $start_date = $input['start_date'] ?? date('Y-m-d');
    $end_date = $input['end_date'] ?? date('Y-m-d');


    if (!$person_id || !$organization_id) {
        throw new Exception('Person ID ve Organization ID gerekli');
    }
    
    // event_id kontrolü
    if (!$event_id) {
        error_log("⚠️ event_id boş veya null: " . var_export($event_id, true));
        // event_id boş olsa bile devam et, sadece logla
    } else {
        error_log("✅ event_id değeri: " . $event_id . " (tip: " . gettype($event_id) . ")");
    }

    // Mevcut kaydı kontrol et
    $mysqli = getDBConnection();
    if (!$mysqli) {
        throw new Exception("Veritabanı bağlantısı kurulamadı");
    }
    
    // Debug: Gelen verileri logla
    error_log("🔍 Gelen veriler - person_id: " . $person_id . ", organization_id: " . $organization_id . ", event_id: " . $event_id . ", success_status: " . $success_status);
    error_log("🔍 event_id tipi: " . gettype($event_id) . ", değeri: " . var_export($event_id, true));
    
    // Tablo yapısını kontrol et
    $descQuery = "DESCRIBE planned_multi_skill";
    $descResult = $mysqli->query($descQuery);
    if ($descResult) {
        while ($row = $descResult->fetch_assoc()) {
            if ($row['Field'] === 'teacher_id') {
                error_log("🔍 teacher_id alan tipi: " . $row['Type']);
                break;
            }
        }
    }
    
    // Mevcut kaydı kontrol et
    $checkQuery2 = "SELECT etkinlik_id FROM planned_multi_skill WHERE person_id = ? AND organization_id = ?";
    $checkStmt2 = $mysqli->prepare($checkQuery2);
    $checkStmt2->bind_param("ii", $person_id, $organization_id);
    $checkStmt2->execute();
    $checkResult2 = $checkStmt2->get_result();
    if ($checkResult2->num_rows > 0) {
        $existingRow = $checkResult2->fetch_assoc();
        error_log("🔍 Mevcut etkinlik_id: " . ($existingRow['etkinlik_id'] ?? 'NULL'));
    }
    $checkStmt2->close();
    
    $checkQuery = "SELECT id FROM planned_multi_skill WHERE person_id = ? AND organization_id = ?";
    $checkStmt = $mysqli->prepare($checkQuery);
    $checkStmt->bind_param("ii", $person_id, $organization_id);
    $checkStmt->execute();
    $result = $checkStmt->get_result();
    $existingRecord = $result->fetch_assoc();

    if ($existingRecord) {
        // Mevcut kaydı güncelle
        $updateQuery = "UPDATE planned_multi_skill SET 
            etkinlik_id = ?, 
            success_status = ?,
            start_date = ?,
            end_date = ?,
            updated_at = NOW()
            WHERE person_id = ? AND organization_id = ?";
        
        $updateStmt = $mysqli->prepare($updateQuery);
        // etkinlik_id kullan
        $updateStmt->bind_param("isssii", $event_id, $success_status, $start_date, $end_date, $person_id, $organization_id);
        
        // Debug: Gönderilen verileri logla
        error_log("🔍 UPDATE - event_id: " . $event_id . ", success_status: " . $success_status);
        error_log("🔍 UPDATE sorgusu çalıştırılıyor...");
        $result = $updateStmt->execute();
        error_log("🔍 UPDATE sonucu: " . ($result ? 'BAŞARILI' : 'BAŞARISIZ'));

        if ($result) {
            // Güncelleme sonrası etkinlik_id'yi kontrol et
            $verifyQuery = "SELECT etkinlik_id FROM planned_multi_skill WHERE person_id = ? AND organization_id = ?";
            $verifyStmt = $mysqli->prepare($verifyQuery);
            $verifyStmt->bind_param("ii", $person_id, $organization_id);
            $verifyStmt->execute();
            $verifyResult = $verifyStmt->get_result();
            if ($verifyResult->num_rows > 0) {
                $verifyRow = $verifyResult->fetch_assoc();
                error_log("🔍 Güncelleme sonrası etkinlik_id: " . ($verifyRow['etkinlik_id'] ?? 'NULL'));
            }
            $verifyStmt->close();
            
            // Organization_images tablosunu güncelle
            updateOrganizationImage($person_id, $organization_id, $success_status);
            
            echo json_encode([
                'success' => true,
                'message' => 'Çoklu beceri kaydı güncellendi',
                'action' => 'updated'
            ]);
        } else {
            throw new Exception('Güncelleme başarısız');
        }
    } else {
        // Yeni kayıt oluştur
        $insertQuery = "INSERT INTO planned_multi_skill 
            (person_id, organization_id, etkinlik_id, success_status, start_date, end_date, created_at, updated_at) 
            VALUES (?, ?, ?, ?, ?, ?, NOW(), NOW())";
        
        $insertStmt = $mysqli->prepare($insertQuery);
        // etkinlik_id kullan
        $insertStmt->bind_param("iiisss", $person_id, $organization_id, $event_id, $success_status, $start_date, $end_date);
        
        // Debug: Gönderilen verileri logla
        error_log("🔍 INSERT - event_id: " . $event_id . ", success_status: " . $success_status);
        $result = $insertStmt->execute();

        if ($result) {
            // INSERT sonrası etkinlik_id'yi kontrol et
            $verifyQuery2 = "SELECT etkinlik_id FROM planned_multi_skill WHERE person_id = ? AND organization_id = ?";
            $verifyStmt2 = $mysqli->prepare($verifyQuery2);
            $verifyStmt2->bind_param("ii", $person_id, $organization_id);
            $verifyStmt2->execute();
            $verifyResult2 = $verifyStmt2->get_result();
            if ($verifyResult2->num_rows > 0) {
                $verifyRow2 = $verifyResult2->fetch_assoc();
                error_log("🔍 INSERT sonrası etkinlik_id: " . ($verifyRow2['etkinlik_id'] ?? 'NULL'));
            }
            $verifyStmt2->close();
            
            // Organization_images tablosunu güncelle
            updateOrganizationImage($person_id, $organization_id, $success_status);
            
            echo json_encode([
                'success' => true,
                'message' => 'Çoklu beceri kaydı oluşturuldu',
                'action' => 'created'
            ]);
        } else {
            throw new Exception('Kayıt oluşturma başarısız');
        }
    }
    
    closeDBConnection($mysqli);

} catch (Exception $e) {
    echo json_encode([
        'success' => false,
        'message' => 'Hata: ' . $e->getMessage()
    ]);
}

// Organization_images tablosunu güncelle
function updateOrganizationImage($person_id, $organization_id, $success_status) {
    global $pdo;
    
    try {
        // Kişi adını al
        $personQuery = "SELECT name FROM persons WHERE id = ?";
        $personStmt = $pdo->prepare($personQuery);
        $personStmt->execute([$person_id]);
        $person = $personStmt->fetch(PDO::FETCH_ASSOC);
        
        if (!$person) {
            error_log("❌ Kişi bulunamadı: $person_id");
            return;
        }
        
        $personName = $person['name'];
        
        // Success status'a göre pie chart belirle
        $imageName = 'pie (2).png'; // Varsayılan: Bilgisi Yok
        
        switch ($success_status) {
            case 'istek_gonderildi':
                $imageName = 'pie (3).png'; // İstek Gönderildi
                break;
            case 'planlandi':
                $imageName = 'pie (4).png'; // Planlandı
                break;
            case 'tamamlandi':
                $imageName = 'pie (5).png'; // Tamamlandı
                break;
        }
        
        // Organization_images tablosunu güncelle
        $updateQuery = "
            UPDATE organization_images 
            SET image_name = ?, updated_at = NOW()
            WHERE organization_id = ? AND row_name = ?
        ";
        
        $updateStmt = $pdo->prepare($updateQuery);
        $result = $updateStmt->execute([$imageName, $organization_id, $personName]);
        
        if ($result) {
            error_log("✅ Organization image güncellendi: $personName, $organization_id, $imageName");
        } else {
            error_log("❌ Organization image güncellenemedi: $personName, $organization_id");
        }
        
        // Test için basit bir log
        error_log("🧪 TEST: updateOrganizationImage çağrıldı - $personName, $organization_id, $success_status -> $imageName");
        
    } catch (Exception $e) {
        error_log("❌ Organization image güncelleme hatası: " . $e->getMessage());
    }
}
?>
