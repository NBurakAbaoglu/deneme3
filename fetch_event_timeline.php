<?php
require_once 'config.php';

header('Content-Type: application/json');

// Veritabanı bağlantısını al
$mysqli = getDBConnection();

if (!$mysqli) {
    die(json_encode(["error" => "Veritabanı bağlantısı kurulamadı."]));
}

// Yeni etkinlik tablolarından veri çek
$events = [];

// Temel beceri etkinlikleri
$temelSQL = "SELECT id, temel_beceri_adi as course_title, baslangic_tarihi as event_date, bitis_tarihi as end_date, 'temel' as etkinlik_turu FROM temel_beceri_etkinlikleri WHERE durum = 'aktif'";
$temelResult = executeQuery($mysqli, $temelSQL);
if ($temelResult && $temelResult->num_rows > 0) {
    while ($row = $temelResult->fetch_assoc()) {
        $events[] = $row;
    }
}

// Çoklu beceri etkinlikleri
$cokluSQL = "SELECT id, organizasyon_adi as course_title, baslangic_tarihi as event_date, bitis_tarihi as end_date, 'coklu' as etkinlik_turu FROM coklu_beceri_etkinlikleri cbe LEFT JOIN organizations o ON cbe.coklu_beceri_id = o.id WHERE cbe.durum = 'aktif'";
$cokluResult = executeQuery($mysqli, $cokluSQL);
if ($cokluResult && $cokluResult->num_rows > 0) {
    while ($row = $cokluResult->fetch_assoc()) {
        $events[] = $row;
    }
}

// Eğiticinin eğitimi etkinlikleri
$egitimSQL = "SELECT id, organizasyon_adi as course_title, baslangic_tarihi as event_date, bitis_tarihi as end_date, 'egitim' as etkinlik_turu FROM egiticinin_egitimi_etkinlikleri eee LEFT JOIN organizations o ON eee.coklu_beceri_id = o.id WHERE eee.durum = 'aktif'";
$egitimResult = executeQuery($mysqli, $egitimSQL);
if ($egitimResult && $egitimResult->num_rows > 0) {
    while ($row = $egitimResult->fetch_assoc()) {
        $events[] = $row;
    }
}

// Tarihe göre sırala
usort($events, function($a, $b) {
    return strcmp($a['event_date'], $b['event_date']);
});

if (empty($events)) {
    error_log("Etkinlik verisi bulunamadı.");
}

// JSON formatında sonucu döndür
echo json_encode($events);

// Bağlantıyı kapat
closeDBConnection($mysqli);
?>
