# Consistency Report - HealthSync

## Phân tích sự không nhất quán giữa nghiệp vụ và cơ sở dữ liệu cũ

Cơ sở dữ liệu Legacy của HealthSync chưa đáp ứng đầy đủ quy trình nghiệp vụ được mô tả trong Activity Diagram.

### 1. Trạng thái lịch hẹn

Bảng Appointments cũ sử dụng cột `is_active` kiểu Boolean. Cách thiết kế này chỉ biểu diễn được hai trạng thái bật/tắt, trong khi nghiệp vụ yêu cầu nhiều trạng thái gồm PENDING, CONFIRMED, CHECKED_IN, COMPLETED và CANCELLED. Vì vậy cần thay thế `is_active` bằng cột `status` sử dụng ENUM.

### 2. Tiền cọc và phí phạt

Thiết kế cũ không có các cột lưu tiền cọc và phí phạt. Điều này khiến hệ thống không thể ghi nhận số tiền bệnh nhân đã đặt cọc cũng như khoản tiền bị phạt khi hủy lịch. Thiết kế mới bổ sung `deposit_amount` và `penalty_fee` với kiểu DECIMAL để đảm bảo độ chính xác khi xử lý tiền.

### 3. Đơn thuốc

Cơ sở dữ liệu cũ hoàn toàn không có bảng lưu đơn thuốc. Vì vậy sau khi lịch hẹn chuyển sang COMPLETED, hệ thống không có nơi lưu thông tin thuốc được bác sĩ kê. Thiết kế mới bổ sung bảng `Prescriptions`, liên kết với `Appointments` thông qua `appointment_id`.

Như vậy, thiết kế mới đã bổ sung các thành phần dữ liệu cần thiết để phản ánh đầy đủ quy trình đặt lịch, xác nhận, khám bệnh, hủy lịch và kê đơn.
