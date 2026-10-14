# N2-S2 · Map ghi (POST/PUT/DELETE/restore/purge)

**Epic:** N2 · **Ước lượng:** 3 pts · **Phụ thuộc:** N2-S1
**File:** `flutter_app/lib/src/data/datasources/serverpod_data_source.dart`

## Mục tiêu

Nối các hành vi ghi của thiết kế: tạo/sửa đầy đủ field, ghim, lưu trữ, chuyển vào
thùng rác, khôi phục, xoá vĩnh viễn. **`PUT /notes/{id}` hiện đang thiếu** nên
không sửa/ghim được ghi chú.

## Phạm vi

- **Sửa:** các hàm `post(...)`, `put(...)`, `delete(...)`.
- **KHÔNG sửa:** `uploadImage`, các nhánh domain khác.

## Việc cần làm

- [ ] `post('/notes')`: truyền thêm `title`, `tags`, `is_archived`, `checklist`,
  `entry_ids` xuống `notes.create(...)`.
- [ ] Thêm nhánh `post` cho `/notes/{id}/restore` → `notes.restore(id)`.
- [ ] Thêm nhánh `put` cho `/notes/...` → `notes.update(id, title, content, color,
  tags, isPinned, isArchived, isTrashed, checklist, entryIds)` → `_noteMap`.
- [ ] Thêm nhánh `put` cho `/notes/{id}/archive` (body `{is_archived}`) →
  `notes.archive(id, isArchived)`.
- [ ] `delete('/notes/{id}')` → giữ `notes.delete(id)` (nay là soft-delete).
- [ ] Thêm nhánh `delete` cho `/notes/{id}/purge` → `notes.purge(id)`.
- [ ] Helper `_uuidList(dynamic)` → `List<sp.UuidValue>?` để map `entry_ids`.
- [ ] `flutter analyze`.

## Acceptance Criteria

1. *Given* UI sửa nội dung một note, *when* `PUT /notes/{id}` được gọi, *then*
   server nhận đủ `content/title/color/tags/isPinned/isArchived/isTrashed` và map
   trả `_noteMap` (không còn `ApiException: unsupported PUT`).
2. *Given* `PUT /notes/{id}` với `entry_ids: []`, *then* liên kết bị gỡ hết.
3. *Given* `POST /notes/{id}/restore`, *then* note ra khỏi thùng rác.
4. *Given* `DELETE /notes/{id}`, *then* note vào thùng rác (không xoá hẳn);
   `DELETE /notes/{id}/purge` mới xoá hẳn.
5. *Then* `flutter analyze` sạch.

## Kiểm chứng

```powershell
cd flutter_app
flutter analyze
Select-String -Path 'lib\src\data\datasources\serverpod_data_source.dart' -Pattern "startsWith\('/notes/'\)|/purge|/restore"
```

## Rủi ro / ghi chú

- `put` hiện dựa vào `body[...]` từng key; truyền `null` nghĩa là **xoá** giá trị
  (xem comment trong `serverpod_data_source.dart`). Với `is_archived`/`is_trashed`
  là boolean, đừng để lẫn `null` khi không định đổi — UI nên luôn gửi giá trị hiện tại.
- Thứ tự nhánh trong `put`: `/entries/` đứng trước; thêm `/notes/` **sau** các nhánh
  `/self-messages`/`/reflections` hoặc bất kỳ đâu miễn không đè nhau.
- `purge`/`restore` là endpoint POST/DELETE mới ⇒ cần `serverpod generate` bên
  server đã sinh client trước (N1-S5).
