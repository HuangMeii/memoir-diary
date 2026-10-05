# 📔 Memoir — Nhật ký số (Digital Diary)

> Ứng dụng nhật ký cá nhân **đa người dùng** (multi-user), gồm **Flutter App + Flutter Web**, backend **FastAPI**, lưu ảnh trên **Neon Object Storage** và dữ liệu trên **PostgreSQL (Neon serverless)**.

---

## 1. Giới thiệu

Memoir giúp bạn ghi lại mỗi ngày một cách có hệ thống: cảm xúc, thời tiết, suy nghĩ, lòng biết ơn, giấc mơ, ghi chú, todo, lịch biểu và sức khỏe. Điểm đặc biệt là hai **lưới tháng đổ màu** theo cảm xúc và thời tiết, cùng cơ chế **câu động viên ngẫu nhiên** kết hợp **lời nhắn nhủ của chính bạn** để bạn phản tư mỗi ngày.

### Tính năng chính
- ✍️ **Viết nhật ký** kèm upload ảnh.
- 🌦️ **Chọn thời tiết** qua icon (5 trạng thái): `nắng`, `râm`, `mưa`, `bão`, `khác`.
- 😀 **Chọn cảm xúc** qua icon (5 trạng thái): `vui`, `buồn`, `chán`, `bình thường`, `giận`.
- 🗓️ **2 lưới tháng** (mood + weather) đổ màu từng ô theo ngày.
- 🧭 **Câu quan điểm từ góc nhìn khác**.
- 🔮 **Câu nhắn nhủ tương lai** (hoặc câu hỏi).
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
- 🌦️ **Dự báo thời tiết thật** *(đặc tả xong, chưa code — xem [docs/11-weather-forecast.md](docs/11-weather-forecast.md))*: gọi **Open-Meteo** (miễn phí, **không cần API key**) để hiện nhiệt độ và dự báo, gợi ý chọn thời tiết khi viết nhật ký.

---

## 2. Kiến trúc tổng quan

```
Flutter App (Android/iOS) ─┐
                           ├──(HTTPS: JSON + multipart upload)──▶ FastAPI
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
| Backend | Python 3.14 (Miniconda), FastAPI, Uvicorn, SQLAlchemy 2.0, Alembic, Pydantic v2, boto3, psycopg 3 |
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
│  ├─ 08-quotes-seed.md
│  ├─ 09-focus-garden.md
│  ├─ 10-calendar.md
│  └─ 11-weather-forecast.md
├─ backend/        # FastAPI (Phase 1)
└─ flutter_app/    # Flutter app + web (Phase 3+)
```

> Trạng thái hiện tại: **Phase 0–5 đã hoàn thành** (backend FastAPI đầy đủ 13 bảng + 13 router, seed 100 câu, Flutter app + web có đủ tính năng và upload ảnh lên Neon Object Storage). Còn lại: build APK và deploy (Phase 6–7). **Khu vườn học tập (Phase 8–13), Calendar (Phase 14–18), dự báo thời tiết (Phase 19–20) và UI thời tiết/cảm xúc một hàng (Phase 21) đã có đặc tả nhưng chưa viết code.** Chi tiết từng hạng mục xem [`PLAN.md`](PLAN.md).

---

## 5. Tài liệu

| Tài liệu | Nội dung |
|---|---|
| [docs/01-architecture.md](docs/01-architecture.md) | Kiến trúc, thành phần, triển khai |
| [docs/02-data-flow.md](docs/02-data-flow.md) | Luồng hoạt động (auth, lưu nhật ký, upload ảnh, câu ngẫu nhiên, lưới tháng) |
| [docs/03-database-schema.md](docs/03-database-schema.md) | Chi tiết bảng, cột, khóa, ERD |
| [docs/04-api-reference.md](docs/04-api-reference.md) | Danh sách API + request/response |
| [docs/05-features.md](docs/05-features.md) | Đặc tả tính năng → màn hình |
| [docs/06-setup-deploy.md](docs/06-setup-deploy.md) | Cài đặt, cấu hình, migrate, seed, build |
| [docs/07-ui-design.md](docs/07-ui-design.md) | Wireframe, bảng màu mood/weather |
| [docs/08-quotes-seed.md](docs/08-quotes-seed.md) | 100 câu động viên để seed |
| [docs/09-focus-garden.md](docs/09-focus-garden.md) | **Khu vườn học tập** *(chưa triển khai)*: timer, chống gian lân, coin/EXP, cây nảy mầm, shop, xếp hạng, sự kiện |
| [docs/10-calendar.md](docs/10-calendar.md) | **Module Calendar** *(chưa triển khai)*: ngày/tuần/tháng, timeline, sự kiện lặp, nhắc nhở, liên kết Study + Journal |
| [docs/11-weather-forecast.md](docs/11-weather-forecast.md) | **Dự báo thời tiết** *(chưa triển khai)*: tích hợp Open-Meteo, cache 2 tầng, ánh xạ mã WMO |

---

## 6. Quick start (sau khi code xong)

```bash
# Backend
cd backend
python -m venv .venv && .venv\Scripts\activate
pip install -r requirements.txt
copy .env.example .env      # điền DATABASE_URL, S3_*, JWT_SECRET
alembic upgrade head
python -m app.seed.seed
python -m app.seed.admin    # tạo tài khoản admin quản lý kho câu
uvicorn app.main:app --reload
# Flutter web
cd flutter_app
flutter pub get
flutter run -d chrome

# Flutter app
flutter build apk --release
```

**Tạo tài khoản admin** (quản lý kho câu dùng chung):

- Để trống `ADMIN_*` trong `.env` → script hỏi mật khẩu ở terminal (không hiện ký tự):

  ```powershell
  python -m app.seed.admin
  ```

- Hoặc chỉ đặt quyền admin cho tài khoản đã có (không cần mật khẩu):

  ```powershell
  python -m app.seed.admin --email ban@example.com --promote-only
  ```

Admin đăng nhập bình thường rồi dùng nhóm endpoint `/api/v1/admin/*` (Swagger: http://127.0.0.1:8000/docs). Tài khoản thường gọi nhóm này sẽ nhận `403`.

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
- [ ] Phase 19 — Backend: API thời tiết Open-Meteo *(đặc tả xong, chưa code)*
- [ ] Phase 20 — Flutter: thẻ thời tiết + đổi vị trí
- [ ] Phase 21 — UI: thời tiết & cảm xúc cùng một hàng

> Các phase 8–21 là **đặc tả đã chốt, chưa triển khai**. Xem [docs/09-focus-garden.md](docs/09-focus-garden.md), [docs/10-calendar.md](docs/10-calendar.md) và [docs/11-weather-forecast.md](docs/11-weather-forecast.md).

---

## 8. Giấy phép

Dự án cá nhân — MIT License (dự kiến).
