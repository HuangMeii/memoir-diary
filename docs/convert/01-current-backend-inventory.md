# 01 — Kiểm kê backend hiện tại

## 1. Runtime

- FastAPI entrypoint: `backend/app/main.py`.
- API prefix lấy từ config, tài liệu hiện tại dùng `/api/v1`.
- PostgreSQL Neon qua SQLAlchemy/ Alembic.
- Neon Object Storage S3-compatible, bucket private `diary-images`; sẽ được
  truy cập qua serverless function hoặc signed URL, không truy cập trực tiếp từ
  Flutter bằng secret.
- Auth JWT + bcrypt, access token ngắn hạn và refresh token.

## 2. Domain và router

| Domain | Router | Trạng thái Flutter |
|---|---|---|
| Auth | `auth` | Có login/register/session restore |
| Lookup | `lookups` | Có mood/weather provider |
| Entry | `entries` | Có editor và entry by date |
| Image | `images` | Có upload/preview/delete |
| Quote | `quotes` | Có một phần quote card; manager cần hoàn thiện |
| Daily quote | `daily_quotes` | Có today/history/reshuffle |
| Self message | `self_messages` | Có lưu từ quote card; list cần UI |
| Reflection | `reflections` | Có lưu từ quote card/editor |
| Notes | `notes` | Có list/add/delete; edit/pin cần hoàn thiện |
| Todos | `todos` | Có trong planner |
| Events | `events` | Có trong planner |
| Schedule | `schedules` | Có trong planner |
| Health | `health` | Có input và chart 30 ngày |
| Stats | `stats` | Có mood grid/weather grid/summary |
| Weather | `weather` | Có router; UI forecast chưa triển khai |
| Admin | `admin` | API có; Flutter admin UI chưa có |

## 3. Bảng dữ liệu cần kiểm kê

`users`, `moods`, `weathers`, `diary_entries`, `entry_images`, `quotes`,
`self_messages`, `daily_quotes`, `reflections`, `notes`, `todos`, `events`,
`schedule_items`, `health_logs`, cùng các bảng roadmap nếu đã được migrate.

## 4. Việc phải chốt trước migration

- Tên field chuẩn: `thought` và `text` của reflection phải thống nhất.
- Phân trang hiện có thực tế có khớp tài liệu API không.
- Có bao nhiêu user active/inactive, entry, image, quote và object.
- Các row legacy thiếu `user_id`, `week_label` hoặc metadata ảnh.
- Admin nào cần được giữ role và được function kiểm tra server-side.
