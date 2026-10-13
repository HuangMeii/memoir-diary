# 00 — Quyết định chuyển backend sang Serverpod/Dart và rủi ro

## 1. Câu trả lời ngắn

Đích dài hạn là **Dart backend riêng (Serverpod)** cho toàn bộ nghiệp vụ.
FastAPI chỉ còn là **reference implementation** trong thời gian migration để
kiểm tra parity và rollback.

Điều **không** làm: **không nhúng backend vào Flutter binary** (app/web).
Flutter Web đặc biệt không an toàn vì JavaScript bundle và network request đều
có thể bị kiểm tra. Serverpod là process server riêng, giữ secret phía server.

Có thể chuyển vào Flutter (client):

- UI và routing.
- Model/DTO.
- Repository gọi SDK.
- State management.
- Validation không nhạy cảm.
- Presentation logic và optimistic UI.

Bắt buộc ở server (Serverpod, không bao giờ ở client):

- Password authentication và refresh token signing.
- Quyền truy cập theo user và admin authorization.
- Tính cặp quote server-side trong transaction.
- Presigned/private storage access.
- Database transaction, uniqueness và aggregate nhạy cảm.

## 2. Quyết định kiến trúc

Đã chốt: backend nghiệp vụ đích là **Serverpod/Dart**. Trong thời gian
migration, FastAPI tiếp tục chạy như **reference implementation** để kiểm tra
parity và rollback; FastAPI chỉ bị xóa sau khi Serverpod đạt parity và rollback
đã kiểm tra (chi tiết ở `07-serverpod-migration-roadmap.md`).

## 3. Thành phần FastAPI tạm giữ trong migration

Các thành phần dưới đây tiếp tục chạy trong FastAPI cho tới khi Serverpod đạt
parity, sau đó được thay thế ở tầng server.

| Thành phần FastAPI (tạm giữ) | Thay bằng (Serverpod/Dart) |
|---|---|
| routers, services, schemas, dependencies | Serverpod endpoints + domain services |
| SQLAlchemy + Alembic | Serverpod ORM + migration |
| JWT/bcrypt + CORS server-side | Serverpod auth/session + role checks |
| Neon Object Storage qua boto3/SigV4 | Serverpod storage gateway (signed URL) |
| Flutter `ApiClient` + Riverpod | Giữ nguyên; chỉ đổi DataSource sang SDK Serverpod |

## 4. Rủi ro chính

| Rủi ro | Mức | Cách giảm thiểu |
|---|---|---|
| Lộ secret khi bundle Flutter | Critical | Secret chỉ ở FastAPI environment |
| Sai mapping password/user | High | Test login, refresh và user ownership |
| Ownership filter sai làm lộ dữ liệu user | Critical | Test matrix user A/B/admin trước cutover |
| Presigned URL khác behavior cũ | High | Storage integration test và private bucket mặc định |
| Quote pair thay đổi lịch sử | High | Giữ daily quote row và transaction/function |
| Mất ảnh khi đổi storage | High | Copy, checksum, đếm object, dual-read |
| Flutter Web cache code cũ | Medium | Versioned deployment, cache headers, smoke test |
| API gọi trực tiếp từ widget | Medium | Repository interface và datasource |
| API contract lệch tài liệu | Medium | Contract test và typed DTO |
| Dev secret dùng ở production | Critical | Secret manager và config theo môi trường |
| FastAPI downtime | High | Health check, logs, backup và deploy rollback |
| Serverpod parity drift theo domain | High | Contract fixtures + parity test trước khi chuyển traffic |
| Lệch phiên bản protocol/code-gen Serverpod client-server | Medium | Pin version Serverpod trong CI, regenerate và review |
| Migrate session/refresh token sang Serverpod | High | Dual-issue token trong canary, test logout/refresh |
| Lệch timezone/`now()` khi chuyển sang Dart | Medium | Dùng `now()` của DB làm chuẩn, test ISO week/ngày |

## 5. Điều kiện bắt đầu Phase 0 (roadmap 07)

Không bắt đầu rewrite Serverpod nếu chưa có:

- Dart SDK pin và Serverpod CLI cài/pin trong CI và máy dev.
- FastAPI staging chạy được và có health check (`/health` local đã OK).
- Contract fixtures lấy từ response FastAPI hiện tại.
- Backup database và manifest ảnh.
- Danh sách user/auth migration được chấp thuận.
- Kế hoạch rollback đã thử trên staging.
