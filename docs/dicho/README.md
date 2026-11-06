# Đi chợ / Warm Editorial Canvas (DI CHO-01 + DI CHO-02) — bộ task

Thư mục này chia nhỏ việc triển khai thiết kế **Warm Editorial Canvas** đã tải về
`ui-figma/dicho/` thành các task nhỏ (mỗi task ≤ 1 ngày). Đây là tài liệu *kế hoạch/kỹ thuật*; không chứa code chạy.

## 1. Nguồn thiết kế

| Nguồn (`ui-figma/dicho/…`) | Màn hình | File |
|---|---|---|
| `warm_editorial_canvas/` | Design system "Warm Editorial Canvas" (màu, chữ, khoảng cách, bo góc) | `DESIGN.md` |
| `code.html` | Bản dựng web "Thời tiết theo hành trình — Memoir" | `code.html` (966 dòng) |
| `screen.png` | Ảnh chụp màn hình tham chiếu | `screen.png` |

Ba thư mục con `memoir_i_ch_th_ng_minh/`, `memoir_i_ch_th_ng_minh_y_chu_i_si_u_th/` và `warm_editorial_canvas/` chứa các frame thiết kế chi tiết.

## 2. Bản đồ màn hình (để đối chiếu khi dựng)

| Khối | Nội dung |
|---|---|
| Chrome | Wordmark, navigation, user chip, actions (`Hành trình đã lưu` · `So sánh giờ khởi hành` · `Lưu vào nhật ký`) |
| Hero / Title | "Thời tiết theo hành trình", phụ đề |
| Form Quản lý lộ trình | Điểm xuất phát / điểm dừng / điểm đến, ô nhập địa chỉ (gợi ý Nominatim), thời gian dừng, đảo chiều, ngày–giờ khởi hành, segmented Ô tô / Xe đạp / Đi bộ, danh sách tuyến thay thế |
| Bản đồ | Tile OSM thật, polyline, marker điểm đi/dừng/đến, marker nhiệt độ theo mức bất lợi, attribution |
| Phân tích hành trình | Bar lượng mưa + line nhiệt độ theo Km, nhãn HH:mm + Km |
| Chi tiết chặng | Lưới thẻ 1→4 cột: giờ — Chặng N, chip mức, tên điểm, Km, đến HH:mm, icon + nhiệt độ, Mưa %, mm, Gió km/h |
| Khuyến cáo an toàn | Callout nền theo mức (vàng/đỏ), lý do đoạn bất lợi, tốc độ tối đa, hệ thống đèn, điểm dừng chờ |
| So sánh giờ khởi hành | 3 thẻ (đề xuất / đang chọn / muộn hơn), giờ đến, lý do, nút Áp dụng |
| Modal Lưu vào nhật ký | Tên chuyến, liên kết nhật ký, lộ trình, ngày khởi hành, thời tiết đính kèm, cảm xúc & ghi chú, ảnh |

## 3. Hiện trạng

- Backend `RouteEndpoint`, `JourneysEndpoint` đã tồn tại từ feature route weather cũ (`docs/12-route-weather.md`).
- Chưa có mã Flutter/Serverpod nào cho màn hình thiết kế mới trong `ui-figma/dicho/`.

## 4. Kế hoạch task

| ID | Task | Ước lượng | Phụ thuộc | File | Trạng thái |
|---|---|---|---|---|---|
| DC-01 | Khung chrome màn hình "Đi chợ" | 3 | — | [01-chrome.md](01-chrome.md) | TODO |
| DC-02 | Form Quản lý lộ trình | 5 | DC-01 | [02-route-planner.md](02-route-planner.md) | TODO |
| DC-03 | Bản đồ lộ trình + marker thời tiết | 5 | DC-01 | [03-route-map.md](03-route-map.md) | TODO |
| DC-04 | Timeline chi tiết chặng | 3 | DC-02 | [04-route-timeline.md](04-route-timeline.md) | TODO |
| DC-05 | Biểu đồ diễn tiến mưa / nhiệt độ | 3 | DC-02 | [05-route-chart.md](05-route-chart.md) | TODO |
| DC-06 | Khối khuyến cáo an toàn đoạn bất lợi | 2 | DC-02 | [06-safety-advisory.md](06-safety-advisory.md) | TODO |
| DC-07 | So sánh giờ khởi hành | 2 | DC-02 | [07-departure-compare.md](07-departure-compare.md) | TODO |
| DC-08 | Modal Lưu vào nhật ký | 3 | DC-02 | [08-save-journey.md](08-save-journey.md) | TODO |
| DC-09 | States: loading / empty / error / thiếu dữ liệu | 2 | DC-01…DC-08 | [09-states.md](09-states.md) | TODO |
| DC-10 | Cập nhật tài liệu + kiểm chứng end-to-end | 2 | toàn bộ | [10-verification.md](10-verification.md) | TODO |

## 5. Thứ tự thực hiện

```
README → 00-conventions
DC-01 → DC-02 → (DC-03 // DC-04 // DC-05) → DC-06 → DC-07 → DC-08 → DC-09 → DC-10
```

## 6. Lệnh hay dùng

```powershell
# Flutter — chạy trong flutter_app
flutter pub get
flutter analyze ; flutter test
flutter run -d chrome --web-port 8080   # khớp CORS_ORIGINS của backend
```

## 7. Ghi chú chung

- Thiết kế dùng font **Newsreader** (serif) và **Plus Jakarta Sans** (sans) — map về `Lora` (`serifFamily`) và `Inter` (`sansFamily`) theo quy ước tại [docs/notes/00-conventions.md §3](../notes/00-conventions.md).
- Màu từ `ui-figma/dicho/DESIGN.md` dùng qua `MemoirPalette` / `Theme.of`, **không** hard-code mã hex trực tiếp vào widget.
- Mọi task UI **bắt buộc** ghi `Nguồn thiết kế: ui-figma/dicho` + tên section trong `code.html` để đối chiếu khi dựng.
- Ngoài phạm vi: tự xây mô hình dự đoán thời tiết, dẫn đường turn-by-turn, tự định vị GPS, lưu mọi lần bấm "Xem" (chỉ ghi DB khi user bấm Lưu vào nhật ký).