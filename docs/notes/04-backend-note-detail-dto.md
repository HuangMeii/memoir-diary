# N1-S4 · DTO `NoteDetail`

**Epic:** N1 · **Ước lượng:** 1 pt · **Phụ thuộc:** N1-S2, N1-S3
**Nguồn thiết kế:** `ui-figma/taoghichu/code.html` (một màn hình cần đủ note +
checklist + danh sách entry liên kết trong **một** lần gọi)

## Mục tiêu

Gói `Note` + checklist + entry liên kết vào một class trả về để trình soạn thảo mở
bằng **một** round-trip thay vì ba.

## Phạm vi

- **Tạo mới:** `memoir_server/memoir_server_server/lib/src/notes/note_detail.spy.yaml`
  (class DTO, **không** có `table`).
- **KHÔNG sửa:** `note.spy.yaml`, các model con.

## Việc cần làm

- [ ] Tạo class DTO theo mẫu dưới (không `table` ⇒ không tạo bảng).
- [ ] Quyết định dạng entry liên kết: **trả kèm** `DiaryEntry` (đủ cho panel) —
  nếu payload lớn, đổi sang `List<NoteEntryLink>` + client gọi `entries.get`.
- [ ] Chạy `serverpod generate`; kiểm tra `generated/notes/note_detail.dart`.

Nội dung `.spy.yaml` (chọn trả kèm entry — đơn giản nhất cho panel):

```yaml
### Note + its checklist and linked diary entries, for the note editor.
class: NoteDetail
fields:
  note: Note
  checklist: List<NoteChecklistItem>
  ### Các trang nhật ký đang liên kết (mới nhất trước).
  entries: List<DiaryEntry>
```

## Acceptance Criteria

1. *Given* `Note`, `NoteChecklistItem`, `DiaryEntry` tồn tại, *when* chạy
   `serverpod generate`, *then* sinh `NoteDetail` **không** có `NoteDetail.db`/`.t`
   (DTO, không phải bảng).
2. *Then* client nhận được `NoteDetail` với `note`, `checklist`, `entries` khác null.
3. *Then* `dart analyze` sạch.

## Kiểm chứng

```powershell
cd memoir_server\memoir_server_server
serverpod generate
dart analyze
Select-String -Path 'lib\src\generated\notes\note_detail.dart' -Pattern 'checklist|entries'
```

## Rủi ro / ghi chú

- Vì `NoteDetail` trả cả `DiaryEntry`, nếu sau này entry có ảnh/nội dung lớn thì
  payload tăng — theo dõi ở N5-S3; khi đó chuyển sang trả `List<NoteEntryLink>` +
  `entries.get(id)` (N1-S6).
- Đặt file trong `lib/src/notes/` để generator gom đúng module `notes`.
