# H5-S2 · Cập nhật tài liệu dự án

**Epic:** H5 · **Ước lượng:** 2 pts · **Phụ thuộc:** H1-S6, H3-S9, H4-S4

## Mục tiêu

Đưa mục Sức khoẻ vào tài liệu chuẩn của repo, để đặc tả cũ (brief MVP) không còn là
nguồn chân lý duy nhất và người sau không phải đọc lại `code.html`.

## Phạm vi

- **Sửa:** `docs/03-database-schema.md`, `docs/04-api-reference.md`,
  `docs/UI-design/16-health-input.md`, `docs/UI-design/17-health-trends.md`,
  `README.md`, `PLAN.md`, `docs/UI-design/README.md` (thêm liên kết tới `docs/health/`).
- **KHÔNG sửa:** `docs/01-architecture.md`, `docs/02-data-flow.md` (chỉ sửa nếu có câu
  nào đó mâu thuẫn rõ với bản dựng — ghi lại trong PR nếu phải sửa).

## Việc cần làm

- [ ] `docs/03-database-schema.md` §16 “Bảng `health_logs`”:
  - thêm 7 cột mới (H1-S1) vào bảng cột;
  - thêm ba mục: `health_water_entries`, `health_activities`, `health_profiles` (bảng cột
    + ràng buộc `UNIQUE (user_id)` trên `health_profiles`);
  - cập nhật §2 (ERD) thêm ba quan hệ `users ||--o{ …`;
  - cập nhật §19 (index) thêm `idx_health_water_user_date`, `idx_health_activity_user_date`,
    `idx_health_logs_user_date`.
- [ ] `docs/04-api-reference.md` §15 “Health logs”:
  - giữ 4 dòng cũ; thêm `GET /health/day`, `GET /health/trends`,
    `POST /health/water`, `DELETE /health/water/{id}`, `POST /health/activity`,
    `DELETE /health/activity/{id}`, `GET /health/profile`, `PUT /health/profile`;
  - thêm một ví dụ JSON cho `POST /health/water` và một cho `PUT /health/profile`;
  - ghi chú `metric ∈ steps|workout|water|sleep|weight` và `trends` luôn trả đủ số ngày.
- [ ] `docs/UI-design/16-health-input.md` (HEALTH-01) — viết lại thành **đặc tả theo bản
  dựng**: form “Nhập nhanh chỉ số hôm nay” + ba modal ghi nhận nhanh (trỏ tới
  `docs/health/README.md` §1 và các task H3-S3, H4-S2..S4); giữ mục Validation cũ nhưng
  bổ sung đơn vị/định dạng của `docs/health/00-conventions.md` §4.
- [ ] `docs/UI-design/17-health-trends.md` (HEALTH-02) — viết lại: 3 thẻ hero, khối
  “Xu hướng 30 ngày gần nhất” (metric + kỳ 7/30/90 ngày, 4 ô số, legend 3 mức),
  drawer BMI; ghi rõ trạng thái trống và nguyên tắc “không vẽ số mẫu”.
- [ ] `docs/UI-design/README.md`: thêm dòng liên kết tới `../health/README.md` (bộ task chi tiết).
- [ ] `README.md`: mục tính năng — cập nhật mô tả Sức khoẻ (nước theo lần, giấc ngủ chi tiết,
  BMI, xu hướng 30 ngày, ghi nhận nhanh).
- [ ] `PLAN.md`: cập nhật dòng “Health (bước chân, thời gian tập)” thành phạm vi mới +
  ghi chú cột mốc; thêm dòng cho mục chưa ship (Xuất báo cáo).
- [ ] Ghi rõ trong PR: **nguồn Stitch** (`ui-figma/suckhoe/*`) và những gì **chưa** ship.

## Acceptance Criteria

1. *Given* đọc `docs/03-database-schema.md`, *then* schema mô tả **khớp** `definition.sql`
   sau migration (tên bảng/cột/index).
2. *Given* đọc `docs/04-api-reference.md`, *then* có đủ 8 endpoint mới và ví dụ body đúng
   tên khoá snake_case.
3. *Then* `docs/UI-design/16-health-input.md` và `17-health-trends.md` **không** còn mô tả
   form 7 field / mô tả “metric picker” chung chung mà khớp bản dựng, và đều trỏ tới
   `docs/health/`.
4. *Then* `README.md` và `PLAN.md` mô tả mục Sức khoẻ theo bản dựng, có nêu phần chưa ship.
5. *Then* mọi liên kết markdown mới trong `docs/health/` và `docs/UI-design/` trỏ tới file
   **có thật** (kiểm bằng lệnh ở mục Kiểm chứng).

## Kiểm chứng

```powershell
# liệt kê link nội bộ trong docs/health và kiểm tra file đích tồn tại
Get-ChildItem 'docs\health\*.md' | Select-String -Pattern '\]\(([^)]+\.md)\)' -AllMatches |
  ForEach-Object { $_.Matches } | ForEach-Object { $_.Groups[1].Value } | Sort-Object -Unique
Get-ChildItem 'docs\health' | Select-Object Name
# đối chiếu schema với migration vừa sinh
Select-String -Path 'memoir_server\memoir_server_server\migrations\*\definition.sql' -Pattern 'health_water_entries|health_activities|health_profiles'
```

## Rủi ro / ghi chú

- `docs/03` và `docs/04` còn nhắc FastAPI/`/health-logs` ở các mục lịch sử — **đừng** viết
  lại toàn bộ file; chỉ thêm/sửa mục health để diff nhỏ, dễ review.
- Brief 16/17 thuộc bộ “Figma Screen Briefs”: giữ tiêu đề `HEALTH-01`/`HEALTH-02` để không
  phá liên kết từ `docs/UI-design/README.md`.
- Nếu phát hiện tài liệu nào mâu thuẫn với bản dựng (ví dụ `docs/02-data-flow.md` nói
  “mỗi ngày 1 bản ghi sức khỏe” — nay vẫn đúng cho `health_logs`, nhưng nước có bảng con),
  ghi chú lại trong chính file đó bằng một dòng “xem thêm” thay vì viết lại.
