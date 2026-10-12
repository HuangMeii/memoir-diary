# JOURNAL-02 — Soạn nhật ký theo ngày

**Nền tảng:** MVP · Mobile + Web

## Sections

1. Ngày đang ghi và nút lưu.
2. Chọn thời tiết.
3. Chọn cảm xúc.
4. Nội dung nhật ký nhiều dòng.
5. Ảnh đính kèm.
6. Góc nhìn khác.
7. Nhắn nhủ tương lai / câu hỏi.
8. Tự chăm sóc hôm nay.
9. Hi vọng ngày mai.
10. Lòng biết ơn.
11. Giấc mơ.
12. Phản tư về câu nói.

## Hành vi

- Tạo mới hoặc sửa entry theo ngày, một entry/ngày.
- Nút lưu sticky trên web, AppBar/bottom action trên mobile.
- Thêm ảnh trước khi entry tồn tại phải hiện hướng dẫn lưu entry trước.
- Rời màn hình khi có thay đổi → confirm “Lưu bản nháp / Bỏ thay đổi / Tiếp tục”.

## States

New, Existing, Saving, Saved, Validation error, Server error.

## Thiết kế Figma — `JOURNAL-02 · …`

**Trạng thái:** màn này **chưa có frame nào trên Figma** (bridge `figma-mcp-go`
đang trả `plugin not connected`). Spec dưới đây lấy số đo **trực tiếp từ các
frame đã có** (`Page 2 — Web login states` cho ô nhập/nút, `HOME-01 · Web` cho
lựa chọn mood-weather, `Lưới tháng · Web` cho khung/tiêu đề/card), nên dựng theo
là khớp hệ thống hiện tại; chữ lấy đúng label/hint trong
`flutter_app/lib/src/ui/screens/entry_editor.dart` để design ↔ app khớp 1:1.

### Frame cần dựng (trên `Page 1`, theo lối đặt tên của file)

| Frame | Kích thước | Nội dung |
| --- | --- | --- |
| `JOURNAL-02 · Web · Ngày chưa ghi` | 1280×(auto) | App bar dùng chung (nav `Lưới tháng` active) + vùng lưu sticky (nút `Lưu nhật ký`, chưa có "đã lưu lúc"); breadcrumb `← Lưới tháng`; overline `TRANG NHẬT KÝ · 11.10`; tiêu đề `Chủ nhật, 11.10` (36/46) + "Chưa lưu cảm xúc hay thời tiết cho ngày này."; 2 cột 700 + 300 |
| `JOURNAL-02 · Web · Đã có nhật ký` | 1280 | Như trên, field đã có nội dung, "Đã lưu lúc 21:14" (`text.secondary`) cạnh nút, ảnh mở khoá |
| `JOURNAL-02 · Web · Đang lưu` | 1280 | Nút disabled "Đang lưu..." + spinner 16 |
| `JOURNAL-02 · Web · Đã lưu` | 1280 | Banner inline (`surface.brand-subtle` + icon `check` 15 + `text.brand`) dưới sticky save + link `Xem lưới tháng` |
| `JOURNAL-02 · Web · Lỗi lưu` | 1280 | Banner lỗi (`feedback.error` + `circle-alert`) + nút `Thử lại` |
| `JOURNAL-02 · Web · Rời màn khi chưa lưu` | 1280 | Nền tối 40% + dialog 420, radius 20, `elevation.drop-shadow-3`, 3 nút `Tiếp tục` / `Bỏ thay đổi` / `Lưu bản nháp` |
| `JOURNAL-02 · Mobile · Ngày chưa ghi` | 390×844 | Một cột, **bottom bar sticky** `Lưu nhật ký` cao 52 |
| `JOURNAL-02 · Mobile · Đã có nhật ký` | 390×844 | Như trên + ảnh đã có + "Đã lưu…" |

`JOURNAL-03` (ảnh) — xem `08-journal-photo-gallery.md`.

### Spec thành phần (đo từ frame có sẵn)

| Thành phần | Số đo | Token / style |
| --- | --- | --- |
| Ô nhập (1 dòng) | `Label` 16 cao + 8 + `Input` **52** cao, padding 16, radius **10** | `type/label`, `type/body/input` 14/17, `text.primary` / `text.secondary`, nền `surface.input`, viền `border.default`, radius `input` |
| Ô nhập nhiều dòng | cùng lối, `Input` = 52 + 17×(số dòng − 1); nhật ký chính ~220 | như trên |
| Nút chính | cao **52**, radius **10**, chữ `type/button` 14 | `action.primary`, `text.on-primary`, radius `button` |
| Nút phụ (chữ) | cao 34, padding ngang 12 | `text.brand` |
| Lựa chọn mood/weather | `Quick choices` 302×69, mỗi `Choice` **56×69** (icon 22 + label 13), dòng trạng thái 13 | `component.choice.icon-stroke`, `icon.brand`, `text.brand`, `text.secondary` |
| Card | radius **20** (`card`), padding 24, viền `border.default` | `surface.card`, `elevation.1` |
| Khung màn | gutter **36**, content **1208**, app bar 84, radius ngoài **16** (`page`) | `background.page`, `surface.card` |
| Ảnh thumbnail | 104×104, radius 12, nút ✕ 28×28 góc trên phải | `surface.card`, `border.default` |
| Dialog | 420 rộng, radius 20, padding 24 | `surface.card`, `elevation.drop-shadow-3` |

### 9 field trong cột trái (đúng như app)

| Icon | Label | Hint | Control |
| --- | --- | --- | --- |
| `book-open` | Nội dung nhật ký | — | textarea ~220 |
| `eye` | Góc nhìn khác | Nếu nhìn sự việc này từ góc khác thì sao? | 3 dòng |
| `mail` | Nhắn nhủ tương lai (hoặc một câu hỏi) | Bạn muốn nói gì với chính mình ngày mai? | 3 dòng |
| `spa` | Hôm nay bạn đã tự chăm sóc mình thế nào? | — | 3 dòng |
| `sunset` | Bạn hi vọng điều gì vào ngày mai? | — | 3 dòng |
| `heart` | Bày tỏ lòng biết ơn | Điều gì khiến bạn biết ơn hôm nay? | 3 dòng |
| `moon` | Giấc mơ đã trải qua | — | 3 dòng |
| `send` | Câu hỏi gửi gắm tương lai của bạn? | Ví dụ: Một năm nữa mình đã dám nói chưa? | 3 dòng |
| `brain` | Suy nghĩ về 2 câu hôm nay | Câu từ kho và câu của bạn gợi cho bạn điều gì? | 3 dòng |

Cột phải 300: card `Ngày đang ghi`, card `Thời tiết`, card `Cảm xúc` (mỗi card 5
`Choice` 56×69), card `Ảnh kèm theo`, card `Câu nói hôm nay` + ô phản tư.

### Cách dựng (khi bridge đã nối)

1. `save_version_checkpoint("trước JOURNAL-02")`.
2. `get_variable_defs` + `get_styles` để lấy id variable/text style hiện có.
3. `batch_execute_pipeline`: `create_node` (FRAME + auto layout) → `create_text`
   → `create_vector` (icon) → `manage_variable` bind token.
4. `set_selection` để xem lại; sau đó điền node id vào bảng trên.

