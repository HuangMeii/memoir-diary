# H3-S5 · Card “Dòng thời gian hoạt động”

**Epic:** H3 · **Ước lượng:** 3 pts · **Phụ thuộc:** H2-S5
**Nguồn thiết kế:** `ui-figma/suckhoe/memoir_c_p_nh_t_th_ng_s_c_nh_n_bmi/code.html`
dòng 453–505 — `h3` “Dòng thời gian hoạt động” + nút `+ Thêm mốc` (456–460) và 4 mốc
mẫu (461–504: “Chạy bộ bờ kè Nhiêu Lộc 06:30 · 4.2 km…”, “Bổ sung nước sau bữa trưa
12:30 · 500 ml…”, “Giãn cơ & Yoga buổi chiều 18:00 · 20 phút…”, “Giấc ngủ ngon đêm qua
23:00 · 7 giờ 30 phút…”)

## Mục tiêu

Dựng dòng thời gian trong ngày: các mốc **hệ thống** suy ra từ log (tập / lần uống cuối /
giấc ngủ) cộng các mốc **người dùng tự thêm** (`health_activities`), sắp theo giờ tăng dần,
có nút `+ Thêm mốc` và xoá mốc tự thêm.

## Phạm vi

- **Tạo mới:** `flutter_app/lib/src/ui/health/health_timeline.dart`.
- **KHÔNG sửa:** `health_summary_cards.dart`, `health_chrome.dart`;
  `ui/widgets/text_prompt_dialog.dart` chỉ **đọc** để cân nhắc tái sử dụng.

## Việc cần làm

- [ ] `HealthTimeline({required DateTime date, required HealthDayOverview day,
      required VoidCallback onChanged})` — `ConsumerStatefulWidget`.
- [ ] Dựng danh sách mốc hệ thống (chỉ thêm khi có dữ liệu):
  - tập: giờ = `day.log.createdAt`? **Không** — dùng nhãn trung tính “Buổi tập”
    với `X phút · <loại hình> · <cường độ>` (bản ghi health không lưu giờ tập riêng);
  - nước: mốc **lần uống cuối** từ `waterBreakdownOf(day.water).lastAt` —
    `HH:mm · <n> ml`;
  - ngủ: nếu có `sleepHours` — `sleepBedtime · 7h 30m` (dùng `formatSleepDuration`).
- [ ] Dựng mốc tự thêm từ `day.activities`: `atTime · title · detail` (detail rỗng ⇒ ẩn).
- [ ] Sắp **tất cả** mốc theo thời điểm tăng dần; mốc không có giờ nằm cuối; dùng đường
      kẻ dọc + chấm tròn (`colorScheme.primary` cho mốc người dùng, `outlineVariant` cho mốc hệ thống).
- [ ] `+ Thêm mốc`: `showDialog` (dùng `TextPromptDialog` nếu chữ ký phù hợp, nếu không
      tạo `_AddMilestoneDialog` **trong file này**) thu 3 trường: giờ (`TimePicker`, mặc
      định giờ hiện tại theo VN), tiêu đề (bắt buộc), ghi chú (tuỳ chọn) ⇒ gọi
      `addActivity(...)` rồi `refreshHealth(ref, day: date)` + `onChanged()`.
- [ ] Xoá mốc tự thêm: `IconButton` (`Icons.close`) chỉ trên mốc người dùng ⇒ xác nhận ⇒
      `removeActivity(id)` ⇒ `refreshHealth`.
- [ ] Danh sách dài: cắt còn 4–5 mốc đầu + nút “Xem toàn bộ lịch sử 7 ngày” ở trạng thái
      chờ (`onPressed: null` + tooltip) như thiết kế (ngoài phạm vi, `README.md` §9).
- [ ] Trạng thái trống: câu “Chưa có mốc nào hôm nay. Thêm mốc đầu tiên.” + nút `+ Thêm mốc`.
- [ ] `flutter analyze`.

## Acceptance Criteria

1. *Given* ngày có tập 45 phút, 3 lần uống (lần cuối 14:30) và ngủ 7h30/23:00, *then*
   timeline có 3 mốc hệ thống và sắp tăng dần theo giờ (mốc tập đứng cuối vì không có giờ).
2. *Given* bấm `+ Thêm mốc` và lưu “Giãn cơ & Yoga buổi chiều, 18:00, 20 phút…”, *then*
   mốc mới xuất hiện **ngay** trong danh sách đúng vị trí theo giờ (không cần tải lại trang).
3. *Given* bấm xoá một mốc người dùng, *then* mốc biến mất và gọi `removeActivity` đúng id.
4. *Given* mốc hệ thống, *then* **không** có nút xoá (không xoá được dữ liệu log từ timeline).
5. *Given* ngày trống, *then* hiện trạng thái trống + nút `+ Thêm mốc`.
6. *Then* `flutter analyze` sạch; màn 390px không tràn.

## Kiểm chứng

```powershell
cd flutter_app
flutter analyze
flutter run -d chrome --web-port 8080   # so với code.html 453–505 / screen.png
```

## Rủi ro / ghi chú

- Mốc **hệ thống** là suy diễn, không phải dữ liệu lưu riêng: đừng ghi thêm hàng
  `health_activities` cho chúng, nếu không sẽ nhân đôi khi tải lại.
- Bản ghi `health_logs` **không** có giờ tập; nếu sau này cần “06:30, 4.2 km, 210 kcal”
  như thiết kế thì phải thêm cột (task mới), đừng bịa giờ từ `createdAt`.
- `atTime` lưu chuỗi `HH:mm` (H1-S2) nên khi sắp xếp phải so chuỗi theo **giờ VN** và
  xử lý trường hợp thiếu (mốc cũ chưa có giờ).
