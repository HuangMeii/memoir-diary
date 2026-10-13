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

## Prototype

Submit thành công → `HOME-01`; link đăng ký → `AUTH-02`.

