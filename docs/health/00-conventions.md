# Quy ước — bộ task Sức khoẻ

Áp dụng cho mọi file trong `docs/health/`. Kế thừa `docs/jira/00-conventions.md`
(Epic → Story/Spike → Subtask, AC Given/When/Then, DoD) và
`docs/notes/00-conventions.md` (quy ước code, map tài nguyên, Serverpod, Flutter),
bổ sung phần riêng của mục Sức khoẻ.

## 1. Cấu trúc một file task

```markdown
# <ID> · <Tên task>
**Epic:** H# · **Ước lượng:** <n> pts · **Phụ thuộc:** <ID>
**Nguồn thiết kế:** ui-figma/suckhoe/<folder>/code.html dòng a–b   (chỉ task UI)

## Mục tiêu
## Phạm vi              (file đụng tới · KHÔNG đụng tới)
## Việc cần làm         (checklist từng bước)
## Acceptance Criteria  (Given/When/Then, đánh số)
## Kiểm chứng           (câu lệnh chạy được)
## Rủi ro / ghi chú
```

- ID theo `H<epic>-S<task>` (khớp bảng ở `README.md`); epic H0–H5.
- Ước lượng Fibonacci; task ≤ 5 điểm. Task > 5 phải tách tiếp.
- Mọi task UI **bắt buộc** ghi `Nguồn thiết kế` + khoảng dòng trong `code.html`
  (dùng bảng “Bản đồ dòng dashboard” ở `README.md` §2).
- Hai màn modal ngủ/nước ghi thêm dòng cảnh báo **`screen.png` hỏng** để người đọc
  biết chỉ có `code.html` làm chuẩn.

## 2. Quy ước code

| Chủ đề | Quy ước |
|---|---|
| Ngôn ngữ | Code/comment **tiếng Anh**; tài liệu/UI **tiếng Việt** |
| Flutter | feature-first; Riverpod cho state; repository cho API |
| Vị trí | screen ở `flutter_app/lib/src/ui/screens/`; widget phụ ở `flutter_app/lib/src/ui/health/` |
| Serverpod | domain code ở `memoir_server/memoir_server_server/lib/src/health/`; một `.spy.yaml` / model; một `health_endpoint.dart` |
| Lỗi client | ném `ApiException` với `code` ổn định (đừng ném `Exception` thô) |
| CSS → Flutter | Tailwind `rounded-2xl` → `MemoirRadius.card`; `rounded-lg` → `MemoirRadius.page`; `rounded-full` → `MemoirRadius.pill` |

## 3. Map tài nguyên thiết kế

Không thêm asset mới; map về cái sẵn có (giống `docs/notes/00-conventions.md` §3):

| Thiết kế (DESIGN.md) | App dùng |
|---|---|
| `Newsreader` (serif) | **`Lora`** (`serifFamily`) |
| `Plus Jakarta Sans` (sans) | **`Inter`** (`sansFamily`) |
| Material Symbols Outlined | Material Icons / `MemoirIcon` |

Cỡ chữ: map `headline-xl/lg/md/sm`, `body-lg/md/sm`, `label-md/sm`, `caption` sang
`MemoirType` (`headingPage`, `heading1`, `headingEditorial`, `body`, `label`,
`caption`, `overlineEditorial`). Không hard-code px rời rạc trong widget.

Màu: dùng `MemoirColorsLight`/`MemoirColorsDark` qua `Theme.of(context)`.
**Không** dán hex Stitch vào widget — bản dựng dùng những màu **chưa có** trong
palette (`#0288D1`, `#0D47A1`, `#E3F2FD`, `#1565C0`, `#7E57C2`, `#4527A0`,
`#EDE7F6`, `#5E35B1`, `#FB8C00`, `#2E7D32`, `#29B6F6`); các màu này được thêm thành
token ở task **H0-S1** rồi regenerate `tokens.dart`
(`dart run tool/gen_tokens.dart`). Pill/segmented dùng
`theme.colorScheme.surfaceContainerHighest` như `SegmentedTabs` sẵn có (bản dựng
dùng `#F1EFEA`, đã có token tương đương trong palette).

## 4. Quy ước nghiệp vụ (riêng mục Sức khoẻ)

| Chủ đề | Quy ước |
|---|---|
| Ngày & giờ | Mọi phép “hôm nay/hôm qua”, phân buổi, khung giờ ngủ tính theo **giờ Việt Nam (UTC+7)** — cùng cách đã chốt cho thời tiết (`docs/12-route-weather.md`) |
| Buổi uống | Suy ra từ **giờ của `recordedAt`**: Sáng `< 12:00`, Chiều `12:00–17:59`, Tối `≥ 18:00` (không lưu cột `period`) |
| Đơn vị | Nước `ml` (int), phút tập `phút` (int), ngủ `giờ` (double), ngủ sâu `phút` (int), cân nặng `kg` (double 1 số lẻ), chiều cao `cm` (int) |
| Định dạng hiển thị | Ngủ `7h 30m`; cân nặng `58.2 kg`; nước `1.750 ml` (dấu `.` ngăn nghìn) |
| BMI | `weightKg / (heightCm/100)^2`, làm tròn **1 số thập phân**; phân loại **IDI & WPRO**: Gầy `<18.5`, Chuẩn `18.5–22.9`, Thừa cân `23–24.9`, Béo phì `≥25` |
| Ngưỡng “đạt” | Ngày đạt chuẩn khi giá trị `≥` mục tiêu của metric đó; `70–99%` là “gần đạt”; dưới `70%` là “chưa đạt” (khớp legend 3 mức của thiết kế) |
| Số bước | Nhập tay (HealthKit/Google Fit ngoài phạm vi) |
| Nguồn số liệu | Mọi số “tổng / trung bình / ngày đạt chuẩn / đỉnh cao” tính từ dữ liệu thật trong kỳ đang chọn; thiếu dữ liệu ⇒ hiển thị trạng thái trống, **không** vẽ số mẫu của thiết kế |

## 5. Quy ước Serverpod

- **Không sửa** `lib/src/generated/**` và `memoir_server_client/**` — generator ghi đè.
- Sau khi đổi `.spy.yaml` có `table`: chạy `serverpod generate`, rồi
  `serverpod create-migration`.
- Migration là **ngoại lệ** được sửa tay `migration.sql` khi cần index; **không**
  đụng các file khác trong thư mục migration, và `definition.sql` cuối cùng phải khớp.
- Migration chỉ **sinh** ở đây; **apply** do `serverpod start` khi boot.
- Mọi endpoint ghi dữ liệu đều `requireLogin = true` + `currentUserId(session)` +
  kiểm tra sở hữu bằng `ensureOwned(...)` (`lib/src/shared/session_utils.dart`).
- Chuẩn hoá ngày bằng `dateOnly(...)` trước khi so sánh/ghi (cột `date`).

## 6. Quy ước Flutter

- Provider thêm vào `flutter_app/lib/src/data/providers.dart`; FutureProvider **phải**
  `await ref.watch(authReadyProvider.future)` trước khi gọi API.
- Sau khi ghi dữ liệu, gọi helper `refreshHealth(ref)` (H2-S5) — đừng
  `ref.invalidate` rải rác từng provider trong widget.
- `HealthScreen` mở bằng `Navigator.push` từ thẻ shortcut (giữ nguyên
  `ui/home/shortcut_cards.dart`); **không** thêm route mới vào `main.dart`.
- Chrome dùng chung: `AppHeader` (`ui/widgets/app_header.dart`) với
  `AppDestination.health` (thêm ở H3-S8); segmented/chip dùng
  `SegmentedTabs` (`ui/widgets/segmented_tabs.dart`) thay vì tự vẽ.
- Test đặt trong `flutter_app/test/`; hàm thuần (BMI, chia buổi, tổng hợp xu hướng,
  format) tách vào `ui/health/health_metrics.dart` để test không cần network.

## 7. DoD của tính năng (áp dụng cho toàn bộ epic)

- [ ] `dart analyze` sạch (server) và `flutter analyze` sạch (app).
- [ ] `dart format` đã chạy (server).
- [ ] `dart test` xanh (server) — nhóm health.
- [ ] `flutter test` xanh (app) — gồm `test/health_test.dart`.
- [ ] Đã verify trên web (`flutter run -d chrome --web-port 8080`) đối chiếu
  `ui-figma/suckhoe/memoir_s_c_kho_th_ch_t_t_i_gi_n/screen.png`,
  `…/memoir_c_p_nh_t_th_ng_s_c_nh_n_bmi/screen.png`,
  `…/memoir_ghi_nh_n_nhanh_s_c_kho/screen.png`; hai modal ngủ/nước đối chiếu
  `code.html` (ảnh chụp hỏng).
- [ ] `docs/03-database-schema.md`, `docs/04-api-reference.md`,
  `docs/UI-design/16-health-input.md`, `17-health-trends.md`, `README.md`/`PLAN.md`
  đã cập nhật (task H5-S2).
- [ ] Migration đã review: chỉ thêm cột/bảng, **không** mất dữ liệu `health_logs`.
