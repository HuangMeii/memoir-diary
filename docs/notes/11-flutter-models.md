# N2-S3 · Model Dart `Note` + con

**Epic:** N2 · **Ước lượng:** 2 pts · **Phụ thuộc:** N2-S1
**File:** `flutter_app/lib/src/data/models.dart`

## Mục tiêu

Thay `Map<String, dynamic>` thô bằng model có kiểu cho ghi chú — cùng cách các
domain khác đang làm (`DiaryEntry`, `HealthLog`, `WeatherDay`…).

## Phạm vi

- **Sửa:** `flutter_app/lib/src/data/models.dart` (thêm class mới ở cuối file).
- **KHÔNG sửa:** `_noteMap` trong datasource (vẫn là nguồn JSON); không đổi model khác.

## Việc cần làm

- [ ] Thêm `class Note` với `fromJson` + `toJson` theo shape snake_case của
  `_noteMap`: `id, title, content, color, tags, isPinned, isArchived, isTrashed,
  createdAt, updatedAt`.
- [ ] Thêm `class NoteChecklistItem` (`id, noteId, text, isDone, sortOrder`).
- [ ] Thêm `class NoteEntryLink` (`id, noteId, entryId, createdAt`) — dùng khi
  `NoteDetail` trả link thay vì entry.
- [ ] Thêm tiện ích dùng chung cho UI/test:
  - `String get displayTitle` — `title` nếu có, ngược lại dòng đầu của `content`
    (cắt ≤ 60 ký tự), cuối cùng là `'(Ghi chú)'`.
  - `String get preview` — đoạn text đầu của `content` bỏ qua dòng tiêu đề.
  - `int get wordCount` — đếm từ trên `content`.
  - `NoteChecklistItem.copyWith({bool? isDone})` cho toggle nhanh.
- [ ] `flutter analyze`.

## Acceptance Criteria

1. *Given* JSON từ `_noteMap`, *when* `Note.fromJson`, *then* `tags` là
   `List<String>` (mặc định `const []` khi thiếu), các cờ bool mặc định `false`.
2. *Given* note không có `title`, *then* `displayTitle` lấy dòng đầu của `content`.
3. *Given* `content` nhiều dòng, *then* `preview` **không** chứa dòng tiêu đề.
4. *Given* `content` 840 từ, *then* `wordCount == 840` (theo dòng thân, không tính
   ký hiệu markdown thuần).
5. *Then* `flutter analyze` sạch.

## Kiểm chứng

```powershell
cd flutter_app
flutter analyze
# sau N5-S1:
flutter test test/notes_test.dart
```

## Rủi ro / ghi chú

- `displayTitle`/`preview`/`wordCount` là **hàm thuần** ⇒ đặt ở model để test không
  cần widget/network (N5-S1).
- Đừng đặt logic lọc/sắp xếp ở đây; các hàm đó thuộc một file helper riêng cho màn
  danh sách (N3-S2) để tránh model phình.
- `createdAt`/`updatedAt` giữ nullable như `SelfMessage`/`Reflection` để chịu được
  payload thiếu.
