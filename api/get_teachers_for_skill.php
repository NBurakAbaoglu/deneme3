<?php
require_once '../config.php';

header('Content-Type: application/json');

try {
    $mysqli = getDBConnection();
    if (!$mysqli) throw new Exception("Veritabanı bağlantısı kurulamadı");

    $organizationName = $_GET['organization_name'] ?? null;
    $skillName = $_GET['skill_name'] ?? null;
    
    if (!$organizationName && !$skillName) {
        throw new Exception("En az bir parametre gerekli (organization_name veya skill_name)");
    }

    $query = "SELECT DISTINCT person_name FROM tep_teachers WHERE 1=1";
    $params = [];
    $types = "";
    
    if ($organizationName) {
        $query .= " AND organization_name = ?";
        $params[] = $organizationName;
        $types .= "s";
    }
    
    if ($skillName) {
        $query .= " AND skill_name = ?";
        $params[] = $skillName;
        $types .= "s";
    }
    
    $query .= " ORDER BY person_name ASC";
    
    $stmt = $mysqli->prepare($query);
    if (!$stmt) throw new Exception("Sorgu hazırlama hatası: " . $mysqli->error);
    
    if (!empty($params)) {
        $stmt->bind_param($types, ...$params);
    }
    
    $stmt->execute();
    $result = $stmt->get_result();
    
    if (!$result) throw new Exception("Sorgu hatası: " . $mysqli->error);

    $teachers = [];
    while ($row = $result->fetch_assoc()) {
        $teachers[] = [
            'person_name' => $row['person_name']
        ];
    }

    $stmt->close();

    echo json_encode([
        'success' => true,
        'teachers' => $teachers
    ]);

} catch (Exception $e) {
    echo json_encode([
        'success' => false,
        'message' => $e->getMessage()
    ]);
}
?>
