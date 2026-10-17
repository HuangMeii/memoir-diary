# H2-S6 · Hàm thuần `health_metrics.dart`

**Epic:** H2 · **Ước lượng:** 3 pts · **Phụ thuộc:** —
**File mới:** `flutter_app/lib/src/ui/health/health_metrics.dart`

## Mục tiêu

Gom mọi phép tính/định dạng của mục Sức khoẻ vào **một file hàm thuần** (không
`BuildContext`, không network) để widget chỉ việc vẽ, và test ở H5-S1 không cần backend:
BMI, phân loại BMI, phân buổi uống, tổng hợp nước, tổng hợp chuỗi xu hướng, định dạng
số/thời lượng.

## Phạm vi

- **Tạo mới:** `flutter_app/lib/src/ui/health/health_metrics.dart`.
- **KHÔNG sửa:** `data/models.dart` (không đưa logic vào model), `ui/utilities.dart`
  (file dùng chung — chỉ *dùng*, không sửa).

## Việc cần làm

- [ ] `enum HealthMetric { steps, workout, water, sleep, weight }` kèm
      `wireName` (`'steps' | 'workout' | 'water' | 'sleep' | 'weight'`), `label`
      (“Bước chân”, “Luyện tập”, “Nước”, “Giấc ngủ”, “Cân nặng”) và `unit`.
- [ ] `enum WaterPeriod { morning, afternoon, evening }` + `label` (“Sáng”, “Chiều”, “Tối”).
- [ ] `enum BmiZone { underweight, normal, overweight, obese }` + `label`
      (“Gầy”, “Chuẩn”, “Thừa cân”, “Béo phì”).
- [ ] `double? bmiOf({double? weightKg, int? heightCm})` — `null` nếu thiếu một trong
      hai hoặc `heightCm <= 0`; làm tròn **1 số thập phân**.
- [ ] `BmiZone? bmiZoneOf(double? bmi)` — ngưỡng IDI & WPRO: `<18.5` gầy,
      `18.5–22.9` chuẩn, `23–24.9` thừa cân, `>=25` béo phì (dùng `< 23`,
      `< 25`, `>= 25` để không hở khe giữa các khoảng).
- [ ] `WaterPeriod periodOf(DateTime recordedAt)` — theo **giờ VN (UTC+7)**:
      `<12h` Sáng, `12–17h` Chiều, `>=18h` Tối. Nhận `DateTime` UTC và tự `+7`.
- [ ] `class WaterBreakdown { Map<WaterPeriod, int> mlByPeriod; int totalMl; int count;
      DateTime? lastAt; WaterPeriod? peakPeriod; }` +
      `WaterBreakdown waterBreakdownOf(List<HealthWaterEntry> entries)`.
- [ ] `class TrendSummary { double total; double average; int daysWithData;
      int daysOnTarget; int daysPartial; double? peakValue; DateTime? peakDate;
      double goal; double completionRatio; }` +
      `TrendSummary summarizeTrend({required List<HealthTrendPoint> points,
      required HealthMetric metric, HealthProfile? profile})` — bỏ qua điểm `value == null`
      khi tính TB; đếm “ngày đạt chuẩn” theo `value >= goal` (mốc 100%) và “gần đạt”
      theo `>= 0.7 * goal`; `completionRatio` = `daysOnTarget / số ngày của kỳ`.
- [ ] `double goalFor(HealthMetric metric, HealthProfile? profile)` — default lấy từ
      `HealthProfile` khi `profile == null`: 8000 / 60 / 2000 / 8; `weight` không có
      mục tiêu ngày ⇒ dùng `weightGoalKg` hoặc `0` (chart vẽ không có đường mốc).
- [ ] `String formatSleepDuration(double? hours)` → `7h 30m` (làm tròn phút, `0m` khi null).
- [ ] `String formatMinutes(int? minutes)` → `45 phút`; `String formatMl(int? ml)` →
      `1.750 ml` (dấu `.` ngăn nghìn); `String formatWeight(double? kg)` → `58.2 kg`.
- [ ] `String formatClock(DateTime utc)` → `HH:mm` theo giờ VN (cho “Gần nhất 14:30”).
- [ ] `flutter analyze`.

## Acceptance Criteria

1. *Given* `weightKg: 58.2`, `heightCm: 165`, *then* `bmiOf` trả `21.4` và `bmiZoneOf`
   trả `BmiZone.normal`.
2. *Given* `heightCm: null`, *then* `bmiOf` trả `null` và `bmiZoneOf(null)` trả `null`
   (UI hiện “chưa đủ dữ liệu”, không hiện `NaN`).
3. *Given* nước uống lúc `05:00Z` (= 12:00 giờ VN), *then* `periodOf` trả
   `WaterPeriod.afternoon` (ranh giới rơi về buổi Chiều).
4. *Given* 3 lần uống `250/500/1000 ml` (Sáng/Chiều/Tối), *then* `waterBreakdownOf` trả
   `totalMl == 1750`, `count == 3`, `peakPeriod == evening`, `lastAt` là lần muộn nhất.
5. *Given* kỳ 30 ngày có 24 ngày `>= 8000` và 4 ngày trống, *then* `summarizeTrend`
   trả `daysWithData == 26`, `daysOnTarget == 24`, `peakValue` là giá trị lớn nhất kèm
   đúng ngày, `completionRatio == 0.8`.
6. *Given* `formatSleepDuration(7.5)`, *then* `'7h 30m'`; `formatMl(1750)` → `'1.750 ml'`.
7. *Then* file **không** import `flutter/material.dart` cho logic (chỉ import model);
   `flutter analyze` sạch.

## Kiểm chứng

```powershell
cd flutter_app
flutter analyze
Select-String -Path 'lib\src\ui\health\health_metrics.dart' -Pattern 'bmiOf|waterBreakdownOf|summarizeTrend|formatSleepDuration'
# chạy test hàm thuần (H5-S1):
flutter test test\health_test.dart
```

## Rủi ro / ghi chú

- **Múi giờ**: mọi so sánh “buổi”/“hôm nay” phải cộng 7 giờ trước khi lấy `hour`; đừng
  dùng `DateTime.now()` trong hàm thuần — truyền thời điểm vào để test được.
- Không chốt cứng ngưỡng 70% vào nhiều chỗ: khai báo hằng `partialThreshold = 0.7` một
  lần, tái sử dụng cho cả chart lẫn legend.
- Đầu vào là model từ `data/models.dart` ⇒ file này nằm ở `ui/` nhưng **không** phụ
  thuộc widget; giữ vậy để `test/health_test.dart` chạy không cần `pumpWidget`.
