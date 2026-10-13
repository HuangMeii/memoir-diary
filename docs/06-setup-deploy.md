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
  (`apiServer.port: 8080`), Insights (`8081`), tên DB/user. **Dev chạy PostgreSQL
  nhúng** (`database.dataPath: .serverpod/development/pgdata`), không cần Neon.
- `memoir_server/memoir_server_server/config/passwords.yaml` — mật khẩu DB dev
  (**không commit**). `staging.yaml` / `production.yaml` cho môi trường thật.
- Ảnh dùng **object storage riêng tư** qua storage gateway của server; database,
  JWT và storage secret **không bao giờ** đi xuống Flutter.

### 3.1. Neon PostgreSQL cho staging / production

`staging.yaml` và `production.yaml` trỏ vào **Neon (serverless)**. Điền các
placeholder `REPLACE_WITH_NEON_*` (host pooler, tên DB, user) lấy từ **Neon
Console → Connect**; mật khẩu để trong `passwords.yaml` (`staging.database` /
`production.database`) hoặc cấp qua biến môi trường trên host.

Serverpod đọc cấu hình theo thứ tự cờ CLI → `config/<mode>.yaml` → env:

| Biến môi trường | Ý nghĩa |
|---|---|
| `SERVERPOD_RUN_MODE` | `staging` hoặc `production` (chọn `config/<mode>.yaml`) |
| `SERVERPOD_DATABASE_HOST` / `_PORT` / `_NAME` / `_USER` / `_REQUIRE_SSL` | Ghi đè khối `database` |
| `SERVERPOD_DATABASE_PASSWORD` | Mật khẩu Neon (thay cho `passwords.yaml`) |
| `SERVERPOD_APPLY_MIGRATIONS` | `true` để apply migration khi boot |

Chạy thử tại máy (Serverpod tự apply migration lên Neon):

```powershell
cd memoir_server\memoir_server_server
dart bin\main.dart --mode staging --apply-migrations
```

> Khuyến nghị **branch Neon riêng** cho staging và production. Không trỏ thẳng
> vào database Neon thời FastAPI vì Serverpod dùng schema khác — xem 3.2.

### 3.2. Chuyển dữ liệu từ database thời FastAPI

`neondb` từng thuộc backend FastAPI: bảng snake_case, có bảng `alembic_version`.
Serverpod dùng cột camelCase (`password_hash` → `passwordHash`, `created_at` →
`createdAt`, `date` → `timestamp`) nên **không thể** trỏ thẳng vào. Cách đã dùng
(giữ nguyên dữ liệu, đảo ngược được):

1. Chuyển toàn bộ bảng `public` sang schema `legacy`:
   `ALTER TABLE public.<t> SET SCHEMA legacy` — thao tác metadata, tức thời.
2. Cho Serverpod chạy `--apply-migrations` để tạo schema mới trong `public`.
3. Copy dữ liệu `legacy.<t>` → `public.<t>` với ánh xạ snake_case → camelCase
   (`date` → `timestamp`, `created_at at time zone 'UTC'`), rồi `setval` cho
   sequence `moods`/`weathers`.

Schema `legacy` giữ lại làm bản sao lưu; xoá khi app đã chạy đúng:

```sql
DROP SCHEMA legacy CASCADE;
```


---

## 4. Migrate & Seed

`serverpod start` **apply migration còn thiếu khi khởi động**. Muốn sinh migration
mới sau khi đổi model:

```powershell
cd memoir_server\memoir_server_server
serverpod create-migration          # thêm --force nếu là thay đổi phá huỷ
```

Dữ liệu tham chiếu (moods, weathers, 100 quotes) seed qua **endpoint `seed`**
(idempotent) — xem `lib/src/shared/seed_endpoint.dart`.

### 4.1. Đồng bộ dữ liệu Neon → DB dev

Dev chạy PostgreSQL **nhúng và tách biệt** (`database.dataPath`), nên tài khoản/nhật
kỳ trên Neon không tự có ở dev. Khi cần bản sao local (để dev offline khỏi Neon),
dùng công cụ `tool/sync_from_neon.dart` — nó **chỉ đọc Neon** và **chỉ ghi vào DB dev**:

```powershell
cd memoir_server\memoir_server_server
dart run tool\sync_from_neon.dart --dry-run   # xem số row 2 bên, không ghi
dart run tool\sync_from_neon.dart --replace   # copy (idempotent, TRUNCATE trước)
```

- Đích dev nối qua **unix-socket** của cụm nhúng (`…/.serverpod/development/run/.s.PGSQL.<port>`),
  không qua TCP; nguồn Neon lấy từ `config/staging.yaml` + `config/passwords.yaml`.
- Copy thẳng theo bảng (`users`, lookups, `quotes`, `diary_entries`, …), bỏ qua
  `serverpod_*` (giữ nguyên state migration của dev) và `auth_tokens` (đăng nhập lại).
  Thêm `--with-tokens` nếu muốn giữ phiên cũ; `--tables=a,b` để giới hạn.
- Cần cụm nhúng đang chạy (khởi động server một lần) để có socket.
- Mật khẩu được copy nguyên hash ⇒ đăng nhập dev **bằng đúng tài khoản Neon**.

**Ảnh:** ảnh nằm ở Neon Object Storage, DB chỉ lưu key. Để ảnh hiển thị ở dev, thêm
`s3AccessKey`/`s3SecretKey` vào mục `development:` của `config/passwords.yaml`
(đã cấu hình sẵn) và **khởi động lại server** để nạp credential.

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
