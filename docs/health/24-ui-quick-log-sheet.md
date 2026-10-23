# H4-S1 · Khung sheet ghi nhận nhanh (3 tab)

**Epic:** H4 · **Ước lượng:** 2 pts · **Phụ thuộc:** H2-S5
**Nguồn thiết kế:** tab strip xuất hiện trong cả ba modal —
`memoir_ghi_nh_n_gi_ng/code.html` dòng 164–172, `memoir_ghi_nh_n_nhanh_s_c_kho/code.html`
dòng 175 và 211–221, `memoir_ghi_nh_n_u_ng_n_c_trung_t_m/code.html` dòng 196–199

> ⚠️ Hai modal **ngủ** và **nước** không có `screen.png` dùng được (28 byte) — chỉ đối
> chiếu `code.html`.

## Mục tiêu

Dựng **một** khung bottom sheet dùng chung cho ba lối ghi nhận nhanh, có tiêu đề
“Ghi nhận sức khoẻ”, phụ đề ngày, tab `Giờ ngủ | Thời gian tập | Uống nước`, chỗ chứa
nội dung tab và footer `Hủy / Để sau` + nút lưu.

## Phạm vi

- **Tạo mới:** `flutter_app/lib/src/ui/health/quick_log_sheet.dart`.
- **KHÔNG sửa:** `health_screen.dart` (chỉ gọi `showQuickLogSheet`), ba file tab
  (H4-S2…S4 — task này chỉ định nghĩa **interface** cho chúng).

## Việc cần làm

- [x] `enum QuickLogTab { sleep, workout, water }` + `label`/`icon`:
      `Giờ ngủ` (`Icons.bedtime`), `Thời gian tập` (`Icons.fitness_center`),
      `Uống nước` (`Icons.water_drop`).
- [x] `Future<void> showQuickLogSheet(BuildContext context, WidgetRef ref,
      {required DateTime date, QuickLogTab initialTab = QuickLogTab.workout})`
      — `showModalBottomSheet(isScrollControlled: true, useSafeArea: true)`, mobile là
      sheet trượt lên, web là panel giữa rộng ~560 (giống các modal khác của app).
- [x] Khung: tiêu đề **“Ghi nhận sức khoẻ”** + phụ đề “Cập nhật nhật ký thể trạng cá nhân
      cho ngày hôm nay” + nút `close`; dưới đó là dòng ngày “Ngày dd/MM/yyyy”.
- [x] Tab strip: 3 tab với trạng thái chọn (nền trắng + chữ đậm, tab khác chữ mờ) —
      dùng `SegmentedTabs<QuickLogTab>` sẵn có (H0-S1 đã có token nền pill).
- [ ] Thân: `switch (tab)` ⇒ `QuickWorkoutTab` / `QuickWaterTab` / `QuickSleepTab`, truyền
      xuống `date`, `overview` (từ `healthDayProvider(date)`) và callback `onSaved`.
- [x] Footer: `TextButton('Hủy / Để sau')` đóng sheet **không** ghi gì, và nút
      `FilledButton.icon(Icons.save, 'Lưu vào nhật ký')` ⇒ gọi `save()` của tab đang mở;
      thành công ⇒ `refreshHealth(ref, day: date)`, đóng sheet, snackbar “Đã ghi nhận vào
      nhật ký ngày dd/MM”.
- [ ] Mỗi tab tự quản lý nháp của mình; đổi tab rồi quay lại **giữ** giá trị đang nhập
      trong phiên mở sheet (dùng `IndexedStack` hoặc state ở khung).
- [ ] `showQuickLogSheet` là **điểm vào duy nhất**: màn Sức khoẻ (H3-S8, form H3-S3) và
      nút `+ Ghi nhận nhanh` (H3-S1) đều gọi hàm này.
- [ ] `flutter analyze`.

## Acceptance Criteria

1. *Given* `initialTab: QuickLogTab.workout` (nút `+ Ghi nhận nhanh` ở header), *then*
   sheet mở đúng tab “Thời gian tập”.
2. *Given* mở từ nút “+ Thêm ly” của form (H3-S3), *then* sheet mở tab “Uống nước”.
3. *Given* người dùng gõ dữ liệu ở tab Nước rồi chuyển sang tab Ngủ và quay lại, *then*
   giá trị đã gõ **vẫn còn**.
4. *Given* bấm “Hủy / Để sau”, *then* đóng sheet, **không** có request nào được gửi.
5. *Given* bấm “Lưu vào nhật ký” khi dữ liệu hợp lệ, *then* ghi đúng tab đó, `refreshHealth`
   được gọi, màn Sức khoẻ cập nhật ngay, có snackbar xác nhận.
6. *Given* tiêu đề/ngày trong sheet, *then* hiển thị đúng ngày đang xem ở màn (không phải
   luôn luôn “hôm nay”).
7. *Then* màn 390px: sheet cao tối đa ~90% màn, nội dung cuộn được; `flutter analyze` sạch.

## Kiểm chứng

```powershell
cd flutter_app
flutter analyze
flutter run -d chrome --web-port 8080
# mở 3 tab và so với code.html của 3 modal (folder tương ứng)
```

## Rủi ro / ghi chú

- Sheet phải **nhận `date`** chứ không tự lấy “hôm nay”: màn Sức khoẻ cho phép xem ngày
  khác, ghi nhận nhanh phải theo ngày đó.
- Chỉ một khung duy nhất: nếu mỗi tab tự mở sheet riêng sẽ lệch bố cục và khó giữ nháp.
- Đây là task khung — **không** nhồi logic ghi của tab vào file này; mỗi tab gọi
  `HealthRepository` (H2-S4) và báo lại qua `onSaved`.
