# H5-S3 · Kiểm chứng end-to-end

**Epic:** H5 · **Ước lượng:** 2 pts · **Phụ thuộc:** toàn bộ task H0…H5

## Mục tiêu

Chạy thật từ server tới giao diện, đối chiếu **từng màn** với bản export, và ghi lại bằng
chứng vào chính file này. Đây là bước chốt DoD của bộ task (`00-conventions.md` §7).

## Phạm vi

- **Sửa:** file này (điền bảng bằng chứng bên dưới).
- **KHÔNG sửa:** code (nếu phát hiện lỗi, mở task sửa mới hoặc quay lại task tương ứng).

## Việc cần làm

- [ ] **Server**: `serverpod generate` ⇒ `serverpod create-migration` ⇒ rà `migration.sql`
      ⇒ `serverpod start` (áp migration) ⇒ ghi lại số hàng `health_logs` **trước/sau**.
- [ ] `dart analyze ; dart format . ; dart test` trong `memoir_server_server` ⇒ xanh.
- [ ] **App**: `flutter pub get ; flutter analyze ; flutter test` ⇒ xanh.
- [ ] `dart run tool/gen_tokens.dart` ở gốc repo ⇒ `tokens.dart` không đổi thêm (đã commit
      ở H0-S1), `flutter analyze` vẫn sạch.
- [ ] **Chạy web**: `flutter run -d chrome --web-port 8080` (khớp CORS của backend), đăng nhập
      tài khoản thật, rồi đi hết luồng:

| # | Bước | Kỳ vọng |
|---|---|---|
| 1 | Mở thẻ “Sức khỏe” ở Trang chủ | Dashboard dựng đúng chrome, không còn `AppBar('Sức khoẻ')` |
| 2 | Ngày hôm nay: nhập 50 phút tập + cường độ “Tập vừa”, lưu | Thẻ hero tập đổi `50/60 · 83%` ngay |
| 3 | Mở `+ Ghi nhận nhanh` ⇒ tab Nước: bấm `+250` hai lần rồi lưu | `500 ml` vào ngày đó; tóm tắt `n lần · HH:mm` đổi |
| 4 | Sheet ⇒ tab Ngủ: 7h30, 23:00 → 06:30, ngủ sâu 105, “Ngủ ngon & sâu” | Thẻ ngủ `7h 30m / 8h 00m`, `Sâu 1h 45m · 23%` |
| 5 | Sheet ⇒ tab Tập: sửa số phút và lưu | Giá trị cũ của ngày được cập nhật (không tạo hàng mới) |
| 6 | Form ⇒ nút thông số ⇒ drawer BMI: đổi cân nặng bằng stepper, lưu | BMI tính lại; log ngày nhận cân nặng; biến động cân nặng cập nhật |
| 7 | Timeline ⇒ `+ Thêm mốc` 18:00 “Giãn cơ & Yoga buổi chiều” | Mốc xuất hiện đúng thứ tự giờ; xoá được |
| 8 | Đổi ngày sang hôm qua rồi quay lại | Mọi khối theo ngày, không lẫn dữ liệu |
| 9 | Chọn metric `Nước` + kỳ `3 tháng` | 4 ô số + biểu đồ đổi theo metric/kỳ; ngày trống vẫn có cột |
| 10 | Đổi ngày sang ngày tương lai (trống) | Trạng thái trống, không `NaN`, không số mẫu |
| 11 | Tắt mạng rồi bấm “Lưu chỉ số” | Snackbar lỗi, giá trị nhập còn nguyên, form không đóng |

- [ ] **Đối chiếu thiết kế** (mở file cạnh màn hình):

| Màn | Nguồn đối chiếu | Kết quả |
|---|---|---|
| Dashboard | `ui-figma/suckhoe/memoir_s_c_kho_th_ch_t_t_i_gi_n/screen.png` | ☐ đạt ☐ lệch (ghi rõ) |
| Dashboard + drawer BMI | `ui-figma/suckhoe/memoir_c_p_nh_t_th_ng_s_c_nh_n_bmi/screen.png` | ☐ đạt ☐ lệch |
| Modal tập | `ui-figma/suckhoe/memoir_ghi_nh_n_nhanh_s_c_kho/screen.png` | ☐ đạt ☐ lệch |
| Modal nước | `ui-figma/suckhoe/memoir_ghi_nh_n_u_ng_n_c_trung_t_m/code.html` (**ảnh chụp hỏng**) | ☐ đạt ☐ lệch |
| Modal ngủ | `ui-figma/suckhoe/memoir_ghi_nh_n_gi_ng/code.html` (**ảnh chụp hỏng**) | ☐ đạt ☐ lệch |

- [ ] **Không hồi quy**:
  - Trang chủ: thẻ “Nhịp viết”/tổng hợp tháng vẫn có số liệu health sau khi lưu chỉ số;
  - `flutter test` không có test nào đỏ;
  - `GET /health-logs` vẫn trả mảng như cũ cho màn cũ.
- [ ] **Ghi bằng chứng** vào bảng dưới (điền khi chạy thật):

| Hạng mục | Lệnh / cách kiểm | Kết quả |
|---|---|---|
| Server analyze + test | `dart analyze ; dart test` | |
| Migration | số hàng `health_logs` trước ⇒ sau | |
| App analyze + test | `flutter analyze ; flutter test` | |
| Web 8080 (11 bước) | | |
| Đối chiếu 5 màn | | |

## Acceptance Criteria

1. *Given* migration đã áp, *then* số hàng `health_logs` **không đổi** và schema khớp
   `definition.sql`.
2. *Given* 11 bước ở bảng trên, *then* mọi bước đạt kỳ vọng.
3. *Given* 5 màn, *then* mỗi màn được đánh dấu đạt/lệch kèm ghi chú (với hai modal hỏng ảnh,
   đối chiếu `code.html`).
4. *Given* thao tác lưu chỉ số, *then* số liệu health trên trang chủ cập nhật (không hồi quy
   `monthSummaryProvider`).
5. *Then* file này có bảng bằng chứng đã điền, không còn ô trống ở mục “Hạng mục”.

## Kiểm chứng

```powershell
# Server
cd memoir_server\memoir_server_server
serverpod generate ; dart analyze ; dart format . ; dart test

# App
cd ..\..\flutter_app
flutter pub get ; flutter analyze ; flutter test
flutter run -d chrome --web-port 8080

# Token
cd ..
dart run tool/gen_tokens.dart
```

## Rủi ro / ghi chú

- Chạy `serverpod start` sẽ **áp migration lên DB thật**: làm theo checklist ở H1-S6 và
  backup/git stash trước nếu chưa chắc.
- Nếu web không gọi được API: kiểm `CORS_ORIGINS` phải khớp `--web-port 8080` (đúng cách
  các phase trước đã làm).
- Hai modal ngủ/nước **không có ảnh chụp**: “đạt” ở đây nghĩa là khớp cấu trúc + chuỗi trong
  `code.html`, không phải khớp ảnh pixel.
