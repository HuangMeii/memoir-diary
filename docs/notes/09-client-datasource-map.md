# N2-S1 · Map đọc trong `ServerpodDataSource`

**Epic:** N2 · **Ước lượng:** 3 pts · **Phụ thuộc:** N1-S7
**File:** `flutter_app/lib/src/data/datasources/serverpod_data_source.dart`

## Mục tiêu

Đưa các field mới của `Note` + chi tiết (`NoteDetail`) ra dạng JSON snake_case mà
repository Dart đọc được, đồng thời thêm `GET /notes/{id}` và `GET /entries/{id}`.

## Phạm vi

- **Sửa:** nhánh `get(...)` và hàm `_noteMap` trong `serverpod_data_source.dart`.
- **KHÔNG sửa:** `backend_data_source.dart` (interface giữ nguyên); `_entryMap` chỉ
  bổ sung nếu cần.

## Việc cần làm

- [ ] Mở rộng `_noteMap(sp.Note n)` thêm:
  `title`, `tags`, `is_archived`, `is_trashed` (giữ `id, content, color, is_pinned,
  created_at, updated_at`).
- [ ] Thêm `_checklistMap(sp.NoteChecklistItem i)` → `{id, note_id, text, is_done, sort_order}`.
- [ ] Thêm `_noteDetailMap(sp.NoteDetail d)` → `{note, checklist: [...], entries: [...]}`
  (dùng `_entryMap` cho `entries`).
- [ ] Trong `get(...)`, nhánh `case '/notes':` truyền query:
  `includeArchived: query?['archived'] != 'false'`, `trashedOnly: query?['trashed'] == 'true'`.
- [ ] Thêm nhánh `if (path.startsWith('/notes/'))` → `notes.get(id)` → `_noteDetailMap`
  (đặt **sau** `case '/notes'` để không nuốt nhánh list).
- [ ] Thêm nhánh `if (path.startsWith('/entries/') && !path.endsWith('/images'))`
  → `entries.get(id)` → `_entryMap` (chỉ khi không khớp `by-date`/`images`).
- [ ] `flutter analyze`.

## Acceptance Criteria

1. *Given* server trả `Note` có `title`, `tags`, `isTrashed`, *when* repository gọi
   `GET /notes`, *then* mỗi phần tử map có đủ `title`, `tags`, `is_archived`,
   `is_trashed`.
2. *Given* `GET /notes?trashed=true`, *then* gọi `notes.list(trashedOnly: true)`.
3. *Given* `GET /notes/{id}`, *then* trả `{note, checklist, entries}` với `entries`
   đã qua `_entryMap` (camelCase đã chuẩn hoá như các domain khác).
4. *Given* `GET /entries/{id}` (không phải `/by-date` hay `/images`), *then* trả một
   entry đã map; id không tồn tại → `ApiException(statusCode: 404)` như nhánh
   `/entries/by-date/` hiện có.
5. *Then* `flutter analyze` sạch.

## Kiểm chứng

```powershell
cd flutter_app
flutter analyze
```

Đối chiếu nhanh bằng `Select-String -Path 'lib\src\data\datasources\serverpod_data_source.dart' -Pattern 'is_trashed|_noteDetailMap'`.

## Rủi ro / ghi chú

- **Thứ tự nhánh quan trọng**: `case '/notes'` phải đứng trước
  `if (path.startsWith('/notes/'))`, nếu không `GET /notes` sẽ rơi vào nhánh detail
  với id `''`.
- `_noteUrls`-style cache không cần ở đây (không có URL ảnh).
- Nếu `NoteDetail` đổi sang trả `links` thay vì `entries` (xem N1-S4), cập nhật
  `_noteDetailMap` tương ứng.
