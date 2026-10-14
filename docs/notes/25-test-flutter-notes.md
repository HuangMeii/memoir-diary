# N5-S1 · `test/notes_test.dart`

**Epic:** N5 · **Ước lượng:** 3 pts · **Phụ thuộc:** N2-S3
**Mẫu:** `flutter_app/test/widget_test.dart` (group + `test`/`testWidgets`)

## Mục tiêu

Test các **hàm thuần** của tính năng Ghi chú (model, lọc/sắp xếp, markdown-lite, và
một widget card) để không phụ thuộc backend.

## Phạm vi

- **Tạo mới:** `flutter_app/test/notes_test.dart`.
- **KHÔNG sửa:** `widget_test.dart`, `calendar_views_test.dart`.

## Việc cần làm

- [ ] `group('Note.fromJson')` — map đủ field; `tags` mặc định rỗng; cờ bool mặc
  định false; `updatedAt` null chấp nhận được.
- [ ] `group('Note display helpers')` — `displayTitle` (có/không `title`),
  `preview` (bỏ dòng tiêu đề), `wordCount`.
- [ ] `group('notes query')` — `applyNotesQuery`: tìm không dấu ("ca phe" khớp "Cà
  phê"), chip pinned/archived, lọc theo tag, sort `updatedDesc`/`titleAsc`;
  `noteTagCounts` đếm đúng.
- [ ] `group('markdown-lite')` — `toggleInline` bọc & bỏ bọc; `prefixLine` thêm/bỏ
  tiền tố; `insertChecklist`; `insertDivider`; kiểm tra `TextSelection` trả về.
- [ ] `testWidgets('NoteCard checklist variant')` — dựng
  `NoteCard(note: …, isGrid: true, …)` trong `MaterialApp(theme: buildTheme(light))`;
  khẳng định có "1/3", có `Checkbox`, và bấm ghim gọi callback **đúng 1 lần**.
- [ ] `flutter test`.

## Acceptance Criteria

1. *Given* dữ liệu mẫu, *then* mọi nhóm test trên xanh, chạy < 10s, **không** cần
   network.
2. *Given* `NoteCard` với checklist 3 mục (1 done), *then* test khẳng định chuỗi
   "1/3" tồn tại.
3. *Given* bấm icon ghim, *then* callback `onPin` nhận `true` và chỉ một lần.
4. *Given* `flutter test` toàn bộ app, *then* không test nào hồi quy (các file test
   cũ vẫn xanh).
5. *Then* `flutter analyze` sạch.

## Kiểm chứng

```powershell
cd flutter_app
flutter analyze
flutter test test/notes_test.dart
flutter test
```

## Rủi ro / ghi chú

- Chỉ test **hàm thuần** + 1 widget; phần gọi API để lại cho integration test phía
  server (N1-S8) — đừng dựng mock `BackendDataSource` phức tạp.
- Nếu `applyNotesQuery` cần `Note` dựng tay, thêm factory test trong chính file test
  (không thêm vào `models.dart`).
