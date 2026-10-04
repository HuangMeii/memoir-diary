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
{ "access_token": "eyJ...", "token_type": "bearer", "expires_in": 3600 }
```

### 2.3. Thông tin user hiện tại
`GET /auth/me` → `200 { "id", "email", "username", "display_name", "is_active" }`

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

## 9. Stats (lưới tháng) — `/stats`

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

## 10. Notes — `/notes`

| Method | Path | Mô tả |
|---|---|---|
| GET | `/notes` | Danh sách ghi chú |
| POST | `/notes` | Tạo ghi chú |
| PUT | `/notes/{id}` | Sửa |
| PATCH | `/notes/{id}/pin` | Ghim/bỏ ghim |
| DELETE | `/notes/{id}` | Xóa |

## 11. Todos — `/todos`

| Method | Path | Mô tả |
|---|---|---|
| GET | `/todos?week=2026-W15` | Danh sách theo tuần |
| POST | `/todos` | Tạo |
| PUT | `/todos/{id}` | Sửa |
| PATCH | `/todos/{id}/done` | Đánh dấu hoàn thành |
| DELETE | `/todos/{id}` | Xóa |

## 12. Events — `/events`

| Method | Path | Mô tả |
|---|---|---|
| GET | `/events?from=&to=` | Sự kiện trong khoảng |
| POST | `/events` | Tạo sự kiện đặc biệt |
| PUT | `/events/{id}` | Sửa |
| DELETE | `/events/{id}` | Xóa |

## 13. Schedule items — `/schedule-items`

| Method | Path | Mô tả |
|---|---|---|
| GET | `/schedule-items?from=&to=` | Lịch biểu |
| POST | `/schedule-items` | Tạo |
| PUT | `/schedule-items/{id}` | Sửa |
| DELETE | `/schedule-items/{id}` | Xóa |

## 14. Health logs — `/health-logs`

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

## 15. Health check

| Method | Path | Mô tả |
|---|---|---|
| GET | `/health` | `{ "status": "ok" }` |

