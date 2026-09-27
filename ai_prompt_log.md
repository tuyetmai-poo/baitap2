# AI Prompt Log - HealthSync

## Prompt 1 - Thiết kế trạng thái

**Câu hỏi:**

Trong thiết kế cơ sở dữ liệu quan hệ, tại sao việc dùng một cột Boolean để theo dõi vòng đời của một lịch hẹn là không phù hợp? Nên thay thế bằng cấu trúc nào?

**Mục đích:**

Tìm hiểu cách biểu diễn nhiều trạng thái của một lịch hẹn trong MySQL.

**Kết quả áp dụng:**

Sử dụng ENUM với các trạng thái:

- PENDING
- CONFIRMED
- CHECKED_IN
- COMPLETED
- CANCELLED

---

## Prompt 2 - Kiểu dữ liệu tiền

**Câu hỏi:**

Khi thiết kế cột deposit_amount và penalty_fee trong MySQL, nên sử dụng FLOAT, DOUBLE hay DECIMAL? Vì sao?

**Mục đích:**

Tìm hiểu cách lưu trữ dữ liệu tài chính chính xác.

**Kết quả áp dụng:**

Sử dụng DECIMAL(12,2) cho tiền cọc và phí phạt vì DECIMAL phù hợp với dữ liệu tài chính và tránh các vấn đề sai số do số thực dấu phẩy động.

---

## Prompt 3 - ALTER TABLE

**Câu hỏi:**

Cú pháp MySQL để xóa cột is_active và thêm cột status kiểu ENUM vào bảng Appointments có sẵn là gì?

**Mục đích:**

Ôn lại cách thay đổi cấu trúc bảng mà không cần tạo lại toàn bộ database.

**Kết quả áp dụng:**

Sử dụng ALTER TABLE để DROP COLUMN và ADD COLUMN khi cần tái cấu trúc bảng.

---

## Prompt 4 - Khóa ngoại

**Câu hỏi:**

Làm thế nào để thiết lập quan hệ giữa bảng Appointments và Prescriptions bằng khóa ngoại?

**Mục đích:**

Đảm bảo đơn thuốc luôn tham chiếu đến một lịch hẹn hợp lệ.

**Kết quả áp dụng:**

Bảng Prescriptions sử dụng `appointment_id` làm FOREIGN KEY tham chiếu đến `Appointments(appointment_id)`.

---

## Prompt 5 - JOIN kiểm tra dữ liệu

**Câu hỏi:**

Viết câu lệnh SELECT JOIN giữa Appointments và Prescriptions để lấy danh sách bệnh nhân đã hoàn tất khám và thông tin đơn thuốc.

**Mục đích:**

Kiểm tra dữ liệu sau khi triển khai cơ sở dữ liệu.

**Kết quả áp dụng:**

Sử dụng JOIN giữa Appointments, Patients, Doctors và Prescriptions với điều kiện status = COMPLETED.
