# 04 — Migration dữ liệu, Auth và Storage

> Transport: FastAPI = reference trong migration; đích cuối = Serverpod/Dart
> (xem `07-serverpod-migration-roadmap.md`).

## Phase A — Inventory và backup

- Dump PostgreSQL schema + data.
- Export user list không bao gồm password hash trong log/report.
- Tạo manifest ảnh: `image_id`, `entry_id`, `object_key`, size, checksum.
- Snapshot Neon và lưu bản backup được mã hóa.
- Đếm row theo từng bảng, kiểm tra foreign key/orphan.

## Phase B — Schema target

- Tạo Neon branch/database staging và FastAPI staging riêng.
- Giữ schema SQLAlchemy/Alembic hiện tại làm nguồn chuẩn.
- Rà soát ownership check ở từng router có `user_id`.
- Tạo index/unique constraint tương đương:
  `user_id + entry_date`, `user_id + log_date`, `user_id + quote_date`.
- Giữ auth, daily quote và admin operations trong FastAPI services/routers.

## Phase C — Auth

- Không migrate `JWT_SECRET` sang client.
- Không migrate password hash hoặc JWT secret sang Flutter.
- Giữ bcrypt/JWT ở FastAPI; chỉ thay secret khi triển khai production.
- Link user cũ bằng immutable mapping table:
  `legacy_user_id -> managed_auth_user_id`.
- Kiểm thử user active, inactive, admin, refresh hết hạn và reset password.

## Phase D — Data copy

Thứ tự:

1. `users` và auth mapping.
2. `moods`, `weathers`.
3. `diary_entries`.
4. `entry_images` metadata.
5. `quotes`, `self_messages`, `daily_quotes`, `reflections`.
6. `notes`, `todos`, `events`, `schedule_items`, `health_logs`.

Sau mỗi nhóm: row count, checksum field quan trọng, foreign key và sample read.

## Phase E — Image copy

- Giữ bucket Neon hiện tại, object key và metadata. Chỉ chạy copy khi đổi bucket
  theo yêu cầu riêng.
- Không để Flutter làm nhiệm vụ copy với credential storage.
- Verify size/content-type/checksum.
- Chạy dual-read URL trong staging.
- Chỉ xóa bucket cũ sau thời gian rollback đã thống nhất.

## Phase F — Reconciliation

- So sánh số row mỗi bảng.
- So sánh entry theo ngày và mood/weather.
- So sánh daily quote pair từng ngày.
- Mở sample gallery theo nhiều user.
- Ghi lại mọi mismatch và quyết định sửa/giữ theo dữ liệu nguồn.
