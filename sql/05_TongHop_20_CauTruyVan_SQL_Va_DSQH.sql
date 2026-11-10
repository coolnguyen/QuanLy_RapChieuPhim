-- ===============================================================================
-- TỔNG HỢP 20 CÂU HỎI TRUY VẤN (ĐẠI SỐ QUAN HỆ & SQL SERVER)
-- BÀI TẬP LỚN CƠ SỞ DỮ LIỆU - NHÓM 11 (LỚP 67KTPM2)
-- ĐẦY ĐỦ 4 NHÓM KỸ THUẬT:
--   (1) Truy vấn 1 bảng
--   (2) Truy vấn kết nối nhiều bảng (JOIN)
--   (3) Truy vấn gom nhóm & hàm tổng hợp (GROUP BY, HAVING)
--   (4) Truy vấn lồng (Subquery / ALL / IN / NOT IN / NOT EXISTS)
-- ===============================================================================

USE QL_RapChieuPhim_TongHop;
GO

-- ===============================================================================
-- PHÂN HỆ 1: LỊCH CHIẾU & PHIM VÀ VÉ & ĐẶT CHỖ (Nguyễn Xuân Trường)
-- ===============================================================================

-- [Câu 1] Truy vấn kết nối nhiều bảng (JOIN)
-- Nghiệp vụ: Liệt kê các suất chiếu của bộ phim 'Mai' kèm thông tin phòng chiếu và giá vé.
-- ĐSQH: KETQUA = π_{TenPhim, TenPhong, NgayChieu, GioBatDau, GiaVeCoBan}(σ_{TenPhim = N'Mai'}(SUAT_CHIEU ⋈ PHIM ⋈ PHONG_CHIEU))
SELECT p.TenPhim, pc.TenPhong, sc.NgayChieu, sc.GioBatDau, sc.GiaVeCoBan
FROM SUAT_CHIEU sc
JOIN PHIM p ON sc.MaPhim = p.MaPhim
JOIN PHONG_CHIEU pc ON sc.MaPhong = pc.MaPhong
WHERE p.TenPhim = N'Mai';
GO

-- [Câu 2] Truy vấn kết nối 4 bảng (JOIN)
-- Nghiệp vụ: Tra cứu danh sách vé đã đặt kèm họ tên khách hàng, số ghế và ngày chiếu.
-- ĐSQH: KETQUA = π_{MaVe, HoTen, SoGhe, NgayChieu, GiaVe}(VE ⋈ KHACH_HANG ⋈ GHE ⋈ SUAT_CHIEU)
SELECT v.MaVe, kh.HoTen, g.SoGhe, sc.NgayChieu, v.GiaVe
FROM VE v
JOIN KHACH_HANG kh ON v.MaKH = kh.MaKH
JOIN GHE g ON v.MaGhe = g.MaGhe
JOIN SUAT_CHIEU sc ON v.MaSuatChieu = sc.MaSuatChieu;
GO

-- [Câu 3] Gom nhóm & hàm tổng hợp (GROUP BY)
-- Nghiệp vụ: Thống kê tổng số vé bán ra và tổng doanh thu thu được theo từng bộ phim.
-- ĐSQH: KETQUA = γ_{TenPhim, COUNT(MaVe)->TongVe, SUM(GiaVe)->DoanhThu}(PHIM ⋈ SUAT_CHIEU ⋈ VE)
SELECT p.TenPhim, COUNT(v.MaVe) AS TongVeBan, SUM(v.GiaVe) AS TongDoanhThu
FROM PHIM p
JOIN SUAT_CHIEU sc ON p.MaPhim = sc.MaPhim
JOIN VE v ON sc.MaSuatChieu = v.MaSuatChieu
GROUP BY p.TenPhim;
GO

-- [Câu 4] Gom nhóm có điều kiện lọc (HAVING)
-- Nghiệp vụ: Tìm các khách hàng thân thiết đã mua từ 2 vé trở lên.
SELECT kh.MaKH, kh.HoTen, COUNT(v.MaVe) AS SoVeDaMua, SUM(v.GiaVe) AS TongTien
FROM KHACH_HANG kh
JOIN VE v ON kh.MaKH = v.MaKH
GROUP BY kh.MaKH, kh.HoTen
HAVING COUNT(v.MaVe) >= 2;
GO

-- [Câu 5] Truy vấn lồng (Subquery / NOT IN)
-- Nghiệp vụ: Tìm các bộ phim hiện chưa có suất chiếu nào được xếp lịch.
-- ĐSQH: KETQUA = π_{MaPhim, TenPhim}(PHIM) - π_{MaPhim, TenPhim}(PHIM ⋈ SUAT_CHIEU)
SELECT MaPhim, TenPhim
FROM PHIM
WHERE MaPhim NOT IN (SELECT DISTINCT MaPhim FROM SUAT_CHIEU);
GO


-- ===============================================================================
-- PHÂN HỆ 2: KHÁCH HÀNG VÀ NHÂN SỰ (Nguyễn Văn Đức)
-- ===============================================================================

-- [Câu 6 / PH2-C1] Truy vấn trên 1 bảng
-- Nghiệp vụ: Lọc danh sách nhân viên có mức lương cơ bản trên 7.000.000 VNĐ.
-- ĐSQH: KETQUA = π_{MaNS, HoTen, ChucVu, LuongCoBan}(σ_{LuongCoBan > 7000000}(NHAN_SU))
SELECT MaNS, HoTen, ChucVu, LuongCoBan
FROM NHAN_SU
WHERE LuongCoBan > 7000000;
GO

-- [Câu 7 / PH2-C2] Truy vấn kết nối nhiều bảng (JOIN)
-- Nghiệp vụ: Hiển thị hóa đơn kèm tên khách hàng, hạng thẻ thành viên và mức chiết khấu.
SELECT hd.MaHD, hd.NgayLap, kh.HoTen, ltv.TenLoaiTV, ltv.ChietKhau
FROM HOA_DON_TONG hd
JOIN KHACH_HANG kh ON hd.MaKH = kh.MaKH
JOIN LOAI_THANH_VIEN ltv ON kh.MaLoaiTV = ltv.MaLoaiTV;
GO

-- [Câu 8 / PH2-C3] Truy vấn kết nối 3 bảng (JOIN)
-- Nghiệp vụ: Liệt kê hồ sơ nhân sự kèm tên bộ phận và tên chi nhánh làm việc.
SELECT ns.MaNS, ns.HoTen, ns.ChucVu, bp.TenBP, cn.TenCN
FROM NHAN_SU ns
JOIN BO_PHAN bp ON ns.MaBP = bp.MaBP
JOIN CHI_NHANH cn ON bp.MaCN = cn.MaCN;
GO

-- [Câu 9 / PH2-C4] Gom nhóm & Tính tổng (GROUP BY)
-- Nghiệp vụ: Thống kê số lượng nhân viên và tổng quỹ lương theo từng chi nhánh.
SELECT cn.TenCN, COUNT(ns.MaNS) AS SoNhanVien, SUM(ns.LuongCoBan) AS TongQuyLuong
FROM CHI_NHANH cn
JOIN BO_PHAN bp ON cn.MaCN = bp.MaCN
JOIN NHAN_SU ns ON bp.MaBP = ns.MaBP
GROUP BY cn.TenCN;
GO

-- [Câu 10 / PH2-C5] Truy vấn lồng (Subquery so sánh > AVG)
-- Nghiệp vụ: Tìm các sản phẩm bắp nước có đơn giá cao hơn đơn giá trung bình và đã từng được bán.
SELECT DISTINCT sp.MaSP, sp.TenSP, sp.DonGia
FROM SAN_PHAM_KHO sp
JOIN CHI_TIET_BAN_SP ct ON sp.MaSP = ct.MaSP
WHERE sp.DonGia > (SELECT AVG(DonGia) FROM SAN_PHAM_KHO);
GO


-- ===============================================================================
-- PHÂN HỆ 3: TÀI CHÍNH VÀ CƠ SỞ VẬT CHẤT & KỸ THUẬT (Cung Thành Trung)
-- ===============================================================================

-- [Câu 11 / PH3-C1] Truy vấn kết nối 3 bảng (JOIN)
-- Nghiệp vụ: Liệt kê danh sách thiết bị kỹ thuật kèm phòng chiếu và nhóm thiết bị.
SELECT tb.MaTB, tb.TenTB, pc.TenPhong, ltb.TenLoaiTB, tb.TinhTrang
FROM THIET_BI tb
JOIN PHONG_CHIEU pc ON tb.MaPhong = pc.MaPhong
JOIN LOAI_THIET_BI ltb ON tb.MaLoaiTB = ltb.MaLoaiTB;
GO

-- [Câu 12 / PH3-C2] Gom nhóm có điều kiện lọc (GROUP BY / HAVING)
-- Nghiệp vụ: Thống kê các bộ phim có tổng doanh thu vượt trên 100.000.000 VNĐ.
SELECT p.TenPhim, SUM(dt.TongDoanhThu) AS TongDoanhThuPhim
FROM DOANH_THU dt
JOIN SUAT_CHIEU sc ON dt.MaSuatChieu = sc.MaSuatChieu
JOIN PHIM p ON sc.MaPhim = p.MaPhim
GROUP BY p.TenPhim
HAVING SUM(dt.TongDoanhThu) > 100000000;
GO

-- [Câu 13 / PH3-C3] Gom nhóm đa bảng (LEFT JOIN + GROUP BY)
-- Nghiệp vụ: Tổng hợp số lần bảo trì và tổng chi phí kỹ thuật theo từng phòng chiếu.
SELECT pc.TenPhong, COUNT(DISTINCT bt.MaBaoTri) AS SoLanBaoTri, ISNULL(SUM(bt.ChiPhiBaoTri), 0) AS TongChiPhiBaoTri
FROM PHONG_CHIEU pc
LEFT JOIN THIET_BI tb ON pc.MaPhong = tb.MaPhong
LEFT JOIN BAO_TRI bt ON tb.MaTB = bt.MaTB
GROUP BY pc.TenPhong;
GO

-- [Câu 14 / PH3-C4] Truy vấn lồng (Subquery > AVG)
-- Nghiệp vụ: Tìm các suất chiếu có tổng doanh thu lớn hơn mức doanh thu trung bình toàn rạp.
SELECT sc.MaSuatChieu, p.TenPhim, dt.TongDoanhThu
FROM DOANH_THU dt
JOIN SUAT_CHIEU sc ON dt.MaSuatChieu = sc.MaSuatChieu
JOIN PHIM p ON sc.MaPhim = p.MaPhim
WHERE dt.TongDoanhThu > (SELECT AVG(TongDoanhThu) FROM DOANH_THU);
GO

-- [Câu 15 / PH3-C5] Truy vấn lồng cực trị (>= ALL / MAX)
-- Nghiệp vụ: Xác định thiết bị tiêu tốn tổng chi phí bảo trì lớn nhất.
SELECT tb.MaTB, tb.TenTB, SUM(bt.ChiPhiBaoTri) AS TongChiPhi
FROM THIET_BI tb
JOIN BAO_TRI bt ON tb.MaTB = bt.MaTB
GROUP BY tb.MaTB, tb.TenTB
HAVING SUM(bt.ChiPhiBaoTri) >= ALL (
    SELECT SUM(ChiPhiBaoTri) 
    FROM BAO_TRI 
    GROUP BY MaTB
);
GO


-- ===============================================================================
-- PHÂN HỆ 4: MARKETING & TRUYỀN THÔNG VÀ ĐỐI TÁC & NHÀ CUNG CẤP (Ngụy Công Vinh)
-- ===============================================================================

-- [Câu 16 / PH4-C1] Truy vấn trên 1 bảng
-- Nghiệp vụ: Lọc các chiến dịch truyền thông có ngân sách từ 100.000.000 VNĐ trở lên.
SELECT MaCD, TenCD, NganSach, KenhTrienKhai
FROM CHIEN_DICH
WHERE NganSach >= 100000000;
GO

-- [Câu 17 / PH4-C2] Truy vấn kết nối 3 bảng (JOIN)
-- Nghiệp vụ: Hiển thị sự kiện ra mắt kèm tên chiến dịch truyền thông và tên bộ phim.
SELECT sk.MaSK, sk.TenSK, cd.TenCD, p.TenPhim, sk.NgayToChuc
FROM SU_KIEN sk
JOIN CHIEN_DICH cd ON sk.MaCD = cd.MaCD
JOIN PHIM p ON sk.MaPhim = p.MaPhim;
GO

-- [Câu 18 / PH4-C3] Truy vấn kết nối 4 bảng (JOIN)
-- Nghiệp vụ: Tra cứu chi tiết bản quyền phim ký với từng đối tác/nhà phát hành.
SELECT dt.TenDT, hd.SoHopDong, p.TenPhim, hdp.GiaBanQuyen, hdp.TyLeChiaDoanhThu
FROM DOI_TAC dt
JOIN HOP_DONG hd ON dt.MaDT = hd.MaDT
JOIN HOP_DONG_PHIM hdp ON hd.MaHD = hdp.MaHD
JOIN PHIM p ON hdp.MaPhim = p.MaPhim;
GO

-- [Câu 19 / PH4-C4] Gom nhóm & Hàm tổng hợp (GROUP BY / HAVING)
-- Nghiệp vụ: Thống kê tổng số sự kiện và tổng giá trị tài trợ theo từng đối tác.
SELECT dt.TenDT, COUNT(dtsk.MaSK) AS SoSuKienThamGia, SUM(dtsk.GiaTriTaiTro) AS TongGiaTriTaiTro
FROM DOI_TAC dt
JOIN DOI_TAC_SU_KIEN dtsk ON dt.MaDT = dtsk.MaDT
GROUP BY dt.TenDT
HAVING SUM(dtsk.GiaTriTaiTro) > 0;
GO

-- [Câu 20 / PH4-C5] Truy vấn lồng (Subquery > AVG)
-- Nghiệp vụ: Tìm các mã khuyến mãi thuộc chiến dịch có ngân sách cao hơn ngân sách trung bình.
SELECT km.MaKM, km.TenKM, km.GiaTriGiam, cd.TenCD, cd.NganSach
FROM KHUYEN_MAI km
JOIN CHIEN_DICH cd ON km.MaCD = cd.MaCD
WHERE cd.NganSach > (SELECT AVG(NganSach) FROM CHIEN_DICH);
GO
