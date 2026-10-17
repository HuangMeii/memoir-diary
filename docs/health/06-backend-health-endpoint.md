# H1-S5 · Endpoint `health` mở rộng

**Epic:** H1 · **Ước lượng:** 5 pts · **Phụ thuộc:** H1-S4
**Nguồn thiết kế:** gom từ các khối dữ liệu của
`ui-figma/suckhoe/memoir_s_c_kho_th_ch_t_t_i_gi_n/code.html` (form 249–316, xu hướng
253–447, timeline 453–505) và drawer BMI của `…_bmi/code.html` (539–720)

## Mục tiêu

Mở rộng `HealthEndpoint` từ `list` + `save` thành đủ API cho dashboard: nội dung một
ngày, chuỗi xu hướng theo metric, thêm/xoá lần uống, thêm/xoá mốc hoạt động, đọc/lưu
thông số cơ thể & mục tiêu. Giữ **nguyên** `list`/`save` để không phá màn cũ và
`monthSummaryProvider`.

## Phạm vi

- **Sửa:** `memoir_server/memoir_server_server/lib/src/health/health_endpoint.dart`.
- **KHÔNG sửa:** `lib/src/generated/**`, `.spy.yaml` (đã xong ở H1-S1…S4),
  `stats_endpoint.dart` (đọc `health_logs` như cũ).

## Việc cần làm

- [ ] `save(...)`: thêm tham số `workoutType`, `workoutIntensity`, `sleepBedtime`,
      `sleepWake`, `sleepDeepMinutes`, `sleepQuality`, `sleepNote`; giữ nguyên hành vi
      upsert theo `(userId, logDate)` và **giữ nguyên** semantic hiện tại (giá trị
      không truyền ⇒ `null`, vì form luôn gửi toàn bộ field — xem comment trong hàm).
- [ ] `dayOverview(date)` → `HealthDayOverview`:
      `log` (findFirstRow theo ngày), `water` (find theo `logDate`, sort `recordedAt`),
      `activities` (find theo `logDate`, sort `atTime`), `profile` (theo `userId`).
- [ ] `trends(from, to, metric)` → `List<HealthTrendPoint>`: luôn trả **đủ số ngày**
      của kỳ (kể cả ngày `value == null`), mỗi điểm kèm `goal` của metric đó lấy từ
      `HealthProfile` (thiếu profile ⇒ default 8000/60/2000/8). `metric` nhận
      `steps | workout | water | sleep | weight`; giá trị khác ⇒
      `ApiException(code: 'badRequest')`.
- [ ] `waterAdd(logDate, amountMl, recordedAt?, note?)` → chèn `HealthWaterEntry`
      (mặc định `recordedAt = now()`), rồi **tính lại tổng** vào
      `health_logs.waterMl` (tổng các entry của ngày) và upsert hàng ngày nếu chưa có.
- [ ] `waterRemove(id)` → kiểm `ensureOwned`, xoá entry, tính lại tổng như trên.
- [ ] `activityAdd(logDate, atTime, title, detail?)` và `activityRemove(id)` → kiểm
      `ensureOwned` trước khi ghi/xoá.
- [ ] `profileGet()` → `HealthProfile?`; `profileSave(heightCm?, weightGoalKg?,
      weightStartKg?, stepsGoal?, workoutGoalMinutes?, waterGoalMl?, sleepGoalHours?)`
      → upsert theo `userId`, trả hàng vừa lưu.
- [ ] Mọi phương thức: `currentUserId(session)` + `dateOnly(...)` cho ngày; **chỉ**
      chạm `health_logs` để cập nhật tổng nước trong `waterAdd`/`waterRemove` (không
      ghi đè các field khác của hàng ngày).
- [ ] Xoá mốc/lần uống của user khác ⇒ `ApiException(code: 'notFound')`.
- [ ] `dart analyze ; dart format .`.

## Acceptance Criteria

1. *Given* `save` không truyền field mới, *when* lưu, *then* hành vi giống hệt bản cũ
   (hàng ngày được tạo/cập nhật, `monthSummaryProvider` đọc được như trước).
2. *Given* `dayOverview(2026-10-17)` khi ngày đó chưa có gì, *then* trả
   `log == null`, `water == []`, `activities == []`, `profile == null`.
3. *Given* thêm 3 lần uống `250/500/1000 ml`, *then* `waterAdd` trả về
   `HealthDayOverview` có 3 entry và `log.waterMl == 1750`; xoá 1 entry ⇒ tổng cập nhật lại.
4. *Given* `trends(from: 2026-09-18, to: 2026-10-17, metric: 'steps')`, *then* trả
   đúng **30** điểm, ngày không có `steps` mang `value == null`, và `goal == 8000`
   (hoặc mục tiêu người dùng đã lưu).
5. *Given* `profileGet()` khi chưa có hàng, *then* trả `null`; sau `profileSave(heightCm: 165, stepsGoal: 9000)`
   thì `profileGet()` trả đúng hai giá trị đó và các mục tiêu còn lại giữ default.
6. *Given* gọi `waterRemove`/`activityRemove` với id của user khác, *then*
   `ApiException(code: 'notFound')`.
7. *Given* `metric: 'khong-ton-tai'`, *then* `ApiException(code: 'badRequest')`.
8. *Then* `dart analyze` sạch, `dart format` không tạo thay đổi.

## Kiểm chứng

```powershell
cd memoir_server\memoir_server_server
dart analyze
dart format .
Select-String -Path 'lib\src\health\health_endpoint.dart' -Pattern 'dayOverview|trends|waterAdd|activityAdd|profileSave'
# chạy server để thử tay (tuỳ chọn):
# serverpod start
```

## Rủi ro / ghi chú

- **Recalc tổng nước**: chỉ tính lại 2 cột liên quan của `health_logs`
  (`waterMl`), không dựng lại cả hàng (tránh ghi đè `steps`/`note` người dùng vừa nhập).
- `trends` phải dựng ngày theo **giờ VN** (UTC+7) cho khớp UI — cùng cách
  `weather_endpoint` đang xử lý ngày dự báo.
- `weight` lấy từ `health_logs.weightKg` (cân nặng theo ngày) — **không** lấy từ
  `health_profiles` (chỉ có mục tiêu/khởi điểm).
- Endpoint đang `requireLogin = true`; giữ nguyên.
- Nếu `save` buộc phải "chỉ ghi field được truyền" để H3-S3 lưu từng phần, hãy chốt
  lại trong PR trước vì `_healthMap` phía client đang dựa vào semantic hiện tại.
