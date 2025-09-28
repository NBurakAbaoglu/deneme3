<?php
require_once __DIR__ . '/../config.php';

header('Content-Type: application/json');

try {
    $mysqli = getDBConnection();
    if (!$mysqli) {
        throw new Exception("Veritabanı bağlantısı kurulamadı.");
    }

    $teacherName = $_GET['teacher_name'] ?? '';
    $skillName = $_GET['skill_name'] ?? '';
    $organizationId = $_GET['organization_id'] ?? '';

    if (empty($teacherName) || empty($skillName) || empty($organizationId)) {
        throw new Exception("Gerekli parametreler eksik.");
    }

    // Eğitmenin mevcut kontenjanını kontrol et
    $sql = "SELECT 
                tbe.kontenjan,
                COUNT(ps.id) as mevcut_atama_sayisi,
                (tbe.kontenjan - COUNT(ps.id)) as kalan_kontenjan
            FROM temel_beceri_etkinlikleri tbe
            LEFT JOIN planned_skills ps ON ps.teacher_id = tbe.egitmen_adi 
                AND ps.skill_id = (SELECT id FROM skills WHERE skill_name = ?)
                AND ps.organization_id = ?
                AND ps.status = 'planlandi'
            WHERE tbe.egitmen_adi = ? 
                AND tbe.temel_beceri_adi = ?
                AND tbe.durum = 'aktif'
            GROUP BY tbe.id, tbe.kontenjan";

    $stmt = $mysqli->prepare($sql);
    if (!$stmt) {
        throw new Exception("SQL hazırlama hatası: " . $mysqli->error);
    }

    $stmt->bind_param("iiss", $organizationId, $organizationId, $teacherName, $skillName);
    $stmt->execute();
    $result = $stmt->get_result();

    if ($result->num_rows > 0) {
        $row = $result->fetch_assoc();
        $kontenjan = $row['kontenjan'];
        $mevcut_atama = $row['mevcut_atama_sayisi'];
        $kalan_kontenjan = $row['kalan_kontenjan'];
        
        $isAvailable = $kalan_kontenjan > 0;
        
        echo json_encode([
            'success' => true,
            'teacher_name' => $teacherName,
            'skill_name' => $skillName,
            'kontenjan' => $kontenjan,
            'mevcut_atama' => $mevcut_atama,
            'kalan_kontenjan' => $kalan_kontenjan,
            'is_available' => $isAvailable,
            'message' => $isAvailable ? 
                "Eğitmen kontenjanı müsait (Kalan: {$kalan_kontenjan})" : 
                "Eğitmen kontenjanı dolu (Kontenjan: {$kontenjan}, Mevcut: {$mevcut_atama})"
        ]);
    } else {
        // Eğitmen bu beceri için etkinlik bulunamadı
        echo json_encode([
            'success' => true,
            'teacher_name' => $teacherName,
            'skill_name' => $skillName,
            'kontenjan' => 0,
            'mevcut_atama' => 0,
            'kalan_kontenjan' => 0,
            'is_available' => false,
            'message' => "Bu eğitmen için bu beceri etkinliği bulunamadı"
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
