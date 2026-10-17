# H1-S4 · DTO ngày + điểm xu hướng

**Epic:** H1 · **Ước lượng:** 2 pts · **Phụ thuộc:** H1-S1, H1-S2, H1-S3
**Nguồn thiết kế:** `ui-figma/suckhoe/memoir_s_c_kho_th_ch_t_t_i_gi_n/code.html`
— một màn hình cần **log ngày + danh sách lần uống + mốc hoạt động + thông số/mục
tiêu** trong một lần gọi (form 249–316 và timeline 453–505 cùng lúc)

## Mục tiêu

Gói dữ liệu của **một ngày** và của **một chuỗi xu hướng** thành hai class không có
bảng, để client chỉ gọi một endpoint cho mỗi khối giao diện thay vì ghép nhiều lời gọi.

## Phạm vi

- **Tạo mới:** `memoir_server/memoir_server_server/lib/src/health/health_day_overview.spy.yaml`,
  `memoir_server/memoir_server_server/lib/src/health/health_trend_point.spy.yaml`.
- **KHÔNG sửa:** các model có bảng (`health_log`, `health_water_entry`,
  `health_activity`, `health_profile`), `lib/src/generated/**`.

## Việc cần làm

- [ ] `health_day_overview.spy.yaml`:

```yaml
### Everything the dashboard needs for one day, in a single round trip.
class: HealthDayOverview
fields:
  date: DateTime
  ### Null when nothing has been logged for the day yet.
  log: HealthLog?
  water: List<HealthWaterEntry>
  activities: List<HealthActivity>
  ### Null until the user saves body metrics or goals.
  profile: HealthProfile?
```

- [ ] `health_trend_point.spy.yaml`:

```yaml
### One day of a trend series for the selected metric.
class: HealthTrendPoint
fields:
  date: DateTime
  ### Null when the day has no data for the metric (keeps the axis honest).
  value: double?
  ### Goal in force for that day, so the chart can draw the target line.
  goal: double?
```

- [ ] Chạy `serverpod generate`; xác nhận hai class **không** tạo bảng
  (`definition.sql` không có `health_day_overviews` / `health_trend_points`).
- [ ] `dart analyze`.

## Acceptance Criteria

1. *Given* hai `.spy.yaml` không có `table:`, *when* `serverpod generate`, *then*
   sinh hai class Dart thuần (không bảng, không migration mới).
2. *Given* một ngày chưa có gì, *when* endpoint trả `HealthDayOverview`, *then*
   `log == null`, `water == []`, `activities == []`, `profile == null` (client tự
   hiện trạng thái trống, không cần giá trị mẫu).
3. *Given* một ngày có dữ liệu, *then* `overview.log.logDate == overview.date` và
   mọi `water[i].logDate`/`activities[i].logDate` bằng đúng ngày đó.
4. *Given* chuỗi xu hướng 30 ngày, *then* có đủ **30** `HealthTrendPoint` (ngày không
   có dữ liệu mang `value == null`) — trục thời gian không bị co lại.
5. *Then* `memoir_server_client` export hai class; `dart analyze` sạch.

## Kiểm chứng

```powershell
cd memoir_server\memoir_server_server
serverpod generate
dart analyze
Select-String -Path 'lib\src\generated\health\health_day_overview.dart','lib\src\generated\health\health_trend_point.dart' -Pattern 'class Health'
Select-String -Path 'migrations\*\definition.sql' -Pattern 'health_day_overviews|health_trend_points'   # phải KHÔNG có kết quả
```

## Rủi ro / ghi chú

- `HealthLog` là class **có bảng** được nhúng vào DTO — giống cách
  `NoteDetail`/`JourneyDetail` đang làm (`note_detail.spy.yaml`), không cần bảng trung gian.
- `goal` nằm trong điểm xu hướng để chart vẽ đúng đường mốc cho từng metric (bước
  8.000, phút 60, nước 2.000, ngủ 8) mà không phải truyền thêm tham số riêng.
- Nếu H1-S5 cần thêm cờ tổng hợp (ví dụ `waterCount`, `waterLastAt`), ưu tiên **tính
  ở client** từ `water[]` (H2-S6) để DTO không phình — chỉ thêm field khi client
  không thể suy ra.
