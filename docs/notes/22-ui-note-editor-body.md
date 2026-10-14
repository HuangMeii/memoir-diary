# N4-S3 · Tiêu đề + dòng meta + thân nội dung

**Epic:** N4 · **Ước lượng:** 3 pts · **Phụ thuộc:** N4-S2
**Nguồn thiết kế:** `ui-figma/taoghichu/code.html` dòng ~283–378 (tiêu đề serif,
dòng meta "Ngày cập nhật / 840 từ / Du lịch & Đời sống / Màu ghi chú", các section
với block checklist tương tác và bullet list)

## Mục tiêu

Dựng vùng nội dung: tiêu đề tách riêng (`title`), dòng meta động, và thân note
(sửa được) với **block checklist tương tác** cùng danh sách bullet render từ
`content` + `checklist`.

## Phạm vi

- **Tạo mới:** `flutter_app/lib/src/ui/notes/editor_body.dart`.
- **Sửa:** `note_editor_screen.dart` (ghép vùng body vào layout).
- **KHÔNG sửa:** `markdown_lite.dart` (N4-S2).

## Việc cần làm

- [ ] **Tiêu đề**: `TextField` 1 dòng, `serifFamily`, cỡ `headingPage`/`heading1`,
  `hintText: 'Tiêu đề ghi chú...'`, không viền, nền trong suốt.
- [ ] **Dòng meta** (dưới tiêu đề, viền dưới hairline):
  - "Ngày cập nhật: dd Tháng m, yyyy" (icon lịch, chữ primary) — từ `updatedAt`.
  - "• {wordCount} từ" — từ `Note.wordCount`.
  - "• {tag đầu tiên}" trong chip nền `surfaceContainer` (nếu có tag).
  - "• ● Màu ghi chú: {tên màu tiếng Việt}" — chấm màu lấy từ `color`.
- [ ] **Thân**: `TextField` đa dòng, **không** viền, `serifFamily` cho dòng `#`/`##`,
  `sansFamily` cho đoạn thường; `keyboardType: multiline`; `expands`.
- [ ] **Block checklist tương tác**: lấy từ `NoteDetail.checklist`; mỗi dòng
  `CheckboxListTile`/`Row(Checkbox + Text)`; text gạch ngang khi `isDone`. Toggle
  cập nhật state cục bộ, lưu qua `update(checklist: …)` khi autosave chạy.
- [ ] **Bullet list**: dòng trong `content` bắt đầu `- ` → hiển thị gạch đầu dòng
  (dùng `RichText`/`Text.rich` với `WidgetSpan`? **không** — chỉ cần `Text` kèm ký
  hiệu `•`, giữ cho thân vẫn là text thuần).
- [ ] Nút "Thêm dòng" ở cuối block checklist (optional, khớp tính tương tác).
- [ ] `flutter analyze`.

## Acceptance Criteria

1. *Given* note chưa có tiêu đề, *then* placeholder "Tiêu đề ghi chú..." hiện ra và
   tiêu đề không chiếm dòng trong `content`.
2. *Given* `content` 840 từ, *then* dòng meta hiện "840 từ".
3. *Given* `color = '#3d654c'`, *then* dòng meta hiện chấm màu và "Xanh ô liu nhạt".
4. *Given* checklist có 4 mục (2 done), *then* 2 mục bị gạch ngang; tick mục thứ ba
   → lưu và giữ trạng thái sau khi mở lại.
5. *Given* dòng `- Sức mạnh của thói quen`, *then* hiển thị dạng bullet.
6. *Then* `flutter analyze` sạch.

## Kiểm chứng

```powershell
cd flutter_app
flutter analyze
flutter run -d chrome --web-port 8080   # so vùng body với ui-figma/taoghichu/screen.png
```

## Rủi ro / ghi chú

- Tiêu đề và `content` **tách rời**: dòng đầu của `content` **không** bị coi là tiêu
  đề khi đang ở editor (chỉ dùng khi thiếu `title` ở card — `Note.displayTitle`).
- Tên màu tiếng Việt: dùng map nhỏ `{'#3d654c': 'Xanh ô liu nhạt', …}`; màu lạ →
  hiện mã hex.
- Không render Markdown đầy đủ (bold/italic) trong `TextField` — Flutter không hỗ
  trợ style từng phần trong `TextField`. Style một phần chỉ có ở card/preview (N5-S1
  test phần phân tích), không ở editor.
