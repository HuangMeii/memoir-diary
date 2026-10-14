# N1-S2 · Model checklist con (`NoteChecklistItem`)

**Epic:** N1 · **Ước lượng:** 2 pts · **Phụ thuộc:** N1-S1
**Nguồn thiết kế:** `ui-figma/taoghichu/code.html` (block checklist trong section 1,
dòng ~322–347); `ui-figma/ghichu/screen.png` (card checklist + "1/3 đã mua",
"3/3 mục tiêu")

## Mục tiêu

Lưu checklist tương tác của một ghi chú dưới dạng **bảng con** có thứ tự, để
`notes` không phình và tiến độ (`n/m`) tính được từ dữ liệu.

## Phạm vi

- **Tạo mới:** `memoir_server/memoir_server_server/lib/src/notes/note_checklist_item.spy.yaml`.
- **Phụ thuộc:** bảng `notes` phải tồn tại (N1-S1).
- **KHÔNG sửa:** `entry_image.spy.yaml` (chỉ tham khảo mẫu bảng con).

## Việc cần làm

- [ ] Tạo file model theo mẫu dưới (bảng con, cascade theo note).
- [ ] Đặt `sortOrder` để giữ thứ tự người dùng kéo–thả.
- [ ] Chạy `serverpod generate`; kiểm tra `generated/notes/note_checklist_item.dart`.
- [ ] Xác nhận quan hệ: xoá note → xoá hết item (cascade).

Nội dung `.spy.yaml`:

```yaml
### One checklist line inside a note (interactive to-do block).
class: NoteChecklistItem
table: note_checklist_items
fields:
  id: UuidValue?, defaultPersist=random_v7
  noteId: UuidValue, relation(parent=notes, onDelete=Cascade)
  text: String
  isDone: bool, default=false
  ### Thứ tự hiển thị; 0-based, tăng dần từ trên xuống.
  sortOrder: int, default=0
```

## Acceptance Criteria

1. *Given* bảng `notes` tồn tại, *when* chạy `serverpod generate`, *then* sinh ra
   `NoteChecklistItem` với `NoteChecklistItem.t` và repository `db` như các model khác.
2. *Given* một note có 3 item, *when* xoá note, *then* cả 3 item bị xoá theo
   (cascade ở DB, không cần code xoá tay).
3. *Then* `isDone` mặc định `false` và `sortOrder` mặc định `0`.
4. *Then* `dart analyze` sạch.

## Kiểm chứng

```powershell
cd memoir_server\memoir_server_server
serverpod generate
dart analyze
Select-String -Path 'lib\src\generated\notes\note_checklist_item.dart' -Pattern 'noteId|sortOrder'
```

## Rủi ro / ghi chú

- Mẫu bảng con theo đúng `journal/entry_image.spy.yaml` (`entryId: UuidValue,
  relation(parent=diary_entries, onDelete=Cascade)`).
- Tiến độ hiển thị trên card (`done/total`) **tính ở client**, không lưu cột riêng,
  để tránh dữ liệu lệch.
- Không đặt `unique` trên `(noteId, sortOrder)`: người dùng có thể có hai dòng cùng
  thứ tự khi kéo–thả, việc chuẩn hoá thứ tự là trách nhiệm của endpoint (N1-S5).
