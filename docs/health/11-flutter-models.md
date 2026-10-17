# H2-S3 · Model Dart mới

**Epic:** H2 · **Ước lượng:** 2 pts · **Phụ thuộc:** H2-S1
**File:** `flutter_app/lib/src/data/models.dart` (`HealthLog` ở dòng 265–307)

## Mục tiêu

Bổ sung vào tầng model Dart những field/class mà dashboard cần: 7 field mới của
`HealthLog`, và 5 class mới (`HealthWaterEntry`, `HealthActivity`, `HealthProfile`,
`HealthDayOverview`, `HealthTrendPoint`).

## Phạm vi

- **Sửa:** `flutter_app/lib/src/data/models.dart` (chỉ phần health).
- **KHÔNG sửa:** các class khác trong file; không thêm dependency mới (không dùng
  `freezed`/`json_serializable`).

## Việc cần làm

- [ ] Mở rộng `HealthLog`: `workoutType`, `workoutIntensity`, `sleepBedtime`,
      `sleepWake`, `sleepDeepMinutes`, `sleepQuality`, `sleepNote` — tất cả nullable,
      giữ nguyên 8 field cũ và constructor `const`.
- [ ] `HealthLog.fromJson`: đọc thêm 7 khoá snake_case; `toPayload()` thêm 7 khoá
      tương ứng theo đúng nguyên tắc hiện tại (**chỉ gửi field khác null**).
- [ ] `HealthWaterEntry { id, logDate, amountMl, recordedAt, note }` với `fromJson`.
- [ ] `HealthActivity { id, logDate, atTime, title, detail, kind }` với `fromJson`.
- [ ] `HealthProfile` với `heightCm`, `weightGoalKg`, `weightStartKg`, `stepsGoal`,
      `workoutGoalMinutes`, `waterGoalMl`, `sleepGoalHours`; `fromJson` **điền default
      của thiết kế** khi server trả `null` cho mục tiêu (8000 / 60 / 2000 / 8) để widget
      không phải kiểm tra null từng chỗ.
- [ ] `HealthDayOverview { date, log, water, activities, profile }` với `fromJson`
      chấp nhận `log == null` và `profile == null`; hai danh sách luôn khác null.
- [ ] `HealthTrendPoint { date, value, goal }` với `fromJson` (giữ `value`/`goal` null).
- [ ] `flutter analyze`.

## Acceptance Criteria

1. *Given* một map chứa đủ 15 khoá health, *when* `HealthLog.fromJson`, *then* đọc
   đúng cả 7 field mới và 8 field cũ.
2. *Given* `HealthLog` chỉ có `steps`, *when* `toPayload()`, *then* map chỉ chứa
   `steps` (không gửi `null` cho các field còn lại — giữ hành vi cũ).
3. *Given* `HealthProfile.fromJson({})` (server trả thiếu mục tiêu), *then*
   `stepsGoal == 8000`, `workoutGoalMinutes == 60`, `waterGoalMl == 2000`,
   `sleepGoalHours == 8`.
4. *Given* `HealthDayOverview.fromJson` với `log: null`, `profile: null`, *then*
   đọc được, `water == []`, `activities == []`.
5. *Given* `HealthTrendPoint.fromJson` với `value: null`, *then* `value == null`
   (không biến thành 0 — tránh vẽ cột 0 sai).
6. *Then* `flutter analyze` sạch, `flutter test` cũ vẫn xanh.

## Kiểm chứng

```powershell
cd flutter_app
flutter analyze
Select-String -Path 'lib\src\data\models.dart' -Pattern 'class HealthWaterEntry|class HealthActivity|class HealthProfile|class HealthDayOverview|class HealthTrendPoint|sleepDeepMinutes'
```

## Rủi ro / ghi chú

- Giữ tên khoá JSON **snake_case** đúng như `_healthMap` (H2-S1) sinh ra; lệch một
  khoá là `fromJson` ném cast error ở runtime.
- `HealthLog.logDate` đang là `DateTime` đọc từ chuỗi `log_date`; giữ nguyên, đừng
  đổi sang `String`.
- Không thêm factory test vào file này (xem `docs/notes/25-test-flutter-notes.md`):
  dữ liệu mẫu để trong chính file test.
