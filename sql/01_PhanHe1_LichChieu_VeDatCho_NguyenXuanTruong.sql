-- ===============================================================================
-- PHÂN HỆ 1: QUẢN LÝ LỊCH CHIẾU & PHIM VÀ VÉ & ĐẶT CHỖ
-- Thành viên thực hiện: Nguyễn Xuân Trường
-- ===============================================================================

CREATE DATABASE QuanLyRapChieuPhim;
GO
USE QuanLyRapChieuPhim;
GO
-- 1. Bảng PHIM
CREATE TABLE PHIM (
    MaPhim VARCHAR(10) PRIMARY KEY,
    TenPhim NVARCHAR(100) NOT NULL,
    TheLoai NVARCHAR(50),
    DaoDien NVARCHAR(100),
    DienVien NVARCHAR(200),
    ThoiLuong INT -- Tính bằng phút
);
-- 2. Bảng SUATCHIEU
CREATE TABLE SUATCHIEU (
    MaSuatChieu VARCHAR(10) PRIMARY KEY,
    NgayChieu DATE NOT NULL,
    GioChieu TIME NOT NULL,
    GiaVeSuat DECIMAL(10, 0) NOT NULL,
    PhongChieu NVARCHAR(20) NOT NULL,
    MaPhim VARCHAR(10) NOT NULL,
    FOREIGN KEY (MaPhim) REFERENCES PHIM(MaPhim)
);
-- 3. Bảng KHACHHANG
CREATE TABLE KHACHHANG (
    MaKH VARCHAR(10) PRIMARY KEY,
    TenKH NVARCHAR(100) NOT NULL,
    SoDienThoai VARCHAR(15),
    Email VARCHAR(100),
    DiaChi NVARCHAR(200)
);
-- 4. Bảng GHE
CREATE TABLE GHE (
    MaGhe VARCHAR(10) PRIMARY KEY,
    HangGhe CHAR(2) NOT NULL,
    SoGhe INT NOT NULL,
    LoaiGhe NVARCHAR(30) -- Thường / VIP
);
-- 5. Bảng THANHTOAN
CREATE TABLE THANHTOAN (
    MaThanhToan VARCHAR(10) PRIMARY KEY,
    SoTien DECIMAL(10, 0) NOT NULL,
    PhuongThucThanhToan NVARCHAR(30) NOT NULL, -- Tiền mặt / Thẻ / Online
    ThoiGian DATETIME NOT NULL,
    TrangThai NVARCHAR(30)
);
-- 6. Bảng VE
CREATE TABLE VE (
    MaVe VARCHAR(10) PRIMARY KEY,
    LoaiVe NVARCHAR(30) NOT NULL, -- Thường / Ưu tiên
    DoiTuong NVARCHAR(30) NOT NULL, -- Người lớn / Trẻ em
    GiaVe DECIMAL(10, 0) NOT NULL,
    TrangThai NVARCHAR(30),
    MaSuatChieu VARCHAR(10) NOT NULL,
    MaKH VARCHAR(10) NOT NULL,
    MaGhe VARCHAR(10) NOT NULL,
    MaThanhToan VARCHAR(10) NOT NULL,
    FOREIGN KEY (MaSuatChieu) REFERENCES SUATCHIEU(MaSuatChieu),
    FOREIGN KEY (MaKH) REFERENCES KHACHHANG(MaKH),
    FOREIGN KEY (MaGhe) REFERENCES GHE(MaGhe),
    FOREIGN KEY (MaThanhToan) REFERENCES THANHTOAN(MaThanhToan)
);
GO
-- ================= NHẬP DỮ LIỆU MẪU =================
INSERT INTO PHIM VALUES
('P01', N'Mai', N'Tâm lý, Tình cảm', N'Trấn Thành', N'Phương Anh Đào, Tuấn Trần', 131),
('P02', N'Đào, Phở và Piano', N'Lịch sử', N'Phi Tiến Sơn', N'Doãn Quốc Đam, Cao Thị Thùy Linh', 100),
('P03', N'Lật Mặt 7: Một Điều Ước', N'Gia đình', N'Lý Hải', N'Thanh Hiền, Trương Minh Cường', 138),
('P04', N'Dune: Hành Tinh Cát 2', N'Khoa học viễn tưởng', N'Denis Villeneuve', N'Timothée Chalamet, Zendaya', 166);
INSERT INTO SUATCHIEU VALUES
('SC01', '2026-10-25', '18:00:00', 90000, N'Phòng 01', 'P01'),
('SC02', '2026-10-25', '20:30:00', 100000, N'Phòng 02', 'P01'),
('SC03', '2026-10-26', '19:00:00', 80000, N'Phòng 01', 'P02'),
('SC04', '2026-10-26', '21:00:00', 110000, N'Phòng 03', 'P03');
INSERT INTO KHACHHANG VALUES
('KH01', N'Nguyễn Văn An', '0901234567', 'an.nv@gmail.com', N'Đống Đa, Hà Nội'),
('KH02', N'Trần Thị Bình', '0912345678', 'binh.tt@gmail.com', N'Cầu Giấy, Hà Nội'),
('KH03', N'Lê Hoàng Nam', '0987654321', 'nam.lh@gmail.com', N'Thanh Xuân, Hà Nội');
INSERT INTO GHE VALUES
('G01', 'A', 1, N'Thường'),
('G02', 'A', 2, N'Thường'),
('G03', 'B', 5, N'VIP'),
('G04', 'B', 6, N'VIP');
INSERT INTO THANHTOAN VALUES
('TT01', 180000, N'Online', '2026-10-24 14:30:00', N'Thành công'),
('TT02', 80000, N'Tiền mặt', '2026-10-25 18:45:00', N'Thành công'),
('TT03', 110000, N'Thẻ', '2026-10-25 20:15:00', N'Thành công');
INSERT INTO VE VALUES
('V01', N'Thường', N'Người lớn', 90000, N'Đã thanh toán', 'SC01', 'KH01', 'G01', 'TT01'),
('V02', N'Thường', N'Người lớn', 90000, N'Đã thanh toán', 'SC01', 'KH01', 'G02', 'TT01'),
('V03', N'Ưu tiên', N'Trẻ em', 80000, N'Đã thanh toán', 'SC03', 'KH02', 'G03', 'TT02'),
('V04', N'Thường', N'Người lớn', 110000, N'Đã thanh toán', 'SC04', 'KH03', 'G04', 'TT03');
GO
Yêu cầu 6:
Câu 1: Truy vấn có điều kiện trên một bảng
Đề bài: Cho biết mã phim, tên phim và đạo diễn của các bộ phim có thời lượng lớn hơn 120 phút.
Đại số quan hệ (ĐSQH): π MaPhim, TenPhim, DaoDien (σ ThoiLuong > 120 (PHIM))
SQL:
SQL
SELECT MaPhim, TenPhim, DaoDien
FROM PHIM
WHERE ThoiLuong > 120;
Câu 2: Truy vấn trên nhiều bảng (1)
Đề bài: Liệt kê mã suất chiếu, tên phim, ngày chiếu, giờ chiếu và phòng chiếu của tất cả các suất chiếu trong ngày '2026-10-25'.
Đại số quan hệ (ĐSQH): π MaSuatChieu, TenPhim, NgayChieu, GioChieu, PhongChieu (σ NgayChieu = '2026-10-25' (SUATCHIEU) |><| PHIM) (Nếu dùng phông Cambria Math hoặc Arial Unicode:) π MaSuatChieu, TenPhim, NgayChieu, GioChieu, PhongChieu (σ NgayChieu = '2026-10-25' (SUATCHIEU) ⋈ PHIM)
SQL:
SQL
SELECT SC.MaSuatChieu, P.TenPhim, SC.NgayChieu, SC.GioChieu, SC.PhongChieu
FROM SUATCHIEU SC
JOIN PHIM P ON SC.MaPhim = P.MaPhim
WHERE SC.NgayChieu = '2026-10-25';
Câu 3: Truy vấn trên nhiều bảng (2)
Đề bài: Cho biết tên khách hàng, số điện thoại, mã vé, hàng ghế, số ghế và giá vé của các khách hàng đã đặt vé thuộc đối tượng 'Người lớn'.
Đại số quan hệ (ĐSQH): π TenKH, SoDienThoai, MaVe, HangGhe, SoGhe, GiaVe (KHACHHANG |><| σ DoiTuong = N'Người lớn' (VE) |><| GHE) (Nếu dùng ký hiệu ⋈:) π TenKH, SoDienThoai, MaVe, HangGhe, SoGhe, GiaVe (KHACHHANG ⋈ σ DoiTuong = N'Người lớn' (VE) ⋈ GHE)
SQL:
SQL
SELECT KH.TenKH, KH.SoDienThoai, V.MaVe, G.HangGhe, G.SoGhe, V.GiaVe
FROM VE V
JOIN KHACHHANG KH ON V.MaKH = KH.MaKH
JOIN GHE G ON V.MaGhe = G.MaGhe
WHERE V.DoiTuong = N'Người lớn';
Câu 4: Truy vấn tính tổng
Đề bài: Tính tổng số tiền vé thu được và tổng số vé đã bán theo từng mã khách hàng và tên khách hàng.
Đại số quan hệ (ĐSQH): MaKH, TenKH G SUM(GiaVe) AS TongTien, COUNT(MaVe) AS SoLuongVe (KHACHHANG |><| VE) (Nếu dùng ký hiệu ⋈:) MaKH, TenKH G SUM(GiaVe) AS TongTien, COUNT(MaVe) AS SoLuongVe (KHACHHANG ⋈ VE)
SQL:
SQL
SELECT KH.MaKH, KH.TenKH, COUNT(V.MaVe) AS SoLuongVe, SUM(V.GiaVe) AS TongTien
FROM KHACHHANG KH
JOIN VE V ON KH.MaKH = V.MaKH
GROUP BY KH.MaKH, KH.TenKH;
Câu 5: Truy vấn lồng
Đề bài: Tìm thông tin các bộ phim (MaPhim, TenPhim) chưa có bất kỳ suất chiếu nào được lên lịch.
Đại số quan hệ (ĐSQH): π MaPhim, TenPhim (PHIM) - π MaPhim, TenPhim (PHIM |><| SUATCHIEU) (Nếu dùng ký hiệu ⋈:) π MaPhim, TenPhim (PHIM) - π MaPhim, TenPhim (PHIM ⋈ SUATCHIEU)
SQL:
SQL
SELECT MaPhim, TenPhim
FROM PHIM
WHERE MaPhim NOT IN (
    SELECT DISTINCT MaPhim
    FROM SUATCHIEU
);