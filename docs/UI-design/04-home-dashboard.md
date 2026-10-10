# HOME-01 — Tổng quan hôm nay

**Nền tảng:** MVP · Mobile + Web

## Bố cục

1. AppBar: Memoir, ngày hiện tại, profile/logout.
2. Lời chào và ngày.
3. Card chọn nhanh thời tiết và cảm xúc.
4. Card câu nói hôm nay.
5. CTA “Viết nhật ký hôm nay”.
6. Grid shortcut: Lưới tháng, Ghi chú, Kế hoạch, Sức khỏe, Lịch sử câu nói.

## Hành vi

- Chọn mood/weather lưu ngay và hiển thị snackbar.
- Pull-to-refresh trên mobile; nút refresh trên web.
- CTA mở `JOURNAL-02`.

## States

Loading skeleton, ngày chưa ghi, đã có mood/weather, quote lỗi, offline.

## Responsive

Mobile một cột; web chia content thành cột chính và cột phụ, shortcut dùng
grid 2×N.

