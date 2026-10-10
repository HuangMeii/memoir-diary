# 00 — Quyết định giữ FastAPI và rủi ro

## 1. Câu trả lời ngắn

Không có phương án an toàn để chuyển **toàn bộ backend** vào Flutter binary.
Flutter Web còn công khai hơn vì JavaScript bundle và network request đều có thể
được kiểm tra.

Có thể chuyển phần sau vào Flutter:

- UI và routing.
- Model/DTO.
- Repository gọi SDK.
- State management.
- Validation không nhạy cảm.
- Presentation logic và optimistic UI.

Phải giữ ở managed backend/serverless:

- Password authentication và refresh token signing.
- Quyền truy cập theo user trong FastAPI dependencies/query filters.
- Admin authorization.
- Tính cặp quote server-side.
- Presigned/private storage access.
- Database transaction, uniqueness và aggregate nhạy cảm.

## 2. Quyết định kiến trúc

Đã quyết định **không thay FastAPI**. FastAPI tiếp tục là lớp application
server duy nhất cho Flutter App và Flutter Web.

## 3. Các thành phần được giữ

| Tiêu chí | Bắt buộc |
|---|---|
- FastAPI routers, services, schemas và dependencies.
- SQLAlchemy + Alembic.
- Neon PostgreSQL.
- Neon Object Storage qua boto3/SigV4.
- JWT/bcrypt và CORS server-side.
- Flutter `ApiClient` + Riverpod.

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

## 5. Điều kiện bắt đầu Phase 1

Không bắt đầu Phase 1 nếu chưa có:

- FastAPI staging chạy được và có health check.
- Backup database và manifest ảnh.
- Quyết định giữ FastAPI/Neon PostgreSQL/Object Storage đã được chốt.
- Danh sách user/auth migration được chấp thuận.
- Kế hoạch rollback đã thử trên staging.
