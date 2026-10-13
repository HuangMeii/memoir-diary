# AUTH-03 — Khôi phục phiên

**Nền tảng:** MVP · Mobile + Web

## Mục tiêu

Hiển thị splash ngắn khi app đọc token đã lưu, tránh nhấp nháy giữa Login và
Home.

## Thành phần

Logo, progress indicator, thông báo ngắn “Đang khôi phục phiên...”.

## States

Token hợp lệ → `HOME-01`; token hết hạn → `AUTH-01` với thông báo; lỗi mạng
không được xóa dữ liệu form nếu người dùng đang ở màn hình đăng nhập.

