# 04 — API Reference

## 1. Quy ước chung

- **Base URL (dev)**: `http://127.0.0.1:8000`
- **Prefix**: `/api/v1` (khuyến nghị) — ví dụ `POST /api/v1/auth/login`. Swagger UI: `/docs`, ReDoc: `/redoc`.
- **Định dạng**: JSON (`Content-Type: application/json`), riêng upload ảnh dùng `multipart/form-data`.
- **Xác thực**: header `Authorization: Bearer <access_token>` cho mọi endpoint tài nguyên.
- **Phân trang**: `?page=1&size=20` → trả `{items, total, page, size}`.
- **Ngày/giờ**: chuỗi ISO-8601 (`2026-04-04`, `2026-04-04T21:30:00+07:00`).
- **Mã lỗi**: `400` (bad request), `401` (chưa xác thực), `403` (không có quyền), `404` (không thấy), `409` (xung đột), `422` (validate), `500` (server).

---

## 2. Auth — `/auth`

### 2.1. Đăng ký
`POST /auth/register`
```json
// Request
{ "email": "a@example.com", "username": "an", "password": "secret123", "display_name": "An" }
// Response 201
{ "id": "uuid", "email": "a@example.com", "username": "an", "access_token": "eyJ...", "token_type": "bearer" }
```

### 2.2. Đăng nhập (OAuth2 password flow)
`POST /auth/login` (form-urlencoded)
```
username=a@example.com&password=secret123
```
```json
// Response 200
{ "access_token": "eyJ...", "refresh_token": "eyJ...", "token_type": "bearer", "expires_in": 3600 }
```

### 2.2b. Làm mới token (refresh)
`POST /auth/refresh`
```json
// Request
{ "refresh_token": "eyJ..." }
// Response 200
{ "access_token": "eyJ...", "token_type": "bearer", "expires_in": 3600 }
```

> **Access token hạn 60 phút, refresh token hạn 30 ngày.** Mỗi token mang claim `type`
> (`access` / `refresh`) và **không dùng chỗ cho nhau**: dùng refresh token gọi API thì
> `401`, dùng access token gọi `/auth/refresh` cũng `401`. Endpoint này nạp lại user và
> kiểm tra `is_active`, nên tài khoản bị khoá không thể dùng refresh token cũ để gia hạn.
>
> Refresh token là **stateless** (không lưu DB): không xoay vòng, nên thu hồi riêng từng
> token không được. Việc vô hiệu hóa tài khoản vẫn cắt phiên ngay vì `is_active` được
> kiểm tra ở cả `/auth/refresh` lẫn mọi request.

### 2.3. Thông tin user hiện tại
`GET /auth/me` → `200 { "id", "email", "username", "display_name", "is_active", "role", "created_at" }`

> `role` là `user` hoặc `admin`; admin được phép dùng nhóm endpoint `/admin`.

---

## 3. Entries — `/entries`

| Method | Path | Mô tả |
|---|---|---|
| GET | `/entries` | Danh sách (lọc `?month=2026-04`, `?from=&to=`) |
| GET | `/entries/{id}` | Chi tiết 1 entry (kèm images) |
| GET | `/entries/by-date/{date}` | Lấy theo ngày `YYYY-MM-DD` |
| POST | `/entries` | Tạo entry mới |
| PUT | `/entries/{id}` | Cập nhật entry |
| DELETE | `/entries/{id}` | Xóa entry |

**Body tạo/cập nhật**
```json
{
  "entry_date": "2026-04-04",
  "mood_id": 1,
  "weather_id": 2,
  "diary_text": "Hôm nay...",
  "other_perspective": "Nếu là cô ấy, mình sẽ...",
  "future_message": "Này tôi của 1 năm sau, bạn ổn chứ?",
  "self_care": "Đi bộ 30 phút, ngủ đủ giấc",
  "tomorrow_hope": "Mong mai trời nắng để đi chơi",
  "gratitude": "Biết ơn gia đình",
  "dream": "Mơ thấy mình bay"
}
```

## 4. Images — `/entries/{id}/images`, `/images`

| Method | Path | Mô tả |
|---|---|---|
| POST | `/entries/{id}/images` | Upload ảnh (multipart, field `file`) |
| GET | `/entries/{id}/images` | Danh sách ảnh của entry |
| GET | `/images/{id}/url` | Lấy presigned GET URL |
| DELETE | `/images/{id}` | Xóa ảnh (storage + DB) |

**Response upload 201**
```json
{
  "id": "uuid",
  "entry_id": "uuid",
  "object_key": "entries/uuid/9f3c.jpg",
  "content_type": "image/jpeg",
  "size_bytes": 245678,
  "url": "https://<endpoint>/diary-images/entries/..."
}
```

## 5. Lookups

| Method | Path | Mô tả |
|---|---|---|
| GET | `/moods` | Danh sách 5 cảm xúc (id, code, label_vi, icon, color_hex) |
| GET | `/weathers` | Danh sách 5 thời tiết |

## 6. Quotes (kho câu) — `/quotes`

| Method | Path | Mô tả |
|---|---|---|
| GET | `/quotes` | Danh sách (lọc `?category=&is_active=&page=&size=`) |
| POST | `/quotes` | Thêm câu mới |
| GET | `/quotes/{id}` | Chi tiết |
| PUT | `/quotes/{id}` | Cập nhật |
| DELETE | `/quotes/{id}` | Xóa (mặc định soft-delete `is_active=false`) |
| GET | `/quotes/random` | 1 câu ngẫu nhiên (đang active) |

**Body tạo/cập nhật**
```json
{ "text": "Hãy sống như ngày mai là ngày cuối...", "author": "Khuyết danh", "source": "Facebook", "category": "động viên", "is_active": true }
```

## 7. Self messages — `/self-messages`

| Method | Path | Mô tả |
|---|---|---|
| GET | `/self-messages` | Danh sách lời nhắn của bản thân |
| POST | `/self-messages` | Thêm lời nhắn |
| PUT | `/self-messages/{id}` | Sửa |
| DELETE | `/self-messages/{id}` | Xóa |
| GET | `/random-pair?entry_id=` | Trả 1 câu kho + 1 lời nhắn bản thân |

**Response `/random-pair`**
```json
{
  "quote": { "id": "uuid", "text": "...", "author": "..." },
  "self_message": { "id": "uuid", "content": "..." }
}
```

## 8. Daily quotes — `/daily-quotes`

Cặp câu được **lưu theo ngày**, nên mở app nhiều lần trong ngày vẫn thấy cùng một câu.

| Method | Path | Mô tả |
|---|---|---|
| GET | `/daily-quotes/today` | Cặp câu hôm nay — tạo mới nếu hôm nay chưa có |
| GET | `/daily-quotes?month=YYYY-MM` | Lịch sử trong tháng, mới nhất trước |
| DELETE | `/daily-quotes/{id}` | Xoá dòng (dùng để đổi câu của hôm nay) |

**Response `/daily-quotes/today`**
```json
{
  "id": "uuid",
  "quote_date": "2026-10-05",
  "quote_id": "uuid",
  "self_message_id": "uuid",
  "created_at": "2026-10-05T02:16:00Z",
  "quote": { "id": "uuid", "text": "...", "author": "..." },
  "self_message": { "id": "uuid", "content": "..." }
}
```

`quote` và `self_message` có thể `null`: tài khoản mới chưa có lời nhắn, hoặc câu đã bị xoá khỏi kho.

## 9. Reflections — `/reflections`

| Method | Path | Mô tả |
|---|---|---|
| GET | `/reflections?entry_id=` | Danh sách phản tư |
| POST | `/reflections` | Lưu suy nghĩ về 2 câu |
| PUT | `/reflections/{id}` | Sửa |
| DELETE | `/reflections/{id}` | Xóa |

```json
// POST body
{ "entry_id": "uuid", "quote_id": "uuid", "self_message_id": "uuid", "thought": "Mình thấy 2 câu này như..." }
```

## 10. Stats (lưới tháng) — `/stats`

| Method | Path | Mô tả |
|---|---|---|
| GET | `/stats/mood-grid?month=2026-04` | Màu ô theo cảm xúc từng ngày |
| GET | `/stats/weather-grid?month=2026-04` | Màu ô theo thời tiết từng ngày |
| GET | `/stats/summary?month=2026-04` | Thống kê tổng hợp (số ngày, mood phổ biến...) |

```json
// GET /stats/mood-grid?month=2026-04
[
  { "date": "2026-04-01", "code": "happy", "label": "Vui", "color": "#FFD93D" },
  { "date": "2026-04-02", "code": "sad",   "label": "Buồn", "color": "#4A90D9" }
]
```

## 11. Notes — `/notes`

| Method | Path | Mô tả |
|---|---|---|
| GET | `/notes` | Danh sách ghi chú |
| POST | `/notes` | Tạo ghi chú |
| PUT | `/notes/{id}` | Sửa |
| PATCH | `/notes/{id}/pin` | Ghim/bỏ ghim |
| DELETE | `/notes/{id}` | Xóa |

## 12. Todos — `/todos`

| Method | Path | Mô tả |
|---|---|---|
| GET | `/todos?week=2026-W15` | Danh sách theo tuần |
| POST | `/todos` | Tạo |
| PUT | `/todos/{id}` | Sửa |
| PATCH | `/todos/{id}/done` | Đánh dấu hoàn thành |
| DELETE | `/todos/{id}` | Xóa |

## 13. Events — `/events`

| Method | Path | Mô tả |
|---|---|---|
| GET | `/events?from=&to=` | Sự kiện trong khoảng |
| POST | `/events` | Tạo sự kiện đặc biệt |
| PUT | `/events/{id}` | Sửa |
| DELETE | `/events/{id}` | Xóa |

## 14. Schedule items — `/schedule-items`

| Method | Path | Mô tả |
|---|---|---|
| GET | `/schedule-items?from=&to=` | Lịch biểu |
| POST | `/schedule-items` | Tạo |
| PUT | `/schedule-items/{id}` | Sửa |
| DELETE | `/schedule-items/{id}` | Xóa |

## 15. Health logs — `/health-logs`

| Method | Path | Mô tả |
|---|---|---|
| GET | `/health-logs?from=&to=` | Dữ liệu sức khỏe |
| POST | `/health-logs` | Ghi nhận (steps, workout_minutes, ...) |
| PUT | `/health-logs/{id}` | Sửa |
| DELETE | `/health-logs/{id}` | Xóa |

```json
// POST body
{ "log_date": "2026-04-04", "steps": 8200, "workout_minutes": 45, "note": "Chạy bộ buổi sáng" }
```

## 16. Health check

| Method | Path | Mô tả |
|---|---|---|
| GET | `/health` | `{ "status": "ok" }` |

---

## 17. Admin — `/admin` (quản trị)

> Yêu cầu token của tài khoản có `role = "admin"` (tạo bằng `python -m app.seed.admin`).
> Tài khoản thường gọi các endpoint này sẽ nhận `403`.

| Method | Path | Mô tả |
|---|---|---|
| GET | `/admin/stats` | Tổng quan: users, quotes, entries |
| GET | `/admin/quotes` | Danh sách câu hệ thống (`user_id IS NULL`) |
| POST | `/admin/quotes` | Thêm câu vào kho chung |
| PUT | `/admin/quotes/{id}` | Sửa câu hệ thống |
| DELETE | `/admin/quotes/{id}` | Xoá mềm câu hệ thống |
| GET | `/admin/users` | Danh sách users (+ số câu, số entry) |
| PATCH | `/admin/users/{id}` | Đổi `role`, khoá/mở tài khoản |

```json
// PATCH /admin/users/{id}  — nâng quyền hoặc khoá tài khoản
{ "role": "admin", "is_active": false }
```

> Admin không thể tự vô hiệu hóa chính mình (`400`).

---

## 18. Focus Garden — `/focus` & `/garden` (CHƯA TRIỂN KHAI)

> **Đặc tả, chưa có endpoint nào trong backend hiện tại.** Sẽ triển khai ở [Phase 8–11](../PLAN.md).
> Thiết kế đầy đủ: [09-focus-garden.md](09-focus-garden.md).

### 18.1. Tập trung — `/focus`

| Method | Path | Mô tả |
|---|---|---|
| POST | `/focus/sessions` | Mở phiên tập trung |
| GET | `/focus/sessions/active` | Phiên đang chạy (khôi phục khi app bị tắt) |
| POST | `/focus/sessions/{id}/heartbeat` | Ping giữ phiên (mỗi 30s) |
| POST | `/focus/sessions/{id}/pause` | Tạm dừng |
| POST | `/focus/sessions/{id}/resume` | Tiếp tục |
| POST | `/focus/sessions/{id}/complete` | Hoàn thành → chạy chống gian lân + tính thưởng |
| POST | `/focus/sessions/{id}/cancel` | Hủy phiên (0 coin) |
| GET | `/focus/sessions?from=&to=` | Lịch sử phiên |

```json
// POST /focus/sessions
{ "planned_minutes": 25 }
// Response 201
{ "id": "uuid", "status": "running", "started_at": "2026-10-05T21:00:00+00:00",
  "heartbeat_interval_seconds": 30 }
```

```json
// POST /focus/sessions/{id}/heartbeat
{ "client_elapsed_seconds": 600 }
// Response 200
{ "status": "running", "elapsed_seconds": 602, "stall_count": 0 }
```

```json
// POST /focus/sessions/{id}/complete
{ "client_elapsed_seconds": 1500 }
// Response 200 — kết quả settlement
{
  "status": "completed",
  "elapsed_seconds": 1500,
  "credited_minutes": 25,
  "coins_earned": 5,
  "exp_earned": 25,
  "capped": false,
  "flags": []
}
```

`status` trả về: `completed` (thưởng đủ) · `capped` (đã chạm trần 480 phút/ngày) · `rejected` (gian lân hoặc phiên quá ngắn).

### 18.2. Khu vườn — `/garden`

| Method | Path | Mô tả |
|---|---|---|
| GET | `/garden/profile` | Ví: coin, exp, level, streak |
| GET | `/garden/plots` | Danh sách cây |
| POST | `/garden/plots` | Gieo hạt |
| POST | `/garden/plots/{id}/water` | Dùng 1 nước |
| POST | `/garden/plots/{id}/fertilize` | Dùng 1 phân bón |
| POST | `/garden/plots/{id}/harvest` | Thu hoạch (chỉ khi `bloom`) |
| GET | `/garden/shop` | Danh mục vật phẩm |
| GET | `/garden/inventory` | Vật phẩm đang sở hữu |
| POST | `/garden/purchase` | Mua vật phẩm |
| GET | `/garden/leaderboard?period=day\|week\|all` | Bảng xếp hạng |
| GET | `/garden/challenges` | Sự kiện + tiến độ của tôi |
| POST | `/garden/challenges/{id}/claim` | Nhận thưởng sự kiện |

```json
// POST /garden/purchase
{ "item_code": "water", "quantity": 2 }
```

### 18.3. Admin tạo sự kiện — `/admin/garden`

| Method | Path | Mô tả |
|---|---|---|
| GET/POST | `/admin/garden/challenges` | Danh sách / tạo sự kiện |
| PUT/DELETE | `/admin/garden/challenges/{id}` | Sửa / xoá sự kiện |

```json
// POST /admin/garden/challenges
{ "title": "Học 600 phút trong tháng", "metric": "study_minutes",
  "target": 600, "reward_coins": 50, "reward_exp": 100,
  "starts_at": "2026-10-01T00:00:00+07:00",
  "ends_at": "2026-10-31T23:59:59+07:00" }
```

---

## 19. Calendar — `/calendar` (CHƯA TRIỂN KHAI)

> **Đặc tả, chưa có endpoint.** Xem [10-calendar.md](10-calendar.md). Sẽ thay bằng `events` + `schedule_items` hiện tại.

| Method | Path | Mô tả |
|---|---|---|
| GET | `/calendar?view=day\|week\|month&date=` | Lịch trong khoảng của chế độ đã chọn |
| GET | `/calendar/{id}` | Chi tiết 1 sự kiện |
| POST | `/calendar` | Tạo |
| PUT | `/calendar/{id}` | Sửa |
| DELETE | `/calendar/{id}` | Xóa |
| PATCH | `/calendar/{id}/status` | `{ "status": "done" }` |
| GET | `/calendar/upcoming` | Sắp tới / đang diễn ra (kèm `remind_at`) |
| GET | `/calendar/stats?month=` | Phút đã lên lịch vs thực tế học |

## 20. Weather — `/weather` (CHƯA TRIỂN KHAI)

> **Đặc tả, chưa có endpoint.** Xem [11-weather-forecast.md](11-weather-forecast.md). Gọi qua backend, không gọi thẳng.

| Method | Path | Mô tả |
|---|---|---|
| GET | `/weather/current?lat=&lon=` | Thời tiết hiện tại + dự báo 7 ngày |
| GET | `/weather/daily?date=` | Thời tiết một ngày (ưu tiên snapshot) |
| GET | `/weather/history?from=&to=` | Lịch sử từ snapshot, không gọi mạng |
| PUT | `/weather/location` | Lưu vị trí của user |
