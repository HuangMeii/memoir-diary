# N4-S1 · Top bar trình soạn thảo

**Epic:** N4 · **Ước lượng:** 3 pts · **Phụ thuộc:** N2-S5
**Nguồn thiết kế:** `ui-figma/taoghichu/code.html` dòng ~185–235 (modal, top editor
bar: quay lại, breadcrumb, autosave, chấm màu, ghim, "+ Thêm thẻ", "Liên kết với
nhật ký", "Lưu & Đóng")

## Mục tiêu

Tạo màn `NoteEditorScreen` dạng **modal toàn màn hình** (khớp thiết kế) và dựng top
bar với các điều khiển: quay lại, trạng thái tự động lưu, chọn màu, ghim, thẻ, liên
kết, lưu.

## Phạm vi

- **Tạo mới:** `flutter_app/lib/src/ui/screens/note_editor_screen.dart` +
  `flutter_app/lib/src/ui/notes/editor_top_bar.dart`.
- **KHÔNG sửa:** `notes_screen.dart` (chỉ được gọi tới từ đó).

## Việc cần làm

- [ ] `NoteEditorScreen({Note? note})` — null = tạo mới; có = sửa. Nhận `NoteDetail`
  qua `noteDetailProvider(note.id)` khi sửa.
- [ ] Bọc trong `Dialog.fullscreen`/`Scaffold` bo góc `MemoirRadius.card`, tối đa
  ~1200px rộng, nền `surfaceCard`, viền + shadow như `code.html`.
- [ ] `EditorTopBar`:
  - "Quay lại danh sách" (icon mũi tên) → xác nhận nếu có thay đổi chưa lưu.
  - Breadcrumb "Ghi chú / Đang soạn thảo" (chữ primary cho vế sau).
  - Chip **"Đã lưu tự động lúc HH:mm"** — nối `core/autosave.dart`; đổi sang
    "Đang lưu…" khi đang gửi.
  - **Chấm chọn màu**: ≥ 4 màu (ô liu/vàng/hồng/xám) map sang `color`; chấm đang chọn
    có viền.
  - **Ghim**: icon `push_pin`, đổi màu khi `isPinned`.
  - **"+ Thêm thẻ"**: mở hộp thoại nhập tag → thêm vào `tags`.
  - **"Liên kết với nhật ký"**: mở panel liên kết (N4-S4).
  - **"Lưu & Đóng"** (`FilledButton`): lưu rồi `Navigator.pop`.
- [ ] `flutter analyze`.

## Acceptance Criteria

1. *Given* bấm "+ Ghi chú mới", *then* mở editor trống, tiêu đề chưa có nội dung,
   chip tự động lưu hiện "Chưa lưu" cho tới lần lưu đầu.
2. *Given* sửa nội dung và chờ ~1–2s (theo `autosave.dart`), *then* chip đổi thành
   "Đã lưu tự động lúc HH:mm" và dữ liệu đã gửi lên server.
3. *Given* chọn màu, *then* chấm đó được đánh dấu và `color` được lưu.
4. *Given* bấm ghim, *then* `isPinned` đổi và icon phản ánh trạng thái.
5. *Given* bấm "Quay lại" khi có thay đổi chưa lưu, *then* có hộp thoại xác nhận
   (Lưu & thoát / Thoát không lưu / Ở lại).
6. *Given* bấm "Lưu & Đóng", *then* lưu xong và quay về danh sách, note mới xuất hiện.
7. *Then* `flutter analyze` sạch.

## Kiểm chứng

```powershell
cd flutter_app
flutter analyze
flutter run -d chrome --web-port 8080   # mở editor, so với ui-figma/taoghichu/screen.png
```

## Rủi ro / ghi chú

- Tái dùng `core/autosave.dart` (đã dùng cho `entry_editor.dart`) — đọc file đó
  trước để dùng đúng API, **không** viết lại cơ chế debounce.
- Editor là **modal**: đảm bảo không vẽ lại `AppHeader` phía sau (thiết kế phủ mờ
  nền), tránh hai thanh header chồng nhau.
- Màu ghi chú lưu dạng chuỗi hex trong `color`; ánh xạ "tên màu" tiếng Việt chỉ để
  hiển thị trong dòng meta (N4-S3).
