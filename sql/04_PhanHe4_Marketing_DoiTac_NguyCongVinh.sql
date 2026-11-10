-- ===============================================================================
-- PHÂN HỆ 4: QUẢN LÝ MARKETING & TRUYỀN THÔNG VÀ ĐỐI TÁC & NHÀ CUNG CẤP
-- Thành viên thực hiện: Ngụy Công Vinh
-- ===============================================================================

Theo bài giảng Chương 4 và Lecture 6, 8 của TS. Lê Thị Tú Kiên, việc tạo lập CSDL quan hệ trên hệ quản trị SQL Server cần tuân thủ các chuẩn mực sau:
●       1. Phân nhóm lệnh DDL: Ngôn ngữ định nghĩa dữ liệu (DDL - Data Definition Language): Sử dụng các lệnh CREATE DATABASE, USE, CREATE TABLE để định nghĩa cấu trúc lưu trữ ở mức logic.
●       2. Kiểu miền dữ liệu: Lựa chọn kiểu dữ liệu phù hợp (Lecture 5, 6): Dùng NVARCHAR cho chuỗi ký tự tiếng Việt có dấu (Unicode); VARCHAR cho các mã định danh không dấu; DECIMAL(p,s) cho tiền tệ và tỷ lệ phần trăm; INT cho số lượng/thời lượng; DATE cho ngày tháng và DATETIME2 cho thời điểm chính xác.
●       3. Mức độ ràng buộc: Phân biệt Ràng buộc mức cột (Column-level) và Ràng buộc mức bảng (Table-level) (Lecture 8 Slide 4-7): Ràng buộc mức cột khai báo trực tiếp sau tên cột; ràng buộc mức bảng khai báo ở cuối câu lệnh bằng mệnh đề CONSTRAINT <tên_ràng_buộc>. Các bảng có khóa chính ghép nhiều cột bắt buộc phải dùng ràng buộc mức bảng.
●       4. Các loại ràng buộc toàn vẹn: 5 loại ràng buộc toàn vẹn cơ bản (Chương 3 Slide 43 & Lecture 8):
   • Ràng buộc khóa (PRIMARY KEY): Xác định duy nhất từng bộ trong quan hệ, không nhận giá trị NULL (thỏa mãn toàn vẹn thực thể).    • Ràng buộc thực thể (NOT NULL): Ngăn chặn giá trị rỗng/chưa biết đối với các thuộc tính bắt buộc.    • Ràng buộc duy nhất (UNIQUE): Đảm bảo không có 2 dòng trùng giá trị (như Mã số thuế, Số hợp đồng).    • Ràng buộc toàn vẹn tham chiếu (FOREIGN KEY ... REFERENCES): Mọi giá trị khóa ngoài phải tồn tại ở khóa chính của bảng được tham chiếu tới. Sử dụng tùy chọn ON DELETE CASCADE (xóa lan truyền ở bảng trung gian) và ON DELETE SET NULL (giữ lại sự kiện khi chiến dịch kết thúc).    • Ràng buộc miền dữ liệu (CHECK): Quy định điều kiện logic nghiệp vụ (NgayKetThuc >= NgayBatDau, SoTien > 0, NganSach >= 0, TyLeChiaDoanhThu BETWEEN 0 AND 100).
 2. Kịch bản T-SQL tạo lập bảng và ràng buộc
Toàn bộ cấu trúc bảng được thiết lập trong CSDL thống nhất QL_RapChieuPhim_Marketing_DoiTac:
-- ==============================================================================
-- 1. TẠO CƠ SỞ DỮ LIỆU VÀ CHUYỂN VÙNG LÀM VIỆC (DDL)
-- ==============================================================================
IF NOT EXISTS (SELECT * FROM sys.databases WHERE name = 'QL_RapChieuPhim_Marketing_DoiTac')
BEGIN
	CREATE DATABASE QL_RapChieuPhim_Marketing_DoiTac;
END
GO
USE QL_RapChieuPhim_Marketing_DoiTac;
GO
-- ==============================================================================
-- 2. TẠO CÁC BẢNG QUAN HỆ VỚI ĐẦY ĐỦ RÀNG BUỘC TOÀN VẸN (Lecture 6 & 8)
-- ==============================================================================
-- 2.1. Bảng PHIM (Thực thể tham chiếu bản quyền)
CREATE TABLE PHIM (
	MaPhim VARCHAR(20) NOT NULL,
	TenPhim NVARCHAR(200) NOT NULL,
	ThoiLuong INT NOT NULL,
	GioiHanTuoi NVARCHAR(20) DEFAULT 'P',
	CONSTRAINT PK_Phim PRIMARY KEY (MaPhim),
	CONSTRAINT CK_Phim_ThoiLuong CHECK (ThoiLuong > 0)
);
-- 2.2. Bảng CHIEN_DICH_TRUYEN_THONG (Phân hệ Marketing)
CREATE TABLE CHIEN_DICH_TRUYEN_THONG (
	MaChienDich VARCHAR(20) NOT NULL,
	TenChienDich NVARCHAR(150) NOT NULL,
	MucTieu NVARCHAR(255) NULL,
	NgayBatDau DATE NOT NULL,
	NgayKetThuc DATE NOT NULL,
	NganSach DECIMAL(18, 2) NOT NULL DEFAULT 0,
	ChiPhiThucTe DECIMAL(18, 2) NOT NULL DEFAULT 0,
	TrangThai NVARCHAR(50) NOT NULL DEFAULT N'Lên kế hoạch',
	CONSTRAINT PK_ChienDich PRIMARY KEY (MaChienDich),
	CONSTRAINT CK_CD_Ngay CHECK (NgayKetThuc >= NgayBatDau),
	CONSTRAINT CK_CD_NganSach CHECK (NganSach >= 0),
	CONSTRAINT CK_CD_ChiPhi CHECK (ChiPhiThucTe >= 0)
);
-- 2.3. Bảng CHUONG_TRINH_KHUYEN_MAI (Phân hệ Marketing - Giảm giá đơn hàng)
CREATE TABLE CHUONG_TRINH_KHUYEN_MAI (
	MaKhuyenMai VARCHAR(20) NOT NULL,
	TenKhuyenMai NVARCHAR(150) NOT NULL,
	LoaiGiamGia NVARCHAR(30) NOT NULL,
	GiaTriGiam DECIMAL(18, 2) NOT NULL,
	GiaTriDonToiThieu DECIMAL(18, 2) NOT NULL DEFAULT 0,
	NgayBatDau DATE NOT NULL,
	NgayKetThuc DATE NOT NULL,
	TrangThai NVARCHAR(50) NOT NULL DEFAULT N'Còn hiệu lực',
	MaChienDich VARCHAR(20) NULL,
	CONSTRAINT PK_KhuyenMai PRIMARY KEY (MaKhuyenMai),
	CONSTRAINT FK_KM_ChienDich FOREIGN KEY (MaChienDich)
    	REFERENCES CHIEN_DICH_TRUYEN_THONG(MaChienDich) ON DELETE SET NULL,
	CONSTRAINT CK_KM_Ngay CHECK (NgayKetThuc >= NgayBatDau),
	CONSTRAINT CK_KM_GiaTriGiam CHECK (GiaTriGiam > 0)
);
-- 2.4. Bảng SU_KIEN (Phân hệ Marketing - Ra mắt phim, Fan meeting, Họp báo)
CREATE TABLE SU_KIEN (
	MaSuKien VARCHAR(20) NOT NULL,
	TenSuKien NVARCHAR(150) NOT NULL,
	ThoiGianBatDau DATETIME2 NOT NULL,
	ThoiGianKetThuc DATETIME2 NOT NULL,
	DiaDiem NVARCHAR(200) NOT NULL,
	SoLuongKhachDuKien INT NOT NULL DEFAULT 0,
	ChiPhiDuKien DECIMAL(18, 2) NOT NULL DEFAULT 0,
	MaChienDich VARCHAR(20) NULL,
	CONSTRAINT PK_SuKien PRIMARY KEY (MaSuKien),
	CONSTRAINT FK_SK_ChienDich FOREIGN KEY (MaChienDich)
    	REFERENCES CHIEN_DICH_TRUYEN_THONG(MaChienDich) ON DELETE SET NULL,
	CONSTRAINT CK_SK_ThoiGian CHECK (ThoiGianKetThuc >= ThoiGianBatDau),
	CONSTRAINT CK_SK_SoKhach CHECK (SoLuongKhachDuKien >= 0),
	CONSTRAINT CK_SK_ChiPhi CHECK (ChiPhiDuKien >= 0)
);
-- 2.5. Bảng DOI_TAC (Phân hệ Đối tác & Nhà cung cấp)
CREATE TABLE DOI_TAC (
	MaDoiTac VARCHAR(20) NOT NULL,
	TenDoiTac NVARCHAR(200) NOT NULL,
	LoaiDoiTac NVARCHAR(100) NOT NULL,
	NguoiDaiDien NVARCHAR(100) NULL,
	SoDienThoai VARCHAR(20) NULL,
	Email VARCHAR(100) NULL,
	DiaChi NVARCHAR(255) NULL,
	MaSoThue VARCHAR(30) NULL,
	CONSTRAINT PK_DoiTac PRIMARY KEY (MaDoiTac),
	CONSTRAINT UQ_DoiTac_MST UNIQUE (MaSoThue)
);
-- 2.6. Bảng DOI_TAC_SU_KIEN (Bảng trung gian N - M có thuộc tính quan hệ)
CREATE TABLE DOI_TAC_SU_KIEN (
	MaDoiTac VARCHAR(20) NOT NULL,
	MaSuKien VARCHAR(20) NOT NULL,
	VaiTroThamGia NVARCHAR(100) NOT NULL,
	SoTienTaiTro DECIMAL(18, 2) NOT NULL DEFAULT 0,
	QuyenLoi NVARCHAR(255) NULL,
	CONSTRAINT PK_DoiTac_SuKien PRIMARY KEY (MaDoiTac, MaSuKien),
	CONSTRAINT FK_DTSK_DoiTac FOREIGN KEY (MaDoiTac)
    	REFERENCES DOI_TAC(MaDoiTac) ON DELETE CASCADE,
	CONSTRAINT FK_DTSK_SuKien FOREIGN KEY (MaSuKien)
    	REFERENCES SU_KIEN(MaSuKien) ON DELETE CASCADE,
	CONSTRAINT CK_DTSK_Tien CHECK (SoTienTaiTro >= 0)
);
-- 2.7. Bảng HOP_DONG (Phân hệ Đối tác & Nhà cung cấp)
CREATE TABLE HOP_DONG (
	MaHopDong VARCHAR(20) NOT NULL,
	SoHopDong VARCHAR(50) NOT NULL,
	TieuDe NVARCHAR(200) NOT NULL,
	LoaiHopDong NVARCHAR(100) NOT NULL,
	NgayKy DATE NOT NULL,
	NgayHieuLuc DATE NOT NULL,
	NgayHetHan DATE NOT NULL,
	GiaTriHopDong DECIMAL(18, 2) NOT NULL DEFAULT 0,
	TrangThai NVARCHAR(50) NOT NULL DEFAULT N'Đang thực hiện',
	MaDoiTac VARCHAR(20) NOT NULL,
	CONSTRAINT PK_HopDong PRIMARY KEY (MaHopDong),
	CONSTRAINT UQ_HopDong_SoHD UNIQUE (SoHopDong),
	CONSTRAINT FK_HD_DoiTac FOREIGN KEY (MaDoiTac)
    	REFERENCES DOI_TAC(MaDoiTac),
	CONSTRAINT CK_HD_Ngay CHECK (NgayHetHan >= NgayHieuLuc),
	CONSTRAINT CK_HD_GiaTri CHECK (GiaTriHopDong >= 0)
);
-- 2.8. Bảng HOP_DONG_PHIM (Kiểm soát nguồn bản quyền chiếu phim)
CREATE TABLE HOP_DONG_PHIM (
	MaHopDong VARCHAR(20) NOT NULL,
	MaPhim VARCHAR(20) NOT NULL,
	NgayBatDauChieu DATE NOT NULL,
	NgayKetThucChieu DATE NOT NULL,
	PhiBanQuyen DECIMAL(18, 2) NOT NULL DEFAULT 0,
	TyLeChiaDoanhThu DECIMAL(5, 2) NOT NULL DEFAULT 0,
	CONSTRAINT PK_HopDong_Phim PRIMARY KEY (MaHopDong, MaPhim),
	CONSTRAINT FK_HDP_HopDong FOREIGN KEY (MaHopDong)
    	REFERENCES HOP_DONG(MaHopDong) ON DELETE CASCADE,
	CONSTRAINT FK_HDP_Phim FOREIGN KEY (MaPhim)
    	REFERENCES PHIM(MaPhim) ON DELETE CASCADE,
	CONSTRAINT CK_HDP_Ngay CHECK (NgayKetThucChieu >= NgayBatDauChieu),
	CONSTRAINT CK_HDP_TyLe CHECK (TyLeChiaDoanhThu BETWEEN 0 AND 100)
);
-- 2.9. Bảng KHOAN_CHI (Quản lý chi trả giải ngân cho đối tác / hợp đồng)
CREATE TABLE KHOAN_CHI (
	MaKhoanChi VARCHAR(20) NOT NULL,
	NgayChi DATE NOT NULL DEFAULT CAST(GETDATE() AS DATE),
	SoTien DECIMAL(18, 2) NOT NULL,
	NoiDungChi NVARCHAR(255) NOT NULL,
	HinhThucThanhToan NVARCHAR(50) NOT NULL DEFAULT N'Chuyển khoản',
	MaDoiTac VARCHAR(20) NOT NULL,
	MaHopDong VARCHAR(20) NULL,
	CONSTRAINT PK_KhoanChi PRIMARY KEY (MaKhoanChi),
	CONSTRAINT FK_KC_DoiTac FOREIGN KEY (MaDoiTac)
    	REFERENCES DOI_TAC(MaDoiTac),
	CONSTRAINT FK_KC_HopDong FOREIGN KEY (MaHopDong)
    	REFERENCES HOP_DONG(MaHopDong) ON DELETE SET NULL,
	CONSTRAINT CK_KC_SoTien CHECK (SoTien > 0)
);
GO
 3. Kịch bản nhập dữ liệu mẫu
Dữ liệu mẫu được xây dựng sát thực tế rạp chiếu phim Việt Nam, đảm bảo tính toàn vẹn tham chiếu không vi phạm bất kỳ ràng buộc nào:
-- Thêm dữ liệu bảng PHIM
INSERT INTO PHIM VALUES
('P001', N'Đào, Phở và Piano', 100, N'T13'),
('P002', N'Mai', 131, N'T18'),
('P003', N'Dune: Part Two (Hành Tinh Cát 2)', 166, N'T16'),
('P004', N'Kung Fu Panda 4', 94, N'P'),
('P005', N'Lật Mặt 7: Một Điều Ước', 138, N'T13');
-- Thêm dữ liệu bảng CHIEN_DICH_TRUYEN_THONG
INSERT INTO CHIEN_DICH_TRUYEN_THONG VALUES
('CD01', N'Chào Hè Rực Rỡ 2026', N'Tăng 30% doanh số vé hè', '2026-05-01', '2026-06-30', 150000000, 120000000, N'Đang thực hiện'),
('CD02', N'Đại Tiệc Bom Tấn Mùa Thu', N'Quảng bá chùm phim bom tấn', '2026-09-01', '2026-10-31', 200000000, 195000000, N'Đang thực hiện'),
('CD03', N'Tuần Lễ Phim Việt Nam', N'Tôn vinh điện ảnh nước nhà', '2026-02-10', '2026-02-28', 80000000, 75000000, N'Đã kết thúc');
-- Thêm dữ liệu bảng CHUONG_TRINH_KHUYEN_MAI
INSERT INTO CHUONG_TRINH_KHUYEN_MAI VALUES
('KM01', N'Ưu Đãi Học Sinh Sinh Viên', N'Tiền mặt', 20000, 80000, '2026-05-01', '2026-06-30', N'Còn hiệu lực', 'CD01'),
('KM02', N'Combo Bắp Nước Siêu Rẻ', N'Phần trăm', 25.0, 150000, '2026-05-15', '2026-06-15', N'Còn hiệu lực', 'CD01'),
('KM03', N'Giảm 20% Suất Chiếu Bom Tấn', N'Phần trăm', 20.0, 120000, '2026-09-01', '2026-10-31', N'Còn hiệu lực', 'CD02');
-- Thêm dữ liệu bảng SU_KIEN
INSERT INTO SU_KIEN VALUES
('SK01', N'Công Chiếu Premiere Dune 2', '2026-09-05 18:30', '2026-09-05 22:30', N'Phòng chiếu số 1 - Rạp Thủy Lợi Cinema', 250, 45000000, 'CD02'),
('SK02', N'Giao Lưu Dàn Diễn Viên Phim Mai', '2026-02-14 19:00', '2026-02-14 21:30', N'Sảnh lớn tầng 2', 300, 35000000, 'CD03'),
('SK03', N'Đêm Hội Điện Ảnh Cosplay Hè', '2026-06-01 17:00', '2026-06-01 22:00', N'Sảnh ngoài trời và Rạp số 2', 400, 50000000, 'CD01');
-- Thêm dữ liệu bảng DOI_TAC
INSERT INTO DOI_TAC VALUES
('DT01', N'Công ty Cổ phần CJ ENM Việt Nam', N'Nhà phân phối phim', N'Nguyễn Văn An', '0901234567', 'an@cjenm.vn', N'Quận 1, TP. Hồ Chí Minh', '0301122334'),
('DT02', N'Công ty TNHH Phân Phối Galaxy Studio', N'Nhà phân phối phim', N'Trần Thị Bích', '0912345678', 'bich@galaxy.vn', N'Quận 3, TP. Hồ Chí Minh', '0302233445'),
('DT03', N'Tập đoàn Âm thanh JBL Harman', N'Nhà cung cấp thiết bị', N'David Lee', '0988776655', 'lee@harman.com', N'Cầu Giấy, Hà Nội', '0103344556'),
('DT04', N'Công ty Cổ phần Beatvn Media', N'Đơn vị truyền thông', N'Phạm Quang Hưng', '0977665544', 'contact@beatvn.com', N'Đống Đa, Hà Nội', '0104455667'),
('DT05', N'Công ty Suntory PepsiCo Việt Nam', N'Nhà tài trợ', N'Lê Hoàng Long', '0933221100', 'long@pepsico.vn', N'Bình Dương', '3700123456');
-- Thêm dữ liệu bảng DOI_TAC_SU_KIEN
INSERT INTO DOI_TAC_SU_KIEN VALUES
('DT05', 'SK01', N'Nhà tài trợ Kim Cương', 30000000, N'Đặt gian hàng nước ngọt & logo backdrop'),
('DT04', 'SK01', N'Bảo trợ truyền thông', 0, N'Đưa tin bài viral và livestream sự kiện'),
('DT01', 'SK02', N'Đơn vị đồng tổ chức', 25000000, N'Phát biểu khai mạc và chụp ảnh lưu niệm cùng ekip'),
('DT05', 'SK03', N'Nhà tài trợ Vàng', 20000000, N'Tài trợ combo quà tặng cho khách cosplay');
-- Thêm dữ liệu bảng HOP_DONG
INSERT INTO HOP_DONG VALUES
('HD01', 'HD-2026/01/CJ', N'HĐ bản quyền phim Mai & Đào Phở Piano', N'Bản quyền phim', '2026-01-10', '2026-01-15', '2026-06-30', 120000000, N'Đang thực hiện', 'DT01'),
('HD02', 'HD-2026/02/GALAXY', N'HĐ bản quyền phim Dune 2 & Lật Mặt 7', N'Bản quyền phim', '2026-02-01', '2026-02-15', '2026-11-30', 250000000, N'Đang thực hiện', 'DT02'),
('HD03', 'HD-2026/03/JBL', N'Cung cấp và bảo trì hệ thống loa Atmos', N'Cung cấp thiết bị', '2026-03-01', '2026-03-10', '2027-03-10', 180000000, N'Đang thực hiện', 'DT03'),
('HD04', 'HD-2026/04/BEAT', N'Gói truyền thông viral mạng xã hội hè', N'Truyền thông quảng cáo', '2026-04-20', '2026-05-01', '2026-07-01', 60000000, N'Đang thực hiện', 'DT04');
-- Thêm dữ liệu bảng HOP_DONG_PHIM
INSERT INTO HOP_DONG_PHIM VALUES
('HD01', 'P001', '2026-02-10', '2026-04-30', 40000000, 50.0),
('HD01', 'P002', '2026-02-10', '2026-05-15', 80000000, 55.0),
('HD02', 'P003', '2026-03-01', '2026-06-30', 150000000, 50.0),
('HD02', 'P005', '2026-04-26', '2026-08-31', 100000000, 52.5);
-- Thêm dữ liệu bảng KHOAN_CHI
INSERT INTO KHOAN_CHI VALUES
('KC01', '2026-01-20', 60000000, N'Thanh toán đợt 1 bản quyền phim Mai cho CJ', N'Chuyển khoản', 'DT01', 'HD01'),
('KC02', '2026-02-25', 125000000, N'Tạm ứng tiền bản quyền phát hành phim Dune 2', N'Chuyển khoản', 'DT02', 'HD02'),
('KC03', '2026-03-15', 90000000, N'Thanh toán đợt 1 lắp đặt hệ thống loa JBL', N'Chuyển khoản', 'DT03', 'HD03'),
('KC04', '2026-05-05', 30000000, N'Thanh toán 50% chi phí truyền thông hè Beatvn', N'Chuyển khoản', 'DT04', 'HD04'),
('KC05', '2026-06-25', 60000000, N'Quyết toán đợt 2 bản quyền phim Mai cho CJ', N'Chuyển khoản', 'DT01', 'HD01'); 
PHẦN VI: YÊU CẦU SỐ 6 - BỘ 5 CÂU HỎI TRUY VẤN (ĐSQH VÀ SQL SERVER)
Cơ cấu 5 câu hỏi truy vấn tuân thủ nghiêm ngặt quy định của Bộ môn HTTT: 1 câu có điều kiện trên 1 bảng, 2 câu nhiều bảng, 1 câu gom nhóm tính tổng, 1 câu truy vấn lồng
CÂU 1: TRUY VẤN CÓ ĐIỀU KIỆN TRÊN MỘT BẢNG
Yêu cầu nghiệp vụ: Tìm danh sách các đối tác thuộc nhóm "Nhà phân phối phim" có trụ sở tại "TP. Hồ Chí Minh", gồm: Mã đối tác, Tên đối tác, Loại đối tác, Người đại diện, Số điện thoại và Địa chỉ.
1. Biểu thức Đại số quan hệ:
KQTG  ←  σ_{(LoaiDoiTac = 'Nhà phân phối phim') ∧ (DiaChi LIKE '%TP. Hồ Chí Minh%')} (DOI_TAC)
KETQUA  ←  Π_{MaDoiTac, TenDoiTac, LoaiDoiTac, NguoiDaiDien, SoDienThoai, DiaChi} (KQTG)
• Giải thích: Áp dụng phép chọn σ với 2 điều kiện kết hợp bằng phép hội ∧ để lọc các bộ hợp lệ, sau đó áp dụng phép chiếu Π để lấy đúng 6 thuộc tính cần báo cáo.
2. Câu lệnh SQL Server:
SELECT MaDoiTac, TenDoiTac, LoaiDoiTac, NguoiDaiDien, SoDienThoai, DiaChi
FROM DOI_TAC
WHERE LoaiDoiTac = N'Nhà phân phối phim'
  AND DiaChi LIKE N'%TP. Hồ Chí Minh%';
3. Bảng kết quả (Result set):
 CÂU 2: TRUY VẤN TRÊN NHIỀU BẢNG
Yêu cầu nghiệp vụ: Liệt kê các sự kiện do rạp tổ chức kèm theo tên chiến dịch truyền thông quản lý sự kiện đó và chi phí dự kiến, sắp xếp theo chi phí giảm dần.
1. Biểu thức Đại số quan hệ:
KQTG  ←  SU_KIEN  ⋈_{SU_KIEN.MaChienDich = CHIEN_DICH_TRUYEN_THONG.MaChienDich}  CHIEN_DICH_TRUYEN_THONG
KETQUA  ←  Π_{MaSuKien, TenSuKien, DiaDiem, ThoiGianBatDau, ChiPhiDuKien, TenChienDich} (KQTG)
2. Câu lệnh SQL Server:
• Cách 1: Cú pháp kết nối tường minh (Explicit JOIN - Khuyên dùng):
SELECT sk.MaSuKien, sk.TenSuKien, sk.DiaDiem, sk.ThoiGianBatDau, sk.ChiPhiDuKien, cd.TenChienDich
FROM SU_KIEN AS sk
INNER JOIN CHIEN_DICH_TRUYEN_THONG AS cd ON sk.MaChienDich = cd.MaChienDich
ORDER BY sk.ChiPhiDuKien DESC;
• Cách 2: Cú pháp kết nối không tường minh (Implicit JOIN - Trong mệnh đề WHERE):
SELECT sk.MaSuKien, sk.TenSuKien, sk.DiaDiem, sk.ThoiGianBatDau, sk.ChiPhiDuKien, cd.TenChienDich
FROM SU_KIEN sk, CHIEN_DICH_TRUYEN_THONG cd
WHERE sk.MaChienDich = cd.MaChienDich
ORDER BY sk.ChiPhiDuKien DESC;
3. Bảng kết quả (Result set):
 CÂU 3: TRUY VẤN TRÊN NHIỀU BẢNG
Yêu cầu nghiệp vụ: Cho biết thông tin các đối tác có tham gia tài trợ tiền cho sự kiện của rạp (Số tiền tài trợ > 0), gồm: Tên đối tác, Loại đối tác, Tên sự kiện, Vai trò tham gia, Số tiền tài trợ và Quyền lợi.
1. Biểu thức Đại số quan hệ :
R1  ←  DOI_TAC  ⋈_{DOI_TAC.MaDoiTac = DOI_TAC_SU_KIEN.MaDoiTac}  DOI_TAC_SU_KIEN
R2  ←  R1  ⋈_{DOI_TAC_SU_KIEN.MaSuKien = SU_KIEN.MaSuKien}  SU_KIEN
KQTG  ←  σ_{SoTienTaiTro > 0} (R2)
KETQUA  ←  Π_{TenDoiTac, LoaiDoiTac, TenSuKien, VaiTroThamGia, SoTienTaiTro, QuyenLoi} (KQTG)
2. Câu lệnh SQL Server :
SELECT dt.TenDoiTac, dt.LoaiDoiTac, sk.TenSuKien, dtsk.VaiTroThamGia, dtsk.SoTienTaiTro, dtsk.QuyenLoi
FROM DOI_TAC dt
INNER JOIN DOI_TAC_SU_KIEN dtsk ON dt.MaDoiTac = dtsk.MaDoiTac
INNER JOIN SU_KIEN sk ON dtsk.MaSuKien = sk.MaSuKien
WHERE dtsk.SoTienTaiTro > 0
ORDER BY dtsk.SoTienTaiTro DESC;
3. Bảng kết quả (Result set):
 CÂU 4: TRUY VẤN TÍNH TỔNG (SUMMARY QUERY - GROUP BY & HAVING)
Yêu cầu nghiệp vụ: Thống kê tổng số tiền rạp đã giải ngân chi trả cho từng đối tác nhận tiền, lọc ra các đối tác có tổng chi trả từ 50.000.000 VNĐ trở lên, hiển thị: Mã đối tác, Tên đối tác, Số lần chi và Tổng tiền đã chi.
1. Biểu thức Đại số quan hệ:
KQTG  ←  DOI_TAC  ⋈_{DOI_TAC.MaDoiTac = KHOAN_CHI.MaDoiTac}  KHOAN_CHI
R1  ←  [MaDoiTac, TenDoiTac] F_{COUNT(MaKhoanChi) → SoLanChi, SUM(SoTien) → TongTienDaChi} (KQTG)
KETQUA  ←  σ_{TongTienDaChi ≥ 50000000} (R1)
2. Câu lệnh SQL Server:
SELECT dt.MaDoiTac, dt.TenDoiTac, COUNT(kc.MaKhoanChi) AS SoLanChi, SUM(kc.SoTien) AS TongTienDaChi
FROM DOI_TAC dt
INNER JOIN KHOAN_CHI kc ON dt.MaDoiTac = kc.MaDoiTac
GROUP BY dt.MaDoiTac, dt.TenDoiTac
HAVING SUM(kc.SoTien) >= 50000000
ORDER BY TongTienDaChi DESC;
3. Bảng kết quả (Result set):
CÂU 5: TRUY VẤN LỒNG (SUBQUERY TRONG MỆNH ĐỀ WHERE)
Yêu cầu nghiệp vụ: Tìm danh sách các hợp đồng (Mã hợp đồng, Số hợp đồng, Tiêu đề, Giá trị hợp đồng, Tên đối tác) có Giá trị hợp đồng lớn hơn giá trị hợp đồng trung bình (AVG) của toàn bộ các hợp đồng trong rạp.
1. Biểu thức Đại số quan hệ :
E_avg  ←  F_{AVERAGE(GiaTriHopDong) → GiaTriTB} (HOP_DONG)
R1  ←  HOP_DONG  ⋈_{GiaTriHopDong > GiaTriTB}  E_avg
R2  ←  R1  ⋈_{HOP_DONG.MaDoiTac = DOI_TAC.MaDoiTac}  DOI_TAC
KETQUA  ←  Π_{MaHopDong, SoHopDong, TieuDe, GiaTriHopDong, TenDoiTac} (R2)
2. Câu lệnh SQL Server:
SELECT hd.MaHopDong, hd.SoHopDong, hd.TieuDe, hd.GiaTriHopDong, dt.TenDoiTac
FROM HOP_DONG hd
INNER JOIN DOI_TAC dt ON hd.MaDoiTac = dt.MaDoiTac
WHERE hd.GiaTriHopDong > (
	SELECT AVG(GiaTriHopDong)
	FROM HOP_DONG
)
ORDER BY hd.GiaTriHopDong DESC;
3. Bảng kết quả (Result set):
*(Giá trị hợp đồng trung bình: (120M + 250M + 180M + 60M) / 4 = 152.500.000 VNĐ. Câu lệnh lọc các hợp đồng > 152.5M VNĐ):*