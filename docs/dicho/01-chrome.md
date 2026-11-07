# DC-01 · Chrome màn "Đi chợ thông minh"

**Epic:** DI CHO-01 · **Ước lượng:** 3 pts · **Phụ thuộc:** —
**Nguồn thiết kế:** `ui-figma/dicho` — `memoir_i_ch_th_ng_minh_y_chu_i_si_u_th/code.html`,
section "TOP NAV BAR" + "BREADCRUMB & HEADER" + "Notice Banner".

## Mục tiêu

Dựng phần khung của màn: breadcrumb, overline, tiêu đề serif, phụ đề, chọn danh
sách, `Danh sách mới`, banner nguồn dữ liệu — tất cả trên `AppHeader` sẵn có và
scale theo frame 1280.

## Phạm vi

- `flutter_app/lib/src/ui/dicho/dicho_chrome.dart` (mới).
- `flutter_app/lib/src/ui/screens/dicho_screen.dart` (ghép khung).
- KHÔNG đụng: nội dung card danh sách / siêu thị (DC-02, DC-03), backend.

## Việc cần làm

- [x] `DichoBreadcrumb`: `Trang chủ / Tiện ích / Đi chợ thông minh`, back về trang trước.
- [x] `DichoPageHeader`: overline `BÁCH HÓA & GIA ĐÌNH`, H1 `Đi chợ thông minh` (Lora 36), phụ đề, cụm action.
- [x] `DichoListSelector`: pill dropdown đổi danh sách, mục đang chọn có hậu tố `(Đang chọn)`.
- [x] `Danh sách mới` → `TextPromptDialog` → `DichoNotifier.createList`.
- [x] `DichoNoticeBanner`: nói rõ giá là **dữ liệu mẫu** (thiết kế ghi "cập nhật 08:30" nhưng chưa có feed).
- [x] Màn hình scale `homeScaleFor(designWidth: 1280)`, dùng `AppHeader` như các màn khác.

## Acceptance Criteria

1. Given mở màn từ tiện ích **Đi chợ**, when trang tải xong, then thấy breadcrumb, overline, H1 serif và phụ đề đúng thiết kế.
2. Given bấm vào pill danh sách, when chọn `Thực đơn thanh đạm 7 ngày`, then header và card hiển thị danh sách đó.
3. Given bấm `Danh sách mới`, when nhập tên và bấm `Tạo`, then danh sách mới xuất hiện và được chọn; nhập rỗng thì không tạo.
4. Given màn hình hẹp (< 900), when render, then cụm action xuống dưới tiêu đề thay vì tràn.
5. Given đọc banner, when người dùng thấy số tiền, then hiểu đó là dữ liệu mẫu chứ không phải giá thật.

## Kiểm chứng

```powershell
cd flutter_app
flutter analyze
flutter test test\dicho_shopping_test.dart
flutter run -d chrome --web-port 8080
```

## Rủi ro / ghi chú

- Thiết kế có nút primary `Lưu vào nhật ký`; chưa dựng vì cần DC-08 (chưa có chỗ lưu danh sách vào nhật ký).
- Banner cố tình khác chữ thiết kế để không nói sai về dữ liệu.
