# 05 — Design System

## 1. Định hướng visual

- Cảm giác: riêng tư, nhẹ nhàng, ấm áp, khuyến khích viết mỗi ngày.
- Nền tảng: Material 3, bo góc mềm, độ tương phản đạt WCAG AA.
- Font: Inter cho Figma; Flutter có thể map sang font tương đương đã được
  bundle hoặc hệ thống.

## 2. Color tokens

| Token | Light | Dùng cho |
|---|---|---|
| `primary` | `#4F6F8F` | CTA, link, selected |
| `primary-container` | `#D8E7F5` | card nổi bật |
| `surface` | `#FAFBFC` | nền chính |
| `surface-container` | `#FFFFFF` | card |
| `text-primary` | `#1B2430` | nội dung |
| `text-secondary` | `#5E6875` | mô tả |
| `error` | `#BA1A1A` | lỗi/xóa |
| `success` | `#39734A` | lưu thành công |

Mood và weather dùng đúng bảng màu nghiệp vụ trong [07-ui-design.md](../07-ui-design.md).
Mỗi màu phải đi kèm icon hoặc label.

## 3. Typography

| Style | Size / line height | Dùng cho |
|---|---:|---|
| Display | 32 / 40 | tiêu đề auth, hero |
| H1 | 28 / 36 | tiêu đề trang |
| H2 | 22 / 28 | section |
| Title | 18 / 24 | card/header |
| Body | 16 / 24 | nội dung nhập |
| Label | 13 / 18 | metadata, legend |
| Caption | 12 / 16 | helper/error phụ |

## 4. Spacing và shape

- Base spacing: 4 px; dùng các nấc 4, 8, 12, 16, 24, 32.
- Card radius: 16 px; input/button radius: 12 px; chip: 999 px.
- Touch target tối thiểu 44×44 px.
- Web content padding 32 px; mobile padding 16 px.

## 5. Components cần tạo trong Figma

`Button`, `IconButton`, `TextField`, `DatePicker`, `AppBar`, `Sidebar`,
`BottomNavigation`, `SectionCard`, `MoodWeatherPicker`, `QuoteCard`,
`ReflectionField`, `MonthGridCell`, `Legend`, `TodoRow`, `EventRow`,
`HealthMetricCard`, `Chart`, `EmptyState`, `ErrorState`, `ConfirmDialog`,
`Snackbar`, `BottomSheet`.

Mỗi component cần variant: default, hover, pressed, focused, disabled, loading
nếu phù hợp.

## 6. Responsive breakpoints

| Breakpoint | Layout |
|---:|---|
| 0–599 | mobile một cột, bottom navigation |
| 600–1023 | tablet, rail hoặc navigation rút gọn |
| 1024+ | web sidebar, grid nhiều cột |

