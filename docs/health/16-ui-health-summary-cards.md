# H3-S2 · 3 thẻ tóm tắt hero

**Epic:** H3 · **Ước lượng:** 3 pts · **Phụ thuộc:** H3-S1
**Nguồn thiết kế:** `ui-figma/suckhoe/memoir_c_p_nh_t_th_ng_s_c_nh_n_bmi/code.html`
dòng 244–246 (grid `sm:grid-cols-3`) và 249–316 (chi tiết nước theo buổi)

## Mục tiêu

Dựng ba thẻ tóm tắt ngày: **Thời gian luyện tập**, **Nước uống** (kèm phân bố theo
buổi), **Giấc ngủ** — mỗi thẻ có số chính, mục tiêu và vòng/phần trăm tiến độ.

## Phạm vi

- **Tạo mới:** `flutter_app/lib/src/ui/health/health_summary_cards.dart`.
- **Dùng:** `health_metrics.dart` (H2-S6) cho phân buổi/định dạng; token health của H0-S1.
- **KHÔNG sửa:** `health_chrome.dart`, `health_quick_form.dart`.

## Việc cần làm

- [ ] `HealthSummaryCards({required HealthDayOverview day, required HealthProfile profile})`
      → `LayoutBuilder`: `< 768px` 1 cột, `>= 768px` 3 cột bằng nhau.
- [ ] Thẻ **Thời gian luyện tập** (`Icons.fitness_center`):
  - số lớn `45 phút` + `/ 60 phút` (mục tiêu `profile.workoutGoalMinutes`);
  - chip `75% Mục tiêu` = `workoutMinutes / goal * 100` (làm tròn);
  - dòng phụ: cường độ (“Tập vừa”) khi có `workoutIntensity`.
- [ ] Thẻ **Nước uống** (`Icons.water_drop`):
  - số `1.750` + `/ 2.000 ml` (dùng `formatMl`);
  - phần trăm từ `waterBreakdownOf(day.water)`;
  - **3 dòng phân buổi**: `Sáng 750 ml · 3 lần nạp`, `Chiều 800 ml · Cao nhất`,
    `Tối 200 ml · 1 lần nạp`; buổi trống hiển thị `0 ml` (không ẩn dòng);
  - dòng cuối: `7 lần uống · Gần nhất 14:30` (`formatClock`).
- [ ] Thẻ **Giấc ngủ** (`Icons.bedtime`):
  - `7h 30m` + `/ 8h 00m` (`formatSleepDuration`);
  - chip chất lượng (`Rất tốt` / `Bình thường` / `Chập chờn`) suy từ `sleepQuality`;
  - dòng `23:00 - 06:30` (`sleepBedtime` – `sleepWake`) và `Sâu 1h 45m · 23%`
    (`sleepDeepMinutes / sleepHours * 60`).
- [ ] Vòng/thanh tiến độ: dùng màu token `healthWaterAccent` và `healthSleepAccent`;
      thẻ tập dùng `colorScheme.primary` (thiết kế dùng sage sẵn có).
- [ ] Thẻ thiếu dữ liệu: hiện `--` cho số chính và ẩn vòng tiến độ (chi tiết ở H3-S9).
- [ ] `flutter analyze`.

## Acceptance Criteria

1. *Given* `workoutMinutes: 45`, `workoutGoalMinutes: 60`, *then* thẻ tập hiện `45 phút`,
   `/ 60 phút` và `75%`.
2. *Given* 3 lần uống `750/800/200` ml, *then* thẻ nước hiện tổng `1.750`,
   `/ 2.000 ml`, phân buổi đúng thứ tự **Sáng → Chiều → Tối**, buổi lớn nhất có nhãn
   “Cao nhất”.
3. *Given* `sleepHours: 7.5`, `sleepDeepMinutes: 105`, `sleepBedtime: '23:00'`,
   `sleepWake: '06:30'`, *then* thẻ ngủ hiện `7h 30m`, `/ 8h 00m`, `23:00 - 06:30`,
   `Sâu 1h 45m · 23%`.
4. *Given* ngày chưa có nước, *then* thẻ nước hiện `0`, phân buổi đều `0 ml` và
   **không** hiện “Gần nhất …”.
5. *Given* màn 390px, *then* ba thẻ xếp dọc, không tràn; 1440px ⇒ một hàng 3 thẻ.
6. *Then* mọi màu lấy từ token/`Theme.of` (không hex trực tiếp); `flutter analyze` sạch.

## Kiểm chứng

```powershell
cd flutter_app
flutter analyze
flutter run -d chrome --web-port 8080   # so 3 thẻ với dòng 244 của code.html / screen.png
```

## Rủi ro / ghi chú

- Phần trăm có thể vượt 100 (ví dụ tập 90/60 phút): **kẹp** thanh tiến độ ở 100 nhưng
  vẫn hiển thị số phần trăm thật, hoặc hiện `150%` — chốt một cách và ghi trong PR.
- “kcal” trong thiết kế (`~240 kcal`) **không** thuộc task này (chưa có công thức, xem
  `README.md` §9); nếu vẫn muốn hiện, chỉ hiện khi có `workoutMinutes` và ghi rõ là ước tính.
- Không đọc provider trong widget này: nhận `HealthDayOverview` từ màn để dễ test.
