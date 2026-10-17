# H2-S5 · Provider + `refreshHealth`

**Epic:** H2 · **Ước lượng:** 2 pts · **Phụ thuộc:** H2-S4
**File:** `flutter_app/lib/src/data/providers.dart` (`healthLogsProvider` dòng 250–261)

## Mục tiêu

Thêm provider cho nội dung một ngày, chuỗi xu hướng và thông số cơ thể, cùng **một**
helper làm mới dữ liệu health sau mỗi lần ghi — thay cho việc rải `ref.invalidate`
trong widget.

## Phạm vi

- **Sửa:** `flutter_app/lib/src/data/providers.dart`.
- **KHÔNG sửa:** `healthLogsProvider` (giữ cho màn cũ/`monthSummaryProvider`),
  `monthSummaryProvider`; các provider domain khác.

## Việc cần làm

- [ ] `healthDayProvider` — `FutureProvider.family<HealthDayOverview, DateTime>`:
      `await ref.watch(authReadyProvider.future)` rồi `ref.read(healthRepositoryProvider).day(date)`.
      Chuẩn hoá `date` về nửa đêm để tránh nhiều key cho cùng một ngày.
- [ ] `healthTrendsProvider` — `FutureProvider.family<List<HealthTrendPoint>,
      ({String from, String to, HealthMetric metric})>`.
- [ ] `healthProfileProvider` — `FutureProvider<HealthProfile?>` (trả `null` khi chưa lưu).
- [ ] `refreshHealth(WidgetRef ref, {DateTime? day})`:
      invalidate `healthDayProvider(ngày)` (nếu truyền),
      `healthDayProvider` cho ngày hôm nay, `healthTrendsProvider` (mọi key),
      `healthProfileProvider`, `healthLogsProvider` (mọi key) và
      `monthSummaryProvider` (vì tổng hợp tháng có đọc health).
- [ ] Ghi rõ trong doc-comment: **mọi hành vi ghi** (lưu chỉ số, thêm/xoá nước, thêm/xoá
      mốc, lưu thông số) đều phải gọi `refreshHealth(...)`.
- [ ] `flutter analyze`.

## Acceptance Criteria

1. *Given* chưa đăng nhập xong, *when* đọc `healthDayProvider`, *then* provider chờ
   `authReadyProvider` rồi mới gọi API (không có request 401 loé lên).
2. *Given* hai widget cùng hỏi `healthDayProvider(17/10)`, *then* chỉ **một** request
   được gửi (family cache theo ngày đã chuẩn hoá).
3. *Given* thêm một lần uống 250 ml, *when* UI gọi `refreshHealth(ref, day: …)`, *then*
   nội dung ngày, chuỗi xu hướng, danh sách `healthLogsProvider` và tổng hợp tháng đều
   được nạp lại.
4. *Given* user chưa lưu thông số cơ thể, *then* `healthProfileProvider` trả `null`
   (không ném lỗi, không tạo dữ liệu).
5. *Then* `flutter analyze` sạch; `healthLogsProvider` giữ nguyên chữ ký cũ.

## Kiểm chứng

```powershell
cd flutter_app
flutter analyze
Select-String -Path 'lib\src\data\providers.dart' -Pattern 'healthDayProvider|healthTrendsProvider|healthProfileProvider|refreshHealth'
```

## Rủi ro / ghi chú

- `monthSummaryProvider` hiện được `health_screen.dart` invalidate trực tiếp
  (dòng 87–91); sau task này **chỉ** `refreshHealth` làm việc đó — nhớ gỡ code cũ khi
  viết lại màn (H3-S8).
- Invalidate `healthTrendsProvider` không tham số sẽ xoá **mọi** key; chấp nhận vì dữ
  liệu theo kỳ rất nhẹ, và tránh phải so khớp key thủ công.
- Đừng `ref.read` repository trong `build`; chỉ dùng trong provider (đúng cách file này
  đang làm).
