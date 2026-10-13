# 06 — Kiểm thử, rollout và rollback

> Transport: FastAPI = reference trong migration; đích cuối = Serverpod/Dart
> (xem `07-serverpod-migration-roadmap.md`).

## 1. Test matrix

### Auth

- User mới đăng ký/đăng nhập/đăng xuất.
- Session restore sau restart.
- Access hết hạn tự refresh một lần.
- Refresh thất bại đưa về login.
- User inactive bị chặn.
- Admin và user thường có quyền khác nhau.

### Data isolation

- User A không đọc/sửa/xóa row của user B.
- URL ảnh của A không dùng được cho B.
- Admin chỉ quản lý system quote theo policy đã định.

### Parity domain

- Tạo, sửa, đọc, xóa entry.
- Mood/weather grid và summary.
- Daily quote pair, reshuffle, history.
- Ảnh upload, preview, delete.
- Notes, planner, health.

### Platform

- Android emulator/device.
- Flutter Web Chrome desktop.
- Mobile viewport responsive.
- Mạng chậm, offline, retry, refresh trình duyệt.

## 2. So sánh dữ liệu

Tạo script report chỉ đọc:

- Row count theo bảng.
- Count theo user.
- Count entry theo tháng.
- Count images theo entry.
- Quote pair theo `quote_date`.
- Checksum các field không nhạy cảm.

Mọi mismatch phải có ticket hoặc decision log trước cutover.

## 3. Rollout

1. Local FastAPI runtime.
2. FastAPI staging với dữ liệu anonymized hoặc branch.
3. Internal account.
4. Canary 1–5% user.
5. 25% → 50% → 100%.

Mỗi bước cần khoảng theo dõi và tiêu chí dừng rõ ràng.

## 4. Điều kiện rollback

Rollback ngay nếu có một trong các dấu hiệu:

- Bất kỳ bằng chứng cross-user access.
- Mất hoặc nhân đôi daily quote.
- Tỷ lệ login/refresh lỗi vượt baseline.
- Upload/đọc ảnh lỗi hàng loạt.
- Data mismatch chưa giải thích.

Rollback bằng feature flag về `LegacyBackendDataSource`; không rollback bằng
cách xóa dữ liệu target.

## 5. Điều kiện hoàn tất triển khai

Chỉ coi migration hoàn tất sau khi:

- 100% user đã chạy Flutter build mới ổn định trong rollback window.
- FastAPI production có health check và logs.
- Backup cuối cùng đã xác nhận restore được.
- Đã export schema/data và image manifest.
- Đã thông báo maintenance nếu cần.
- Có kế hoạch rollback Flutter build và FastAPI deployment.
