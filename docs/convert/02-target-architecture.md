# 02 — Kiến trúc đích

## 1. Cấu trúc Flutter

```text
flutter_app/lib/
├─ src/
│  ├─ app/                 # router, shell, responsive navigation
│  ├─ core/                # config, session, errors, logging
│  ├─ auth/                # auth gateway và session state
│  ├─ data/
│  │  ├─ models/           # domain models bất biến
│  │  ├─ repositories/     # interface theo domain
│  │  └─ datasources/      # FastAPI HTTP calls
│  ├─ features/
│  │  ├─ journal/
│  │  ├─ quotes/
│  │  ├─ planner/
│  │  ├─ health/
│  │  ├─ notes/
│  │  └─ admin/
│  └─ shared/
│     ├─ widgets/
│     └─ validators/
```

## 2. Luồng dữ liệu

```text
Screen
  → Riverpod controller/notifier
  → Repository interface
  → ApiClient
  → FastAPI
  → Neon PostgreSQL / Object Storage
```

Screen không được gọi `ApiClient` trực tiếp. Điều này giữ khả năng test,
mock và thay đổi API mà không sửa toàn bộ UI.

## 3. Boundary server-side

### FastAPI chịu trách nhiệm server-side

- Đọc/sửa entry của chính user.
- Đọc lookup mood/weather.
- CRUD notes, todos, events, schedules, health logs của chính user.
- Đọc lịch sử quote của chính user.

### Bắt buộc dùng function hoặc transaction server-side

- Đăng ký, refresh và disable account.
- Tạo daily quote pair đúng một lần mỗi ngày.
- Reshuffle quote có kiểm soát.
- Admin CRUD system quotes và user management.
- Upload/delete private object và tạo presigned URL.
- Aggregate thống kê cần bảo vệ hoặc query phức tạp.

## 4. Storage

- Bucket private.
- Flutter chỉ nhận API URL và session token.
- FastAPI kiểm tra ownership theo `user_id`/entry ownership.
- S3 access key, secret và Neon connection string chỉ nằm trong `.env` server,
  secret manager hoặc deployment environment; không đưa vào app.
- Presigned URL hoặc signed storage URL có thời hạn ngắn.
