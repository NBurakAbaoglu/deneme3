<?php
require_once __DIR__ . '/../config.php';

header('Content-Type: application/json');

try {
    $mysqli = getDBConnection();
    if (!$mysqli) {
        throw new Exception("Veritabanı bağlantısı kurulamadı.");
    }

    $input = json_decode(file_get_contents('php://input'), true);
    
    $organizationId = $input['organization_id'] ?? '';
    $skillName = $input['skill_name'] ?? '';
    $personId = $input['person_id'] ?? '';

    if (empty($organizationId) || empty($skillName) || empty($personId)) {
        throw new Exception("Gerekli parametreler eksik.");
    }

    // Bu beceri için kontenjanı olan eğitmenleri bul
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
            GROUP BY tbe.id, tbe.egitmen_adi, tbe.kontenjan
            HAVING kalan_kontenjan > 0
            ORDER BY kalan_kontenjan DESC, tbe.baslangic_tarihi ASC
            LIMIT 1";

    $stmt = $mysqli->prepare($sql);
    if (!$stmt) {
        throw new Exception("SQL hazırlama hatası: " . $mysqli->error);
    }

    $stmt->bind_param("iis", $organizationId, $organizationId, $skillName);
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
                      WHERE person_id = ? 
                        AND organization_id = ? 
                        AND skill_id = (SELECT id FROM skills WHERE skill_name = ?)
                        AND teacher_id IS NULL";
        
        $updateStmt = $mysqli->prepare($updateSql);
        if (!$updateStmt) {
            throw new Exception("Güncelleme SQL hazırlama hatası: " . $mysqli->error);
        }
        
        $updateStmt->bind_param("siis", $assignedTeacher, $personId, $organizationId, $skillName);
        
        if ($updateStmt->execute()) {
            echo json_encode([
                'success' => true,
                'assigned_teacher' => $assignedTeacher,
                'kalan_kontenjan' => $kalanKontenjan - 1,
                'message' => "Eğitmen otomatik atandı: {$assignedTeacher}"
            ]);
        } else {
            throw new Exception("Eğitmen atama hatası: " . $updateStmt->error);
        }
        
        $updateStmt->close();
    } else {
        echo json_encode([
            'success' => false,
            'message' => "Bu beceri için kontenjanı olan eğitmen bulunamadı"
        ]);
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
