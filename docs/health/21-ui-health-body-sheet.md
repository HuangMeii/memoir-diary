# H3-S7 · Drawer “Thông số cá nhân & Thể trạng” (BMI)

**Epic:** H3 · **Ước lượng:** 5 pts · **Phụ thuộc:** H2-S6
**Nguồn thiết kế:** `ui-figma/suckhoe/memoir_c_p_nh_t_th_ng_s_c_nh_n_bmi/code.html`
dòng 539–720 — header (545–558), cân nặng hiện tại + stepper `−0.5 −0.1 +0.1 +0.5`
(562–603), chiều cao “Cố định · Dùng làm mốc tính chỉ số BMI & BMR” (585–603), thẻ BMI
21.4 + spectrum + 4 mốc (604–642), tiến độ cân nặng mục tiêu (643–661), “Biến động cân
nặng” + pill *4 tuần / 6 tháng* (662–706), quote (707–713), footer *Hủy* / *Lưu thay đổi*
(715–720)

## Mục tiêu

Dựng drawer phải, mở từ nút *Thông số* trên header màn Sức khoẻ
(`HealthPageHeader.onOpenBodySheet`, H3-S8 — trước 25.10.2026 là nút trong form H3-S3):
sửa cân nặng + chiều cao, xem **BMI
tự tính** và phân loại IDI & WPRO, xem tiến độ tới cân nặng mục tiêu và biến động cân nặng
4 tuần / 6 tháng, rồi lưu — ghi cân nặng vào **log ngày** và chiều cao/mục tiêu vào **profile**.

## Phạm vi

- **Tạo mới:** `flutter_app/lib/src/ui/health/health_body_sheet.dart`.
- **Dùng:** `health_metrics.dart` (BMI, định dạng), `healthLogsProvider` (chuỗi cân nặng),
  `healthProfileProvider`.
- **KHÔNG sửa:** `health_quick_form.dart`, `models.dart`, `providers.dart`.

## Việc cần làm

- [x] `showHealthBodySheet(BuildContext, {required DateTime date, required WidgetRef ref})`
      — qua `showHealthModal` (25.10.2026): `< 700 px` là bottom sheet
      (`isScrollControlled: true`, `useSafeArea: true`), `≥ 700 px` là **dialog giữa
      màn hình** (`Dialog` + `ConstrainedBox(maxWidth: 560, maxHeight: 86 %)`, nền mờ bấm
      ra ngoài để đóng). Panel thực có key `healthModalPanelKey` để test đo được.
- [x] **Cân nặng hiện tại**: `TextField` số (1 số lẻ) prefill từ cân nặng **gần nhất**
      (ngày đang chọn, nếu trống thì bản ghi có cân nặng mới nhất trong 90 ngày).
- [x] 4 nút stepper `−0.5`, `−0.1`, `+0.1`, `+0.5` cộng/trừ giá trị đang hiển thị;
      chặn dưới `0`; mỗi lần bấm chỉ đổi ô nhập (chưa gọi API).
- [ ] **Chiều cao (cm)**: `TextField` số, helper “Cố định · Dùng làm mốc tính chỉ số
      BMI & BMR” (chỉ ghi vào `profile.heightCm`, không theo ngày).
- [ ] Thẻ **BMI**: `bmiOf(weightKg, heightCm)` + `bmiZoneOf`:
  - số lớn 1 số thập phân + nhãn phân loại (“Trọng lượng chuẩn”, “Gầy”, “Thừa cân”, “Béo phì”);
  - dòng chú thích “Thể trạng cân đối theo chuẩn Châu Á (IDI & WPRO)”;
  - **spectrum**: `LinearGradient` từ `healthBmiUnder` → `healthBmiNormal` →
    `healthBmiOver`; kim chỉ ở `((bmi - 15) / 20).clamp(0, 1)` (dải 15–35);
  - 4 nhãn mốc: `Gầy (<18.5)`, `Chuẩn (18.5 - 22.9)`, `Thừa cân (23 - 24.9)`, `Béo phì (≥25)`;
  - thiếu cân nặng/chiều cao ⇒ hiện “Chưa đủ dữ liệu để tính BMI” (không hiện NaN).
- [ ] **Cân nặng mục tiêu**: `weightGoalKg` (mặc định điền từ profile; rỗng ⇒ ẩn khối),
      thanh tiến độ tính từ `weightStartKg → weightGoalKg → cân nặng hiện tại`:
      “Còn 1.2 kg”, “Khởi điểm: 61.0 kg”, “Đã giảm 2.8 kg (70% chặng đường)”,
      “Đích: 57.0 kg” (dùng `healthTrendUp` cho phần đã đạt); nếu tăng cân ⇒ câu
      tương ứng (không hiện số âm mơ hồ).
- [ ] **Biến động cân nặng** (làm lại theo thiết kế gốc, 25.10.2026): icon `trending_down`
      + tiêu đề + pill `4 tuần / 3 tháng / 6 tháng` (`SegmentedTabs<WeightRange>`);
      câu phụ “Giảm 0.6 kg trong 4 tuần qua một cách lành mạnh”, hoặc
      “Chưa đủ dữ liệu trong 4 tuần qua để thấy biến động”;
  - **4 card** đều nhau (`Wrap`: 4 cột, `< 380 px` ⇒ 2 cột): `Tuần 1/2/3` + `Hôm nay`,
    mỗi card gồm label – số kg – caption (`dd/MM` ở card đầu, `±x.y kg` ở các card sau,
    `--` khi thiếu); card “Hôm nay” nền `surfaceBrandSubtle`, viền primary, chữ primary;
  - số liệu từ `weightCardsOf` (thuần, `health_metrics.dart`): chia cửa sổ 28 / 90 / 180
    ngày thành 4 kỳ bằng nhau — 3 kỳ đầu lấy **trung bình**, card cuối lấy **lần cân mới
    nhất**; mốc **sau hôm nay bị bỏ qua**;
  - **không còn** ô nhập tay `Cân nặng (kg)` / `Thời gian`, chip Ngày/Tuần/Tháng hay nút
    `Thêm`: số cân nhập ở field “Cân nặng hiện tại (kg)” phía trên và lưu bằng
    `Lưu thay đổi`.
- [ ] **Quote** khối cuối: nguyên văn thiết kế “Cân nặng chỉ là một chỉ số tham khảo,
      không định nghĩa giá trị của bạn. Hãy lắng nghe nguồn năng lượng và sự nhẹ nhõm của
      cơ thể mỗi ngày.”
- [ ] **Lưu thay đổi**:
  1. lưu cân nặng vào log ngày đang chọn: `save(logDate: date, weightKg: …)`
     (**không** gửi các field khác — giữ nguyên nguyên tắc `toPayload` chỉ gửi field khác null);
  2. lưu `profileSave(heightCm: …, weightGoalKg: …, weightStartKg: …)` — `weightStartKg`
     chỉ ghi khi người dùng chưa có (hoặc khi họ bấm “Đặt lại khởi điểm”);
  3. `refreshHealth(ref, day: date)` + đóng sheet + snackbar “Đã lưu thay đổi”.
- [ ] **Hủy**: đóng sheet, không gọi API, không giữ giá trị đã sửa.
- [ ] `flutter analyze`.

## Acceptance Criteria

1. *Given* `weightKg: 58.2`, `heightCm: 165`, *then* thẻ BMI hiện `21.4`, nhãn
   “Trọng lượng chuẩn”, kim chỉ ở ~`0.32` của dải 15–35 và mốc “Chuẩn (18.5 - 22.9)”
   được làm nổi.
2. *Given* bấm `+0.1` ở ô cân nặng, *then* giá trị thành `58.3` và BMI tính lại ngay
   (không cần lưu, không gọi API).
3. *Given* bấm `−0.5` ba lần, *then* giá trị giảm đúng 1.5 và **không** xuống dưới 0.
4. *Given* `weightGoalKg: 57.0`, `weightStartKg: 61.0`, cân nặng hiện tại `58.2`, *then*
   khối tiến độ hiện “Còn 1.2 kg”, “Đã giảm 2.8 kg (70% chặng đường)”, “Đích: 57.0 kg”.
5. *Given* bấm “Lưu thay đổi”, *then* log của **ngày đang chọn** nhận `weightKg` mới,
   profile nhận `heightCm`/`weightGoalKg`, và màn Sức khoẻ cập nhật ngay (biểu đồ/timeline).
6. *Given* bấm “Hủy”, *then* không có request nào được gửi và giá trị cũ còn nguyên khi
   mở lại drawer.
7. *Given* chỉ có 1 lần cân trong cửa sổ, *then* 3 card kỳ hiện `--` và câu phụ là
   “Chưa đủ dữ liệu trong 4 tuần qua để thấy biến động”.
8. *Given* các lần cân 59.0 / 58.8 (Tuần 1), 58.6 (Tuần 2), 58.4 (Tuần 3), 58.3 (hôm nay),
   *then* 4 card hiện `Tuần 1 58.9`, `Tuần 2 58.6 -0.3 kg`, `Tuần 3 58.4 -0.2 kg`,
   `Hôm nay 58.3 -0.1 kg` và câu phụ “Giảm 0.6 kg trong 4 tuần qua một cách lành mạnh”.
9. *Given* một mốc có ngày **sau hôm nay**, *then* mốc đó bị bỏ qua (không lên card
   “Hôm nay”, không ảnh hưởng câu phụ).
10. *Then* `flutter analyze` sạch; màn 390px cuộn được trong sheet, không tràn.

## Kiểm chứng

```powershell
cd flutter_app
flutter analyze
flutter run -d chrome --web-port 8080   # so drawer với ..._bmi/screen.png
flutter test test\health_test.dart      # BMI/threshold (H5-S1)
```

## Rủi ro / ghi chú

- **Hai đích ghi khác nhau**: cân nặng ⇒ `health_logs` (theo ngày), chiều cao/mục tiêu ⇒
  `health_profiles`. Nếu lần lưu thứ hai lỗi, hiện cảnh báo “Chỉ lưu được cân nặng” thay
  vì báo thành công.
- BMI/spectrum dùng **cùng** `bmiOf`/`bmiZoneOf` của H2-S6 — không viết lại công thức
  trong widget để test có giá trị.
- BMR: hiện **chỉ** là chữ trong helper của thiết kế; không tính BMR/kcal (ngoài phạm vi).
- Drawer không tự gọi `day(...)`: nhận dữ liệu qua provider/`ref` đã truyền vào để tránh
  thêm request khi mở.
