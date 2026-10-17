# H1-S1 · Mở rộng model `HealthLog` (tập + ngủ)

**Epic:** H1 · **Ước lượng:** 2 pts · **Phụ thuộc:** —
**Nguồn thiết kế:** `ui-figma/suckhoe/memoir_ghi_nh_n_nhanh_s_c_kho/code.html`
(loại hình bài tập dòng 249, mức gắng sức 255–279) và
`ui-figma/suckhoe/memoir_ghi_nh_n_gi_ng/code.html` (giờ ngủ/thức dậy 199–231,
ngủ sâu 234–243, chất lượng giấc ngủ 245–278, ghi chú 282–300)

## Mục tiêu

Thêm vào bảng `health_logs` những cột mà ba modal ghi nhận nhanh cần nhưng schema
hiện tại chưa có: **loại hình + cường độ tập**, **khung giờ ngủ**, **ngủ sâu**,
**chất lượng giấc ngủ**, **ghi chú buổi sáng**. Giữ nguyên toàn bộ cột cũ (kể cả
`waterMl`, sẽ do H1-S5 tính lại thành tổng suy ra).

## Phạm vi

- **Sửa:** `memoir_server/memoir_server_server/lib/src/health/health_log.spy.yaml`.
- **KHÔNG sửa:** `lib/src/generated/**`, `memoir_server_client/**` (generator ghi đè);
  `health_endpoint.dart` (task H1-S5).

## Việc cần làm

- [ ] Thêm `workoutType: String?` — loại hình bài tập tự do (“Chạy bộ”, “Yoga”…).
- [ ] Thêm `workoutIntensity: String?` — `nhe` | `vua` | `nang` (chuỗi thường, không
      enum, cùng cách `User.role` đang làm để thêm giá trị không phải sửa code).
- [ ] Thêm `sleepBedtime: String?` và `sleepWake: String?` — giờ dạng `HH:mm`
      (chuỗi, không `DateTime`, vì đây là **giờ trong ngày** không kèm ngày).
- [ ] Thêm `sleepDeepMinutes: int?` — số phút ngủ sâu (ước tính).
- [ ] Thêm `sleepQuality: String?` — `chapChon` | `binhThuong` | `ngonSau`.
- [ ] Thêm `sleepNote: String?` — “Ghi chú cảm nhận buổi sáng” (tách khỏi `note`
      chung của ngày).
- [ ] Chạy `serverpod generate`; xác nhận `generated/health/health_log.dart` có đủ
      6 field mới.
- [ ] Chạy `dart analyze` trong `memoir_server_server`.

## Acceptance Criteria

1. *Given* `.spy.yaml` đã sửa, *when* chạy `serverpod generate`, *then* lệnh kết
   thúc mã 0 và model generated chứa `workoutType`, `workoutIntensity`,
   `sleepBedtime`, `sleepWake`, `sleepDeepMinutes`, `sleepQuality`, `sleepNote`.
2. *Given* một bản ghi ngày mới chỉ truyền `steps`, *then* các field mới đều `null`
   và **không** làm hỏng `unique(per: userId)` của `logDate`.
3. *Given* dữ liệu `health_logs` đang có, *then* model mới đọc lại được bản ghi cũ
   (mọi cột mới nullable).
4. *Then* `memoir_server_client` export `HealthLog` có đủ field mới.
5. *Then* `dart analyze` sạch.

## Kiểm chứng

```powershell
cd memoir_server\memoir_server_server
serverpod generate
dart analyze
Select-String -Path 'lib\src\generated\health\health_log.dart' -Pattern 'sleepDeepMinutes|workoutIntensity|sleepQuality'
```

## Rủi ro / ghi chú

- **Không** đổi kiểu cột cũ (`waterMl`, `sleepHours`…) — dữ liệu người dùng đang có.
- `sleepBedtime`/`sleepWake` để **chuỗi**: giờ ngủ vắt qua nửa đêm (23:00 → 06:30)
  nên lưu `DateTime` sẽ phải kèm ngày và dễ lệch; tổng thời lượng ngủ vẫn là
  `sleepHours` (số giờ, 2 số lẻ) để tương thích `monthSummaryProvider`.
- Mốc thời gian “Lần ghi nhận gần nhất: Hôm qua 07:15” của thiết kế **không** cần
  cột mới: suy từ `createdAt` bản ghi ngày gần nhất.
- Index mới (nếu cần) thuộc H1-S6.
