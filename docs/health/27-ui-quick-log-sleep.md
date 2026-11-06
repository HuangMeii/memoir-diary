# H4-S4 · Tab Giờ ngủ

**Epic:** H4 · **Ước lượng:** 3 pts · **Phụ thuộc:** H4-S1
**Nguồn thiết kế:** `ui-figma/suckhoe/memoir_ghi_nh_n_gi_ng/code.html` — tiêu đề
“Ghi nhận sức khoẻ” (164–172), “Theo dõi thể trạng hôm nay” + câu quote (145–157), tổng
giấc ngủ đêm qua “7h 30m · Đạt chuẩn” (192–205), mục tiêu đề xuất “7h 00m — 8h 00m mỗi
đêm” (205–219), stepper giờ/phút (219–231), “Bắt đầu đi ngủ 11:00 PM” (231–243), “Giờ
thức dậy 06:30 AM” (231–243), “Ngủ sâu (ước tính) 1h 45m · 23%” (234–243), “Chất lượng
giấc ngủ” + 3 lựa chọn (245–278), “Ghi chú cảm nhận buổi sáng” (282–300), “Lần ghi nhận
gần nhất: Hôm qua 07:15” (302), footer `Hủy / Để sau` + lưu (302–315)

> ⚠️ Modal này **không có `screen.png` dùng được** (28 byte) — chỉ đối chiếu `code.html`.

## Mục tiêu

Dựng tab **Giờ ngủ**: nhập thời lượng ngủ, khung giờ đi ngủ/thức dậy, ngủ sâu (ước tính),
chất lượng giấc ngủ và ghi chú cảm nhận buổi sáng — lưu vào log của ngày đang xem.

## Phạm vi

- **Tạo mới:** `flutter_app/lib/src/ui/health/quick_sleep_tab.dart`.
- **Sửa:** `quick_log_sheet.dart` — thay `_TabPlaceholder` của tab Giờ ngủ bằng
  `QuickSleepTab` và cho `_save()` gọi `save()` của tab này (trước 25.10.2026 tab chỉ là
  khung “Nội dung chi tiết sẽ được bổ sung…”). Footer cũng đổi sang xếp dọc khi bề rộng
  < 420 px vì hai nhãn nút cần ~480 px (màn 390 px bị tràn 129 px).
- **KHÔNG sửa:** `health_quick_form.dart`, `health_body_sheet.dart`.

## Việc cần làm

- [x] `QuickSleepTab({required DateTime date, required HealthDayOverview day,
      HealthProfile? profile, required ValueChanged<bool> onDirtyChanged})`.
- [x] Khối tổng kết: `7h 30m` lớn + `(450 phút)` + chip `Đạt chuẩn` khi thời lượng nằm
      trong dải đề xuất, ngược lại `Thiếu x`; mục tiêu đọc từ `profile.sleepGoalHours`
      (mặc định 8h).
- [x] Dòng “Mục tiêu đề xuất: 7h 00m — 8h 00m mỗi đêm” (nguyên văn thiết kế).
- [x] **Thời lượng ngủ**: 2 ô số `giờ` + `phút` (0–59) ↔ gộp thành `sleepHours` (double,
      ví dụ `7h30` ⇒ `7.5`); ô phút `> 59` ⇒ chặn + báo lỗi “Phút phải nhỏ hơn 60”.
      Hai ô nằm trong **stepper của hero** (`7 giờ │ 30 phút`, như ảnh thiết kế), không
      còn block “Thời lượng ngủ” riêng; lỗi hiện thành caption đỏ dưới hero và tự xoá
      khi người dùng gõ.
- [x] **Bắt đầu đi ngủ**: `TimePicker` (`sleepBedtime`, dạng `HH:mm`), hiện `11:00 PM` +
      nhãn phụ “tối qua”/“hôm qua”/“Chưa ghi nhận”.
- [x] **Giờ thức dậy**: `TimePicker` (`sleepWake`), nhãn phụ “sáng nay”/“hôm nay”.
- [x] **Ngủ sâu (ước tính)**: ô số `phút` (`sleepDeepMinutes`) + dòng phụ
      `Chiếm xx% chu kỳ ngủ` = `deep / totalMinutes` (làm tròn, chỉ hiện khi có cả hai).
- [x] **Chất lượng giấc ngủ**: 3 lựa chọn có icon + phụ đề như thiết kế ⇒
      `chapChon` (“Chập chờn · Khó vào giấc, thức giấc nhiều lần”),
      `binhThuong` (“Bình thường · Đủ giấc, không quá mệt mỏi”),
      `ngonSau` (“Ngủ ngon & sâu · Thức dậy tràn đầy năng lượng”).
- [x] **Ghi chú cảm nhận buổi sáng**: `TextField`, `maxLines: 3`, chữ mờ gợi ý theo thiết kế
      (“Thức dậy tỉnh táo, cơ thể sảng khoái…”) ⇒ `sleepNote`.
- [x] Dòng “Lần ghi nhận gần nhất: …” — lấy từ bản ghi **trước ngày đang xem** có
      `sleepHours` (trong `healthLogsProvider` 30 ngày); hiển thị ở **footer của sheet**
      (trái, cạnh nút Huỷ/Lưu) đúng như ảnh thiết kế; không có ⇒ ẩn dòng.
- [x] `save()` của tab: `healthRepository.save(logDate: date, sleepHours: …, sleepBedtime: …,
      sleepWake: …, sleepDeepMinutes: …, sleepQuality: …, sleepNote: …)` — field bỏ trống
      không gửi.
- [x] Kiểm tra hợp lệ: `sleepHours` trong khoảng `0–24`; `sleepDeepMinutes` không lớn hơn
      tổng thời lượng ngủ (chặn và báo lỗi).
- [x] `flutter analyze` + `test/quick_sleep_tab_test.dart` (5 test: prefill, tính lại tổng,
      chặn phút ≥ 60, chặn ngủ sâu > tổng, sheet 390 px mở đúng form và không tràn).


## Acceptance Criteria

1. *Given* ngày có `sleepHours: 7.5`, `sleepBedtime: '23:00'`, `sleepWake: '06:30'`,
   `sleepDeepMinutes: 105`, `sleepQuality: 'ngonSau'`, *then* mọi trường prefill đúng và
   khối tổng hiện `7h 30m / 8h 00m` + chip `Đạt chuẩn`.
2. *Given* nhập `7` giờ `30` phút + ngủ sâu `105` phút, *then* payload có
   `sleepHours: 7.5`, `sleepDeepMinutes: 105` và dòng phụ hiện `Chiếm 23% chu kỳ ngủ`.
3. *Given* chọn chất lượng “Ngủ ngon & sâu”, *then* payload có `sleepQuality == 'ngonSau'`.
4. *Given* nhập ô phút `75`, *then* không gọi API và hiện lỗi “Phút phải nhỏ hơn 60”.
5. *Given* ngày hôm qua có ghi nhận ngủ lúc 07:15 (giờ VN), *then* dòng cuối hiện
   “Lần ghi nhận gần nhất: Hôm qua 07:15”.
6. *Given* lưu thành công, *then* thẻ “Giấc ngủ” trên màn và timeline cập nhật ngay.
7. *Then* `flutter analyze` sạch; màn 390px không tràn.

## Kiểm chứng

```powershell
cd flutter_app
flutter analyze
flutter run -d chrome --web-port 8080   # so tab Ngủ với memoir_ghi_nh_n_gi_ng/code.html
```

## Rủi ro / ghi chú

- **Giờ ngủ vắt qua nửa đêm** (23:00 → 06:30): đừng tính tổng bằng hiệu hai giờ; tổng là
  `sleepHours` người dùng nhập (thiết kế cũng hiển thị tổng riêng).
- `sleepBedtime`/`sleepWake` là **chuỗi `HH:mm`** (H1-S1) — không gửi `DateTime`.
- “Ngủ sâu” là **ước tính** của người dùng: UI phải ghi rõ “(ước tính)” như thiết kế, không
  khẳng định là số đo.
- Giữ nguyên mã chất lượng (`chapChon|binhThuong|ngonSau`) khớp H1-S1 và nhãn ở H2-S6
  (`waterBreakdownOf`/`TrendSummary` không phụ thuộc, nhưng thẻ hero H3-S2 có dùng).

## Đã dựng (25.10.2026)

- `quick_sleep_tab.dart` (+ `test/quick_sleep_tab_test.dart`), nối vào `quick_log_sheet.dart`.
- **Khác thiết kế — dòng “Lần ghi nhận gần nhất”:** `HealthLog` của client **không** mang
  `createdAt`, nên dòng này chỉ nêu **ngày** (`Hôm qua` / `dd/MM`), không bịa giờ `07:15`.
  Muốn có giờ thì phải thêm `createdAt` vào `HealthLog` (H1-S2/H1-S4) trước.
- **Khác thiết kế — chip tổng kết:** `Đạt chuẩn` tính theo **dải đề xuất**
  `sleepGoalHours - 1h … sleepGoalHours` (mặc định `7h 00m — 8h 00m`), không phải
  `>= goal`; nếu lấy `>= goal` thì chính ảnh thiết kế (`7h 30m`, mục tiêu `8h 00m`,
  chip `Đạt chuẩn`) sẽ tự mâu thuẫn. Thiếu bao nhiêu so với **cận dưới** thì hiện ở chip.
- **Footer sheet:** hai nút xếp dọc khi bề rộng < 420 px (trước đó tràn 129 px ở 390 px).
- Tab Nước vẫn là `_TabPlaceholder` (H4-S3 chưa làm) — sheet sẽ báo
  “Tab Uống nước chưa được triển khai” nếu bấm lưu ở tab đó.

## Đồng bộ với ảnh thiết kế (25.10.2026)

Đối chiếu `screen.png` của modal ngủ (ảnh 1) với bản web (ảnh 2) và sửa 5 chỗ lệch:

| Khu vực | Trước | Sau (theo ảnh 1) |
|---|---|---|
| Header | chỉ tiêu đề + `IconButton` X | badge tròn 36 px (`Icons.self_improvement` ≈ `mindfulness`) + tiêu đề + phụ đề + nút X **tròn viền** 32 px; nền tint + hairline dưới |
| Ngày đang xem | dòng “Ngày dd/MM/yyyy” riêng | gộp vào phụ đề: “cho ngày hôm nay” / “cho ngày dd/MM/yyyy” |
| Tab strip | `SegmentedTabs` (pill, không icon) | tab **gạch chân** có icon 18 px, active primary + viền dưới 2 px |
| Thời lượng ngủ | block riêng dưới hero, 2 `TextField` to | **stepper trong hero**: ô trắng viền `7 giờ │ 30 phút` (ô số 30 px, `InputBorder.none`) |
| Tile giờ | không icon `schedule`, caption “tối qua” | thêm `Icons.schedule`; icon thức dậy màu hổ phách (`healthMetricPeak`); caption lặp giá trị (`11:00 PM tối qua`) |
| Tile ngủ sâu | `TextField` viền + suffix | ô số 19 px semibold màu primary, không viền, caption `Chiếm xx% chu kỳ ngủ` (đổi sang chữ đỏ khi lỗi) |
| Footer | dòng lịch sử nằm cuối tab, nút huỷ `TextButton`, cả khối cùng cuộn | dòng lịch sử **ở footer** (`Icons.history`), nút huỷ `OutlinedButton`, header/tab/footer **cố định** — chỉ thân tab cuộn |
| Khung | 1 `ListView` chứa tất cả | `Column` = header + tab strip + `Expanded(ListView)` + footer |

- Helper thuần mới trong `health_metrics.dart`: `lastSleepLogBefore()` và
  `shortDayLabel()` (footer dùng chung với test, không lặp logic).
- Bề rộng modal giữ **560** (khớp ảnh 1 và cho ra 3 cột tile/card); `code.html` ghi
  `max-w-[700px]` — nếu muốn rộng hơn chỉ cần thêm `maxWidth: 700` vào `showHealthModal`
  trong `showQuickLogSheet`.
- Vẫn **không** hiện được giờ `07:15` trong dòng lịch sử: `HealthLog` không có
  `createdAt` (xem mục trên).

