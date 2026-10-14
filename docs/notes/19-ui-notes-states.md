# N3-S6 · States: loading / empty / error / thùng rác

**Epic:** N3 · **Ước lượng:** 2 pts · **Phụ thuộc:** N3-S5
**Nguồn thiết kế:** `ui-figma/ghichu/DESIGN.md` (mục *Interactive States*) +
nút "Xem thùng rác" trong `screen.png`

## Mục tiêu

Phủ đủ các trạng thái mà màn danh sách có thể rơi vào, để không bao giờ hiện màn
trắng hay lỗi thô.

## Phạm vi

- **Tạo mới:** `flutter_app/lib/src/ui/notes/notes_states.dart`.
- **Sửa:** `notes_screen.dart` (chọn nhánh state).
- **KHÔNG sửa:** các widget card/filter.

## Việc cần làm

- [ ] `NotesLoading` — skeleton/spinner căn giữa, giữ chỗ để tránh "nhảy layout".
- [ ] `NotesEmpty({required bool trashed, VoidCallback onCreate})`:
  - danh sách thường: tiêu đề "Chưa có ghi chú nào" + nút **"Tạo ghi chú đầu tiên"**.
  - thùng rác: "Thùng rác trống" + nút "Quay lại danh sách".
- [ ] `NotesError({required Object error, VoidCallback onRetry})` — icon `wifi_off`,
  thông báo thân thiện + nút "Tải lại" (`ref.invalidate(notesProvider)`).
- [ ] `NotesTrashHeader({required int count, VoidCallback onExit})` — dải nhắc đang ở
  thùng rác + nút "Thoát thùng rác"; card trong thùng rác hiện 2 hành động
  **Khôi phục** / **Xoá vĩnh viễn** (gọi `restore`/`purge`).
- [ ] Ghép nhánh trong `notes_screen.dart`: `AsyncValue.when(loading/error/data)`;
  nhánh `data` rỗng → `NotesEmpty`; `showTrash == true` → `trashedNotesProvider`.
- [ ] `flutter analyze`.

## Acceptance Criteria

1. *Given* `notesProvider` đang tải, *then* hiện `NotesLoading` (không hiện empty).
2. *Given* danh sách rỗng và không ở thùng rác, *then* hiện CTA "Tạo ghi chú đầu
   tiên" và bấm mở trình soạn thảo.
3. *Given* `notesProvider` lỗi (ví dụ backend tắt), *then* hiện `NotesError` kèm nút
   "Tải lại"; bấm nút thử lại request.
4. *Given* ở thùng rác có 2 note, *then* mỗi card có "Khôi phục" và "Xoá vĩnh viễn";
   khôi phục đưa note về danh sách thường, xoá vĩnh viễn gỡ hẳn.
5. *Given* thùng rác trống, *then* hiện "Thùng rác trống" + nút quay lại.
6. *Then* `flutter analyze` sạch; không nhánh nào render `null`/màn trắng.

## Kiểm chứng

```powershell
cd flutter_app
flutter analyze
flutter run -d chrome --web-port 8080
# Thử: tắt backend → xem NotesError; tài khoản mới → xem NotesEmpty
```

## Rủi ro / ghi chú

- Xoá vĩnh viễn **phải** có hộp thoại xác nhận (không thể hoàn tác) — dùng
  `showDialog` với nút "Xoá vĩnh viễn" màu `error`.
- `NotesLoading` nên dùng skeleton cùng chiều cao card để chuyển state không giật.
