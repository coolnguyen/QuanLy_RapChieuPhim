-- ===============================================================================
-- HỌC VIỆN / TRƯỜNG ĐẠI HỌC THỦY LỢI - KHOA CÔNG NGHỆ THÔNG TIN
-- BÀI TẬP LỚN MÔN CƠ SỞ DỮ LIỆU - LỚP: 67KTPM2
-- ĐỀ TÀI: HỆ THỐNG QUẢN LÝ RẠP CHIẾU PHIM
-- NHÓM 11 | GIẢNG VIÊN HƯỚNG DẪN: TS. LÊ THỊ TÚ KIÊN
-- ===============================================================================
-- FILE 00: MASTER SCRIPT KHỞI TẠO CSDL VÀ 28 BẢNG CHUẨN 3NF TOÀN HỆ THỐNG
-- Thứ tự khởi tạo 4 tầng (DDL Dependency Order) chống lỗi khóa ngoại (FK)
-- ===============================================================================

CREATE DATABASE QL_RapChieuPhim_TongHop;
GO
USE QL_RapChieuPhim_TongHop;
GO

-- ===============================================================================
-- TẦNG 1: CÁC BẢNG DANH MỤC GỐC ĐỘC LẬP (Không chứa khóa ngoại)
-- ===============================================================================

-- 1. Bảng CHI_NHANH (Phân hệ 2 - Quản lý nhân sự & vận hành)
CREATE TABLE CHI_NHANH (
    MaCN VARCHAR(10) PRIMARY KEY,
    TenCN NVARCHAR(100) NOT NULL UNIQUE,
    DiaChi NVARCHAR(255) NOT NULL,
    SDT VARCHAR(15) NOT NULL UNIQUE
);

-- 2. Bảng LOAI_THANH_VIEN (Phân hệ 2 - Khách hàng & hội viên)
CREATE TABLE LOAI_THANH_VIEN (
    MaLoaiTV VARCHAR(10) PRIMARY KEY,
    TenLoaiTV NVARCHAR(50) NOT NULL UNIQUE,
    ChietKhau DECIMAL(5,2) NOT NULL DEFAULT 0 CHECK (ChietKhau BETWEEN 0 AND 100),
    TyLeTichDiem DECIMAL(5,2) NOT NULL DEFAULT 0 CHECK (TyLeTichDiem >= 0)
);

-- 3. Bảng PHIM (Bảng trung tâm liên kết Phân hệ 1, 3, 4)
CREATE TABLE PHIM (
    MaPhim VARCHAR(10) PRIMARY KEY,
    TenPhim NVARCHAR(150) NOT NULL,
    TheLoai NVARCHAR(100) NOT NULL,
    DaoDien NVARCHAR(100),
    DienVien NVARCHAR(200),
    ThoiLuong INT NOT NULL CHECK (ThoiLuong > 0),
    DoTuoi INT NOT NULL DEFAULT 0 CHECK (DoTuoi >= 0),
    NgayKhoiChieu DATE NOT NULL,
    NgonNgu NVARCHAR(50),
    TrangThaiPhim NVARCHAR(50) NOT NULL DEFAULT N'Đang chiếu'
);

-- 4. Bảng LOAI_GHE (Phân hệ 1 - Vé & phòng chiếu)
CREATE TABLE LOAI_GHE (
    MaLoaiGhe VARCHAR(10) PRIMARY KEY,
    TenLoaiGhe NVARCHAR(50) NOT NULL UNIQUE,
    PhuThu DECIMAL(12,2) NOT NULL DEFAULT 0 CHECK (PhuThu >= 0)
);

-- 5. Bảng SAN_PHAM_KHO (Phân hệ 2 - Bắp nước & Dịch vụ F&B)
CREATE TABLE SAN_PHAM_KHO (
    MaSP VARCHAR(10) PRIMARY KEY,
    TenSP NVARCHAR(100) NOT NULL,
    DonViTinh NVARCHAR(30) NOT NULL,
    DonGia DECIMAL(12,2) NOT NULL CHECK (DonGia >= 0),
    SoLuongTon INT NOT NULL DEFAULT 0 CHECK (SoLuongTon >= 0)
);

-- 6. Bảng LOAI_THIET_BI (Phân hệ 3 - Cơ sở vật chất kỹ thuật)
CREATE TABLE LOAI_THIET_BI (
    MaLoaiTB VARCHAR(10) PRIMARY KEY,
    TenLoaiTB NVARCHAR(100) NOT NULL UNIQUE,
    MoTa NVARCHAR(255)
);

-- 7. Bảng CHIEN_DICH (Phân hệ 4 - Marketing & Truyền thông)
CREATE TABLE CHIEN_DICH (
    MaCD VARCHAR(10) PRIMARY KEY,
    TenCD NVARCHAR(150) NOT NULL,
    MucTieu NVARCHAR(200),
    NgayBatDau DATE NOT NULL,
    NgayKetThuc DATE NOT NULL,
    NganSach DECIMAL(15,2) NOT NULL CHECK (NganSach >= 0),
    KenhTrienKhai NVARCHAR(100),
    CONSTRAINT CHK_ChienDich_Ngay CHECK (NgayKetThuc >= NgayBatDau)
);

-- 8. Bảng DOI_TAC (Phân hệ 4 - Nhà cung cấp & Nhà phát hành)
CREATE TABLE DOI_TAC (
    MaDT VARCHAR(10) PRIMARY KEY,
    TenDT NVARCHAR(150) NOT NULL,
    LoaiDT NVARCHAR(50) NOT NULL,
    SoDienThoai VARCHAR(15),
    Email VARCHAR(100),
    DiaChi NVARCHAR(200),
    TrangThaiHopTac NVARCHAR(50) DEFAULT N'Đang hợp tác'
);

-- ===============================================================================
-- TẦNG 2: CÁC BẢNG NGHIỆP VỤ CẤP 1 (Tham chiếu đến Tầng 1)
-- ===============================================================================

-- 9. Bảng BO_PHAN (Thuộc Chi nhánh)
CREATE TABLE BO_PHAN (
    MaBP VARCHAR(10) PRIMARY KEY,
    TenBP NVARCHAR(100) NOT NULL,
    MoTa NVARCHAR(255),
    MaCN VARCHAR(10) NOT NULL FOREIGN KEY REFERENCES CHI_NHANH(MaCN)
);

-- 10. Bảng NHAN_SU (Chuẩn hóa 3NF: bỏ MaCN, tra cứu qua MaBP)
CREATE TABLE NHAN_SU (
    MaNS VARCHAR(10) PRIMARY KEY,
    HoTen NVARCHAR(100) NOT NULL,
    GioiTinh NVARCHAR(10),
    NgaySinh DATE,
    SDT VARCHAR(15) NOT NULL UNIQUE,
    ChucVu NVARCHAR(50) NOT NULL,
    LuongCoBan DECIMAL(12,2) NOT NULL CHECK (LuongCoBan > 0),
    MaBP VARCHAR(10) NOT NULL FOREIGN KEY REFERENCES BO_PHAN(MaBP),
    MaQuanLy VARCHAR(10) NULL FOREIGN KEY REFERENCES NHAN_SU(MaNS)
);

-- 11. Bảng KHACH_HANG (Thuộc Loại thành viên)
CREATE TABLE KHACH_HANG (
    MaKH VARCHAR(10) PRIMARY KEY,
    HoTen NVARCHAR(100) NOT NULL,
    SDT VARCHAR(15) NOT NULL UNIQUE,
    Email VARCHAR(100) UNIQUE,
    NgaySinh DATE,
    MaLoaiTV VARCHAR(10) NOT NULL FOREIGN KEY REFERENCES LOAI_THANH_VIEN(MaLoaiTV)
);

-- 12. Bảng PHONG_CHIEU (Thuộc Chi nhánh)
CREATE TABLE PHONG_CHIEU (
    MaPhong VARCHAR(10) PRIMARY KEY,
    TenPhong NVARCHAR(50) NOT NULL,
    LoaiPhong NVARCHAR(50) NOT NULL,
    SucChua INT NOT NULL CHECK (SucChua > 0),
    TinhTrang NVARCHAR(50) DEFAULT N'Hoạt động',
    MaCN VARCHAR(10) NULL FOREIGN KEY REFERENCES CHI_NHANH(MaCN)
);

-- 13. Bảng GHE (Thuộc Phòng chiếu & Loại ghế)
CREATE TABLE GHE (
    MaGhe VARCHAR(10) PRIMARY KEY,
    SoGhe VARCHAR(10) NOT NULL,
    HangGhe VARCHAR(5) NOT NULL,
    TrangThaiGhe NVARCHAR(30) DEFAULT N'Hoạt động',
    MaPhong VARCHAR(10) NOT NULL FOREIGN KEY REFERENCES PHONG_CHIEU(MaPhong),
    MaLoaiGhe VARCHAR(10) NOT NULL FOREIGN KEY REFERENCES LOAI_GHE(MaLoaiGhe),
    CONSTRAINT UQ_Ghe_Phong UNIQUE (MaPhong, HangGhe, SoGhe)
);

-- 14. Bảng SU_KIEN (Thuộc Chiến dịch & Phim)
CREATE TABLE SU_KIEN (
    MaSK VARCHAR(10) PRIMARY KEY,
    TenSK NVARCHAR(150) NOT NULL,
    NgayToChuc DATE NOT NULL,
    DiaDiem NVARCHAR(200),
    ChiPhiDuKien DECIMAL(15,2) CHECK (ChiPhiDuKien >= 0),
    MaCD VARCHAR(10) NOT NULL FOREIGN KEY REFERENCES CHIEN_DICH(MaCD),
    MaPhim VARCHAR(10) NOT NULL FOREIGN KEY REFERENCES PHIM(MaPhim)
);

-- 15. Bảng KHUYEN_MAI (Thuộc Chiến dịch & Khách hàng)
CREATE TABLE KHUYEN_MAI (
    MaKM VARCHAR(10) PRIMARY KEY,
    TenKM NVARCHAR(150) NOT NULL,
    LoaiKM NVARCHAR(50),
    GiaTriGiam DECIMAL(10,2) NOT NULL CHECK (GiaTriGiam > 0),
    NgayBatDau DATE NOT NULL,
    NgayKetThuc DATE NOT NULL,
    MaCD VARCHAR(10) NULL FOREIGN KEY REFERENCES CHIEN_DICH(MaCD),
    MaKH VARCHAR(10) NULL FOREIGN KEY REFERENCES KHACH_HANG(MaKH)
);

-- 16. Bảng HOP_DONG (Ký với Đối tác)
CREATE TABLE HOP_DONG (
    MaHD VARCHAR(10) PRIMARY KEY,
    SoHopDong VARCHAR(30) NOT NULL UNIQUE,
    NgayKy DATE NOT NULL,
    NgayHieuLuc DATE NOT NULL,
    NgayHetHan DATE NOT NULL,
    GiaTriHopDong DECIMAL(15,2) NOT NULL CHECK (GiaTriHopDong > 0),
    MaDT VARCHAR(10) NOT NULL FOREIGN KEY REFERENCES DOI_TAC(MaDT)
);

-- ===============================================================================
-- TẦNG 3: CÁC BẢNG GIAO DỊCH, LỊCH CHIẾU, KỸ THUẬT & LIÊN KẾT M-N
-- ===============================================================================

-- 17. Bảng CA_LAM_VIEC (Phân ca trực cho Nhân sự)
CREATE TABLE CA_LAM_VIEC (
    MaCa VARCHAR(10) PRIMARY KEY,
    TenCa NVARCHAR(50) NOT NULL,
    GioBatDau TIME NOT NULL,
    GioKetThuc TIME NOT NULL,
    MaNS VARCHAR(10) NOT NULL FOREIGN KEY REFERENCES NHAN_SU(MaNS)
);

-- 18. Bảng SUAT_CHIEU (Nối Phim & Phòng chiếu)
CREATE TABLE SUAT_CHIEU (
    MaSuatChieu VARCHAR(10) PRIMARY KEY,
    NgayChieu DATE NOT NULL,
    GioBatDau TIME NOT NULL,
    GioKetThuc TIME NOT NULL,
    GiaVeCoBan DECIMAL(12,2) NOT NULL CHECK (GiaVeCoBan > 0),
    MaPhim VARCHAR(10) NOT NULL FOREIGN KEY REFERENCES PHIM(MaPhim),
    MaPhong VARCHAR(10) NOT NULL FOREIGN KEY REFERENCES PHONG_CHIEU(MaPhong)
);

-- 19. Bảng HOA_DON_TONG (Hóa đơn dịch vụ tổng hợp)
CREATE TABLE HOA_DON_TONG (
    MaHD VARCHAR(10) PRIMARY KEY,
    NgayLap DATETIME NOT NULL DEFAULT GETDATE(),
    MaKH VARCHAR(10) NULL FOREIGN KEY REFERENCES KHACH_HANG(MaKH),
    MaNS VARCHAR(10) NOT NULL FOREIGN KEY REFERENCES NHAN_SU(MaNS),
    MaKM VARCHAR(10) NULL FOREIGN KEY REFERENCES KHUYEN_MAI(MaKM)
);

-- 20. Bảng THANH_TOAN (Ghi nhận phương thức & số tiền thanh toán)
CREATE TABLE THANH_TOAN (
    MaThanhToan VARCHAR(10) PRIMARY KEY,
    PhuongThucThanhToan NVARCHAR(50) NOT NULL,
    NgayThanhToan DATETIME NOT NULL DEFAULT GETDATE(),
    SoTien DECIMAL(15,2) NOT NULL CHECK (SoTien >= 0),
    TrangThaiTT NVARCHAR(50) DEFAULT N'Thành công',
    MaHD VARCHAR(10) NULL FOREIGN KEY REFERENCES HOA_DON_TONG(MaHD)
);

-- 21. Bảng VE (Chuẩn hóa 3NF: Bỏ PhuongThucThanhToan, có ràng buộc chống bán trùng ghế)
CREATE TABLE VE (
    MaVe VARCHAR(10) PRIMARY KEY,
    NgayDat DATETIME NOT NULL DEFAULT GETDATE(),
    GiaVe DECIMAL(12,2) NOT NULL CHECK (GiaVe >= 0),
    TrangThaiVe NVARCHAR(50) NOT NULL DEFAULT N'Đã thanh toán',
    MaSuatChieu VARCHAR(10) NOT NULL FOREIGN KEY REFERENCES SUAT_CHIEU(MaSuatChieu),
    MaGhe VARCHAR(10) NOT NULL FOREIGN KEY REFERENCES GHE(MaGhe),
    MaKH VARCHAR(10) NULL FOREIGN KEY REFERENCES KHACH_HANG(MaKH),
    MaThanhToan VARCHAR(10) NULL FOREIGN KEY REFERENCES THANH_TOAN(MaThanhToan),
    CONSTRAINT UQ_Ve_SuatChieu_Ghe UNIQUE (MaSuatChieu, MaGhe)
);

-- 22. Bảng CHI_TIET_BAN_SP (Bảng trung gian M-N giữa Hóa đơn và Sản phẩm F&B)
CREATE TABLE CHI_TIET_BAN_SP (
    MaHD VARCHAR(10) NOT NULL FOREIGN KEY REFERENCES HOA_DON_TONG(MaHD),
    MaSP VARCHAR(10) NOT NULL FOREIGN KEY REFERENCES SAN_PHAM_KHO(MaSP),
    SoLuong INT NOT NULL CHECK (SoLuong > 0),
    DonGiaBan DECIMAL(12,2) NOT NULL CHECK (DonGiaBan >= 0),
    PRIMARY KEY (MaHD, MaSP)
);

-- 23. Bảng THIET_BI (Thiết bị lắp đặt tại phòng chiếu)
CREATE TABLE THIET_BI (
    MaTB VARCHAR(10) PRIMARY KEY,
    TenTB NVARCHAR(100) NOT NULL,
    HangSanXuat NVARCHAR(100),
    NgayLapDat DATE NOT NULL,
    GiaMua DECIMAL(15,2) CHECK (GiaMua >= 0),
    TinhTrang NVARCHAR(50) DEFAULT N'Hoạt động tốt',
    MaPhong VARCHAR(10) NOT NULL FOREIGN KEY REFERENCES PHONG_CHIEU(MaPhong),
    MaLoaiTB VARCHAR(10) NOT NULL FOREIGN KEY REFERENCES LOAI_THIET_BI(MaLoaiTB)
);

-- 24. Bảng BAO_TRI (Lịch sử bảo dưỡng thiết bị)
CREATE TABLE BAO_TRI (
    MaBaoTri VARCHAR(10) PRIMARY KEY,
    MaTB VARCHAR(10) NOT NULL FOREIGN KEY REFERENCES THIET_BI(MaTB),
    NgayBaoTri DATE NOT NULL,
    LoaiBaoTri NVARCHAR(50) NOT NULL,
    ChiPhiBaoTri DECIMAL(15,2) NOT NULL CHECK (ChiPhiBaoTri >= 0),
    DonViThucHien NVARCHAR(150),
    KetQua NVARCHAR(100)
);

-- 25. Bảng SU_CO (Xử lý sự cố kỹ thuật phòng chiếu)
CREATE TABLE SU_CO (
    MaSuCo VARCHAR(10) PRIMARY KEY,
    MaTB VARCHAR(10) NOT NULL FOREIGN KEY REFERENCES THIET_BI(MaTB),
    NgayPhatHien DATE NOT NULL,
    MoTaSuCo NVARCHAR(255) NOT NULL,
    MucDoNghiemTrong NVARCHAR(50) NOT NULL,
    ChiPhiXuLy DECIMAL(15,2) DEFAULT 0 CHECK (ChiPhiXuLy >= 0),
    TrangThaiXuLy NVARCHAR(50) DEFAULT N'Đã khắc phục'
);

-- 26. Bảng DOANH_THU (Doanh thu suất chiếu)
CREATE TABLE DOANH_THU (
    MaDoanhThu VARCHAR(10) PRIMARY KEY,
    MaSuatChieu VARCHAR(10) NOT NULL FOREIGN KEY REFERENCES SUAT_CHIEU(MaSuatChieu),
    NgayGhiNhan DATE NOT NULL,
    SoVeBan INT NOT NULL CHECK (SoVeBan >= 0),
    DoanhThuVe DECIMAL(15,2) NOT NULL CHECK (DoanhThuVe >= 0),
    DoanhThuDichVu DECIMAL(15,2) DEFAULT 0 CHECK (DoanhThuDichVu >= 0),
    TongDoanhThu DECIMAL(15,2) NOT NULL CHECK (TongDoanhThu >= 0)
);

-- 27. Bảng DOI_TAC_SU_KIEN (Bảng trung gian M-N giữa Sự kiện và Đối tác)
CREATE TABLE DOI_TAC_SU_KIEN (
    MaSK VARCHAR(10) NOT NULL FOREIGN KEY REFERENCES SU_KIEN(MaSK),
    MaDT VARCHAR(10) NOT NULL FOREIGN KEY REFERENCES DOI_TAC(MaDT),
    VaiTro NVARCHAR(100) NOT NULL,
    GiaTriTaiTro DECIMAL(15,2) DEFAULT 0 CHECK (GiaTriTaiTro >= 0),
    PRIMARY KEY (MaSK, MaDT)
);

-- 28. Bảng HOP_DONG_PHIM (Chi tiết bản quyền phim theo từng hợp đồng)
CREATE TABLE HOP_DONG_PHIM (
    MaHD VARCHAR(10) NOT NULL FOREIGN KEY REFERENCES HOP_DONG(MaHD),
    MaPhim VARCHAR(10) NOT NULL FOREIGN KEY REFERENCES PHIM(MaPhim),
    GiaBanQuyen DECIMAL(15,2) NOT NULL CHECK (GiaBanQuyen > 0),
    TyLeChiaDoanhThu DECIMAL(5,2) NOT NULL CHECK (TyLeChiaDoanhThu BETWEEN 0 AND 100),
    PRIMARY KEY (MaHD, MaPhim)
);
GO

-- ===============================================================================
-- TẦNG 4: CÁC KHUNG NHÌN TÍNH TOÁN ĐỘNG (VIEWS ĐẠT CHUẨN 3NF)
-- ===============================================================================

-- View 1: Tính điểm tích lũy của khách hàng động
CREATE VIEW VW_KHACH_HANG_DIEM AS
SELECT 
    kh.MaKH,
    kh.HoTen,
    kh.SDT,
    ltv.TenLoaiTV,
    ISNULL(SUM(tt.SoTien * ltv.TyLeTichDiem / 100), 0) AS TongDiemTichLuy
FROM KHACH_HANG kh
JOIN LOAI_THANH_VIEN ltv ON kh.MaLoaiTV = ltv.MaLoaiTV
LEFT JOIN HOA_DON_TONG hd ON kh.MaKH = hd.MaKH
LEFT JOIN THANH_TOAN tt ON hd.MaHD = tt.MaHD
GROUP BY kh.MaKH, kh.HoTen, kh.SDT, ltv.TenLoaiTV;
GO

-- View 2: Tính tổng tiền hóa đơn động từ vé và sản phẩm F&B
CREATE VIEW VW_HOA_DON_TONG_TIEN AS
SELECT 
    hd.MaHD,
    hd.NgayLap,
    hd.MaKH,
    hd.MaNS,
    ISNULL(SUM(ct.SoLuong * ct.DonGiaBan), 0) AS TienDichVu,
    ISNULL(v.TienVe, 0) AS TienVe,
    ISNULL(SUM(ct.SoLuong * ct.DonGiaBan), 0) + ISNULL(v.TienVe, 0) AS TongTienTruocGiam
FROM HOA_DON_TONG hd
LEFT JOIN CHI_TIET_BAN_SP ct ON hd.MaHD = ct.MaHD
LEFT JOIN (
    SELECT MaKH, SUM(GiaVe) AS TienVe 
    FROM VE 
    GROUP BY MaKH
) v ON hd.MaKH = v.MaKH
GROUP BY hd.MaHD, hd.NgayLap, hd.MaKH, hd.MaNS, v.TienVe;
GO

PRINT N'Khởi tạo thành công toàn bộ CSDL và 28 bảng chuẩn 3NF QL_RapChieuPhim_TongHop!';
