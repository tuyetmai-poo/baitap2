-- ============================================
-- HEALTHSYNC DATABASE
-- ============================================

CREATE DATABASE IF NOT EXISTS healthsync_db;
USE healthsync_db;

-- ============================================
-- 1. PATIENTS
-- ============================================

CREATE TABLE Patients (
    patient_id INT AUTO_INCREMENT PRIMARY KEY,
    full_name VARCHAR(100) NOT NULL,
    phone VARCHAR(15) NOT NULL
);

-- ============================================
-- 2. DOCTORS
-- ============================================

CREATE TABLE Doctors (
    doctor_id INT AUTO_INCREMENT PRIMARY KEY,
    full_name VARCHAR(100) NOT NULL,
    specialty VARCHAR(50)
);

-- ============================================
-- 3. APPOINTMENTS
-- ============================================

CREATE TABLE Appointments (
    appointment_id INT AUTO_INCREMENT PRIMARY KEY,
    patient_id INT NOT NULL,
    doctor_id INT NOT NULL,
    appointment_date DATETIME NOT NULL,

    status ENUM(
        'PENDING',
        'CONFIRMED',
        'CHECKED_IN',
        'COMPLETED',
        'CANCELLED'
    ) NOT NULL DEFAULT 'PENDING',

    deposit_amount DECIMAL(12,2) NOT NULL DEFAULT 0,
    penalty_fee DECIMAL(12,2) NOT NULL DEFAULT 0,
    cancel_reason VARCHAR(255),

    FOREIGN KEY (patient_id)
        REFERENCES Patients(patient_id),

    FOREIGN KEY (doctor_id)
        REFERENCES Doctors(doctor_id),

    CHECK (deposit_amount >= 0),
    CHECK (penalty_fee >= 0)
);

-- ============================================
-- 4. PRESCRIPTIONS
-- ============================================

CREATE TABLE Prescriptions (
    prescription_id INT AUTO_INCREMENT PRIMARY KEY,
    appointment_id INT NOT NULL,
    medication_details TEXT NOT NULL,
    issued_date DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,

    FOREIGN KEY (appointment_id)
        REFERENCES Appointments(appointment_id),

    UNIQUE (appointment_id)
);

-- ============================================
-- 5. DỮ LIỆU MẪU
-- ============================================

INSERT INTO Patients (full_name, phone)
VALUES
('Nguyen Van An', '0901234567'),
('Tran Thi Binh', '0912345678');

INSERT INTO Doctors (full_name, specialty)
VALUES
('Dr. Nguyen Van Minh', 'Noi khoa'),
('Dr. Tran Thi Lan', 'Ngoai khoa');

-- ============================================
-- 6. KỊCH BẢN 1: KHÁM THÀNH CÔNG
-- PENDING -> CHECKED_IN -> COMPLETED
-- ============================================

INSERT INTO Appointments (
    patient_id,
    doctor_id,
    appointment_date,
    status,
    deposit_amount,
    penalty_fee
)
VALUES (
    1,
    1,
    '2026-09-27 09:00:00',
    'PENDING',
    500000,
    0
);

-- Bệnh nhân đến khám
UPDATE Appointments
SET status = 'CHECKED_IN'
WHERE appointment_id = 1;

-- Khám xong
UPDATE Appointments
SET status = 'COMPLETED'
WHERE appointment_id = 1;

-- Bác sĩ kê đơn
INSERT INTO Prescriptions (
    appointment_id,
    medication_details
)
VALUES (
    1,
    'Paracetamol 500mg - ngày uống 2 lần sau ăn'
);

-- ============================================
-- 7. KỊCH BẢN 2: HỦY LỊCH VÀ PHẠT CỌC
-- CONFIRMED -> CANCELLED
-- ============================================

INSERT INTO Appointments (
    patient_id,
    doctor_id,
    appointment_date,
    status,
    deposit_amount,
    penalty_fee
)
VALUES (
    2,
    2,
    '2026-09-28 14:00:00',
    'CONFIRMED',
    300000,
    0
);

UPDATE Appointments
SET
    status = 'CANCELLED',
    cancel_reason = 'Bận việc đột xuất',
    penalty_fee = 150000
WHERE appointment_id = 2;

-- ============================================
-- 8. KIỂM TRA DỮ LIỆU
-- ============================================

SELECT
    appointment_id,
    patient_id,
    doctor_id,
    appointment_date,
    status,
    deposit_amount,
    penalty_fee,
    cancel_reason
FROM Appointments;

-- ============================================
-- 9. KIỂM TRA LỊCH ĐÃ KHÁM VÀ ĐƠN THUỐC
-- ============================================

SELECT
    a.appointment_id,
    p.full_name AS patient_name,
    d.full_name AS doctor_name,
    a.status,
    a.deposit_amount,
    pr.medication_details,
    pr.issued_date
FROM Appointments a
JOIN Patients p
    ON a.patient_id = p.patient_id
JOIN Doctors d
    ON a.doctor_id = d.doctor_id
JOIN Prescriptions pr
    ON a.appointment_id = pr.appointment_id
WHERE a.status = 'COMPLETED';