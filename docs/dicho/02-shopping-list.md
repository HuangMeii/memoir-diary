# DC-02 · Danh sách cần mua

**Epic:** DI CHO-01 · **Ước lượng:** 5 pts · **Phụ thuộc:** DC-01
**Nguồn thiết kế:** `ui-figma/dicho` — `memoir_i_ch_th_ng_minh_y_chu_i_si_u_th/code.html`,
section "LEFT COLUMN: Card Danh sách cần mua" + "Interactive Grocery Items List".

## Mục tiêu

Card trái: ngân sách + thanh tiến độ, ô thêm nhanh, danh sách dòng hàng có tick /
stepper / thành tiền / xoá, và khối tổng dự kiến (tạm tính + phí giao).

## Phạm vi

- `flutter_app/lib/src/ui/dicho/dicho_shopping_card.dart` (mới).
- `flutter_app/lib/src/ui/dicho/dicho_add_item_dialog.dart` (mới).
- `flutter_app/lib/src/ui/dicho/dicho_format.dart` (mới).
- `flutter_app/lib/src/data/dicho_shopping.dart` (mới, state local + seed).
- KHÔNG đụng: card siêu thị (DC-03), so sánh giá (DC-05), backend.

## Việc cần làm

- [x] `DichoState`/`DichoNotifier`: subtotal, remaining, `budgetProgress`, `estimatedTotal`, delivery fee.
- [x] Seed đúng thiết kế: 5 món (76.000 + 32.000 + 175.000 + 18.000 + 52.000 = 353.000 đ), ngân sách 500.000 đ.
- [x] Header card: số món + tạm tính, ngân sách (bấm bút chì để sửa).
- [x] Thanh tiến độ + nhãn `Còn dư … (29%)`, chuyển sang đỏ khi vượt ngân sách.
- [x] Ô thêm nhanh + nút `Thêm` → dialog `Thêm mặt hàng` (tên, đơn giá, số lượng, đơn vị, nhóm, quy cách).
- [x] `DichoItemRow`: checkbox, icon nhóm, tên (gạch ngang khi đã tick), quy cách + đơn giá, stepper 1…99, thành tiền, nút xoá.
- [x] Responsive: dưới 520 px thì stepper/thành tiền xuống dòng dưới.
- [x] Empty state khi danh sách trống.
- [x] Khối tổng: `Tự đi mua` / `Giao tận nơi (+15k)`, tạm tính, tổng dự kiến.

## Acceptance Criteria

1. Given danh sách mẫu, when mở màn, then thấy `5 sản phẩm`, tạm tính `353.000 đ`, ngân sách `500.000 đ`, `Còn dư 147.000 đ (29%)`.
2. Given bấm `+` ở dòng sữa, when state cập nhật, then dòng hiện `3 hộp`, `114.000 đ`, tạm tính `391.000 đ`.
3. Given bấm `−` khi số lượng là 1, when state cập nhật, then vẫn là `1` (không về 0).
4. Given nhập tên rồi `Thêm` và huỷ dialog, when quay lại, then danh sách không đổi.
5. Given nhập tên + đơn giá 5.000 và lưu, when quay lại, then dòng mới nằm cuối, chưa tick, tạm tính tăng 5.000.
6. Given ngân sách bị sửa xuống dưới tạm tính, when render, then nhãn chuyển `Vượt …`, thanh tiến độ đầy và đổi màu lỗi.
7. Given chọn `Giao tận nơi`, when render, then tổng dự kiến = tạm tính + 15.000 và phí hiện thành dòng riêng.
8. Given xoá hết hàng, when render, then thấy empty state thay vì khoảng trắng.

## Kiểm chứng

```powershell
cd flutter_app
flutter analyze
flutter test test\dicho_shopping_test.dart
```

## Rủi ro / ghi chú

- State chỉ nằm trong bộ nhớ phiên (chưa có endpoint) — tải lại trang là mất chỉnh sửa; điều này đã ghi ở README §3.
- Thiết kế hiển thị đơn vị theo quy cách (`5 kg`, `500 g`) trong khi đơn giá theo gói/túi; bản dựng thống nhất stepper theo đơn vị đóng gói và giữ quy cách ở dòng phụ.
- Khối VAT/voucher/dự phòng của thiết kế để cho DC-04.
