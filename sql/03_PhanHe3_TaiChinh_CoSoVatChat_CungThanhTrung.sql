-- ===============================================================================
-- PHÂN HỆ 3: QUẢN LÝ TÀI CHÍNH VÀ CƠ SỞ VẬT CHẤT & KỸ THUẬT
-- Thành viên thực hiện: Cung Thành Trung
-- ===============================================================================

CREATE DATABASE QuanLyRapChieuPhim_CSVC_TaiChinh;
GO
USE QuanLyRapChieuPhim_CSVC_TaiChinh;
GO

    NoiDung NVARCHAR(255),
    SoTien DECIMAL(18,2) NOT NULL CHECK (SoTien >= 0),
    LoaiDoanhThu NVARCHAR(50),
    MaBaoCao VARCHAR(10) NOT NULL,
    CONSTRAINT FK_DoanhThu_BaoCao FOREIGN KEY (MaBaoCao) REFERENCES BAO_CAO(MaBaoCao)
);
GO
CREATE TABLE GIAO_DICH (
    MaGiaoDich VARCHAR(10) PRIMARY KEY,
    NgayGiaoDich DATETIME NOT NULL,
    NoiDung NVARCHAR(255),
    SoTien DECIMAL(18,2) NOT NULL CHECK (SoTien >= 0),
    LoaiGiaoDich NVARCHAR(50),
    PhuongThucThanhToan NVARCHAR(50),
    MaDoanhThu VARCHAR(10) NOT NULL,
    CONSTRAINT FK_GiaoDich_DoanhThu FOREIGN KEY (MaDoanhThu) REFERENCES DOANH_THU(MaDoanhThu)
);
GO
CREATE TABLE PHONG_CHIEU (
    MaPhong VARCHAR(10) PRIMARY KEY,
    TenPhong NVARCHAR(100) NOT NULL,
    LoaiPhong NVARCHAR(50),
    SucChua INT NOT NULL CHECK (SucChua > 0),
    KhuVuc NVARCHAR(100),
    TrangThai NVARCHAR(50)
);
GO
CREATE TABLE LOAI_THIET_BI (
    MaLoaiTB VARCHAR(10) PRIMARY KEY,
    TenLoaiTB NVARCHAR(100) NOT NULL,
    MoTa NVARCHAR(255)
);
GO
CREATE TABLE THIET_BI (
    MaTB VARCHAR(10) PRIMARY KEY,
    TenTB NVARCHAR(100) NOT NULL,
    NgaySuDung DATE,
    TrangThai NVARCHAR(50),
    MaPhong VARCHAR(10) NOT NULL,
    MaLoaiTB VARCHAR(10) NOT NULL,
    CONSTRAINT FK_ThietBi_Phong FOREIGN KEY (MaPhong) REFERENCES PHONG_CHIEU(MaPhong),
    CONSTRAINT FK_ThietBi_Loai FOREIGN KEY (MaLoaiTB) REFERENCES LOAI_THIET_BI(MaLoaiTB)
);
GO
CREATE TABLE NHAN_VIEN_KY_THUAT (
    MaNV VARCHAR(10) PRIMARY KEY,
    HoTen NVARCHAR(100) NOT NULL,
    SDT VARCHAR(15),
    ChucVu NVARCHAR(50),
    TrinhDo NVARCHAR(100),
    TrangThai NVARCHAR(50)
);
GO
CREATE TABLE SU_CO (
    MaSuCo VARCHAR(10) PRIMARY KEY,
    NgayPhatHien DATE NOT NULL,
    MucDo NVARCHAR(50),
    TrangThaiXuLy NVARCHAR(50),
    ChiPhiSuaChua DECIMAL(18,2) CHECK (ChiPhiSuaChua >= 0),
    MaTB VARCHAR(10) NOT NULL,
    MaNV VARCHAR(10) NULL,
    CONSTRAINT FK_SuCo_ThietBi FOREIGN KEY (MaTB) REFERENCES THIET_BI(MaTB),
    CONSTRAINT FK_SuCo_NhanVien FOREIGN KEY (MaNV) REFERENCES NHAN_VIEN_KY_THUAT(MaNV)
);
GO
CREATE TABLE BAO_TRI (
    MaBaoTri VARCHAR(10) PRIMARY KEY,
    NgayBaoTri DATE NOT NULL,
    NoiDung NVARCHAR(255),
    ChiPhi DECIMAL(18,2) CHECK (ChiPhi >= 0),
    TrangThai NVARCHAR(50),
    MaTB VARCHAR(10) NOT NULL,
    MaNV VARCHAR(10) NOT NULL,
    CONSTRAINT FK_BaoTri_ThietBi FOREIGN KEY (MaTB) REFERENCES THIET_BI(MaTB),
    CONSTRAINT FK_BaoTri_NhanVien FOREIGN KEY (MaNV) REFERENCES NHAN_VIEN_KY_THUAT(MaNV)
);
GO
-- DU LIEU MAU NHOM TAI CHINH
INSERT INTO BAO_CAO VALUES
('BC001','2026-10-20',N'Báo cáo ngày',1250000),
('BC002','2026-10-21',N'Báo cáo ngày',1800000);
INSERT INTO DOANH_THU VALUES
('DT001','2026-10-20',N'Doanh thu vé',800000,N'Bán vé','BC001'),
('DT002','2026-10-20',N'Doanh thu đồ ăn',450000,N'Đồ ăn và nước uống','BC001'),
('DT003','2026-10-21',N'Doanh thu vé',1200000,N'Bán vé','BC002'),
('DT004','2026-10-21',N'Doanh thu đồ ăn',600000,N'Đồ ăn và nước uống','BC002');
INSERT INTO GIAO_DICH VALUES
('GD001','2026-10-20T09:00:00',N'Bán vé buổi sáng',500000,N'Bán vé',N'Tiền mặt','DT001'),
('GD002','2026-10-20T14:00:00',N'Bán vé buổi chiều',300000,N'Bán vé',N'Chuyển khoản','DT001'),
('GD003','2026-10-20T15:00:00',N'Bán combo bỏng nước',450000,N'Đồ ăn',N'Thẻ ngân hàng','DT002'),
('GD004','2026-10-21T10:00:00',N'Bán vé buổi sáng',700000,N'Bán vé',N'Tiền mặt','DT003'),
('GD005','2026-10-21T19:00:00',N'Bán vé buổi tối',500000,N'Bán vé',N'Chuyển khoản','DT003'),
('GD006','2026-10-21T20:00:00',N'Bán đồ ăn nước uống',600000,N'Đồ ăn',N'Thẻ ngân hàng','DT004');
GO
-- DU LIEU MAU NHOM CO SO VAT CHAT VA KY THUAT
INSERT INTO PHONG_CHIEU VALUES
('P01',N'Phòng chiếu 1',N'2D',100,N'Tầng 1',N'Đang hoạt động'),
('P02',N'Phòng chiếu 2',N'3D',120,N'Tầng 2',N'Đang hoạt động'),
('P03',N'Phòng chiếu 3',N'IMAX',180,N'Tầng 3',N'Tạm ngừng');
INSERT INTO LOAI_THIET_BI VALUES
('L01',N'Máy chiếu',N'Thiết bị trình chiếu phim'),
('L02',N'Âm thanh',N'Loa và bộ khuếch đại âm thanh'),
('L03',N'Thiết bị hỗ trợ',N'Thiết bị phục vụ vận hành phòng chiếu');
INSERT INTO THIET_BI VALUES
('TB001',N'Máy chiếu Sony', '2025-01-10',N'Đang hoạt động','P01','L01'),
('TB002',N'Hệ thống loa JBL','2025-01-12',N'Đang hoạt động','P01','L02'),
('TB003',N'Máy chiếu Epson','2025-03-15',N'Đang hoạt động','P02','L01'),
('TB004',N'Hệ thống âm thanh Dolby','2025-03-15',N'Đang hoạt động','P02','L02'),
('TB005',N'Máy chiếu IMAX','2025-05-20',N'Đang sửa chữa','P03','L01'),
('TB006',N'Bộ điều khiển phòng chiếu','2025-05-20',N'Đang hoạt động','P03','L03');
INSERT INTO NHAN_VIEN_KY_THUAT VALUES
('NV001',N'Nguyễn Văn An','0901234567',N'Kỹ thuật viên',N'Cao đẳng',N'Đang làm việc'),
('NV002',N'Trần Thị Bình','0912345678',N'Kỹ thuật viên',N'Đại học',N'Đang làm việc'),
('NV003',N'Lê Minh Cường','0923456789',N'Trưởng nhóm kỹ thuật',N'Đại học',N'Đang làm việc');
INSERT INTO SU_CO VALUES
('SC001','2026-10-18',N'Trung bình',N'Đã xử lý',250000,'TB002','NV001'),
('SC002','2026-10-20',N'Nghiêm trọng',N'Đang xử lý',900000,'TB005','NV003'),
('SC003','2026-10-21',N'Nhẹ',N'Đã xử lý',100000,'TB003','NV002');
INSERT INTO BAO_TRI VALUES
('BT001','2026-10-18',N'Kiểm tra và vệ sinh hệ thống loa',250000,N'Hoàn thành','TB002','NV001'),
('BT002','2026-10-20',N'Sửa chữa máy chiếu IMAX',900000,N'Đang thực hiện','TB005','NV003'),
('BT003','2026-10-21',N'Kiểm tra máy chiếu Epson',100000,N'Hoàn thành','TB003','NV002'),
('BT004','2026-10-22',N'Bảo trì định kỳ máy chiếu Sony',150000,N'Hoàn thành','TB001','NV001');
GO
-- TRUY VAN KIEM TRA DU LIEU
SELECT * FROM BAO_CAO;
SELECT * FROM DOANH_THU;
SELECT * FROM GIAO_DICH;
SELECT * FROM PHONG_CHIEU;
SELECT * FROM LOAI_THIET_BI;
SELECT * FROM THIET_BI;
SELECT * FROM NHAN_VIEN_KY_THUAT;
SELECT * FROM SU_CO;
SELECT * FROM BAO_TRI;
-- KIEM TRA TONG DOANH THU THEO BAO CAO
SELECT bc.MaBaoCao, bc.NgayLap, bc.TongDoanhThu,
       SUM(dt.SoTien) AS TongTinhTuChiTiet
FROM BAO_CAO bc
JOIN DOANH_THU dt ON dt.MaBaoCao = bc.MaBaoCao
GROUP BY bc.MaBaoCao, bc.NgayLap, bc.TongDoanhThu;
-- THIET BI VA PHONG CHIEU
SELECT tb.MaTB, tb.TenTB, l.TenLoaiTB, p.TenPhong, tb.TrangThai
FROM THIET_BI tb
JOIN LOAI_THIET_BI l ON tb.MaLoaiTB = l.MaLoaiTB
JOIN PHONG_CHIEU p ON tb.MaPhong = p.MaPhong;
-- LICH SU BAO TRI VA NHAN VIEN THUC HIEN
SELECT bt.MaBaoTri, bt.NgayBaoTri, tb.TenTB, nv.HoTen,
       bt.NoiDung, bt.ChiPhi, bt.TrangThai
FROM BAO_TRI bt
JOIN THIET_BI tb ON bt.MaTB = tb.MaTB
JOIN NHAN_VIEN_KY_THUAT nv ON bt.MaNV = nv.MaNV;
GO
Yêu cầu 6:
6.1. Mục đích
Dựa trên cơ sở dữ liệu đã xây dựng ở yêu cầu 5, tiến hành xây dựng 5 câu hỏi truy vấn bằng Đại số quan hệ (ĐSQH) và ngôn ngữ SQL Server.
Các câu truy vấn tập trung vào hai nhóm nghiệp vụ:
Tài chính: Quản lý doanh thu, giao dịch và báo cáo.
Cơ sở vật chất & kỹ thuật: Quản lý phòng chiếu, máy chiếu, hệ thống âm thanh, sự cố và bảo trì.
Các truy vấn sử dụng phép chọn (σ), phép chiếu (π), phép kết nối (⋈) và phép gom nhóm, tổng hợp (γ) nhằm khai thác thông tin từ cơ sở dữ liệu.
6.2. Các câu hỏi truy vấn
Câu 1. Liệt kê các giao dịch có số tiền lớn hơn 100.000 đồng
Mục đích: Giúp bộ phận tài chính theo dõi các giao dịch có giá trị lớn hơn mức quy định.
Đại số quan hệ:
SQL:
SELECT MaGiaoDich, NgayGiaoDich, NoiDung, SoTien
FROM GIAO_DICH
WHERE SoTien > 100000;
Kết quả mong đợi: Hiển thị mã giao dịch, ngày giao dịch, nội dung và số tiền của những giao dịch lớn hơn 100.000 đồng.
Câu 2. Thống kê tổng doanh thu theo từng loại doanh thu
Mục đích: Giúp người quản lý biết nguồn doanh thu nào đóng góp nhiều nhất, chẳng hạn bán vé, bán đồ ăn hoặc nước uống.
Đại số quan hệ mở rộng:
Trong đó, γ là phép gom nhóm theo LoaiDoanhThu và tính tổng SoTien.
SQL:
SELECT LoaiDoanhThu,
       SUM(SoTien) AS TongTien
FROM DOANH_THU
GROUP BY LoaiDoanhThu;
Kết quả mong đợi: Hiển thị từng loại doanh thu và tổng số tiền tương ứng.
Câu 3. Liệt kê các thiết bị thuộc từng phòng chiếu
Mục đích: Giúp bộ phận kỹ thuật theo dõi số lượng và tình trạng thiết bị được bố trí trong từng phòng chiếu.
Đại số quan hệ:
π_{MaPhong,TenPhong,MaTB,TenTB,TrangThai}(PHONG_CHIEU ⋈_{PHONG_CHIEU.MaPhong=THIET_BI.MaPhong} THIET_BI)
Trong đó TrangThai được hiểu là trạng thái của thiết bị.
SQL:
SELECT
    P.MaPhong,
    P.TenPhong,
    T.MaTB,
    T.TenTB,
    T.TrangThai
FROM PHONG_CHIEU AS P
INNER JOIN THIET_BI AS T
    ON P.MaPhong = T.MaPhong;
Kết quả mong đợi: Hiển thị danh sách thiết bị, mã thiết bị, tên phòng và tình trạng hoạt động của từng thiết bị.
Câu 4. Liệt kê các thiết bị đang gặp sự cố chưa được xử lý
Mục đích: Giúp nhân viên kỹ thuật xác định những thiết bị cần ưu tiên kiểm tra và sửa chữa.
Đại số quan hệ:
π_{MaSuCo,TenTB,NgayPhatHien,MucDo,TrangThaiXuLy}(σ_{TrangThaiXuLy='Chưa xử lý'}(SU_CO ⋈_{SU_CO.MaTB=THIET_BI.MaTB} THIET_BI))
SQL:
SELECT
    S.MaSuCo,
    T.TenTB,
    S.NgayPhatHien,
    S.MucDo,
    S.TrangThaiXuLy
FROM SU_CO AS S
INNER JOIN THIET_BI AS T
    ON S.MaTB = T.MaTB
WHERE S.TrangThaiXuLy = N'Chưa xử lý';
Kết quả mong đợi: Hiển thị các sự cố chưa xử lý cùng thông tin thiết bị và mức độ nghiêm trọng.
Câu 5. Thống kê số lần bảo trì và tổng chi phí bảo trì của từng nhân viên kỹ thuật
Mục đích: Theo dõi khối lượng công việc và tổng chi phí bảo trì do từng nhân viên phụ trách.
Đại số quan hệ mở rộng:
Đặt:
R = NHAN_VIEN_KY_THUAT ⋈_{NHAN_VIEN_KY_THUAT.MaNV=BAO_TRI.MaNV} BAO_TRI
Khi đó:
SQL:
SELECT
    N.MaNV,
    N.HoTen,
    COUNT(B.MaBaoTri) AS SoLanBaoTri,
    SUM(B.ChiPhi) AS TongChiPhi
FROM NHAN_VIEN_KY_THUAT AS N
INNER JOIN BAO_TRI AS B
    ON N.MaNV = B.MaNV
GROUP BY N.MaNV, N.HoTen;
Kết quả mong đợi: Hiển thị mã nhân viên, họ tên, số lần bảo trì và tổng chi phí bảo trì của mỗi nhân viên đã thực hiện bảo trì.
6.3. Tổng hợp 5 câu truy vấn
Điều chỉnh câu 4 theo dữ liệu mẫu ở yêu cầu 5
Trong dữ liệu mẫu đã nhập, sự cố SC002 có trạng thái Đang xử lý, không phải Chưa xử lý. Vì vậy, để câu 4 trả về dữ liệu thực tế, thay điều kiện SQL bằng:
WHERE S.TrangThaiXuLy = N'Đang xử lý';
Khi đó, kết quả dự kiến là:
Kết quả dự kiến của câu 5
Dựa trên dữ liệu mẫu đã tạo: