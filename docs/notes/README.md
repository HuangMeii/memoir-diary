# Ghi chú (LIB-01) + Trình soạn ghi chú — bộ task

Thư mục này chia nhỏ việc **nâng cấp tính năng Ghi chú** của Memoir thành các task
nhỏ (mỗi task ≤ 1 ngày), dựa trên hai bản export từ **Stitch** đã tải về
`ui-figma/`. Đây là tài liệu *kế hoạch/kỹ thuật*; không chứa code chạy.

## 1. Nguồn thiết kế

| Nguồn | Màn hình | File |
|---|---|---|
| `ui-figma/ghichu/` | Danh sách ghi chú (web) | `code.html`, `DESIGN.md`, `screen.png` |
| `ui-figma/taoghichu/` | Trình soạn ghi chú (modal, web) | `code.html`, `DESIGN.md`, `screen.png` |

Hai `DESIGN.md` giống nhau — cùng design system **"Warm Editorial Canvas"**
(primary `#254d36`, surface `#f7faf5`, Newsreader + Plus Jakarta Sans).

## 2. Hiện trạng (trước khi làm)

| Lớp | File | Tình trạng |
|---|---|---|
| UI | `flutter_app/lib/src/ui/screens/notes_screen.dart` | Chỉ là `Scaffold` + `AppBar('Ghi chú nhanh')` + `TextField` + `ListView` card mặc định — rất xa thiết kế |
| Data | `flutter_app/lib/src/data/repositories/notes_repository.dart` | Chỉ có `list()` / `add(content)` / `delete(id)` — chưa có `update` |
| Transport | `flutter_app/lib/src/data/datasources/serverpod_data_source.dart` | Đã map `GET /notes`, `POST /notes`, `DELETE /notes/{id}`; **thiếu `PUT /notes/{id}`** |
| Model | `memoir_server_server/lib/src/notes/note.spy.yaml` | Chỉ có `userId, content, color, isPinned, createdAt, updatedAt` |
| Endpoint | `memoir_server_server/lib/src/notes/notes_endpoint.dart` | `list/create/update/delete`; `update` bỏ qua `title` |

## 3. Phạm vi

**Đầy đủ như thiết kế** — mở rộng DB/model, endpoint, rồi dựng lại cả hai màn hình.
Thiết kế có những thứ schema hiện tại chưa có: **tiêu đề riêng, thẻ (tag),
checklist tương tác, thùng rác/lưu trữ, liên kết nhật ký nhiều trang**.

## 4. Bốn quyết định schema (đã chốt phương án A)

| # | Quyết định | Phương án A (chốt) | Phương án B (loại) |
|---|---|---|---|
| 1 | Checklist tương tác | **Bảng con `note_checklist_items`** (cascade theo note) | Nhúng JSON vào `content` |
| 2 | Liên kết nhật ký | **Bảng nối `note_entry_links`** (nhiều–nhiều) | Một cột `entryId` (chỉ 1 trang) |
| 3 | Xoá ghi chú | **Soft-delete (`isTrashed`) + `restore`/`purge`** | Xoá cứng như hiện tại |
| 4 | Định dạng thân note | **Markdown-lite trong `content`** (H1–H3, bullet, checklist, quote, divider) | Mô hình block rich-text đầy đủ |

Chi tiết từng quyết định nằm trong file task tương ứng (N1-S1…N1-S3).

## 5. Bảng task

Trạng thái: `TODO` · `DOING` · `DONE`.

### Epic N1 — Backend Ghi chú (Serverpod)

| ID | Task | Ước lượng | Phụ thuộc | File | Trạng thái |
|---|---|---|---|---|---|
| N1-S1 | Mở rộng model `Note` | 2 | — | [01-backend-note-model.md](01-backend-note-model.md) | TODO |
| N1-S2 | Model checklist con | 2 | N1-S1 | [02-backend-checklist-model.md](02-backend-checklist-model.md) | TODO |
| N1-S3 | Model liên kết nhật ký | 2 | N1-S1 | [03-backend-entry-link-model.md](03-backend-entry-link-model.md) | TODO |
| N1-S4 | DTO `NoteDetail` | 1 | N1-S2, N1-S3 | [04-backend-note-detail-dto.md](04-backend-note-detail-dto.md) | TODO |
| N1-S5 | Endpoint `notes` mở rộng | 5 | N1-S4 | [05-backend-notes-endpoint.md](05-backend-notes-endpoint.md) | TODO |
| N1-S6 | `entries.get(id)` | 2 | — | [06-backend-entries-get.md](06-backend-entries-get.md) | TODO |
| N1-S7 | Migration | 2 | N1-S5, N1-S6 | [07-backend-migration.md](07-backend-migration.md) | TODO |
| N1-S8 | Integration test endpoint | 3 | N1-S7 | [08-backend-endpoint-tests.md](08-backend-endpoint-tests.md) | TODO |

### Epic N2 — Cầu nối & tầng dữ liệu Flutter

| ID | Task | Ước lượng | Phụ thuộc | File | Trạng thái |
|---|---|---|---|---|---|
| N2-S1 | Map đọc trong `ServerpodDataSource` | 3 | N1-S7 | [09-client-datasource-map.md](09-client-datasource-map.md) | TODO |
| N2-S2 | Map ghi (POST/PUT/DELETE/restore/purge) | 3 | N2-S1 | [10-client-datasource-writes.md](10-client-datasource-writes.md) | TODO |
| N2-S3 | Model Dart `Note` + con | 2 | N2-S1 | [11-flutter-models.md](11-flutter-models.md) | TODO |
| N2-S4 | `NotesRepository` mở rộng | 2 | N2-S2, N2-S3 | [12-flutter-notes-repository.md](12-flutter-notes-repository.md) | TODO |
| N2-S5 | Provider `notesProvider` | 1 | N2-S4 | [13-flutter-providers.md](13-flutter-providers.md) | TODO |

### Epic N3 — UI danh sách Ghi chú (`ui-figma/ghichu`)

| ID | Task | Ước lượng | Phụ thuộc | File | Trạng thái |
|---|---|---|---|---|---|
| N3-S1 | Breadcrumb + header trang | 2 | N2-S5 | [14-ui-notes-chrome.md](14-ui-notes-chrome.md) | TODO |
| N3-S2 | Tìm kiếm + chip lọc + sort + toggle | 3 | N3-S1 | [15-ui-notes-search-filter.md](15-ui-notes-search-filter.md) | TODO |
| N3-S3 | `note_card.dart` + biến thể | 3 | N2-S3 | [16-ui-note-card.md](16-ui-note-card.md) | TODO |
| N3-S4 | Banner kết nối nhật ký | 1 | N3-S1 | [17-ui-notes-callout.md](17-ui-notes-callout.md) | TODO |
| N3-S5 | `notes_screen.dart` (2 section) | 3 | N3-S2, N3-S3, N3-S4 | [18-ui-notes-screen.md](18-ui-notes-screen.md) | TODO |
| N3-S6 | States: loading/empty/error/trash | 2 | N3-S5 | [19-ui-notes-states.md](19-ui-notes-states.md) | TODO |

### Epic N4 — UI trình soạn ghi chú (`ui-figma/taoghichu`)

| ID | Task | Ước lượng | Phụ thuộc | File | Trạng thái |
|---|---|---|---|---|---|
| N4-S1 | Top bar (autosave, màu, ghim, thẻ, liên kết) | 3 | N2-S5 | [20-ui-note-editor-topbar.md](20-ui-note-editor-topbar.md) | TODO |
| N4-S2 | Thanh format | 2 | N4-S1 | [21-ui-note-editor-toolbar.md](21-ui-note-editor-toolbar.md) | TODO |
| N4-S3 | Tiêu đề + meta + thân nội dung | 3 | N4-S2 | [22-ui-note-editor-body.md](22-ui-note-editor-body.md) | TODO |
| N4-S4 | Panel liên kết nhật ký | 2 | N4-S3 | [23-ui-note-editor-links.md](23-ui-note-editor-links.md) | TODO |
| N4-S5 | Footer (Xóa / Lưu bản sao / Xong) | 2 | N4-S4 | [24-ui-note-editor-footer.md](24-ui-note-editor-footer.md) | TODO |

### Epic N5 — Kiểm thử, tài liệu, kiểm chứng

| ID | Task | Ước lượng | Phụ thuộc | File | Trạng thái |
|---|---|---|---|---|---|
| N5-S1 | `test/notes_test.dart` | 3 | N2-S3 | [25-test-flutter-notes.md](25-test-flutter-notes.md) | TODO |
| N5-S2 | Cập nhật tài liệu dự án | 2 | N1-S7, N3-S6, N4-S5 | [26-docs-update.md](26-docs-update.md) | TODO |
| N5-S3 | Kiểm chứng end-to-end | 2 | toàn bộ | [27-verification.md](27-verification.md) | TODO |

## 6. Thứ tự thực hiện

```
README → 00-conventions
N1: 01 → 02 → 03 → 04 → 05 → 06 → 07 → 08
N2: 09 → 10 → 11 → 12 → 13
N3: 14 → (16 // 17) → 15 → 18 → 19
N4: 20 → (21 // 22) → 23 → 24
N5: 25 → 26 → 27
```

Song song được khi không chạm cùng file: `N3-S3 // N3-S4`, `N4-S2 // N4-S3`,
`N1-S6 // N1-S1..S5`.

## 7. Lệnh hay dùng

```bash
# Backend (Serverpod) — chạy trong memoir_server/memoir_server_server
serverpod generate                 # sinh lại generated/ + memoir_server_client
serverpod create-migration         # sau khi đổi .spy.yaml có `table`
dart analyze ; dart format . ; dart test

# Flutter — chạy trong flutter_app
flutter pub get
flutter analyze ; flutter test
flutter run -d chrome --web-port 8080   # khớp CORS_ORIGINS của backend
```

## 8. Ghi chú chung

- **Không sửa file generated** (`lib/src/generated/**` và toàn bộ
  `memoir_server_client`). Chỉ sửa `.spy.yaml`, endpoint, và `migration.sql` của
  migration *vừa sinh* khi SQL cần chỉnh tay.
- Migration chỉ **sinh** trong kế hoạch này; việc **apply** là bước bạn kiểm soát
  (`serverpod start` sẽ tự áp migration khi boot).
- Font/icon: map về tài nguyên sẵn có — Newsreader → **Lora**, Plus Jakarta Sans →
  **Inter**, Material Symbols → Material Icons / `MemoirIcon`. Xem `00-conventions.md`.
- Quy ước issue/AC/DoD kế thừa `docs/jira/00-conventions.md`.


