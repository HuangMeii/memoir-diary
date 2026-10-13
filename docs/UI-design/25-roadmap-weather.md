# WEATHER-01 — Dự báo thời tiết

**Nền tảng:** ROADMAP

Thiết kế card dự báo hôm nay, nhiệt độ, dự báo nhiều ngày, vị trí và CTA dùng
dự báo để gợi ý weather khi viết nhật ký.

Cần có states loading, permission denied, API unavailable và stale cache.

## Đã dựng (tiện ích `Thời tiết` trong header)

`weather_screen.dart` + `weather_card.dart`, đọc `/weather/current` qua
`weatherProvider`. Màn có **3 tab** theo `Thời tiết · Tuần/Ngày/Theo giờ · Web`:

- **Tuần**: card `Hôm nay` (icon Figma `sun`/`cloud`/`cloud-rain`/`storm`/
  `wind`/`weather` map theo điều kiện qua `weatherIconFor`, nhiệt độ, điều
  kiện, tên vị trí, chip `Dữ liệu cũ · cập nhật HH:mm` khi nguồn `cache`),
  bảng tuần (7 hàng: icon + thứ + điều kiện + min/max) và strip 7 ô ngày.
- **Ngày**: hàng chip chọn ngày + card chi tiết ngày (icon 40, thứ · ngày/tháng,
  điều kiện, min/max).
- **Theo giờ**: khung báo "chưa kết nối" (backend chưa có dữ liệu theo giờ;
  khi có sẽ hiện timeline 06:00–23:00 như design).
- **Chọn địa điểm** (`46:9100`): dialog tìm theo tỉnh/thành gợi ý →
  `PUT /weather/location` → refresh. Còn lại: state loading/error + nút tải
  lại + ghi chú nguồn `Open-Meteo · Vị trí`.

