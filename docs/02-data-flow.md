# 02 — Luồng hoạt động (Data Flow)

Tài liệu mô tả các luồng nghiệp vụ chính của Memoir.

---

## 1. Luồng xác thực (Đăng ký / Đăng nhập)

```mermaid
sequenceDiagram
    participant U as Người dùng (Flutter)
    participant A as FastAPI /auth
    participant DB as PostgreSQL

    U->>A: POST /auth/register {email, username, password}
    A->>A: hash password (bcrypt)
    A->>DB: INSERT users
    DB-->>A: user_id
    A-->>U: {access_token, token_type}

    U->>A: POST /auth/login (OAuth2 password flow)
    A->>DB: SELECT users WHERE email
    A->>A: verify password
    A-->>U: {access_token}
    U->>U: lưu token (flutter_secure_storage)

    U->>A: GET /auth/me (Bearer token)
    A->>A: decode & verify JWT
    A->>DB: SELECT user by id
    A-->>U: {user profile}
```

**Ghi chú**
- Mọi request tài nguyên phải kèm `Authorization: Bearer <token>`.
- Token hết hạn → client chuyển về màn Login.
- Dữ liệu luôn lọc theo `user_id` lấy từ token.

---

## 2. Luồng viết & lưu nhật ký

```mermaid
sequenceDiagram
    participant U as Người dùng (Flutter)
    participant A as FastAPI /entries
    participant DB as PostgreSQL

    U->>U: Chọn ngày, thời tiết (icon), cảm xúc (icon)
    U->>U: Điền text: nhật ký, góc nhìn khác, nhắn nhủ tương lai,
    note over U: tự chăm sóc, hi vọng ngày mai, biết ơn, giấc mơ
    U->>A: POST /entries (JSON) hoặc PUT /entries/{id}
    A->>A: validate (mood_id, weather_id tồn tại)
    A->>DB: UPSERT diary_entries (unique: user_id + entry_date)
    DB-->>A: entry
    A-->>U: 201/200 {entry}
```

**Quy tắc**
- Mỗi user chỉ có **1 entry / ngày** (`unique(user_id, entry_date)`).
- Lưu lần đầu = `POST`; sửa = `PUT /entries/{id}` (upsert theo ngày).

---

## 3. Luồng upload ảnh (Flutter → FastAPI → Neon Object Storage → PostgreSQL)

```mermaid
sequenceDiagram
    participant U as Người dùng (Flutter)
    participant A as FastAPI /entries/{id}/images
    participant S as Neon Object Storage
    participant DB as PostgreSQL

    U->>A: POST multipart (file + Bearer token)
    A->>A: kiểm tra quyền sở hữu entry
    A->>A: tạo object_key = entries/{entry_id}/{uuid}.{ext}
    A->>S: PutObject (path-style, SigV4)
    S-->>A: 200 OK
    A->>DB: INSERT entry_images (object_key, url, content_type, size)
    DB-->>A: image_id
    A-->>U: {image: {...}}

    note over U,A: Khi hiển thị
    U->>A: GET /images/{id}/url
    A->>A: tạo presigned GET URL (hạn ngắn)
    A-->>U: {url}
```

**Ghi chú**
- Ảnh không đi qua DB; DB chỉ lưu **metadata** (khóa đối tượng).
- Xóa ảnh: `DELETE /images/{id}` → xóa object trên storage + xóa record DB.

---

## 4. Luồng sinh "cặp câu" ngẫu nhiên + phản tư

Yêu cầu: mỗi ngày hiển thị **1 câu từ kho câu thu thập trên mạng** + **1 câu từ lời nhắn nhủ của bản thân**, sau đó người dùng viết **suy nghĩ về 2 câu đó**.

```mermaid
sequenceDiagram
    participant U as Người dùng (Flutter)
    participant A as FastAPI /random-pair
    participant DB as PostgreSQL

    U->>A: GET /random-pair?entry_id=...
    A->>DB: SELECT random quote (is_active = true)
    A->>DB: SELECT random self_message (của user)
    A-->>U: {quote, self_message}
    U->>U: Hiển thị 2 câu
    U->>A: POST /reflections {entry_id, quote_id, self_message_id, thought}
    A->>DB: INSERT reflections
    A-->>U: 201 {reflection}
```

**Quy tắc chọn**
- Câu kho: ưu tiên chưa xuất hiện gần đây trong `reflections` của user (tránh lặp).
- Lời nhắn nhủ bản thân: lấy ngẫu nhiên từ `self_messages` của user; nếu trống thì tạo gợi ý từ `future_message` của các entry cũ.

---

## 5. Luồng dựng lưới tháng (mood grid & weather grid)

```mermaid
sequenceDiagram
    participant U as Người dùng (Flutter)
    participant A as FastAPI /stats
    participant DB as PostgreSQL

    U->>A: GET /stats/mood-grid?month=2026-04
    A->>DB: SELECT entry_date, mood_id FROM diary_entries WHERE user_id AND month
    A->>A: map mood_id -> color_hex
    A-->>U: [{date, code, color}]
    U->>U: GridView 7 cột -> tô màu ô

    U->>A: GET /stats/weather-grid?month=2026-04
    A-->>U: [{date, code, color}]
```

**Hiển thị**: 2 bảng riêng (Mood / Weather), dạng lịch tháng 7 cột × ~6 hàng; mỗi ô là một ngày, **đổ màu theo `color_hex`** của mood/weather của ngày đó; ngày không có entry để trống/xám nhạt.

---

## 6. Luồng CRUD kho câu

```mermaid
sequenceDiagram
    participant U as Người dùng (Flutter)
    participant A as FastAPI /quotes
    participant DB as PostgreSQL

    U->>A: GET /quotes?category=&page=
    A-->>U: danh sách phân trang
    U->>A: POST /quotes {text, author, source, category}
    A->>DB: INSERT quotes
    U->>A: PUT /quotes/{id}
    A->>DB: UPDATE quotes
    U->>A: DELETE /quotes/{id}
    A->>DB: DELETE (soft: is_active=false) hoặc xóa cứng
```

**Ghi chú**
- Kho câu có thể **CRUD** đầy đủ.
- Seed sẵn **100 câu** (xem [08-quotes-seed.md](08-quotes-seed.md)).
- `is_active=false` = ẩn khỏi vòng random nhưng vẫn giữ dữ liệu.

---

## 7. Luồng ghi chú / todo / sự kiện / lịch biểu

```mermaid
sequenceDiagram
    participant U as Người dùng (Flutter)
    participant A as FastAPI
    participant DB as PostgreSQL

    U->>A: POST /notes | /todos | /events | /schedule-items
    A->>DB: INSERT (gắn user_id)
    U->>A: GET danh sách (lọc theo tuần / khoảng ngày)
    A-->>U: kết quả
    U->>A: PATCH (đổi trạng thái todo, ví dụ is_done=true)
    A->>DB: UPDATE
```

- **Mục tiêu tuần**: `todos` lọc theo `week_label` / `due_date`.
- **Sự kiện đặc biệt**: `events` (start_at, end_at, location).
- **Lịch biểu**: `schedule_items` (hỗ trợ lặp qua `recurrence_rule` — RFC5545 rút gọn).

---

## 8. Luồng theo dõi sức khỏe

```mermaid
sequenceDiagram
    participant U as Người dùng (Flutter)
    participant A as FastAPI /health-logs
    participant DB as PostgreSQL

    U->>A: POST /health-logs {log_date, steps, workout_minutes}
    A->>DB: UPSERT (unique: user_id + log_date)
    U->>A: GET /health-logs?from=&to=
    A-->>U: dữ liệu chuỗi thời gian
    U->>U: Vẽ biểu đồ (fl_chart)
```

- Mỗi ngày 1 bản ghi sức khỏe (`unique(user_id, log_date)`).
- Nguồn số bước chân: nhập tay, hoặc tích hợp HealthKit/Google Fit ở Phase sau (ngoài phạm vi hiện tại).

