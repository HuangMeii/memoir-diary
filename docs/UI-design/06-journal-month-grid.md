# JOURNAL-01 — Lưới tháng

**Nền tảng:** MVP · Mobile + Web

## Bố cục

- Header tháng/năm với previous/next.
- Card “Cảm xúc”: lịch 7 cột.
- Card “Thời tiết”: lịch 7 cột.
- Legend có icon + nhãn + màu.
- Card summary: số ngày ghi, bước chân, phút tập, phân bố mood/weather.

## Hành vi

Tap một ngày → `JOURNAL-02`; chuyển tháng → loading grid, giữ tháng đang xem.
Ngày không có dữ liệu dùng màu trung tính và nhãn “Chưa ghi”.

## Responsive

Mobile hai grid xếp dọc; web có thể đặt cạnh nhau nếu chiều rộng đủ.

## Đã dựng — Web (`flutter_app`)

Bố cục bám frame `Lưới tháng · Web` (1280×1154, gutter 36, content 1208):

- **Chrome dùng chung** (`ui/widgets/app_header.dart`): một header 84 px gồm
  wordmark + ngày, nav `Trang chủ · Lưới tháng · Lịch sử kiện`, pill tiện ích và
  tài khoản. Nav chỉ hiện khi header đủ rộng (≥ 880 px bên trong gutter) và **tự
  cuộn thay vì tràn**; `Lịch sử kiện` render mờ vì chưa có màn.
- **Hero** (`ui/screens/month_grids_screen.dart`): breadcrumb `← Trang chủ`,
  overline `NHÌN LẠI TỪNG NGÀY`, tiêu đề `Lưới tháng · Tháng 10`, mô tả, control
  `Tuần | Tháng | Năm` (chỉ `Tháng` hoạt động), `Hôm nay` + `‹ ›` đổi tháng, và
  nhãn `Đang xem ngày 11.10`.
- **Ba thẻ đồng bộ 387×494** (`ui/month/month_card.dart`,
  `ui/month/month_heatmaps.dart`): `Nhật ký` (ô 26 có số, đậm dần theo
  `DiaryEntry.filledFields`), `Cảm xúc` và `Thời tiết` (ô 48×42 tô màu, không
  số) + legend (`Ít → Nhiều` cho Nhật ký, swatch + nhãn cho hai thẻ kia).
  Cả ba dùng chung một lưới (`ui/widgets/month_heatmap.dart`, widget này cũng
  thay lưới riêng của home): cột tuần bắt đầu **Chủ nhật**, hàng tuần CN→T7, dải
  tuần `1–3 · 4–10 …`, hôm nay tô/viền primary, ngày tới nhạt.
- **Ngày đang chọn** (`ui/month/day_details.dart`): ngày (Lora 29), giá trị đã
  lưu (emoji + nhãn primary), trạng thái nhật ký và CTA `Viết nhật ký hôm nay` →
  `JOURNAL-02`. Bấm một ô trong lưới là **chọn ngày**; nút mới mở editor.
- **Privacy footer**: `PrivacyNote` (`ui/widgets/app_footer.dart`), dùng chung
  với home.
- **Hệ số zoom riêng**: `homeScaleFor(width, designWidth: kMonthDesignWidth)`
  với `kMonthDesignWidth = 1280`; trần chữ vẫn 1.1 như home.

### Khác Figma (có chủ ý)

- Frame có cả `Utility navigation` 58 px **và** app bar 80 px; trong app hai thứ
  đó đã gộp thành một header 84 px (xem `04-home-dashboard.md`).
- Màu ô Cảm xúc/Thời tiết lấy từ `color_hex` của API thay vì hard-code token
  `heatmap.*`, để lưới luôn khớp dữ liệu người dùng đã lưu.
- Dải tuần chỉ in ở thẻ `Nhật ký`; hai thẻ còn lại để trống như frame.
- Icon chưa export nên dùng tạm Material: `arrow-left`, `chevron-left`,
  `chevron-right`, `lock-keyhole`.

### Còn thiếu so với Figma

- State Loading/Empty/Error của cả màn (hiện chỉ có loading/error cục bộ ở từng
  thẻ, và state Offline chưa dựng).
- Chế độ `Tuần`/`Năm` và màn `Lịch sử kiện`.
- Frame `Lưới tháng · Mobile` chưa dựng riêng: trên máy hẹp màn xếp dọc theo
  cùng thứ tự (hero → 3 thẻ → ngày đang chọn → footer), header không có nav.

