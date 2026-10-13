# CAL-01 — Lịch sự kiện

**Nền tảng:** MVP · Mobile + Web

## Màn

`flutter_app/lib/src/ui/screens/calendar_screen.dart` — màn `Lịch sử kiện` trong
nav (AppHeader), dựng theo frame `Lịch tháng · Web` (`42:26848`) và
`Tạo sự kiện · Web` (`42:27239`):

- **Chrome**: breadcrumb `← Trang chủ`, tiêu đề `Lịch sự kiện` (Lora 36) + nút
  `+ Tạo sự kiện` (phải), thanh tháng: `Tháng 10` (Lora 29) + pill `Hôm nay` +
  chevron trước/sau, ghi chú `Tháng 10, 2026 · Giờ Việt Nam (GMT+7)`.
- **Workspace 2 cột** (≥ 960 px; máy hẹp xếp dọc):
  - **Sidebar 220 px**: mini date picker (lưới 5×7, bấm ngày chuyển tháng),
    card `Lịch của tôi` (checkbox `Sự kiện` dùng được; `Lịch biểu`/`Nhật ký`
    mờ), card `Nhắc nhở` (sự kiện sắp tới đầu tiên + số lượng).
  - **Lưới tháng**: 7 cột `T2..CN`, 6 tuần; mỗi ngày là **card trắng viền
    outline** (ngày tháng trước/giữa giảm độ sáng) chứa badge ngày dạng **tròn
    24 px** (hôm nay = `primaryContainer`, đang chọn = `primary`) và tối đa 2
    dòng sự kiện `HH:mm + tên` (+N nếu nhiều).
- **Danh sách** phía dưới: `Sự kiện dd.MM` của ngày đang chọn + `Sắp tới`
  (5 sự kiện kế tiếp) — giờ, địa điểm, nhắc nhở (`· Nhắc 30 phút trước`),
  nút xoá (có xác nhận).
- **Tạo sự kiện**: dialog `_EventEditorDialog` gồm **`Nhắc nhở`**
  (`Không nhắc / Trước 10 phút / 30 phút / 1 giờ / 1 ngày`), tiêu đề, ngày,
  giờ bắt đầu/kết thúc, địa điểm, ghi chú; `Hủy` / `Lưu sự kiện`.

## Backend

- `GET /events?from=&to=` — `EventsEndpoint.list`; client `/events` truyền
  `from`/`to` (`ServerpodDataSource`).
- `POST /events` / `PUT /events/{id}` — tạo/sửa: `title`, `start_at`,
  `end_at`, `location`, `description`, `is_all_day`, **`reminder_minutes`**
  (cột `events.reminderMinutes` thêm qua migration `20261013033425716`).
- `DELETE /events/{id}` — xoá.
- Repository: `PlannerRepository.eventsBetween(from, to)` + `delete`.

Model client: `PlannerEvent` (id, title, startAt, endAt, location, description,
reminderMinutes) cùng các helper thuần `calendarCells` / `eventsOn` /
`upcomingAfter` (có unit test).

## Khác Figma (có chủ ý)

- Chưa dựng Lịch ngày (timeline 06:00–23:00) và Lịch tuần
  (`42:25691` / `42:26242`); màn hiện là lưới tháng + sidebar + danh sách.
- Chip `Lịch biểu`/`Nhật ký` trong `Lịch của tôi` chỉ là hiển thị (chưa có
  mô hình sự kiện lịch biểu trong lưới).