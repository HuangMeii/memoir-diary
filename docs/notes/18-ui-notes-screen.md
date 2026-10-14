# N3-S5 · Viết lại `notes_screen.dart` (2 section + chrome)

**Epic:** N3 · **Ước lượng:** 3 pts · **Phụ thuộc:** N3-S2, N3-S3, N3-S4
**Nguồn thiết kế:** `ui-figma/ghichu/screen.png` (toàn trang: header, tìm kiếm,
chip, "ĐÃ GHIM", "TẤT CẢ GHI CHÚ", callout, footer)

## Mục tiêu

Thay màn `NotesScreen` tối giản hiện tại bằng bố cục đầy đủ của thiết kế, dùng
chrome chung (`AppHeader`, `AppFooterBar`) và dữ liệu từ `notesProvider`.

## Phạm vi

- **Viết lại:** `flutter_app/lib/src/ui/screens/notes_screen.dart`.
- **Dùng:** `ui/notes/notes_chrome.dart`, `notes_search_field`/`notes_filter_bar.dart`,
  `note_card.dart`, `notes_callout.dart`.
- **KHÔNG sửa:** `home/shortcut_cards.dart` (đã trỏ tới `NotesScreen`).

## Việc cần làm

- [ ] `ConsumerStatefulWidget`; giữ state cục bộ: `search`, `filter`, `tag`, `sort`,
  `isGrid`, `showTrash`.
- [ ] Dựng: `AppHeader(date, initials, onLogout, destination: AppDestination.home)`
  → nội dung trong `SingleChildScrollView` + `Center` + `ConstrainedBox(maxWidth: 1200)`:
  1. `NotesBreadcrumb`
  2. `NotesPageHeader(count: notes.length, onTrash: …, onCreate: …)`
  3. `NotesFilterBar(...)` (bind state)
  4. Section **"ĐÃ GHIM"** (nhãn + "n ghi chú ưu tiên") → lưới `NoteCard` `isPinned`.
  5. Section **"TẤT CẢ GHI CHÚ"** (nhãn + "n ghi chú thường") → phần còn lại.
  6. `NotesCallout()`
  - → `AppFooterBar()`.
- [ ] Lưới: `Wrap`/`GridView` số cột theo bề rộng (mobile 1, ≥768px 2, ≥1200px 4)
  như thiết kế; chế độ list là 1 cột ẩn bớt thân.
- [ ] Hành vi: `onCreate` mở `NoteEditorScreen()` (N4-S1) — với `Note?` null; card
  `onOpen` mở editor với note đó; `onPin`/`onArchive`/`onTrash` gọi repository rồi
  `refreshNotes(ref)`.
- [ ] Giữ nhãn section đúng thiết kế: "ĐÃ GHIM", "TẤT CẢ GHI CHÚ" (chip nhỏ).
- [ ] `flutter analyze`.

## Acceptance Criteria

1. *Given* có note ghim, *then* section "ĐÃ GHIM" hiển thị trước và "TẤT CẢ GHI CHÚ"
   không lặp lại note đó.
2. *Given* bấm "Ghim" trên một card, *then* note chuyển sang section "ĐÃ GHIM" sau
   khi refresh (không cần tải lại trang).
3. *Given* bấm "+ Ghi chú mới", *then* mở trình soạn thảo (N4) và lưu xong quay về
   thấy note mới.
4. *Given* bấm "Xem thùng rác", *then* vào chế độ thùng rác (N3-S6).
5. *Given* bề rộng ≥ 1200px, *then* lưới 4 cột; 390px → 1 cột, không tràn.
6. *Then* `flutter analyze` sạch; `NotesScreen` không còn `TextField` thêm nhanh cũ.

## Kiểm chứng

```powershell
cd flutter_app
flutter analyze
flutter run -d chrome --web-port 8080
```

So từng vùng với `ui-figma/ghichu/screen.png`: header → tìm kiếm → chip → ĐÃ GHIM →
TẤT CẢ → callout → footer.

## Rủi ro / ghi chú

- **Thứ tự nhãn section** và **nguồn dữ liệu** phải khớp thiết kế; note vừa ghim
  vẫn nằm trong `notesProvider`, chỉ đổi vị trí nhóm.
- `AppHeader` cần `ref` → lấy `displayName`/`initialsOf` như `HomeScreen` làm; copy
  cách đó thay vì tự chế.
- Nếu `NoteEditorScreen` chưa xong (N4), tạm mở `NoteEditorScreen` dạng stub để
  `analyze` vẫn sạch — nhưng đừng merge trước khi N4 xong.
