===============================================================================
BÀI TẬP LỚN MÔN HỆ CƠ SỞ DỮ LIỆU - TRƯỜNG ĐẠI HỌC THỦY LỢI
LỚP: 67KTPM2 | NHÓM: 11
ĐỀ TÀI: QUẢN LÝ RẠP CHIẾU PHIM
GIẢNG VIÊN HƯỚNG DẪN: TS. LÊ THỊ TÚ KIÊN
===============================================================================
HỒ SƠ NỘP BÀI: BẢN VẼ THIẾT KẾ GỐC + MÃ NGUỒN CODE SQL SERVER

DANH SÁCH THÀNH VIÊN NHÓM 11:
1. Nguyễn Hoàng Hải - 2551170884 (Nhóm trưởng - Phụ trách Tổng quát đề tài)
2. Nguyễn Xuân Trường - 2551170940 (Phân hệ 1: Lịch chiếu & Phim và Vé & Đặt chỗ)
3. Nguyễn Văn Đức - 2551170879 (Phân hệ 2: Khách hàng và Nhân sự)
4. Cung Thành Trung - 2551170938 (Phân hệ 3: Cơ sở vật chất kỹ thuật và Tài chính)
5. Ngụy Công Vinh - 2551170949 (Phân hệ 4: Marketing & Truyền thông và Đối tác)

===============================================================================
CẤU TRÚC THƯ MỤC FILE NÉN ZIP:
===============================================================================
Nhom11_67KTPM2_BanVeGoc_va_Code/
│
├── 01_Ban_Ve_Goc/
│   ├── DrawIO_Source/                          (File thiết kế gốc chỉnh sửa được trên Draw.io / diagrams.net)
│   │   ├── Luoc_Do_Quan_He_CrowFoot_TongHop_YC3.drawio   (Bản vẽ Crow's Foot 28 bảng toàn hệ thống)
│   │   └── ERD_TongHop_ToanHeThong_YC2.drawio           (Bản vẽ ERD tổng hợp 23 thực thể)
│   └── Anh_Ban_Ve_Do_Net_Cao_PNG/              (Ảnh render sắc nét độ phân giải cao)
│       ├── 01_ERD_TongHop_ToanHeThong_YC2.png
│       ├── 02_Luoc_Do_Quan_He_CrowFoot_TongHop_YC3.png
│       ├── 03_ERD_PhanHe1_LichChieu_VeDatCho.png
│       ├── 04_LuocDoQuanHe_PhanHe1.png
│       ├── 05_ERD_PhanHe2_NhanSu_VanHanh.png
│       ├── 06_ERD_PhanHe2_KhachHang_KinhDoanh.png
│       ├── 07_ERD_PhanHe3_CoSoVatChat_KyThuat.png
│       └── 08_ERD_PhanHe3_TaiChinh.png
│
├── 02_Code_SQL_Server/
│   ├── 00_Master_Script_Tao_CSDL_Va_28Bang_TongHop.sql  (Kịch bản DDL chuẩn 3NF tích hợp toàn bộ hệ thống)
│   ├── 01_PhanHe1_LichChieu_VeDatCho_NguyenXuanTruong.sql (Code SQL tạo bảng, insert dữ liệu & 5 câu truy vấn của Trường)
│   ├── 02_PhanHe2_KhachHang_NhanSu_NguyenVanDuc.sql       (Code SQL tạo bảng, insert dữ liệu, 3 View & 5 câu truy vấn của Đức)
│   ├── 03_PhanHe3_TaiChinh_CoSoVatChat_CungThanhTrung.sql (Code SQL tạo bảng, insert dữ liệu & 5 câu truy vấn của Trung)
│   ├── 04_PhanHe4_Marketing_DoiTac_NguyCongVinh.sql       (Code SQL tạo bảng, insert dữ liệu & 5 câu truy vấn của Vinh)
│   └── 05_TongHop_20_CauTruyVan_SQL_Va_DSQH.sql         (Tổng hợp toàn bộ 20 câu truy vấn kèm ĐSQH & SQL của 4 phân hệ)
│
├── 03_Tai_Lieu_Bao_Cao/
│   ├── Nhom11_67KTPM2_BTL_CSDL_HoanChinh.docx           (File báo cáo Word hoàn chỉnh chuẩn form 105 trang)
│   └── Nhom11_67KTPM2_BTL_CSDL_HoanChinh.pdf            (File PDF xuất từ báo cáo để đối chiếu nhanh)
│
└── README_HuongDan_Nhom11.txt                           (Tài liệu hướng dẫn này)

===============================================================================
HƯỚNG DẪN MỞ BẢN VẼ GỐC TRÊN DRAW.IO (APP.DIAGRAMS.NET):
===============================================================================
1. Truy cập trang web https://app.diagrams.net/ (hoặc mở phần mềm Diagrams.net trên máy tính, hoặc extension Draw.io trên VS Code).
2. Chọn "Open Existing Diagram" (Mở biểu đồ hiện có).
3. Duyệt đến thư mục `01_Ban_Ve_Goc/DrawIO_Source/` và chọn một trong hai file:
   - `Luoc_Do_Quan_He_CrowFoot_TongHop_YC3.drawio`
   - `ERD_TongHop_ToanHeThong_YC2.drawio`
4. Toàn bộ các bảng, thực thể, đường kết nối Crow's Foot / mối kết hợp và màu sắc theo phân hệ đều có thể click chỉnh sửa, di chuyển và xuất ảnh (Export As PNG/PDF/SVG) tùy ý.

===============================================================================
HƯỚNG DẪN THỰC THI CODE SQL TRÊN SQL SERVER MANAGEMENT STUDIO (SSMS):
===============================================================================
Cách 1 - Chạy kịch bản tích hợp toàn hệ thống (Khuyên dùng):
  1. Mở file `00_Master_Script_Tao_CSDL_Va_28Bang_TongHop.sql` trong SSMS.
  2. Nhấn phím F5 (Execute) để khởi tạo CSDL `QL_RapChieuPhim_TongHop`, 28 bảng chuẩn 3NF và các View tính toán.
  3. Mở file `05_TongHop_20_CauTruyVan_SQL_Va_DSQH.sql` và nhấn F5 để chạy kiểm thử toàn bộ 20 câu truy vấn.

Cách 2 - Chạy kịch bản độc lập của từng phân hệ:
  - Mở lần lượt các file `01_...`, `02_...`, `03_...`, `04_...` để tạo CSDL con và nạp dữ liệu mẫu của từng thành viên.
