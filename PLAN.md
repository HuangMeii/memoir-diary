# 🗺️ PLAN — Kế hoạch triển khai Memoir

Tài liệu này mô tả lộ trình xây dựng ứng dụng nhật ký **Memoir** (Flutter App + Web, backend **Serverpod/Dart**, Neon Object Storage, PostgreSQL).

> ⚠️ **Cập nhật 2026-10-11:** backend FastAPI đã bị gỡ; backend hiện tại là
> **Serverpod/Dart** (`memoir_server/`). Các mục nhắc FastAPI/uvicorn bên dưới là
> tham chiếu lịch sử — xem [docs/convert/09-remove-fastapi.md](docs/convert/09-remove-fastapi.md).

---

## 1. Mục tiêu

Xây dựng ứng dụng nhật ký đa người dùng, cho phép:
- Ghi nhật ký hằng ngày kèm ảnh, thời tiết và cảm xúc.
- Trực quan hóa cảm xúc/thời tiết theo tháng bằng lưới đổ màu.
- Lưu giữ các mục phản tư cá nhân (góc nhìn khác, nhắn nhủ tương lai, biết ơn, giấc mơ...).
- Nuôi dưỡng động lực bằng kho câu động viên (CRUD) + câu ngẫu nhiên + phản tư.
- Quản lý ghi chú, todo, sự kiện, lịch biểu và theo dõi sức khỏe.
- Biến thời gian học thành động lực: vòng tập trung (timer) → coin/EXP → gieo hạt đậu nảy mầm → mua nước/phân bón → bảng xếp hạng và sự kiện (đặc tả: [docs/09-focus-garden.md](docs/09-focus-garden.md)).
- Quản lý lịch đầy đủ như Google Calendar ở mức vừa phải: ngày/tuần/tháng, timeline theo giờ, sự kiện lặp, nhắc nhở, liên kết Study + Journal (đặc tả: [docs/10-calendar.md](docs/10-calendar.md)).
- Dự báo thời tiết thật từ **Open-Meteo** (miễn phí, không cần key) để gợi ý khi viết nhật ký (đặc tả: [docs/11-weather-forecast.md](docs/11-weather-forecast.md)).

---

## 2. Kiến trúc tóm tắt

`Flutter (App+Web)` ⇄ `FastAPI` ⇄ `Neon Object Storage` (ảnh) + `PostgreSQL` (metadata & nội dung).
Chi tiết: [docs/01-architecture.md](docs/01-architecture.md).

---

## 3. Các Phase

### ✅ Phase 0 — Tài liệu & Thiết kế (HOÀN THÀNH)
- [x] `README.md`, `PLAN.md`
- [x] `docs/01-architecture.md`
- [x] `docs/02-data-flow.md`
- [x] `docs/03-database-schema.md`
- [x] `docs/04-api-reference.md`
- [x] `docs/05-features.md`
- [x] `docs/06-setup-deploy.md`
- [x] `docs/07-ui-design.md`
- [x] `docs/08-quotes-seed.md`

### ✅ Phase 1 — Backend FastAPI + DB + Auth (HOÀN THÀNH)
- [x] Khởi tạo package `backend/app/` (main.py, core, models, schemas, routers, services)
- [x] Cấu hình `.env` (DATABASE_URL, S3_*, JWT_SECRET)
- [x] SQLAlchemy models (13 bảng theo `docs/03-database-schema.md`)
- [x] Alembic init + migration đầu tiên
- [x] Auth: `/auth/register`, `/auth/login`, `/auth/me` (JWT + bcrypt)
- [x] Router CRUD: entries, images, moods, weathers, quotes, self_messages, reflections, notes, todos, events, schedule_items, health_logs
- [x] Storage service (boto3, path-style, presigned URL)
- [x] `/stats/mood-grid`, `/stats/weather-grid`
- [x] Swagger UI hoạt động tại `/docs`

### ✅ Phase 2 — Seed dữ liệu (HOÀN THÀNH)
- [x] Seed `moods` (5), `weathers` (5)
- [x] Seed `quotes` (100 câu từ `docs/08-quotes-seed.md`)
- [x] Script `python -m app.seed.seed` (idempotent)

### ✅ Phase 3 — Flutter scaffold (HOÀN THÀNH)
- [x] `flutter create` (bật web + android + ios)
- [x] Theme Material 3, màu mood/weather, routing (go_router)
- [x] `ApiClient` (dio) + interceptor JWT + secure storage
- [x] Models Dart + repositories

### ✅ Phase 4 — Flutter features (HOÀN THÀNH)
- [x] Auth (login/register/logout) + guard
- [x] Viết nhật ký (form đầy đủ các mục)
- [x] Weather/Mood picker (icon)
- [x] 2 lưới tháng đổ màu
- [x] Kho câu (CRUD) + random pair + phản tư
- [x] Notes, Todo, Events, Schedule
- [x] Health (bước chân, thời gian tập) + biểu đồ 30 ngày (`fl_chart`)

### ✅ Phase 5 — Upload ảnh end-to-end (HOÀN THÀNH)
- [x] Flutter chọn ảnh → multipart → FastAPI
- [x] FastAPI đẩy lên Neon Object Storage + lưu DB
- [x] Hiển thị ảnh (presigned GET) + xóa ảnh

### ⬜ Phase 6 — Build
- [x] `flutter build web --release`
- [ ] `flutter build apk --release` (cần Android SDK)

### ⬜ Phase 7 — Kiểm thử & Deploy
- [ ] Smoke test luồng chính
- [ ] Deploy backend (Render/Fly/VM) + web (Netlify/Vercel/Firebase Hosting)

---

### ⬜ Phase 8 — Backend: Focus Garden (CHƯA TRIỂN KHAI)
> Đặc tả đầy đủ: [docs/09-focus-garden.md](docs/09-focus-garden.md)

- [ ] 7 bảng mới (`garden_profiles`, `focus_sessions`, `garden_plots`, `shop_items`, `user_inventory`, `garden_challenges`, `garden_challenge_progress`) + migration Alembic
- [ ] `focus_service` + router `/focus` (start / active / heartbeat / pause / resume / complete / cancel / history)
- [ ] Test: vòng đời phiên, idempotency, restore phiên sau khi app bị tắt

### ⬜ Phase 9 — Chống gian lân + Coin/EXP (CHƯA TRIỂN KHAI)
- [ ] Server đo thời gian (không tin client), heartbeat 30s, `stall_count`
- [ ] Đối chiếu `desync` (|server − client| > 30s), chặn phiên < 60s
- [ ] Giới hạn ngày (480 phút) → trả `capped`
- [ ] Cộng Coin `floor(minutes/5)`, EXP, `level`, `streak_days`

### ⬜ Phase 10 — Vườn, shop, vật phẩm (CHƯA TRIỂN KHAI)
- [ ] Gieo hạt đậu, 5 stage nảy mầm (`seed → sprout → young → mature → bloom`)
- [ ] Seed `shop_items` (nước 5 · phân bón 10 · hạt 3 coin)
- [ ] Router `/garden` (profile / plots / water / fertilize / harvest / shop / inventory / purchase)
- [ ] Thu hoạch khi `bloom` → thưởng EXP

### ⬜ Phase 11 — Bảng xếp hạng + Sự kiện (CHƯA TRIỂN KHAI)
- [ ] `GET /garden/leaderboard?period=day|week|all` (kèm hạng của chính mình)
- [ ] Sự kiện do admin tạo qua `/admin/garden/challenges` (dùng `require_admin`)
- [ ] Tiến độ tự động theo hoạt động thật + nhận thưởng (`claim`)

### ⬜ Phase 12 — Flutter: timer + hub vườn (CHƯA TRIỂN KHAI)
- [ ] `FocusTimerNotifier` (Riverpod) + `Timer.periodic` heartbeat + `WidgetsBindingObserver`
- [ ] `focus_timer_screen.dart`: Pause / Resume / Reset / Complete theo flow đã chốt
- [ ] `garden_screen.dart` (hub) + `plant_view.dart` (`CustomPainter` theo stage)
- [ ] Mất mạng → cảnh báo và tự pause

### ⬜ Phase 13 — Flutter: shop, leaderboard, sự kiện (CHƯA TRIỂN KHAI)
- [ ] `garden_shop_screen.dart` (mua nước / phân bón / hạt)
- [ ] `leaderboard_screen.dart` (ngày / tuần / tất cả)
- [ ] `garden_events_screen.dart` (sự kiện + tiến độ + nhận thưởng)
- [ ] Gắn lối vào khu vườn từ `home_screen.dart`

### ⬜ Phase 14 — Calendar: gộp bảng & migration (CHƯA TRIỂN KHAI)
> Đặc tả đầy đủ: [docs/10-calendar.md](docs/10-calendar.md)

- [ ] Thêm cột mới vào `events`: `recurrence_rule`, `recurrence_until`, `reminder_minutes`, `status`, `color`, `entry_id`, `focus_session_id`
- [ ] **Đếm `schedule_items` trước khi migrate** — báo lại số hàng, chỉ xoá bảng khi khớp
- [ ] `INSERT INTO events SELECT ... FROM schedule_items`, rồi `DROP TABLE schedule_items`

### ⬜ Phase 15 — Backend Calendar (CHƯA TRIỂN KHAI)
- [ ] `GET /calendar?view=day|week|month&date=` — bung lần lặp khi trả về
- [ ] CRUD `/calendar` + `PATCH /calendar/{id}/status`
- [ ] `GET /calendar/upcoming` (kèm `remind_at` tính sẵn) + `/calendar/stats?month=`
- [ ] Test: lặp ngày/tuần/tháng, sửa-xoá một lần lặp đơn lẻ trả `409`

### ⬜ Phase 16 — Flutter: timeline ngày + form (CHƯA TRIỂN KHAI)
- [ ] `calendar_screen.dart` (chế độ ngày) + `calendar_timeline.dart` (`CustomPainter` cột giờ 06:00–23:00)
- [ ] `calendar_event_sheet.dart` — form tạo/sửa: giờ, mô tả, vị trí, màu, lặp, nhắc
- [ ] Sửa tab **Lịch biểu** trong planner dùng chung dữ liệu Calendar

### ⬜ Phase 17 — Calendar: tuần/tháng + nhắc nhở (CHƯA TRIỂN KHAI)
- [ ] `calendar_month_grid.dart` + chế độ tuần
- [ ] Trạng thái **đã qua / đang diễn ra / sắp tới**
- [ ] Nhắc nhở **cả 2 kiểu**: banner khi app đang mở + danh sách cần chú ý khi mới mở app

### ⬜ Phase 18 — Calendar: liên kết Study + Journal (CHƯA TRIỂN KHAI)
- [ ] Mở Focus Timer từ sự kiện (`focus_session_id`, cần Phase 8)
- [ ] "Ghi nhật ký sau sự kiện" (`entry_id`)
- [ ] Thống kê so sánh **phút đã lên lịch** vs **thực tế học**

### ✅ Phase 19 — Backend: API thời tiết Open-Meteo (ĐÃ TRIỂN KHAI)
> Đặc tả đầy đủ: [docs/11-weather-forecast.md](docs/11-weather-forecast.md)

- [x] Gọi HTTP bằng gói `http` của Dart (không còn `httpx` — đó là phương án FastAPI trước đây)
- [x] Bảng `weather_snapshots` + cột `weather_lat` / `weather_lon` / `weather_location_name` trên `users`
- [x] `WeatherEndpoint`: gọi Open-Meteo, ánh xạ mã WMO → 5 nhóm `weathers`, cache 2 tầng (bộ nhớ 30 phút + DB)
- [x] Endpoint `weather.current / daily / history / setLocation` + timeout 5s, lỗi thì trả cache chứ không trả lỗi

### ✅ Phase 20 — Flutter: dự báo thời tiết (ĐÃ TRIỂN KHAI)
- [x] `ui/screens/weather_screen.dart` + `ui/weather/*` — tab `Tuần / Ngày / Theo giờ` theo các frame `Thời tiết · … · Web`
- [x] `ui/weather/location_dialog.dart` — dialog `Chọn tỉnh / thành` → `setLocation` → refresh
- [x] `ui/widgets/weather_card.dart` — `WeatherForecastView` dùng cho mục **Tiện ích → Thời tiết**
- [x] Lỗi mạng → hiện dữ liệu cache kèm nhãn `Dữ liệu cũ · cập nhật HH:mm`
- [x] Phần số liệu **theo giờ / lượng mưa / xác suất / gió / độ ẩm** còn là **minh họa**, có ghi rõ ở dòng nguồn (xem [docs/UI-design/25-roadmap-weather.md](docs/UI-design/25-roadmap-weather.md))

### ✅ Phase 21 — UI: thời tiết & cảm xúc cùng một hàng (ĐÃ TRIỂN KHAI)
- [x] `WeatherMoodRow` (`flutter_app/lib/src/ui/home/picker_card.dart`) — hai thẻ `PickerCard` ("Thời tiết hôm nay" + "Cảm xúc hôm nay") nằm **cùng một dòng**, đúng frame `HOME-01 · Weather and mood row`
- [x] `LayoutBuilder` + `kPickerRowBreakpoint = 700`: `Row` khi đủ rộng (mỗi thẻ ~342 px như thiết kế), `Column` khi hẹp (mobile không tràn, giống frame Mobile)
- [x] Giữ nguyên: `Semantics`, màu chọn, tap bỏ chọn, nhãn nút
- [x] **Dự báo thời tiết không nằm trên Home**: chỉ hiện trong mục **Tiện ích → Thời tiết** (`weather_screen.dart` dùng `WeatherForecastView`); Home chỉ còn phần chọn nhanh, không lặp lại dự báo

### ✅ Phase 22 — Backend: routing + thời tiết dọc tuyến (ĐÃ TRIỂN KHAI)
> Đặc tả đầy đủ: [docs/12-route-weather.md](docs/12-route-weather.md) · khác biệt so với đặc tả: [§18](docs/12-route-weather.md#18-bản-dựng-thực-tế-phase-2227)

- [x] `route_service`: gọi **OSRM** (`car` / `bike` / `foot`), đọc `distance` / `duration` / `geometry` (GeoJSON) / `legs`, hỗ trợ `alternatives`
- [x] Geocoding bằng **Open-Meteo Geocoding** — `searchPlaces(query)` (truy vấn được phi dấu trước khi gửi)
- [x] Sinh **điểm mẫu dọc tuyến** (bước 25 km, trần 25 mẫu, luôn giữ đủ điểm dừng) + **ETA** từ `leg.duration` và `dwell`
- [x] Gọi Open-Meteo **nhiều toạ độ trong một request**, ghép giờ ⇒ nhiệt độ / trạng thái / xác suất mưa / lượng mưa / gió (ghép theo khoảng cách gần nhất, không theo thứ tự trả về)
- [x] `route_rules.dart`: ngưỡng đoạn bất lợi (`info` / `caution` / `warning`) + gộp thành dải cảnh báo
- [x] `RouteEndpoint`: `searchPlaces` · `plan` · `forecast` · `planWithWeather` · `compareDepartures`
- [x] Test Dart thuần: haversine, sampling, ETA, quy tắc, vượt 16 ngày — **31 test xanh**
- [x] `tool/route_smoke.dart` đo nhà cung cấp thật (293 km TP.HCM → Đà Lạt, 14 điểm mẫu)

### ✅ Phase 23 — Backend: lưu hành trình (ĐÃ TRIỂN KHAI)
- [x] Bảng `journeys` / `journey_stops` / `journey_weather_points` + migration `20261013174623807` và `20261013175627648` (chỉ thêm)
- [x] `JourneysEndpoint`: `list` · `detail` · `save` · `delete`, cách ly theo `user_id` (`ensureOwned`)
- [x] `save` ghi **bản tóm tắt dự báo** vào `journey_weather_points` + `weather_saved_at`
- [x] Liên kết nhật ký: `journeys.entryId` là liên kết mềm (`UuidValue?`, như `reflections.entryId`); `save(createEntry: true)` upsert entry của ngày khởi hành

### ✅ Phase 24 — Flutter: dữ liệu lộ trình (ĐÃ TRIỂN KHAI)
- [x] `data/repositories/route_repository.dart` + model Dart trong `data/models.dart`
- [x] Provider: `routeRepositoryProvider` · `routePlanProvider` · `routeDeparturesProvider` · `placeSearchProvider` · `journeysProvider` · `journeyDetailProvider`
- [x] Nhánh path mới trong `data/datasources/serverpod_data_source.dart` (`/route/*`, `/journeys/*`) + `ApiException.code`

### ✅ Phase 25 — Flutter UI: lộ trình, bản đồ, timeline (ĐÃ TRIỂN KHAI)
- [x] `ui/screens/route_weather_screen.dart` + `ui/route/*` (chrome, form, bản đồ, biểu đồ, timeline, khuyến cáo, so sánh giờ)
- [x] **Form Quản lý lộ trình**: điểm đi / nhiều điểm dừng / điểm đến, tìm kiếm, chọn trên bản đồ, phương tiện, ngày–giờ, dwell, đảo chiều, chọn tuyến thay thế
- [x] Bản đồ tile thật (`flutter_map` + tile OSM): polyline + marker địa điểm + marker nhiệt độ; chọn marker ↔ highlight timeline, chọn timeline ↔ bản đồ cuộn tới marker
- [x] Đăng ký màn vào `ui/utilities.dart` (nhãn đầy đủ `Thời tiết hành trình`, nhãn header `Hành trình`)

### ✅ Phase 26 — Flutter: lưu nhật ký + xem lại hành trình (ĐÃ TRIỂN KHAI)
- [x] `ui/route/save_journey_dialog.dart` — tên chuyến, ghi / không ghi vào nhật ký ngày khởi hành, tóm tắt đính kèm sửa được, ghi chú (ảnh qua nhật ký đã liên kết)
- [x] `ui/route/saved_journeys_dialog.dart`: danh sách hành trình, chi tiết, **bản tóm tắt đã lưu** tách khỏi nút **Cập nhật dự báo mới nhất**, xoá hành trình
- [x] Trạng thái mục E: loading, không có tuyến, lỗi / vượt giới hạn, dữ liệu một phần, vượt 16 ngày, lưu thành công / thất bại, dữ liệu cũ — chưa đăng nhập do guard `/login` sẵn có

### ✅ Phase 27 — Đóng gói thời tiết hành trình (ĐÃ TRIỂN KHAI, còn bước vẽ Figma)
- [x] `flutter analyze` sạch + `dart analyze` (workspace server) sạch; `flutter test` 99/99, `dart test` 31/31
- [x] Attribution `© OpenStreetMap contributors · OSRM · Open-Meteo` (góc bản đồ + dòng nguồn) và dòng miễn trừ
- [x] Cập nhật docs: `12` (§18), `03-database-schema`, `05-features`, `UI/02-screen-inventory`, `UI-design/28`
- [ ] Vẽ frame Figma `ROUTE-01` để đối chiếu (màn đã dựng theo ngôn ngữ thị giác, chưa có bản vẽ)
- [ ] Verify trên thiết bị thật (`flutter run` web/mobile) — chưa chạy trong phiên này


---

## 4. Cột mốc (Milestones)

| Mốc | Kết quả |
|---|---|
| M0 | Bộ tài liệu/thiết kế hoàn chỉnh |
| M1 | Backend chạy, Swagger đầy đủ endpoint, auth hoạt động |
| M2 | DB seed xong, 100 câu sẵn sàng |
| M3 | Flutter chạy được web, viết & lưu nhật ký |
| M4 | Upload ảnh end-to-end |
| M5 | Build web + apk, deploy |
| M6 | *(đang chờ)* Backend Focus Garden: timer + chống gian lân + coin/EXP |
| M7 | *(đang chờ)* Vườn + shop + bảng xếp hạng + sự kiện, Flutter hoàn chỉnh |
| M8 | *(đang chờ)* Calendar: gộp bảng, CRUD, timeline, lặp + nhắc nhở |
| M9 | *(đang chờ)* Liên kết Calendar ↔ Study ↔ Journal + thống kê thời gian |
| M10 | Dự báo thời tiết Open-Meteo + màn **Tiện ích → Thời tiết** *(đã xong)* |
| M11 | Thời tiết theo hành trình: routing + dự báo dọc tuyến + lưu hành trình vào nhật ký *(đã xong)* |

---

## 5. Rủi ro & giảm thiểu

| Rủi ro | Mức | Giảm thiểu |
|---|---|---|
| Flutter SDK chưa cài | ~~Cao~~ | ~~Cài qua winget/zip trước Phase 3~~ → Đã xong, Flutter 3.47.6 tại `D:\dev\flutter` |
| Python 3.14 quá mới (thiếu wheel psycopg/pydantic-core) | ~~Trung~~ | ~~Tạo conda env 3.12~~ → Đã xong, `psycopg-binary` + `pydantic-core` đều có wheel cho 3.14.6; backend chạy ổn |
| Neon Object Storage chỉ path-style/SigV4, không hỗ trợ PutBucketAcl | Đã xong | Endpoint dạng `br-<branch-id>.storage.c-<N>.<region>...`; bucket đặt `private` qua Console |
| CORS giữa Flutter web và FastAPI | Trung | Đã bật `CORSMiddleware`; khi dev web phải chạy `flutter run -d chrome --web-port 8080` để khớp `CORS_ORIGINS` |
| Android SDK chưa cài | **Cao** | Chặn `flutter build apk` và test trên điện thoại thật. Cài tại https://developer.android.com/studio |
| Android chặn HTTP cleartext (API 9+) | **Cao** | Đã thêm `android:usesCleartextTraffic` vào `AndroidManifest.xml` để test với backend LAN |
| Xác thực JWT bị lộ secret | Cao | Lưu `JWT_SECRET` trong `.env`, không commit |
| *(Phase 8–13)* Timer gian lật: bỏ app nhưng giữ phiên chạy | Cao *(đã chốt thiết kế)* | **Server đo thời gian**, heartbeat 30s, quãng > 90s bị loại khỏi `credited_minutes`, `stall_count >= 3` → từ chối |
| *(Phase 8–13)* Giới hạn ngày bị lách bằng nhiều thiết bị/nhiều tài khoản | Trung | Chặm trần 480 phút/ngày tính trên DB, không tin client |
| *(Phase 8–13)* Mất mạng giữa lúc tập trung → mất thưởng | Trung | UI cảnh báo và **tự pause** thay vì đếm tiếp |
| *(Phase 8–13)* Đồng hồ hệ thống lệch ảnh hưởng `streak_days` | Thấp | Server dùng `now()` của DB làm chuẩn; `streak` tính theo ngày server |
| *(Phase 14)* Xoá `schedule_items` làm mất lịch người dùng | **Cao** | Đếm hàng trước → migrate → **đối chiếu số hàng khớp** → mới `DROP`. Có bước rollback trong `downgrade()` |
| *(Phase 14–18)* Lịch lặp nhân bản hàng làm DB phình | Trung *(đã chốt thiết kế)* | Lưu **1 hàng + quy tắc**, bung lần lặp khi đọc |
| *(Phase 17)* Web không có push → không nhắc được khi app đóng | Trung *(đã chốt)* | Chấp nhận: nhắc 2 lớp (khi app mở + banner). Muốn nhắc khi đóng thì cần web push, ngoài phạm vi |
| *(Phase 19–20)* Open-Meteo chậm / mất mạng làm treo app | Trung *(đã chốt thiết kế)* | Timeout cứng 5s + cache 2 tầng + luôn có đường về bằng `weather_snapshots`; lỗi thì trả cache chứ không trả lỗi |
| *(Phase 19–20)* Gọi Open-Meteo quá nhiều lần bị giới hạn | Thấp | Cache bộ nhớ 30 phút theo tọa độ; `WEATHER_API_ENABLED=false` để tắt hẳn |
| *(Phase 22–27)* Instance OSRM công khai là server demo, có giới hạn và không cam kết SLA | **Cao** *(đã chốt thiết kế)* | Timeout cứng 5s + cache 30 phút + trần 25 điểm mẫu; đổi `ROUTE_API_URL_*` sang instance tự host **không cần sửa code**; OSRM lỗi thì tuyến cũ vẫn hiển thị |
| *(Phase 22–27)* Tile OSM bị chặn nếu lạm dụng | Trung | Chỉ dùng cho một khung bản đồ nhỏ trong app, có User-Agent, khối lượng thấp; đổi tile provider khi cần |
| *(Phase 22–27)* Open-Meteo chỉ dự báo tối đa **16 ngày** | Thấp *(đã chốt)* | Trả trạng thái `beyondRange` rõ ràng + nhãn "ngoài phạm vi dự báo"; **không** đoán cho phần vượt |
| *(Phase 22–27)* Nhiều toạ độ trong một request Open-Meteo có thể trả thiếu | Trung *(đã chốt)* | Báo cáo `coverage = partial`, mẫu thiếu hiển thị `—` (vẫn giữ vị trí + ETA) — xem docs/12 §5.4 |
| *(Phase 22–27)* Hiểu sai "dự báo" thành "chắc chắn xảy ra" | Trung | Mọi câu chữ chỉ dùng "dự kiến / có thể / xác suất"; panel khuyến cáo ghi rõ là quy tắc hiển thị của Memoir, không phải khuyến nghị giao thông chính thức |

---

## 6. Quy ước code (dự kiến)

- Backend: PEP8, type hints, router tách theo domain, response schema rõ ràng.
- Flutter: feature-first, Riverpod cho state, repository pattern cho API.
- Ngôn ngữ: code/comment tiếng Anh, tài liệu/UI tiếng Việt.
