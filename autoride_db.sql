-- =========================================
-- AUTORIDE DATABASE
-- =========================================

CREATE DATABASE IF NOT EXISTS autoride_db;
USE autoride_db;

-- =========================================
-- 1. BẢNG CARS
-- =========================================

CREATE TABLE Cars (
    car_id INT AUTO_INCREMENT PRIMARY KEY,
    model_name VARCHAR(100) NOT NULL,
    license_plate VARCHAR(20) UNIQUE NOT NULL
);

-- =========================================
-- 2. BẢNG RENTALS - LEGACY
-- =========================================

CREATE TABLE Rentals (
    rental_id INT AUTO_INCREMENT PRIMARY KEY,
    car_id INT,
    customer_name VARCHAR(100) NOT NULL,
    rent_date DATETIME NOT NULL,
    return_date DATETIME,

    status VARCHAR(50) DEFAULT 'BOOKED',

    FOREIGN KEY (car_id)
        REFERENCES Cars(car_id)
);

-- =========================================
-- 3. NÂNG CẤP BẢNG RENTALS
-- =========================================

-- Chuyển status từ VARCHAR sang ENUM
ALTER TABLE Rentals
MODIFY COLUMN status ENUM(
    'BOOKED',
    'ACTIVE',
    'COMPLETED',
    'CANCELLED'
) NOT NULL DEFAULT 'BOOKED';

-- Thêm các cột tài chính
ALTER TABLE Rentals
ADD COLUMN security_deposit DECIMAL(10,2) NOT NULL DEFAULT 0,
ADD COLUMN late_fee DECIMAL(10,2) NOT NULL DEFAULT 0,
ADD COLUMN damage_fee DECIMAL(10,2) NOT NULL DEFAULT 0;

-- =========================================
-- 4. BẢNG INSPECTIONS
-- =========================================

CREATE TABLE Inspections (
    inspection_id INT AUTO_INCREMENT PRIMARY KEY,
    rental_id INT NOT NULL,
    inspection_date DATETIME NOT NULL,
    damage_description TEXT,
    inspector_name VARCHAR(100) NOT NULL,

    FOREIGN KEY (rental_id)
        REFERENCES Rentals(rental_id)
        ON DELETE RESTRICT
);

-- =========================================
-- 5. DỮ LIỆU XE
-- =========================================

INSERT INTO Cars (
    model_name,
    license_plate
)
VALUES (
    'Toyota Camry',
    '30A-12345'
);

-- =========================================
-- 6. KỊCH BẢN THUÊ XE
-- Khách Nguyen Van A thuê xe
-- Tiền cọc: 10.000.000 VNĐ
-- =========================================

INSERT INTO Rentals (
    car_id,
    customer_name,
    rent_date,
    return_date,
    status,
    security_deposit,
    late_fee,
    damage_fee
)
VALUES (
    1,
    'Nguyen Van A',
    '2026-09-27 08:00:00',
    NULL,
    'ACTIVE',
    10000000,
    0,
    0
);

-- =========================================
-- 7. KHÁCH TRẢ XE
-- Phát hiện vỡ đèn pha trái
-- =========================================

INSERT INTO Inspections (
    rental_id,
    inspection_date,
    damage_description,
    inspector_name
)
VALUES (
    1,
    '2026-09-29 10:00:00',
    'Vỡ đèn pha trái',
    'Tran Van B'
);

-- =========================================
-- 8. HOÀN TẤT HỢP ĐỒNG
-- Không trả trễ nên late_fee = 0
-- Phí sửa chữa = 2.000.000 VNĐ
-- =========================================

UPDATE Rentals
SET
    return_date = '2026-09-29 10:00:00',
    status = 'COMPLETED',
    late_fee = 0,
    damage_fee = 2000000
WHERE rental_id = 1;

-- =========================================
-- 9. TÍNH TIỀN HOÀN LẠI
-- Tiền hoàn = Tiền cọc - Phí trễ - Phí hư hỏng
-- =========================================

SELECT
    rental_id,
    customer_name,
    security_deposit,
    late_fee,
    damage_fee,
    (
        security_deposit
        - COALESCE(late_fee, 0)
        - COALESCE(damage_fee, 0)
    ) AS refund_amount
FROM Rentals
WHERE rental_id = 1;

-- Kết quả:
-- security_deposit = 10000000
-- late_fee = 0
-- damage_fee = 2000000
-- refund_amount = 8000000