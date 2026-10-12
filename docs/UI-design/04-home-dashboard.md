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

- **Utility navigation** (58 px, `ui/home/utility_navigation.dart`): nhãn
  “Tiện ích” + pill “Xem thời tiết”, chỉ hiện khi content ≥ 1024 px.
- **Home header** (80 px, `ui/home/home_header.dart`): brand mark (SVG đã có sẵn
  màu, **không** tint `srcIn`), tên + ngày, avatar chữ cái, tên hiển thị,
  Đăng xuất.
- **Dashboard 2 cột** (`ui/home/dashboard_columns.dart`): cột chính 700 px
  (picker thời tiết + cảm xúc → thanh “đã lưu” → câu nói → nhịp viết), cột phụ
  300 px (trang nhật ký + 5 shortcut), gap 24 px; dưới 1024 px thì xếp dọc.
- **Thanh đã lưu** (`ui/home/saved_bar.dart`): render inline ngay dưới picker
  (SnackBar của Material luôn neo đáy màn hình nên không dùng được).
- **Câu nói hôm nay** (`ui/home/daily_quote_card.dart`): 3 state — có câu,
  chưa có câu, lỗi (nút “Thử lại”).
- **Nhịp viết của bạn** (`ui/home/month_activity_card.dart` +
  `ui/home/activity_heatmap.dart`): lưới tháng kiểu contribution, cột = tuần
  (Chủ nhật đầu tuần), hàng = thứ; độ đậm = số mục đã điền
  (`DiaryEntry.filledFields` / 9), ô hôm nay viền, ngày tương lai nhạt.
  Dữ liệu lấy từ `GET /entries?month=` (không cần đổi backend).
- **Hai ô nhập đã chuyển sang `JOURNAL-02`** (`entry_editor.dart`): “Câu hỏi
  gửi gắm tương lai” (lưu thành self message) và “Suy nghĩ về 2 câu hôm nay”.
- **Zoom theo bề rộng cửa sổ** (`ui/home/home_scale.dart`): hệ số
  `viewportWidth / 1120` kẹp trong `[1, 1.5]`, truyền qua `HomeScale` và nhân
  vào `MediaQuery.textScaler` nên chữ và khối cùng lớn lên; dưới 1120 px giữ
  1:1 cho mobile, `HomeScale.of` không có ancestor cũng trả 1. Ô heatmap dùng
  gap 6 px nên lưới đúng frame `176×223`.

### Còn thiếu so với Figma

- Ảnh botanical cạnh câu nói: chưa có SVG trong `assets/illustrations`.
- Icon đang dùng tạm Material: `check`, `refresh-cw`, `x`, `book-open`,
  `calendar-days`, `sticky-note`, `list-checks`, `heart-pulse`.
- Thanh “Nhịp viết” đang khoá ở chế độ `Tháng`; `Tuần`/`Năm` hiển thị mờ.
- State Offline chưa dựng.
- App bar web hiện là Memoir + ngày (chưa có nav Trang chủ/Lưới tháng/Lịch sử).


