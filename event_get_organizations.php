<?php
require_once 'config.php';

header('Content-Type: application/json');

try {
    $mysqli = getDBConnection();
    if (!$mysqli) {
        throw new Exception('Veritabanı bağlantısı kurulamadı');
    }

    $result = $mysqli->query("SELECT id, name FROM organizations ORDER BY name ASC");
    if (!$result) {
        throw new Exception('Sorgu hatası: ' . $mysqli->error);
    }

    $organizations = [];
    while ($row = $result->fetch_assoc()) {
        $organizations[] = $row;
    }

    $mysqli->close();
    echo json_encode($organizations);
} catch (Exception $e) {
    echo json_encode(['error' => 'Veritabanı hatası: ' . $e->getMessage()]);
}
