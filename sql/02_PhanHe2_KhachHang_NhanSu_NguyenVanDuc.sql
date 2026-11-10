-- ===============================================================================
-- PHÂN HỆ 2: QUẢN LÝ KHÁCH HÀNG VÀ NHÂN SỰ
-- Thành viên thực hiện: Nguyễn Văn Đức
-- ===============================================================================

CREATE DATABASE RAP_CHIEU_PHIM;
GO
USE RAP_CHIEU_PHIM;
GO

-- 1. Bảng CHI_NHANH
CREATE TABLE CHI_NHANH (
    MA_CN VARCHAR(10) PRIMARY KEY,
    TEN_CN NVARCHAR(100) NOT NULL,
    DIA_CHI NVARCHAR(200) NOT NULL,
    SDT VARCHAR(15) NOT NULL
);

-- 2. Bảng BO_PHAN
CREATE TABLE BO_PHAN (
    MA_BP VARCHAR(10) PRIMARY KEY,
    TEN_BP NVARCHAR(100) NOT NULL,
    MO_TA NVARCHAR(200),
    MA_CN VARCHAR(10) NULL FOREIGN KEY REFERENCES CHI_NHANH(MA_CN)
);

-- 3. Bảng NHAN_SU
CREATE TABLE NHAN_SU (
    MA_NS VARCHAR(10) PRIMARY KEY,
    HO_TEN NVARCHAR(100) NOT NULL,
    GIOI_TINH NVARCHAR(10),
    NGAY_SINH DATE,
    SDT VARCHAR(15) NOT NULL,
    CHUC_VU NVARCHAR(50) NOT NULL,
    LUONG DECIMAL(12,2) NOT NULL,
    MA_BP VARCHAR(10) NOT NULL FOREIGN KEY REFERENCES BO_PHAN(MA_BP),
    MA_QL VARCHAR(10) NULL FOREIGN KEY REFERENCES NHAN_SU(MA_NS)
);

-- 4. Bảng KHACH_HANG
CREATE TABLE KHACH_HANG (
    MA_KH VARCHAR(10) PRIMARY KEY,
    HO_TEN NVARCHAR(100) NOT NULL,
    SDT VARCHAR(15) NOT NULL UNIQUE,
    EMAIL VARCHAR(100),
    NGAY_DANG_KY DATE NOT NULL,
    HANG_THANH_VIEN NVARCHAR(30) DEFAULT N'Đồng'
);

-- 5. Bảng DIEM_TICH_LUY
CREATE TABLE DIEM_TICH_LUY (
    MA_GIAO_DICH VARCHAR(10) PRIMARY KEY,
    MA_KH VARCHAR(10) NOT NULL FOREIGN KEY REFERENCES KHACH_HANG(MA_KH),
    NGAY_GIAO_DICH DATE NOT NULL,
    DIEM_THAY_DOI INT NOT NULL,
    LY_DO NVARCHAR(100)
);

-- 6. Bảng SAN_PHAM
CREATE TABLE SAN_PHAM (
    MA_SP VARCHAR(10) PRIMARY KEY,
    TEN_SP NVARCHAR(100) NOT NULL,
    LOAI_SP NVARCHAR(50),
    DON_GIA DECIMAL(10,2) NOT NULL
);

-- 7. Bảng KHO_CHI_NHANH
CREATE TABLE KHO_CHI_NHANH (
    MA_CN VARCHAR(10) NOT NULL FOREIGN KEY REFERENCES CHI_NHANH(MA_CN),
    MA_SP VARCHAR(10) NOT NULL FOREIGN KEY REFERENCES SAN_PHAM(MA_SP),
    SO_LUONG_TON INT NOT NULL CHECK (SO_LUONG_TON >= 0),
    PRIMARY KEY (MA_CN, MA_SP)
);
GO

- YC5 (tiếp): NHẬP DỮ LIỆU MẪU CHO CSDL RAP_CHIEU_PHIM
- Chạy sau YC5_CREATE_DB.sql
USE RAP_CHIEU_PHIM;
GO
- 1. CHI NHÁNH: 2 cơ sở
INSERT INTO CHI_NHANH VALUES
(N'CN01', N'Rạp Sao Vàng – Hà Nội',   N'25 Minh Khai, Hai Bà Trưng, Hà Nội',  N'0243123456'),
(N'CN02', N'Rạp Sao Vàng – Hải Phòng', N'1 Lạch Tray, Ngô Quyền, Hải Phòng',   N'0225123456');
- 2. BỘ PHẬN: 4 bộ phận (BP04 thuộc văn phòng, chưa gắn chi nhánh -> MA_CN NULL)
INSERT INTO BO_PHAN VALUES
(N'BP01', N'Kế toán',    N'Quản lý thu chi, hóa đơn',        N'CN01'),
(N'BP02', N'Ca chiếu',   N'Vận hành phòng chiếu, in vé',     N'CN01'),
(N'BP03', N'Bán hàng',   N'Quầy F&B và quầy vé',             N'CN02'),
(N'BP04', N'Quản trị',   N'Văn phòng tổng công ty',          NULL);
- 3. NHÂN SỰ: 6 nhân viên (không còn MA_CN — đạt 3NF, chi nhánh suy ra qua bộ phận)
INSERT INTO NHAN_SU VALUES
(N'NS01', N'Trần Văn An',   '1995-04-12', N'Nam',  N'0901111111', 'an.tv@saovang.vn',   N'Hà Nội',  	N'Kế toán viên',  9000000,  N'BP01'),
(N'NS02', N'Lê Thị Bình',   '1998-09-03', N'Nữ',   N'0902222222', 'binh.lt@saovang.vn', N'Hà Nội',  	N'Thu ngân',  	7500000,  N'BP02'),
(N'NS03', N'Phạm Văn Cường','1993-01-25', N'Nam',  N'0903333333', 'cuong.pv@saovang.vn',N'Hải Phòng',   N'Trưởng ca chiếu',11000000, N'BP02'),
(N'NS04', N'Hoàng Thị Dung','1999-11-17', N'Nữ',   N'0904444444', 'dung.ht@saovang.vn', N'Hải Phòng',   N'Nhân viên bán hàng',7000000,N'BP03'),
(N'NS05', N'Ngô Văn Em',    '1996-06-08', N'Nam',  N'0905555555', 'em.nv@saovang.vn',   N'Hà Nội',  	N'Nhân viên bán hàng',7000000,N'BP03'),
(N'NS06', N'Vũ Thị Hoa',    '1990-03-30', N'Nữ',   N'0906666666', 'hoa.vt@saovang.vn',  N'Hà Nội',  	N'Giám đốc',  	20000000, N'BP04');
- 4. KHÁCH HÀNG: 6 khách (KH01, KH02, KH05 là VIP; KH06 chưa mua vé để phục vụ truy vấn)
INSERT INTO KHACH_HANG VALUES
(N'KH01', N'Đặng Văn Nhất',  '1994-02-14', N'Nam', N'0911111111', 'nhat.dv@gmail.com', N'Hà Nội',	N'VIP'),
(N'KH02', N'Bùi Thị Nhị',    '1997-07-22', N'Nữ',  N'0922222222', 'nhi.bt@gmail.com',  N'Hà Nội',	N'VIP'),
(N'KH03', N'Đỗ Văn Ba',      '2000-10-05', N'Nam', N'0933333333', 'ba.dv@gmail.com',   N'Hải Phòng', N'Thường'),
(N'KH04', N'Nguyen Thi Bon', '1999-12-19', N'Nữ',  N'0944444444', 'bon.nt@gmail.com',  N'Hải Phòng', N'Thường'),
(N'KH05', N'Lý Văn Năm',     '1992-05-11', N'Nam', N'0955555555', 'nam.lv@gmail.com',  N'Hà Nội',    N'VIP'),
(N'KH06', N'Trần Thị Sáu',   '2001-08-27', N'Nữ',  N'0966666666', 'sau.tt@gmail.com',  N'Hà Nội',	N'Thường');
- 5. ĐIỂM TÍCH LŨY: lịch sử cộng/trừ điểm (KH06 không có bản ghi nào)
INSERT INTO DIEM_TICH_LUY VALUES
(N'DI01', N'KH01', 300, '2026-09-01 20:10', N'Tích lũy'),
(N'DI02', N'KH01', 100, '2026-09-20 19:05', N'Sử dụng'),
(N'DI03', N'KH01', 250, '2026-10-02 20:00', N'Tích lũy'),
(N'DI04', N'KH02', 400, '2026-09-05 18:40', N'Tích lũy'),
(N'DI05', N'KH02', 150, '2026-09-28 21:10', N'Sử dụng'),
(N'DI06', N'KH03', 120, '2026-10-05 17:30', N'Tích lũy'),
(N'DI07', N'KH05', 500, '2026-09-12 20:30', N'Tích lũy'),
(N'DI08', N'KH05', 200, '2026-10-08 19:20', N'Sử dụng');
- 6. SẢN PHẨM: 6 mặt hàng (bắp, nước, lưu niệm)
INSERT INTO SAN_PHAM VALUES
(N'SP01', N'Bắp lớn',      	N'Bắp',   	60000),
(N'SP02', N'Bắp nhỏ caramel',  N'Bắp',       40000),
(N'SP03', N'Pepsi 500ml',  	N'Nước',  	25000),
(N'SP04', N'Soda caramel', 	N'Nước',  	30000),
(N'SP05', N'Gấu bông logo',	N'Lưu niệm',  90000),
(N'SP06', N'Ly giữ nhiệt', 	N'Lưu niệm', 120000);
- 7. KHO CHI NHÁNH: tồn kho theo từng cặp (chi nhánh, sản phẩm)
INSERT INTO KHO_CHI_NHANH VALUES
(N'CN01', N'SP01', 100), (N'CN01', N'SP02', 80), (N'CN01', N'SP03', 200),
(N'CN01', N'SP04', 50),  (N'CN01', N'SP05', 10),  (N'CN01', N'SP06', 5),
(N'CN02', N'SP01', 60),  (N'CN02', N'SP03', 120), (N'CN02', N'SP04', 40),
(N'CN02', N'SP05', 8),   (N'CN02', N'SP06', 3);
- 8. LOẠI GHẾ: 3 loại
INSERT INTO LOAI_GHE VALUES
(N'LG01', N'Ghế thường', 0),
(N'LG02', N'Ghế VIP',    30000),
(N'LG03', N'Ghế đôi',    50000);
- 9. SUẤT CHIẾU: 6 suất tại 2 chi nhánh (tên phim hư cấu)
INSERT INTO SUAT_CHIEU VALUES
(N'SC01', N'CN01', N'Mưa Sao Băng',    	'2026-10-02 20:00', 90000),
(N'SC02', N'CN01', N'Hành Tinh X',     	'2026-10-03 18:30', 110000),
(N'SC03', N'CN01', N'Cơm Tấm Ơi',      	'2026-10-02 21:00', 90000),
(N'SC04', N'CN02', N'Mưa Sao Băng',    	'2026-10-04 19:00', 80000),
(N'SC05', N'CN02', N'Điệp Vụ Màn Đêm', 	'2026-10-04 20:30', 100000),
(N'SC06', N'CN02', N'Cơm Tấm Ơi',      	'2026-10-05 17:00', 80000);
- 10. HÓA ĐƠN TỔNG: 8 hóa đơn (HD08 chưa thanh toán, không có chi tiết;
- 	MA_NS NULL với hóa đơn khách tự đặt online)
INSERT INTO HOA_DON_TONG VALUES
(N'HD01', N'KH01', N'NS02', '2026-10-02 19:45', N'Đã thanh toán'),
(N'HD02', N'KH01', N'NS02', '2026-10-04 18:50', N'Một phần'),
(N'HD03', N'KH02', N'NS03', '2026-10-03 18:00', N'Đã thanh toán'),
(N'HD04', N'KH03', N'NS01', '2026-10-05 16:40', N'Đã thanh toán'),
(N'HD05', N'KH05', N'NS02', '2026-10-04 20:10', N'Đã thanh toán'),
(N'HD06', N'KH02', N'NS04', '2026-10-02 20:45', N'Một phần'),
(N'HD07', N'KH04', NULL,     '2026-10-03 17:55', N'Đã thanh toán'),
(N'HD08', N'KH06', NULL,     '2026-10-06 10:00', N'Chưa thanh toán');
- 11. THANH TOÁN: 8 giao dịch (HD02 trả làm 2 lần -> minh họa 1:N với hóa đơn)
INSERT INTO THANH_TOAN VALUES
(N'TT01', N'HD01', N'Tiền mặt',	230000, '2026-10-02 19:46'),
(N'TT02', N'HD02', N'MOMO',    	90000,  '2026-10-04 18:52'),
(N'TT03', N'HD02', N'VNPAY',   	120000, '2026-10-04 19:10'),
(N'TT04', N'HD03', N'Chuyển khoản',150000, '2026-10-03 18:05'),
(N'TT05', N'HD04', N'MOMO',    	100000, '2026-10-05 16:42'),
(N'TT06', N'HD05', N'VNPAY',   	340000, '2026-10-04 20:12'),
(N'TT07', N'HD06', N'Tiền mặt',	60000,  '2026-10-02 20:47'),
(N'TT08', N'HD07', N'VNPAY',   	140000, '2026-10-03 17:58');
- 12. CHI TIẾT HÓA ĐƠN SẢN PHẨM (THANH_TIEN không lưu — suy ra qua VIEW)
INSERT INTO CT_HD_SAN_PHAM VALUES
(N'HD01', N'SP01', 2), (N'HD01', N'SP03', 3),
(N'HD02', N'SP02', 1), (N'HD02', N'SP05', 1),
(N'HD03', N'SP01', 1), (N'HD03', N'SP04', 2),
(N'HD04', N'SP03', 4),
(N'HD05', N'SP06', 1), (N'HD05', N'SP01', 2),
(N'HD06', N'SP02', 3),
(N'HD07', N'SP04', 2);
- 13. VÉ: 10 vé (VE04, VE10 đã hủy chưa gộp hóa đơn; KH06 không có vé)
INSERT INTO VE VALUES
(N'VE01', N'SC01', N'LG01', N'KH01', N'A1',  N'Đã in',   N'HD01'),
(N'VE02', N'SC01', N'LG02', N'KH01', N'B1',  N'Đã in',   N'HD01'),
(N'VE03', N'SC02', N'LG01', N'KH02', N'A5',  N'Đã đặt',  N'HD03'),
(N'VE04', N'SC04', N'LG01', N'KH03', N'A7',  N'Đã hủy',  NULL),
(N'VE05', N'SC05', N'LG02', N'KH05', N'C3',  N'Đã in',   N'HD05'),
(N'VE06', N'SC05', N'LG03', N'KH05', N'D1',  N'Đã in',   N'HD05'),
(N'VE07', N'SC03', N'LG01', N'KH02', N'A9',  N'Đã đặt',  N'HD06'),
(N'VE08', N'SC02', N'LG02', N'KH04', N'B7',  N'Đã đặt',  N'HD07'),
(N'VE09', N'SC04', N'LG01', N'KH01', N'A2',  N'Đã in',   N'HD02'),
(N'VE10', N'SC06', N'LG01', N'KH03', N'A10', N'Đã hủy',  NULL);
GO
- KIỂM TRA: xem nhanh số dòng mỗi bảng
SELECT 'CHI_NHANH' AS BANG, COUNT(*) AS SO_DONG FROM CHI_NHANH
UNION ALL SELECT 'BO_PHAN', COUNT(*) FROM BO_PHAN
UNION ALL SELECT 'NHAN_SU', COUNT(*) FROM NHAN_SU
UNION ALL SELECT 'KHACH_HANG', COUNT(*) FROM KHACH_HANG
UNION ALL SELECT 'DIEM_TICH_LUY', COUNT(*) FROM DIEM_TICH_LUY
UNION ALL SELECT 'SAN_PHAM', COUNT(*) FROM SAN_PHAM
UNION ALL SELECT 'KHO_CHI_NHANH', COUNT(*) FROM KHO_CHI_NHANH
UNION ALL SELECT 'HOA_DON_TONG', COUNT(*) FROM HOA_DON_TONG
UNION ALL SELECT 'THANH_TOAN', COUNT(*) FROM THANH_TOAN
UNION ALL SELECT 'CT_HD_SAN_PHAM', COUNT(*) FROM CT_HD_SAN_PHAM
UNION ALL SELECT 'LOAI_GHE', COUNT(*) FROM LOAI_GHE
UNION ALL SELECT 'SUAT_CHIEU', COUNT(*) FROM SUAT_CHIEU
UNION ALL SELECT 'VE', COUNT(*) FROM VE;
- Kiểm tra VIEW tổng tiền hóa đơn
SELECT * FROM V_TONG_HOA_DON ORDER BY MA_HD;
Yêu cầu 6:
 CSDL: RAP_CHIEU_PHIM — mỗi thành viên 5 câu hỏi
Kí hiệu ĐSQH: π phép chiếu, σ phép chọn, ⋈ phép kết nối tự nhiên, ρ phép đổi tên, − phép hiệu, Γ nhóm và gộp (GROUP BY kèm hàm kết tập).
Phân loại theo yêu cầu đề bài:
 Câu 1 của mỗi thành viên: truy vấn điều kiện trên một bảng
 Câu 2, 3: truy vấn trên nhiều bảng
 Câu 4: truy vấn tính tổng / kết tập
 Câu 5: truy vấn lồng
 TV1.1 — Cho biết mã, họ tên, số điện thoại của những khách hàng là thành viên VIP.
 TV1.2 — Liệt kê họ tên nhân viên và tên bộ phận mà họ đang làm việc.
 TV1.3 — Cho biết mã vé, tên chi nhánh và tên phim của các vé đã in (in tại chi nhánh nào, xem phim gì).
 TV1.4 — Mỗi khách hàng đã mua bao nhiêu vé? Cho biết mã KH, họ tên và số vé.
 TV1.5 — Tìm những khách hàng đã từng thanh toán hóa đơn bằng ví MOMO.