# ROUTE-01 — Thời tiết theo hành trình

**Nền tảng:** ROADMAP

Thiết kế màn nhập lộ trình và xem thời tiết dự kiến dọc đường: form **Quản lý lộ
trình**, bản đồ có marker địa điểm + marker thời tiết, biểu đồ diễn tiến (mưa +
nhiệt độ theo km), timeline từng chặng, khuyến cáo đoạn bất lợi, so sánh giờ
khởi hành, và modal **Lưu vào nhật ký**.

Cần có states: default, loading, không có tuyến, API lỗi / vượt giới hạn, dữ
liệu một phần, vượt phạm vi dự báo, lưu thành công / thất bại, chưa đăng nhập.

Đặc tả hành vi & API: [12-route-weather.md](../12-route-weather.md).

## Nguồn tham chiếu

- `ui-figma/stitch_weather_route_planner_ui/code.html` — bản dựng web do Stitch sinh.
- `ui-figma/thời tiết hành trình.svg` — bản export của chính frame đó (1280×2456).
- `ui-figma/stitch_weather_route_planner_ui/DESIGN.md` — token "Warm Editorial Canvas".

## Đã dựng (`Thời tiết hành trình` trong header)

`route_weather_screen.dart` + `ui/route/*`, đọc `route.planWithWeather` qua
`routePlanProvider`. Màn dựng theo các khối của frame này:

- **Chrome** (`route_chrome.dart`): breadcrumb `← Trang chủ / Tiện ích / Hành trình`,
  overline `HÀNH TRÌNH & THỜI TIẾT`, tiêu đề, phụ đề, ba hành động
  (`Hành trình đã lưu` · `So sánh giờ khởi hành` · `Lưu vào nhật ký`); dải tóm tắt
  (`Lộ trình / Khoảng cách / Thời gian di chuyển / Khởi hành / Đến dự kiến`) kèm
  chip nguồn `Dữ liệu trực tiếp · OSRM · Open-Meteo` hoặc `Dữ liệu cũ · cập nhật HH:mm`.
- **Dải trên bản đồ** (`route_weather_screen.dart`): trên cửa sổ rộng, form **Quản lý
  lộ trình** (cột trái, `4/12` ≈ 384 px) và khối **nguồn dữ liệu + dải tóm tắt** (cột
  phải, `8/12`) nằm **chung một hàng**; **bản đồ chạy full-width ngay bên dưới** cả hai
  cột. Hẹp hơn ngưỡng thì xếp dọc lại: form → nguồn dữ liệu → bản đồ. Mọi trạng thái
  (chưa đủ điểm / loading / lỗi) hiện ở cột phải, nên form luôn đứng nguyên bên trái.
- **Form Quản lý lộ trình** (`route_planner_panel.dart`): điểm xuất phát / điểm dừng /
  điểm đến, **ô của mỗi điểm vừa là ô nhập địa chỉ** (gợi ý từ Nominatim hiện ngay dưới
  điểm đó, **chỉ chạy khi bấm nút Tìm / Enter** — không tìm lúc đang gõ; nút bị chặn
  1,5 giây sau mỗi lần tìm, dùng chung cho mọi điểm),
  **chọn trên bản đồ**, `Thời gian dừng` cho từng điểm dừng (± 15 phút),
  `Đảo chiều`, chọn ngày–giờ khởi hành, segmented `Ô tô / Xe đạp / Đi bộ`, danh sách
  **Tuyến thay thế** (chỉ hiện khi routing API trả về).
- **Bản đồ** (`route_map_view.dart`): tile OSM thật, polyline, marker `Điểm đi/Điểm
  dừng/Điểm đến`, marker nhiệt độ tô theo mức bất lợi, bấm marker → chọn mục timeline
  và ngược lại bản đồ cuộn tới mục đang chọn, attribution ở góc.
- **Phân tích hành trình** (`route_progress_chart.dart`): bar lượng mưa + line nhiệt độ
  theo `Km`, nhãn dưới trục là `HH:mm` + `Km` của vài mốc.
- **Chi tiết chặng** (`route_timeline.dart`): lưới thẻ 1→4 cột, mỗi thẻ là một chặng
  (`giờ — Chặng N`, chip mức, tên điểm, `Km`, `đến HH:mm`, icon + nhiệt độ, `Mưa %`,
  `mm`, `Gió km/h`, lý do nếu có).
- **Khuyến cáo an toàn** (`route_panels.dart`): callout nền theo mức, tiêu đề `Đoạn …`
  + `(dự kiến HH:mm – HH:mm)`, mô tả, dòng ghi rõ đây là ngưỡng hiển thị của Memoir.
- **So sánh giờ khởi hành** (`route_panels.dart`): 3 khung giờ (−2h / đang chọn / +2h),
  mỗi khung có giờ đến, kết luận ngắn và nút `Áp dụng`.
- **Modal `ROUTE-02`** (`save_journey_dialog.dart`): tên chuyến đi, switch ghi vào nhật
  ký ngày khởi hành (nói rõ sẽ **tạo mới** hay **thêm vào** nhật ký đã có), nội dung
  đính kèm sửa được, ghi chú.
- **Xem lại hành trình** (`saved_journeys_dialog.dart`): danh sách hành trình đã lưu,
  chi tiết một chuyến, **bản tóm tắt đã lưu** (kèm "chụp lúc …") tách khỏi nút
  **Cập nhật dự báo mới nhất**, và xoá hành trình.

### Khác bản Stitch (có chủ ý)

- **Bản đồ là tile OSM thật**, không phải bản đồ giấy vẽ tay: cần bấm chọn điểm thật
  và marker theo toạ độ. Đổi lại, phong cách "bản đồ biên tập" của bản Stitch không
  còn giữ được.
- **Số liệu đều lấy từ nhà cung cấp thật** (OSRM + Open-Meteo), không dùng số minh họa.
- **Form Quản lý lộ trình không có trong bản Stitch** — dựng mới theo cùng ngôn ngữ
  thị giác.
- **Dải trên bản đồ phục dựng lưới `lg:col-span-4 / 8`** của frame, nhưng **bản đồ
  được nâng lên full-width** ngay dưới dải đó thay vì nằm trong cột phải như Stitch.
- **Icon Material thay cho Material Symbols** chưa export, như mọi màn khác.
- **Attribution ở góc bản đồ** và **dòng miễn trừ cuối trang** là bắt buộc, không phải
  trang trí.

## Frame cần vẽ

| Frame | Kích thước | Ghi chú |
|---|---|---|
| `ROUTE-01 · Web · Mặc định` | 1440×1024 | Bố cục chính, đủ các vùng |
| `ROUTE-01 · Web · Loading` | 1440×1024 | Skeleton bản đồ + timeline |
| `ROUTE-01 · Web · Không có tuyến` | 1440×1024 | Empty state thay vùng bản đồ |
| `ROUTE-01 · Web · Dữ liệu một phần` | 1440×1024 | Mẫu thiếu hiện `—` + banner nhắc |
| `ROUTE-01 · Web · Vượt phạm vi dự báo` | 1440×1024 | Nhãn "ngoài 16 ngày" |
| `ROUTE-01 · Web · Lỗi API` | 1440×1024 | Banner lỗi + nút **Thử lại** |
| `ROUTE-01 · Mobile · Mặc định` | 390×844 | Xếp dọc, form thu gọn |
| `ROUTE-02 · Modal · Lưu vào nhật ký` | 720×auto | Hai biến thể: thành công / thất bại |

## Bố cục (theo thứ tự trên trang)

1. **Chrome (`AppHeader`)** — wordmark *Memoir*, điều hướng `Trang chủ / Lưới
   tháng / Lịch sử kiện`, pill **Tiện ích** (đang chọn), chip tài khoản, nút
   **Lưu vào nhật ký**.
2. **Breadcrumb + hero** — `← Trang chủ / Tiện ích / HÀNH TRÌNH & THỜI TIẾT`;
   tiêu đề *Thời tiết theo hành trình*; phụ đề *Kiểm tra thời tiết và điều kiện
   đường sá trên từng đoạn đường trước khi khởi hành.*; hai nút **So sánh giờ
   khởi hành** (viền) và **Lưu vào nhật ký** (đặc).
3. **Banner nguồn** — khối `surface-container-low`: icon info + chữ nguồn dữ
   liệu, và chip trạng thái nguồn (`Dữ liệu trực tiếp · OSRM/Open-Meteo` hoặc
   `Dữ liệu cũ · cập nhật HH:mm`). Nằm ở **cột phải** của dải 2 cột (mục 5), tức
   **chung hàng với form Quản lý lộ trình**.
4. **Strip tóm tắt** — bốn ô: *Lộ trình* · *Khoảng cách* · *Giờ khởi hành* ·
   *Thời gian di chuyển* · *Đến dự kiến*; liên kết **Đảo chiều hành trình**. Cùng
   **cột phải** với banner nguồn.
5. **Form Quản lý lộ trình** *(MỚI — **không** có trong bản Stitch, phải dựng
   thêm theo cùng ngôn ngữ thị giác)* — **cột trái** của dải 2 cột, trên cửa sổ
   rộng chia hàng `4/12` (≈ 384 px) với cột phải `8/12` (banner nguồn + strip tóm
   tắt). Dưới ngưỡng rộng thì ba khối xếp dọc lại: form → nguồn dữ liệu → bản đồ.
   Khối gồm:
   - **Điểm xuất phát** (pill có icon ghim + giá trị + chevron).
   - **Danh sách điểm dừng trung gian**: mỗi hàng có tay kéo để đổi thứ tự, tên
     điểm, ô **Thời gian dừng** (phút), nút xoá; nút **+ Thêm điểm dừng**.
   - **Điểm đến**.
   - Ô **Tìm kiếm địa điểm** + nút **Chọn trên bản đồ**; danh sách gợi ý
     (`TỈNH / THÀNH GỢI Ý` với mục đang chọn có `Đang chọn` + dấu check, giống
     `location_dialog.dart` hiện có).
   - **Phương tiện**: segmented `Ô tô · Xe đạp · Đi bộ`.
   - **Ngày khởi hành** + **giờ khởi hành**.
   - **Tuyến thay thế**: danh sách thẻ (km / thời gian / chênh lệch). **Chỉ hiện
     khi routing API thực sự trả về**; không có thì bỏ hẳn khối này.
6. **Bản đồ** — **chạy full-width ngay bên dưới dải 2 cột** (khác bản Stitch, vốn
   đặt bản đồ trong cột phải). Panel header (*Bản đồ lộ trình & Trạm quan sát thời
   tiết* + tỷ lệ + cụm zoom `+ / − / fit`), viewport: polyline tuyến, marker điểm đi
   / điểm dừng / điểm đến, marker thời tiết, callout cảnh báo (viền vàng + pulse),
   bảng chú thích. **Attribution** đặt ở góc bản đồ.

7. **Phân tích hành trình** — tiêu đề *Dự báo thời tiết dọc hành trình & Biểu đồ
   diễn tiến*; biểu đồ **bar lượng mưa (mm)** + **line nhiệt độ (°C)** theo trục
   `Km`, với trục mốc dưới biểu đồ: `06:30 · Km 0` · `08:45 · Km 75` ·
   `11:15 · Km 185` · `13:15 · Km 305`.
8. **Chi tiết từng chặng** — lưới thẻ (1 cột mobile → 4 cột web): dòng đầu
   `giờ — Chặng N` + chip mức (*Thuận lợi / Bình thường / Cảnh báo trơn*), tên
   điểm, `Km`, icon thời tiết + nhiệt độ, `Mưa: %` + mm, `Gió: km/h`. Chặng đang
   được chú ý có viền đậm + nền sage nhạt.
9. **Khuyến cáo an toàn (cấp độ Vàng)** — khối nền vàng nhạt + viền vàng: tiêu đề
   *Đoạn … (dự kiến HH:MM – HH:MM)*, đoạn văn mô tả, 3 ô gợi ý (tốc độ tối đa /
   hệ thống đèn / điểm dừng chờ), dòng nguồn + câu *Memoir an toàn trên từng dặm
   đường*. **Bắt buộc** ghi rõ: đây là **quy tắc hiển thị của Memoir**, không phải
   khuyến nghị an toàn giao thông chính thức.
10. **So sánh giờ khởi hành** — 3 thẻ lựa chọn (đề xuất / đang chọn / muộn hơn),
    mỗi thẻ có giờ đến và một dòng lý do; nút **Áp dụng giờ xuất phát …**.
11. **Footer disclaimer** — dòng miễn trừ + attribution
    `© OpenStreetMap contributors · OSRM · Open-Meteo`.
12. **Modal `ROUTE-02` Lưu vào nhật ký** — *Tên chuyến đi*, *Liên kết nhật ký*
    (chọn entry có sẵn / **tạo nhật ký mới**), *Lộ trình*, *Ngày khởi hành*,
    *Thời tiết đính kèm tự động* (khối chỉ đọc), *Cảm xúc & Ghi chú cá nhân*,
    *Ảnh chuyến đi*; hai nút **Huỷ bỏ** / **Xác nhận lưu vào nhật ký**.

## Trạng thái bắt buộc

| Trạng thái | Thể hiện |
|---|---|
| Loading | skeleton ở bản đồ + timeline; nút tính tuyến ở trạng thái disabled |
| Không có tuyến | empty card giữa vùng bản đồ + gợi ý đổi điểm hoặc phương tiện |
| Lỗi API / vượt giới hạn | banner lỗi phía trên vùng phân tích + nút **Thử lại** |
| Dữ liệu một phần | banner *"Chỉ có dữ liệu cho một phần hành trình"*, mẫu thiếu hiển thị `—` |
| Vượt phạm vi dự báo | chip cảnh báo *"Ngoài phạm vi dự báo (16 ngày)"* |
| Dữ liệu đã lỗi thời | nhãn *"Dữ liệu cũ · cập nhật HH:mm"* cạnh chip nguồn |
| Chưa đăng nhập | không vào được màn (guard đưa về `/login`) |
| Lưu thành công / thất bại | nút đổi sang *Đã lưu thành công* / SnackBar lỗi và **giữ nguyên form** |

## Token dùng

- **Màu**: `surfaceCard`, `surfaceBrandSubtle`, `borderDefault` cho khung;
  `feedbackWarning` + `feedbackWarningBackground` cho khối khuyến cáo;
  `feedbackError` cho mưa lớn / cảnh báo nặng; `textPrimary` / `textSecondary`
  cho chữ; `actionPrimary` cho nút đặc.
- **Chữ**: `MemoirType` — headline cho tiêu đề màn, title cho tiêu đề khối, body
  cho nội dung, label cho nhãn nút, caption cho nhãn phụ; số liệu (`Km`, `°C`,
  `mm`, `%`) dùng cỡ caption/nhãn mono để thẳng cột.
- **Khoảng & bán kính**: `MemoirSpace.s3…s6`; `MemoirRadius.card` cho khối lớn,
  `MemoirRadius.control` cho input / pill / chip.

## Khác Figma có chủ ý

- **Bản đồ**: bản Stitch vẽ tay một "bản đồ giấy" tĩnh (đường bình độ, mảng cao
  nguyên). Khi dựng thật, ưu tiên **tile OSM thật** để bấm chọn được điểm; nếu
  chọn giữ bản đồ giấy thì phải ghi rõ là **không pan/zoom được**. Xem
  [12-route-weather.md §17](../12-route-weather.md).
- **Số liệu minh họa**: khi chưa nối API, màn phải ghi rõ
  `Dữ liệu minh họa · Chưa kết nối API` — giống quy ước của màn thời tiết hiện có.
- **Form Quản lý lộ trình không có trong Stitch** — dựng mới theo đúng ngôn ngữ
  "Warm Editorial Canvas", không bịa thêm style khác.
- **Icon**: các icon Material Symbols trong bản thiết kế (`explore`, `schedule`,
  `swap_vert`, `warning`, `rainy`, `foggy`, `cloud_sync`, `fit_screen`…) **chưa
  được export** sang `assets/icons/` ⇒ dùng `Icons.*` của Material như mọi màn khác.
- **Attribution là bắt buộc**, không phải trang trí: đặt ở góc bản đồ và/hoặc
  dòng nguồn cuối trang.
- **Không dùng chữ khẳng định chắc chắn** ("sẽ mưa", "bão sẽ đổ bộ") — chỉ
  "dự kiến", "có thể", "xác suất".

