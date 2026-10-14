# N1-S3 · Model liên kết nhật ký (`NoteEntryLink`)

**Epic:** N1 · **Ước lượng:** 2 pts · **Phụ thuộc:** N1-S1
**Nguồn thiết kế:** `ui-figma/taoghichu/code.html` (panel "LIÊN KẾT NHẬT KÝ LIÊN
QUAN" + nút "+ Liên kết thêm trang nhật ký khác", dòng ~379–427);
`ui-figma/ghichu/screen.png` (chip "Nhật ký 12/10" trên card)

## Mục tiêu

Cho phép một ghi chú liên kết **nhiều** trang nhật ký (`diary_entries`) và một
trang nhật ký có thể được nhiều ghi chú tham chiếu — quan hệ nhiều–nhiều qua bảng nối.

## Phạm vi

- **Tạo mới:** `memoir_server/memoir_server_server/lib/src/notes/note_entry_link.spy.yaml`.
- **Phụ thuộc:** bảng `notes` (N1-S1) và `diary_entries` (đã có).
- **KHÔNG sửa:** `journal/diary_entry.spy.yaml` (không thêm cột vào bảng nhật ký).

## Việc cần làm

- [ ] Tạo file model theo mẫu dưới.
- [ ] Đặt `unique` trên `(noteId, entryId)` để chặn liên kết trùng.
- [ ] Chạy `serverpod generate`; kiểm tra `generated/notes/note_entry_link.dart`.
- [ ] Xác nhận quan hệ: xoá note → xoá link; xoá entry → xoá link.

Nội dung `.spy.yaml`:

```yaml
### Many-to-many link between a note and the diary entries it references.
class: NoteEntryLink
table: note_entry_links
fields:
  id: UuidValue?, defaultPersist=random_v7
  noteId: UuidValue, relation(parent=notes, onDelete=Cascade)
  entryId: UuidValue, relation(parent=diary_entries, onDelete=Cascade)
  createdAt: DateTime, default=now
```

> Nếu Serverpod 4.0.4 không nhận `unique` tổ hợp hai cột trong `.spy.yaml`, thay
> bằng index unique thủ công trong `migration.sql` (task N1-S7) và ghi chú lại.

## Acceptance Criteria

1. *Given* `notes` và `diary_entries` tồn tại, *when* chạy `serverpod generate`,
   *then* sinh ra `NoteEntryLink` với hai quan hệ cascade.
2. *Given* một note liên kết entry A hai lần, *then* chỉ một hàng tồn tại
   (ràng buộc unique / chặn ở endpoint).
3. *Given* xoá một `diary_entry`, *then* mọi link tới nó bị xoá.
4. *Then* `dart analyze` sạch.

## Kiểm chứng

```powershell
cd memoir_server\memoir_server_server
serverpod generate
dart analyze
Select-String -Path 'lib\src\generated\notes\note_entry_link.dart' -Pattern 'entryId|noteId'
```

## Rủi ro / ghi chú

- Panel liên kết cần hiển thị **ngày + mood + tiêu đề/trích đoạn** của entry →
  cần `entries.get(id)` (task N1-S6) hoặc trả kèm trong `NoteDetail` (N1-S4).
- Chọn bảng nối (phương án A) thay vì một cột `entryId` vì thiết kế có nút
  "**Liên kết thêm** trang nhật ký khác" (số nhiều).
