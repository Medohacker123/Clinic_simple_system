
CREATE DATABASE IF NOT EXISTS alshefa_clinic
  CHARACTER SET utf8mb4
  COLLATE utf8mb4_unicode_ci;

USE alshefa_clinic;


SET FOREIGN_KEY_CHECKS = 0;


DROP TABLE IF EXISTS invoices;
DROP TABLE IF EXISTS prescriptions;
DROP TABLE IF EXISTS appointments;
DROP TABLE IF EXISTS doctors;
DROP TABLE IF EXISTS patients;

-- ============================================
-- 1. جدول المرضى - Patients Table
-- ============================================
CREATE TABLE patients (
    patient_id    INT(4)        UNSIGNED AUTO_INCREMENT PRIMARY KEY,
    pat_name      VARCHAR(30)   NOT NULL,
    pat_phone     VARCHAR(10)   NOT NULL,
    pat_address   VARCHAR(80)   DEFAULT NULL,
    dob           DATE          DEFAULT NULL,
    gender        ENUM('ذكر','أنثى') NOT NULL,
    created_at    TIMESTAMP     DEFAULT CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- ============================================
-- 2. جدول الأطباء - Doctors Table
-- ============================================
CREATE TABLE doctors (
    doc_id          INT(6)        UNSIGNED AUTO_INCREMENT PRIMARY KEY,
    doc_name        VARCHAR(70)   NOT NULL,
    specialization  VARCHAR(80)   NOT NULL,
    doc_phone       VARCHAR(10)   NOT NULL,
    doc_email       VARCHAR(100)  DEFAULT NULL,
    visit_cost      DECIMAL(9,2)  NOT NULL DEFAULT 0.00,
    created_at      TIMESTAMP     DEFAULT CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- ============================================
-- 3. جدول المواعيد - Appointments Table
-- ============================================
CREATE TABLE appointments (
    appt_id     INT(10)       UNSIGNED AUTO_INCREMENT PRIMARY KEY,
    patient_id  INT(4)        UNSIGNED NOT NULL,
    doc_id      INT(6)        UNSIGNED NOT NULL,
    appt_date   DATE          NOT NULL,
    appt_time   TIME          NOT NULL,
    status      ENUM('محجوز','مكتمل','ملغى','لم يحضر') DEFAULT 'محجوز',
    diagnosis   VARCHAR(200)  DEFAULT NULL,
    notes       TEXT          DEFAULT NULL,
    created_at  TIMESTAMP     DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (patient_id) REFERENCES patients(patient_id) ON DELETE CASCADE,
    FOREIGN KEY (doc_id)     REFERENCES doctors(doc_id)      ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- ============================================
-- 4. جدول الوصفات الطبية - Prescriptions Table
-- ============================================
CREATE TABLE prescriptions (
    presc_id      INT(15)       UNSIGNED AUTO_INCREMENT PRIMARY KEY,
    appt_id       INT(10)       UNSIGNED NOT NULL,
    med_name      VARCHAR(100)  NOT NULL,
    dosage        VARCHAR(50)   NOT NULL,
    duration      INT(6)        NOT NULL COMMENT 'Duration in days',
    instructions  TEXT          DEFAULT NULL,
    created_at    TIMESTAMP     DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (appt_id) REFERENCES appointments(appt_id) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- ============================================
-- 5. جدول الفواتير - Invoices Table
-- ============================================
CREATE TABLE invoices (
    inv_id        INT(9)        UNSIGNED AUTO_INCREMENT PRIMARY KEY,
    appt_id       INT(10)       UNSIGNED NOT NULL UNIQUE,
    total_amount  DECIMAL(9,2)  NOT NULL DEFAULT 0.00,
    inv_date      DATE          NOT NULL,
    pay_method    ENUM('نقدي','بطاقة','تحويل') DEFAULT 'نقدي',
    pay_status    ENUM('مدفوع','غير مدفوع','جزئي') DEFAULT 'غير مدفوع',
    created_at    TIMESTAMP     DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (appt_id) REFERENCES appointments(appt_id) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- ============================================
-- Sample Data - بيانات تجريبية
-- ============================================

INSERT INTO doctors (doc_name, specialization, doc_phone, doc_email, visit_cost) VALUES
('د. أحمد محمد علي',    'أمراض الباطنية',   '0912345678', 'ahmed@alshefa.sd',   150.00),
('د. فاطمة حسن',        'طب الأطفال',        '0912345679', 'fatima@alshefa.sd',  120.00),
('د. عمر خالد',         'جراحة عامة',        '0912345680', 'omar@alshefa.sd',    200.00),
('د. مريم إبراهيم',     'أمراض النساء',      '0912345681', 'mariam@alshefa.sd',  180.00);

INSERT INTO patients (pat_name, pat_phone, pat_address, dob, gender) VALUES
('محمد عبد الله أحمد',  '0912345678', 'الخرطوم - بحري',     '1990-05-15', 'ذكر'),
('آمنة يوسف حسن',       '0923456789', 'أم درمان - الثورة',  '1985-09-22', 'أنثى'),
('خالد محمود إبراهيم',  '0934567890', 'الخرطوم - الرياض',   '2000-01-10', 'ذكر'),
('زينب عمر الشيخ',      '0945678901', 'أم درمان - حي النيل','1978-11-30', 'أنثى');

INSERT INTO appointments (patient_id, doc_id, appt_date, appt_time, status, diagnosis, notes) VALUES
(1, 1, CURDATE(), '09:00:00', 'مكتمل',  'ارتفاع ضغط الدم', 'مراجعة بعد أسبوع'),
(2, 2, CURDATE(), '10:30:00', 'محجوز',  NULL,               NULL),
(3, 3, CURDATE(), '11:00:00', 'محجوز',  NULL,               'حالة عاجلة'),
(4, 1, CURDATE(), '14:00:00', 'مكتمل',  'سكر الدم',         NULL);

INSERT INTO prescriptions (appt_id, med_name, dosage, duration, instructions) VALUES
(1, 'أملوديبين', '5 ملغ',   30, 'مرة واحدة يومياً مع الأكل'),
(1, 'أسبرين',    '100 ملغ', 30, 'مرة واحدة يومياً'),
(4, 'ميتفورمين', '500 ملغ', 60, 'مرتين يومياً مع الوجبات');

INSERT INTO invoices (appt_id, total_amount, inv_date, pay_method, pay_status) VALUES
(1, 150.00, CURDATE(), 'نقدي',  'مدفوع'),
(4, 150.00, CURDATE(), 'بطاقة', 'مدفوع');


SET FOREIGN_KEY_CHECKS = 1;
