# H3-S3 · Form “Nhập nhanh chỉ số hôm nay”

> **Trạng thái 25.10.2026:** **đã gỡ khỏi màn.** `health_quick_form.dart` bị xoá và cột
> trái dashboard chỉ còn `HealthTrends`; nút *Thông số* trên header vẫn mở
> `showHealthBodySheet` (H3-S7). Tài liệu dưới đây giữ làm bản ghi thiết kế.

**Epic:** H3 · **Ước lượng:** 5 pts · **Phụ thuộc:** H2-S6
**Nguồn thiết kế:** `ui-figma/suckhoe/memoir_c_p_nh_t_th_ng_s_c_nh_n_bmi/code.html`
dòng 249–316 — tiêu đề “Nhập nhanh chỉ số hôm nay” + “Ngày 17/10/2026” + nút thu gọn,
“Thời lượng (phút)” + “Cường độ” (Tập nhẹ/Vừa/Nặng), “Tổng lượng nước” + “Số lần uống”
+ “Gần nhất”, “Phân bố lượng nước theo buổi”, “Giấc ngủ” (Thời lượng/Khung giờ),
“Thông số cá nhân” (Cân nặng/Chiều cao), “Ghi chú cơ thể hôm nay”, nút “Lưu chỉ số”

## Mục tiêu

Thay form 6 ô của `health_screen.dart` cũ bằng form đầy đủ của thiết kế: nhập trong
ngày đang chọn, ghi qua `HealthRepository.save(...)`, làm mới dữ liệu bằng `refreshHealth`.

## Phạm vi

- **Tạo mới:** `flutter_app/lib/src/ui/health/health_quick_form.dart`.
- **KHÔNG sửa:** `health_screen.dart` (viết lại ở H3-S8), sheet ghi nhận nhanh (H4).

## Việc cần làm

- [ ] `HealthQuickForm({required DateTime date, required HealthDayOverview day,
      required HealthProfile? profile, required VoidCallback onSaved,
      required VoidCallback onOpenBodySheet})` — `ConsumerStatefulWidget`.
- [ ] Header card: nhãn “NHẬP NHANH CHỈ SỐ HÔM NAY” + `Ngày dd/MM/yyyy` + nút
      thu gọn/mở (`Icons.expand_more`, đổi trạng thái `Sửa`/`Đóng` như thiết kế).
- [ ] **Vận động**: `Thời lượng (phút)` (`TextField` số) + `Cường độ` là `SegmentedTabs`
      (dùng `ui/widgets/segmented_tabs.dart`) với 3 lựa chọn `Tập nhẹ / Tập vừa / Tập nặng`
      ↔ `nhe | vua | nang`.
- [ ] **Nước**: hiển thị `Tổng lượng nước` + `Số lần uống` + `Gần nhất` **chỉ đọc**
      (suy từ `day.water` bằng `waterBreakdownOf`), kèm nút `+ Thêm ly` mở tab Uống nước
      của sheet ghi nhận nhanh (H4-S3) — không nhập tổng trực tiếp để tránh lệch với
      bảng con.
- [ ] **Phân bố theo buổi**: 3 hàng Sáng/Chiều/Tối với `ml`, số lần, và nhãn trạng thái
      (“Đạt nhịp”, “Cao nhất”, “1 lần nạp”); kèm dòng `Đã nạp xx% mục tiêu`.
- [ ] **Giấc ngủ**: `Thời lượng ngủ` (giờ, 1 số lẻ) + `Khung giờ ngủ` (2 `TextField`/`TimePicker`
      cho `sleepBedtime`/`sleepWake` dạng `HH:mm`); nút mở tab Giờ ngủ của sheet (H4-S4).
- [ ] **Thông số cá nhân**: `Cân nặng (kg)` + `Chiều cao (cm)`; nút “Thông số cá nhân
      & Thể trạng” mở drawer BMI (`onOpenBodySheet` ⇒ H3-S7).
- [ ] **Ghi chú cơ thể hôm nay**: `TextField` `maxLines: 3`, placeholder
      “Hôm nay cơ thể nhẹ nhõm…”.
- [ ] `Lưu chỉ số`: dựng payload bằng `HealthLog.toPayload()` (chỉ gửi field khác null);
      rỗng ⇒ snackbar “Chưa nhập gì để lưu”; thành công ⇒ `onSaved()`.
- [ ] `initState`/`didUpdateWidget`: prefill từ `day.log` (kể cả 7 field mới); đổi ngày
      ⇒ nạp lại giá trị, **không** giữ dữ liệu ngày cũ.
- [ ] Validation: chỉ nhận số hợp lệ (`int.tryParse`/`double.tryParse`); giá trị âm ⇒ chặn
      lưu; giữ đúng giá trị người dùng nhập khi lỗi.
- [ ] Nút lưu là con trực tiếp của `Column` (đặt trong `SizedBox(width: double.infinity)`)
      — **không** để trong `Row` không `Expanded` (xem cảnh báo trong `ui/theme.dart`).
- [ ] `flutter analyze`.

## Acceptance Criteria

1. *Given* ngày có `steps`, `workoutMinutes`, `sleepHours`, *when* mở form, *then* các ô
   được prefill đúng; đổi sang ngày khác *then* các ô đổi theo ngày mới.
2. *Given* người dùng sửa “Thời lượng (phút)” thành 50 và bấm “Lưu chỉ số”, *then*
   gọi `save(...)` có `workoutMinutes: 50`, **không** gửi các field bỏ trống, rồi
   `refreshHealth(ref)` và snackbar “Đã lưu ngày dd/MM”.
3. *Given* người dùng chọn cường độ “Tập vừa”, *then* payload có
   `workoutIntensity == 'vua'`.
4. *Given* form rỗng, *when* bấm “Lưu chỉ số”, *then* không gọi API và hiện
   “Chưa nhập gì để lưu”.
5. *Given* bấm “+ Thêm ly”, *then* mở sheet ghi nhận nhanh ở tab **Uống nước**;
   bấm nút thông số ⇒ mở drawer BMI.
6. *Given* màn 390px, *then* form 1 cột, không tràn, nút lưu full-width.
7. *Then* số lần uống/tổng nước hiển thị **khớp** với thẻ tóm tắt (H3-S2) — cùng nguồn
   `day.water`; `flutter analyze` sạch.

## Kiểm chứng

```powershell
cd flutter_app
flutter analyze
flutter run -d chrome --web-port 8080   # so khối form với code.html 249–316 / screen.png
```

## Rủi ro / ghi chú

- **Không** cho nhập “Tổng lượng nước” trực tiếp: tổng do bảng con quyết định (H1-S5),
  nếu cho sửa tay sẽ lệch với “7 lần uống”.
- `sleepHours` giữ đơn vị **giờ** (double) để không phá `monthSummaryProvider`; “Sâu 1h45m”
  là `sleepDeepMinutes`, đừng cộng vào `sleepHours`.
- Chỉ nên `setState` cho phần text; dữ liệu ngày lấy từ `day` (provider ở màn) để tránh
  hai nguồn sự thật.
