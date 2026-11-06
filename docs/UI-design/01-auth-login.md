# AUTH-01 — Đăng nhập

**Nền tảng:** MVP · Mobile + Web  
**Mục tiêu:** Đăng nhập nhanh bằng username và mật khẩu.

## Nội dung

- Logo Memoir và tagline “Nhật ký mỗi ngày, nhìn lại chính mình”.
- Input tên đăng nhập.
- Input mật khẩu, nút hiện/ẩn.
- Nút chính “Đăng nhập”.
- Link “Chưa có tài khoản? Đăng ký”.

## States

`Default`, `Loading` (disable form + spinner), `Invalid credentials`,
`Network error`, `Session expired`.

## Responsive

- Mobile: form một cột, max-width 420 px, padding 24 px.
- Web: card form max-width 420 px ở giữa, có illustration nhẹ ở cột bên trái.

## Animation (prototype web)

Bản prototype tĩnh: `prototype/login/` — serve từ root repo
(`python -m http.server 5500`) rồi mở `/prototype/login/`.

- **Kích hoạt:** focus hoặc đang gõ ở ô *Tên đăng nhập* / *Mật khẩu* → `is-writing`;
  rời cả hai ô **và** cả hai đều rỗng → trả về trạng thái tĩnh.
- **Sách lật:** trang phải xoay quanh gáy (`x = 170` trong viewBox 340×300),
  `rotateY 0 → -172°`, 620 ms, `cubic-bezier(.22,.61,.36,1)`, kèm lớp bóng mờ dần
  khi lật; trang mới (kẻ dòng + một nét mực) lộ ra bên dưới.
- **Nhánh cây gạt sang bên:** cành `translate(44px, -6px) rotate(8deg)` quanh gốc
  `(208, 208)`, 640 ms; 6 cụm lá theo sau với delay 60–260 ms.
- **Phụ trợ:** nền artwork mờ còn `0.45`, card form nhích `-8px` + shadow nhẹ.
- **Giảm chuyển động:** `prefers-reduced-motion: reduce` → 1 ms, giữ đúng trạng thái cuối.
- **Mọi bề rộng:** dưới 960 px artwork nằm phía trên form (bản Flutter vẫn ẩn illustration
  ở mobile như mục Responsive ở trên).
- **Tự chạy một lần khi mở trang** (700 ms) và có nút **Chuyển động: bật/tắt** để
  override `prefers-reduced-motion` khi review.
- Port sang Flutter: xem `prototype/login/README.md` §4.

## Prototype

Submit thành công → `HOME-01`; link đăng ký → `AUTH-02`.

