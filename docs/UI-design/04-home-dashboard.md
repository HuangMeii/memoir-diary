# HOME-01 — Tổng quan hôm nay

**Nền tảng:** MVP · Mobile + Web

## Bố cục

1. AppBar: Memoir, ngày hiện tại, profile/logout.
2. Lời chào và ngày.
3. Card chọn nhanh thời tiết và cảm xúc.
4. Card câu nói hôm nay.
5. CTA “Viết nhật ký hôm nay”.
6. Grid shortcut: Lưới tháng, Ghi chú, Kế hoạch, Sức khỏe, Lịch sử câu nói.

## Hành vi

- Chọn mood/weather lưu ngay và hiển thị snackbar.
- Pull-to-refresh trên mobile; nút refresh trên web.
- CTA mở `JOURNAL-02`.

## States

Loading skeleton, ngày chưa ghi, đã có mood/weather, quote lỗi, offline.

## Responsive

Mobile một cột; web chia content thành cột chính và cột phụ, shortcut dùng
grid 2×N.

## Đã dựng — Web (`flutter_app`)

Bố cục bám theo frame Figma `HOME-01 · Web · Đã có mood-weather`:

- **App header** (84 px, `ui/widgets/app_header.dart`): brand mark (SVG đã có sẵn
  màu, **không** tint `srcIn`), tên + ngày, nav `Trang chủ · Lưới tháng ·
  Lịch sử kiện` (thêm theo frame `Lưới tháng · Web`; chỉ hiện khi header đủ rộng,
  mỗi mục mở màn của nó), pill tiện ích, avatar chữ cái, tên hiển thị, Đăng xuất —
  **tất cả trên một hàng**.
- **Tiện ích nằm trong header** (`ui/home/utility_pill.dart`): pill “Xem thời
  tiết” ngay trước phần tài khoản, hiện khi content ≥ 1024 px; bề rộng hẹp hơn
  thì bỏ tên hiển thị trước (≥ 1040 px mới có), rồi tới pill. Mobile vẫn để
  tiện ích ở cuối trang qua `UtilitiesSection` (`ui/widgets/app_footer.dart`),
  đúng một nơi hiển thị.
- **Dashboard 2 cột** (`ui/home/dashboard_columns.dart`): cột chính 700 px
  (picker thời tiết + cảm xúc → thanh “đã lưu” → câu nói → nhịp viết), cột phụ
  300 px (trang nhật ký + 5 shortcut), gap 24 px; dưới 1024 px thì xếp dọc.
- **Thanh đã lưu** (`ui/home/saved_bar.dart`): render inline ngay dưới picker
  (SnackBar của Material luôn neo đáy màn hình nên không dùng được).
- **Câu nói hôm nay** (`ui/home/daily_quote_card.dart`): 3 state — có câu,
  chưa có câu, lỗi (nút “Thử lại”).
- **Nhịp viết của bạn** (`ui/home/month_activity_card.dart` +
  `ui/home/activity_heatmap.dart` trên lưới dùng chung
  `ui/widgets/month_heatmap.dart`): lưới tháng kiểu contribution, cột = tuần
  (Chủ nhật đầu tuần), hàng = thứ; độ đậm = số mục đã điền
  (`DiaryEntry.filledFields` / 9), ô hôm nay viền, ngày tương lai nhạt.
  Dữ liệu lấy từ `GET /entries?month=` (không cần đổi backend).
- **Hai ô nhập đã chuyển sang `JOURNAL-02`** (`entry_editor.dart`): “Câu hỏi
  gửi gắm tương lai” (lưu thành self message) và “Suy nghĩ về 2 câu hôm nay”.
- **Zoom theo bề rộng cửa sổ** (`ui/home/home_scale.dart`): hai hệ số.
  `HomeScale.factor` = `viewportWidth / 1120` kẹp trong `[1, 1.5]` để khối và
  khoảng cách phủ kín cửa sổ; `HomeScale.textFactor` = cùng công thức nhưng kẹp
  trần **1.1**, truyền vào `MediaQuery.textScaler` (chữ) và dùng cho mọi thứ
  trong header. Nhờ vậy màn 1536 px có khối 1.371× nhưng body chỉ 14.3 px thay
  vì 17.8 px, và header vẫn 84 px. Dưới 1120 px cả hai giữ 1:1 cho mobile;
  `HomeScale.of` / `HomeScale.textOf` không có ancestor cũng trả 1. Ô heatmap
  dùng gap 6 px nên lưới đúng frame `176×223`.

### Còn thiếu so với Figma

- Ảnh botanical cạnh câu nói: chưa có SVG trong `assets/illustrations`.
- Icon đang dùng tạm Material: `check`, `refresh-cw`, `x`, `book-open`,
  `calendar-days`, `sticky-note`, `list-checks`, `heart-pulse`.
- Thanh “Nhịp viết” đang khoá ở chế độ `Tháng`; `Tuần`/`Năm` hiển thị mờ.
- State Offline chưa dựng.
- Nav `Trang chủ / Lưới tháng / Lịch sử kiện` đã có trong header; cả ba mục đều
  dựng (`Lịch sử kiện` = màn Lịch, xem `27-event-calendar.md`).

### Khác Figma (có chủ ý)

- Gộp `Utility navigation` (58 px) vào header thành **một thanh 84 px** thay vì
  hai thanh 58 + 80 px: ở màn 1536 px tiết kiệm được 101 px chiều cao, và đúng
  hướng các frame khác vốn đặt nav trong app bar.
- Bỏ nhãn “Tiện ích” (trong header nó chỉ còn là tiêu đề thừa; pill đã ghi rõ
  tên tiện ích).
- Chữ chỉ zoom tới 1.1× trong khi khối zoom tới 1.5× — cố ý, xem mục Zoom ở trên.


