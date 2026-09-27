# AI Prompt Log - AutoRide

## Prompt 1 - Kiểu dữ liệu tài chính

**Câu hỏi:**

Trong MySQL, khi lưu tiền cọc, phí phạt và phí sửa chữa thì nên sử dụng FLOAT hay DECIMAL? Vì sao?

**Mục đích:**

Tìm hiểu kiểu dữ liệu phù hợp cho dữ liệu tài chính.

**Kết quả áp dụng:**

Sử dụng DECIMAL(10,2) cho:

- security_deposit
- late_fee
- damage_fee

DECIMAL phù hợp với dữ liệu tiền tệ và hạn chế sai số số thực.

---

## Prompt 2 - Quan hệ Inspections

**Câu hỏi:**

Trong hệ thống cho thuê xe, bảng Inspections nên có quan hệ 1-1 hay 1-N với Rentals?

**Mục đích:**

Phân tích cách thiết kế bảng kiểm tra xe.

**Kết quả áp dụng:**

Thiết kế 1-N giúp hệ thống có thể lưu nhiều lần kiểm tra cho một hợp đồng, ví dụ kiểm tra lúc nhận xe và kiểm tra lúc trả xe.

Nếu nghiệp vụ chỉ cho phép đúng một biên bản kiểm tra cho mỗi hợp đồng thì có thể thêm UNIQUE(rental_id) để tạo quan hệ 1-1.

---

## Prompt 3 - ENUM

**Câu hỏi:**

Lợi ích của việc sử dụng ENUM thay cho VARCHAR để lưu trạng thái hợp đồng trong MySQL là gì?

**Mục đích:**

Đảm bảo trạng thái chỉ nhận các giá trị hợp lệ.

**Kết quả áp dụng:**

Sử dụng:

BOOKED, ACTIVE, COMPLETED, CANCELLED.

---

## Prompt 4 - NULL trong phép tính tiền

**Câu hỏi:**

Nếu late_fee hoặc damage_fee có giá trị NULL thì phép tính tiền hoàn lại trong MySQL có thể xảy ra vấn đề gì?

**Mục đích:**

Đảm bảo phép tính tiền hoàn lại luôn cho kết quả chính xác.

**Kết quả áp dụng:**

Sử dụng COALESCE để thay thế NULL bằng 0:

security_deposit - COALESCE(late_fee, 0) - COALESCE(damage_fee, 0)

---

## Prompt 5 - Database Normalization

**Câu hỏi:**

Tại sao nên tách thông tin kiểm tra xe thành bảng Inspections thay vì thêm damage_description trực tiếp vào Rentals?

**Mục đích:**

Tìm hiểu cách tránh lặp dữ liệu và thiết kế bảng có khả năng mở rộng.

**Kết quả áp dụng:**

Tách Inspections giúp lưu được nhiều lần kiểm tra cho một hợp đồng và giữ bảng Rentals tập trung vào thông tin của hợp đồng.
