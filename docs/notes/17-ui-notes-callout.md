# N3-S4 · Banner "Kết nối ghi chú cùng dòng nhật ký"

**Epic:** N3 · **Ước lượng:** 1 pt · **Phụ thuộc:** N3-S1
**Nguồn thiết kế:** `ui-figma/ghichu/code.html` dòng ~582–601 (section callout cuối
trang: icon `import_contacts`, tiêu đề, đoạn mô tả, nút "Khám phá liên kết")

## Mục tiêu

Dựng khối quảng bá ở cuối danh sách, hướng người dùng sang việc liên kết ghi chú
với nhật ký.

## Phạm vi

- **Tạo mới:** `flutter_app/lib/src/ui/notes/notes_callout.dart`.
- **KHÔNG sửa:** `widgets/app_footer.dart` (footer trang xử lý riêng ở N3-S5).

## Việc cần làm

- [ ] `NotesCallout({VoidCallback? onExplore})`.
- [ ] Khung: nền `palette.surfaceBrandSubtle`, viền hairline, `MemoirRadius.card`,
  padding `s6`, layout `Row` khi rộng / `Column` khi hẹp.
- [ ] Trái: vòng tròn nền `primaryFixed`/`primaryContainer` chứa icon
  (`Icons.menu_book` làm thay `import_contacts`), bên cạnh là tiêu đề serif
  "Kết nối ghi chú cùng dòng nhật ký của bạn" + đoạn mô tả nguyên văn trong
  `code.html` dòng ~592–594.
- [ ] Phải: nút outline pill "Khám phá liên kết" (icon `hub`/`Icons.hub_outlined`).
- [ ] `onExplore` mặc định `null` → nút disabled với tooltip "Sắp có"; khi
  `onExplore != null` mới bấm được (tính năng liên kết thật nằm ở N4-S4).
- [ ] `flutter analyze`.

## Acceptance Criteria

1. *Given* `onExplore == null`, *then* nút "Khám phá liên kết" ở trạng thái disabled
   và không ném lỗi khi bấm.
2. *Given* `onExplore != null`, *then* bấm gọi callback.
3. *Given* màn hẹp, *then* nội dung xếp dọc, không tràn.
4. *Then* `flutter analyze` sạch.

## Kiểm chứng

```powershell
cd flutter_app
flutter analyze
flutter run -d chrome --web-port 8080   # so vùng callout với screen.png
```

## Rủi ro / ghi chú

- Đây là **khối trang trí/hướng dẫn**, không phải tính năng mới; giữ disabled là
  trung thực với backend hiện tại.
- Icon `import_contacts`/`hub` không có trong `assets/icons/` → dùng icon Material
  tương đương (đúng quy ước `00-conventions.md` §3).
