# 06 — Setup & Deploy

## 1. Yêu cầu hệ thống

| Thành phần | Phiên bản đề nghị | Ghi chú |
|---|---|---|
| Dart SDK | 3.12+ | `memoir_server` khai báo `sdk: ^3.12.2` |
| Serverpod CLI | 4.0.4 | `dart pub global activate serverpod_cli` |
| PostgreSQL | tự quản (dev) / Neon serverless (prod) | Dev: PostgreSQL nhúng qua `database.dataPath`; Prod: Neon |
| Object Storage riêng tư | — | S3-compatible cho ảnh (Neon Object Storage) |
| Flutter SDK | 3.22+ | Bắt buộc để build app/web |
| Git | 2.40+ | |

> Backend là **Serverpod/Dart** (`memoir_server/`). Backend FastAPI cũ đã bị gỡ —
> xem [convert/09-remove-fastapi.md](convert/09-remove-fastapi.md).

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
flutter run -d chrome
```

**App (dev, có thiết bị/emulator)**:
```powershell
flutter run --dart-define=SERVERPOD_URL=http://10.0.2.2:8080   # Android emulator
```

**Build phát hành**:
```powershell
flutter build web --release --dart-define=SERVERPOD_URL=https://api.example.com
flutter build apk --release --dart-define=SERVERPOD_URL=https://api.example.com
# iOS (cần macOS): flutter build ios --release
```

> Web dev và Android emulator **không cần** `--dart-define` — `AppConfig` tự chọn
> theo nền tảng (`kIsWeb` → `http://127.0.0.1:8080`, Android → `10.0.2.2:8080`).
> Chỉ **bắt buộc** khi deploy production hoặc chạy trên thiết bị thật.

---

## 7. Triển khai (production)

### Backend
- Chạy server Serverpod sau reverse proxy có HTTPS: `dart bin/main.dart` trong
  `memoir_server_server` (hoặc `serverpod start` khi phát triển).
- Cấu hình `config/production.yaml` + `config/passwords.yaml` (hoặc biến môi trường
  tương ứng) trên host.
- Bật HTTPS; giới hạn `allowedOrigins` nếu dùng `authCookie`.

### Web
- `flutter build web --release` → upload thư mục `build/web` lên Netlify/Vercel/Firebase Hosting.

### App
- Ký và phát hành qua Google Play / App Store.

---

## 8. Checklist Go-live

- [ ] `config/production.yaml` + `passwords.yaml` đã điền (DB, storage)
- [ ] Bucket ảnh đã tạo, access level đúng
- [ ] Migration đã apply (server tự apply khi boot)
- [ ] Seed xong moods, weathers, 100 quotes (endpoint `seed`)
- [ ] Health endpoint trả OK
- [ ] Đăng ký/đăng nhập/upload ảnh smoke test OK
- [ ] Web build chạy, gọi được API Serverpod (`SERVERPOD_URL` đúng)
