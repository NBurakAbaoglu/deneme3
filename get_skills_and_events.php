<?php
require_once 'config.php';

header('Content-Type: application/json');

try {
    $mysqli = getDBConnection();
    if (!$mysqli) {
        throw new Exception("Veritabanı bağlantısı kurulamadı");
    }

    $data = [];

    // Planned skills verilerini çek
    $skillsSQL = "SELECT * FROM planned_skills";
    $skillsResult = $mysqli->query($skillsSQL);

    if (!$skillsResult) {
        throw new Exception("Planned skills sorgusu başarısız: " . $mysqli->error);
    }

    $skills = [];
    while ($row = $skillsResult->fetch_assoc()) {
        $skills[] = $row;
    }

    $data['planned_skills'] = $skills;

    // Yeni etkinlik tablolarından veri çek
    $events = [];
    
    // Temel beceri etkinlikleri
    $temelSQL = "SELECT * FROM temel_beceri_etkinlikleri WHERE durum = 'aktif'";
    $temelResult = $mysqli->query($temelSQL);
    if ($temelResult) {
        while ($row = $temelResult->fetch_assoc()) {
            $row['etkinlik_turu'] = 'temel';
            $events[] = $row;
        }
    }
    
    // Çoklu beceri etkinlikleri
    $cokluSQL = "SELECT * FROM coklu_beceri_etkinlikleri WHERE durum = 'aktif'";
    $cokluResult = $mysqli->query($cokluSQL);
    if ($cokluResult) {
        while ($row = $cokluResult->fetch_assoc()) {
            $row['etkinlik_turu'] = 'coklu';
            $events[] = $row;
        }
    }
    
    // Eğiticinin eğitimi etkinlikleri
    $egitimSQL = "SELECT * FROM egiticinin_egitimi_etkinlikleri WHERE durum = 'aktif'";
    $egitimResult = $mysqli->query($egitimSQL);
    if ($egitimResult) {
        while ($row = $egitimResult->fetch_assoc()) {
            $row['etkinlik_turu'] = 'egitim';
            $events[] = $row;
        }
    }

    $data['events'] = $events;

    echo json_encode([
        'success' => true,
        'data' => $data
    ]);

} catch (Exception $e) {
    error_log("Veri çekme hatası: " . $e->getMessage());

    echo json_encode([
        'success' => false,
        'message' => 'Hata: ' . $e->getMessage()
    ]);
}
?>
