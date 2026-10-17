# CAL-01 — Lịch sự kiện

**Nền tảng:** MVP · Mobile + Web

## Màn

`flutter_app/lib/src/ui/screens/calendar_screen.dart` + `ui/calendar/calendar_views.dart`
— màn `Lịch sự kiện` trong nav (AppHeader), dựng theo ba frame `Lịch ngày · Web`
(`42:25691`), `Lịch tuần · Web` (`42:26242`), `Lịch tháng · Web` (`42:26848`) và
`Tạo sự kiện · Web` (`42:27239`):

- **Chrome**: breadcrumb `← Trang chủ`, tiêu đề `Lịch sự kiện` (Lora 36) + nút
  `+ Tạo sự kiện` (phải), thanh kỳ (Lora 29) + pill `Hôm nay` + chevron trước/
  sau + **`View control` `Ngày | Tuần | Tháng`** (`SegmentedTabs`), ghi chú
  `Tháng 10, 2026 · Giờ Việt Nam (GMT+7)`.
- **Tiêu đề kỳ** theo view: `Chủ nhật, 11 tháng 10` (Ngày), `5 – 11 tháng 10`
  (Tuần), `Tháng 10` (Tháng); chevron lùi/tiến một ngày, một tuần hoặc một
  tháng. Ngày đang xem là `_anchor` (mặc định hôm nay); `_load()` tải đúng cửa
  sổ mà view hiện (cộng một tuần đệm và 30 ngày tới cho danh sách `Sắp tới`).
- **Workspace 2 cột** (≥ 960 px; máy hẹp xếp dọc):
  - **Sidebar 220 px**: mini date picker (bấm ngày đặt neo), card `Lịch của tôi`
    (cả ba checkbox `Sự kiện` / `Lịch biểu` / `Nhật ký` đều bấm được; mỗi lịch
    một tông và bật/tắt được ngay, không cần tải lại), card `Nhắc nhở`.
  - **Ngày** (`CalendarDaySchedule`): header `GMT+7` + thứ (`CHỦ NHẬT`) + badge
    ngày bo góc 28 px, lane `Cả ngày` (block `Nhật ký` của ngày đó khi lịch
    `Nhật ký` đang bật, ngược lại `Không có sự kiện cả ngày`), canvas
    06:00–22:00 (17 hàng × 48 px) với sự kiện đặt theo giờ bắt đầu và độ dài;
    sự kiện trùng nhau chia đôi bề ngang qua `dayLanes`.
  - **Tuần** (`CalendarWeekGrid`): 7 cột ngày × hàng giờ 06:00–22:00, cột ngày
    đang xem được tô nền, lane `Cả ngày` hiện `—`, sự kiện là card trong ô của
    nó.
  - **Tháng**: lưới tháng như trước (7 cột `T2..CN`, 6 tuần, badge ngày).
- Card sự kiện (`CalendarEventBlock`): nền màu + vạch trái, tiêu đề và
  `07:00–07:30`; màu lấy từ `calendarEventTint`.
- **Danh sách** phía dưới: một mục cho mỗi lịch đang bật — `Sự kiện dd.MM`,
  `Lịch biểu dd.MM` (giờ, quy tắc lặp, nhắc nhở, nút xoá) và `Nhật ký dd.MM`
  (xem trước nội dung, mở `EntryEditorScreen`) — rồi `Sắp tới` (5 sự kiện kế
  tiếp) — giờ, địa điểm, nhắc nhở (`· Nhắc 30 phút trước`), nút xoá (có xác nhận).
- **Tạo sự kiện**: dialog `_EventEditorDialog` gồm **`Nhắc nhở`**
  (`Không nhắc / Trước 10 phút / 30 phút / 1 giờ / 1 ngày`), tiêu đề, ngày,
  giờ bắt đầu/kết thúc, địa điểm, ghi chú; `Hủy` / `Lưu sự kiện`.

## Backend

- `GET /events?from=&to=` — `EventsEndpoint.list`; client `/events` truyền
  `from`/`to` (`ServerpodDataSource`).
- `GET /schedule-items?from=&to=` — `SchedulesEndpoint.list`, cùng quy ước
  `from`/`to` và cùng thứ tự `start_at` như `/events`; client gọi
  `PlannerRepository.schedulesBetween(from, to)`.
- `GET /entries?from=&to=` — `EntriesEndpoint.list` (đã có sẵn tham số);
  `EntryRepository.listBetween(from, to)` map về `dayKey` cho lịch.
- `POST /events` / `PUT /events/{id}` — tạo/sửa: `title`, `start_at`,
  `end_at`, `location`, `description`, `is_all_day`, **`reminder_minutes`**
  (cột `events.reminderMinutes` thêm qua migration `20261013033425716`).
- `DELETE /events/{id}` — xoá.
- Repository: `PlannerRepository.eventsBetween(from, to)` +
  `schedulesBetween(from, to)` + `delete`.

Model client: `PlannerEvent` (id, title, startAt, endAt, location, description,
reminderMinutes), `PlannerSchedule` (id, title, startAt, endAt, recurrenceRule,
reminderMinutes) và `DiaryEntry`. Cùng các helper thuần `calendarCells` /
`eventsOn` / `upcomingAfter`. Hình học timeline nằm ở
`ui/calendar/calendar_views.dart` — `CalendarSource`, `CalendarEntry`,
`visibleEntries`, `mondayOf`, `timelineSlot`, `dayLanes` — đều có unit test
(`test/calendar_views_test.dart`, `test/calendar_sources_test.dart`).

## Khác Figma (có chủ ý)

- Ba frame (`Lịch ngày/tuần/tháng`) tô sự kiện bằng ba tông khác nhau cho
  `Cá nhân`/`Công việc`/`Sức khỏe`, nhưng frame nào cũng gán một kiểu; backend
  chưa có cột màu nên `calendarEventTint` nay tô **theo lịch**: sự kiện = tông
  brand, lịch biểu = `warning`, nhật ký = `rainChart` — ba lịch trong `Lịch của
  tôi` nhìn ra được ngay từ block.
- Lane `Cả ngày` vẫn luôn hiện placeholder cho sự kiện: `PlannerEvent` chưa đọc
  `is_all_day` của API; lane chỉ dùng cho block `Nhật ký` (trang nhật ký không
  có giờ).
- `recurrence_rule` của lịch biểu mới chỉ hiện thành nhãn (`Hằng ngày` /
  `Hằng tuần`), chưa bung các lần lặp ra lưới.
- Icon `chevron`, `arrow-left`, `leaf`… chưa được export, dùng `Icons.*` của
  Material như các màn khác.
- Canvas chỉ vẽ 06:00–22:00 như design; sự kiện hoàn toàn ngoài khung đó bị ẩn
  (`timelineSlot` trả null).