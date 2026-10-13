# 09 — Gỡ backend FastAPI (cutover 2026-10-11)

## Quyết định

Serverpod/Dart trở thành **backend duy nhất**. `backend/` (FastAPI) đã bị xoá khỏi
repo, cùng với đường REST phía Flutter: `core/api_client.dart`,
`data/datasources/fastapi_data_source.dart`, `core/auth_repository.dart`, cờ
`BACKEND` và `AppConfig.apiBaseUrl`.

Phần còn dùng chung được tách ra file riêng:

- `core/api_exception.dart` — `ApiException` (Serverpod data source + repositories
  vẫn dùng).
- `core/session.dart` — `SessionStore` + `sessionStoreProvider` (Serverpod client
  đọc access token từ đây qua `serverpod_backend.dart`).

## Căn cứ

- Serverpod có **model + endpoint cho toàn bộ 16 domain** (auth, lookups, journal,
  images, quotes, daily quotes, self messages, reflections, notes, todos, events,
  schedules, health, stats, admin, weather) + `seed`.
- `dart test` trong `memoir_server_server` **PASS** (3/3, PostgreSQL nhúng tự quản)
  — server khởi động, apply migration và xử lý auth end-to-end.
- `dart analyze` (server) và `flutter analyze` (app) **sạch**.

## Lệch khỏi ADR/roadmap — có chủ đích

`08-adr-serverpod.md` và `07-serverpod-migration-roadmap.md` yêu cầu *parity report*
+ *backup đã diễn tập restore* **trước khi** gỡ FastAPI. Lần này gỡ **trước**, theo
yêu cầu rõ ràng của chủ dự án.

**Rủi ro đã chấp nhận:** chưa có bằng chứng parity từng domain với FastAPI.

## Rollback

Tag `pre-fastapi-removal` giữ nguyên trạng thái trước khi gỡ:

```powershell
git fetch --tags
git checkout pre-fastapi-removal
# hoặc chỉ lấy lại backend:
git checkout pre-fastapi-removal -- backend/
```

## Còn lại (chưa làm)

- [ ] **Parity fixtures + parity test** cho từng domain (FastAPI không còn trong
      repo — lấy lại từ tag `pre-fastapi-removal` khi cần đối chiếu).
- [ ] **Upload ảnh trên web**: `file_bytes_stub.dart` vẫn
      `throw UnsupportedError` — web không đọc được file theo path, cần truyền bytes
      từ `XFile`.
- [ ] Test cho `serverpod_data_source`, `SessionStore` và các repository.
- [ ] CI workflow (analyze/test/build) cho `memoir_server` và `flutter_app`.
- [ ] Quét tài liệu còn nhắc FastAPI: `docs/01-architecture.md`,
      `docs/02-data-flow.md`, `docs/04-api-reference.md`, `docs/05-features.md`,
      `PLAN.md`, `CONTRIBUTING.md`, `.gitignore` (mục “Python (backend)”).
- [ ] **Không còn silent token refresh**: `SessionStore` không còn gọi
      `/auth/refresh`; token Serverpod là opaque và được trả về cho cả access lẫn
      refresh nên hiện chưa cần, nhưng nếu sau này thêm hạn cho token thì phải làm
      lại phần này.
