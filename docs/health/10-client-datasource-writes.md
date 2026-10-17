# H2-S2 · Map ghi (nước / hoạt động / thông số cơ thể / save)

**Epic:** H2 · **Ước lượng:** 3 pts · **Phụ thuộc:** H2-S1
**File:** `flutter_app/lib/src/data/datasources/serverpod_data_source.dart`

## Mục tiêu

Nối các hành vi ghi của thiết kế xuống endpoint `health`: lưu chỉ số ngày (đã có, nay
thêm field), thêm/xoá **lần uống**, thêm/xoá **mốc hoạt động**, lưu **thông số cơ thể
& mục tiêu**.

## Phạm vi

- **Sửa:** `post(...)`, `put(...)`, `delete(...)` (các nhánh health).
- **KHÔNG sửa:** `uploadImage`, nhánh domain khác, `backend_data_source.dart`.

## Việc cần làm

- [ ] Mở rộng `case '/health-logs'` trong `post(...)` (dòng 236–245) truyền thêm
      `workoutType`, `workoutIntensity`, `sleepBedtime`, `sleepWake`,
      `sleepDeepMinutes`, `sleepQuality`, `sleepNote`.
- [ ] Thêm nhánh `post` cho `/health/water` → `_client.health.waterAdd(logDate,
      amountMl, recordedAt, note)` → trả `_dayOverviewMap(...)`.
- [ ] Thêm nhánh `delete` cho `/health/water/{id}` → `waterRemove(id)` →
      `_dayOverviewMap(...)`.
- [ ] Thêm nhánh `post` cho `/health/activity` → `activityAdd(logDate, atTime, title,
      detail)` → `_dayOverviewMap(...)`.
- [ ] Thêm nhánh `delete` cho `/health/activity/{id}` → `activityRemove(id)` →
      `_dayOverviewMap(...)`.
- [ ] Thêm nhánh `put` cho `/health/profile` → `profileSave(heightCm, weightGoalKg,
      weightStartKg, stepsGoal, workoutGoalMinutes, waterGoalMl, sleepGoalHours)` →
      `_profileMap(...)`.
- [ ] Helper `_uuid(dynamic value)` → `UuidValue` (hoặc `null`) để parse id phần nước/
      mốc từ path/body — theo cách các domain khác đang parse id.
- [ ] Xử lý `DateTime?`: `recorded_at` từ body là `HH:mm`-less ISO? **Chốt**: body gửi
      ISO đầy đủ (giờ VN quy về UTC ở client) hoặc bỏ trống để server dùng `now()`.
- [ ] `flutter analyze`.

## Acceptance Criteria

1. *Given* UI lưu chỉ số ngày có “loại hình tập = Chạy bộ, cường độ = vua, ngủ sâu =
   105 phút”, *when* gọi `POST /health-logs`, *then* server nhận đủ 7 field mới và
   response map đọc lại đúng.
2. *Given* `POST /health/water` với `amountMl: 250`, *then* response là nội dung ngày
   đã cập nhật (`water` có thêm 1 phần tử, `log.water_ml` tăng 250).
3. *Given* `DELETE /health/water/{id}`, *then* response là nội dung ngày **sau** khi xoá.
4. *Given* `POST /health/activity` và `DELETE /health/activity/{id}`, *then* map trả về
   có/không có mốc tương ứng.
5. *Given* `PUT /health/profile` với 7 field, *then* response `_profileMap` có giá trị
   vừa lưu; gửi `null` nghĩa là **xoá** giá trị đó (đúng semantic `put` hiện có).
6. *Then* `flutter analyze` sạch; không nhánh nào ném `unsupported POST/PUT/DELETE` cho
   bốn đường dẫn mới.

## Kiểm chứng

```powershell
cd flutter_app
flutter analyze
Select-String -Path 'lib\src\data\datasources\serverpod_data_source.dart' -Pattern "'/health/water'|'/health/activity'|'/health/profile'|waterAdd|activityAdd|profileSave"
```

## Rủi ro / ghi chú

- `put` hiện dựa vào `body[...]` từng key; truyền `null` là **xoá** giá trị. Với mục
  tiêu số (`stepsGoal`…) UI nên luôn gửi giá trị hiện tại để tránh vô tình xoá.
- Thứ tự nhánh `delete`: `/health/water/{id}` và `/health/activity/{id}` phải đứng
  **trước** mọi nhánh tổng quát nếu sau này có `startsWith('/health/')`.
- `recordedAt`: nếu client gửi kèm, phải là thời điểm thật (để phân buổi đúng); nếu
  không, server dùng `now()` — **không** gửi `00:00` giả vì sẽ rơi nhầm vào buổi Sáng.
