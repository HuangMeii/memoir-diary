# H1-S2 · Model nước theo lần + hoạt động

**Epic:** H1 · **Ước lượng:** 2 pts · **Phụ thuộc:** —
**Nguồn thiết kế:** `ui-figma/suckhoe/memoir_ghi_nh_n_u_ng_n_c_trung_t_m/code.html`
(dung tích lần này 210–234, chọn nhanh `+150/+250/+500 ml` 217–243, thời gian uống
245–259, ghi chú 261–283) và `ui-figma/suckhoe/memoir_c_p_nh_t_th_ng_s_c_nh_n_bmi/code.html`
(dòng 453–505 “Dòng thời gian hoạt động” + `+ Thêm mốc`)

> ⚠️ Modal uống nước **không có `screen.png` dùng được** (28 byte, file lỗi) — chỉ
> đối chiếu `code.html`.

## Mục tiêu

Tạo hai bảng mới để dashboard hiển thị được những số mà thiết kế yêu cầu:
**nước theo từng lần uống** (số lần, lần gần nhất, phân bố Sáng/Chiều/Tối) và
**mốc hoạt động** người dùng tự thêm vào dòng thời gian.

## Phạm vi

- **Tạo mới:**
  `memoir_server/memoir_server_server/lib/src/health/health_water_entry.spy.yaml`,
  `memoir_server/memoir_server_server/lib/src/health/health_activity.spy.yaml`.
- **KHÔNG sửa:** `.spy.yaml` khác, `lib/src/generated/**`, `memoir_server_client/**`.

## Việc cần làm

- [ ] `health_water_entry.spy.yaml`:

```yaml
### One logged drink. `health_logs.water_ml` is the derived daily total.
class: HealthWaterEntry
table: health_water_entries
fields:
  id: UuidValue?, defaultPersist=random_v7
  userId: UuidValue, relation(parent=users, onDelete=Cascade)
  logDate: DateTime
  amountMl: int
  recordedAt: DateTime, default=now
  note: String?
  createdAt: DateTime, default=now
```

- [ ] `health_activity.spy.yaml`:

```yaml
### A milestone the user adds to the day's activity timeline.
class: HealthActivity
table: health_activities
fields:
  id: UuidValue?, defaultPersist=random_v7
  userId: UuidValue, relation(parent=users, onDelete=Cascade)
  logDate: DateTime
  atTime: String
  title: String
  detail: String?
  ### `note` (tự thêm) — chỗ để mở rộng loại mốc khác sau này.
  kind: String, default='note'
  createdAt: DateTime, default=now
```

- [ ] Chạy `serverpod generate`; xác nhận có `generated/health/health_water_entry.dart`
      và `generated/health/health_activity.dart`.
- [ ] Xác nhận quan hệ cascade: xoá user ⇒ xoá cả hai bảng mới (xem `definition.sql`).
- [ ] `dart analyze`.

## Acceptance Criteria

1. *Given* hai `.spy.yaml` mới, *when* `serverpod generate`, *then* sinh ra hai bảng
   `health_water_entries` và `health_activities` với FK `userId → users(id)` cascade.
2. *Given* một `HealthActivity` tạo không truyền `kind`, *then* `kind == 'note'`.
3. *Given* một `HealthWaterEntry` tạo không truyền `recordedAt`, *then* nhận `now()`
   (để phân buổi theo giờ VN ở tầng đọc).
4. *Then* cả hai model đều không có ràng buộc unique (một ngày có **nhiều** lần uống
   và nhiều mốc).
5. *Then* `memoir_server_client` export hai class mới; `dart analyze` sạch.

## Kiểm chứng

```powershell
cd memoir_server\memoir_server_server
serverpod generate
dart analyze
Select-String -Path 'lib\src\generated\health\health_water_entry.dart','lib\src\generated\health\health_activity.dart' -Pattern 'class Health'
```

## Rủi ro / ghi chú

- `logDate` là **ngày** (so sánh bằng `dateOnly(...)` ở endpoint), còn `recordedAt`
  giữ **thời điểm thật** để suy ra buổi uống và “lần gần nhất 14:30”.
- `health_logs.waterMl` **không** bị bỏ: H1-S5 tính lại tổng từ bảng con mỗi lần
  thêm/xoá, và các màn cũ (`monthSummaryProvider`) vẫn đọc được.
- Index `(userId, logDate)` cho hai bảng mới thuộc H1-S6.
