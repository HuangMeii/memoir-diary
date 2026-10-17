# H2-S4 · `health_repository.dart` mở rộng

**Epic:** H2 · **Ước lượng:** 2 pts · **Phụ thuộc:** H2-S3
**File:** `flutter_app/lib/src/data/repositories/health_repository.dart`

## Mục tiêu

Đưa toàn bộ hành vi của endpoint `health` ra thành API Dart rõ ràng để provider và
widget chỉ gọi repository.

## Phạm vi

- **Sửa:** `flutter_app/lib/src/data/repositories/health_repository.dart`.
- **KHÔNG sửa:** `backend_data_source.dart` (H2-S1/S2 đã lo), provider (H2-S5).

## Việc cần làm

- [ ] Giữ nguyên `logs({from, to})` (đang dùng cho màn cũ và `monthSummaryProvider`).
- [ ] Đổi `save(...)` thành chữ ký có tên rõ ràng thay vì `Map<String, dynamic>`:

```dart
Future<HealthLog> save({
  required DateTime logDate,
  int? steps,
  int? workoutMinutes,
  String? workoutType,
  String? workoutIntensity,
  int? waterMl,
  double? sleepHours,
  String? sleepBedtime,
  String? sleepWake,
  int? sleepDeepMinutes,
  String? sleepQuality,
  String? sleepNote,
  double? weightKg,
  String? note,
});
```

- [ ] `day(DateTime date)` → `HealthDayOverview` (`GET /health/day?date=…`).
- [ ] `trends({required String from, required String to, required HealthMetric metric})`
      → `List<HealthTrendPoint>` (`GET /health/trends`).
- [ ] `addWater({required DateTime logDate, required int amountMl, DateTime? recordedAt, String? note})`
      → `HealthDayOverview`.
- [ ] `removeWater(String id)` → `HealthDayOverview`.
- [ ] `addActivity({required DateTime logDate, required String atTime, required String title, String? detail})`
      → `HealthDayOverview`.
- [ ] `removeActivity(String id)` → `HealthDayOverview`.
- [ ] `profile()` → `HealthProfile?`; `saveProfile({int? heightCm, double? weightGoalKg,
      double? weightStartKg, int? stepsGoal, int? workoutGoalMinutes, int? waterGoalMl,
      double? sleepGoalHours})` → `HealthProfile`.
- [ ] Ngày gửi xuống datasource dạng `YYYY-MM-DD` (dùng helper chung, không tự cắt chuỗi).
- [ ] `flutter analyze`.

## Acceptance Criteria

1. *Given* màn danh sách tháng gọi `monthSummaryProvider`, *then* nó vẫn lấy dữ liệu
   health qua `logs(...)` như trước (không đổi hành vi).
2. *Given* `day(DateTime(2026, 10, 17))`, *then* gọi `GET /health/day?date=2026-10-17`
   và trả `HealthDayOverview`.
3. *Given* `addWater(amountMl: 250)`, *then* trả nội dung ngày đã cập nhật (không phải
   `void`), để UI cập nhật ngay không cần gọi lại `day(...)`.
4. *Given* `trends(metric: HealthMetric.steps, …)`, *then* metric được dịch sang chuỗi
   `'steps' | 'workout' | 'water' | 'sleep' | 'weight'` đúng như endpoint chờ.
5. *Given* `save(...)` với 7 field mới ⇒ payload có đủ khoá snake_case; field null
   **không** được gửi (giữ nguyên semantic cũ).
6. *Then* `flutter analyze` sạch.

## Kiểm chứng

```powershell
cd flutter_app
flutter analyze
Select-String -Path 'lib\src\data\repositories\health_repository.dart' -Pattern 'day\(|trends\(|addWater|removeWater|addActivity|removeActivity|saveProfile'
```

## Rủi ro / ghi chú

- **Không** để `Map<String, dynamic>` lọt ra khỏi repository: nếu widget phải biết
  khoá snake_case thì tầng dữ liệu đã rò rỉ.
- `HealthMetric` là enum khai báo ở `ui/health/health_metrics.dart` (H2-S6). Nếu muốn
  tách phụ thuộc UI ⇄ data, có thể khai báo enum trong `models.dart` — chọn **một** chỗ
  và thống nhất trong PR.
- `profile()` trả `null` khi chưa lưu, **không** tự tạo hàng mới ở client.
