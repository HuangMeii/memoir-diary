# Story · Subtask · Acceptance Criteria

Batch 1 — cho 3 epic ưu tiên: **MD-9** (Tooling/CI), **MD-20** (Serverpod), **MD-22** (Quality).
Bản CSV để import: **`04-stories-batch1.noparent.csv`**. Quy ước chi tiết: `00-conventions.md`.

## Quy ước chung

- **Issue type:** Story (có Subtask). Điều tra → **Spike** (timebox 1–2 ngày, output = kết luận + quyết định).
  **Không** dùng issue type `Task` ở cấp riêng.
- **Acceptance Criteria (AC):** dạng Given/When/Then, đánh số, kiểm chứng được.
- **Estimate:** Fibonacci; Story ≤ 5 điểm; Subtask ≤ 4 giờ.
- **Definition of Done:** code + test + `analyze` sạch + PR review 1 người + docs cập nhật
  (nếu đổi API/schema) + verify web & mobile + có rollback nếu đổi hạ tầng.
- **Liên kết epic:** import bản `.noparent` rồi gắn parent bằng `jira-link-parent.ps1`;
  cột `Issue Id`/`Parent` trong CSV **không** auto-link được (xem `README.md`).
- **Subtask = just-in-time:** chỉ tạo khi Story bắt đầu làm; bắt đầu từ **MD-9-S1**
  → danh sách ở `06-subtasks-md-9-s1.csv` (Subtask bắt buộc có parent nên tạo từ trang Story).

---

## MD-9 — `[Platform] Tooling, CI/CD và bảo vệ nhánh`

### MD-9-S1 · `[CI] Lint + test cho backend (FastAPI)` · 3 pts · Highest
**AC**
1. *Given* PR mở/cập nhật vào `main` hoặc `develop`, *when* CI chạy, *then* job backend chạy `ruff` + `pytest` và kết thúc dưới 5 phút.
2. *Given* một test đỏ, *when* CI kết thúc, *then* job fail và PR bị chặn merge.
3. *Given* không có thay đổi trong `backend/`, *then* job bị skip (path filter).

**Subtasks:** tạo `.github/workflows/backend.yml` · cache pip · path filter · thử một PR đỏ để xác nhận chặn merge.

### MD-9-S2 · `[CI] dart analyze + flutter test + build web` · 5 pts · High
**AC**
1. *Given* PR có thay đổi trong `flutter_app/`, *when* CI chạy, *then* `dart analyze` sạch và `flutter test` xanh.
2. *Then* `flutter build web --release` thành công và artifact được upload.
3. *Then* job kết thúc dưới 10 phút.

**Subtasks:** workflow `flutter.yml` · setup Flutter SDK + cache · bước build · upload artifact.

### MD-9-S3 · `[CI] Serverpod: analyze + generate + test` · 3 pts · Medium
**AC**
1. *Then* `serverpod generate` chạy không lỗi (code generated không lệch).
2. *Then* `dart analyze memoir_server_server` sạch.
3. *Given* môi trường CI không có PostgreSQL, *then* `dart test` bị skip qua biến `SKIP_DB_TESTS=true` (không làm đỏ build).

**Subtasks:** workflow `memoir_server.yml` · cài Serverpod CLI 4.0.4 · cache pub · xử lý DB.

### MD-9-S4 · `[Repo] Bảo vệ nhánh main và develop` · 2 pts · High
**AC**
1. *Then* không thể push trực tiếp vào `main`/`develop`.
2. *Then* merge bắt buộc PR + 1 approve + CI xanh.
3. *Then* force-push bị chặn.

**Subtasks:** cấu hình branch protection · thêm `CODEOWNERS`.

### MD-9-S5 · `[Repo] Chuẩn hoá commit + PR` · 1 pt · Low
**AC**
1. *Then* `CONTRIBUTING.md` nêu rõ quy ước Conventional Commits.
2. *Then* PR template (đã có) có checklist bắt buộc và được điền khi mở PR.

**Subtasks:** rà `pull_request_template.md` · (tuỳ chọn) thêm commitlint.

---

## MD-20 — `[Platform] Chuyển backend sang Serverpod/Dart`

### MD-20-S1 · `[Serverpod] Tạo parity fixtures từ response FastAPI` · 5 pts · Highest
**AC**
1. *Then* mỗi domain (auth, lookups, entries, images, quotes, daily quotes, self messages, reflections, notes, todos, events, schedules, health, stats, weather) có fixture response mẫu được version hoá.
2. *Then* fixture được **sinh tự động** từ test FastAPI (không copy tay) và có script tái tạo.
3. *Then* chạy script trên máy sạch cho ra fixture giống hệt (deterministic).

**Subtasks:** viết script ghi fixture · commit fixtures · tài liệu cách tái tạo.

### MD-20-S2 · `[Serverpod] Parity test cho auth` · 5 pts · Highest
**AC**
1. *Then* `register` / `login` / `me` / `logout` trả shape + status tương đương FastAPI.
2. *Given* token sai hoặc đã bị thu hồi, *when* gọi endpoint bảo vệ, *then* bị từ chối.
3. *Given* user A đã đăng nhập, *when* đọc dữ liệu của user B, *then* không lộ dữ liệu.
4. *Then* parity test chạy trong CI.

**Subtasks:** test register/login · test token hết hạn/thu hồi · test ownership A/B · wire CI.

### MD-20-S3 · `[Serverpod] Cut over domain journal sau feature flag` · 5 pts · Highest
**AC**
1. *Given* `BACKEND=fastapi`, *when* tạo/sửa/xoá entry, *then* hành vi không đổi.
2. *Given* `BACKEND=serverpod`, *then* create/edit/by-date/delete + gallery cho kết quả tương đương fixture.
3. *Given* mở lại cờ về `fastapi`, *then* rollback trong 1 bước, không cần migration ngược.

**Subtasks:** bật cờ cho màn journal · chạy parity · smoke web + mobile · cập nhật docs.
**Depends on:** MD-20-S1, MD-20-S2.

### MD-20-S4 · `[Serverpod] Cut over planner + notes + health` · 5 pts · High
**AC:** tương tự S3 cho `notes`, `todos`, `events`, `schedule-items`, `health-logs`; không đổi UI; rollback 1 bước.
**Subtasks:** bật cờ theo domain · parity từng domain · smoke · cập nhật docs.

### MD-20-S5 · `[Serverpod] Cut over quotes + stats` · 5 pts · High
**AC**
1. Tương tự S3 cho `quotes`, `daily-quotes`, `self-messages`, `reflections`, `stats`.
2. *Then* cặp câu trong ngày **idempotent** (mở 2 lần ra cùng cặp) và lịch sử được giữ.
3. *Then* lưới mood/weather + summary khớp fixture.

**Subtasks:** bật cờ · parity quotes/stats · smoke · cập nhật docs.

### MD-20-S6 · `[Serverpod] Chạy dart test + smoke BACKEND=serverpod` · 3 pts · High
**AC**
1. *Then* `dart test` xanh trên máy có PostgreSQL.
2. *Then* smoke 5 luồng chính (đăng nhập, ghi nhật ký, lưới tháng, kho câu, thời tiết) trên web + mobile.
3. *Then* log không có 401/500 ngoài dự kiến.

**Subtasks:** chạy dart test · smoke thủ công có checklist · thu log.

### MD-20-S7 · `[Serverpod] Runbook rollback + đổi mặc định` · 2 pts · Medium
**AC**
1. *Then* runbook ghi rõ cách đổi cờ về `fastapi` trong ≤ 1 phút, cho cả web và mobile.
2. *Then* có mục "dấu hiệu phải rollback": lỗi 401/500 tăng, mất/nhân đôi dữ liệu, cross-user access.
3. *Then* chỉ đổi mặc định sang `serverpod` sau khi toàn bộ parity test xanh.

**Subtasks:** viết runbook · review chéo 1 người · link runbook trong `README.md`.

### MD-20-S8 · `[Serverpod] Gỡ FastAPI sau parity report` · 3 pts · Medium
**AC**
1. *Then* parity report được review và approve.
2. *Then* backup DB + manifest ảnh đã xác nhận **restore được**.
3. *Then* chỉ xoá FastAPI sau khi hết cửa sổ rollback; `docs/convert` cập nhật trạng thái và ADR.

**Subtasks:** viết parity report · xác nhận backup/restore · xoá code + cập nhật docs/ADR.

---

## MD-22 — `[Quality] Kiểm thử - a11y - i18n - hiệu năng`

### MD-22-S1 · `[Test] Unit test cho models + repositories` · 5 pts · High
**AC**
1. *Then* mọi model parse đúng JSON snake_case của FastAPI, kể cả field null và `updated_at`.
2. *Then* repository map đúng path → call và lỗi (`404` trả `null`, lỗi khác rethrow).
3. *Then* coverage được đo trong CI và không giảm so với baseline.

**Subtasks:** test models · test repositories (FastAPI + Serverpod) · wire coverage vào CI.

### MD-22-S2 · `[Test] Widget test cho màn hình chính` · 5 pts · High
**AC**
1. *Then* Login / Home / Editor / Planner render được ở trạng thái loading, empty và error.
2. *Then* footer **Tiện ích** hiện dạng thanh cố định ở màn rộng và dạng khối cuối trang ở màn hẹp.
3. *Then* không có exception trong lúc test.

**Subtasks:** test Login/Home · test Editor/Planner · test footer 2 breakpoint.

### MD-22-S3 · `[Test] Integration test: đăng nhập → ghi nhật ký → lưới tháng` · 8 pts · High
**AC**
1. *Then* luồng chạy end-to-end với backend đang chạy (FastAPI và/hoặc Serverpod).
2. *Then* dữ liệu vừa tạo thấy được trên lưới tháng.
3. *Then* test không flaky qua 3 lần chạy liên tiếp.

**Subtasks:** dựng harness · viết luồng · chạy 3 lần xác nhận ổn định.

### MD-22-S4 · `[A11y] Rà a11y + responsive (web/mobile/dark mode)` · 3 pts · Medium
**AC**
1. *Then* các nút hành động chính có `Semantics` nhãn đúng.
2. *Then* không tràn layout ở 3 viewport 360 / 768 / 1440.
3. *Then* tương phản màu đạt ở dark mode (theo Material 3).

**Subtasks:** kiểm viewport · kiểm Semantics · kiểm dark mode · ghi danh sách lỗi + sửa.

### MD-22-S5 · `[Perf] Performance budget: bundle web + tải Home/gallery` · 3 pts · Medium
**AC**
1. *Then* có baseline kích thước bundle web và thời gian tải Home/gallery.
2. *Then* đặt ngưỡng cảnh báo và ghi vào tài liệu.
3. *Then* báo cáo Lighthouse được lưu trong `docs/` để so sánh về sau.

**Subtasks:** đo baseline · đặt ngưỡng · lưu báo cáo.

### MD-22-S6 · `[i18n] Spike: tách chuỗi hay không?` · 2 pts · Low (Spike)
**AC**
1. *Then* có kết luận rõ **làm** hoặc **không làm**, kèm lý do.
2. *Then* có ước tính chi phí nếu làm (số file, số chuỗi, thời gian).
3. *Then* quyết định được ghi thành ADR ngắn trong `docs/`.

**Subtasks:** kiểm số chuỗi hard-code · ước tính · viết ADR.

---

## Tiếp theo (Batch 2 trở đi)

Thứ tự đề xuất: **MD-10 (Auth)** → **MD-11 (Journal)** → **MD-17 (Weather — đóng epic)** →
**MD-23 (Ops)** → **MD-21 (Release)** → **MD-12…MD-19** (Quotes, Planner, Health, Stats, Admin, Calendar, Garden).

