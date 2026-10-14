# N3-S3 · `note_card.dart` + các biến thể

**Epic:** N3 · **Ước lượng:** 3 pts · **Phụ thuộc:** N2-S3
**Nguồn thiết kế:** `ui-figma/ghichu/code.html` dòng ~437–579 (card checklist,
bullet, quote, progress bar) và `screen.png`

## Mục tiêu

Dựng card ghi chú bám thiết kế, có nhiều **biến thể thân** tuỳ nội dung: checklist,
danh sách bullet, trích dẫn (quote), thanh tiến độ.

## Phạm vi

- **Tạo mới:** `flutter_app/lib/src/ui/notes/note_card.dart`.
- **KHÔNG sửa:** `note_card` của weather (`widgets/weather_card.dart`) — tên khác
  thư mục, không đụng.

## Việc cần làm

- [ ] `NoteCard({required Note note, required bool isGrid, VoidCallback onOpen,
  ValueChanged<bool> onPin, VoidCallback onArchive, VoidCallback onTrash})`.
- [ ] Khung card: nền `surfaceCard`, viền hairline `palette.borderDefault`,
  `MemoirRadius.card`, shadow nhẹ, hover đổi viền sang primary (dùng `InkWell` +
  `MouseRegion`/`Material` states).
- [ ] Đầu card: `displayTitle` (serif, `headingEditorial`) + 2 icon: ghim
  (`push_pin`, đổi màu primary khi `isPinned`) và `more_vert` (menu: Ghim/Bỏ ghim,
  Lưu trữ, Xoá).
- [ ] Hàng thẻ: chip `#tag` (nền `surfaceBrandSubtle`/`tertiary-fixed` xen kẽ như
  thiết kế).
- [ ] **Thân — chọn biến thể tự động:**
  - có ≥1 checklist item → `_ChecklistBody` (checkbox, gạch ngang khi done, tối đa
    3 dòng đầu + "…").
  - `content` chứa dòng bắt đầu `>` → `_QuoteBody` (italic, viền trái primary).
  - có tiến độ (dòng `Tiến độ …: N%`) → `_ProgressBody` (label + giá trị + `LinearProgressIndicator`).
  - còn lại → `_TextBody` (`preview`, tối đa 3 dòng, `maxLines` + ellipsis).
- [ ] Hàng đáy (viền trên): nguồn (liên kết nhật ký `Nhật ký dd/MM` hoặc `Chưa liên
  kết` / `x/y mục tiêu` / `Định kỳ`) + ngày `dd/MM/yyyy` (`updatedAt`).
- [ ] Chế độ list: cùng card nhưng full-width, ẩn bớt thân còn 1–2 dòng.
- [ ] `flutter analyze`.

## Acceptance Criteria

1. *Given* note có 3 item checklist (1 done), *then* thân là checklist, hiển thị đủ
   và đáy ghi "1/3".
2. *Given* note có `pinned == true`, *then* icon ghim đổi màu primary (trạng thái
   "đang ghim").
3. *Given* note không có `title`, *then* tiêu đề là dòng đầu `content`.
4. *Given* bấm "Ghim", *then* gọi `onPin(true)` đúng **một** lần (không nhân đôi do
   `InkWell` lồng nút).
5. *Given* màn hẹp 390px, *then* card không tràn ngang.
6. *Then* `flutter analyze` sạch.

## Kiểm chứng

```powershell
cd flutter_app
flutter analyze
flutter run -d chrome --web-port 8080   # so vùng "ĐÃ GHIM"/"TẤT CẢ GHI CHÚ" với screen.png
```

## Rủi ro / ghi chú

- Biến thể suy ra từ dữ liệu (checklist/quote/progress) — **không** lưu "loại card"
  trong DB; giữ đơn giản và tránh dữ liệu thừa.
- Nhiều nút bên trong `InkWell`: dùng `GestureDetector`/`InkWell` riêng cho nút để
  không kích hoạt `onOpen` (test ở AC #4).
- `LinearProgressIndicator` cần `value` 0–1; phần trăm đọc từ `content` là **best
  effort** — nếu không parse được thì rơi về `_TextBody`.
