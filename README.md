# Quản lý rạp chiếu phim

Dự án môn Cơ sở dữ liệu — nhóm 5 người. Trước mắt tập trung YC1 (mô tả nghiệp vụ) và YC2 (phân tích, giải thích, vẽ ER).

## 1. Nhánh làm việc

| Nhánh | Người phụ trách | Phần việc |
| --- | --- | --- |
| main | Hải kiểm tra và ghép bài | Bản chung đã kiểm tra |
| marketing-tong-hop | Hải — N1 | Marketing, điều phối, tổng hợp ER |
| lich-chieu | N2 | Phim, phòng, ghế, lịch chiếu |
| ve-khach-hang | N3 | Vé, đặt vé, thanh toán, khách hàng |
| nhan-su | N4 | Nhân sự, ca làm; tổng hợp báo cáo Word |
| van-hanh-doi-tac | N5 | Thiết bị, bảo trì, tài chính, đối tác |

N2–N5 là mã theo phân công; bổ sung tên thật sau. Mỗi nhánh chứa toàn bộ dự án. Mỗi người chủ yếu sửa file phần mình phụ trách.

Quy ước: làm trên nhánh phụ trách → tạo Pull Request vào main → Hải kiểm tra và merge. Không sửa bài trực tiếp trên main. Đây là quy ước nhóm, chưa phải cơ chế chặn quyền trên GitHub.

## 2. Lưu file ở đâu?

| Thư mục | Nội dung |
| --- | --- |
| docs/ | Mô tả YC1 và giải thích YC2 của từng phần (.docx hoặc .md) |
| er/ | Sơ đồ gốc .drawio; có thể kèm PDF/PNG để xem |
| sql/ | Script .sql tạo bảng, dữ liệu mẫu, truy vấn khi đến phần SQL |
| bao-cao/ | Báo cáo chung, bản PDF nộp, slide nếu cần |

Ví dụ N2: docs/lich-chieu.docx, er/lich-chieu.drawio; sau này thêm sql/lich-chieu.sql. Chỉ tạo file có nội dung.

Mỗi người tự viết phần giải thích của mình. N4 tổng hợp vào bao-cao/BaoCao_Nhom.docx; Hải tổng hợp ER vào er/ER_Tong.drawio. Chỉ người tổng hợp sửa file chung để tránh xung đột.

Git merge không tự biên tập 5 file Word thành 1 bài hoặc nối 5 sơ đồ thành ER đúng nghiệp vụ.

## 3. Ai làm gì trên GitHub?

| Thao tác | Nghĩa | Ai làm? |
| --- | --- | --- |
| Clone | Tải dự án lần đầu về máy | Cả 5 người |
| Pull | Tải và tích hợp thay đổi của nhánh trên GitHub | Cả 5 người, trên máy mình |
| Push | Đưa commit của mình lên GitHub | Ai sửa bài thì người đó push |
| Pull Request (PR) | Đề nghị ghép nhánh của mình vào main | Người làm phần đó |
| Merge PR | Duyệt và ghép bài vào main | Hải |

Pull cập nhật mọi loại file được Git quản lý: SQL, Word, Draw.io, ảnh, PDF, README... Không cần pull riêng từng loại. Git không đồng bộ database đang chạy trong SQL Server: lấy script về xong vẫn phải mở và chạy script phù hợp.

## 4. Chuẩn bị một lần

Hải mời 4 thành viên tại Settings → Collaborators → Add people. Mỗi người chấp nhận lời mời. Việc mời thành viên chưa được thực hiện trong lần khởi tạo này.

Mỗi người cài Git. Mở terminal ở thư mục muốn chứa dự án và chạy:

~~~bash
git clone https://github.com/coolnguyen/QuanLy_RapChieuPhim.git
cd QuanLy_RapChieuPhim
git switch lich-chieu
~~~

Ví dụ trên dùng nhánh N2; thay lich-chieu bằng nhánh của mình. Clone một lần trên mỗi máy. Nếu đã clone, mở đúng thư mục dự án rồi chạy git fetch origin để cập nhật danh sách nhánh.

Nếu Git chưa có tên/email tác giả, đặt thông tin của chính mình:

~~~bash
git config user.name "Ten cua ban"
git config user.email "email-cua-ban"
~~~

## 5. Đầu mỗi buổi làm việc

Lưu file và chạy git status. Nếu còn sửa đổi chưa commit, commit phần đang làm trước khi chuyển nhánh/cập nhật. Khi trạng thái làm việc sạch, ví dụ N2 chạy:

~~~bash
git switch lich-chieu
git pull --ff-only
git fetch origin
git merge --no-edit origin/main
~~~

- pull cập nhật nhánh mình từ nhánh cùng tên trên GitHub.
- fetch lấy thông tin mới, bao gồm main.
- merge origin/main đưa bài chung đã duyệt vào nhánh đang làm; không sửa main trên GitHub.

Nếu có CONFLICT hoặc không thể fast-forward, dừng và nhờ Hải kiểm tra. Không tự dùng reset --hard hoặc push --force để thử sửa.

## 6. Gửi phần đã làm

Ví dụ N2 đã lưu hai file docs/lich-chieu.docx và er/lich-chieu.drawio:

~~~bash
git status
git add docs/lich-chieu.docx er/lich-chieu.drawio
git commit -m "docs: bo sung phan tich va ER lich chieu"
git push
~~~

Thay đường dẫn bằng file thực tế của mình; chỉ add file đã sửa. Nội dung commit mô tả việc vừa hoàn thành.

Trên GitHub:
1. Pull requests → New pull request.
2. Chọn base: main, compare: nhánh của mình.
3. Xem Files changed, mô tả việc đã làm và thẻ Trello liên quan.
4. Create pull request.
5. Hải xem bài; nếu cần sửa, tác giả sửa cùng nhánh, commit và push tiếp. PR tự cập nhật.

Hải dùng Create a merge commit → Confirm merge khi bài đạt. Giữ 5 nhánh công việc để dùng tiếp, không xóa sau mỗi PR. Với phần Hải tự làm, nhờ một thành viên kiểm tra trước khi Hải merge.

## 7. Sau khi ghép bài

Cả nhóm thực hiện bước 5 vào buổi làm việc tiếp theo để nhận bản chung mới. Hải không thể pull thay cho máy các thành viên.

Nếu Hải muốn xem bản chung trên máy:

~~~bash
git switch main
git pull --ff-only origin main
~~~

Khi sửa bài, Hải quay lại nhánh marketing-tong-hop và cập nhật theo bước 5.

## 8. Quy tắc ít lỗi

- Mỗi file có một người phụ trách; báo trước nếu cần sửa file của người khác.
- Thống nhất tên thực thể, thuộc tính và khóa chung trước khi vẽ ER hoặc viết SQL.
- Không đưa file database .mdf, .ndf, .ldf, .bak hay mật khẩu lên GitHub.
- SQL chạy theo thứ tự phụ thuộc khóa ngoại; merge thành công chưa có nghĩa mô hình/SQL đã đúng.
- Trello quản lý ai làm gì; GitHub quản lý phiên bản bài và việc ghép bài.
