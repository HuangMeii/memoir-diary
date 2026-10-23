# H4-S2 · Tab Thời gian tập

**Epic:** H4 · **Ước lượng:** 3 pts · **Phụ thuộc:** H4-S1
**Nguồn thiết kế:** `ui-figma/suckhoe/memoir_ghi_nh_n_nhanh_s_c_kho/code.html`
— tiêu đề “Ghi nhận thời gian luyện tập” (211), tab strip (221), đoạn dẫn “Ghi nhận thời
lượng, loại hình vận động và mức độ gắng sức để đồng bộ nhịp rèn luyện thể chất.” (224–234),
“Chi tiết buổi luyện tập” (234), “Số phút tập luyện” (239–247), “Loại hình bài tập” (249–253),
“Mức độ gắng sức” + 3 mức (255–279), ghi chú riêng tư có icon `lock` (279–286), footer
“Hủy / Để sau” + “Lưu ghi nhận vào nhật ký” (289–299)

## Mục tiêu

Dựng tab **Thời gian tập** của sheet ghi nhận nhanh: nhập số phút, loại hình và mức gắng
sức, rồi lưu vào log của ngày đang xem.

## Phạm vi

- **Tạo mới:** `flutter_app/lib/src/ui/health/quick_workout_tab.dart`.
- **Sửa:** — (khung sheet đã lo phần tiêu đề/footer ở H4-S1; tab này chỉ là **thân**).
- **KHÔNG sửa:** `quick_log_sheet.dart`, `health_quick_form.dart`.

## Việc cần làm

- [x] `QuickWorkoutTab({required DateTime date, required HealthDayOverview day,
      required ValueChanged<bool> onDirtyChanged})` — `ConsumerStatefulWidget`.
- [x] Đoạn dẫn nguyên văn thiết kế: “Ghi nhận thời lượng, loại hình vận động và mức độ
      gắng sức để đồng bộ nhịp rèn luyện thể chất.”
- [x] Ô `Số phút tập luyện` (`TextField` số, suffix `phút`), prefill `day.log?.workoutMinutes`.
- [x] Ô `Loại hình bài tập` (`TextField` tự do, gợi ý nhanh dạng chip: `Chạy bộ`, `Yoga`,
      `Đạp xe`, `Bơi`), prefill `day.log?.workoutType`.
- [x] `Mức độ gắng sức`: 3 lựa chọn lớn `Tập nhẹ` / `Tập vừa` / `Tập nặng` ↔
      `nhe | vua | nang` (dùng `SegmentedTabs` hoặc 3 card có icon + phụ đề như thiết kế),
      prefill `day.log?.workoutIntensity`.
- [x] Dòng ghi chú bảo mật: icon `Icons.lock_outline` + “Dữ liệu được lưu trữ riêng tư trong
      tài khoản Memoir của bạn.”
- [x] `save()` của tab (khung gọi khi bấm “Lưu vào nhật ký”):
      `healthRepository.save(logDate: date, workoutMinutes: …, workoutType: …,
      workoutIntensity: …)`; field để trống ⇒ **không** gửi (giữ nguyên giá trị cũ).
- [x] Báo `onDirtyChanged(true)` khi người dùng sửa lần đầu (khung dùng để quyết định có
      hỏi xác nhận khi đóng hay không).
- [x] Nhập không hợp lệ (chữ, số âm, phút > 1440) ⇒ chặn lưu và hiện `errorText` ngay dưới ô.
- [ ] `flutter analyze`.

## Acceptance Criteria

1. *Given* ngày đã có `workoutMinutes: 45`, `workoutType: 'Chạy bộ'`,
   `workoutIntensity: 'vua'`, *when* mở tab, *then* 3 trường được prefill đúng.
2. *Given* nhập `50` phút + loại hình `Yoga` + chọn `Tập nhẹ` rồi lưu, *then* payload có
   `workoutMinutes: 50`, `workoutType: 'Yoga'`, `workoutIntensity: 'nhe'`.
3. *Given* chỉ nhập số phút rồi lưu, *then* `workoutType`/`workoutIntensity` **không** bị ghi
   đè thành null nếu ngày đó đã có giá trị trước đó.
4. *Given* nhập `abc` hoặc `-5`, *then* không gọi API, ô hiện lỗi, người dùng sửa được.
5. *Given* đã sửa dữ liệu rồi bấm đóng sheet, *then* khung biết là “có thay đổi chưa lưu”
   (`onDirtyChanged(true)` đã được gọi).
6. *Given* lưu thành công, *then* thẻ tóm tắt “Thời gian luyện tập” trên màn cập nhật ngay.
7. *Then* `flutter analyze` sạch; màn 390px không tràn (ô số và chip wrap được).

## Kiểm chứng

```powershell
cd flutter_app
flutter analyze
flutter run -d chrome --web-port 8080   # so tab này với memoir_ghi_nh_n_nhanh_s_c_kho/screen.png
```

## Rủi ro / ghi chú

- **Không** nhập “kcal” ở đây (thiết kế chỉ hiện kcal ở thẻ hero như ước tính; xem
  `README.md` §9).
- Giữ chuỗi mã hoá cường độ (`nhe|vua|nang`) đúng như H1-S1/H2-S3; nếu đổi, phải đổi cả
  `health_metrics.dart` (nhãn hiển thị) và test H5-S1.
- Tab chỉ **trả dữ liệu**, không tự gọi `refreshHealth` và không tự đóng sheet — khung H4-S1
  làm việc đó để ba tab hành xử giống nhau.
