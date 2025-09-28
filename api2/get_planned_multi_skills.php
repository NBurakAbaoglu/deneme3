<?php
header('Content-Type: application/json');
require_once __DIR__ . '/../config.php';

try {
    $mysqli = getDBConnection();
    if (!$mysqli) {
        throw new Exception("Veritabanı bağlantısı kurulamadı");
    }

    // planned_multi_skill + persons + organizations + coklu_beceri_etkinlikleri
    $query = "
        SELECT 
            pms.id,
            pms.person_id,
            pms.organization_id,
            pms.success_status,
            pms.etkinlik_id,
            pms.created_at,
            pms.updated_at,
            
            -- PERSON bilgileri persons tablosundan geliyor:
            p.name AS person_name,
            p.registration_no,
            p.company_name,
            p.title,
            
            -- ORGANIZATION bilgileri
            o.name AS organization_name,
            
            -- ÇOKLU BECERİ ETKİNLİKLERİ bilgileri
            cbe.egitmen_adi,
            cbe.baslangic_tarihi,
            cbe.bitis_tarihi,
            cbe.durum
            
        FROM planned_multi_skill pms
        LEFT JOIN persons p ON pms.person_id = p.id
        LEFT JOIN organizations o ON pms.organization_id = o.id
        LEFT JOIN coklu_beceri_etkinlikleri cbe ON cbe.coklu_beceri_id = o.id
        ORDER BY pms.created_at DESC
    ";
    
    $result = $mysqli->query($query);
    if (!$result) {
        throw new Exception("Sorgu hatası: " . $mysqli->error);
    }
    
    $multi_skills = [];
    while ($row = $result->fetch_assoc()) {
        $multi_skills[] = $row;
    }
    
    // Tekrarlanan kayıtları temizle - aynı person_id ve organization_id için sadece en son kaydı al
    $unique_skills = [];
    $seen_combinations = [];
    
    foreach ($multi_skills as $skill) {
        $key = $skill['person_id'] . '_' . $skill['organization_id'];
        
        // Eğer bu kombinasyon daha önce görülmemişse veya bu kayıt daha yeni ise
        if (!isset($seen_combinations[$key]) || $skill['id'] > $seen_combinations[$key]['id']) {
            $seen_combinations[$key] = $skill;
        }
    }
    
    // Benzersiz kayıtları al
    $multi_skills = array_values($seen_combinations);
    
    // Debug log'ları kaldırıldı - performans için
    
    // Basit çoklu beceri işlemi - her kayıt için sadece "Çoklu Beceri" yaz
    foreach ($multi_skills as &$skill) {
        $skill['skill_names'] = 'Çoklu Beceri';
        
        // Eğer etkinlik_id varsa, coklu_beceri_etkinlikleri tablosundan eğitmen bilgilerini al
        if ($skill['etkinlik_id']) {
            $eventQuery = "SELECT egitmen_adi, baslangic_tarihi, bitis_tarihi FROM coklu_beceri_etkinlikleri WHERE id = ?";
            $eventStmt = $mysqli->prepare($eventQuery);
            $eventStmt->bind_param("i", $skill['etkinlik_id']);
            $eventStmt->execute();
            $eventResult = $eventStmt->get_result();
            
            if ($eventResult->num_rows > 0) {
                $eventRow = $eventResult->fetch_assoc();
                $skill['teacher_name'] = $eventRow['egitmen_adi'];
                $skill['event_start_date'] = $eventRow['baslangic_tarihi'];
                $skill['event_end_date'] = $eventRow['bitis_tarihi'];
                error_log("🔍 etkinlik_id " . $skill['etkinlik_id'] . " için eğitmen: " . $skill['teacher_name']);
            }
            $eventStmt->close();
        } else {
            $skill['teacher_name'] = null;
        }
    }
    
    // Çoklu beceri etkinliklerini al
    $events_query = "
        SELECT 
            cbe.id,
            cbe.coklu_beceri_id,
            cbe.egitmen_adi,
            cbe.baslangic_tarihi,
            cbe.bitis_tarihi,
            cbe.durum,
            o.name AS organizasyon_adi
        FROM coklu_beceri_etkinlikleri cbe
        LEFT JOIN organizations o ON cbe.coklu_beceri_id = o.id
        WHERE cbe.durum = 'aktif'
        ORDER BY cbe.baslangic_tarihi ASC
    ";
    
    // Debug: Events sorgusunu logla
    error_log("🔍 Events sorgusu: " . $events_query);
    
    $events_result = $mysqli->query($events_query);
    $events = [];
    if ($events_result) {
        while ($row = $events_result->fetch_assoc()) {
            $events[] = $row;
            error_log("🔍 Event kaydı: " . json_encode($row));
        }
    } else {
        error_log("❌ Events sorgusu başarısız: " . $mysqli->error);
    }
    
    // Teachers tablosu - çoklu beceri etkinliklerinden eğitmenleri al
    $teachers_query = "
        SELECT DISTINCT 
            egitmen_adi as person_name,
            egitmen_adi as id
        FROM coklu_beceri_etkinlikleri 
        WHERE durum = 'aktif' AND egitmen_adi IS NOT NULL AND egitmen_adi != ''
    ";
    
    $teachers_result = $mysqli->query($teachers_query);
    $teachers = [];
    if ($teachers_result) {
        while ($row = $teachers_result->fetch_assoc()) {
            $teachers[] = $row;
        }
    }
    
    // Debug: Dönen verileri logla
    error_log("🔍 get_planned_multi_skills.php - multi_skills count: " . count($multi_skills));
    error_log("🔍 get_planned_multi_skills.php - events count: " . count($events));
    error_log("🔍 get_planned_multi_skills.php - teachers count: " . count($teachers));
    
    // İlk multi_skill kaydını logla
    if (count($multi_skills) > 0) {
        error_log("🔍 İlk multi_skill kaydı: " . json_encode($multi_skills[0]));
        error_log("🔍 İlk kayıt etkinlik_id: " . ($multi_skills[0]['etkinlik_id'] ?? 'NULL'));
    }
    
    // İlk event kaydını logla
    if (count($events) > 0) {
        error_log("🔍 İlk event kaydı: " . json_encode($events[0]));
    }
    
    echo json_encode([
        'success' => true,
        'multi_skills' => $multi_skills,
        'events' => $events,
        'teachers' => $teachers,
        'count' => count($multi_skills)
    ]);
    
    closeDBConnection($mysqli);
    
} catch (Exception $e) {
    echo json_encode([
        'success' => false,
        'message' => $e->getMessage()
    ]);
}
?>
