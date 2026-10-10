# 05 — Hoàn thiện Flutter & ổn định FastAPI reference

> Đây là track chuẩn bị: tách abstraction trong Flutter và giữ FastAPI ổn định
> làm reference. Lộ trình **rewrite backend sang Serverpod/Dart** nằm ở
> `07-serverpod-migration-roadmap.md`.
>
> Trạng thái đánh dấu theo thực tế repo ngày 2026-10-10. `[~]` = làm một phần.

## Phase 0 — Chốt target và bảo vệ hiện trạng

**Deliverable:** chốt Serverpod là backend đích, giữ FastAPI hiện tại làm
reference, backup và inventory.

- [x] Chốt hướng Serverpod/Dart + Neon PostgreSQL + Neon Object Storage (mới trên tài liệu, chưa có ADR — nay đã bổ sung `08`).
- [x] Giữ FastAPI làm reference backend trong thời gian migration.
- [~] `/health` trả `ok` ở local (`backend/app/main.py`); staging chưa dựng.
- [ ] Tách config dev/staging/production (hiện chỉ có 1 `.env`).
- [ ] Ghi ADR và chi phí ước tính.
- [ ] Backup DB và manifest ảnh.
- [ ] Freeze schema production trong thời gian migrate.
- [ ] Feature flag chọn datasource trong Flutter (`AppConfig` mới có `apiBaseUrl`).

**Gate:** rollback staging thành công.

## Phase 1 — Tách abstraction trong Flutter

**Deliverable:** UI không còn phụ thuộc trực tiếp vào transport cụ thể; backend
transport có thể đổi từ FastAPI sang Serverpod.

- [x] Tạo repository interfaces theo domain.
- [x] Tạo `FastApiDataSource` và repository đầu tiên cho lookup/journal.
- [x] Chuyển provider quote, reflection, image gallery và health sang repository.
- [x] Chuyển auth, entry write, notes, planner và health write khỏi UI gọi `ApiClient` trực tiếp.
- [ ] Di chuyển model từ `data/models.dart` thành typed domain models (notes/planner còn `Map<String, dynamic>`).
- [ ] Tạo error mapping và loading/empty/error state chuẩn.
- [ ] Bọc datasource cũ trong `LegacyBackendDataSource`.
- [ ] Bổ sung test (hiện chỉ có `test/widget_test.dart`) và giữ chúng chạy xanh.

**Gate:** hành vi app không đổi, chỉ thay đổi cấu trúc code.

## Phase 2 — Auth và lookups

- [ ] Kiểm tra auth FastAPI staging (register/login/refresh/me).
- [x] Implement login/register/restore qua `AuthRepository` (logout/refresh vẫn do `ApiClient` interceptor quản lý).
- [ ] Implement user mapping và role claim/policy.
- [ ] Migrate mood/weather seed.
- [ ] Test unauthorized/forbidden/expired session.

**Gate:** auth parity trên mobile và web trước khi chuyển traffic.

## Phase 3 — Journal và ảnh

- [ ] Kiểm tra dữ liệu entries và images hiện tại; chỉ migrate khi đổi môi trường.
- [x] Implement EntryRepository và image storage gateway.
- [ ] Kiểm tra ownership checks và presigned URL của FastAPI.
- [ ] Verify create/edit/by-date/delete và gallery.
- [ ] Chạy dual-read cho ảnh.

**Gate:** không mất entry/ảnh và không đọc chéo user.

## Phase 4 — Quote ecosystem

- [ ] Kiểm tra quotes, self messages, daily quotes, reflections hiện tại.
- [ ] Giữ pair generation trong FastAPI service/transaction.
- [ ] Verify reshuffle không tạo duplicate ngày.
- [ ] Verify quote deleted vẫn giữ history row.

**Gate:** parity quote history theo sample tháng.

## Phase 5 — Productivity và health

- [x] Notes, todos, events, schedules, health logs qua `NotesRepository`, `PlannerRepository`, `HealthRepository`.
- [ ] Stats grid/summary bằng view/RPC/function.
- [ ] Preserve timezone và ISO week behavior.
- [ ] Verify planner tải độc lập từng tab.

**Gate:** parity CRUD và summary trước khi chuyển traffic.

## Phase 6 — Admin và roadmap

- [ ] Admin dependency/role checks trong FastAPI.
- [ ] Admin dashboard/users/quote manager.
- [ ] Chỉ sau khi MVP ổn định mới triển khai Garden, Calendar, Forecast.

**Gate:** user thường không thấy/không gọi được admin operation.

## Phase 7 — Production FastAPI reference

- [ ] Deploy FastAPI production với HTTPS (là reference trong giai đoạn migration).
- [ ] Build Flutter Web/App trỏ tới production API bằng `--dart-define`.
- [ ] Theo dõi error rate, auth failure và storage failure.
- [ ] Canary release Flutter trước khi phát hành rộng.
- [ ] Giữ rollback image/build và backup bất biến.

## Track Serverpod/Dart — xem `07-serverpod-migration-roadmap.md`

- Toolchain (2026-10-10): Dart 3.13.5 ✅, Flutter 3.47.6 ✅,
  Serverpod CLI **4.0.4 đã cài** ✅, Docker ❌ (không cần — dùng embedded PostgreSQL).
- Phase 0 (toolchain + workspace): ✅ `memoir_server/` (workspace + server +
  generated client + migration `20261010150402579`).
- Phase 1 (shared infra): ✅ custom `authenticationHandler` + token table
  (`auth_tokens`), bcrypt cho parity hash cũ, `ApiException` cho lỗi, cloud
  storage private cho ảnh, model cho toàn bộ 14 bảng.
- Phase 2–4 (domain phía server): ✅ auth, lookups, entries, images, quotes,
  self messages, daily quotes, reflections, notes, todos, events, schedules,
  health, stats, admin, weather, seed. `dart analyze` sạch.
- Còn lại: contract fixtures và parity test với FastAPI, chạy `dart test`
  (embedded PostgreSQL không khởi tạo được trong sandbox hiện tại), và cutover
  từng domain. Flutter đã nối xong: `BackendDataSource` + `ServerpodDataSource`
  sau flag `--dart-define=BACKEND=serverpod` (mặc định vẫn là FastAPI).
