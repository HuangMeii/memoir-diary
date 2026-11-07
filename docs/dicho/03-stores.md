# DC-03 · Vị trí & Siêu thị

**Epic:** DI CHO-01 · **Ước lượng:** 3 pts · **Phụ thuộc:** DC-01
**Nguồn thiết kế:** `ui-figma/dicho` — `memoir_i_ch_th_ng_minh_y_chu_i_si_u_th/code.html`,
section "RIGHT COLUMN: Card Chọn siêu thị & Vị trí".

## Mục tiêu

Card phải: tiêu đề `Vị trí & Siêu thị`, chip bán kính, danh sách 8 chuỗi kèm
khoảng cách/thời gian, chọn hoặc bỏ chọn để quyết định phạm vi so sánh giá.

## Phạm vi

- `flutter_app/lib/src/ui/dicho/dicho_stores_card.dart` (mới).
- `flutter_app/lib/src/data/dicho_shopping.dart` (`StoreChain`, `dichoStoreChains`, `storeIds`).
- KHÔNG đụng: bản đồ (DC-06), ma trận so sánh giá (DC-05).

## Việc cần làm

- [x] `dichoStoreChains`: 8 chuỗi đúng thiết kế (Co.opmart 1.8 km · 8 phút … Bách Hóa Xanh 1.2 km · 6 phút).
- [x] `toggleStore` / `selectAllStores`.
- [x] Grid 2 cột (dưới 420 px còn 1 cột), tile có checkbox, tên, `km · phút`, viền + nền nhấn khi chọn.
- [x] Đếm `(N chuỗi đang chọn)` + link `Chọn tất cả` / `Bỏ chọn` đổi theo trạng thái.
- [x] Dòng chú thích: khoảng cách tính từ vị trí đã lưu; chuỗi đã chọn là nguồn so sánh ở bước sau.

## Acceptance Criteria

1. Given mở màn lần đầu, when render, then cả 8 chuỗi đang chọn và tiêu đề ghi `(8 chuỗi đang chọn)`.
2. Given bỏ tick Co.opmart, when render, then còn 7 chuỗi và tile mất nền nhấn.
3. Given bấm `Bỏ chọn`, when render, then không chuỗi nào được chọn và link đổi thành `Chọn tất cả`.
4. Given màn hẹp, when render, then các tile xếp một cột, không tràn ngang.

## Kiểm chứng

```powershell
cd flutter_app
flutter analyze
flutter test test\dicho_shopping_test.dart
```

## Rủi ro / ghi chú

- Khoảng cách là số của thiết kế, chưa lấy từ vị trí thật của người dùng (chưa có GPS/địa chỉ lưu).
- Snippet bản đồ trong thiết kế thuộc DC-06; card hiện không vẽ bản đồ để tránh bản đồ giả.
