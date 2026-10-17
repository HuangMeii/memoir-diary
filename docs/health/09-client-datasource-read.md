# H2-S1 · Map đọc trong `ServerpodDataSource`

**Epic:** H2 · **Ước lượng:** 3 pts · **Phụ thuộc:** H1-S6
**File:** `flutter_app/lib/src/data/datasources/serverpod_data_source.dart`

## Mục tiêu

Đưa dữ liệu mới của domain health ra dạng JSON snake_case mà repository Dart đọc được:
mở rộng `_healthMap` (H1-S1), thêm map cho lần uống / mốc hoạt động / thông số cơ thể /
nội dung ngày / điểm xu hướng, và thêm ba nhánh `get`.

## Phạm vi

- **Sửa:** `_healthMap` (dòng 728–737) + thêm map mới + nhánh `get(...)`.
- **KHÔNG sửa:** `backend_data_source.dart` (interface giữ nguyên), các nhánh domain khác.

## Việc cần làm

- [ ] Mở rộng `_healthMap(sp.HealthLog h)` thêm: `workout_type`, `workout_intensity`,
      `sleep_bedtime`, `sleep_wake`, `sleep_deep_minutes`, `sleep_quality`,
      `sleep_note` (giữ đủ 8 khoá cũ).
- [ ] Thêm `_waterEntryMap(sp.HealthWaterEntry e)` →
      `{id, log_date, amount_ml, recorded_at, note}` (ngày/thời điểm qua `_dateOnly`
      và helper ISO sẵn có).
- [ ] Thêm `_activityMap(sp.HealthActivity a)` → `{id, log_date, at_time, title, detail, kind}`.
- [ ] Thêm `_profileMap(sp.HealthProfile p)` → `{height_cm, weight_goal_kg,
      weight_start_kg, steps_goal, workout_goal_minutes, water_goal_ml, sleep_goal_hours}`.
- [ ] Thêm `_dayOverviewMap(sp.HealthDayOverview o)` →
      `{date, log: …, water: [...], activities: [...], profile: …}` (dùng các map trên;
      `log`/`profile` null thì để `null`).
- [ ] Thêm `_trendPointMap(sp.HealthTrendPoint t)` → `{date, value, goal}`.
- [ ] Thêm nhánh trong `get(...)` (đặt cạnh `case '/health-logs'`):
      - `case '/health/day'` → `_client.health.dayOverview(_parseDate(query!['date'])!)`;
      - `case '/health/trends'` → `_client.health.trends(from: …, to: …, metric: query!['metric']!)`;
      - `case '/health/profile'` → `_client.health.profileGet()`
        (trả `null` nếu chưa lưu).
- [ ] `InjectCache`/`_request` wrapper: dùng cùng cách các nhánh đang làm (bọc
      `_request(() => …)` nếu nhánh đó có thể ném lỗi mạng).
- [ ] `flutter analyze`.

## Acceptance Criteria

1. *Given* `GET /health-logs`, *then* mỗi phần tử map có thêm 7 khoá mới và **không**
   mất khoá cũ ⇒ `HealthLog.fromJson` cũ vẫn chạy.
2. *Given* `GET /health/day?date=2026-10-17`, *then* trả map có `date`, `log`,
   `water`, `activities`, `profile`; ngày trống ⇒ `log == null` và hai danh sách rỗng.
3. *Given* `GET /health/trends?from=…&to=…&metric=steps`, *then* trả danh sách map
   `{date, value, goal}` đủ số ngày; `value` null cho ngày trống.
4. *Given* `GET /health/profile` khi chưa lưu, *then* trả `null` (không ném lỗi).
5. *Then* `flutter analyze` sạch.

## Kiểm chứng

```powershell
cd flutter_app
flutter analyze
Select-String -Path 'lib\src\data\datasources\serverpod_data_source.dart' -Pattern "_waterEntryMap|_activityMap|_profileMap|_dayOverviewMap|_trendPointMap|'/health/day'|'/health/trends'|'/health/profile'"
```

## Rủi ro / ghi chú

- **Thứ tự nhánh**: các nhánh `/health/…` là so khớp **chuỗi chính xác** trong
  `switch`, nên không đè `/health-logs`; nếu chuyển sang `startsWith` thì phải đặt
  `/health-logs` trước `/health/day`.
- Ngày phải đi qua `_parseDate` (đã có) để `DateTime` luôn là UTC nửa đêm, khớp
  `dateOnly` phía server.
- `_dateOnly` phía client đang là helper dùng chung — tái sử dụng, đừng viết bản
  `substring(0, 10)` mới rải rác (bản cũ trong `health_screen.dart` sẽ bị gỡ ở H3-S8).
