# Sức khoẻ & Thể chất (HEALTH-01 + HEALTH-02) — bộ task

Thư mục này chia nhỏ việc **nâng cấp mục Sức khoẻ** của Memoir thành các task nhỏ
(mỗi task ≤ 1 ngày), dựa trên **năm bản export từ Stitch** đã tải về
`ui-figma/suckhoe/`. Đây là tài liệu *kế hoạch/kỹ thuật*; không chứa code chạy.

Bộ task này thay thế hai brief cũ `docs/UI-design/16-health-input.md` (HEALTH-01) và
`docs/UI-design/17-health-trends.md` (HEALTH-02) — hai brief đó chỉ mô tả một form
7 field + biểu đồ 30 ngày, trong khi bản dựng có dashboard đầy đủ, drawer BMI và ba
modal ghi nhận nhanh.

## 1. Nguồn thiết kế

| Nguồn (`ui-figma/suckhoe/…`) | Màn hình | File |
|---|---|---|
| `memoir_s_c_kho_th_ch_t_t_i_gi_n/` | **Dashboard “Sức khoẻ & Thể chất”** — bản chính (541 dòng), không drawer | `code.html`, `screen.png` (504 KB) |
| `memoir_c_p_nh_t_th_ng_s_c_nh_n_bmi/` | **Cùng dashboard + drawer “Thông số cá nhân & Thể trạng” (BMI) đang mở** (726 dòng) | `code.html`, `screen.png` (1,15 MB) |
| `memoir_ghi_nh_n_nhanh_s_c_kho/` | **Modal ghi nhận tập luyện** (299 dòng) | `code.html`, `screen.png` (237 KB) |
| `memoir_ghi_nh_n_u_ng_n_c_trung_t_m/` | **Modal ghi nhận uống nước** (300 dòng) | `code.html` — **`screen.png` hỏng** (28 byte, file lỗi `<FILE Im…`) |
| `memoir_ghi_nh_n_gi_ng/` | **Modal ghi nhận giấc ngủ** (315 dòng) | `code.html` — **`screen.png` hỏng** (28 byte) |
| `warm_editorial_canvas/DESIGN.md` | Design system **“Warm Editorial Canvas”** | giống `ui-figma/ghichu` + `taoghichu` |

Hai modal **ngủ** và **nước** không có ảnh chụp dùng được ⇒ mọi task UI của hai màn
này đối chiếu `code.html` (đã ghi rõ khoảng dòng trong từng task).

Ba modal dùng **chung một khung sheet** với tab `Giờ ngủ | Thời gian tập | Uống nước`,
chỉ khác tab đang mở: H4-S1 dựng khung, H4-S2…S4 dựng từng tab.

## 2. Bản đồ dòng dashboard (để đối chiếu khi dựng)

| Dòng (`memoir_c_p_nh_t_th_ng_s_c_nh_n_bmi/code.html`) | Khối |
|---|---|
| 140–190 | Top utility/nav: wordmark, 6 mục nav, bookmark, chuông, “Lưu vào nhật ký”, chip user |
| 193–240 | Sub-header: breadcrumb (195), `h1` “Sức khoẻ & Thể chất” (206), date navigator ‹ Hôm nay, 17/10/2026 › (213), 2 nút *Xuất báo cáo* / *+ Ghi nhận nhanh* (226), banner ngữ cảnh (237) |
| 244–246 | 3 thẻ hero: tập `45/60 phút · 75% · ~240 kcal`; nước `1.750/2.000 ml · 88%` + phân bố Sáng/Chiều/Tối; ngủ `7h30/8h00 · 23:00–06:30 · Sâu 1h45` |
| 249–316 | Form **“Nhập nhanh chỉ số hôm nay”** (thời lượng + cường độ; nước; ngủ; thông số cá nhân; ghi chú; *Lưu chỉ số*) |
| 253–447 | **“Xu hướng 30 ngày gần nhất”**: pill metric *Luyện tập · Nước · Giấc ngủ · Cân nặng* (265), chip *7 ngày · 30 ngày · 3 tháng* (272), 4 ô số (280–314), bar chart + đường mốc 8.000 (319) + đường TB 7.200 (324), 30 cột (328–427), nhãn ngày (430), legend (439) |
| 450–521 | Cột phải: card cầu nối nhật ký (450), **“Dòng thời gian hoạt động”** + `+ Thêm mốc` (453–505), card “Lời nhắc dịu dàng” (507–521) |
| 522–541 | Footer biên tập |
| 539–720 | **Drawer “Thông số cá nhân & Thể trạng”** (chỉ ở bản `…_bmi`): cân nặng + stepper (564–603), BMI + spectrum + tiến độ đích (604–661), chart biến động 4 tuần/6 tháng (662–706), quote (707), footer *Hủy* / *Lưu thay đổi* (715–720) |

Từ dòng 240 trở đi, bản 52 KB lệch **−2 dòng** so với bảng trên.

## 3. Hiện trạng (trước khi làm)

| Lớp | File | Tình trạng |
|---|---|---|
| UI | `flutter_app/lib/src/ui/screens/health_screen.dart` | `AppBar('Sức khoẻ')` + chọn ngày + form 6 ô + 2 `LineChart`. **Không có** chrome chung, breadcrumb, thẻ hero, xu hướng dạng bar + metric pill, timeline, drawer BMI, modal ghi nhận nhanh |
| Repository | `flutter_app/lib/src/data/repositories/health_repository.dart` | Chỉ `logs(from, to)` và `save(date, payload)` |
| Transport | `flutter_app/lib/src/data/datasources/serverpod_data_source.dart` | `case '/health-logs'` (đọc + ghi) và `_healthMap` (dòng 728–737) — 8 field phẳng |
| Model Dart | `flutter_app/lib/src/data/models.dart` | `HealthLog` (dòng 265–307) + `toPayload()` chỉ gửi field khác null |
| Provider | `flutter_app/lib/src/data/providers.dart` | `healthLogsProvider` (family `{from, to}`); `monthSummaryProvider` cũng đọc health |
| Model server | `memoir_server/…/lib/src/health/health_log.spy.yaml` | `id, userId, logDate (unique per user), steps, workoutMinutes, waterMl, sleepHours, weightKg, note, createdAt` |
| Endpoint | `memoir_server/…/lib/src/health/health_endpoint.dart` | Chỉ `list()` + `save()` (upsert theo ngày) |
| `users` | `memoir_server/…/lib/src/auth/user.spy.yaml` | **Không có** `heightCm`; không có mục tiêu cân nặng |
| Điều hướng | `flutter_app/lib/main.dart`, `.../ui/home/shortcut_cards.dart` | Màn Sức khoẻ mở bằng `Navigator.push` từ thẻ shortcut — giữ nguyên cách này |
| Header | `flutter_app/lib/src/ui/widgets/app_header.dart` | `AppDestination` mới có `home`, `monthGrid`, `eventHistory`; thiếu mục nav “Sức khoẻ” mà thiết kế có |
| Token | `tokens/memoir-colors-light.tokens.json`, `…-dark.tokens.json` | Chưa có token nước/ngủ/xu hướng/BMI |
| Test | `flutter_app/test/` | Chưa có test nào cho health |

## 4. Phạm vi

**Đầy đủ như thiết kế.** Ngoài những gì schema hiện có, bản dựng còn cần: nước theo
**từng lần uống** (số lần, lần gần nhất, phân bố Sáng/Chiều/Tối), giấc ngủ chi tiết
(khung giờ, ngủ sâu, chất lượng), loại hình + cường độ tập, **mục tiêu**
(bước/tập/nước/ngủ), **thông số cơ thể** (chiều cao, cân nặng mục tiêu, khởi điểm) để
tính BMI và tiến độ giảm cân, và **dòng thời gian hoạt động** có mốc tự thêm.

## 5. Năm quyết định schema (đã chốt phương án A)

| # | Quyết định | Phương án A (chốt) | Phương án B (loại) |
|---|---|---|---|
| 1 | Nước uống theo lần | **Bảng con `health_water_entries`** (`amountMl`, `recordedAt`, `note`); `health_logs.waterMl` giữ vai trò **tổng suy ra** | Chỉ cộng dồn `waterMl` (không có số lần / lần gần nhất / phân buổi) |
| 2 | Thông số cơ thể & mục tiêu | **Bảng `health_profiles`** (`heightCm`, `weightGoalKg`, `weightStartKg`, `stepsGoal`, `workoutGoalMinutes`, `waterGoalMl`, `sleepGoalHours`) | Thêm cột vào `users` (bảng lõi phình, health nên tự chứa) |
| 3 | Giấc ngủ chi tiết | **Thêm cột trên `health_logs`**: `sleepBedtime`, `sleepWake`, `sleepDeepMinutes`, `sleepQuality`, `sleepNote` | Bảng `health_sleep_entries` riêng (1–1 với ngày ⇒ thừa) |
| 4 | Dòng thời gian hoạt động | **Bảng `health_activities`** cho mốc người dùng tự thêm; mốc hệ thống (tập/nước/ngủ) **suy ra** từ log | Chỉ suy ra, không `+ Thêm mốc` được |
| 5 | Buổi uống (Sáng/Chiều/Tối) | **Suy ra từ giờ VN** của `recordedAt` (không lưu cột) | Lưu cột `period` (lệch khi người dùng sửa giờ) |

Chi tiết từng quyết định nằm trong file task tương ứng (H1-S1…H1-S3).

## 6. Bảng task

Trạng thái: `TODO` · `DOING` · `DONE`.

### Epic H0 — Nền tảng

| ID | Task | Ước lượng | Phụ thuộc | File | Trạng thái |
|---|---|---|---|---|---|
| H0-S1 | Token màu cho mục Sức khoẻ | 2 | — | [01-token-health-colors.md](01-token-health-colors.md) | TODO |

### Epic H1 — Backend Sức khoẻ (Serverpod)

| ID | Task | Ước lượng | Phụ thuộc | File | Trạng thái |
|---|---|---|---|---|---|
| H1-S1 | Mở rộng model `HealthLog` (tập + ngủ) | 2 | — | [02-backend-health-log-model.md](02-backend-health-log-model.md) | TODO |
| H1-S2 | Model nước theo lần + hoạt động | 2 | — | [03-backend-water-activity-models.md](03-backend-water-activity-models.md) | TODO |
| H1-S3 | Model thông số cơ thể & mục tiêu | 2 | — | [04-backend-health-profile-model.md](04-backend-health-profile-model.md) | TODO |
| H1-S4 | DTO ngày + điểm xu hướng | 2 | H1-S1…H1-S3 | [05-backend-day-overview-dto.md](05-backend-day-overview-dto.md) | TODO |
| H1-S5 | Endpoint `health` mở rộng | 5 | H1-S4 | [06-backend-health-endpoint.md](06-backend-health-endpoint.md) | TODO |
| H1-S6 | Migration | 2 | H1-S5 | [07-backend-migration.md](07-backend-migration.md) | TODO |
| H1-S7 | Integration test endpoint | 3 | H1-S6 | [08-backend-endpoint-tests.md](08-backend-endpoint-tests.md) | TODO |

### Epic H2 — Cầu nối & tầng dữ liệu Flutter

| ID | Task | Ước lượng | Phụ thuộc | File | Trạng thái |
|---|---|---|---|---|---|
| H2-S1 | Map đọc trong `ServerpodDataSource` | 3 | H1-S6 | [09-client-datasource-read.md](09-client-datasource-read.md) | TODO |
| H2-S2 | Map ghi (nước / hoạt động / thông số / save) | 3 | H2-S1 | [10-client-datasource-writes.md](10-client-datasource-writes.md) | DONE |
| H2-S3 | Model Dart mới | 2 | H2-S1 | [11-flutter-models.md](11-flutter-models.md) | DONE |
| H2-S4 | `health_repository.dart` mở rộng | 2 | H2-S3 | [12-flutter-health-repository.md](12-flutter-health-repository.md) | DONE |
| H2-S5 | Provider + `refreshHealth` | 2 | H2-S4 | [13-flutter-providers.md](13-flutter-providers.md) | DONE |
| H2-S6 | Hàm thuần `health_metrics.dart` | 3 | — | [14-flutter-health-metrics.md](14-flutter-health-metrics.md) | DONE |

### Epic H3 — UI dashboard + drawer BMI

| ID | Task | Ước lượng | Phụ thuộc | File | Trạng thái |
|---|---|---|---|---|---|
| H3-S1 | Chrome trang + date navigator + banner | 2 | H2-S5 | [15-ui-health-chrome.md](15-ui-health-chrome.md) | DONE |
| H3-S2 | 3 thẻ tóm tắt hero | 3 | H3-S1 | [16-ui-health-summary-cards.md](16-ui-health-summary-cards.md) | DONE |
| H3-S3 | Form “Nhập nhanh chỉ số hôm nay” | 5 | H2-S6 | [17-ui-health-quick-form.md](17-ui-health-quick-form.md) | DONE |
| H3-S4 | Khối “Xu hướng 30 ngày gần nhất” | 5 | H2-S6 | [18-ui-health-trends.md](18-ui-health-trends.md) | DONE |
| H3-S5 | Card "Dòng thời gian hoạt động" | 3 | H2-S5 | [19-ui-health-timeline.md](19-ui-health-timeline.md) | DONE |
| H3-S6 | Card cầu nối nhật ký + “Lời nhắc dịu dàng” | 1 | H3-S1 | [20-ui-health-quote-bridge.md](20-ui-health-quote-bridge.md) | DONE |
| H3-S7 | Drawer “Thông số cá nhân & Thể trạng” (BMI) | 5 | H2-S6 | [21-ui-health-body-sheet.md](21-ui-health-body-sheet.md) | TODO |
| H3-S8 | Viết lại `health_screen.dart` + nav “Sức khoẻ” | 3 | H3-S2…H3-S7 | [22-ui-health-screen.md](22-ui-health-screen.md) | TODO |
| H3-S9 | States: loading / empty / error / thiếu dữ liệu | 2 | H3-S8 | [23-ui-health-states.md](23-ui-health-states.md) | TODO |

### Epic H4 — UI ghi nhận nhanh (3 modal)

| ID | Task | Ước lượng | Phụ thuộc | File | Trạng thái |
|---|---|---|---|---|---|
| H4-S1 | Khung sheet 3 tab | 2 | H2-S5 | [24-ui-quick-log-sheet.md](24-ui-quick-log-sheet.md) | DONE |
| H4-S2 | Tab Thời gian tập | 3 | H4-S1 | [25-ui-quick-log-workout.md](25-ui-quick-log-workout.md) | DONE |
| H4-S3 | Tab Uống nước | 3 | H4-S1 | [26-ui-quick-log-water.md](26-ui-quick-log-water.md) | DONE |
| H4-S4 | Tab Giờ ngủ | 3 | H4-S1 | [27-ui-quick-log-sleep.md](27-ui-quick-log-sleep.md) | TODO |

### Epic H5 — Kiểm thử, tài liệu, kiểm chứng

| ID | Task | Ước lượng | Phụ thuộc | File | Trạng thái |
|---|---|---|---|---|---|
| H5-S1 | `test/health_test.dart` | 3 | H2-S6 | [28-test-flutter-health.md](28-test-flutter-health.md) | TODO |
| H5-S2 | Cập nhật tài liệu dự án | 2 | H1-S6, H3-S9, H4-S4 | [29-docs-update.md](29-docs-update.md) | TODO |
| H5-S3 | Kiểm chứng end-to-end | 2 | toàn bộ | [30-verification.md](30-verification.md) | TODO |

## 7. Thứ tự thực hiện

```
README → 00-conventions
H0: 01
H1: (02 // 03 // 04) → 05 → 06 → 07 → 08
H2: 09 → 10 → 11 → 12 → 13        (14 chạy song song từ đầu)
H3: 15 → 16 → (17 // 18 // 21) → 19 → 20 → 22 → 23
H4: 24 → (25 // 26 // 27)
H5: 28 → 29 → 30
```

Song song được khi không chạm cùng file: `H0-S1 // H1-S1..S3`, `H2-S6 // H1-*`,
`H3-S3 // H3-S4`, `H3-S7 // H3-S9`, `H4-S2 // H4-S3 // H4-S4`.

## 8. Lệnh hay dùng

```powershell
# Backend (Serverpod) — chạy trong memoir_server\memoir_server_server
serverpod generate                 # sinh lại generated/ + memoir_server_client
serverpod create-migration         # sau khi đổi .spy.yaml có `table`
dart analyze ; dart format . ; dart test

# Flutter — chạy trong flutter_app
flutter pub get
flutter analyze ; flutter test
flutter run -d chrome --web-port 8080   # khớp CORS_ORIGINS của backend

# Token (chạy ở gốc repo)
dart run tool/gen_tokens.dart
```

## 9. Ghi chú chung

- **Không sửa file generated** (`lib/src/generated/**`, `memoir_server_client/**`).
- Migration chỉ **sinh** trong kế hoạch này; **apply** là bước bạn kiểm soát
  (`serverpod start` tự áp khi boot).
- Ngoài phạm vi (ghi rõ để không hiểu nhầm): HealthKit/Google Fit, **“Xuất báo cáo”**
  (PDF/CSV — H3-S1 chỉ dựng nút ở trạng thái chờ), đồng bộ thiết bị y tế, nhắc uống
  nước/đi ngủ, BMR & kcal thật (thiết kế có `~240 kcal` — hiển thị ước tính theo phút
  tập hoặc ẩn nếu chưa chốt công thức), màn “Xem toàn bộ lịch sử 7 ngày”.
- Nguồn ảnh để verify: xem §1 — hai modal ngủ/nước **không có `screen.png`** dùng được.
