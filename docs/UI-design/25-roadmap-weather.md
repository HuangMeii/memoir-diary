# WEATHER-01 — Dự báo thời tiết

**Nền tảng:** ROADMAP

Thiết kế card dự báo hôm nay, nhiệt độ, dự báo nhiều ngày, vị trí và CTA dùng
dự báo để gợi ý weather khi viết nhật ký.

Cần có states loading, permission denied, API unavailable và stale cache.

## Đã dựng (`Thời tiết` trong header)

`weather_screen.dart` + `ui/weather/*`, đọc `/weather/current` qua
`weatherProvider`. Màn dựng theo bốn frame `Thời tiết · Tuần/Ngày/Theo giờ/Chọn
địa điểm · Web`:

- **Chrome** (`weather_chrome.dart`, `weather_period_controls.dart`): `AppHeader`
  (điều hướng Lưới tháng / Lịch sự kiện), breadcrumb `← Trang chủ / Tiện ích`,
  overline `BẦU TRỜI NHỮNG NGÀY TỚI`, tiêu đề theo view (`Thời tiết trong
  tuần/ngày/từng giờ`) + mô tả, khối **Location controls** (nút mở dialog và
  menu nhanh `Dùng vị trí hiện tại`), dải trạng thái nguồn (`Dữ liệu trực tiếp ·
  Open-Meteo`, hoặc `Dữ liệu cũ · cập nhật HH:mm` khi `source == cache`),
  **Period controls** (`SegmentedTabs` `Tuần | Ngày | Theo giờ` + dải ngày
  `11–17 tháng 10, 2026`), hàng chip chọn ngày (tab Ngày & Theo giờ) và dòng
  nguồn cuối trang.
- **Tuần** (`WeatherWeekTab`): bảng `Dự báo 7 ngày` (`Cao / thấp · °C`; mỗi
  hàng có thứ/ngày, icon, điều kiện, `mm` và `Xác suất %`) và chart `Lượng mưa
  trong tuần`; cột phụ `NGÀY ĐANG CHỌN` (4 chỉ số + `Xem ngày & từng giờ`) và
  `BẦU TRỜI & NHẬT KÝ`.
- **Ngày** (`WeatherDayTab`): `HÔM NAY` (nhiệt độ, điều kiện, 4 chỉ số),
  `Nhịp trời trong ngày` (6 thẻ giờ 06:00–21:00) và `Lượng mưa theo giờ`.
- **Theo giờ** (`WeatherHourTab`): `Mưa & nhiệt độ · 24 giờ` (bar mưa + line
  nhiệt độ, bấm để chọn giờ), bảng `Chi tiết 24 giờ` hai cột, cột phụ
  `GIỜ ĐANG CHỌN`.
- **Chọn địa điểm** (`46:9100`, `ui/weather/location_dialog.dart`): dialog
  `Chọn tỉnh / thành` — ô tìm, `Dùng vị trí hiện tại`, card quyền vị trí,
  danh sách `TỈNH / THÀNH GỢI Ý` (mục đang dùng có `Đang chọn` + dấu check) →
  `PUT /weather/location` → refresh.

## Dữ liệu minh họa

Backend chỉ trả `current` + 7 ngày `daily`, còn các frame thời tiết là mockup
(`Dữ liệu minh họa · Chưa kết nối API`), nên phần **theo giờ, lượng mưa, xác
suất, gió và độ ẩm** lấy từ `weather_illustrative.dart`: các hàm thuần, tất
định theo ngày (có unit test trong `test/weather_illustrative_test.dart`). Khi
dữ liệu giờ là minh họa, màn ghi rõ `Số liệu theo giờ và lượng mưa là minh họa`
ở dòng nguồn.

> Ngoài ra backend **đã** lấy mưa thật (`precipitation_sum` →
> `WeatherDay.precipitationMm`, có trong `weather_snapshots`) nhưng Flutter chưa
> map field đó, nên UI đang dùng số minh họa ở trên. Nối lại là việc riêng.

## Khác Figma (có chủ ý)

- Icon `map-pin`, `locate-fixed`, `info`, `x`, `check`, `waves`, `search`… chưa
  được export, nên dùng `Icons.*` của Material, đúng như các màn khác.
- Chevron kỳ trước/sau bị làm mờ: `/weather/current` chỉ trả cửa sổ 7 ngày bắt
  đầu từ hôm nay, chưa có kỳ khác để chuyển tới.
- Định vị tự động chưa nối (app không có plugin geolocation), nên `Tiếp tục`
  trong card quyền nói rõ chưa xác định được vị trí thay vì giả vờ.
- **Bỏ card `Dự kiến ngập`** (và class `FloodEstimateCard`): không có nguồn nào
  cho ngập đường phố/đô thị. Open-Meteo có **Flood API** nhưng chỉ trả
  `river_discharge` (GloFAS v4, ~5 km — lưu lượng **sông**), không phải ngập
  đường phố, và không có ngưỡng/return period để phân mức `Thấp / Vừa / Cao`.
  Card cũ chỉ là callout tĩnh nên đã gỡ; cột phụ còn preview ngày/giờ +
  `BẦU TRỜI & NHẬT KÝ`.
- **Bỏ `Rain value` trên đỉnh cột** của các chart mưa: giá trị trùng với nhãn
  trục dọc và với tổng ở tiêu đề, mà với cột cao thì nhãn nằm ngay trên đỉnh
  cột. `RainChart` giờ chỉ vẽ trục + cột + nhãn chân cột (`_topPad` 18 → 8).

