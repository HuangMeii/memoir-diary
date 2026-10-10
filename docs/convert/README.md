# Kế hoạch hoàn thiện Flutter và chuyển backend sang Serverpod

## 1. Phạm vi

Tài liệu này lập kế hoạch hoàn thiện Memoir với Flutter/Dart ở frontend và
Serverpod/Dart là backend đích. FastAPI được giữ làm backend tham chiếu trong
thời gian migration để kiểm tra parity và rollback.

Không chuyển database, JWT, password hash hoặc S3 credential vào Flutter.
Không copy backend Python vào app/web.

## 2. Kiến trúc đích

```text
Flutter App + Flutter Web
        │
        └── Serverpod/Dart backend
                    │
                    ├── PostgreSQL + Object Storage
                    └── Python AI services riêng
```

## Phương án đã chọn

Mục tiêu dài hạn:

- Serverpod/Dart cho backend nghiệp vụ chính.
- Neon PostgreSQL và private Object Storage.
- Auth, permission, transaction và storage gateway ở server.
- Python chỉ dùng cho các AI service riêng.
- Flutter Repository giữ ổn định trong khi DataSource chuyển từ FastAPI sang
  Serverpod.

Trong giai đoạn chuyển đổi, FastAPI vẫn chạy làm implementation tham chiếu;
không xóa hoặc chuyển production traffic trước khi hoàn tất parity.

## 3. Tài liệu trong thư mục

- [00-decision-and-risks.md](00-decision-and-risks.md) — quyết định giữ
  FastAPI và các rủi ro cần xử lý.
- [01-current-backend-inventory.md](01-current-backend-inventory.md) — kiểm kê
  router, bảng dữ liệu, nghiệp vụ và phần Flutter đã có.
- [02-target-architecture.md](02-target-architecture.md) — kiến trúc Flutter
  mục tiêu khi FastAPI vẫn là backend.
- [03-api-to-flutter-mapping.md](03-api-to-flutter-mapping.md) — mapping endpoint
  FastAPI sang repository/provider Flutter.
- [04-data-and-storage-migration.md](04-data-and-storage-migration.md) — kế
  hoạch database, auth, ảnh và dữ liệu lịch sử.
- [05-execution-phases.md](05-execution-phases.md) — phase, task, dependency,
  deliverable và điều kiện hoàn thành.
- [06-testing-and-cutover.md](06-testing-and-cutover.md) — kiểm thử API,
  production deployment và rollback FastAPI.
- [07-serverpod-migration-roadmap.md](07-serverpod-migration-roadmap.md) — lộ
  trình rewrite backend bằng Serverpod/Dart và tích hợp AI service.

## 4. Nguyên tắc không được phá vỡ

- Không commit hoặc bundle `DATABASE_URL`, `JWT_SECRET`, S3 secret hay password
  hash vào Flutter.
- Không cho Flutter kết nối trực tiếp Neon bằng connection string.
- Không xóa FastAPI trước khi Serverpod đạt parity và có rollback đã kiểm tra.
- Giữ user-facing behavior hiện tại trong suốt migration.
- Migrate theo domain, có feature flag và rollback độc lập.
- Mọi thay đổi schema phải có migration có thể chạy lại và backup trước đó.
