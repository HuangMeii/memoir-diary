# Quy ước — bộ task Ghi chú

Áp dụng cho mọi file trong `docs/notes/`. Kế thừa `docs/jira/00-conventions.md`
(Epic → Story/Spike → Subtask, AC Given/When/Then, DoD) và bổ sung phần kỹ thuật
riêng của tính năng Ghi chú.

## 1. Cấu trúc một file task

Mỗi file là **một task nhỏ**, theo đúng thứ tự sau:

```markdown
# <ID> · <Tên task>
**Epic:** N# · **Ước lượng:** <n> pts · **Phụ thuộc:** <ID>
**Nguồn thiết kế:** ui-figma/<ghichu|taoghichu>   (chỉ task UI)

## Mục tiêu
## Phạm vi              (file đụng tới · KHÔNG đụng tới)
## Việc cần làm         (checklist từng bước)
## Acceptance Criteria  (Given/When/Then, đánh số)
## Kiểm chứng           (câu lệnh chạy được)
## Rủi ro / ghi chú
```

- ID theo `N<epic>-S<task>` (khớp bảng ở `README.md`).
- Ước lượng theo Fibonacci; task ≤ 5 điểm. Task > 5 phải tách tiếp.
- Mọi task UI **bắt buộc** ghi `Nguồn thiết kế` + tên section trong `code.html`
  để đối chiếu khi dựng.

## 2. Quy ước code

| Chủ đề | Quy ước |
|---|---|
| Ngôn ngữ | Code/comment **tiếng Anh**; tài liệu/UI **tiếng Việt** (theo `PLAN.md` §6) |
| Flutter | feature-first; Riverpod cho state; repository cho API |
| Serverpod | domain code ở `lib/src/<domain>/`; một `.spy.yaml` / model; `<domain>_endpoint.dart` / endpoint |
| Lỗi client | ném `ApiException` với `code` ổn định (đừng ném `Exception` thô) |
| CSS → Flutter | Tailwind `rounded-xl` → `MemoirRadius.card` (20); `rounded-lg` → `MemoirRadius.page` (16); `rounded-full` → `MemoirRadius.pill` |

## 3. Map tài nguyên thiết kế

Thiết kế dùng font và icon khác với tài nguyên app đang có; **không thêm asset
mới**, map về cái sẵn có:

| Thiết kế (DESIGN.md) | App dùng | Ghi chú |
|---|---|---|
| `Newsreader` (serif) | **`Lora`** (`serifFamily`) | Heading/tiêu đề lớn |
| `Plus Jakarta Sans` (sans) | **`Inter`** (`sansFamily`) | Toàn bộ UI text |
| Material Symbols Outlined | Material Icons / `MemoirIcon` | Chỉ 18 SVG trong `assets/icons/`; icon khác dùng Material |

Cỡ chữ: map thang `headline-xl/lg/md/sm`, `body-lg/md/sm`, `label-md/sm`,
`caption` của Stitch sang các hằng trong `MemoirType`
(`headingPage`, `heading1`, `headingEditorial`, `body`, `label`, `caption`,
`overlineEditorial`). Không hard-code số px rời rạc trong widget.

Màu: dùng `MemoirColorsLight`/`MemoirColorsDark` qua `MemoirPalette` / `Theme.of`.
**Không** dán mã hex Stitch (`#254d36`, `#f7faf5`…) trực tiếp vào widget — bảng
màu Stitch là biến thể khác của palette Figma; nếu thật sự cần một màu mới, thêm
token rồi regenerate `tokens.dart`.

## 4. Quy ước Serverpod

- **Không sửa** `lib/src/generated/**` và `memoir_server_client/**` — do generator
  ghi đè. Sửa `.spy.yaml`, endpoint, `lib/server.dart`.
- Sau khi đổi `.spy.yaml` có `table`: chạy `serverpod generate`, rồi
  `serverpod create-migration`.
- Migration là **ngoại lệ** được sửa tay `migration.sql` khi SQL sinh ra sẽ mất
  dữ liệu; **không** đụng các file khác trong thư mục migration, và schema cuối
  cùng phải khớp `definition.sql`.
- Migration chỉ **sinh** ở đây; **apply** do `serverpod start` khi boot.
- Mọi endpoint ghi dữ liệu đều `requireLogin = true` + `currentUserId(session)` +
  kiểm tra `ensureOwned(...)` (xem `notes_endpoint.dart` hiện tại).

## 5. Quy ước Flutter

- Screen đặt ở `flutter_app/lib/src/ui/screens/`; widget phụ đặt trong thư mục
  feature `flutter_app/lib/src/ui/notes/`.
- Dùng chrome chung: `AppHeader` (`widgets/app_header.dart`), `AppFooterBar`
  (`widgets/app_footer.dart`), `HomeScale` (`home/home_scale.dart`).
- Provider: thêm vào `flutter_app/lib/src/data/providers.dart`; FutureProvider
  **phải** `await ref.watch(authReadyProvider.future)` trước khi gọi API.
- Test đặt trong `flutter_app/test/`; hàm thuần (format/lọc/sort) tách khỏi widget
  để test không cần network.

## 6. DoD của tính năng (áp dụng cho toàn bộ epic)

- [ ] `dart analyze` sạch (server) và `flutter analyze` sạch (app).
- [ ] `dart format` đã chạy (server).
- [ ] `dart test` xanh (server) — nhóm notes.
- [ ] `flutter test` xanh (app) — gồm `test/notes_test.dart`.
- [ ] Đã verify trên web (`flutter run -d chrome --web-port 8080`) đối chiếu
  `ui-figma/ghichu/screen.png` và `ui-figma/taoghichu/screen.png`.
- [ ] `docs/03-database-schema.md`, `docs/04-api-reference.md`,
  `docs/UI-design/09-notes.md`, `README.md`/`PLAN.md` đã cập nhật (task N5-S2).
- [ ] Migration đã review: thêm cột/bảng, **không** mất dữ liệu.
