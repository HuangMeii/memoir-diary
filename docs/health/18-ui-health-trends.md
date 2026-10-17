# H3-S4 · Khối “Xu hướng 30 ngày gần nhất”

**Epic:** H3 · **Ước lượng:** 5 pts · **Phụ thuộc:** H2-S6
**Nguồn thiết kế:** `ui-figma/suckhoe/memoir_c_p_nh_t_th_ng_s_c_nh_n_bmi/code.html`
dòng 253–447 — `h2` (259), pill metric *Luyện tập · Nước · Giấc ngủ · Cân nặng* (265),
chip range *7 ngày · 30 ngày · 3 tháng* (272), 4 ô số (280–314), bar chart + đường mốc
8.000 (319) + đường TB 7.200 (324), 30 cột (328–427), nhãn ngày (430), legend 3 mức
(439–447)

## Mục tiêu

Dựng khối xu hướng: chọn metric, chọn kỳ, 4 ô số tổng hợp, biểu đồ cột có đường mốc +
đường trung bình, nhãn ngày và legend 3 mức — tất cả tính từ dữ liệu thật
(`healthTrendsProvider`, H2-S5) qua `summarizeTrend` (H2-S6).

## Phạm vi

- **Tạo mới:** `flutter_app/lib/src/ui/health/health_trends.dart`.
- **Dùng:** `fl_chart: ^1.2.0` (`BarChart`, đã có trong `pubspec.yaml`), `SegmentedTabs`.
- **KHÔNG sửa:** `ui/weather/weather_charts.dart` (chỉ tham chiếu cách dựng chart).

## Việc cần làm

- [ ] `HealthTrends({required HealthMetric metric, required VoidCallback onMetricChanged,
      required HealthTrendRange range, required VoidCallback onRangeChanged})` +
      `enum HealthTrendRange { week, month, quarter }` → `7 / 30 / 90` ngày.
- [ ] Pill metric: `SegmentedTabs` 4 mục (`Luyện tập`, `Nước`, `Giấc ngủ`, `Cân nặng`)
      ↔ `HealthMetric`; chip range: `SegmentedTabs` 3 mục (`7 ngày`, `30 ngày`, `3 tháng`).
- [ ] 4 ô số (dùng `TrendSummary`):
  - **Tổng bước** (hoặc “Tổng …” theo metric) + chip `+12% so tháng trước` khi tăng,
    màu `healthTrendUp`; giảm ⇒ hiện `-x%` màu `feedbackError`; không có dữ liệu ⇒ `--`.
  - **Trung bình ngày** + `Mục tiêu: 8.000 bước`.
  - **Ngày đạt chuẩn** `24 / 30` + `Tỷ lệ hoàn thành 80%`.
  - **Ngày đỉnh cao** `12.450` + `Thứ Ba, 14/10/2026` (dùng `healthMetricPeak`).
- [ ] Biểu đồ cột (`BarChart`), chiều cao ~180:
  - một cột cho **mỗi ngày của kỳ**, ngày không có dữ liệu ⇒ cột 0 với màu
    `outlineVariant` (không bỏ trống trục);
  - màu cột theo mức: `>= 100% mục tiêu` ⇒ `colorScheme.primary`; `70–99%` ⇒
    `healthBmiNormal`-tông nhạt (`heatmapMoodHappy`); `< 70%` ⇒ `outlineVariant`;
    **ngày hôm nay** viền/đậm hơn;
  - đường mốc mục tiêu + đường trung bình: vẽ bằng `extraLinesData` hoặc cột phủ
    (`FlLine` nét đứt, có nhãn `Mục tiêu 8.000` / `TB: 7.200`);
  - bo tròn đầu cột (`borderRadius: BorderRadius.circular(3)`);
  - `titlesData`: trục dưới chỉ hiện ~4–5 nhãn (`dd ThMM`, thêm “(Hôm nay)” cho cột cuối),
    trục trái hiện số rút gọn (`216K`), tắt trục phải/trên.
- [ ] Legend 3 mức dưới chart: “Đạt mục tiêu (≥ …)”, “Đạt 70-99%”, “Chưa đạt” — **cùng
      nguồn hằng** `partialThreshold` với `summarizeTrend`.
- [ ] Cột phải trong cùng khối (nếu theo bố cục 65/35 của thiết kế) không thuộc task này:
      khối này chiếm cột trái, timeline/quote là H3-S5/S6.
- [ ] Chọn metric/range ⇒ provider nạp lại (không giữ dữ liệu cũ trên màn).
- [ ] `flutter analyze`.

## Acceptance Criteria

1. *Given* kỳ 30 ngày có 24 ngày đạt mục tiêu, *then* ô “Ngày đạt chuẩn” hiện `24 / 30`
   và tỷ lệ `80%`.
2. *Given* ngày trống trong kỳ, *then* biểu đồ vẫn vẽ **đủ số cột** của kỳ, cột đó bằng 0
   và dùng màu “chưa đạt”.
3. *Given* metric = `Nước`, *then* đường mốc dùng mục tiêu nước (`2.000 ml`) và đơn vị
   trong các ô số đổi theo metric.
4. *Given* kỳ không có bất kỳ điểm dữ liệu nào, *then* hiện trạng thái trống với câu
   hướng dẫn (không vẽ số mẫu như thiết kế) — chi tiết ở H3-S9.
5. *Given* bấm chip `3 tháng`, *then* gọi `healthTrendsProvider` với `from/to` của 90 ngày.
6. *Then* legend và màu cột dùng cùng ngưỡng 70%; `flutter analyze` sạch.

## Kiểm chứng

```powershell
cd flutter_app
flutter analyze
flutter test test\health_test.dart      # phần summarizeTrend + legend (H5-S1)
flutter run -d chrome --web-port 8080   # so với code.html 253–447 / screen.png
```

## Rủi ro / ghi chú

- Thiết kế vẽ **30 cột tĩnh** (dữ liệu minh hoạ) — đừng copy số; khối này phải chạy
  bằng dữ liệu thật và có trạng thái trống.
- `fl_chart` 1.2.0: `BarChartData` cần `maxY` thủ công có headroom (giống `_LineChart`
  cũ trong `health_screen.dart` dùng `maxY * 1.2`).
- Với metric `weight`, thang đo nhỏ (57–61 kg): trục Y **không** bắt đầu từ 0 — cho phép
  `minY` động, nếu không đường biểu diễn sẽ dẹt.
