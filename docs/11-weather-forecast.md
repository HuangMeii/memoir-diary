# 11 — Dự báo thời tiết (Open-Meteo)

> **Trạng thái: ĐẶC TẢ — CHƯA TRIỂN KHAI.**
> Mã nguồn hiện tại **không có** bất kỳ lời gọi API thời tiết nào. Bảng `weathers` chỉ là **bảng tra cứu 5 giá trị cố định** (nắng / râm / mưa / bão / khác) dùng để tô màu lưới tháng — chưa phải dữ liệu thời tiết thật.
> Sẽ triển khai ở [Phase 19–20](../PLAN.md).

---

## 1. Vì sao chọn Open-Meteo

Đã **kiểm tra kết nối thành công** từ máy này:

```
GET https://api.open-meteo.com/v1/forecast?latitude=21.0285&longitude=105.8542
    &current=temperature_2m,weather_code
    &daily=weather_code,temperature_2m_max,temperature_2m_min
    &timezone=auto&forecast_days=3
→ HTTP 200
```

| Tiêu chí | Open-Meteo |
|---|---|
| API key | **Không cần** — không phải đăng ký, không phải trả phí |
| Phí | Miễn phí cho mục đích phi thương mại |
| Dữ liệu | Nhiệt độ hiện tại, dự báo theo ngày, mã thời tiết WMO |
| Độ phức tạp | Endpoint REST, trả JSON |

Lựa chọn phù hợp nhất cho dự án cá nhân: **không có bí mật nào phải giữ**, không có chi phí phát sinh.

---

## 2. Kiến trúc: backend làm trung gian

```
Flutter  ──>  FastAPI /weather/*  ──>  Open-Meteo
```

**Không cho Flutter gọi thẳng Open-Meteo.** Lý do:

1. **Chỗ duy nhất** để ánh xạ mã WMO → 5 nhóm thời tiết sẵn có; đổi cơ chế sau này chỉ sửa một chỗ.
2. **Cache**: nhiều lần mở app không nên gọi lên Open-Meteo mỗi lượt.
3. **Lịch sử**: lưu snapshot theo ngày để nhật ký cũ vẫn hiện được thời tiết hôm đó.

---

## 3. Ánh xạ mã WMO → 5 nhóm hiện có

Open-Meteo trả `weather_code` theo chuẩn WMO. Bảng `weathers` hiện có sẵn 5 mã: `sunny, cloudy, rainy, storm, other`.

| Mã WMO | Nghĩa | → `weathers.code` |
|---|---|---|
| 0, 1 | Trời quang, gần như quang | `sunny` |
| 2, 3 | Có mây, u ám | `cloudy` |
| 45, 48 | Sương mù | `cloudy` |
| 51–57, 61–67, 80–82 | Mưa nhẹ / vừa / mưa rào | `rainy` |
| 71–77, 85, 86 | Tuyết | `other` |
| 95, 96, 99 | Bão, giông | `storm` |

Cột `weather_id` trong `diary_entries` giữ nguyên trỏ tới `weathers` — chỉ có **cách chọn mã** thay đổi, không phải schema.

---

## 4. Thiết kế dữ liệu

### 4.1. Thêm cột vào `users`

| Cột | Kiểu | Mô tả |
|---|---|---|
| `weather_lat` | float | Vĩ độ (mặc định Hà Nội) |
| `weather_lon` | float | Kinh độ (mặc định Hà Nội) |
| `weather_location_name` | varchar(100) | Tên hiển thị, ví dụ "Hà Nội" |

Mặc định `21.0285, 105.8542`; người dùng đổi được trong màn hình cài đặt.

### 4.2. Bảng mới `weather_snapshots`

Lưu kết quả dự báo theo ngày để có **lịch sử** và giảm gọi lại.

| Cột | Kiểu | Ràng buộc | Mô tả |
|---|---|---|---|
| id | uuid | PK | |
| user_id | uuid | FK→users(id) CASCADE, indexed | |
| forecast_date | date | NOT NULL | Ngày dự báo |
| weather_code | smallint | NOT NULL | Mã WMO gốc |
| weather_id | smallint | FK→weathers(id) | Nhóm đã ánh xạ |
| temp_min | float | NULL | °C |
| temp_max | float | NULL | °C |
| temp_avg | float | NULL | °C |
| precipitation_mm | float | NULL | Lượng mưa |
| fetched_at | timestamptz | NOT NULL | Lúc lấy từ Open-Meteo |

**Ràng buộc**: `UNIQUE (user_id, forecast_date)`.

> Cần **cả hai** cột: `weather_code` (WMO, 0–99) và `weather_id` (tra cứu nội bộ). Nếu chỉ lưu `weather_id` thì mất thông tin gốc khi cần hiển thị chi tiết hoặc đổi cách ánh xạ về sau.
---

## 5. API dự kiến

| Method | Path | Mô tả |
|---|---|---|
| GET | `/weather/current?lat=&lon=` | Thời tiết hiện tại + dự báo 7 ngày |
| GET | `/weather/daily?date=` | Thời tiết một ngày (ưu tiên snapshot đã lưu) |
| GET | `/weather/history?from=&to=` | Lịch sử từ snapshot, **không** gọi API ngoài |
| PUT | `/weather/location` | Lưu vị trí của user |

```json
// GET /weather/current
{
  "location_name": "Hà Nội",
  "timezone": "Asia/Ho_Chi_Minh",
  "current": {
    "time": "2026-10-05T18:15",
    "temperature": 24.4,
    "weather_code": 0,
    "condition": "Trời quang",
    "icon": "☀️"
  },
  "daily": [
    {
      "date": "2026-10-05",
      "weather_code": 80,
      "condition": "Mưa rào",
      "icon": "🌧️",
      "weather_id": 3,
      "temp_min": 22.3,
      "temp_max": 25.9
    }
  ],
  "source": "open-meteo"
}
```

### 5.1. Cache 2 tầng

| Tầng | Cơ chế | Mục đích |
|---|---|---|
| **Trong bộ nhớ** | TTL 30 phút theo tọa độ | Mở app nhiều lần trong ngày không gọi lại |
| **Trong DB** | `weather_snapshots` | Lịch sử + xem offline + nhật ký cũ |

Luồn `GET /weather/current`: đọc cache → hết hạn thì gọi Open-Meteo → ghi cache → ghi snapshot cho các ngày chưa có.

---

## 6. Xử lý khi API lỗi

Quan trọng: **lỗi mạng không được làm hỏng app nhật ký.**

| Tình huống | Xử lý |
|---|---|
| Open-Meteo chậm (>5s) | Timeout → trả **snapshot cũ nhất** trong DB; không có thì `503` |
| Open-Meteo lỗi / mất mạng | Trả snapshot đã lưu, kèm `source: "cache"` để UI ghi "dữ liệu cũ" |
| Chưa có dữ liệu nào | `503` kèm thông báo tiếng Việt; UI ẩn khối thời tiết |

Bao bọc bằng `try/except` và đặt timeout cứng (`httpx.Timeout(5.0)`). Hai endpoint `/weather/daily` và `/weather/history` chỉ đọc DB nên **không bao giờ** phụ thuộc mạng.

---

## 7. Cấu hình

```env
# Open-Meteo — miễn phí, KHÔNG cần key.
WEATHER_API_URL=https://api.open-meteo.com/v1/forecast
WEATHER_API_ENABLED=true
WEATHER_CACHE_TTL_MINUTES=30
WEATHER_TIMEOUT_SECONDS=5
WEATHER_DEFAULT_LAT=21.0285
WEATHER_DEFAULT_LON=105.8542
```

Cần thêm `httpx` vào `requirements.txt` (hiện chỉ nằm trong `requirements-dev.txt`).

---

## 8. Màn hình Flutter

| Màn hình | Nội dung |
|---|---|
| `weather_card.dart` | Nhiệt độ hôm nay + 5 ngày tới, icon + nhiệt min/max |
| `weather_settings_screen.dart` | Đổi vị trí (nhập tên → geocode, hoặc nhập tọa độ) |
| — Tích hợp | Thêm nút **"Dùng thời tiết hôm nay"** cạnh ô chọn thời tiết ở entry editor |

State: `weatherProvider` (Riverpod `AsyncNotifier`); lỗi → hiện giá trị cache kèm nhãn "cập nhật lúc HH:mm".

---

## 9. Giả định

1. **Không có API key** → không có bí mật, không có chi phí.
2. Vị trí lấy từ **cài đặt của user**, không tự định vị GPS (đơn giản hơn, và web cần quyền riêng tư).
3. Vị trí mặc định là **Hà Nội**; user đổi được.
4. Múi giờ: `timezone=auto` để Open-Meteo tự suy ra; hiển thị theo múi giờ máy.
5. Chỉ dùng cho **hiển thị và gợi ý** — app không tự ghi thời tiết vào nhật ký, user vẫn tự chọn.

## 10. Chia phase

| Phase | Nội dung |
|---|---|
| 19 | Backend: `httpx` + `weather_service` + cache 2 tầng + bảng `weather_snapshots` + router `/weather` |
| 20 | Flutter: `weather_card` + màn hình đổi vị trí + nút "dùng thời tiết hôm nay" ở entry editor |

---

[← Quay lại danh mục tài liệu](../README.md#5-tài-liệu)