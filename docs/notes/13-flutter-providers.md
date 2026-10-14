# N2-S5 · Provider `notesProvider`

**Epic:** N2 · **Ước lượng:** 1 pt · **Phụ thuộc:** N2-S4
**File:** `flutter_app/lib/src/data/providers.dart`

## Mục tiêu

Đưa dữ liệu ghi chú vào Riverpod theo đúng khuôn các domain khác, để màn danh sách
và trình soạn thảo dùng chung một nguồn và invalidate gọn.

## Phạm vi

- **Sửa:** `flutter_app/lib/src/data/providers.dart`.
- **KHÔNG sửa:** `notesRepositoryProvider` hiện có (giữ nguyên cách tạo).

## Việc cần làm

- [ ] `notesProvider` — `FutureProvider<List<Note>>`, **await**
  `ref.watch(authReadyProvider.future)` trước khi gọi `list()` (tránh race 401 như
  comment trong file).
- [ ] `trashedNotesProvider` — `FutureProvider<List<Note>>` gọi
  `list(trashed: true)`.
- [ ] `noteDetailProvider` — `FutureProvider.family<NoteDetail, String>` gọi `get(id)`.
- [ ] `refreshNotes(WidgetRef ref)` — `ref.invalidate(notesProvider)` +
  `trashedNotesProvider` + `noteDetailProvider`.
- [ ] `flutter analyze`.

## Acceptance Criteria

1. *Given* chưa có token, *when* `notesProvider` được đọc, *then* nó chờ
   `authReadyProvider` (không bắn request 401).
2. *Given* `refreshNotes(ref)`, *then* danh sách thường, thùng rác và chi tiết đều
   được invalidate.
3. *Given* `noteDetailProvider('abc')`, *then* gọi `get('abc')`.
4. *Then* `flutter analyze` sạch.

## Kiểm chứng

```powershell
cd flutter_app
flutter analyze
Select-String -Path 'lib\src\data\providers.dart' -Pattern 'notesProvider|refreshNotes'
```

## Rủi ro / ghi chú

- Đặt ngay cạnh `notesRepositoryProvider` để dễ đọc; `refreshNotes` đặt cạnh
  `refreshEntryData` cho nhất quán.
- Không cache lọc/sắp xếp trong provider — UI lọc trong bộ nhớ (N3-S2) vì số ghi
  chú nhỏ; nếu sau này lớn, chuyển lọc lên server.
