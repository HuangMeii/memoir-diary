# H4-S3 · Tab Uống nước

**Epic:** H4 · **Ước lượng:** 3 pts · **Phụ thuộc:** H4-S1
**Nguồn thiết kế:** `ui-figma/suckhoe/memoir_ghi_nh_n_u_ng_n_c_trung_t_m/code.html`
— tiêu đề “Ghi nhận sức khoẻ” (177–199), tab strip (199), “Dung tích vừa uống lần này” +
“Mặc định cốc chuẩn” (210–217), chọn nhanh `+150 ml (cốc nhỏ)` / `+250 ml (ly chuẩn)` /
`+500 ml (bình riêng)` (217–243), “Thời gian uống (Lần uống gần nhất)” + “Vừa nạp xong”
(245–259), “Ghi chú cảm nhận hoặc đồ uống bổ sung · Tùy chọn” (261–283), dòng “Tự động
đồng bộ với trang Sức khoẻ” (283), footer `Hủy / Để sau` + lưu (287–300)

> ⚠️ Modal này **không có `screen.png` dùng được** (28 byte) — chỉ đối chiếu `code.html`.

## Mục tiêu

Dựng tab **Uống nước**: nhập dung tích **lần này**, chọn nhanh 150/250/500 ml, chỉnh thời
điểm uống, thêm ghi chú, rồi ghi thành **một hàng** `health_water_entries` cho ngày đang xem.

## Phạm vi

- **Tạo mới:** `flutter_app/lib/src/ui/health/quick_water_tab.dart`.
- **Sửa:** — (khung ở H4-S1).
- **KHÔNG sửa:** `health_quick_form.dart` (form chỉ hiển thị tổng, không nhập), `models.dart`.

## Việc cần làm

- [ ] `QuickWaterTab({required DateTime date, required HealthDayOverview day,
      required ValueChanged<bool> onDirtyChanged})`.
- [ ] Dòng tóm tắt ngày: `1.750 ml · 7 lần · 14:30` (dùng `waterBreakdownOf` từ `day.water`)
      + `Mục tiêu 2.000 ml` (từ profile) để người dùng thấy mình đang ở đâu.
- [ ] Ô **“Dung tích vừa uống lần này”**: `TextField` số, suffix `ml`, mặc định **250**
      (“Mặc định cốc chuẩn”), `autofocus: true` để nhập nhanh.
- [ ] **Chọn nhanh** 3 chip: `+150 ml` (cốc nhỏ, icon `local_cafe`), `+250 ml` (ly chuẩn,
      icon `glass_cup`), `+500 ml` (bình riêng, icon `sports_bar`) ⇒ **cộng dồn** vào ô
      dung tích (bấm `+250` ba lần ⇒ `750`), không tự gọi API.
- [ ] **Thời gian uống**: nhãn mặc định `Vừa nạp xong` (dùng `DateTime.now()` khi lưu);
      cho chọn giờ khác bằng `TimePicker` (đổi nhãn thành `HH:mm`); ghi chú dưới ô:
      “Thời điểm quyết định buổi Sáng / Chiều / Tối trong thống kê.”
- [ ] **Ghi chú** (`TextField`, `maxLines: 2`, nhãn “Ghi chú cảm nhận hoặc đồ uống bổ sung ·
      Tùy chọn”), gợi ý chữ mờ: “Uống trà thảo mộc ấm và nước lọc ấm cả ngày”.
- [ ] Dòng đồng bộ: icon `Icons.cloud_done` + “Tự động đồng bộ với trang Sức khoẻ”.
- [ ] `save()` của tab: `healthRepository.addWater(logDate: date, amountMl: …,
      recordedAt: <now | giờ đã chọn>, note: …)`; **chặn** `amountMl <= 0` hoặc `> 5000`
      (báo lỗi, không gọi API).
- [ ] Nhập nhiều lần liên tiếp: giữ tab mở để người dùng nạp tiếp — nếu khung đóng sheet sau
      khi lưu, dùng `onSaved` để mở lại tab Nước với dòng tóm tắt mới (chốt một cách trong PR,
      ghi rõ).
- [ ] `flutter analyze`.

## Acceptance Criteria

1. *Given* ngày đã có 7 lần uống tổng 1.750 ml (lần cuối 14:30), *when* mở tab, *then*
   dòng tóm tắt hiện `1.750 ml · 7 lần · 14:30`.
2. *Given* bấm `+250 ml` hai lần, *then* ô dung tích hiện `500`; bấm `+150` ⇒ `650`.
3. *Given* để nguyên mặc định và bấm lưu, *then* ghi `250 ml` với `recordedAt = now()`
   và thẻ nước trên màn tăng thêm 250 ml **ngay**.
4. *Given* chọn giờ `08:15` rồi lưu, *then* lần uống đó được tính vào buổi **Sáng** (phân
   buổi suy từ giờ), và `recordedAt` giữ đúng thời điểm đã chọn.
5. *Given* nhập `0` hoặc `6000`, *then* không gọi API và hiện lỗi ngay dưới ô.
6. *Given* nhập ghi chú “Uống trà thảo mộc…”, *then* ghi chú được lưu và hiện trong dòng
   thời gian hoạt động (H3-S5).
7. *Then* `flutter analyze` sạch; màn 390px không tràn.

## Kiểm chứng

```powershell
cd flutter_app
flutter analyze
flutter run -d chrome --web-port 8080   # so tab Nước với memoir_ghi_nh_n_u_ng_n_c_trung_t_m/code.html
```

## Rủi ro / ghi chú

- **Không** cho sửa “Tổng lượng nước” ở tab này: tổng là **dẫn xuất** từ bảng con (H1-S5);
  sửa tay sẽ làm lệch “số lần uống”.
- `recordedAt` phải là **thời điểm thật** (now hoặc giờ chọn), không gửi `00:00` giả —
  nếu không lần uống sẽ luôn rơi vào buổi Sáng.
- Chip chọn nhanh **cộng dồn** (không phải radio): người dùng hay nạp liên tiếp cùng lúc.
- Ghi chú để trống ⇒ không gửi `note` (tránh lưu chuỗi rỗng).
