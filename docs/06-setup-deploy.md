# 06 — Setup & Deploy

## 1. Yêu cầu hệ thống

| Thành phần | Phiên bản đề nghị | Ghi chú |
|---|---|---|
| Python | 3.12 (khuyến nghị) | Tránh 3.14 để đủ wheel psycopg/pydantic-core |
| FastAPI / Uvicorn | mới nhất | |
| PostgreSQL | Neon serverless | Cloud, không cần cài local |
| Neon Object Storage | — | S3-compatible, cần bật trong Neon project |
| Flutter SDK | 3.22+ | Bắt buộc để build app/web |
| Git | 2.40+ | |

> ⚠️ Trên máy hiện tại **chưa có Flutter SDK**. Cài bằng `winget install --id Google.Flutter` hoặc tải zip Flutter ổn định và thêm `flutter\bin` vào PATH.

---

## 2. Cài Backend (Serverpod/Dart)

```powershell
cd memoir_server
dart pub get
```

Yêu cầu: **Dart SDK** (workspace khai báo `sdk: ^3.12.2`) và **Serverpod CLI**:

```powershell
dart pub global activate serverpod_cli
# nếu `serverpod` chưa có trên PATH: thêm %LOCALAPPDATA%\Pub\Cache\bin vào PATH
```

Không cần cài PostgreSQL hay Docker: `config/development.yaml` đặt
`database.dataPath: .serverpod/development/pgdata`, nên Serverpod tự quản một
PostgreSQL nhúng cho môi trường dev (DB port `8090`).

---

## 3. Cấu hình

- `memoir_server/memoir_server_server/config/development.yaml` — cổng API
  (`apiServer.port: 8080`), Insights (`8081`), tên DB/user.
- `memoir_server/memoir_server_server/config/passwords.yaml` — mật khẩu DB dev
  (**không commit**). `staging.yaml` / `production.yaml` cho môi trường thật.
- Ảnh dùng **object storage riêng tư** qua storage gateway của server; database,
  JWT và storage secret **không bao giờ** đi xuống Flutter.

---

## 4. Migrate & Seed

`serverpod start` **apply migration còn thiếu khi khởi động**. Muốn sinh migration
mới sau khi đổi model:

```powershell
cd memoir_server\memoir_server_server
serverpod create-migration          # thêm --force nếu là thay đổi phá huỷ
```

Dữ liệu tham chiếu (moods, weathers, 100 quotes) seed qua **endpoint `seed`**
(idempotent) — xem `lib/src/seed/seed_endpoint.dart`.

---

## 5. Chạy backend (dev)

```powershell
cd memoir_server
serverpod start
```

- API: http://localhost:8080 · Insights: http://localhost:8081
- `serverpod start` watch file → sinh code tăng dần + hot reload.
- Khi CLI không chạy được, fallback:
  ```powershell
  cd memoir_server\memoir_server_server
  dart bin\main.dart
  ```

---

## 6. Cài & chạy Flutter

```powershell
cd flutter_app
flutter pub get
```

**Web (dev)**:
```powershell
flutter run -d chrome --dart-define=API_BASE_URL=http://127.0.0.1:8000/api/v1
```

**App (dev, có thiết bị/emulator)**:
```powershell
flutter run --dart-define=API_BASE_URL=http://10.0.2.2:8000/api/v1   # Android emulator
```

**Build phát hành**:
```powershell
flutter build web --release --dart-define=API_BASE_URL=https://api.example.com/api/v1
flutter build apk --release --dart-define=API_BASE_URL=https://api.example.com/api/v1
# iOS (cần macOS): flutter build ios --release
```

> `API_BASE_URL` phải **kết thúc bằng `/api/v1`** (code nối tiếp `/{endpoint}`).
> Khi chạy web/emulator dev thì **không cần** `--dart-define` — `AppConfig` tự chọn theo nền tảng (`kIsWeb`).
> Chỉ **bắt buộc** `--dart-define` khi deploy production hoặc chạy trên thiết bị thật.

---

## 7. Triển khai (production)

### Backend
- Chạy `gunicorn -k uvicorn.workers.UvicornWorker app.main:app` (Render/Fly/VPS).
- Đặt biến môi trường giống `.env` trên nền tảng host.
- Bật HTTPS, cấu hình `CORS_ORIGINS` = domain web thật.

### Web
- `flutter build web --release` → upload thư mục `build/web` lên Netlify/Vercel/Firebase Hosting.

### App
- Ký và phát hành qua Google Play / App Store.

---

## 8. Checklist Go-live

- [ ] `.env` đã điền đủ DATABASE_URL, S3_*, JWT_SECRET
- [ ] Bucket `diary-images` đã tạo, access level đúng
- [ ] `alembic upgrade head` thành công
- [ ] Seed xong 5 moods, 5 weathers, 100 quotes
- [ ] `/health` trả `ok`
- [ ] Đăng ký/đăng nhập/upload ảnh smoke test OK
- [ ] Web build chạy, gọi được API (CORS đúng)
