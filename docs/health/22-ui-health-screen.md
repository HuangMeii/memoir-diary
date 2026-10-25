# H3-S8 · Viết lại `health_screen.dart` + nav “Sức khoẻ”

**Epic:** H3 · **Ước lượng:** 3 pts · **Phụ thuộc:** H3-S2…H3-S7
**Nguồn thiết kế:** `ui-figma/suckhoe/memoir_s_c_kho_th_ch_t_t_i_gi_n/screen.png`
(toàn trang) và `…_bmi/code.html` (bố cục 2 cột 65/35 — dòng 241–521)

## Mục tiêu

Thay màn `HealthScreen` tối giản bằng dashboard đầy đủ của thiết kế: chrome chung
(`AppHeader`), breadcrumb + header, dải ngày, 3 thẻ hero, form nhập nhanh, khối xu hướng,
cột phải (timeline + quote), và mở được sheet ghi nhận nhanh / drawer thông số.

## Phạm vi

- **Viết lại:** `flutter_app/lib/src/ui/screens/health_screen.dart`.
- **Sửa:** `flutter_app/lib/src/ui/widgets/app_header.dart` — thêm `AppDestination.health`
  (`'Sức khoẻ'`) vào enum + nhánh điều hướng.
- **Dùng:** `ui/health/health_chrome.dart`, `health_summary_cards.dart`,
  `health_quick_form.dart`, `health_trends.dart`, `health_timeline.dart`,
  `health_quote_card.dart`, `quick_log_sheet.dart` (H4), `health_body_sheet.dart` (H3-S7).
- **KHÔNG sửa:** `ui/home/shortcut_cards.dart` (`HealthScreen.new` vẫn đúng),
  `main.dart` (không thêm route), `monthSummaryProvider`.

## Việc cần làm

- [x] `HealthScreen` là `ConsumerStatefulWidget` với state cục bộ: `_date` (mặc định hôm
      nay theo **giờ VN**), `_metric` (`HealthMetric.steps`), `_range`
      (`HealthTrendRange.month`).
- [x] Dựng: `AppHeader(date: _date, initials: initialsOf(displayName), onLogout: …,
      destination: AppDestination.health, name: displayName)` (copy cách `HomeScreen`/
      `NotesScreen` đang lấy `displayName`).
- [x] Nội dung trong `SingleChildScrollView` + `Center` + `ConstrainedBox(maxWidth: 1200)`,
      `HomeScale` theo bề rộng như các màn khác:
  1. `HealthBreadcrumb` + `HealthPageHeader(date: _date, onPrevious/onNext/onDate, onQuickLog)`;
  2. `HealthContextBanner`;
  3. `HealthSummaryCards(day: overview, profile: profile)`;
  4. Bố cục 2 cột (`LayoutBuilder`: `>= 1000px` ⇒ 65/35, ngược lại xếp dọc):
     - trái: `HealthQuickForm(...)` rồi `HealthTrends(metric: _metric, range: _range, …)`;
     - phải: `HealthJournalBridgeCard(...)`, `HealthTimeline(...)`,
       `HealthGentleReminderCard()`.
- [x] Nguồn dữ liệu: `ref.watch(healthDayProvider(_date))` cho thẻ/form/timeline và
      `ref.watch(healthTrendsProvider((from: …, to: …, metric: _metric)))` +
      `ref.watch(healthProfileProvider)` cho xu hướng/đích mục tiêu.
- [x] Hành vi:
  - `onQuickLog` ⇒ `showQuickLogSheet(...)` với tab mặc định `Thời gian tập` (H4-S1);
  - `onOpenBodySheet` (từ form) ⇒ `showHealthBodySheet(...)` (H3-S7);
  - sau **mọi** hành vi ghi ⇒ `refreshHealth(ref, day: _date)` (H2-S5) **thay vì**
    đoạn `ref.invalidate(healthLogsProvider)`/`monthSummaryProvider` cũ (dòng 87–91).
- [x] **Gỡ bỏ** khỏi màn: `_NumField`, `_Stat`, `_LineChart`, `_DayPicker`, `_prefill`,
      `_range` cũ và logic `substring(0, 10)` (đã thay bằng helper chung + provider).
- [x] Giữ mở màn bằng `Navigator.push` (thẻ shortcut) — không đổi `main.dart`.
- [x] `flutter analyze ; flutter test`.

## Acceptance Criteria

1. *Given* mở màn Sức khoẻ từ thẻ shortcut, *then* thấy header chung, breadcrumb, tiêu đề
   serif, dải ngày hôm nay, 3 thẻ hero, form, khối xu hướng, timeline và card quote —
   không còn `AppBar` riêng + `Card('NHẬP NHANH')` của bản cũ.
2. *Given* bấm `‹` (ngày trước), *then* **mọi** khối (thẻ hero, form, timeline, xu hướng)
   hiển thị dữ liệu của ngày đó.
3. *Given* thêm một lần uống nước từ sheet ghi nhận nhanh, *then* thẻ nước, form, timeline
   và tổng hợp tháng đều cập nhật mà **không** tải lại trang.
4. *Given* màn 390px, *then* một cột, không tràn (`tester.takeException()` null);
   `>= 1000px` ⇒ hai cột 65/35.
5. *Given* header ở màn Sức khoẻ, *then* mục nav “Sức khoẻ” đang được chọn (không đổi vị
   trí 3 mục nav hiện có).
6. *Then* `AppDestination.health` tồn tại và các màn khác (Trang chủ/Lưới tháng/Lịch sử kiện)
   vẫn hoạt động; `flutter analyze` sạch, `flutter test` xanh.

## Kiểm chứng

```powershell
cd flutter_app
flutter analyze
flutter test
flutter run -d chrome --web-port 8080   # so toàn trang với ..._s_c_kho.../screen.png
Select-String -Path 'lib\src\ui\widgets\app_header.dart' -Pattern 'health'
```

## Rủi ro / ghi chú

- `monthSummaryProvider` đọc cả health: nếu bỏ `refreshHealth` thì số liệu “Nhịp viết”
  của trang chủ sẽ cũ — đây là lý do helper đó invalidate cả provider này.
- `AppDestination` chỉ thêm **một** giá trị (`health`); thiết kế còn “Việc cần làm”,
  “Ghi chú”, “Nhật ký” trong nav — ngoài phạm vi, đừng thêm hàng loạt trong task này.
- Đừng đổi chữ ký `HealthScreen()` (const, không tham số): `shortcut_cards.dart` gọi
  `HealthScreen.new`.
- **Layout 390 px:** lưới 3 thẻ hero nằm trong `SingleChildScrollView` (height vô hạn), nên
  `HealthSummaryCards` phải bọc `IntrinsicHeight` quanh `Row(stretch)` — thiếu nó,
  `stretch` đòi infinite height và cả trang trắng. `AppHeader` ẩn dòng ngày (< 460) và
  chuyển nút đăng xuất sang icon-only ở cùng ngưỡng; `HealthDateNavigator` cho nhãn
  ellipsis. `test/health_screen_test.dart` canh cả 390 px lẫn 1904 px.
