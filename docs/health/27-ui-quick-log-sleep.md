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
- **Sửa:** — (khung ở H4-S1).
- **KHÔNG sửa:** `quick_log_sheet.dart`, `health_quick_form.dart`,
  `health_body_sheet.dart`.

## Việc cần làm

- [ ] `QuickSleepTab({required DateTime date, required HealthDayOverview day,
      required HealthProfile? profile, required ValueChanged<bool> onDirtyChanged})`.
- [ ] Khối tổng kết: `7h 30m` lớn + `/ 8h 00m` (mục tiêu `profile.sleepGoalHours`, default 8)
      + chip `Đạt chuẩn` khi `sleepHours >= goal`, ngược lại `Thiếu x giờ`.
- [ ] Dòng “Mục tiêu đề xuất: 7h 00m — 8h 00m mỗi đêm” (nguyên văn thiết kế).
- [ ] **Thời lượng ngủ**: 2 ô số `giờ` + `phút` (0–59) ↔ gộp thành `sleepHours` (double,
      ví dụ `7h30` ⇒ `7.5`); hoặc stepper `+/-`. Ô phút `> 59` ⇒ chặn + báo lỗi.
- [ ] **Bắt đầu đi ngủ**: `TimePicker` (`sleepBedtime`, dạng `HH:mm`), nhãn phụ theo thiết kế
      (“11:00 PM tối qua” / “Vừa xong”).
- [ ] **Giờ thức dậy**: `TimePicker` (`sleepWake`), nhãn phụ “06:30 AM sáng nay”.
- [ ] **Ngủ sâu (ước tính)**: ô số `phút` (`sleepDeepMinutes`) + dòng phụ
      `Chiếm xx% chu kỳ ngủ` = `deep / (sleepHours*60)` (làm tròn, chỉ hiện khi có cả hai).
- [ ] **Chất lượng giấc ngủ**: 3 lựa chọn có icon + phụ đề như thiết kế ⇒
      `chapChon` (“Chập chờn · Khó vào giấc, thức giấc nhiều lần”),
      `binhThuong` (“Bình thường · Đủ giấc, không quá mệt mỏi”),
      `ngonSau` (“Ngủ ngon & sâu · Thức dậy tràn đầy năng lượng”).
- [ ] **Ghi chú cảm nhận buổi sáng**: `TextField`, `maxLines: 3`, chữ mờ gợi ý theo thiết kế
      (“Thức dậy tỉnh táo, cơ thể sảng khoái…”) ⇒ `sleepNote`.
- [ ] Dòng “Lần ghi nhận gần nhất: …” — lấy từ bản ghi ngày gần nhất có `sleepHours`
      (trong `healthLogsProvider` 30 ngày), định dạng “Hôm qua 07:15” theo `createdAt`
      **giờ VN**; không có ⇒ ẩn dòng.
- [ ] `save()` của tab: `healthRepository.save(logDate: date, sleepHours: …, sleepBedtime: …,
      sleepWake: …, sleepDeepMinutes: …, sleepQuality: …, sleepNote: …)` — field bỏ trống
      không gửi.
- [ ] Kiểm tra hợp lệ: `sleepHours` trong khoảng `0–24`; `sleepDeepMinutes` không lớn hơn
      tổng thời lượng ngủ (nếu lớn hơn ⇒ cảnh báo nhưng cho phép lưu? **chốt**: chặn và báo lỗi).
- [ ] `flutter analyze`.

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
