# 08 — ADR: chuyển backend sang Serverpod/Dart

## Trạng thái

Đã chốt (2026-10-10).

## Bối cảnh

Backend hiện tại là FastAPI/Python (`backend/app`). Kế hoạch dài hạn của dự án là
dùng chung một ngôn ngữ Dart: Flutter client + backend nghiệp vụ Serverpod, chỉ
giữ Python cho các AI service riêng. Trước đây tài liệu `00` chốt "giữ FastAPI"
trong khi `07` đặt Serverpod làm đích — hai tài liệu mâu thuẫn và cần hợp nhất.

## Quyết định

1. Backend nghiệp vụ đích là **Serverpod/Dart**.
2. FastAPI chỉ còn là **reference implementation** để kiểm tra parity và làm
   đường rollback trong thời gian migration.
3. **Không** nhúng backend vào Flutter binary; Serverpod là process server riêng,
   giữ secret phía server.
4. Giữ Neon PostgreSQL và Object Storage; chỉ chuyển tầng truy cập.
5. Flutter giữ repository interface ổn định; chỉ thay DataSource
   (`FastApiDataSource` → SDK Serverpod) theo từng domain, có feature flag.

## Hệ quả

- Cần cài/pin Dart SDK và Serverpod CLI trong CI và máy dev.
- Cần sinh contract fixtures từ response FastAPI để làm parity test.
- Phải pin version Serverpod để protocol client/server không lệch.
- FastAPI không bị xóa cho tới khi có parity report và backup.

## Điều kiện rollback

- Bất kỳ bằng chứng cross-user access.
- Mất hoặc nhân đôi daily quote.
- Tỷ lệ login/refresh lỗi vượt baseline.
- Upload/đọc ảnh lỗi hàng loạt.
- Data mismatch chưa giải thích.

Rollback bằng feature flag về `FastApiDataSource`; không xóa dữ liệu target.

## Tham chiếu

- `00-decision-and-risks.md`
- `05-execution-phases.md`
- `07-serverpod-migration-roadmap.md`
- `06-testing-and-cutover.md`
