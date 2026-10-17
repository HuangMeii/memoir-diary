# H1-S7 · Integration test endpoint Sức khoẻ

**Epic:** H1 · **Ước lượng:** 3 pts · **Phụ thuộc:** H1-S6
**Mẫu:** `memoir_server/memoir_server_server/test/integration/auth_endpoint_test.dart`
(+ `test/integration/test_tools/serverpod_test_tools.dart`)

## Mục tiêu

Khoá hành vi của endpoint `health` bằng integration test chạy trên DB test của
Serverpod: upsert theo ngày, nội dung một ngày, cộng/trừ nước, mốc hoạt động,
thông số cơ thể và chuỗi xu hướng — gồm cả **kiểm tra sở hữu**.

## Phạm vi

- **Tạo mới:** `memoir_server/memoir_server_server/test/integration/health_endpoint_test.dart`.
- **KHÔNG sửa:** `auth_endpoint_test.dart`, `test/route_service_test.dart`,
  các file trong `test/integration/test_tools/` (đã sinh).

## Việc cần làm

- [ ] Dựng user test riêng cho nhóm health (theo cách `auth_endpoint_test.dart` đăng
      ký user), lấy session đã đăng nhập từ test tools.
- [ ] `group('health save')`:
  - lưu ngày mới với `steps`/`workoutMinutes` ⇒ đọc lại đúng;
  - lưu lại **cùng ngày** ⇒ vẫn **một** hàng, giá trị được cập nhật (upsert);
  - lưu kèm `workoutType`, `workoutIntensity`, `sleepBedtime`, `sleepWake`,
    `sleepDeepMinutes`, `sleepQuality`, `sleepNote` ⇒ đọc lại đủ 7 field.
- [ ] `group('health day overview')`:
  - ngày trống ⇒ `log == null`, `water.isEmpty`, `activities.isEmpty`, `profile == null`;
  - sau khi lưu + thêm nước + thêm mốc ⇒ mọi danh sách đúng ngày, `water` sắp theo
    `recordedAt`, `activities` sắp theo `atTime`.
- [ ] `group('water')`:
  - thêm `250`, `500`, `1000` ⇒ `log.waterMl == 1750` và `water.length == 3`;
  - xoá một entry ⇒ `waterMl` giảm đúng phần đã xoá;
  - `recordedAt` mặc định là “bây giờ” khi không truyền.
- [ ] `group('activity')`: thêm 2 mốc ⇒ timeline có 2 mốc; xoá 1 mốc ⇒ còn 1.
- [ ] `group('profile')`: chưa có hàng ⇒ `profileGet()` là `null`; sau
      `profileSave(heightCm: 165, stepsGoal: 9000, waterGoalMl: 2500)` ⇒ đọc lại đúng,
      các mục tiêu khác giữ default `60`/`8`.
- [ ] `group('trends')`:
  - `steps` cho kỳ 30 ngày ⇒ **30** điểm, `goal == 8000`, ngày trống có `value == null`;
  - `metric` không hợp lệ ⇒ ném `ApiException` với `code == 'badRequest'`.
- [ ] `group('ownership')`: user thứ hai không xoá được `waterRemove`/`activityRemove`
      của user thứ nhất (`code == 'notFound'`).
- [ ] `dart test`, `dart format .`.

## Acceptance Criteria

1. *Given* DB test sạch, *when* `dart test`, *then* nhóm health xanh, không test nào
   phụ thuộc thứ tự chạy giữa các `group`.
2. *Given* lưu cùng ngày hai lần, *then* số hàng `health_logs` của user đó **không** tăng.
3. *Given* thêm rồi xoá nước, *then* `health_logs.waterMl` luôn bằng tổng các
   `health_water_entries` còn lại của ngày.
4. *Given* `trends` 30 ngày, *then* độ dài danh sách luôn bằng số ngày của kỳ
   (không co lại khi thiếu dữ liệu).
5. *Given* hành vi của user khác, *then* `ApiException` có `code` ổn định
   (`notFound` / `badRequest`), không phải lỗi thô.
6. *Then* `dart analyze` sạch; `dart test` toàn bộ server vẫn xanh (không hồi quy
   `auth_endpoint_test.dart`).

## Kiểm chứng

```powershell
cd memoir_server\memoir_server_server
dart analyze
dart format .
dart test
# chỉ nhóm health:
dart test test\integration\health_endpoint_test.dart
```

## Rủi ro / ghi chú

- Test chạy trên DB test của Serverpod (`.serverpod/test/pgdata`), **không** chạm Neon.
- Dữ liệu test nên tạo mới mỗi lần chạy (ngày riêng hoặc user riêng) để không phụ
  thuộc trạng thái DB còn lại.
- Đừng assert theo `createdAt`/`now()` tuyệt đối — chỉ so **thứ tự** hoặc khoảng thời gian.
