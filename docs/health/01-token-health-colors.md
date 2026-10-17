# H0-S1 · Token màu cho mục Sức khoẻ

**Epic:** H0 · **Ước lượng:** 2 pts · **Phụ thuộc:** —
**Nguồn thiết kế:** `ui-figma/suckhoe/memoir_c_p_nh_t_th_ng_s_c_nh_n_bmi/code.html`
— thẻ hero nước dòng 246 (`#E3F2FD`, `#1565C0`, `#0D47A1`, `#29B6F6`, `#0288D1`),
ngủ (`#EDE7F6`, `#5E35B1`, `#4527A0`, `#7E57C2`), ô “Ngày đỉnh cao” dòng 310
(`#FB8C00`), “+12%” dòng 288 (`#2E7D32`), dải BMI dòng 623/625 (`#29B6F6`,
`#FB8C00`)

## Mục tiêu

Bổ sung vào **token** những màu mà bản dựng Sức khoẻ dùng nhưng palette chưa có
(nước, giấc ngủ, xu hướng tăng, đỉnh cao, dải BMI), rồi regenerate `tokens.dart`
để widget dùng `MemoirColorsLight/Dark` thay vì dán hex (quy ước
`docs/health/00-conventions.md` §3).

## Phạm vi

- **Sửa:** `tokens/memoir-colors-light.tokens.json`, `tokens/memoir-colors-dark.tokens.json`.
- **Sinh lại:** `flutter_app/lib/src/ui/tokens.dart` (chạy generator, **không** sửa tay).
- **KHÔNG sửa:** `tool/gen_tokens.dart`, `tokens/memoir-foundation.tokens.json`,
  `tokens/tokens.resolver.json`, `flutter_app/lib/src/ui/theme.dart` (theme đọc
  token qua tên, không cần map thêm).

## Việc cần làm

- [ ] Thêm nhóm `health` vào **cả hai** file token, cùng đường dẫn khoá (light/dark):

| Khoá (path) | Light | Dark (đề xuất — review khi có Figma) | Dùng ở |
|---|---|---|---|
| `health.water.accent` | `#0288D1` | `#4FC3F7` | icon/thanh tiến độ nước |
| `health.water.text` | `#0D47A1` | `#90CAF9` | số liệu nước |
| `health.water.surface` | `#E3F2FD` | `#102A3C` | nền chip nước |
| `health.water.deep` | `#1565C0` | `#29B6F6` | buổi uống cao nhất |
| `health.sleep.accent` | `#7E57C2` | `#B39DDB` | icon/thanh tiến độ ngủ |
| `health.sleep.text` | `#4527A0` | `#CFBCFF` | số liệu ngủ |
| `health.sleep.surface` | `#EDE7F6` | `#2A2338` | nền chip ngủ |
| `health.sleep.deep` | `#5E35B1` | `#7E57C2` | “Ngủ sâu” |
| `health.trend.up` | `#2E7D32` | `#81C784` | “+12% so tháng trước” |
| `health.metric.peak` | `#FB8C00` | `#FFB74D` | “Ngày đỉnh cao”, kcal |
| `health.bmi.under` | `#29B6F6` | `#4FC3F7` | mốc Gầy của dải BMI |
| `health.bmi.normal` | `#A5D1B2` | `#A5D1B2` | mốc Chuẩn của dải BMI |
| `health.bmi.over` | `#FB8C00` | `#FFB74D` | mốc Thừa cân của dải BMI |

- [ ] Dùng đúng cấu trúc DTCG của file hiện tại (`$type: color`,
  `$value: {colorSpace: srgb, components: […], hex: "#…"}`); giữ indent 2 space.
- [ ] Chạy `dart run tool/gen_tokens.dart` ở gốc repo.
- [ ] Kiểm tra `tokens.dart` có `healthWaterAccent`, `healthWaterText`,
  `healthWaterSurface`, `healthWaterDeep`, `healthSleepAccent`, `healthSleepText`,
  `healthSleepSurface`, `healthSleepDeep`, `healthTrendUp`, `healthMetricPeak`,
  `healthBmiUnder`, `healthBmiNormal`, `healthBmiOver` ở **cả** hai class.
- [ ] **Không** thêm token cho mốc “Béo phì” — dùng `feedbackError` sẵn có.
- [ ] **Không** thêm token cho pill/segmented `#F1EFEA` — đã dùng
  `theme.colorScheme.surfaceContainerHighest`.

## Acceptance Criteria

1. *Given* hai file token đã thêm nhóm `health`, *when* chạy
   `dart run tool/gen_tokens.dart`, *then* lệnh kết thúc mã 0 và `tokens.dart`
   chứa đủ 13 hằng mới ở `MemoirColorsLight` **và** `MemoirColorsDark`.
2. *Given* `MemoirColorsLight.healthWaterAccent`, *then* giá trị là `#0288D1`
   (khớp `code.html` dòng 246).
3. *Then* không file widget nào chứa hex `#0288D1|#0D47A1|#E3F2FD|#7E57C2|#FB8C00|#2E7D32|#29B6F6`.
4. *Then* `flutter analyze` sạch và `flutter test` vẫn xanh (không hồi quy token cũ).

## Kiểm chứng

```powershell
dart run tool/gen_tokens.dart
Select-String -Path 'flutter_app\lib\src\ui\tokens.dart' -Pattern 'healthWater|healthSleep|healthTrendUp|healthMetricPeak|healthBmi'
cd flutter_app ; flutter analyze ; flutter test
```

## Rủi ro / ghi chú

- **Giá trị Dark là đề xuất** (bản dựng chỉ có light). Ghi rõ trong PR để review
  khi Figma có mode tối; nếu chưa chốt, giữ đúng bảng trên thay vì tự pha màu.
- `tool/gen_tokens.dart` đọc cả hai file theo `tokens/tokens.resolver.json`; thêm ở
  một file mà thiếu file kia sẽ làm hằng số lệch giữa 2 mode.
- Đây là task **không phụ thuộc** gì: có thể làm song song với toàn bộ H1.
