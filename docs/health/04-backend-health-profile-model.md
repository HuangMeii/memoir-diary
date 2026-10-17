# H1-S3 · Model thông số cơ thể & mục tiêu

**Epic:** H1 · **Ước lượng:** 2 pts · **Phụ thuộc:** —
**Nguồn thiết kế:** `ui-figma/suckhoe/memoir_c_p_nh_t_th_ng_s_c_nh_n_bmi/code.html`
— drawer 539–720: chiều cao + “Dùng làm mốc tính chỉ số BMI & BMR” (585–603),
BMI 21.4 chuẩn IDI & WPRO (604–642), cân nặng mục tiêu 57.0 / khởi điểm 61.0
(643–661); mục tiêu ngày nằm ở thẻ hero (`/ 60 phút`, `/ 2.000 ml`, `/ 8h 00m`)
và ô “Mục tiêu: 8.000 bước” (dòng 298)

## Mục tiêu

Tạo bảng `health_profiles` (1 dòng / user) chứa **thông số cơ thể** (chiều cao,
cân nặng mục tiêu, cân nặng khởi điểm) và **mục tiêu sức khoẻ** (bước, phút tập,
nước, giờ ngủ) để dashboard tính được BMI, tiến độ giảm cân và % hoàn thành mục tiêu.

## Phạm vi

- **Tạo mới:** `memoir_server/memoir_server_server/lib/src/health/health_profile.spy.yaml`.
- **KHÔNG sửa:** `lib/src/auth/user.spy.yaml` (quyết định #2 phương án A — không nhét
  cột health vào `users`), `lib/src/generated/**`, `memoir_server_client/**`.

## Việc cần làm

- [ ] Tạo `health_profile.spy.yaml`:

```yaml
### Health body measurements and daily goals. One row per user.
class: HealthProfile
table: health_profiles
fields:
  id: UuidValue?, defaultPersist=random_v7
  userId: UuidValue, unique, relation(parent=users, onDelete=Cascade)
  ### Body metrics; height feeds BMI/BMR, so it is stored once.
  heightCm: int?
  weightGoalKg: double?
  weightStartKg: double?
  ### Daily goals shown on the dashboard hero cards.
  stepsGoal: int, default=8000
  workoutGoalMinutes: int, default=60
  waterGoalMl: int, default=2000
  sleepGoalHours: double, default=8
  updatedAt: DateTime, default=now
```

- [ ] Chạy `serverpod generate`; xác nhận bảng `health_profiles` có `unique(userId)`.
- [ ] Xác nhận default hoạt động khi tạo hàng mới (4 mục tiêu có giá trị mặc định
      đúng như thiết kế: 8.000 bước, 60 phút, 2.000 ml, 8 giờ).
- [ ] `dart analyze`.

## Acceptance Criteria

1. *Given* model mới, *when* `serverpod generate`, *then* có bảng `health_profiles`
   với FK cascade tới `users` và **unique** trên `userId`.
2. *Given* một user chưa từng lưu thông số, *then* nội dung ngày (H1-S4) trả
   `profile == null` và tầng đọc UI dùng default của thiết kế (8000/60/2000/8).
3. *Given* một `HealthProfile` tạo không truyền mục tiêu, *then* nhận
   `8000/60/2000/8` (khớp `default` trong yaml).
4. *Given* lưu `heightCm: 165`, `weightGoalKg: 57.0`, `weightStartKg: 61.0`,
   *then* giá trị đọc lại đúng (double không mất phần thập phân).
5. *Then* `memoir_server_client` export `HealthProfile`; `dart analyze` sạch.

## Kiểm chứng

```powershell
cd memoir_server\memoir_server_server
serverpod generate
dart analyze
Select-String -Path 'lib\src\generated\health\health_profile.dart' -Pattern 'weightGoalKg|stepsGoal|heightCm'
```

## Rủi ro / ghi chú

- **Cân nặng hiện tại không** lưu ở đây: đã có `health_logs.weightKg` theo ngày, và
  chart “Biến động cân nặng 4 tuần / 6 tháng” đọc chính chuỗi đó.
- `weightStartKg` là mốc so sánh cho thanh tiến độ (“Khởi điểm 61.0 kg → Đích 57.0 kg”);
  UI chỉ ghi khi người dùng lưu lần đầu hoặc khi họ bấm đặt lại khởi điểm.
- Mục tiêu là **dữ liệu người dùng**, không phải hằng số: đừng hard-code vào widget.
- Bỏ `BMR`/`kcal` khỏi model (ngoài phạm vi, xem `README.md` §9); chiều cao vẫn lưu
  vì BMI cần.
