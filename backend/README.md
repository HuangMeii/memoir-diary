# Memoir — Backend (FastAPI)

REST API cho ứng dụng nhật ký **Memoir**. Xem tài liệu tổng thể ở [`../docs/`](../docs).

## Yêu cầu
- Python 3.12+ (khuyến nghị 3.12; tránh các bản quá mới nếu thiếu wheel)
- PostgreSQL (Neon serverless) + Neon Object Storage (S3-compatible)

## Cài đặt
```powershell
cd backend
python -m venv .venv
.\.venv\Scripts\Activate.ps1
pip install -r requirements.txt
copy .env.example .env      # rồi điền DATABASE_URL, S3_*, JWT_SECRET
```

## Migrate & chạy
```powershell
alembic revision --autogenerate -m "init schema"   # lần đầu
alembic upgrade head
uvicorn app.main:app --reload --port 8000
```
- Swagger UI: http://127.0.0.1:8000/docs
- Health: http://127.0.0.1:8000/health

## Cấu trúc
```
app/
├─ main.py          # FastAPI app + CORS + gắn routers dưới /api/v1
├─ core/            # config, database, security (JWT/bcrypt), deps, storage (S3)
├─ models/          # SQLAlchemy models (13 bảng)
├─ schemas/         # Pydantic request/response
├─ routers/         # auth, entries, images, quotes, self-messages, reflections,
│                   # notes, todos, events, schedules, health, stats, lookups
└─ services/        # stats, quote (random), storage
alembic/            # migrations
```

## Ghi chú
- Mọi endpoint nghiệp vụ yêu cầu `Authorization: Bearer <token>` (trừ `/health`, `/moods`, `/weathers`).
- Ảnh lưu trên **Neon Object Storage** (path-style + SigV4, dùng `endpoint_url`); DB chỉ lưu metadata.
- `AUTO_CREATE_TABLES=true` chỉ dùng khi dev nhanh với SQLite; production dùng Alembic.

## Seed dữ liệu tham chiếu

Bảng `moods`, `weathers`, `quotes` cần dữ liệu trước khi tạo nhật ký.

```powershell
alembic upgrade head          # tạo bảng (chỉ 1 lần)
python -m app.seed.seed       # nạp dữ liệu (idempotent, chạy lại cũng an toàn)
python -m app.seed.seed --reset   # xoá dữ liệu seed cũ rồi nạp lại
```

| Bảng | Số bản ghi | Nội dung |
|------|-----------|----------|
| `moods` | 5 | Vui, Buồn, Chán, Bình thường, Giận |
| `weathers` | 5 | Nắng, Râm, Mưa, Bão, Khác |
| `quotes` | 100 | Kho câu động viên/giáo dục (`app/seed/quotes_100.json`) |

- Câu trong `quotes` có `user_id = NULL` → **dùng chung cho mọi người dùng**. Thêm câu riêng qua `POST /api/v1/quotes` (bản ghi có `user_id` riêng).
- Nếu quên chạy migration, script báo rõ: `Database schema is missing tables: ... Run migrations first: alembic upgrade head`.

## Test

```powershell
pytest -q
```

Test dùng SQLite riêng (`memoir_test.db`), không đụng database dev.
