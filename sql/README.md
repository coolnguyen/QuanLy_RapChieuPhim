# Script SQL Server

Chỉ lưu script .sql và hướng dẫn chạy; không đưa file database .mdf, .ndf, .ldf hoặc .bak lên repo.

Giai đoạn YC1–YC2 chưa cần viết SQL. Khi triển khai, mỗi người lưu phần của mình theo tên nhánh, ví dụ lich-chieu.sql; ghi đầu file tác giả, chức năng và điều kiện cần trước khi chạy.

Nhóm thống nhất tên bảng, khóa chính, khóa ngoại. Người tích hợp ghi thứ tự chạy tại đây: tạo database → tạo bảng theo quan hệ phụ thuộc → thêm dữ liệu mẫu → chạy truy vấn. Thứ tự chi tiết sẽ chốt khi có mô hình.

Pull chỉ lấy file về máy, không chạy SQL và không thay đổi database trong SQL Server. Đọc nội dung script trước khi chạy, nhất là lệnh xóa hoặc tạo lại dữ liệu. Không ghi mật khẩu kết nối trong script.
