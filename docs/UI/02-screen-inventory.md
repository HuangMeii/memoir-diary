# 02 — Screen Inventory

Mỗi mã dưới đây tương ứng với một frame hoặc một nhóm frame trong Figma.

## A. Authentication

| ID | Màn hình | Chức năng cần thiết | Trạng thái cần vẽ |
|---|---|---|---|
| AUTH-01 | Đăng nhập | Username, mật khẩu, hiện/ẩn mật khẩu, submit | Default, loading, sai thông tin, mất mạng |
| AUTH-02 | Đăng ký | Email, username, mật khẩu, validation, chuyển sang đăng nhập | Default, validation, loading, lỗi trùng tài khoản |
| AUTH-03 | Session redirect | Splash ngắn khi khôi phục phiên | Loading, session hết hạn |

## B. Home và nhật ký

| ID | Màn hình | Chức năng cần thiết | Trạng thái cần vẽ |
|---|---|---|---|
| HOME-01 | Hôm nay | Lời chào, ngày hiện tại, mood/weather quick pick, quote pair, shortcut, CTA | Có dữ liệu, ngày trống, loading, lỗi |
| HOME-02 | Quote card | Xem 1–2 câu, đổi câu, viết lời nhắn, phản tư | Chưa có lời nhắn, đã lưu, đang lưu |
| JOURNAL-01 | Lưới tháng | Chuyển tháng, grid mood, grid weather, legend, summary | Có/không có entry, loading, tháng rỗng |
| JOURNAL-02 | Editor nhật ký | Ngày, thời tiết, cảm xúc, nội dung, ảnh, các câu phản tư, lưu | Tạo mới, đã có dữ liệu, đang lưu, lỗi |
| JOURNAL-03 | Gallery ảnh | Preview, upload, caption, xóa ảnh | Empty, uploading, loaded, upload lỗi |

Các trường của `JOURNAL-02`:

- Nội dung nhật ký.
- Góc nhìn khác.
- Nhắn nhủ tương lai / câu hỏi.
- Tự chăm sóc hôm nay.
- Hi vọng ngày mai.
- Lòng biết ơn.
- Giấc mơ.
- Phản tư về cặp câu hôm nay.

## C. Kho lưu giữ

| ID | Màn hình | Chức năng cần thiết | Trạng thái cần vẽ |
|---|---|---|---|
| LIB-01 | Ghi chú nhanh | Thêm nhanh, danh sách, xóa, ghim (khi backend hỗ trợ) | Empty, list, delete confirm |
| LIB-02 | Lịch sử câu nói | Đổi tháng, danh sách quote pair, ngày hôm nay | Empty month, list, quote bị xóa |
| LIB-03 | Lời nhắn cho bản thân | Danh sách câu tự viết, thêm/sửa/xóa | Empty, edit, delete confirm |
| LIB-04 | Kho câu quản lý | Tìm kiếm, lọc, thêm/sửa/xóa quote | Admin-only, empty, pagination, error |

## D. Kế hoạch và sức khỏe

| ID | Màn hình | Chức năng cần thiết | Trạng thái cần vẽ |
|---|---|---|---|
| PLAN-01 | Kế hoạch | Tab Mục tiêu / Sự kiện / Lịch biểu | Loading, list, empty, add inline |
| PLAN-02 | Thêm/sửa mục tiêu | Tên, tuần, hạn, hoàn thành, xóa | Create, edit, validation |
| PLAN-03 | Thêm/sửa sự kiện | Tên, thời gian, địa điểm, xóa | Create, edit, conflict |
| PLAN-04 | Thêm/sửa lịch biểu | Tên, giờ, lặp (nếu có), xóa | Create, edit, recurring |
| HEALTH-01 | Sức khỏe | Chọn ngày, bước, tập, nước, ngủ, cân nặng, ghi chú | Empty, prefilled, saving, invalid value |
| HEALTH-02 | Xu hướng sức khỏe | Biểu đồ 30 ngày, summary cards | Có dữ liệu, không có dữ liệu, lỗi |

## E. Tài khoản

| ID | Màn hình | Chức năng cần thiết | Trạng thái cần vẽ |
|---|---|---|---|
| ACCOUNT-01 | Hồ sơ | Username, email, ngày tham gia | Loading, loaded, error |
| ACCOUNT-02 | Cài đặt | Theme, ngôn ngữ, thông báo, privacy | Default, changed, saved |
| ACCOUNT-03 | Xác nhận đăng xuất | Xác nhận trước khi xóa session | Dialog open, cancel, confirm |

## F. Roadmap

| ID | Màn hình | Ghi chú |
|---|---|---|
| GARDEN-01 | Focus timer | Chưa triển khai |
| GARDEN-02 | Garden hub / cây | Chưa triển khai |
| GARDEN-03 | Shop / inventory | Chưa triển khai |
| GARDEN-04 | Leaderboard / challenges | Chưa triển khai |
| CAL-01 | Calendar ngày / tuần / tháng | Chưa triển khai |
| CAL-02 | Tạo sự kiện lặp và nhắc nhở | Chưa triển khai |
| WEATHER-01 | Dự báo thời tiết | Chưa triển khai |
| ADMIN-01 | Admin dashboard | Backend có API, Flutter UI chưa có |
| ADMIN-02 | Quản lý users | Backend có API, Flutter UI chưa có |
