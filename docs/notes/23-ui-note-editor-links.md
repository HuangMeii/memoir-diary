# N4-S4 · Panel "LIÊN KẾT NHẬT KÝ LIÊN QUAN"

**Epic:** N4 · **Ước lượng:** 2 pts · **Phụ thuộc:** N4-S3
**Nguồn thiết kế:** `ui-figma/taoghichu/code.html` dòng ~379–427 (tiêu đề panel,
nút "+ Liên kết thêm trang nhật ký khác", card entry liên kết với nút "Mở trang nhật
ký" / "Gỡ liên kết")

## Mục tiêu

Cho người dùng gắn/gỡ các trang nhật ký liên quan vào ghi chú và mở nhanh trang đó.

## Phạm vi

- **Tạo mới:** `flutter_app/lib/src/ui/notes/editor_links_panel.dart`.
- **Sửa:** `note_editor_screen.dart` (chèn panel dưới thân).
- **Phụ thuộc dữ liệu:** `NoteDetail.entries` (N1-S4) + `entries.get(id)` (N1-S6).

## Việc cần làm

- [ ] `EditorLinksPanel({required List<DiaryEntry> entries, required Note note,
  required ValueChanged<List<String>> onChanged})`.
- [ ] Tiêu đề hàng: icon `auto_stories` + nhãn "LIÊN KẾT NHẬT KÝ LIÊN QUAN" (chữ
  hoa, `isSecondary`) + chú thích "(Đồng bộ với Memoir Diary)".
- [ ] Nút phải: "+ Liên kết thêm trang nhật ký khác" → mở hộp thoại chọn entry:
  - hiển thị danh sách entry gần đây (dùng `monthEntriesProvider`/`entries` theo
    tháng hiện tại nếu cần) hoặc nhập ngày để tra `entryByDateProvider`;
  - chọn xong → thêm `id` vào danh sách `entryIds`.
- [ ] Card mỗi entry liên kết:
  - icon `book` + "Trang nhật ký ngày dd.mm.yyyy".
  - chip mood (icon cảm xúc + nhãn) — dùng `moodIcon`/`moodsProvider`.
  - tiêu đề/trích đoạn: dòng đầu `diaryText` (hoặc `(Trang trống)`).
  - nút "Mở trang nhật ký" (icon `arrow_outward`) → điều hướng tới `EntryEditorScreen`
    với ngày tương ứng; nút "Gỡ liên kết" (icon `link_off`) → xoá khỏi danh sách.
- [ ] `onChanged` trả danh sách `entryId` mới → editor lưu khi autosave.
- [ ] Rỗng → hiện "Chưa liên kết trang nhật ký nào" + nút thêm.
- [ ] `flutter analyze`.

## Acceptance Criteria

1. *Given* note có 1 entry liên kết, *then* panel hiện 1 card với ngày, mood và
   trích đoạn đúng của entry đó.
2. *Given* bấm "+ Liên kết thêm…" và chọn một entry, *then* card mới xuất hiện và
   `entryIds` được cập nhật.
3. *Given* bấm "Gỡ liên kết", *then* card biến mất và `entryIds` bỏ id đó.
4. *Given* lưu (`update`), *then* `NoteDetail.entries` sau khi mở lại khớp danh sách
   hiển thị.
5. *Given* bấm "Mở trang nhật ký", *then* mở `EntryEditorScreen` đúng ngày của entry.
6. *Given* không có liên kết, *then* hiện trạng thái rỗng + nút thêm.
7. *Then* `flutter analyze` sạch.

## Kiểm chứng

```powershell
cd flutter_app
flutter analyze
flutter run -d chrome --web-port 8080   # so panel với ui-figma/taoghichu/screen.png
```

## Rủi ro / ghi chú

- Nếu `NoteDetail` **không** trả kèm `entries` (đổi ở N1-S4), panel phải tự gọi
  `GET /entries/{id}` cho từng link (N2-S1) — thêm trạng thái loading cho panel.
- Không cho liên kết trùng: lọc entry đã có khỏi hộp thoại chọn.
- Điều hướng sang nhật ký: dùng `EntryEditorScreen(initialDate: …)` nếu có; đọc
  `entry_editor.dart` để biết tham số đúng, đừng đoán.
