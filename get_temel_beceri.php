<?php
header('Content-Type: application/json');
require_once 'config.php'; // PDO bağlantısı

try {
    // planned_skills + persons + organization_skills (artık planlandi tablosu kullanılmıyor)
    $query = "
        SELECT 
            ps.id,
            ps.organization_id,
            ps.person_id,
            ps.skill_id,

            -- PERSON bilgileri persons tablosundan geliyor:
            p.name AS person_name,
            p.registration_no,
            p.company_name,
            p.title,

            -- SKILL bilgileri
            s.skill_name,
            s.skill_description,
            s.category,

            -- PLANNED_SKILLS bilgileri (artık planlandi tablosu yerine planned_skills kullanılıyor)
            ps.teacher_id AS selected_teacher,
            ps.event_id AS selected_event,
            ps.success_status

        FROM planned_skills ps
        LEFT JOIN persons p ON ps.person_id = p.id
        INNER JOIN organization_skills os ON ps.skill_id = os.id
        INNER JOIN skills s ON os.skill_id = s.id
        ORDER BY ps.id ASC
    ";

    $stmt = $pdo->query($query);
    $plannedSkills = $stmt->fetchAll(PDO::FETCH_ASSOC);

    // Yeni etkinlik tablolarından veri çek - Temel beceri etkinlikleri için
    $events = [];
    
    // Temel beceri etkinlikleri - eğitmen bilgileri ile
    $temelEventsStmt = $pdo->query("
        SELECT 
            tbe.*,
            o.name as organizasyon_adi,
            'temel' as etkinlik_turu,
            tbe.baslangic_tarihi as event_date,
            tbe.bitis_tarihi as end_date,
            tbe.temel_beceri_adi as course_title,
            tbe.egitmen_adi as teacher_name,
            s.id as lesson_id,
            t.id as teacher_id
        FROM temel_beceri_etkinlikleri tbe
        LEFT JOIN organizations o ON tbe.coklu_beceri_id = o.id
        LEFT JOIN skills s ON tbe.temel_beceri_adi = s.skill_name
        LEFT JOIN teachers t ON tbe.egitmen_adi = CONCAT(t.first_name, ' ', t.last_name)
        WHERE tbe.durum = 'aktif'
    ");
    $temelEvents = $temelEventsStmt->fetchAll(PDO::FETCH_ASSOC);
    
    // Çoklu beceri etkinlikleri
    $cokluEventsStmt = $pdo->query("
        SELECT 
            cbe.*,
            o.name as organizasyon_adi,
            'coklu' as etkinlik_turu
        FROM coklu_beceri_etkinlikleri cbe
        LEFT JOIN organizations o ON cbe.coklu_beceri_id = o.id
        WHERE cbe.durum = 'aktif'
    ");
    $cokluEvents = $cokluEventsStmt->fetchAll(PDO::FETCH_ASSOC);
    
    // Eğiticinin eğitimi etkinlikleri
    $egitimEventsStmt = $pdo->query("
        SELECT 
            eee.*,
            o.name as organizasyon_adi,
            'egitim' as etkinlik_turu
        FROM egiticinin_egitimi_etkinlikleri eee
        LEFT JOIN organizations o ON eee.coklu_beceri_id = o.id
        WHERE eee.durum = 'aktif'
    ");
    $egitimEvents = $egitimEventsStmt->fetchAll(PDO::FETCH_ASSOC);
    
    // Tüm etkinlikleri birleştir
    $events = array_merge($temelEvents, $cokluEvents, $egitimEvents);

    // Teachers tablosu - sadece teachers tablosundan al
    $teachersStmt = $pdo->query("SELECT id, CONCAT(first_name, ' ', last_name) AS person_name FROM teachers");
    $teachers = $teachersStmt->fetchAll(PDO::FETCH_ASSOC);

    echo json_encode([
        'plannedSkills' => $plannedSkills,
        'events' => $events,
        'teachers' => $teachers
    ]);

} catch(PDOException $e){
    echo json_encode([
        'error' => true,
        'message' => $e->getMessage()
    ]);
}
