# N3-S1 · Breadcrumb + header trang Ghi chú

**Epic:** N3 · **Ước lượng:** 2 pts · **Phụ thuộc:** N2-S5
**Nguồn thiết kế:** `ui-figma/ghichu/code.html` dòng ~197–230 (breadcrumb +
`<section>` header với tiêu đề serif, chip đếm, phụ đề, 2 nút)

## Mục tiêu

Dựng phần "đầu trang" của màn danh sách: breadcrumb, tiêu đề lớn kiểu tạp chí,
chip đếm, phụ đề, nút **"Xem thùng rác"** và **"+ Ghi chú mới"**.

## Phạm vi

- **Tạo mới:** `flutter_app/lib/src/ui/notes/notes_chrome.dart`.
- **Sửa:** không (chỉ import).
- **KHÔNG sửa:** `widgets/app_header.dart` (chrome dùng chung đã có).

## Việc cần làm

- [ ] Widget `NotesBreadcrumb` — "Trang chủ" (có icon mũi tên) `/` "Ghi chú"
  (đậm, màu primary); "Trang chủ" bấm được → `Navigator.pop`.
- [ ] Widget `NotesPageHeader({required int count, required VoidCallback onTrash,
  required VoidCallback onCreate})`:
  - TIÊU ĐỀ "**Ghi chú**" cỡ `headingPage` bằng `serifFamily` (Lora ← Newsreader).
  - Chip đếm `"$count ghi chú"` nền `palette.surfaceBrandSubtle`, chữ caption primary.
  - Phụ đề: "Lưu giữ tưởng, thông tin và những điều quan trọng của bạn trong không
    gian giấy mộc tính lặng." (đúng text trong `code.html` dòng ~213–215).
  - Nút "Xem thùng rác": `OutlinedButton.icon` (icon `Icons.delete_outline`).
  - Nút "+ Ghi chú mới": `FilledButton.icon` (`Icons.add`).
  - Đường kẻ dưới (`Divider` màu `palette.borderDefault`).
- [ ] Responsive: < 768px xếp dọc (nút xuống dưới, full-width); ≥ 768px hai cột
  (chữ trái, nút phải) như thiết kế.
- [ ] Dùng `HomeScale.textOf(context)` cho scale chữ, `MemoirSpace`/`MemoirRadius`.

## Acceptance Criteria

1. *Given* 18 ghi chú, *then* chip hiển thị "18 ghi chú".
2. *Given* bấm "Xem thùng rác", *then* gọi `onTrash` (mở chế độ thùng rác).
3. *Given* bấm "+ Ghi chú mới", *then* gọi `onCreate` (mở trình soạn thảo trống).
4. *Given* màn hẹp (390px), *then* không tràn (`tester.takeException()` null) và
   hai nút xuống dưới tiêu đề.
5. *Then* tiêu đề dùng `serifFamily`, không hard-code px rời.

## Kiểm chứng

```powershell
cd flutter_app
flutter analyze
flutter run -d chrome --web-port 8080   # so với ui-figma/ghichu/screen.png (vùng đầu trang)
```

## Rủi ro / ghi chú

- Đếm ở đây là **tổng** ghi chú (chưa trừ thùng rác) — khớp chip "18 ghi chú" trong
  thiết kế; số trên từng chip lọc do N3-S2 tính.
- Text phụ đề lấy nguyên văn từ `code.html` để khớp Figma; nếu bạn muốn rút gọn, ghi
  chú lại trong PR.
