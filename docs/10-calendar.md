# 10 — Module Calendar

> **Trạng thái: ĐẶC TẢ — CHƯA TRIỂN KHAI.**
> Tài liệu này mô tả tính năng sẽ làm ở [Phase 14–18](../PLAN.md). Ở thời điểm hiện tại **chưa có** bảng, endpoint hay màn hình Calendar nào trong mã nguồn; mọi API/DB dưới đây là **thiết kế dự kiến**.

Calendar là chức năng **ngang hàng với Study Garden** (xem [09-focus-garden.md](09-focus-garden.md)): xem lịch, theo dõi thời gian và quản lý sự kiện ở mức phù hợp với app nhật ký.

---

## 1. Vấn đề cần giải quyết trước

Hiện có **hai bảng trùng chức năng**:

| Bảng | Cột đang có | Thiếu so với Calendar |
|---|---|---|
| `events` | `title, description, start_at, end_at, location, is_all_day` | **lặp lại**, **nhắc nhở**, màu, trạng thái, liên kết |
| `schedule_items` | `title, start_at, end_at, recurrence_rule, reminder_minutes` | **location**, **description**, `is_all_day`, màu, trạng thái, liên kết |

Cả hai đều là "lịch". **Đã chốt: gộp còn một bảng `events`** — đưa cột lặp lại + nhắc nhở sang `events`, migrate dữ liệu `schedule_items`, rồi bỏ bảng cũ. Một tính năng không nên có hai bảng cạnh tranh nhau.

---

## 2. Thiết kế dữ liệu

### 2.1. Bảng `events` (sau khi gộp)

| Cột | Kiểu | Ràng buộc | Mô tả |
|---|---|---|---|
| id | uuid | PK | |
| user_id | uuid | FK→users(id) CASCADE, indexed | |
| title | varchar(255) | NOT NULL | |
| description | text | NULL | |
| start_at | timestamptz | NOT NULL, indexed | Bắt đầu |
| end_at | timestamptz | NULL | NULL = chưa xác định |
| is_all_day | boolean | NOT NULL default false | Sự kiện cả ngày |
| location | varchar(255) | NULL | Địa điểm |
| color | char(7) | NULL | Màu phân loại |
| **recurrence_rule** | varchar(255) | NULL | **Mới**: `daily` / `weekly` / `monthly` |
| **recurrence_until** | date | NULL | **Mới**: lặp đến ngày nào |
| **reminder_minutes** | int | NULL | **Mới**: 5 / 15 / 30 / 60 |
| **status** | varchar(20) | NOT NULL default 'planned' | **Mới**: `planned` / `done` / `skipped` |
| **entry_id** | uuid | NULL | **Mới**: liên kết nhật ký |
| **focus_session_id** | uuid | NULL | **Mới**: liên kết phiên tập trung (Phase 8) |
| created_at | timestamptz | NOT NULL default now() | |

**Quyết định về lặp lại:** lưu **một hàng + một quy tắc**, không nhân bản hàng cho từng lần lặp. Lịch nhiều tháng có hàng trăm hàng; nhân bản sẽ phình to và khó sửa — "đổi lịch học thứ 3" phải sửa hàng chục dòng. `GET /calendar` bung các lần lặp ra khi trả về.

**Index**: `idx_events_user_start (user_id, start_at)`, `idx_events_user_status (user_id, status)`.

### 2.2. Migration

Một migration Alembic duy nhất, theo thứ tự an toàn:
1. Thêm cột mới vào `events` (nullable hoặc có default → không mất dữ liệu cũ)
2. `INSERT INTO events SELECT ... FROM schedule_items` — chỉ những cột bảng cũ có
3. `DROP TABLE schedule_items` + index liên quan

> **Phải đếm `schedule_items` trước khi xoá** và báo lại số hàng đã migrate. Chỉ xoá khi số hàng khớp, vì đây là dữ liệu người dùng thật.

---

## 3. Chức năng

| # | Chức năng | Mô tả | Ghi chú |
|---|---|---|---|
| 1 | **Xem lịch** | Chế độ ngày / tuần / tháng | Một `GET` xử lý cả 3 qua tham số `view` |
| 2 | **Timeline theo giờ** | Cột giờ 06:00 → 23:00, sự kiện nằm đúng vị trí | Vẽ bằng `CustomPainter` |
| 3 | **Tạo sự kiện** | Tiêu đề, giờ, mô tả, vị trí, màu, lặp, nhắc | Một form dùng chung |
| 4 | **Sửa sự kiện** | Đổi mọi trường | |
| 5 | **Xoá sự kiện** | | |
| 6 | **Lặp lại** | Hằng ngày / tuần / tháng, có `recurrence_until` | |
| 7 | **Nhắc nhở** | 5 / 15 / 30 / 60 phút | Xem §5 |
| 8 | **Theo dõi lịch** | 3 trạng thái: **đã qua / đang diễn ra / sắp tới** | Tính server-side theo `now()` |
| 9 | **Liên kết Study** | Mở Focus Timer từ sự kiện "học buổi sáng" | `focus_session_id`, cần Phase 8 |
| 10 | **Liên kết Journal** | "Ghi nhật ký sau sự kiện" | `entry_id` |
| 11 | **Thống kê thời gian** | Phút **đã lên lịch** vs **thực tế học** | Phút thực tế lấy từ `focus_sessions` |

---

## 4. API dự kiến

| Method | Path | Mô tả |
|---|---|---|
| GET | `/calendar?view=day\|week\|month&date=2026-10-05` | Lịch trong khoảng của chế độ đã chọn |
| GET | `/calendar/{id}` | Chi tiết 1 sự kiện |
| POST | `/calendar` | Tạo |
| PUT | `/calendar/{id}` | Sửa |
| DELETE | `/calendar/{id}` | Xoá |
| PATCH | `/calendar/{id}/status` | `{ "status": "done" }` hoặc `"skipped"` |
| GET | `/calendar/upcoming` | Sắp tới / đang diễn ra (cho nhắc nhở) |
| GET | `/calendar/stats?month=YYYY-MM` | Phút đã lên lịch vs thực tế học |
```json
// POST /calendar
{
  "title": "Học tiếng Anh",
  "start_at": "2026-10-06T08:00:00+07:00",
  "end_at": "2026-10-06T09:30:00+07:00",
  "location": "Nhà",
  "recurrence_rule": "weekly",
  "recurrence_until": "2026-12-31",
  "reminder_minutes": 15,
  "color": "#5C9EDB"
}
```

```json
// GET /calendar?view=week&date=2026-10-05
{
  "view": "week",
  "range_start": "2026-10-05T00:00:00+07:00",
  "range_end": "2026-10-12T00:00:00+07:00",
  "events": [
    {
      "id": "uuid",
      "title": "Học tiếng Anh",
      "start_at": "2026-10-06T08:00:00+07:00",
      "end_at": "2026-10-06T09:30:00+07:00",
      "status": "planned",
      "is_occurrence": true,
      "occurrence_index": 1
    }
  ]
}
```

> `is_occurrence` cho biết đây là **lần lặp được bung ra**, không phải hàng thật. Sửa/xoá một lần lặp đơn lẻ trả `409` — trong phạm vi này chỉ sửa được **cả chuỗi**.

---

## 5. Nhắc nhở — đã chốt **cả hai** kiểu

App chạy cả web lẫn mobile mà **web không có push notification của hệ đối**, nên nhắc nhở làm theo hai lớp:

| Kiểu | Cách hoạt động |
|---|---|
| **Trong lúc app đang mở** | `GET /calendar/upcoming` → `Timer` đếm ngược → hiện **banner/snackbar** khi tới giờ nhắc |
| **Khi mở app** | Lần đầu mở app, hiện danh sách "sắp tới cần chú ý" (trong 24h tới) trên Home |

Cả hai dùng chung một nguồn: `GET /calendar/upcoming` trả về sự kiện kèm **`remind_at` đã tính sẵn**. Server tính, client chỉ hiển thị — không để máy tính lại mốc giờ (tránh lệch múi giờ).

**Giới hạn đã chấp nhận:** nếu người dùng **đóng app**, không có nhắc nào chạy. Muốn nhắc cả khi app đóng thì cần service worker (web push) hoặc push native — nằm ngoài phạm vi app Flutter hiện tại.

---

## 6. Màn hình Flutter

| Màn hình | Nội dung |
|---|---|
| `calendar_screen.dart` | 3 chế độ ngày/tuần/tháng + nút thêm |
| `calendar_timeline.dart` | `CustomPainter` vẽ cột giờ, khối sự kiện đè lên |
| `calendar_month_grid.dart` | Lưới tháng, sự kiện hiện chấm nhỏ trong ô |
| `calendar_event_sheet.dart` | Form tạo/sửa (dùng chung) |
| `calendar_reminder_banner.dart` | Banner nhắc nhở trên Home |

State: `calendarProvider` (Riverpod `AsyncNotifier`) theo `view` + `date` hiện tại.

---

## 7. Giả định

1. Múi giờ: `start_at`/`end_at` lưu `timestamptz`; tuần bắt đầu **thứ Hai**; hiển thị theo múi giờ máy người dùng.
2. Sự kiện lặp được bung ra **khi đọc**, không nhân bản hàng.
3. Sửa/xoá một lần lặp đơn lẻ: `409` — chưa hỗ trợ, sửa cả chuỗi.
4. Không có múi giờ hẹn giờ cho sự kiện dài hơn 24h.
5. Lịch là **dữ liệu riêng** của tài khoản: không chia sẻ, không mời người khác.

## 8. Chia phase

| Phase | Nội dung |
|---|---|
| 14 | Migration: cột mới cho `events`, migrate `schedule_items`, bỏ bảng cũ |
| 15 | Backend `/calendar`: CRUD + bung lặp + lọc theo view + stats |
| 16 | Flutter: timeline ngày + form tạo/sửa |
| 17 | Chế độ tuần/tháng + trạng thái + nhắc nhở (cả 2 kiểu) |
| 18 | Liên kết Study + Journal + thống kê so sánh thời gian |

---

[← Quay lại danh mục tài liệu](../README.md#5-tài-liệu)