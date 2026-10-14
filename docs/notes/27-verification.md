# N5-S3 · Kiểm chứng end-to-end

**Epic:** N5 · **Ước lượng:** 2 pts · **Phụ thuộc:** toàn bộ N1…N4

## Mục tiêu

Chốt lại tính năng bằng một lượt kiểm chứng: build sạch cả hai phía, test xanh, và
đối chiếu giao diện với ảnh thiết kế.

## Phạm vi

- **Không sửa code** (trừ khi phát hiện lỗi → quay lại task tương ứng).
- Chạy trên: backend `memoir_server/memoir_server_server`, app `flutter_app`.

## Việc cần làm

### 1. Backend
- [ ] `serverpod generate` — không lỗi, không diff ngoài dự kiến.
- [ ] `dart analyze` sạch.
- [ ] `dart format .` (không còn diff).
- [ ] `dart test` xanh (gồm `notes_endpoint_test.dart`).
- [ ] `serverpod start` áp migration **không** mất dữ liệu (đếm `notes` trước/sau).

### 2. Flutter
- [ ] `flutter pub get` (client generated mới).
- [ ] `flutter analyze` sạch.
- [ ] `flutter test` xanh.
- [ ] `flutter run -d chrome --web-port 8080`.

### 3. Đối chiếu thiết kế
- [ ] Màn danh sách vs `ui-figma/ghichu/screen.png`: breadcrumb, tiêu đề + chip đếm,
  ô tìm kiếm, hàng chip, "ĐÃ GHIM", "TẤT CẢ GHI CHÚ", callout, footer.
- [ ] Trình soạn thảo vs `ui-figma/taoghichu/screen.png`: top bar (autosave, màu,
  ghim, thẻ, liên kết, Lưu & Đóng), thanh format, tiêu đề serif, dòng meta, checklist,
  panel liên kết, footer.

### 4. Kịch bản smoke (thủ công, ghi lại kết quả)
- [ ] Tạo ghi chú mới → gõ nội dung → chờ autosave → đóng → thấy trong danh sách.
- [ ] Ghim → note nhảy lên "ĐÃ GHIM".
- [ ] Thêm checklist 3 mục, tick 1 → mở lại còn nguyên.
- [ ] Thêm thẻ `#CôngViệc` → chip lọc `#CôngViệc` lọc đúng.
- [ ] Liên kết với một trang nhật ký → "Mở trang nhật ký" đi đúng ngày.
- [ ] Xoá ghi chú → vào thùng rác → Khôi phục → về danh sách → Xoá vĩnh viễn → mất.
- [ ] Tài khoản B không thấy ghi chú của A.

## Acceptance Criteria

1. *Then* tất cả lệnh ở mục 1–2 kết thúc mã 0.
2. *Given* DB có N note trước khi áp migration, *then* sau migration vẫn ≥ N hàng và
   cột mới nhận default (không mất dữ liệu).
3. *Given* so với 2 ảnh `screen.png`, *then* không còn khác biệt cấu trúc (bố cục,
   thứ tự khối, nhãn chữ); khác biệt nhỏ về màu/font do map tài nguyên được ghi chú lại.
4. *Given* kịch bản smoke, *then* mọi mục đều "đạt" hoặc có ticket lỗi kèm mô tả.
5. *Then* 2 tài khoản cùng tồn tại và **không** thấy dữ liệu của nhau.

## Kiểm chứng

```powershell
# Backend
cd memoir_server\memoir_server_server
serverpod generate ; dart analyze ; dart format . ; dart test
# (bạn) serverpod start   -> áp migration

# Flutter
cd ..\..\flutter_app
flutter pub get ; flutter analyze ; flutter test
flutter run -d chrome --web-port 8080
```

Đếm dữ liệu trước/sau migration (nếu có kết nối DB):

```sql
SELECT count(*) FROM "notes";
SELECT count(*) FROM "note_checklist_items";
SELECT count(*) FROM "note_entry_links";
```

## Rủi ro / ghi chú

- Đây là **cổng chốt** trước khi merge; nếu mục 3 lệch nhiều, quay lại N3/N4 thay vì
  chấp nhận sai lệch.
- Nếu `flutter test` đỏ vì test cũ (`widget_test.dart`) phụ thuộc `NotesScreen` cũ,
  sửa test đó trong **task này** và ghi chú.
- Ghi lại ảnh chụp màn hình thực tế (web) đính kèm PR để so với `screen.png`.
