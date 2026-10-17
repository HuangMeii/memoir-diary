# H1-S6 · Migration cho model Sức khoẻ

**Epic:** H1 · **Ước lượng:** 2 pts · **Phụ thuộc:** H1-S5

## Mục tiêu

Sinh migration cho toàn bộ thay đổi schema của H1-S1…H1-S5 và bảo đảm nó **không mất
dữ liệu** `health_logs` trên DB Neon thật.

## Phạm vi

- **Sinh mới:** `memoir_server/memoir_server_server/migrations/<timestamp>/`
  (do generator tạo) + một dòng mới trong `migrations/migration_registry.txt`.
- **Được sửa tay:** chỉ `migration.sql` của migration vừa sinh (khi cần thêm index).
- **KHÔNG sửa:** các migration cũ; `definition.sql` chỉ thêm index cho khớp
  `migration.sql`.

## Việc cần làm

- [ ] Chạy `serverpod create-migration` trong `memoir_server_server`.
- [ ] Rà `migration.sql` sinh ra có đúng:
  - `ALTER TABLE "health_logs" ADD COLUMN` cho `workoutType`, `workoutIntensity`,
    `sleepBedtime`, `sleepWake`, `sleepDeepMinutes`, `sleepQuality`, `sleepNote`
    (mọi cột **nullable**);
  - `CREATE TABLE "health_water_entries"` (+ FK cascade tới `users`);
  - `CREATE TABLE "health_activities"` (+ FK cascade tới `users`);
  - `CREATE TABLE "health_profiles"` (+ FK cascade tới `users`, **UNIQUE** trên `userId`).
- [ ] Nếu generator đòi `--force` ⇒ **dừng**, đọc SQL và báo lại (dấu hiệu nó định
      drop cột/bảng đang có dữ liệu).
- [ ] Thêm index thủ công (chỉ trong `migration.sql`) nếu generator chưa tạo:

```sql
-- Nội dung một ngày: lọc theo user + ngày, sắp theo thời điểm uống.
CREATE INDEX IF NOT EXISTS "idx_health_water_user_date"
  ON "health_water_entries" ("userId", "logDate", "recordedAt");
-- Dòng thời gian hoạt động của một ngày.
CREATE INDEX IF NOT EXISTS "idx_health_activity_user_date"
  ON "health_activities" ("userId", "logDate", "atTime");
-- Chuỗi xu hướng đọc theo khoảng ngày.
CREATE INDEX IF NOT EXISTS "idx_health_logs_user_date"
  ON "health_logs" ("userId", "logDate");
```

- [ ] **Đối chiếu**: thêm đúng các index đó vào `definition.sql` (đúng vị trí, cùng
      tên) để DB mới tạo từ `definition.sql` cho ra schema giống `migration.sql`.
- [ ] Đếm hàng `health_logs` **trước** khi apply, ghi lại con số để so sau.
- [ ] Xác nhận `migration_registry.txt` có thêm timestamp mới, không trùng.

## Acceptance Criteria

1. *Given* model đã sửa, *when* chạy `serverpod create-migration`, *then* sinh một
   thư mục migration mới + một dòng mới trong `migration_registry.txt`.
2. *Given* `migration.sql`, *then* nó chỉ có `ADD COLUMN` (nullable, không dữ liệu
   default phá vỡ hàng cũ) và `CREATE TABLE` / `CREATE INDEX` — **không** có
   `DROP COLUMN`/`DROP TABLE`/`ALTER … SET NOT NULL` trên cột đang có dữ liệu.
3. *Given* `health_logs` đang có n hàng, *when* `serverpod start` áp migration, *then*
   vẫn đúng n hàng và các cột mới đều `NULL`.
4. *Given* DB mới dựng từ `definition.sql`, *then* có đủ 3 bảng mới + 3 index và
   `unique (userId)` trên `health_profiles`.
5. *Then* `dart test` (nhóm health, H1-S7) chạy được sau khi migration áp vào DB test.

## Kiểm chứng

```powershell
cd memoir_server\memoir_server_server
serverpod create-migration
Get-ChildItem migrations | Select-Object Name
$last = Get-ChildItem migrations -Directory | Sort-Object Name | Select-Object -Last 1
Get-Content (Join-Path $last.FullName 'migration.sql')
Get-Content 'migrations\migration_registry.txt'
# apply là bước của bạn:
# serverpod start
```

## Rủi ro / ghi chú

- **Đây là bước chạm DB thật** khi `serverpod start`. Đọc kỹ `migration.sql` trước
  khi apply; muốn an toàn thì chạy trên nhánh Neon tạm hoặc backup trước.
- `health_logs.waterMl` **giữ nguyên** trong migration (không đổi tên, không thêm
  ràng buộc) — tổng nước được tính lại ở tầng endpoint.
- Nếu `definition.sql` và `migration.sql` lệch nhau ở phần index, sửa `definition.sql`
  cho khớp (index là phần duy nhất được thêm tay).
