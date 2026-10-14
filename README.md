# 📔 Memoir — Nhật ký số (Digital Diary)

> Ứng dụng nhật ký cá nhân **đa người dùng** (multi-user), gồm **Flutter App + Flutter Web**, backend **Serverpod/Dart**, lưu ảnh trên **Neon Object Storage** và dữ liệu trên **PostgreSQL (Neon serverless)**.

---

## 1. Giới thiệu

Memoir giúp bạn ghi lại mỗi ngày một cách có hệ thống: cảm xúc, thời tiết, suy nghĩ, lòng biết ơn, giấc mơ, ghi chú, todo, lịch biểu và sức khỏe. Điểm đặc biệt là hai **lưới tháng đổ màu** theo cảm xúc và thời tiết, cùng cơ chế **câu động viên ngẫu nhiên** kết hợp **lời nhắn nhủ của chính bạn** để bạn phản tư mỗi ngày.

### Tính năng chính
- ✍️ **Viết nhật ký** kèm upload ảnh.
- 🌦️ **Chọn thời tiết** qua icon (5 trạng thái): `nắng`, `râm`, `mưa`, `bão`, `khác`.
- 😀 **Chọn cảm xúc** qua icon (5 trạng thái): `vui`, `buồn`, `chán`, `bình thường`, `giận`.
- 🗓️ **2 lưới tháng** (mood + weather) đổ màu từng ô theo ngày.
- 🧭 **Câu quan điểm từ góc nhìn khác**.
- 💬 **Kho 100 câu động viên/giáo dục** (CRUD được) + **câu ngẫu nhiên của bản thân** + ô **phản tư**.
- 🌱 **Tự chăm sóc bản thân hôm nay**.
- 🌅 **Hi vọng cho ngày mai**.
- 🙏 **Lòng biết ơn**.
- 💭 **Giấc mơ đã trải qua**.
- 📝 **Ghi chú nhanh**.
- ✅ **Todo list**: mục tiêu tuần, sự kiện đặc biệt, lịch biểu.
- ❤️ **Theo dõi sức khỏe**: số bước chân, thời gian tập luyện.
- 👤 **Multi-user**: đăng ký / đăng nhập / cách ly dữ liệu theo tài khoản.
- 🔐 **Quản trị (admin)**: thêm/sửa/xoá câu trong **kho câu dùng chung**, xem danh sách tài khoản, khoá/mở tài khoản, nâng/hạ quyền. Tài khoản thường không sửa được câu dùng chung.
- 🌳 **Khu vườn học tập** *(đang phát triển — xem [docs/09-focus-garden.md](docs/09-focus-garden.md))*: timer tập trung có chống gian lân → đổi thời gian học thành **coin/EXP** → gieo **hạt đậu nảy mầm** → mua **nước, phân bón** → **bảng xếp hạng** và **sự kiện** do admin tổ chức.
- 📆 **Calendar** *(đặc tả xong, chưa code — xem [docs/10-calendar.md](docs/10-calendar.md))*: xem lịch **ngày / tuần / tháng**, **timeline theo giờ**, tạo/sửa/xoá sự kiện, **lặp lại**, **nhắc nhở**, liên kết với Study Garden và nhật ký, thống kê thời gian đã lên lịch vs thực tế học.
- 🌦️ **Dự báo thời tiết thật** *(đã dựng — xem [docs/11-weather-forecast.md](docs/11-weather-forecast.md))*: gọi **Open-Meteo** (miễn phí, **không cần API key**) để hiện nhiệt độ và dự báo nhiều ngày, gợi ý chọn thời tiết khi viết nhật ký. Nằm trong **Tiện ích → Thời tiết**.
- 🧭 **Thời tiết theo hành trình** *(đã dựng — xem [docs/12-route-weather.md](docs/12-route-weather.md))*: chọn điểm đi / nhiều điểm dừng / điểm đến (tìm kiếm hoặc chọn trực tiếp trên bản đồ OSM), chọn phương tiện và giờ khởi hành, rồi xem **thời tiết dự kiến tại từng chặng** (nhiệt độ, xác suất mưa, lượng mưa, gió), cảnh báo đoạn bất lợi, so sánh giờ khởi hành, và **lưu hành trình vào nhật ký**. Không tự xây mô hình dự đoán thời tiết.

---

## 2. Kiến trúc tổng quan

```
Flutter App (Android/iOS) ─┐
                           ├──(HTTPS: Serverpod RPC + binary upload)──▶ Serverpod/Dart
Flutter Web (build web)   ─┘                                      │
                                                       ┌──────────┴───────────┐
                                                       ▼                      ▼
                                    Neon Object Storage (S3-compatible)   PostgreSQL (Neon)
                                       bucket: diary-images/               users, moods, weathers,
                                         └─ entries/{entry_id}/xxx.jpg     diary_entries, entry_images,
                                                                           quotes, self_messages,
                                                                           reflections, notes, todos,
                                                                           events, schedule_items,
                                                                           health_logs
                                                                            · Phase 8-13 (chua co):
                                                                            ·   focus_sessions, garden_profiles,
                                                                            ·   garden_plots, shop_items, user_inventory,
                                                                            ·   garden_challenges, garden_challenge_progress
                                                                            · Phase 14-20 (chua co):
                                                                            ·   weather_snapshots,
                                                                            ·   events (sau khi gop schedule_items)
```

- **1 codebase Flutter** build ra cả **app** (`flutter build apk/appbundle`, iOS) và **web** (`flutter build web`).
- Ảnh → **Neon Object Storage** (S3 API, path-style, SigV4). Metadata ảnh + nội dung nhật ký → **PostgreSQL**.

---

## 3. Tech stack

| Tầng | Công nghệ |
|---|---|
| Frontend | Flutter 3.47 (Material 3), Riverpod, go_router, dio, image_picker, flutter_secure_storage, fl_chart |
| Backend | Dart 3.13, Serverpod 4.0 (RPC sinh sẵn), PostgreSQL, storage gateway cho ảnh |
| Auth | JWT (HS256) + bcrypt, OAuth2 password flow, phân quyền `role` (`user` / `admin`) |
| Database | PostgreSQL (Neon serverless) |
| Object Storage | Neon Object Storage (S3-compatible) |
| Tooling | Git, winget, Docker (tùy chọn) |

---

## 4. Cấu trúc thư mục

```
Memoir/
├─ README.md
├─ PLAN.md
├─ docs/
│  ├─ 01-architecture.md
│  ├─ 02-data-flow.md
│  ├─ 03-database-schema.md
│  ├─ 04-api-reference.md
│  ├─ 05-features.md
│  ├─ 06-setup-deploy.md
│  ├─ 07-ui-design.md
│  ├─ UI/
│  │  ├─ README.md
│  │  ├─ 01-information-architecture.md
│  │  ├─ 02-screen-inventory.md
│  │  ├─ 03-user-flows.md
│  │  ├─ 04-wireframes.md
│  │  ├─ 05-design-system.md
│  │  └─ 06-figma-handoff.md
│  ├─ UI-design/
│  │  ├─ README.md
│  │  ├─ 01-auth-login.md
│  │  ├─ ...
│  │  └─ 26-shared-components.md
│  ├─ convert/
│  │  ├─ README.md
│  │  ├─ 00-decision-and-risks.md
│  │  ├─ 01-current-backend-inventory.md
│  │  ├─ 02-target-architecture.md
│  │  ├─ 03-api-to-flutter-mapping.md
│  │  ├─ 04-data-and-storage-migration.md
│  │  ├─ 05-execution-phases.md
│  │  └─ 06-testing-and-cutover.md
│  ├─ 08-quotes-seed.md
│  ├─ 09-focus-garden.md
│  ├─ 10-calendar.md
│  ├─ 11-weather-forecast.md
│  └─ 12-route-weather.md
├─ memoir_server/  # Backend Serverpod/Dart (client + server)
└─ flutter_app/    # Flutter app + web (Phase 3+)
```

> Trạng thái hiện tại: **Phase 0–5 đã hoàn thành** (backend Serverpod/Dart đã thay thế FastAPI: 16 domain + seed 100 câu, Flutter app + web đầy đủ tính năng và upload ảnh lên Neon Object Storage). Còn lại: build APK và deploy (Phase 6–7). **Khu vườn học tập (Phase 8–13) và Calendar (Phase 14–18) đã có đặc tả nhưng chưa viết code. Dự báo thời tiết (Phase 19–20) đã dựng xong**: backend `WeatherEndpoint` (Open-Meteo + bảng `weather_snapshots` + cache 2 tầng) và màn **Tiện ích → Thời tiết** (`ui/screens/weather_screen.dart`). **Phase 21 — UI thời tiết & cảm xúc cùng một hàng — đã dựng cùng màn hình Home theo Figma; dự báo thời tiết không lặp lại trên Home. Thời tiết theo hành trình (Phase 22–27) đã dựng xong**: backend `RouteEndpoint` + `JourneysEndpoint` (OSRM + Open-Meteo) với 3 bảng hành trình, và màn **Tiện ích → Thời tiết hành trình** (bản đồ OSM, biểu đồ mưa/nhiệt độ, timeline từng chặng, lưu vào nhật ký).** Chi tiết từng hạng mục xem [`PLAN.md`](PLAN.md).

---

## 5. Tài liệu

| Tài liệu | Nội dung |
|---|---|
| [Jira — Board MD (Backlog)](https://huynhmai2755.atlassian.net/jira/software/projects/MD/boards/4/backlog?atlOrigin=eyJpIjoiMjQzNWI4NzFlNjQ5NDBkZmI0YWU4YTg4OGUzZGRhMmMiLCJwIjoiaiJ9) | Bảng backlog / trạng thái công việc của dự án trên Jira |
| [docs/01-architecture.md](docs/01-architecture.md) | Kiến trúc, thành phần, triển khai |
| [docs/02-data-flow.md](docs/02-data-flow.md) | Luồng hoạt động (auth, lưu nhật ký, upload ảnh, câu ngẫu nhiên, lưới tháng) |
| [docs/03-database-schema.md](docs/03-database-schema.md) | Chi tiết bảng, cột, khóa, ERD |
| [docs/04-api-reference.md](docs/04-api-reference.md) | Danh sách API + request/response |
| [docs/05-features.md](docs/05-features.md) | Đặc tả tính năng → màn hình |
| [docs/06-setup-deploy.md](docs/06-setup-deploy.md) | Cài đặt, cấu hình, migrate, seed, build |
| [docs/07-ui-design.md](docs/07-ui-design.md) | Wireframe, bảng màu mood/weather |
| [docs/UI/README.md](docs/UI/README.md) | Bộ đặc tả giao diện Figma: IA, màn hình, flow, wireframe, design system, handoff |
| [docs/UI-design/README.md](docs/UI-design/README.md) | Brief riêng cho từng trang/màn hình để dựng Figma |
| [docs/convert/README.md](docs/convert/README.md) | Kế hoạch chuyển backend sang Serverpod/Dart — **đã cutover**, FastAPI đã gỡ |
| [docs/08-quotes-seed.md](docs/08-quotes-seed.md) | 100 câu động viên để seed |
| [docs/09-focus-garden.md](docs/09-focus-garden.md) | **Khu vườn học tập** *(chưa triển khai)*: timer, chống gian lân, coin/EXP, cây nảy mầm, shop, xếp hạng, sự kiện |
| [docs/10-calendar.md](docs/10-calendar.md) | **Module Calendar** *(chưa triển khai)*: ngày/tuần/tháng, timeline, sự kiện lặp, nhắc nhở, liên kết Study + Journal |
| [docs/11-weather-forecast.md](docs/11-weather-forecast.md) | **Dự báo thời tiết** *(đã triển khai)*: tích hợp Open-Meteo, cache 2 tầng, ánh xạ mã WMO |
| [docs/12-route-weather.md](docs/12-route-weather.md) | **Thời tiết theo hành trình** *(đã triển khai)*: quản lý lộ trình (nhiều điểm dừng, chọn trên bản đồ), routing OSRM, dự báo dọc tuyến theo điểm mẫu + ETA, quy tắc đoạn bất lợi, lưu hành trình vào nhật ký |

---

## 6. Quick start (sau khi code xong)

```bash
# Backend (Serverpod/Dart)
cd memoir_server
dart pub get
serverpod start          # tự quản PostgreSQL nhúng, apply migration khi boot
# API: http://localhost:8080 · Insights: http://localhost:8081

# Flutter web
cd flutter_app
flutter pub get
flutter run -d chrome    # mặc định trỏ tới http://127.0.0.1:8080

# Flutter app
flutter build apk --release
```

**Tài khoản admin** (quản lý kho câu dùng chung):

Quyền admin giờ do server Dart quyết định (`memoir_server_server/lib/src/admin/`);
nhóm endpoint admin chỉ chấp nhận role phù hợp, tài khoản thường sẽ bị từ chối.
Các script `seed`/`admin` bằng Python đã bị gỡ cùng backend FastAPI.

Chi tiết đầy đủ ở [docs/06-setup-deploy.md](docs/06-setup-deploy.md).

---

## 7. Roadmap

- [x] Phase 0 — Tài liệu & thiết kế
- [x] Phase 1 — Backend FastAPI + DB + Auth
- [x] Phase 2 — Seed dữ liệu (moods, weathers, 100 quotes)
- [x] Phase 3 — Flutter scaffold
- [x] Phase 4 — Flutter features
- [x] Phase 5 — Upload ảnh end-to-end
- [ ] Phase 6 — Build apk *(web đã xong; apk cần cài Android SDK)*
- [ ] Phase 7 — Kiểm thử & deploy
- [ ] Phase 8 — Backend Focus Garden: timer + session *(đặc tả đã xong, chưa code)*
- [ ] Phase 9 — Chống gian lân + coin/EXP
- [ ] Phase 10 — Vườn, shop, vật phẩm
- [ ] Phase 11 — Bảng xếp hạng + sự kiện
- [ ] Phase 12 — Flutter: timer + hub vườn
- [ ] Phase 13 — Flutter: shop, leaderboard, sự kiện
- [ ] Phase 14 — Calendar: gộp bảng `schedule_items` → `events` *(đặc tả xong, chưa code)*
- [ ] Phase 15 — Backend Calendar: CRUD + lặp + thống kê
- [ ] Phase 16 — Flutter: timeline ngày + form tạo/sửa
- [ ] Phase 17 — Calendar: tuần/tháng + nhắc nhở
- [ ] Phase 18 — Calendar: liên kết Study + Journal
- [x] Phase 19 — Backend: API thời tiết Open-Meteo *(đã dựng: `WeatherEndpoint` + bảng `weather_snapshots` + cache 2 tầng)*
- [x] Phase 20 — Flutter: thẻ thời tiết + đổi vị trí *(đã dựng: `ui/screens/weather_screen.dart` + `ui/weather/*`)*
- [x] Phase 21 — UI: thời tiết & cảm xúc cùng một hàng *(đã dựng ở `home/picker_card.dart`; dự báo thời tiết chỉ nằm trong Tiện ích)*
- [x] Phase 22 — Backend: routing + thời tiết dọc tuyến *(đã dựng: `RouteEndpoint` + `route_service` + 31 unit test)*
- [x] Phase 23 — Backend: lưu hành trình + bản tóm tắt dự báo *(đã dựng: `JourneysEndpoint` + 3 bảng mới)*
- [x] Phase 24 — Flutter: repository + provider cho lộ trình
- [x] Phase 25 — Flutter UI: form quản lý lộ trình + bản đồ OSM + timeline
- [x] Phase 26 — Flutter: lưu vào nhật ký + xem lại hành trình đã lưu
- [x] Phase 27 — Đóng gói & docs thời tiết hành trình *(còn: vẽ frame Figma `ROUTE-01`)*

> Các phase 8–18 là **đặc tả đã chốt, chưa triển khai**. Xem [docs/09-focus-garden.md](docs/09-focus-garden.md), [docs/10-calendar.md](docs/10-calendar.md), [docs/11-weather-forecast.md](docs/11-weather-forecast.md) và [docs/12-route-weather.md](docs/12-route-weather.md).

---

## 8. Giấy phép

Dự án cá nhân — MIT License (dự kiến).
