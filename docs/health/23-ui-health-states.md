# H3-S9 · States: loading / empty / error / thiếu dữ liệu

**Epic:** H3 · **Ước lượng:** 2 pts · **Phụ thuộc:** H3-S8
**Nguồn thiết kế:** `ui-figma/suckhoe/memoir_s_c_kho_th_ch_t_t_i_gi_n/screen.png`
(trạng thái có dữ liệu) — các trạng thái còn lại do bộ task này quy định, vì Stitch chỉ
xuất một trạng thái

## Mục tiêu

Chốt hành vi của màn Sức khoẻ khi dữ liệu chưa về, lỗi, hoặc người dùng mới chưa có gì —
để không bao giờ thấy màn trắng, `NaN`, hay số mẫu của thiết kế.

## Phạm vi

- **Sửa:** `ui/screens/health_screen.dart` + các widget `ui/health/*` (thêm tham số/nhánh
  trạng thái), có thể thêm `ui/health/health_states.dart` nếu cần widget dùng chung.
- **KHÔNG sửa:** `ui/notes/notes_states.dart` (chỉ tham chiếu cách làm).

## Việc cần làm

- [ ] **Loading lần đầu**: khung xương/panel xám (`palette.surfaceDisabled`) cho 3 thẻ
      hero + khối xu hướng; **không** dùng spinner toàn màn để tránh nhảy bố cục.
- [ ] **Lỗi nạp** (`AsyncError`): panel có icon `Icons.error_outline`, câu “Không tải được
      dữ liệu sức khoẻ”, nút “Thử lại” ⇒ `ref.invalidate(healthDayProvider(_date))` (và
      provider tương ứng của khối lỗi).
- [ ] **Ngày trống** (`overview.log == null` và `water`/`activities` rỗng):
  - thẻ hero hiện `--` + `/ mục tiêu` lấy từ profile;
  - form trống sẵn để nhập, kèm câu mời “Hôm nay chưa ghi nhận gì. Bắt đầu với một chỉ số nhỏ.”;
  - timeline hiện trạng thái trống + nút `+ Thêm mốc` (H3-S5);
  - **không** hiện khối biến động/MBI… (đã có nhánh riêng).
- [ ] **Kỳ xu hướng không có điểm nào** (`daysWithData == 0`): khối xu hướng hiện câu
      “Chưa đủ dữ liệu trong kỳ này” + gợi ý chọn kỳ ngắn hơn; **không** vẽ 30 cột 0.
- [ ] **Thiếu thông số cơ thể** (`profile == null` hoặc thiếu chiều cao): thẻ BMI trong
      drawer hiện “Chưa đủ dữ liệu để tính BMI” và mời nhập chiều cao; khối tiến độ đích
      ẩn hẳn (không hiện 0%).
- [ ] **Mất mạng khi lưu**: mọi hành vi ghi giữ dữ liệu người dùng đã nhập, hiện snackbar
      lỗi (không đóng sheet để họ thử lại), và **không** tự ý ghi giá trị mặc định.
- [ ] Đảm bảo không xuất hiện `NaN`/`Infinity` ở mọi trường hợp chia cho 0 (mục tiêu = 0,
      chiều cao = 0, chưa có dữ liệu).
- [ ] `flutter analyze`.

## Acceptance Criteria

1. *Given* provider đang tải, *then* màn hiện khung xương, không nhảy bố cục khi dữ liệu về.
2. *Given* provider ném lỗi, *then* hiện panel lỗi có nút “Thử lại”; bấm “Thử lại” ⇒ gọi
   lại provider đúng ngày đang xem.
3. *Given* ngày trống, *then* không thấy `NaN`, không thấy số mẫu (216.000/7.200/24/30),
   và form vẫn nhập được.
4. *Given* kỳ 90 ngày mà không có dữ liệu, *then* khối xu hướng hiện trạng thái trống.
5. *Given* chưa có chiều cao, *then* thẻ BMI hiện câu mời nhập, không hiện số.
6. *Given* tắt mạng rồi bấm “Lưu chỉ số”, *then* ô nhập giữ nguyên giá trị, có snackbar lỗi,
   không đóng form.
7. *Then* `flutter analyze` sạch; `flutter test` xanh.

## Kiểm chứng

```powershell
cd flutter_app
flutter analyze
flutter test
flutter run -d chrome --web-port 8080
# thử tay: đổi ngày sang ngày tương lai (trống), tắt mạng rồi lưu
```

## Rủi ro / ghi chú

- Stitch **không** xuất ảnh cho các state này ⇒ tiêu chí ở đây là hợp đồng: không nhảy bố
  cục, không số giả, luôn có đường thoát (Thử lại / nhập mới).
- Trạng thái trống phải dùng **cùng** widget với trạng thái có dữ liệu (khác nhánh), tránh
  dựng hai bố cục song song rồi lệch nhau về sau.
- Nếu cần thêm chuỗi tiếng Việt mới, giữ văn phong “dịu, ngắn, không phán xét” như phần
  còn lại của sản phẩm.
