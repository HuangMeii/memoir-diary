# DC-11 · Lưu danh sách trên thiết bị

**Epic:** DI CHO-01 · **Ước lượng:** 3 pts · **Phụ thuộc:** DC-02
**Nguồn thiết kế:** không có trong `ui-figma/dicho` — bổ sung theo yêu cầu: cần
một dạng lưu **ngắn, ngay trên máy**, không dựng DB/backend.

## Mục tiêu

Giỏ hàng sống sót khi tải lại trang / mở lại app mà không cần Serverpod, không
cần migration, không cần xuất tệp thủ công.

## Quyết định kỹ thuật

| Phương án | Kết luận |
|---|---|
| **`shared_preferences` + tài liệu CSV** | ✅ chọn: một dependency first-party, web = `localStorage`, mobile/desktop = preferences của HĐH; nội dung là CSV nên vẫn đọc được bằng mắt/bảng tính |
| SQLite (`sqflite`) | ❌ không hợp: web không có đường chạy nhẹ (phải thêm `sqflite_common_ffi_web` + wasm worker), quá nặng cho ~5 dòng dữ liệu |
| Ghi tệp `.csv` thật | ❌ không hợp: web không ghi tệp bền vững nếu không có File System Access API + thao tác người dùng; mobile cần `path_provider`/share sheet |
| Serverpod + bảng DB | ❌ ngoài yêu cầu: cần endpoint, migration, đồng bộ |

## Định dạng tài liệu (v1)

Khoá: `dicho.shopping.csv.v1`. Tài liệu là CSV 3 khối, cách nhau một dòng trống,
mở đầu bằng dòng chú thích `# memoir-di-cho v1 …`:

```
# memoir-di-cho v1 — danh sách mua sắm, lưu trên thiết bị

Danh sách ID,Tên danh sách,Ngân sách (đ),Đang chọn
list-week-41,Mua sắm tuần 41,500000,1
list-family-party,Tiệc cuối tuần gia đình,800000,0

Danh sách ID,Mặt hàng,Quy cách,Nhóm hàng,Đơn vị,Số lượng,Đơn giá (đ),Đã mua
list-week-41,Sữa tươi không đường TH True Milk 1 lít,Hộp giấy tiệt trùng,dairy,hộp,2,38000,1

Hình thức nhận hàng,selfPickup
Chuỗi đang chọn,coopmart|winmart|vincom
```

- `Nhóm hàng` dùng `ShoppingCategory.name` (ASCII) để parse ổn định; UI vẫn hiện nhãn tiếng Việt.
- `Đã mua`, `Đang chọn`: `1`/`0`.
- Ô chứa `,` hoặc `"` được bọc nháy kép + nhân đôi nháy; xuống dòng bị thay bằng khoảng trắng để không phá cấu trúc khối.
- Tài liệu không có dấu `# memoir-di-cho` → bỏ qua (giữ giỏ seed) thay vì đoán cột.

## Việc cần làm

- [x] `dichoShoppingToCsv` / `dichoShoppingFromCsv` (codec khép kín, không phụ thuộc UI).
- [x] `DichoStorage`: `load` / `save` / `clear` trên `shared_preferences`.
- [x] `DichoSync`: nạp **một lần** khi mở màn, ghi **debounce 250 ms** mỗi lần sửa, ghi thêm lúc `dispose`.
- [x] `dichoProvider` dựng notifier + sync; sửa **trước khi** nạp xong thì bản sửa thắng và vẫn được ghi (không bị bản cũ đè).
- [x] `DichoNotifier.onChanged` + `restore()` (đẩy bộ đếm id vượt qua id đã nạp để không trùng id).
- [x] Banner đổi thông điệp: “Danh sách được **lưu ngay trên thiết bị này**”.
- [x] Bỏ nút `Xuất CSV` và toàn bộ hạ tầng tải tệp (theo yêu cầu: không cần xuất).
- [x] Test: vòng lưu–nạp, tài liệu rác bị bỏ qua, `clear`, id không trùng sau khi nạp, tự ghi qua provider, nạp đè giỏ seed.

## Acceptance Criteria

1. Given thêm một mặt hàng rồi đóng app, when mở lại màn Đi chợ, then mặt hàng đó vẫn còn.
2. Given đổi ngân sách / số lượng / hình thức nhận hàng, when tải lại trang (web), then cả ba thay đổi còn nguyên.
3. Given chưa có dữ liệu trên máy, when mở màn, then thấy giỏ seed của thiết kế (5 món, 353.000 đ).
4. Given dữ liệu trên máy bị sửa tay thành rác, when mở màn, then app không crash và quay về giỏ seed.
5. Given sửa liên tục bằng stepper, when ngừng tay 250 ms, then chỉ một lần ghi được thực hiện (debounce).
6. Given xoá khoá lưu (`DichoStorage.clear`), when mở màn, then quay về giỏ seed.

## Kiểm chứng

```powershell
cd flutter_app
flutter analyze
flutter test test\dicho_shopping_test.dart
flutter run -d chrome --web-port 8080   # sửa giỏ rồi F5, dữ liệu vẫn còn
```

## Rủi ro / ghi chú

- `shared_preferences` **không mã hoá**: web để trong `localStorage`, ai mở DevTools cũng đọc được. Dữ liệu chỉ là danh sách đi chợ, không phải bí mật; nếu cần kín thì phải mã hoá riêng.
- Xoá dữ liệu trình duyệt / xoá app = mất giỏ. Muốn sao lưu thì phải thêm lại export hoặc đồng bộ server.
- Một khoá duy nhất cho cả màn: mọi danh sách nằm chung tài liệu; dung lượng thực tế vài KB nên chưa cần tách khoá theo danh sách.
- Chưa có nút "xoá dữ liệu trên máy" trong UI; `DichoStorage.clear()` đã sẵn sàng nếu cần gắn vào màn Cài đặt sau này.
- Nếu sau này đổi định dạng, đổi hậu tố khoá (`…csv.v2`) và viết migrate đọc v1 trước khi ghi v2.
