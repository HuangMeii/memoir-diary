# N4-S5 · Footer trình soạn thảo

**Epic:** N4 · **Ước lượng:** 2 pts · **Phụ thuộc:** N4-S4
**Nguồn thiết kế:** `ui-figma/taoghichu/code.html` dòng ~430–451 (footer: "Xóa ghi
chú", "Lưu bản sao", ghi chú bảo mật, "Xong & Đóng")

## Mục tiêu

Hoàn thiện các hành động cuối của trình soạn thảo: xoá (vào thùng rác), nhân bản,
lưu & đóng — kèm câu bảo mật như thiết kế.

## Phạm vi

- **Tạo mới:** `flutter_app/lib/src/ui/notes/editor_footer.dart`.
- **Sửa:** `note_editor_screen.dart` (ghép footer + xử lý hành động).
- **Phụ thuộc:** `NotesRepository` (N2-S4) cho `trash`/`create`/`update`.

## Việc cần làm

- [ ] `EditorFooter({required bool isNew, required bool dirty, VoidCallback onDelete,
  VoidCallback onDuplicate, VoidCallback onDone})`.
- [ ] Trái: nút "Xóa ghi chú" (icon `delete`, chữ `error`) — ẩn khi `isNew == true`;
  `Divider` dọc; nút "Lưu bản sao" (icon `content_copy`).
- [ ] Phải: câu "Tất cả thay đổi đều được mã hóa trên thiết bị của bạn" (ẩn trên
  mobile) + `FilledButton` "Xong & Đóng".
- [ ] Hành vi:
  - `onDelete` → hộp thoại xác nhận → `trash(id)` (soft-delete) → pop; **không** xoá
    vĩnh viễn (việc đó ở thùng rác, N3-S6).
  - `onDuplicate` → `create(...)` với `title + ' (bản sao)'`, cùng `content/tags/
    checklist/entryIds` → mở bản sao.
  - `onDone` → lưu (nếu `dirty`) rồi pop; gọi `refreshNotes(ref)`.
- [ ] Footer dính đáy modal (không cuộn theo thân): `shrink-0` tương ứng
  `SizedBox`/`Container` ngoài `Expanded` scroll.
- [ ] `flutter analyze`.

## Acceptance Criteria

1. *Given* đang tạo mới, *then* nút "Xóa ghi chú" **không** hiện.
2. *Given* đang sửa note đã lưu, *when* bấm "Xóa ghi chú" và xác nhận, *then* note
   vào thùng rác và editor đóng; note **không** bị xoá vĩnh viễn.
3. *Given* bấm "Lưu bản sao", *then* tạo note mới có tiêu đề kèm "(bản sao)" và giữ
   nội dung/tag/checklist/liên kết; editor mở bản sao.
4. *Given* có thay đổi chưa lưu và bấm "Xong & Đóng", *then* dữ liệu được lưu trước
   khi đóng và danh sách phản ánh ngay.
5. *Given* thân note cuộn dài, *then* footer vẫn nằm đáy (không trôi mất).
6. *Then* `flutter analyze` sạch.

## Kiểm chứng

```powershell
cd flutter_app
flutter analyze
flutter run -d chrome --web-port 8080   # so footer với ui-figma/taoghichu/screen.png
```

## Rủi ro / ghi chú

- "Lưu bản sao" là **tạo mới** (id mới), không phải version; đặt tiêu đề rõ ràng để
  người dùng không nhầm.
- Câu bảo mật trong thiết kế là **văn bản thiết kế**; app chưa mã hoá phía thiết bị —
  nếu muốn chính xác về mặt tuyên bố, giữ nguyên theo Figma và ghi chú trong PR, hoặc
  đổi thành "Ghi chú của bạn chỉ thuộc về bạn." (chọn một, đừng tự ý đổi text Figma mà
  không ghi chú).
- `dirty` do editor truyền xuống (so sánh bản nháp với bản đã lưu) để quyết định có
  lưu khi đóng.
