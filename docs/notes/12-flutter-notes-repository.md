# N2-S4 · `NotesRepository` mở rộng

**Epic:** N2 · **Ước lượng:** 2 pts · **Phụ thuộc:** N2-S2, N2-S3
**File:** `flutter_app/lib/src/data/repositories/notes_repository.dart`

## Mục tiêu

Cho repository phủ đủ hành vi thiết kế và trả model có kiểu thay vì map thô.

## Phạm vi

- **Sửa:** `flutter_app/lib/src/data/repositories/notes_repository.dart`.
- **KHÔNG sửa:** `BackendDataSource`; các repository khác.

## Việc cần làm

- [ ] `Future<List<Note>> list({bool archived = true, bool trashed = false})`
  → `get('/notes', query: {'archived': '$archived', 'trashed': '$trashed'})`.
- [ ] `Future<NoteDetail> get(String id)` → `get('/notes/$id')`.
- [ ] `Future<Note> create({required String content, String? title, String? color,
  List<String>? tags, bool? isPinned, List<NoteChecklistItem>? checklist,
  List<String>? entryIds})` → `post('/notes', ...)`.
- [ ] `Future<Note> update(String id, {String? title, String? content, String? color,
  List<String>? tags, bool? isPinned, bool? isArchived, bool? isTrashed,
  List<NoteChecklistItem>? checklist, List<String>? entryIds})`
  → `put('/notes/$id', ...)`.
- [ ] `Future<void> setPinned(String id, bool value)` và
  `setArchived(String id, bool value)` (gói `update`/`archive`).
- [ ] `Future<void> trash(String id)` (soft), `restore(String id)`,
  `purge(String id)`.
- [ ] Giữ `delete(String id)` → `trash` (để không phá caller cũ) **hoặc** đổi tên và
  cập nhật caller duy nhất (`notes_screen.dart` được viết lại ở N3-S5).
- [ ] `flutter analyze`.

## Acceptance Criteria

1. *Given* repository mới, *when* `list()`, *then* trả `List<Note>` (không phải map).
2. *Given* `list(trashed: true)`, *then* gọi `GET /notes?trashed=true`.
3. *Given* `update(id, isPinned: true)`, *then* gửi `PUT /notes/{id}` với
   `is_pinned: true` và các field khác bằng giá trị hiện tại (không xoá nhầm).
4. *Given* `restore(id)` / `purge(id)`, *then* gọi đúng endpoint POST/DELETE tương ứng.
5. *Then* `flutter analyze` sạch; không caller nào còn dùng API cũ đã xoá.

## Kiểm chứng

```powershell
cd flutter_app
flutter analyze
Select-String -Path 'lib\src\**\*.dart' -Pattern 'notesRepositoryProvider'
```

## Rủi ro / ghi chú

- `update` phải gửi **đầy đủ** object (đặc tính của `put` trong datasource): repository
  nên nhận `Note` hiện tại hoặc yêu cầu caller truyền hết field — chọn cách nhận
  `Note` + `copyWith` để khó quên field.
- Xoá `add(content)` cũ: hiện chỉ `notes_screen.dart` gọi; đổi cùng lúc ở N3-S5 để
  `flutter analyze` vẫn sạch.
