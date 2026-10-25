# H3-S1 · Chrome trang + date navigator + banner

**Epic:** H3 · **Ước lượng:** 2 pts · **Phụ thuộc:** H2-S5
**Nguồn thiết kế:** `ui-figma/suckhoe/memoir_c_p_nh_t_th_ng_s_c_nh_n_bmi/code.html`
dòng 192–240 — breadcrumb (195), `h1` “Sức khoẻ & Thể chất” (206), date navigator
‹ Hôm nay, 17/10/2026 › (213–224), 2 nút *Xuất báo cáo* / *+ Ghi nhận nhanh* (226–235),
banner “Nhật ký sức khoẻ cá nhân hôm nay sẵn sàng để ghi nhận và theo dõi.” (237–240)

## Mục tiêu

Dựng phần đầu trang của dashboard: breadcrumb, tiêu đề biên tập + phụ đề, dải chọn
ngày, hai nút hành động và banner ngữ cảnh.

## Phạm vi

- **Tạo mới:** `flutter_app/lib/src/ui/health/health_chrome.dart`.
- **KHÔNG sửa:** `ui/widgets/app_header.dart` (mục “Sức khoẻ” thêm ở H3-S8),
  `ui/notes/notes_chrome.dart` (chỉ tham chiếu cách làm).

## Việc cần làm

- [ ] `HealthBreadcrumb({VoidCallback? onHome})` — “Trang chủ” (icon `arrow_back`)
      `/` “Sức khoẻ & Thể chất” (đậm, `colorScheme.primary`); mặc định
      `Navigator.of(context).maybePop()` như `NotesBreadcrumb`.
- [ ] `HealthPageHeader`:
  - `h1` “Sức khoẻ & Thể chất” — `serifFamily`, `MemoirType.headingPage`.
  - Phụ đề đúng nguyên văn thiết kế: “Lắng nghe cơ thể, nuôi dưỡng nhịp sống cân bằng
    và chăm sóc bản thân mỗi ngày.”
  - `HealthDateNavigator(date, onPrevious, onNext, onToday)` — `OutlinedButton`/`IconButton`
    `chevron_left` + nhãn `Hôm nay, dd/MM/yyyy` (`Icons.calendar_today` bên trái) +
    `chevron_right`; bấm nhãn ⇒ `showDatePicker` chọn ngày khác.
  - Nút **“+ Ghi nhận nhanh”** (`FilledButton.icon`, `Icons.add_circle`) ⇒ gọi
    `onQuickLog` (mở sheet H4-S1).
  - Nút **“Thông số”** (`OutlinedButton.icon`, `Icons.monitor_weight_outlined`, thêm
    25.10.2026) ⇒ gọi `onOpenBodySheet` (drawer BMI H3-S7).
  - Nút **“Xuất báo cáo”** trong thiết kế **đã gỡ khỏi giao diện ngày 25.10.2026** —
    trước đó là nút chết (`onPressed: null` + `Tooltip('Sẽ có sau')`), không có code
    tính năng phía sau.
- [ ] `HealthContextBanner({required String? firstName, required DateTime date})` —
      nền `palette.surfaceBrandSubtle`, icon `Icons.edit_calendar`, câu “Nhật ký sức khoẻ
      cá nhân hôm nay sẵn sàng để ghi nhận và theo dõi.”
- [ ] Responsive: `< 768px` xếp dọc (nút xuống dưới, `FilledButton` full-width trong
      `SizedBox(width: double.infinity)` **không** đặt `minimumSize` vô hạn — xem cảnh
      báo trong `ui/theme.dart`); `>= 768px` header 2 cột như thiết kế.
- [ ] Dùng `HomeScale.textOf(context)` cho scale chữ; `MemoirSpace`/`MemoirRadius`;
      `flutter analyze`.

## Acceptance Criteria

1. *Given* ngày 17/10/2026, *then* nhãn hiển thị `Hôm nay, 17/10/2026`; ngày khác hiển
   thị `dd/MM/yyyy` **không** kèm chữ “Hôm nay”.
2. *Given* bấm `‹`/`›`, *then* gọi `onPrevious`/`onNext` **đúng một lần** mỗi lần bấm.
3. *Given* bấm “+ Ghi nhận nhanh”, *then* `onQuickLog` được gọi (mở sheet ghi nhận nhanh).
4. *Given* màn Sức khoẻ, *then* **không** còn nút “Xuất báo cáo” (đã gỡ 25.10.2026 —
   nút chết không có tính năng phía sau); chỉ còn *Xuất báo cáo* trong bản thiết kế.
5. *Given* màn hẹp 390px, *then* không tràn (`tester.takeException()` null) và các nút
   nằm dưới tiêu đề.
6. *Then* tiêu đề dùng `serifFamily`, không hard-code px rời rạc; `flutter analyze` sạch.

## Kiểm chứng

```powershell
cd flutter_app
flutter analyze
flutter run -d chrome --web-port 8080   # so vùng đầu trang với ..._bmi/screen.png
```

## Rủi ro / ghi chú

- Text phụ đề/banner lấy **nguyên văn** từ `code.html` để khớp thiết kế.
- Nút “Xuất báo cáo” đã bị **gỡ** (25.10.2026) cùng `Tooltip('Sẽ có sau')` vì không có
  tính năng phía sau; nếu sau này làm CSV/PDF thật thì mở task mới thay vì dựng lại nút
  chờ. `Icons.file_download` không còn dùng trong `health_chrome.dart`.
- `HealthDateNavigator` nhận `date` từ màn (H3-S8) — không giữ state riêng để tránh
  hai nguồn sự thật.
