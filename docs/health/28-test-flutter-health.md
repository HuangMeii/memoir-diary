# H5-S1 · `test/health_test.dart`

**Epic:** H5 · **Ước lượng:** 3 pts · **Phụ thuộc:** H2-S6
**Mẫu:** `flutter_app/test/widget_test.dart`, `flutter_app/test/text_prompt_dialog_test.dart`

## Mục tiêu

Khoá hành vi của các **hàm thuần** trong `ui/health/health_metrics.dart` (BMI, phân buổi,
tổng hợp nước, tổng hợp xu hướng, định dạng) và một widget test cho thẻ tóm tắt — không
cần backend, chạy nhanh trong `flutter test`.

## Phạm vi

- **Tạo mới:** `flutter_app/test/health_test.dart`.
- **KHÔNG sửa:** các test có sẵn (`widget_test.dart`, `calendar_views_test.dart`,
  `route_*_test.dart`, `weather_illustrative_test.dart`, `text_prompt_dialog_test.dart`).

## Việc cần làm

- [ ] `group('bmi')`:
  - `bmiOf(weightKg: 58.2, heightCm: 165) == 21.4` (sai số 0.05);
  - thiếu cân nặng hoặc chiều cao ⇒ `null`; `heightCm: 0` ⇒ `null`;
  - `bmiZoneOf`: `18.4 → underweight`, `18.5 → normal`, `22.9 → normal`, `23 → overweight`,
    `24.9 → overweight`, `25 → obese` (kiểm tra các **ranh giới**, không chỉ điểm giữa).
- [ ] `group('water periods')`:
  - `periodOf` với mốc `11:59Z → morning`, `12:00Z → afternoon`, `17:59Z → evening`? (**lưu ý**
    giờ VN = UTC+7 ⇒ test theo thời điểm UTC, ví dụ `05:00Z = 12:00 VN → afternoon`);
  - `waterBreakdownOf([])` ⇒ `totalMl == 0`, `count == 0`, `lastAt == null`;
  - 3 lần uống `250/500/1000` ⇒ `totalMl == 1750`, `count == 3`, `peakPeriod == evening`,
    `lastAt` là thời điểm muộn nhất.
- [ ] `group('trend summary')`:
  - 30 điểm, 24 điểm `>= 8000`, 4 điểm `null` ⇒ `daysWithData == 26`,
    `daysOnTarget == 24`, `completionRatio == 0.8`, `peakValue`/`peakDate` đúng;
  - ngày `7000` (giữa 70–99%) được đếm vào `daysPartial`, **không** vào `daysOnTarget`;
  - danh sách rỗng ⇒ không chia cho 0, `average == 0`, `peakValue == null`;
  - `metric: HealthMetric.weight`, `profile == null` ⇒ `goal` là `0`/`weightGoalKg` theo chốt ở H2-S6.
- [ ] `group('formatting')`: `formatSleepDuration(7.5) == '7h 30m'`,
  `formatSleepDuration(null) == '0m'`, `formatMl(1750) == '1.750 ml'`,
  `formatWeight(58.2) == '58.2 kg'`, `formatMinutes(45) == '45 phút'`,
  `formatClock(<UTC 07:30>) == '14:30'` (giờ VN).
- [ ] `testWidgets('HealthSummaryCards shows water breakdown')`:
  dựng `HealthSummaryCards(day: <HealthDayOverview mẫu>, profile: <HealthProfile mẫu>)`
  trong `MaterialApp(theme: buildTheme(Brightness.light))`; khẳng định có chuỗi `1.750`,
  `2.000 ml`, `Sáng`, `Chiều`, `Tối`, `7h 30m`; đổi sang ngày trống ⇒ có `--`.
- [ ] Dữ liệu mẫu dựng bằng factory **trong chính file test** (không thêm vào `models.dart`).
- [ ] `flutter test test/health_test.dart` ⇒ xanh; `flutter test` ⇒ không hồi quy.

## Acceptance Criteria

1. *Given* bộ test mới, *when* chạy `flutter test test/health_test.dart`, *then* xanh,
   **không** cần network, chạy < 10s.
2. *Given* các mốc ranh giới BMI (18.5 / 23 / 25), *then* phân loại đúng (không lệch một
   khoảng do dùng `<=`).
3. *Given* mốc giờ `05:00Z`, *then* được tính là buổi **Chiều** (giờ VN 12:00).
4. *Given* `TrendSummary` của kỳ chỉ có điểm `null`, *then* không có `NaN`/`Infinity` trong
   bất kỳ trường số nào.
5. *Given* `flutter test` toàn bộ app, *then* các test cũ vẫn xanh.
6. *Then* `flutter analyze` sạch.

## Kiểm chứng

```powershell
cd flutter_app
flutter analyze
flutter test test\health_test.dart
flutter test
```

## Rủi ro / ghi chú

- Chỉ test hàm thuần + **một** widget: phần gọi API để cho integration test phía server
  (H1-S7); đừng dựng mock `BackendDataSource` phức tạp.
- Test theo **giờ VN** dễ lệch máy: luôn truyền thời điểm cụ thể, không dùng
  `DateTime.now()` trong test.
- Nếu `HealthProfile` có default trong `fromJson`, test riêng nhóm đó ở đây (không cần dựng
  widget) để bắt lỗi thiếu khoá sớm.
