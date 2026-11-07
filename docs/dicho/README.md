# Đi chợ thông minh (DI CHO-01) — bộ task

Thư mục này chia nhỏ việc triển khai màn hình **Đi chợ thông minh** (thiết kế
**Warm Editorial Canvas**) trong `ui-figma/dicho/` thành các task nhỏ (mỗi task
≤ 1 ngày). Đây là tài liệu *kế hoạch/kỹ thuật*; code nằm ở `flutter_app/`.

## 1. Nguồn thiết kế

| Nguồn (`ui-figma/dicho/…`) | Nội dung |
|---|---|
| `memoir_i_ch_th_ng_minh_y_chu_i_si_u_th/code.html` | Frame đầy đủ **"Đi chợ thông minh"** (1202 dòng): chrome, danh sách cần mua, ngân sách, vị trí & siêu thị, bản đồ, so sánh giá, 3 lộ trình, chế độ cầm tay |
| `memoir_i_ch_th_ng_minh/code.html` | Frame rút gọn cùng nội dung |
| `warm_editorial_canvas/DESIGN.md`, `DESIGN.md` | Design system "Warm Editorial Canvas" (màu, chữ, khoảng cách, bo góc) |
| `screen.png` | Ảnh chụp tham chiếu |

## 2. Bản đồ màn hình (đối chiếu khi dựng)

| Khối | Nội dung | Task |
|---|---|---|
| Chrome | Breadcrumb `Trang chủ / Tiện ích / Đi chợ thông minh`, overline `Bách hóa & Gia đình`, H1 serif, phụ đề, chọn danh sách, `Danh sách mới` | DC-01 |
| Notice banner | Dòng thông tin về nguồn dữ liệu giá | DC-01 |
| Danh sách cần mua | Header + ngân sách, thanh tiến độ, ô thêm nhanh, từng dòng hàng (tick, icon, tên, quy cách, đơn giá, stepper, thành tiền, xoá), tổng dự kiến | DC-02 |
| Dự kiến tổng tiền | VAT, voucher, phí giao, dự phòng phát sinh | DC-04 |
| Vị trí & Siêu thị | Bán kính, 8 chuỗi kèm km/phút, chọn/bỏ chọn tất cả | DC-03 |
| Bản đồ | Snippet bản đồ lộ trình mua sắm + ghim từng chuỗi | DC-06 |
| Kết quả so sánh giá | 4 thẻ insight + bảng ma trận giá theo chuỗi | DC-05 |
| Gợi ý lộ trình | 3 phương án (gần & tiết kiệm / một điểm / nhiều điểm) | DC-07 |
| Lưu vào nhật ký | Modal tên chuyến, danh sách, ngân sách, ảnh | DC-08 |
| Chế độ đi chợ | Chế độ cầm tay + trạng thái loading/empty/error | DC-09 |

## 3. Hiện trạng

Đã code (Flutter, offline-first — chưa có endpoint backend):

| Lớp | File | Nội dung |
|---|---|---|
| Data (local) | `flutter_app/lib/src/data/dicho_shopping.dart` | `ShoppingItem`, `ShoppingList`, `StoreChain`, `DichoState` (seed đúng số liệu thiết kế: 5 món / 353.000 đ / ngân sách 500.000 đ / 8 chuỗi), `DichoNotifier` + `dichoProvider` |
| Format | `flutter_app/lib/src/ui/dicho/dicho_format.dart` | `formatVnd`, `formatDistance`, `formatMinutes`, `parseVnd`, icon + nhãn nhóm hàng |
| UI | `flutter_app/lib/src/ui/dicho/dicho_chrome.dart` | `DichoBreadcrumb`, `DichoPageHeader`, `DichoListSelector`, `DichoNoticeBanner` |
| UI | `flutter_app/lib/src/ui/dicho/dicho_shopping_card.dart` | `DichoShoppingCard` (ngân sách, thêm nhanh, dòng hàng, tổng dự kiến), `DichoItemRow` |
| UI | `flutter_app/lib/src/ui/dicho/dicho_add_item_dialog.dart` | Dialog `Thêm mặt hàng` (tên, đơn giá, số lượng, đơn vị, nhóm, quy cách) |
| UI | `flutter_app/lib/src/ui/dicho/dicho_stores_card.dart` | `DichoStoresCard`, `DichoStoreTile` |
| Màn hình | `flutter_app/lib/src/ui/screens/dicho_screen.dart` | Ghép chrome + 2 cột 7/5 (mobile xếp dọc), scale theo frame 1280 |
| Entry point | `flutter_app/lib/src/ui/utilities.dart` | Tiện ích **Đi chợ** trên header (`Icons.shopping_basket_outlined`) |
| Lưu local | `flutter_app/lib/src/data/dicho_csv.dart` | Codec: `dichoShoppingToCsv` / `dichoShoppingFromCsv` — tài liệu CSV 3 khối (danh sách · mặt hàng · cấu hình), đọc/ghi khép kín |
| Lưu local | `flutter_app/lib/src/data/dicho_storage.dart` | `DichoStorage` (`shared_preferences`), `DichoSync` (nạp 1 lần + ghi debounce 250 ms + ghi lúc dispose), `dichoProvider` |
| Test | `flutter_app/test/dicho_shopping_test.dart` | 35 case: seed, subtotal/ngân sách, clamp số lượng, thêm/xoá dòng, danh sách riêng, chuỗi siêu thị, định dạng, widget `DichoItemRow`, vòng lưu–nạp CSV, `DichoStorage` (rỗng/hỏng/clear), `dichoProvider` (tự lưu + nạp khi mở), layout 1280 px & 390 px |

Chưa có: endpoint Serverpod (danh sách/giá/siêu thị), bảng DB, so sánh giá thật,
bản đồ, modal lưu nhật ký, chế độ cầm tay. Giá trong màn là **dữ liệu mẫu** và
banner nói rõ điều đó. Danh sách thì **đã được lưu trên thiết bị** (DC-11): tải
lại trang hay mở lại app vẫn còn nguyên giỏ đang sửa.

## 4. Kế hoạch task

| ID | Task | Ước lượng | Phụ thuộc | File | Trạng thái |
|---|---|---|---|---|---|
| DC-01 | Chrome + banner màn "Đi chợ thông minh" | 3 | — | [01-chrome.md](01-chrome.md) | ✅ DONE |
| DC-02 | Danh sách cần mua: ngân sách, thêm nhanh, dòng hàng, tổng dự kiến | 5 | DC-01 | [02-shopping-list.md](02-shopping-list.md) | ✅ DONE |
| DC-03 | Vị trí & Siêu thị: 8 chuỗi, chọn/bỏ chọn | 3 | DC-01 | [03-stores.md](03-stores.md) | ✅ DONE |
| DC-04 | Dự kiến tổng tiền phải trả (VAT, voucher, phí giao, dự phòng) | 2 | DC-02 | — | TODO |
| DC-05 | Kết quả so sánh giá (4 thẻ insight + ma trận theo chuỗi) | 5 | DC-03, DC-04 | — | TODO |
| DC-06 | Bản đồ lộ trình mua sắm + ghim chuỗi | 3 | DC-03 | — | TODO |
| DC-07 | Gợi ý 3 lộ trình mua sắm | 3 | DC-05 | — | TODO |
| DC-08 | Modal "Lưu vào nhật ký" | 3 | DC-02 | — | TODO |
| DC-09 | Chế độ cầm tay + states (loading/empty/error) | 2 | DC-01…DC-08 | — | TODO |
| DC-10 | Cập nhật tài liệu + kiểm chứng end-to-end | 2 | toàn bộ | — | TODO |
| DC-11 | Lưu danh sách trên thiết bị (CSV trong `shared_preferences`, không DB) | 3 | DC-02 | [11-local-persistence.md](11-local-persistence.md) | ✅ DONE |

> File task của DC-04…DC-10 được viết **just-in-time** khi bắt đầu task, theo
> `docs/jira/00-conventions.md`; các dòng trên để trống link cho tới lúc đó.

## 5. Thứ tự thực hiện

```
README → 00-conventions
DC-01 → DC-02 → DC-11 → DC-03 → (DC-04 // DC-06) → DC-05 → DC-07 → DC-08 → DC-09 → DC-10
```

## 6. Lệnh hay dùng

```powershell
# Flutter — chạy trong flutter_app
flutter pub get
flutter analyze ; flutter test
flutter run -d chrome --web-port 8080   # khớp CORS_ORIGINS của backend
```

## 7. Ghi chú chung

- Thiết kế dùng font **Newsreader** (serif) và **Plus Jakarta Sans** (sans) — map
  về `Lora` (`serifFamily`) và `Inter` (`sansFamily`) theo quy ước tại
  [docs/notes/00-conventions.md §3](../notes/00-conventions.md).
- Màu lấy qua `MemoirPalette` / `Theme.of`; khoảng cách và bo góc lấy qua
  `MemoirSpace` / `MemoirRadius`; **không** hard-code mã hex trong widget.
- Mỗi task UI ghi `Nguồn thiết kế: ui-figma/dicho` + tên section trong
  `code.html` để đối chiếu khi dựng.
- State của màn nằm trong `dichoProvider` và **tự lưu trên thiết bị** (tài liệu CSV
  trong `shared_preferences`, xem [11-local-persistence.md](11-local-persistence.md)).
  Khi có endpoint Serverpod, chỉ tài liệu này + `dicho_storage.dart` phải đổi;
  widget giữ nguyên.
- Ngoài phạm vi: tự xây mô hình dự đoán giá, đặt hàng/giao dịch thật, tự định vị
  GPS, dẫn đường turn-by-turn.
