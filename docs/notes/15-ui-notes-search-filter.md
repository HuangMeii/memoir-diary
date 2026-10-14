# N3-S2 · Tìm kiếm + chip lọc + sắp xếp + toggle hiển thị

**Epic:** N3 · **Ước lượng:** 3 pts · **Phụ thuộc:** N3-S1
**Nguồn thiết kế:** `ui-figma/ghichu/code.html` dòng ~236–300 (ô tìm kiếm, hàng
chip `Tất cả (18) / Gần đây (6) / Đã ghim (3) / #tag… / Đã lưu trữ (4)`, dropdown
"Sắp xếp", toggle list/grid)

## Mục tiêu

Cho người dùng tìm, lọc theo chip và sắp xếp danh sách ghi chú — đều xử lý **phía
client** trên danh sách đã tải.

## Phạm vi

- **Tạo mới:** `flutter_app/lib/src/ui/notes/notes_filter_bar.dart` (widget) và
  `flutter_app/lib/src/ui/notes/notes_query.dart` (hàm thuần, testable).
- **KHÔNG sửa:** `notes_screen.dart` (ghép ở N3-S5).

## Việc cần làm

- [ ] `notes_query.dart` — định nghĩa enum + hàm thuần:
  - `enum NoteFilter { all, recent, pinned, archived, tag }` (tag mang thêm giá trị).
  - `enum NoteSort { updatedDesc, createdDesc, titleAsc }`.
  - `String normalize(String s)` — bỏ dấu tiếng Việt + hạ chữ thường (tìm không dấu).
  - `List<Note> applyNotesQuery(List<Note> notes, {String search, NoteFilter filter,
    String? tag, NoteSort sort})`.
  - `Map<String, int> noteTagCounts(List<Note>)` — cho chip `#tag` động.
- [ ] `notes_filter_bar.dart` — widget `NotesFilterBar`:
  - `TextField` bo tròn với icon kính lúp; phím tắt `⌘K`/`Ctrl K` hiển thị bên phải
    (chỉ nhãn, chưa cần bắt phím).
  - Hàng chip: "Tất cả (n)", "Gần đây (n)", "Đã ghim (n)", "...", từng `#tag`,
    "Đã lưu trữ (n)" — chip đang chọn có nền primary, chữ trắng.
  - Dropdown "Sắp xếp: …" (`PopupMenuButton`/`DropdownButton`).
  - Toggle 2 icon (lưới / danh sách) → callback `onViewChanged(bool isGrid)`.
- [ ] Định nghĩa "Gần đây": note có `updatedAt` trong **7 ngày** gần nhất.
- [ ] `flutter analyze`.

## Acceptance Criteria

1. *Given* danh sách có note "Cà phê sáng", *when* tìm "ca phe" (không dấu), *then*
   vẫn khớp (tìm không dấu).
2. *Given* chip "Đã ghim (3)", *then* chỉ hiển thị note `isPinned == true` và số đếm
   khớp dữ liệu.
3. *Given* chip `#CôngViệc`, *then* chỉ hiển thị note có tag đó; chip tag được sinh
   từ `noteTagCounts` của dữ liệu hiện có.
4. *Given* "Đã lưu trữ (4)", *then* chỉ hiển thị note `isArchived == true`.
5. *Given* sắp xếp "Mới cập nhật", *then* note có `updatedAt` lớn nhất đứng đầu.
6. *Given* bấm toggle, *then* `onViewChanged` nhận `true`/`false` tương ứng.
7. *Then* mọi hàm trong `notes_query.dart` là **hàm thuần** (test ở N5-S1).

## Kiểm chứng

```powershell
cd flutter_app
flutter analyze
flutter test test/notes_test.dart   # sau N5-S1
```

## Rủi ro / ghi chú

- Lọc **trên client** vì danh sách ghi chú nhỏ; nếu sau này > ~500 note, chuyển
  `search/filter/sort` xuống endpoint `notes.list`.
- "Tất cả" **không** tính note ở thùng rác (thùng rác là chế độ riêng, N3-S6).
- Bỏ dấu tiếng Việt: dùng bảng thay thế thủ công (`àáảãạ` → `a`…) để không phụ
  thuộc package mới.
