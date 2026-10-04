# 05 — Đặc tả tính năng (Features)

Tài liệu map từng yêu cầu nghiệp vụ → hành vi → màn hình/widget trong Flutter.

---

## 1. Viết nhật ký (Write diary)

- **Mô tả**: Người dùng tạo/sửa nhật ký của một ngày, kèm ảnh.
- **Dữ liệu**: `diary_entries.diary_text` + `entry_images`.
- **UI**: `features/diary/entry_editor_screen.dart` — form gồm chọn ngày, các khối con (mục 2–6, 8–11), vùng upload ảnh.
- **Quy tắc**: 1 entry/ngày; lưu tự động (autosave) khi rời màn hình.

## 2. Chọn thời tiết hôm nay (icon)

- **5 trạng thái**: `nắng ☀️ #FFB300`, `râm ⛅ #90A4AE`, `mưa 🌧️ #5C9EDB`, `bão ⛈️ #37474F`, `khác ❔ #78909C`.
- **UI**: `features/mood_weather/weather_picker.dart` — hàng 5 nút icon; click chọn → highlight; chỉ chọn 1.
- **Lưu**: `diary_entries.weather_id`.

## 3. Chọn cảm xúc hiện tại (icon)

- **5 trạng thái**: `vui 😀 #FFD93D`, `buồn 😢 #4A90D9`, `chán 😑 #9E9E9E`, `bình thường 😐 #A8D5BA`, `giận 😠 #E74C3C`.
- **UI**: `features/mood_weather/mood_picker.dart` — hàng 5 nút icon; chọn 1.
- **Lưu**: `diary_entries.mood_id`.

## 4. Hai lưới tháng đổ màu (Mood grid & Weather grid)

- **Mô tả**: 2 bảng dạng lịch tháng; mỗi ô = 1 ngày; **ô được tô màu** theo cảm xúc/thời tiết của ngày đó.
- **UI**: `features/mood_weather/month_grid.dart` — `GridView` 7 cột; mỗi ô `Container(color: entryColor)`; ngày không có dữ liệu → xám nhạt `#EEEEEE`.
- **Dữ liệu**: `GET /stats/mood-grid?month=` và `/stats/weather-grid?month=`.
- **Tương tác**: chọn tháng trước/sau; tap ô → mở entry của ngày đó.
- **Chú giải (legend)**: hiển thị bảng màu tương ứng mood/weather.

## 5. Câu quan điểm từ góc nhìn khác

- **Mô tả**: Người dùng viết **1 câu** thể hiện quan điểm từ góc nhìn của người khác.
- **UI**: text field 1 dòng trong editor.
- **Lưu**: `diary_entries.other_perspective`.

## 6. Câu nhắn nhủ tương lai (hoặc câu hỏi)

- **Mô tả**: Viết **1 câu** gửi tới bản thân tương lai, hoặc 1 câu hỏi.
- **UI**: text field trong editor.
- **Lưu**: `diary_entries.future_message`.
- **Liên kết**: câu này có thể được dùng làm nguồn cho `self_messages`.

## 7. Kho câu + Câu ngẫu nhiên + Phản tư

- **Kho câu**: 100 câu động viên/giáo dục thu thập từ mạng xã hội (xem [08-quotes-seed.md](08-quotes-seed.md)); **CRUD được** (`features/quotes/quote_manager_screen.dart`).
- **Hiển thị hằng ngày**: `GET /daily-quotes/today` trả **1 câu từ kho** + **1 câu từ lời nhắn nhủ của bản thân**.
- **Lưu theo ngày**: cặp câu được ghi vào `daily_quotes` (1 dòng / ngày / user) nên mở app nhiều lần trong ngày vẫn thấy cùng câu. Nút 🔄 xoá dòng hôm nay để quay câu khác.
- **Lịch sử**: màn hình "Lịch sử câu nói" xem lại theo tháng, gồm cả `quote_id` để tra ngược câu gốc.
- **Phản tư**: ô "Suy nghĩ như thế nào về 2 câu trên?" → lưu `reflections.thought`.
- **UI**: `QuotePairCard` trong `home_screen.dart` + `quote_history_screen.dart`.

## 8. Hôm nay bạn đã tự chăm sóc mình như thế nào?

- **UI**: text field trong editor.
- **Lưu**: `diary_entries.self_care`.

## 9. Bạn hi vọng điều gì vào ngày mai?

- **UI**: text field trong editor.
- **Lưu**: `diary_entries.tomorrow_hope`.

## 10. Bày tỏ lòng biết ơn

- **UI**: text field trong editor (có thể hỗ trợ nhiều dòng).
- **Lưu**: `diary_entries.gratitude`.

## 11. Giấc mơ đã trải qua

- **UI**: text field trong editor.
- **Lưu**: `diary_entries.dream`.

## 12. Ghi chú (Ghi chú nhanh)

- **Mô tả**: Ghi chú nhanh các nội dung cần nhớ.
- **UI**: `features/notes/notes_screen.dart` — danh sách + nút thêm nhanh; hỗ trợ ghim.
- **Lưu**: `notes`.

## 13. Todo list

- **Mục tiêu đề ra trong tuần**: `todos` với `week_label`, lọc theo tuần.
  - UI: `features/todo/todo_screen.dart` (tab "Tuần này").
- **Ghi chú sự kiện đặc biệt**: `events` với `start_at/end_at/location`.
  - UI: `features/events/events_screen.dart`.
- **Lịch biểu**: `schedule_items` (hỗ trợ lặp).
  - UI: `features/schedule/schedule_screen.dart` (chế độ ngày/tuần).

## 14. Theo dõi sức khỏe

- **Mô tả**: đếm số bước chân, thời gian tập luyện.
- **UI**: `features/health/health_screen.dart` — form nhập nhanh theo ngày + biểu đồ xu hướng (`fl_chart`).
- **Lưu**: `health_logs` (1 bản ghi/ngày).
- **Mở rộng tương lai**: đồng bộ HealthKit/Google Fit.

---

## 15. Bảng tổng hợp yêu cầu ↔ thực thể dữ liệu

| Yêu cầu | Bảng | Cột/Trường |
|---|---|---|
| Viết nhật ký | diary_entries | diary_text |
| Thời tiết | diary_entries | weather_id → weathers |
| Cảm xúc | diary_entries | mood_id → moods |
| Lưới tháng | diary_entries | (entry_date, mood_id, weather_id) |
| Góc nhìn khác | diary_entries | other_perspective |
| Nhắn nhủ tương lai | diary_entries | future_message |
| Kho câu + random + phản tư | quotes, self_messages, reflections | text / content / thought |
| Tự chăm sóc | diary_entries | self_care |
| Hi vọng ngày mai | diary_entries | tomorrow_hope |
| Biết ơn | diary_entries | gratitude |
| Giấc mơ | diary_entries | dream |
| Ghi chú | notes | content |
| Mục tiêu tuần | todos | title, week_label, is_done |
| Sự kiện đặc biệt | events | title, start_at, end_at |
| Lịch biểu | schedule_items | title, start_at, recurrence_rule |
| Sức khỏe | health_logs | steps, workout_minutes |
