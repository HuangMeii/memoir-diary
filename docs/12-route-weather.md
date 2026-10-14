# 12 — Thời tiết theo hành trình (Route Weather Planner)

> **Trạng thái: ĐÃ TRIỂN KHAI** (Phase 22–27) — backend Serverpod (`RouteEndpoint`, `JourneysEndpoint`) + màn **Tiện ích → Thời tiết hành trình**.
> Đặc tả dưới đây vẫn là nguồn chân lý cho hành vi. **§18 ghi lại những chỗ bản dựng khác đặc tả** và các quyết định đã chốt sau khi đo nhà cung cấp thật.
> Thiết kế tham chiếu: `ui-figma/stitch_weather_route_planner_ui/` và `ui-figma/thời tiết hành trình.svg`.

---

## 1. Mục tiêu & phạm vi

Người dùng nhập một lộ trình (điểm xuất phát, các điểm dừng trung gian, điểm đến, phương tiện, ngày giờ khởi hành, thời gian dừng), rồi xem **thời tiết dự kiến tại từng mốc thời gian tương ứng trên đường đi**.

### 1.1. Bảng đối chiếu yêu cầu ↔ hạng mục

| # | Yêu cầu | Hạng mục thực hiện |
|---|---|---|
| A | Quản lý lộ trình: điểm đi / điểm dừng / điểm đến, tìm kiếm & chọn trực tiếp trên bản đồ, tuyến thay thế, phương tiện, ngày giờ khởi hành, thời gian dừng, hiển thị km / thời gian / ETA | `RouteEndpoint.plan` + `RouteEndpoint.searchPlaces`, form `ui/route/route_planner_panel.dart` |
| B | Dự báo thời tiết theo lộ trình: lấy hình học tuyến, điểm mẫu, ETA từng mẫu, gọi weather API theo toạ độ + thời điểm, hiển thị các chỉ số, đánh dấu đoạn bất lợi, phân biệt dự báo / không có / lỗi thời | `RouteEndpoint.forecast` + §5, §6, §7 |
| C | Tương tác bản đồ & timeline: marker địa điểm + marker thời tiết, chọn marker ↔ highlight timeline, đổi điểm dừng / phương tiện / giờ thì cập nhật lại | `ui/route/route_map_view.dart`, `ui/route/route_timeline.dart`, state `routePlannerProvider` |
| D | Tích hợp nhật ký: lưu hành trình vào tài khoản, lưu tên / điểm dừng / tuyến / giờ / thời gian dự kiến, liên kết hoặc tạo nhật ký, ghi chú + ảnh, xem lại sau chuyến đi, phân biệt bản tóm tắt đã lưu với dự báo mới nhất | `JourneysEndpoint` + §8 + modal `ui/route/save_journey_dialog.dart` |
| E | Trạng thái hệ thống: loading, không có tuyến, lỗi / vượt giới hạn, dữ liệu một phần, vượt phạm vi dự báo, lưu thành công / thất bại, chưa đăng nhập / không có quyền | §10 |

### 1.2. Những việc **KHÔNG** làm (non-goals)

1. **Không tự xây dựng mô hình dự đoán thời tiết.** Chỉ đọc dữ liệu nhà cung cấp; không nội suy "sáng tạo" ngoài dữ liệu trả về.
2. **Không khẳng định chắc chắn** mưa / bão / nắng "sẽ xảy ra". Mọi câu chữ dùng dạng *"dự kiến", "có thể", "xác suất"*, kèm dòng miễn trừ cuối trang.
3. **Không dẫn đường turn-by-turn / thoại.** Chỉ hiển thị tuyến + thời tiết dọc tuyến.
4. **Không tự định vị GPS.** Điểm xuất phát mặc định lấy từ vị trí thời tiết đã lưu trên `users` (`weather_lat` / `weather_lon`), user tự đổi — cùng giả định §9 của [11-weather-forecast.md](11-weather-forecast.md).
5. **Không lưu mọi lần bấm "Xem".** Chỉ ghi vào DB khi user chủ động bấm **Lưu vào nhật ký**.
6. **Không dự báo quá 16 ngày** (§5.5) và không giả vờ có dữ liệu khi nhà cung cấp không trả.

---

## 2. Vì sao chọn các nhà cung cấp này

| Nhu cầu | Nhà cung cấp | Vì sao |
|---|---|---|
| Routing (tuyến + hình học + thời gian) | **OSRM** | Miễn phí, **không cần API key**, trả `distance` / `duration` **theo từng leg**, có `geometries=geojson` và `alternatives`. Cùng triết lý "không có bí mật nào phải giữ" như Open-Meteo ([11-weather-forecast.md §1](11-weather-forecast.md)) |
| Tìm địa điểm theo tên | **Nominatim** | OSM giữ địa chỉ tới tầng **đường / phường** (GeoNames mà Open-Meteo dùng thì không), trả **tên tiếng Việt có dấu** qua `accept-language=vi`, miễn phí không key |
| Dự báo dọc tuyến | **Open-Meteo Forecast** | Nhận **nhiều toạ độ trong một request** (`latitude=a,b,c&longitude=…`), có `precipitation_probability`, `precipitation`, `temperature_2m`, `wind_speed_10m`, `wind_gusts_10m`, `visibility`, `weather_code`; tối đa **16 ngày** |
| Nền bản đồ | **OSM raster tiles** | Không key, hiển thị được bằng `flutter_map` trên cả web và mobile |

**Ánh xạ phương tiện ↔ profile OSRM** (mục A — "phương tiện di chuyển phù hợp với routing API"):

| Lựa chọn UI | Profile OSRM | Ghi chú |
|---|---|---|
| `car` — Ô tô / Xe máy | `driving` | Mặc định |
| `bike` — Xe đạp | `bike` | Instance phải có profile bike |
| `foot` — Đi bộ | `foot` | |
| `transit` — Công cộng | — | **Không hỗ trợ ở bản đầu**: OSRM không có profile transit. UI **ẩn** lựa chọn này thay vì trả kết quả sai |

> ⚠️ Instance OSRM công khai là **server demo**: có giới hạn truy vấn và không cam kết SLA. Vì vậy đặc tả luôn dùng timeout cứng 5 s (§11), cache 30 phút, base URL ghi đè được bằng biến cấu hình (§12), và mọi chỗ hiển thị đều ghi rõ nguồn dữ liệu.

> ⚠️ Nominatim là server **do cộng đồng quyên góp** và **cấm auto-complete search** (usage policy). Vì vậy tìm địa điểm **chỉ chạy khi user bấm nút / Enter**, client chặn **1,5 giây** giữa hai lần tìm (§11), và query luôn kèm `countrycodes=vn`.

---

## 3. Kiến trúc: backend làm trung gian

```
Flutter ──> Serverpod /route/*    ──> OSRM (routing) + Nominatim (geocoding)
        │
        └────> Serverpod /journeys/* ──> Open-Meteo Forecast (nhiều toạ độ)
                                                │
                                    PostgreSQL: journeys, journey_stops,
                                                journey_weather_points
```

**Không cho Flutter gọi thẳng OSRM / Geocoding / Forecast.** Bốn lý do:

1. **Chỗ duy nhất** để đổi nhà cung cấp, đổi profile hoặc thay instance OSRM — client không phải sửa.
2. **Cache**: đổi qua lại giữa các mục timeline không nên bắn lại hàng chục request lên nhà cung cấp.
3. **Chống lạm dụng**: trần số điểm mẫu và tần suất được ép ở server, không tin client.
4. **Lịch sử**: bản tóm tắt dự báo lúc lưu phải nằm trong DB để "xem lại sau chuyến đi".

Ánh xạ mã WMO → 5 nhóm `weathers` **dùng lại nguyên bảng ở [11-weather-forecast.md §3](11-weather-forecast.md)** — không định nghĩa lại, không thêm nhóm mới.

---

## 4. Luồng dữ liệu

### 4.1. A — Quản lý lộ trình

1. User mở **Tiện ích → Thời tiết theo hành trình**; app nạp vị trí đã lưu trên hồ sơ (`weather_lat` / `weather_lon`) làm **điểm xuất phát**.
2. **Gõ thẳng tên đường / địa chỉ vào ô của điểm đó** rồi **bấm nút Tìm kiếm hoặc Enter** → `RouteEndpoint.searchPlaces(query)` → gợi ý hiện ngay dưới điểm đó; chọn một dòng để gán toạ độ. Không có bước mở ô tìm kiếm riêng, và **không** tìm trong lúc đang gõ: Nominatim cấm auto-complete (§11).
3. Hoặc **chọn trực tiếp trên bản đồ**: bấm vào bản đồ lấy toạ độ và gán vào điểm đi / điểm dừng / điểm đến (không cần geocode ngược).
4. **Thêm nhiều điểm dừng trung gian**, sắp xếp lại thứ tự, xoá; mỗi điểm có **thời gian dừng** (phút). **Đảo chiều hành trình** = đảo danh sách điểm.
5. Chọn **phương tiện** và **ngày + giờ khởi hành**.
6. `RouteEndpoint.plan(...)` → OSRM trả tuyến (hoặc nhiều tuyến): `distanceMeters`, `durationSeconds`, `geometry` (GeoJSON LineString), `legs[]`. Nếu có **tuyến thay thế** (`alternatives=true` **và** OSRM thực sự trả về) → UI hiện danh sách để chọn; nếu không có thì **ẩn hẳn** mục này (đúng chữ "khi được hỗ trợ").
7. Hiện **khoảng cách**, **thời gian di chuyển ước tính** và **thời gian đến dự kiến** = `departureAt` + `duration` + Σ`dwell`.

### 4.2. B — Dự báo thời tiết theo lộ trình

1. Lấy **tuyến đường + hình học tuyến** từ kết quả `plan`.
2. Sinh **các điểm mẫu đại diện dọc tuyến** (§5.1).
3. Ước tính **thời điểm đi qua** từng điểm mẫu từ `leg.duration` + `dwell` (§5.3).
4. Gọi Open-Meteo **một request cho tất cả toạ độ mẫu**, các biến `hourly` (§5.4).
5. Ghép mỗi mẫu với giờ gần nhất ⇒ **nhiệt độ, trạng thái thời tiết, xác suất mưa, lượng mưa, tốc độ gió** — chỉ hiện chỉ số nào nhà cung cấp thực sự trả.
6. Hiển thị ở **điểm đầu, điểm dừng, điểm đến và các vị trí mẫu dọc đường**.
7. Chấm **mức bất lợi** theo bảng quy tắc §6 (`info` / `caution` / `warning`) kèm `reasons` dạng chữ.
8. Gắn `status` cho **từng mẫu**: `forecast` (dữ liệu dự báo) · `unavailable` (dữ liệu không có sẵn) · `stale` (dữ liệu đã lỗi thời, lấy từ cache); và cho **cả báo cáo**: `coverage = full | partial | none`.

### 4.3. C — Tương tác bản đồ & timeline

1. Vẽ bản đồ + tuyến **cắt thành từng lát tô màu theo mức bất lợi** (xanh / cam / đỏ, xám nét đứt khi thiếu dự báo — xem §18.3) + marker địa điểm + bảng chú thích màu.
2. Bấm một điểm trên bản đồ → **đặt điểm dừng đang chọn** vào đúng điểm đó (mục A).
3. Bấm mục timeline / điểm trên biểu đồ / dải khuyến cáo → **làm dày lát đường chứa mẫu đó**, đóng khuyên đánh dấu tại mẫu và cuộn bản đồ tới mẫu.
4. Đổi điểm dừng / phương tiện / giờ khởi hành → **tính lại tuyến và dự báo** (debounce ≥ 400 ms; huỷ request cũ khi có kết quả mới).
5. Chọn tuyến thay thế → tính lại dự báo theo hình học mới.

### 4.4. D — Tích hợp nhật ký

1. Trong modal **Lưu vào nhật ký**, nhập **tên chuyến đi**; hiện `Lộ trình`, `Ngày khởi hành`, **tóm tắt thời tiết đính kèm** và ô ghi chú.
2. Chọn **liên kết nhật ký hiện có** (entry của ngày khởi hành, nếu đã có) hoặc **tạo nhật ký mới**. Vì `diary_entries` là `UNIQUE (user_id, entry_date)` và `EntriesEndpoint.create` đã **upsert theo ngày**, "tạo mới" = tạo/ghi vào entry của ngày khởi hành.
3. Bổ sung **ghi chú** (`journeys.notes`) và **ảnh** — ảnh gắn vào entry (`entry_images`) qua `entry_id`.
4. `JourneysEndpoint.save(...)` lưu `journeys` + `journey_stops` + `journey_weather_points` (ảnh chụp dự báo tại thời điểm lưu).
5. Mở lại hành trình đã lưu: hiện **bản tóm tắt đã lưu** (`journey_weather_points`, kèm nhãn *"Bản tóm tắt đã lưu lúc HH:mm dd.MM.yyyy"*) và một nút riêng **"Cập nhật dự báo mới nhất"** (gọi lại `RouteEndpoint.forecast`). Hai khối **tách biệt**, không trộn số cũ với số mới.

---

## 5. Thuật toán

Toàn bộ phần này là **hàm thuần Dart** ở `memoir_server_server/lib/src/route/route_service.dart` ⇒ viết unit test được, không cần mạng.

### 5.1. Điểm mẫu dọc tuyến

- Đầu vào: `geometry` GeoJSON LineString (danh sách `[lon, lat]`), `stops` (điểm đi, các điểm dừng, điểm đến), `legs[]`.
- **Bắt buộc** có mặt trong tập mẫu: **mọi `stop`** và **ranh giới mỗi leg** (để ETA khớp `leg.duration` thật).
- Giữa hai mốc liên tiếp, thêm mẫu cách nhau **`ROUTE_SAMPLE_STEP_KM = 25`** km, đo bằng **khoảng cách tích luỹ haversine**.
- **Trần `ROUTE_MAX_SAMPLES = 25`** mẫu cho toàn tuyến (để một request Open-Meteo là đủ). Nếu vượt trần: **tăng bước mẫu** chứ **không** cắt bớt điểm dừng.

### 5.2. Toạ độ điểm mẫu

Điểm mẫu nằm **trên hình học tuyến** (nội suy giữa hai đỉnh gần nhất theo tỉ lệ khoảng cách), **không** làm tròn về đỉnh gần nhất — để marker nằm đúng trên đường vẽ.

### 5.3. Thời điểm đi qua (ETA)

```
eta(stop_0)  = departureAt
eta(stop_k)  = eta(stop_{k-1}) + leg[k-1].duration + dwell(stop_{k-1})
eta(mẫu giữa hai mốc) = eta(mốc trước) + fraction_km × duration_của_leg_chứa_nó
```

- `dwell` (thời gian dừng) chỉ áp cho **điểm dừng**, không áp cho mẫu dọc đường.
- Dùng `leg.duration` **thật của OSRM**, không suy từ tốc độ trung bình — vì tốc độ phụ thuộc địa hình.
- `arrivalAt` của điểm đến cuối cùng chính là **thời gian đến dự kiến** hiển thị ở mục A.

### 5.4. Ghép giờ với dữ liệu dự báo

- Request `hourly` trả mảng theo giờ; với mẫu có ETA `t`, chọn **index giờ gần nhất không lớn hơn `t`** (floor) trong múi giờ `Asia/Ho_Chi_Minh`.
- Mẫu rơi ngoài khung giờ nhà cung cấp trả ⇒ `status = unavailable`; nếu do vượt 16 ngày thì kèm `beyondRange` và báo cáo `coverage = partial`.
- Nếu Open-Meteo trả **ít toạ độ hơn** số mẫu đã gửi ⇒ các mẫu thiếu vẫn hiện **vị trí + ETA**, chỉ số thời tiết để `—`, báo cáo `coverage = partial`.
- Đơn vị: `°C` · `mm` · `%` · `km/h`. Chỉ thêm chữ mô tả ("giật", "se lạnh") khi có cơ sở từ `wind_gusts_10m` / `temperature_2m`.

### 5.5. Phạm vi dự báo

`departureAt + duration + Σdwell` vượt quá **16 ngày** kể từ hôm nay ⇒ trả `beyondRange` (mục E). Không "đoán" cho phần vượt.

---

## 6. Quy tắc xác định đoạn bất lợi (nguồn chân lý duy nhất)

Đặt tại `memoir_server_server/lib/src/route/route_rules.dart`. **Server trả `severity` + `reasons`; UI chỉ hiển thị** — không lặp lại ngưỡng trong Dart của Flutter.

| Nhóm | Ngưỡng | `severity` | `reason` |
|---|---|---|---|
| Mưa vừa | `precipitation ≥ 2.5 mm/h` **hoặc** (`precipitation_probability ≥ 60%` và `precipitation ≥ 1 mm/h`) | `caution` | "Mưa vừa, đường có thể trơn" |
| Mưa lớn | `precipitation ≥ 7.6 mm/h` | `warning` | "Mưa lớn, hạn chế tầm nhìn" |
| Dông / bão | `weather_code ∈ {95, 96, 97, 99}` **hoặc** `wind_gusts_10m ≥ 60 km/h` | `warning` | "Dông, gió giật mạnh" |
| Gió mạnh | `wind_speed_10m ≥ 40 km/h` | `caution` | "Gió mạnh" |
| Sương mù | `weather_code ∈ {45, 48}` **hoặc** `visibility < 1000 m` | `caution` | "Sương mù, tầm nhìn hạn chế" |
| Nóng | `temperature_2m ≥ 35 °C` | `caution` | "Nắng nóng" |
| Lạnh | `temperature_2m ≤ 10 °C` | `caution` | "Trời lạnh" |

Quy tắc chung:

- Một mẫu có thể khớp **nhiều nhóm** ⇒ trả **mọi** `reason`; `severity` lấy **mức cao nhất**.
- Thứ tự mức: `warning` > `caution` > `info`. Không nhóm nào khớp ⇒ `info`, **không** hiện callout.
- **Đoạn bất lợi liên tục** (hai mẫu liền kề cùng `severity ≥ caution`) gộp thành **một dải cảnh báo** `[start_at – end_at]` để panel "Khuyến cáo an toàn" hiển thị (`alerts[]` trong §9).
- Ngưỡng là **quy tắc hiển thị của Memoir**, **không phải** khuyến nghị an toàn giao thông chính thức. Panel phải ghi rõ điều này + nguồn dữ liệu.

---

## 7. Ánh xạ mã WMO → 5 nhóm `weathers`

Dùng **nguyên** bảng ở [11-weather-forecast.md §3](11-weather-forecast.md) (`sunny` · `cloudy` · `rainy` · `storm` · `other`). Khác duy nhất ở chỗ: ở đây áp cho **từng mẫu giờ dọc tuyến**, không phải theo ngày. Không thêm nhóm mới, không đổi `weathers`.

---

## 8. Thiết kế dữ liệu

Cả ba bảng đều thuộc về một user (trực tiếp qua `user_id`, hoặc gián tiếp qua `journey_id`) ⇒ **cách ly dữ liệu theo tài khoản** như mọi bảng nghiệp vụ khác.

### 8.1. Bảng `journeys`

| Cột | Kiểu | Ràng buộc | Mô tả |
|---|---|---|---|
| id | uuid | PK | |
| user_id | uuid | FK→users(id) CASCADE, indexed | Chủ sở hữu |
| title | varchar(150) | NOT NULL | Tên chuyến đi |
| vehicle | varchar(20) | NOT NULL | `car` / `bike` / `foot` |
| departure_at | timestamptz | NOT NULL | Giờ khởi hành |
| origin_name | varchar(200) | NOT NULL | |
| origin_lat / origin_lon | double precision | NOT NULL | |
| destination_name | varchar(200) | NOT NULL | |
| destination_lat / destination_lon | double precision | NOT NULL | |
| distance_meters | int | NOT NULL | Tổng quãng đường |
| duration_seconds | int | NOT NULL | Thời gian di chuyển (chưa gồm `dwell`) |
| geometry | text | NOT NULL | GeoJSON LineString của tuyến đang chọn |
| notes | text | NULL | Ghi chú chuyến đi |
| entry_id | uuid | FK→diary_entries(id) ON DELETE SET NULL | Nhật ký liên kết |
| weather_saved_at | timestamptz | NULL | Lúc chụp bản tóm tắt dự báo |
| created_at / updated_at | timestamptz | NOT NULL | |

### 8.2. Bảng `journey_stops`

| Cột | Kiểu | Ràng buộc | Mô tả |
|---|---|---|---|
| id | uuid | PK | |
| journey_id | uuid | FK→journeys(id) CASCADE, indexed | |
| seq | int | NOT NULL | Thứ tự `0..n` |
| kind | varchar(20) | NOT NULL | `origin` / `waypoint` / `destination` |
| name | varchar(200) | NOT NULL | |
| lat / lon | double precision | NOT NULL | |
| dwell_minutes | int | NOT NULL default 0 | Thời gian dừng |
| arrival_at | timestamptz | NULL | ETA tại thời điểm lưu |
| distance_from_start_meters | int | NULL | Km tích luỹ (nhãn "Km 75") |

**Ràng buộc**: `UNIQUE (journey_id, seq)`.

### 8.3. Bảng `journey_weather_points`

Ảnh chụp dự báo **tại thời điểm lưu** — chính là căn cứ để "phân biệt bản tóm tắt dự báo đã lưu với dự báo thời tiết mới nhất" (mục D).

| Cột | Kiểu | Ràng buộc | Mô tả |
|---|---|---|---|
| id | uuid | PK | |
| journey_id | uuid | FK→journeys(id) CASCADE, indexed | |
| seq | int | NOT NULL | Trùng `seq` mẫu trong báo cáo |
| sample_at | timestamptz | NOT NULL | Thời điểm dự kiến đi qua |
| lat / lon | double precision | NOT NULL | |
| label | varchar(200) | NULL | Tên mốc (điểm dừng / "Km 185") |
| weather_code | int | NULL | Mã WMO gốc |
| weather_id | int | NULL | FK→weathers(id) |
| temp_c | double precision | NULL | |
| precipitation_mm | double precision | NULL | |
| precipitation_probability | int | NULL | % |
| wind_speed_kmh | double precision | NULL | |
| severity | varchar(20) | NULL | `info` / `caution` / `warning` |
| fetched_at | timestamptz | NOT NULL | Lúc lấy từ Open-Meteo |

**Ràng buộc**: `UNIQUE (journey_id, seq)`.

> `journeys.entry_id` là liên kết **mềm**: xoá nhật ký thì hành trình **vẫn còn**, chỉ mất liên kết (`ON DELETE SET NULL`). Chuyến đi và trang nhật ký là hai thứ độc lập.

---

## 9. API dự kiến

| Method | Endpoint | Mô tả |
|---|---|---|
| `searchPlaces` | `route.searchPlaces(query, {limit})` | Tìm địa điểm theo tên (Nominatim, chỉ Việt Nam) |
| `plan` | `route.plan({origin, destination, waypoints, vehicle, alternatives})` | Tuyến + hình học + leg (+ tuyến thay thế) |
| `forecast` | `route.forecast({stops, departureAt, vehicle, geometry})` | Điểm mẫu + ETA + thời tiết + cờ bất lợi |
| `planWithWeather` | `route.planWithWeather(...)` | Ghép `plan` + `forecast` cho một lần bấm |
| `compareDepartures` | `route.compareDepartures({..., hours})` | Bảng "So sánh giờ khởi hành" |
| `list` / `get` | `journeys.list()` · `journeys.get(id)` | Hành trình đã lưu (kèm bản tóm tắt) |
| `save` | `journeys.save({..., title, notes, entryId, linkMode})` | Lưu hành trình + snapshot dự báo |
| `delete` | `journeys.delete(id)` | Xoá hành trình |

```json
// route.plan  (rút gọn) — JSON đã đổi sang snake_case bởi ServerpodDataSource
{
  "route": {
    "distance_meters": 305400,
    "duration_seconds": 23400,
    "geometry": { "type": "LineString", "coordinates": [[106.63, 10.76], [108.44, 11.94]] },
    "legs": [
      { "distance_meters": 75000,  "duration_seconds": 5400,  "to_index": 1 },
      { "distance_meters": 230400, "duration_seconds": 18000, "to_index": 2 }
    ]
  },
  "alternatives": [],
  "source": "osrm"
}
```

```json
// route.forecast  (rút gọn)
{
  "generated_at": "2026-10-11T06:20:00+07:00",
  "coverage": "partial",
  "source": "api",
  "beyond_range": false,
  "samples": [
    {
      "seq": 0, "label": "TP. Hồ Chí Minh", "kind": "origin",
      "lat": 10.76, "lon": 106.63, "distance_from_start_meters": 0,
      "arrival_at": "2026-10-11T06:30:00+07:00",
      "weather_code": 0, "condition": "Trời quang", "icon": "☀️",
      "temp_c": 27.0, "precipitation_mm": 0.0, "precipitation_probability": 0,
      "wind_speed_kmh": 6.0, "severity": "info", "reasons": [],
      "status": "forecast"
    },
    {
      "seq": 3, "label": "Đèo Bảo Lộc", "kind": "waypoint",
      "lat": 11.53, "lon": 107.80, "distance_from_start_meters": 185000,
      "arrival_at": "2026-10-11T11:15:00+07:00",
      "weather_code": 80, "condition": "Mưa rào", "icon": "🌧️",
      "temp_c": 23.0, "precipitation_mm": 14.0, "precipitation_probability": 80,
      "wind_speed_kmh": 18.0, "severity": "warning",
      "reasons": ["Mưa lớn, hạn chế tầm nhìn", "Gió mạnh"],
      "status": "forecast"
    }
  ],
  "alerts": [
    {
      "severity": "warning",
      "start_at": "2026-10-11T11:00:00+07:00",
      "end_at": "2026-10-11T12:30:00+07:00",
      "title": "Đèo Bảo Lộc",
      "summary": "Mưa lớn (14 mm), gió giật. Đường đèo có thể trơn trượt.",
      "from_seq": 3, "to_seq": 4
    }
  ]
}
```

**Kiểu `.spy.yaml` cần thêm**: `GeoPoint`, `PlaceCandidate`, `RouteLeg`, `RouteGeometry`, `RoutePlan`, `RouteAlternative`, `RouteSample`, `RouteAlert`, `RouteWeatherReport`, `Journey`, `JourneyStop`, `JourneyWeatherPoint` — đặt trong `memoir_server_server/lib/src/route/`. Sau đó `serverpod generate` để sinh lại client SDK.

---

## 10. Trạng thái & lỗi (mục E)

| Mã | Khi nào | UI |
|---|---|---|
| `loading` | đang tính tuyến / đang lấy dự báo | skeleton ở bản đồ + timeline; khoá nút gửi để tránh bấm hai lần |
| `noPoints` | OSRM trả `InvalidOptions` — điểm ở `0,0`, tức stop **chưa được gán toạ độ** | "Điểm đi hoặc điểm đến chưa xác định được vị trí. Bấm nút tìm kiếm rồi chọn từ danh sách, hoặc chọn trực tiếp trên bản đồ." |
| `noRoute` | OSRM trả `NoRoute` / `NoSegment` | "Không tìm thấy tuyến đường giữa các điểm đã chọn. Thử đổi điểm hoặc phương tiện." |
| `rateLimited` | HTTP 429 từ OSRM / Open-Meteo | "Đã vượt giới hạn truy vấn. Vui lòng thử lại sau ít phút." + nút **Thử lại** |
| `unavailable` | nhà cung cấp lỗi / timeout 5 s và cache cũng không có | "Không tải được dữ liệu thời tiết." + nút **Thử lại**; tuyến vẫn hiển thị nếu đã có |
| `stale` | kết quả trả từ cache | hiện số liệu + nhãn **"Dữ liệu cũ · cập nhật HH:mm"** (giống `WeatherForecast.isStale` hiện có) |
| `partialCoverage` | chỉ một phần mẫu có dữ liệu | banner "Chỉ có dữ liệu cho một phần hành trình"; mẫu thiếu hiện `—` |
| `beyondRange` | thời điểm đi qua vượt 16 ngày | "Thời gian yêu cầu vượt quá phạm vi dự báo (16 ngày)." |
| `saveOk` | lưu thành công | SnackBar "Đã lưu hành trình vào nhật ký." |
| `saveFailed` | lưu lỗi | SnackBar lỗi + **giữ nguyên form** để thử lại |
| `unauthenticated` | chưa đăng nhập | `requireLogin = true` → 401 → guard đưa về `/login` (đã có sẵn) |
| `forbidden` | hành trình của user khác | `ensureOwned` → "Bạn không có quyền truy cập hành trình này." |

Ngoài ra, mọi chỗ hiển thị thời tiết phải phân biệt được **ba loại dữ liệu** (mục B): `forecast` (dữ liệu dự báo) · `stale` (dữ liệu đã lỗi thời, từ cache) · `unavailable` (dữ liệu không có sẵn).

---

## 11. Cache & chống lạm dụng

| Tầng | Cơ chế | Mục đích |
|---|---|---|
| Trong bộ nhớ | TTL **30 phút** theo key (toạ độ mẫu làm tròn + ngày + giờ khởi hành) | Đổi qua lại giữa các mục timeline / phương tiện không bắn lại request |
| Trong DB | `journey_weather_points` | Bản tóm tắt sau chuyến đi, xem lại được kể cả khi nhà cung cấp lỗi |

- Timeout cứng **5 s** cho mọi lời gọi ra ngoài; lỗi thì trả cache chứ **không** trả lỗi (giống [11-weather-forecast.md §6](11-weather-forecast.md)).
- Trần **25 điểm mẫu** cho mỗi request thời tiết (§5.1).
- `ROUTE_API_ENABLED=false` để tắt hẳn phần gọi ra ngoài (UI hiện thông báo thay vì lỗi).
- **Gõ vào ô tên điểm bị debounce ≥ 400 ms trước khi gọi `plan`.** Ô tên vừa là ô nhập địa chỉ (§4.1), nên không debounce thì gõ `140 Lê Trọng Tấn` là **16 request** OSRM + Open-Meteo. Cách làm: danh sách điểm hiển thị cập nhật ngay từng phím, nhưng danh sách **đi vào `RouteQuery`** chỉ cập nhật sau khi ngừng gõ. Thao tác rời rạc (chọn từ gợi ý, bấm bản đồ, đổi `dwell`, thêm/xoá/đảo chiều) áp dụng **ngay**, không qua debounce — chờ 400 ms chỉ làm app chậm mà không tránh được gì.
- **Tìm địa điểm chỉ chạy khi bấm nút / Enter** (Nominatim cấm auto-complete). Client chặn nút khi đang chờ **và** trong **1,5 giây** sau lần tìm trước — mềm hơn ngưỡng 1 req/s của Nominatim. Query luôn kèm `countrycodes=vn` để không gợi ý nhầm nước ngoài. Bộ đếm 1,5 giây dùng **chung cho mọi điểm**, nên bấm nhanh ở hai điểm khác nhau cũng bị chặn.

---

## 12. Cấu hình

```env
# OSRM — không cần key. Có thể tự host.
ROUTE_API_URL_CAR=https://routing.openstreetmap.de/routed-car/route/v1/driving
ROUTE_API_URL_BIKE=https://routing.openstreetmap.de/routed-bike/route/v1/driving
ROUTE_API_URL_FOOT=https://routing.openstreetmap.de/routed-foot/route/v1/driving
# Geocoding — Nominatim, không cần key. Có thể tự host.
ROUTE_GEOCODING_URL=https://nominatim.openstreetmap.org/search
ROUTE_GEOCODING_COUNTRY=vn
ROUTE_TIMEOUT_SECONDS=5
ROUTE_CACHE_TTL_MINUTES=30
ROUTE_SAMPLE_STEP_KM=25
ROUTE_MAX_SAMPLES=25
ROUTE_FORECAST_MAX_DAYS=16
ROUTE_API_ENABLED=true
```

> Dùng lại `WEATHER_API_URL` của [11-weather-forecast.md §7](11-weather-forecast.md) cho phần `hourly`; **không** tạo biến trùng.

---

## 13. Màn hình Flutter

| Màn hình / widget | Nội dung |
|---|---|
| `ui/screens/route_weather_screen.dart` | Màn **Tiện ích → Thời tiết theo hành trình**: chrome + form + bản đồ + phân tích + timeline + khuyến cáo + so sánh giờ + disclaimer |
| `ui/route/route_chrome.dart` | Breadcrumb `Trang chủ / Tiện ích / HÀNH TRÌNH & THỜI TIẾT`, tiêu đề, phụ đề, nút **So sánh giờ khởi hành** + **Lưu vào nhật ký**, khối **Dữ liệu trực tiếp** (chip nguồn + bảng 4 ô số liệu, full-width dưới dải 2 cột) |
| `ui/route/route_planner_panel.dart` | **Mục A**: điểm xuất phát / danh sách điểm dừng / điểm đến, tìm kiếm địa điểm, chọn trên bản đồ, chọn phương tiện, ngày–giờ khởi hành, thời gian dừng, đảo chiều, chọn tuyến thay thế |
| `ui/route/route_map_view.dart` | Bản đồ + tuyến cắt lát tô màu theo mức bất lợi + marker địa điểm + chú thích màu; **mục C** (chọn mục timeline ↔ làm dày lát và cuộn tới mẫu) |
| `ui/route/route_segments.dart` | Hàm thuần cắt hình học tuyến thành các lát theo `distanceFromStartMeters`, gán mức của cả lát và gộp lát liền kề cùng mức |
| `ui/route/route_progress_chart.dart` | Bar lượng mưa + line nhiệt độ theo `Km`, trục mốc `Km 0 / 75 / 185 / 305` |
| `ui/route/route_timeline.dart` | Thẻ từng chặng: `giờ — Chặng N`, tên, `Km`, nhiệt độ, `Mưa %` + mm, gió, chip mức |
| `ui/route/route_alerts_panel.dart` | Dải cảnh báo bất lợi (cấp độ Vàng) gộp từ `alerts[]` + ghi rõ nguồn và tính chất tham khảo |
| `ui/route/route_departure_compare.dart` | So sánh giờ khởi hành (`compareDepartures`), chọn giờ đề xuất |
| `ui/route/save_journey_dialog.dart` | Modal **Lưu vào nhật ký**: tên chuyến, liên kết / tạo entry, tóm tắt đính kèm (chỉ đọc), ghi chú, ảnh |

- **Đăng ký màn**: thêm một dòng vào `ui/utilities.dart` → `utilityItems` (label `Thời tiết hành trình`), đúng cách `weather_screen.dart` đang được đăng ký.
- **State**: màn giữ phần nhập liệu (điểm, phương tiện, giờ, tuyến đang chọn, mục đang chọn) trong `State` của chính nó; dữ liệu đọc qua `routePlanProvider` (gộp `plan` + dự báo trong một request), `routeDeparturesProvider`, `placeSearchProvider`, `journeysProvider`, `journeyDetailProvider(id)` — danh sách thật xem §18.2.
- **Repository**: `data/repositories/route_repository.dart`, thêm nhánh path trong `data/datasources/serverpod_data_source.dart` (`/route/plan`, `/route/forecast`, `/journeys`, …) và model Dart trong `data/models.dart` — đúng pattern hiện có.
- **Icon**: các icon Material Symbols trong bản thiết kế (`explore`, `schedule`, `swap_vert`, `warning`, `rainy`, `foggy`, `cloud_sync`…) chưa được export sang `assets/icons/` ⇒ dùng `Icons.*` của Material như mọi màn khác.

---

## 14. An toàn dữ liệu & giấy phép

- **Attribution bắt buộc** trên bản đồ và ở dòng nguồn: *"© OpenStreetMap contributors · OSRM · Open-Meteo"*. Nominatim cũng dùng dữ liệu OSM nên dòng này đã bao trùm, không cần thêm tên nhà cung cấp.
- Dòng miễn trừ cuối trang, giữ đúng ý bản thiết kế:
  *"Dự báo thời tiết hành trình mang tính tham khảo cho cá nhân. Hãy luôn quan sát biển báo và điều kiện giao thông thực tế khi lái xe."*
- Không dùng ngôn ngữ khẳng định chắc chắn (§1.2) — chỉ "dự kiến", "có thể", "xác suất".
- Toạ độ hành trình là **dữ liệu cá nhân**: chỉ ghi vào DB khi user bấm lưu; chỉ gửi lên nhà cung cấp những toạ độ mẫu cần thiết cho request thời tiết.

---

## 15. Kiểm thử dự kiến

| Loại | Nội dung |
|---|---|
| Unit (Dart thuần, không mạng) | haversine & khoảng cách tích luỹ; cắt tuyến thành lát màu (mức của lát = mức cao nhất hai đầu, gộp lát liền kề, thiếu dữ liệu → `unknown`, mẫu lệch thứ tự, mẫu vượt cuối hình học); sinh điểm mẫu (bước 25 km, trần 25, **giữ đủ stop**); ETA (`dwell` chỉ áp ở stop); ghép index giờ; bảng quy tắc §6 (mọi ngưỡng + giá trị biên); vượt 16 ngày → `beyondRange` |
| Widget | 6 trạng thái: loading / noPoints / noRoute / unavailable / partial / beyondRange; chọn mục timeline → **làm dày lát đường + khuyên đánh dấu** tại mẫu tương ứng |
| Tích hợp (thủ công) | một tuyến thật TP.HCM → Đà Lạt: 4 mốc, có cảnh báo, lưu vào nhật ký, mở lại xem **bản tóm tắt đã lưu** tách khỏi dự báo mới |

---

## 16. Chia phase

| Phase | Nội dung |
|---|---|
| 22 | Backend: `route_service` (OSRM + geocoding + sampling + ETA + rules) + `RouteEndpoint` + test Dart thuần |
| 23 | Backend: bảng `journeys` / `journey_stops` / `journey_weather_points` + `JourneysEndpoint` + migration |
| 24 | Flutter: `route_repository`, model, provider, nhánh `ServerpodDataSource` |
| 25 | Flutter UI: chrome + **form quản lý lộ trình (A)** + bản đồ (C) + timeline + biểu đồ + khuyến cáo |
| 26 | Flutter: modal lưu nhật ký (D) + màn xem lại hành trình (bản tóm tắt đã lưu ↔ dự báo mới nhất) + toàn bộ trạng thái (E) |
| 27 | Đóng gói: `flutter analyze` + `flutter test`, kiểm tra web & mobile, cập nhật docs |

**Definition of Done**: `flutter analyze` sạch · unit test §15 xanh · docs cập nhật (`12`, `03-database-schema`, `05-features`, `UI/02-screen-inventory`, `UI-design/28`) · verify trên web · **không** còn chỗ nào khẳng định chắc chắn thời tiết sẽ xảy ra.

---

## 17. Giả định & điểm chưa chốt

1. **Chưa chốt:** bản đồ dùng **tile OSM thật** (`flutter_map` + `latlong2`) hay **vẽ lại "bản đồ giấy" stylized** như SVG thiết kế. Đề xuất: tile thật để thoả "chọn trực tiếp trên bản đồ"; nếu ưu tiên khớp pixel tuyệt đối thì dùng bản đồ giấy (đánh đổi: mất pan/zoom thật, "chọn trên bản đồ" chỉ còn là chọn trên sơ đồ).
2. **Chưa chốt:** có lưu **lịch sử mọi hành trình** hay chỉ giữ hành trình user chủ động lưu. Đề xuất: chỉ lưu khi bấm lưu (đã phản ánh ở §8, §1.2.5).
3. **Chưa chốt:** `compareDepartures` gọi bao nhiêu mốc giờ. Đề xuất **3** (sớm hơn / đang chọn / muộn hơn), đúng bản thiết kế.
4. Giả định instance OSRM công khai đủ dùng cho quy mô cá nhân; nếu bị chặn thì đổi `ROUTE_API_URL_*` sang instance tự host — **không phải sửa code**.
5. Giả định Open-Meteo multi-coordinate trả **đúng thứ tự** toạ độ đã gửi. **Phải kiểm chứng bằng request thật ở Phase 22** trước khi viết logic ghép mẫu.
6. `transit` (công cộng) **không** hỗ trợ ở bản đầu (§2).
7. Bản đầu chỉ giữ **một tuyến đang chọn**; danh sách tuyến thay thế đọc từ `plan.alternatives`.

---

## 18. Bản dựng thực tế (Phase 22–27)

### 18.1. Ba quyết định còn treo ở §17 đã chốt

| Điểm treo | Đã chốt | Vì sao |
|---|---|---|
| Bản đồ | **Tile OSM thật** (`flutter_map` 8.x + `latlong2`) | Cần "chọn trực tiếp trên bản đồ" thật sự: bấm để đặt điểm, pan/zoom, marker theo toạ độ |
| Lịch sử hành trình | **Chỉ lưu khi người dùng bấm Lưu** | Không ghi dữ liệu cá nhân ngoài ý muốn |
| `compareDepartures` | **3 mốc: −2h / +0h / +2h** | Đúng bản thiết kế ("sớm hơn / đang chọn / muộn hơn") |

### 18.2. File đã dựng

**Backend** (`memoir_server/memoir_server_server/lib/src/route/`):

| File | Nội dung |
|---|---|
| `route_service.dart` | haversine, giải mã GeoJSON, sinh điểm mẫu, ETA, gọi OSRM/**Nominatim**/Open-Meteo, ghép giờ, gộp dải cảnh báo, cache 30 phút |
| `route_rules.dart` | Nhóm WMO → `weathers.code` + **bảng ngưỡng bất lợi §6** + `RouteSeverity` |
| `route_endpoint.dart` | `searchPlaces` · `plan` · `forecast` · `planWithWeather` · `compareDepartures` |
| `journeys_endpoint.dart` | `list` · `detail` · `save` · `delete`, kèm upsert nhật ký ngày khởi hành |
| 14 file `.spy.yaml` | `RouteStop`, `PlaceCandidate`, `RouteLeg`, `RouteAlternative`, `RoutePlan`, `RouteWeatherSample`, `RouteAlert`, `RouteWeatherReport`, `RoutePlanWithWeather`, `RouteDepartureOption`, `Journey`, `JourneyStop`, `JourneyWeatherPoint`, `JourneyDetail` |
| `tool/route_smoke.dart` | Script đo nhà cung cấp thật, chạy tay (`dart run tool/route_smoke.dart`) |
| `test/route_service_test.dart` | **31 unit test** cho toàn bộ hàm thuần |

**Migration**: `20261013174623807` (3 bảng mới) và `20261013175627648` (`journey_weather_points.weatherGroup`). Cả hai **chỉ thêm**, không `DROP`.

**Flutter** (`flutter_app/lib/src/`):

| File | Nội dung |
|---|---|
| `ui/screens/route_weather_screen.dart` | Màn `ROUTE-01`: form + bản đồ + biểu đồ + timeline + khuyến cáo + so sánh giờ + các trạng thái mục E |
| `ui/route/route_planner_panel.dart` | **Mục A**: điểm đi/điểm dừng/điểm đến; **ô mỗi điểm vừa là ô nhập địa chỉ** (Enter / nút Tìm để geocode, gợi ý hiện dưới điểm đó), chọn trên bản đồ, phương tiện, ngày–giờ, thời gian dừng, đảo chiều, tuyến thay thế. State tìm kiếm nằm ở panel (không ở widget con) để dùng chung bộ đếm 1,5 giây |
| `ui/route/route_map_view.dart` | Bản đồ tile: tuyến cắt lát tô màu theo mức bất lợi + chú thích màu, marker địa điểm, bấm để đặt điểm dừng, tự cuộn tới và làm dày lát của mục timeline đang chọn |
| `ui/route/route_segments.dart` | `buildRouteSegments`: cắt hình học tại từng mẫu, mức của lát = mức cao nhất của hai mẫu hai đầu, gộp lát liền kề cùng mức, `unknown` khi cả hai đầu đều không có dữ liệu; `routeMetersBetween`/`routeCumulativeMeters`/`routePointAt` dùng chung hằng số bán kính với server |
| `ui/route/route_progress_chart.dart` | Bar mưa + line nhiệt độ theo `Km` (`CustomPainter`) |
| `ui/route/route_timeline.dart` | Thẻ từng chặng, gắn mức bất lợi của **cả đoạn** chứ không chỉ điểm cuối |
| `ui/route/route_panels.dart` | Panel khuyến cáo an toàn + panel so sánh giờ khởi hành |
| `ui/route/route_chrome.dart` | Breadcrumb, hero, khối **Dữ liệu trực tiếp** (chip nguồn trực tiếp / dữ liệu cũ + bảng 4 ô số liệu) |
| `ui/route/save_journey_dialog.dart` | **`ROUTE-02`**: tên chuyến, ghi/không ghi vào nhật ký ngày khởi hành, nội dung đính kèm sửa được, ghi chú |
| `ui/route/saved_journeys_dialog.dart` | **Mục D phần xem lại**: danh sách hành trình, chi tiết một chuyến, **bản tóm tắt đã lưu tách khỏi "Cập nhật dự báo mới nhất"**, xoá hành trình |
| `ui/route/route_format.dart` · `data/repositories/route_repository.dart` · `data/providers.dart` | Định dạng dùng chung, repository, provider (`routePlanProvider`, `routeDeparturesProvider`, `placeSearchProvider`, `journeysProvider`, `journeyDetailProvider`) |

### 18.3. Chỗ bản dựng khác đặc tả (có chủ ý)

1. **`route.forecast` xin `timezone=GMT`, không phải `Asia/Ho_Chi_Minh`.** Múi giờ chỉ dùng để **tra index giờ**; mọi thời gian hiển thị lấy từ `arrivalAt` thật, nên không phụ thuộc múi giờ máy chủ. Điều này bỏ luôn rủi ro lệch múi giờ ở §17.5.
2. **Ghép toạ độ mẫu ↔ entry trả về theo khoảng cách gần nhất**, không theo thứ tự. Nhờ vậy giả định "Open-Meteo trả đúng thứ tự" (§17.5) không còn là rủi ro: kể cả khi provider đổi thứ tự, điểm vẫn nhận đúng dữ liệu.
3. **Tìm địa điểm gửi thẳng chuỗi có dấu, kèm `countrycodes=vn`.** Đo thật trên Nominatim: `Đà Lạt` → *Đà Lạt, Tỉnh Lâm Đồng*; `140 Le Trong Tan` → *… 140, Lê Trọng Tấn, Phường Tây Thạnh, TP.HCM*. Bỏ `countrycodes` thì `Tây Thạnh` bị hiểu thành *Tây Thành / Đà Nẵng* (cách ~600 km), `Le T` chỉ ra địa danh Pháp. Vì vậy `foldForSearch()` đã **bị xoá** — query gửi nguyên bản. Không nối thêm gì vào `q`: gặp dấu phẩy, Nominatim chuyển sang dạng có cấu trúc và đòi đoạn sau dấu phẩy phải là tên vùng **khớp chính xác**.
4. **Gõ vào ô tên điểm bị debounce, nhưng `searchPlaces` thì không.** Hai thứ khác nhau: `plan` bị debounce 400 ms vì gõ tới đâu gọi tới đó là bắn request thừa; `searchPlaces` **không** debounce mà **không gọi** trong lúc gõ, vì Nominatim cấm auto-complete — chỉ chạy khi Enter / bấm nút.
5. **Danh sách điểm có hai bản: bản hiển thị và bản đi vào `RouteQuery`.** `_StopRow` ghi controller từ `stop.name` khi tên đổi từ ngoài, nên nếu debounce thẳng việc ghi tên vào danh sách thì ô nhập sẽ bị nhảy chữ. Tách hai bản giữ được cả hai: ô nhập mượt, và request chỉ bắn sau khi ngừng gõ.
4. **Thêm `weatherGroup` vào `RouteWeatherSample` và `JourneyWeatherPoint`.** Server là nơi duy nhất giữ bảng WMO → `weathers.code`; app chỉ đọc nhóm để chọn icon SVG sẵn có, không lặp lại bảng WMO trong Dart.
5. **`route_rules.dart` giữ một bản sao bảng WMO.** `weather/weather_endpoint.dart` **không bị sửa** để bảo toàn màn thời tiết đang chạy; gộp hai bản là việc riêng, làm sau.
6. **Tuyến thay thế chỉ hỏi khi đúng 2 điểm.** Đo thật: `Hà Nội → Hải Phòng` trả **2 routes**, `TP.HCM → Đà Lạt` trả **1**. Không có thì khối "Tuyến thay thế" ẩn hẳn — đúng chữ "khi được hỗ trợ".
7. **`journeys.save` ghi nhật ký theo yêu cầu.** `createEntry=true` → upsert entry của ngày khởi hành (`diary_entries` là `UNIQUE (user_id, entry_date)`, giống `EntriesEndpoint.create`); `entryId` → liên kết entry có sẵn; không truyền gì → chỉ lưu hành trình.
8. **Ảnh chuyến đi gắn vào nhật ký**, không gắn vào bảng hành trình: dùng lại luồng ảnh sẵn có (`entry_images`), modal ghi rõ "Mở nhật ký sau khi lưu để thêm ảnh".
9. **Khi chọn tuyến thay thế, dự báo được tính lại** cho hình học mới (`route.forecast` với plan của tuyến thay thế, giữ nguyên điểm dừng và thời gian dừng), kèm nút **Về tuyến đề xuất**.
10. **Header web đổi cách chia chỗ.** `nav` và `utilities` nằm trong hai dải cuộn riêng theo tỉ lệ **2 : 1** để pill thứ hai không bao giờ đẩy navigation ra khỏi tầm bấm; pill trong header dùng nhãn ngắn (`Hành trình`), nhãn đầy đủ (`Thời tiết hành trình`) dùng ở khối "Tiện ích" cuối trang.

11. **Tuyến tô màu theo mức bất lợi, thay cho icon mức độ trên marker.** Mỗi đoạn giữa hai mẫu liền kề là một lát, tô bằng **mức cao nhất của hai mẫu hai đầu** — đúng quy tắc `RouteTimeline` dùng cho mỗi chặng, nên bản đồ và thẻ không bao giờ nói lệch nhau. Ba màu lấy **nguyên bộ màu mức độ đã có** (`warning` = đỏ đất `feedbackError`, `caution` = hổ phách `feedbackWarning`, `info` = xanh brand), nên **không sinh token mới** và bản đồ khớp với chip / callout / timeline. Đoạn **thiếu dự báo** (mẫu `unavailable` hoặc không có `weatherCode`) tô **xám nét đứt**: dữ liệu thiếu không được trông như đường tốt. Mẫu `stale` **vẫn tô màu** vì đó là điều tốt nhất app biết.
12. **Không dùng `Polyline.gradientColors` của `flutter_map`.** Painter của gói vẽ gradient **tuyến tính theo màn hình** giữa điểm đầu và điểm cuối của cả polyline (`Gradient.linear(offsets.first, offsets.last, …)` trong `polyline_layer/painter.dart`), nên màu chảy ngang qua khúc cua thay vì bám theo chiều dài đường. Cách đúng là **cắt thành nhiều `Polyline`**, mỗi lát một màu — đúng cách Google Maps vẽ giao thông.
13. **Bỏ marker icon thời tiết trên bản đồ.** Marker là tay bấm duy nhất để chọn mẫu, nên đổi lại: chọn mẫu từ **timeline / biểu đồ / dải khuyến cáo**, bản đồ **làm dày lát** chứa mẫu đó và **đóng khuyên** tại toạ độ mẫu. Vì vậy `RouteMapView` **bỏ tham số `onSelectSample`** (chỉ có một call-site, không test nào dựng widget này).
14. **Màu là *thời tiết*, không phải *giao thông*.** Memoir không có nguồn dữ liệu giao thông (OSRM công khai chỉ trả tuyến, không trả traffic), nên phụ đề mục **Bản đồ lộ trình** và chú thích màu đều ghi rõ "màu đường là mức bất lợi của thời tiết dự kiến". Muốn tô theo kẹt xe phải thêm provider mới (Google Directions `duration_in_traffic` / TomTom / HERE) — việc riêng, ngoài phạm vi.
15. **Bảng chú thích nằm trên bản đồ.** Vì màu đường giờ mang nghĩa, thang màu phải đọc được ngay tại chỗ: khối chú thích đặt góc dưới-phải khung bản đồ (góc dưới-trái đã dành cho attribution), gồm 4 mục `Thuận lợi / Cần chú ý / Cảnh báo / Chưa có dự báo`.

### 18.4. Đã kiểm chứng

| Việc | Kết quả |
|---|---|
| `dart analyze` (workspace `memoir_server`) | sạch |
| `dart test test/route_service_test.dart` | **31/31 xanh** |
| `flutter analyze` | sạch |
| `flutter test` (route + weather + calendar + widget) | **117/117 xanh** — trong đó **15 test mới** cho `route_segments.dart` (`test/route_segments_test.dart`); gồm 51 test `AppHeader`/trang chủ cũ, không hồi quy |
| `tool/route_smoke.dart` (nhà cung cấp thật) | TP.HCM → Đèo Bảo Lộc → Đà Lạt: **293 km / 228 phút**, 6074 điểm hình học, 14 điểm mẫu đều có dữ liệu, ETA khớp `dwell` 30 phút, 2 dải cảnh báo `caution` |

### 18.5. Còn lại (chưa làm)

- **Chưa vẽ frame Figma** cho `ROUTE-01` theo §13: màn đã dựng theo đúng ngôn ngữ thị giác nhưng chưa có bản vẽ để đối chiếu.
- **Gộp bảng WMO** giữa `weather_endpoint.dart` và `route_rules.dart` (mục 18.3.5).
- Số liệu **theo giờ trong màn thời tiết cũ** vẫn là minh họa (việc riêng của Phase 19–20).
- **`transit`** vẫn chưa hỗ trợ, đúng như đặc tả §2.

---

[← Quay lại danh mục tài liệu](../README.md#5-tài-liệu)









