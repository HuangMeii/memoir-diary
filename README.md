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
```

- **1 codebase Flutter** build ra cả **app** (`flutter build apk/appbundle`, iOS) và **web** (`flutter build web`).
- Ảnh → **Neon Object Storage** (S3 API, path-style, SigV4). Metadata ảnh + nội dung nhật ký → **PostgreSQL**.

---

## 3. Tech stack

| Tầng | Công nghệ |
|---|---|
| Frontend | Flutter (Material 3), Riverpod, go_router, dio, image_picker/file_picker, flutter_secure_storage, table_calendar, fl_chart |
| Backend | Python 3.12, FastAPI, Uvicorn, SQLAlchemy 2.0, Alembic, Pydantic v2, boto3, psycopg |
| Auth | JWT (HS256) + bcrypt (passlib), OAuth2 password flow |
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
│  └─ 08-quotes-seed.md
├─ backend/        # FastAPI (Phase 1)
└─ flutter_app/    # Flutter app + web (Phase 3+)
```

> Trạng thái hiện tại: **tài liệu/thiết kế** đã hoàn thành. Code backend và Flutter nằm ở các Phase tiếp theo (xem `PLAN.md`).

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
uvicorn app.main:app --reload

# Flutter web
cd flutter_app
flutter pub get
flutter run -d chrome

# Flutter app
flutter build apk --release
```

Chi tiết đầy đủ ở [docs/06-setup-deploy.md](docs/06-setup-deploy.md).

---

## 7. Roadmap

- [x] Phase 0 — Tài liệu & thiết kế (tài liệu này)
- [ ] Phase 1 — Backend FastAPI + DB + Auth
- [ ] Phase 2 — Seed dữ liệu (moods, weathers, 100 quotes)
- [ ] Phase 3 — Flutter scaffold
- [ ] Phase 4 — Flutter features
- [ ] Phase 5 — Upload ảnh end-to-end
- [ ] Phase 6 — Build web + app
- [ ] Phase 7 — Kiểm thử & deploy

---

## 8. Giấy phép

Dự án cá nhân — MIT License (dự kiến).
