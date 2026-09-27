# ERD - Activity Diagram Mapping

## Data Gaps trong thiết kế cũ

Cơ sở dữ liệu Legacy chưa phản ánh đầy đủ quy trình thuê và trả xe trong Activity Diagram.

### 1. Thiếu tiền cọc

Quy trình yêu cầu khách hàng phải đóng Security Deposit nhưng bảng Rentals không có cột lưu tiền cọc. Vì vậy hệ thống không thể xác định số tiền ban đầu dùng để tính tiền hoàn lại.

### 2. Thiếu phí phạt và phí sửa chữa

Khi khách trả xe trễ hoặc xe bị hư hỏng, hệ thống phải ghi nhận các khoản phí tương ứng. Nếu không có `late_fee` và `damage_fee`, hệ thống không thể tính chính xác số tiền hoàn lại.

### 3. Thiếu bảng kiểm tra xe

Activity Diagram có bước nhân viên kiểm tra tình trạng xe nhưng database cũ không có bảng Inspections. Do đó không thể lưu chi tiết hư hỏng và người thực hiện kiểm tra.

### Kết luận

`damage_fee` là dữ liệu bắt buộc vì nó đại diện cho khoản chi phí phát sinh khi xe bị hư hỏng. Công thức hoàn tiền là:

`security_deposit - late_fee - damage_fee`

Do đó nếu thiếu `damage_fee`, hệ thống có thể hoàn sai tiền cho khách hàng.
