# 🗺️ PLAN — Kế hoạch triển khai Memoir

Tài liệu này mô tả lộ trình xây dựng ứng dụng nhật ký **Memoir** (Flutter App + Web, FastAPI, Neon Object Storage, PostgreSQL).

---

## 1. Mục tiêu

Xây dựng ứng dụng nhật ký đa người dùng, cho phép:
- Ghi nhật ký hằng ngày kèm ảnh, thời tiết và cảm xúc.
- Trực quan hóa cảm xúc/thời tiết theo tháng bằng lưới đổ màu.
- Lưu giữ các mục phản tư cá nhân (góc nhìn khác, nhắn nhủ tương lai, biết ơn, giấc mơ...).
- Nuôi dưỡng động lực bằng kho câu động viên (CRUD) + câu ngẫu nhiên + phản tư.
- Quản lý ghi chú, todo, sự kiện, lịch biểu và theo dõi sức khỏe.

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

### ⬜ Phase 1 — Backend FastAPI + DB + Auth
- [ ] Khởi tạo package `backend/app/` (main.py, core, models, schemas, routers, services)
- [ ] Cấu hình `.env` (DATABASE_URL, S3_*, JWT_SECRET)
- [ ] SQLAlchemy models (13 bảng theo `docs/03-database-schema.md`)
- [ ] Alembic init + migration đầu tiên
- [ ] Auth: `/auth/register`, `/auth/login`, `/auth/me` (JWT + bcrypt)
- [ ] Router CRUD: entries, images, moods, weathers, quotes, self_messages, reflections, notes, todos, events, schedule_items, health_logs
- [ ] Storage service (boto3, path-style, presigned URL)
- [ ] `/stats/mood-grid`, `/stats/weather-grid`
- [ ] Swagger UI hoạt động tại `/docs`

### ⬜ Phase 2 — Seed dữ liệu
- [ ] Seed `moods` (5), `weathers` (5)
- [ ] Seed `quotes` (100 câu từ `docs/08-quotes-seed.md`)
- [ ] Script `python -m app.seed.seed` (idempotent)

### ⬜ Phase 3 — Flutter scaffold
- [ ] `flutter create` (bật web + android + ios)
- [ ] Theme Material 3, màu mood/weather, routing (go_router)
- [ ] `ApiClient` (dio) + interceptor JWT + secure storage
- [ ] Models Dart + repositories

### ⬜ Phase 4 — Flutter features
- [ ] Auth (login/register/logout) + guard
- [ ] Viết nhật ký (form đầy đủ các mục)
- [ ] Weather/Mood picker (icon)
- [ ] 2 lưới tháng đổ màu
- [ ] Kho câu (CRUD) + random pair + phản tư
- [ ] Notes, Todo, Events, Schedule
- [ ] Health (bước chân, thời gian tập)

### ⬜ Phase 5 — Upload ảnh end-to-end
- [ ] Flutter chọn ảnh → multipart → FastAPI
- [ ] FastAPI đẩy lên Neon Object Storage + lưu DB
- [ ] Hiển thị ảnh (presigned GET) + xóa ảnh

### ⬜ Phase 6 — Build
- [ ] `flutter build web --release`
- [ ] `flutter build apk --release` (+ iOS nếu có macOS)

### ⬜ Phase 7 — Kiểm thử & Deploy
- [ ] Smoke test luồng chính
- [ ] Deploy backend (Render/Fly/VM) + web (Netlify/Vercel/Firebase Hosting)

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

---

## 5. Rủi ro & giảm thiểu

| Rủi ro | Mức | Giảm thiểu |
|---|---|---|
| Flutter SDK chưa cài | Cao | Cài qua winget/zip trước Phase 3 |
| Python 3.14 quá mới (thiếu wheel psycopg/pydantic-core) | Trung | Tạo conda env Python 3.12 cho backend |
| Neon Object Storage chỉ path-style/SigV4, không hỗ trợ PutBucketAcl | Trung | Cấu hình `endpoint_url` + đặt access level qua Console/API Neon |
| CORS giữa Flutter web và FastAPI | Trung | Bật CORSMiddleware |
| Xác thực JWT bị lộ secret | Cao | Lưu `JWT_SECRET` trong `.env`, không commit |

---

## 6. Quy ước code (dự kiến)

- Backend: PEP8, type hints, router tách theo domain, response schema rõ ràng.
- Flutter: feature-first, Riverpod cho state, repository pattern cho API.
- Ngôn ngữ: code/comment tiếng Anh, tài liệu/UI tiếng Việt.
