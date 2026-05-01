<?php
header('Access-Control-Allow-Origin: *');
header('Access-Control-Allow-Methods: GET, POST, PUT, DELETE, OPTIONS');
header('Access-Control-Allow-Headers: Content-Type');
if ($_SERVER['REQUEST_METHOD'] === 'OPTIONS') { http_response_code(200); exit; }

require_once __DIR__ . '/config.php';
require_once __DIR__ . '/auth_check.php';
require_auth();

$method = $_SERVER['REQUEST_METHOD'];
$db = getDB();

switch ($method) {
    case 'GET':
        $id = $_GET['id'] ?? null;
        $date = $_GET['date'] ?? null;
        $patient = $_GET['patient_id'] ?? null;

        if ($id) {
            $stmt = $db->prepare("
                SELECT a.*, p.pat_name, p.pat_phone, d.doc_name, d.specialization, d.visit_cost
                FROM appointments a
                JOIN patients p ON a.patient_id = p.patient_id
                JOIN doctors  d ON a.doc_id     = d.doc_id
                WHERE a.appt_id = ?
            ");
            $stmt->execute([$id]);
            jsonResponse($stmt->fetch());
        } else {
            $sql = "
                SELECT a.*, p.pat_name, p.pat_phone, d.doc_name, d.specialization, d.visit_cost
                FROM appointments a
                JOIN patients p ON a.patient_id = p.patient_id
                JOIN doctors  d ON a.doc_id     = d.doc_id
                WHERE 1=1
            ";
            $params = [];
            if ($date)    { $sql .= " AND a.appt_date = ?"; $params[] = $date; }
            if ($patient) { $sql .= " AND a.patient_id = ?"; $params[] = $patient; }
            $sql .= " ORDER BY a.appt_date DESC, a.appt_time ASC";
            $stmt = $db->prepare($sql);
            $stmt->execute($params);
            jsonResponse($stmt->fetchAll());
        }
        break;

    case 'POST':
        $d = getInput();
        $stmt = $db->prepare("INSERT INTO appointments (patient_id, doc_id, appt_date, appt_time, status, diagnosis, notes) VALUES (?,?,?,?,?,?,?)");
        $stmt->execute([$d['patient_id'], $d['doc_id'], $d['appt_date'], $d['appt_time'], $d['status'] ?? 'محجوز', $d['diagnosis'] ?? null, $d['notes'] ?? null]);
        $apptId = $db->lastInsertId();

        // Auto-create invoice
        $costStmt = $db->prepare("SELECT visit_cost FROM doctors WHERE doc_id = ?");
        $costStmt->execute([$d['doc_id']]);
        $cost = $costStmt->fetchColumn();
        $invStmt = $db->prepare("INSERT INTO invoices (appt_id, total_amount, inv_date, pay_method, pay_status) VALUES (?,?,?,?,?)");
        $invStmt->execute([$apptId, $cost, $d['appt_date'], 'نقدي', 'غير مدفوع']);

        jsonResponse(['id' => $apptId, 'message' => 'تم حجز الموعد وإنشاء الفاتورة'], 201);
        break;

    case 'PUT':
        $d = getInput();
        $id = $_GET['id'] ?? $d['appt_id'];
        $stmt = $db->prepare("UPDATE appointments SET patient_id=?, doc_id=?, appt_date=?, appt_time=?, status=?, diagnosis=?, notes=? WHERE appt_id=?");
        $stmt->execute([$d['patient_id'], $d['doc_id'], $d['appt_date'], $d['appt_time'], $d['status'], $d['diagnosis'] ?? null, $d['notes'] ?? null, $id]);
        jsonResponse(['message' => 'تم تحديث الموعد']);
        break;

    case 'DELETE':
        $id = $_GET['id'];
        $stmt = $db->prepare("DELETE FROM appointments WHERE appt_id = ?");
        $stmt->execute([$id]);
        jsonResponse(['message' => 'تم حذف الموعد']);
        break;
}
