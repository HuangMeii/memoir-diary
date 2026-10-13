# JOURNAL-02 — Soạn nhật ký theo ngày

**Nền tảng:** MVP · Mobile + Web

## Sections

1. Ngày đang ghi và trạng thái lưu.
2. Chọn thời tiết.
3. Chọn cảm xúc.
4. Nội dung nhật ký nhiều dòng.
5. Ảnh đính kèm.
6. Góc nhìn khác.
7. Tự chăm sóc hôm nay.
8. Hi vọng ngày mai.
9. Lòng biết ơn.
10. Giấc mơ.
11. Phản tư về câu nói.

## Hành vi

- Tạo mới hoặc sửa entry theo ngày, một entry/ngày.
- **Tự động lưu**: sau ~4 giây ngừng gõ (debounce), toàn bộ trang (mọi ô nhập,
  cảm xúc, thời tiết) được đẩy lên server — không cần nút `Lưu nhật ký`. Chạm
  chọn cảm xúc/thời tiết lưu ngay, đúng “Tự động lưu” của Home.
- Reflection và câu gửi gắm tương lai được lưu **theo id** bản ghi đã tạo, nên
  tự lưu nhiều lần không nhân bản dữ liệu.
- Rời màn hình: lưu nốt những gì đang chờ (flush) rồi thoát; nếu lưu thất bại ở
  lại với banner lỗi để không mất chữ.
- Thêm ảnh trước khi entry tồn tại vẫn hiện hướng dẫn lưu entry trước.

## States

New, Existing, Saving, Saved, Validation error, Server error.

## Thiết kế Figma — `JOURNAL-02 · …`

**Trạng thái: đã dựng trên Figma** (`Page 1`, block nằm bên phải cột thời tiết —
web tại `x=9700…16700, y=1804`, mobile tại `x=11100, y=3700`). Bản dựng giữ đúng
token/style của các frame có sẵn: app bar hợp nhất 84 px, `surface.card` /
`background.page` / `border.default`, Lora 36 cho tiêu đề, Inter 13/11 cho nhãn,
ô nhập cao 52/86/220 radius 10, `Choice` 48×69, card radius 20 padding 20.

| Frame | Node id |
| --- | --- |
| `JOURNAL-02 · Web · Ngày chưa ghi` | `97:3` |
| `JOURNAL-02 · Web · Đã có nhật ký` | `99:118` |
| `JOURNAL-02 · Web · Đang lưu` | `99:460` |
| `JOURNAL-02 · Web · Đã lưu` | `99:574` |
| `JOURNAL-02 · Web · Lỗi lưu` | `99:688` |
| `JOURNAL-02 · Web · Rời màn khi chưa lưu` | `99:232` (overlay `99:802`, dialog `99:803`) |
| `JOURNAL-02 · Mobile · Ngày chưa ghi` | `99:346` (390 rộng, nav ẩn, cột dọc) |

Mốc version trước khi dựng: `trước JOURNAL-02` (id `2409390243730878959`).

### Đã dựng trong app

`flutter_app/lib/src/ui/screens/entry_editor.dart` đã được dựng lại theo các
frame trên:

- **Tự động lưu thay cho nút lưu** (lệch thiết kế có chủ đích — xem “Đã dừng
  theo thiết kế” bên dưới).
- `PopScope` chặn back; khi rời trang, phần đang chờ lưu được **flush** trước
  khi pop — không còn dialog `Rời màn khi chưa lưu?` (frame `99:232`).
- Save-bar sticky trên cùng chỉ còn trạng thái: `Đang lưu... / Sẽ tự động
  lưu... / Đã lưu lúc HH:mm / Nhật ký tự động lưu sau vài giây.` — không còn
  `Huỷ` và nút `Lưu nhật ký` (frame `99:460`).
- Banner lỗi `Chưa lưu được: ...` + `Thử lại` — `99:688`. Không còn banner
  `Đã lưu nhật ký` + `Xem lưới tháng` (`99:574`) vì đã tự lưu.
- Breadcrumb `← Lưới tháng`, overline `TRANG NHẬT KÝ · dd.MM`, tiêu đề
  `Thứ, dd.MM` — `97:3`.
- 2 cột: trái 700 (9 field đúng thứ tự Figma + block `2 câu hôm nay` trước ô
  phản tư), phải 300 (card `Ngày đang ghi`, cặp `Thời tiết hôm nay` / `Cảm xúc
  hôm nay` — cùng `WeatherMoodRow` + `PickerCard` của Home, chạm là lưu ngay —
  và card `Ảnh kèm theo` với `+ Thêm ảnh`) — `99:152` / `99:189`.
- `_Field` theo spec: label 13 có icon 18, input radius 10, viền `border.default`,
  nền `surface.input`, nhật ký chính ~10 dòng.
- Responsive: dưới ngưỡng 2 cột (main + gap + side + 32, đã scale) chuyển 1 cột
  với `AppHeader(showUtilities: false)`.

### Đã dừng theo thiết kế (bỏ nút lưu)

Theo yêu cầu sản phẩm, JOURNAL-02 không còn nút `Lưu nhật ký`: mọi ô nhập tự lưu
sau ~4 giây ngừng gõ, chọn cảm xúc/thời tiết lưu ngay và rời trang thì flush. So
với Figma (`99:460` nút lưu, `99:574` banner đã lưu, `99:232` dialog rời màn),
đây là lệch thiết kế có chủ đích.

### Còn lại của bản "gọn" (chi tiết sau)

- **Chưa dựng**: state ảnh `JOURNAL-03` (thumbnail 104, upload progress, lỗi
  upload, dialog xoá ảnh) và frame `JOURNAL-02 · Mobile · Đã có nhật ký`.
- Thanh trạng thái lưu ở trên (mobile); không còn nút `Lưu nhật ký` nên không
  còn chuyện sticky đáy.
- Ô nhập trong các field phụ đang cao 86 (1 dòng hint ở trên); bản đầy đủ nên là
  3 dòng (~120) và có icon 18 bên trái nhãn (icon chưa có SVG nên chưa vẽ).
- Card cột phải rộng 300 trong cột 358 trên mobile; nên cho card dãn theo cột.
- Dialog chưa có nút dạng khối (hiện là nhãn chữ) và chưa có elevation.

### Ghi chú kỹ thuật khi dựng bằng MCP

- `batch_execute_pipeline` hỏng với plugin build này (`'commitUndo' is read-only`)
  → phải gọi từng lệnh.
- `create_node` FRAME từ chối `cornerRadius`; mọi tham số layout
  (`HUG`/`FILL`/`layoutGrow`) bị bỏ qua lúc tạo → phải `set_auto_layout` sau.
- `clone_node` **không giữ parent** (node nhảy ra page) → luôn truyền `parentId`
  hoặc gọi `reparent_nodes` sau khi clone.
- Ảnh QA xuất bằng `export_screenshots` ra thư mục làm việc của plugin
  (`G:\MyApp\Microsoft VS Code\Microsoft VS Code\`) vì `outputPath` phải nằm
  trong đó.


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

