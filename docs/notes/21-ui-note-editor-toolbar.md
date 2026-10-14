# N4-S2 · Thanh format

**Epic:** N4 · **Ước lượng:** 2 pts · **Phụ thuộc:** N4-S1
**Nguồn thiết kế:** `ui-figma/taoghichu/code.html` dòng ~236–282 (toolbar: B I U S,
H1 H2 H3, list, numbered, checklist, quote, divider, image, link, table, gợi ý
"Phím tắt: Tab để thụt dòng")

## Mục tiêu

Dựng thanh định dạng chèn cú pháp **Markdown-lite** vào `content` (quyết định #4,
phương án A) và tô sáng nút đang bật.

## Phạm vi

- **Tạo mới:** `flutter_app/lib/src/ui/notes/editor_toolbar.dart` +
  helper thuần `flutter_app/lib/src/ui/notes/markdown_lite.dart`.
- **KHÔNG sửa:** `editor_top_bar.dart` (N4-S1).

## Việc cần làm

- [ ] `markdown_lite.dart` — hàm thuần, nhận `(String text, TextSelection sel)` và
  trả `(String text, TextSelection sel)` mới:
  - `toggleInline(text, sel, marker)` — `**đậm**`, `*nghiêng*`, `__gạch chân__`,
    `~~gạch ngang~~` (chọn sẵn vùng → bọc; không chọn → chèn cặp marker + đặt con trỏ giữa).
  - `prefixLine(text, sel, prefix)` — `# `, `## `, `### `, `- `, `1. `, `> `.
  - `insertChecklist(text, sel)` — thêm dòng `- [ ] ` (dùng cho block thật, xem N4-S3).
  - `insertDivider(text, sel)` — thêm `---`.
- [ ] `editor_toolbar.dart` — widget `EditorToolbar({required TextEditingController
  controller, required FocusNode focusNode})`:
  - Nhóm nút: B/I/U/S · H1/H2/H3 · bullet · numbered · **checklist** · quote ·
    divider · ảnh · link · bảng.
  - Nút đang áp dụng cho con trỏ → nền `surfaceContainerHigh` (như nút checklist
    được tô trong `code.html`).
  - Cuối hàng: chú thích "Phím tắt: Tab để thụt dòng".
  - Icon ảnh/link/bảng: chèn placeholder Markdown (`![](url)`, `[text](url)`,
    bảng 2×2) — **chưa** xử lý upload ảnh (ngoài phạm vi Ghi chú).
- [ ] `flutter analyze`.

## Acceptance Criteria

1. *Given* chọn "sáng", *when* bấm **B**, *then* `content` chứa `**sáng**` và vùng
   chọn bao quanh chữ.
2. *Given* không chọn gì, *when* bấm **H2**, *then* dòng hiện tại bắt đầu `## ` và
   con trỏ ở sau tiền tố.
3. *Given* con trỏ trong một dòng bắt đầu `- [ ] `, *then* nút checklist được tô sáng.
4. *Given* bấm divider, *then* `content` có `---` trên dòng riêng.
5. *Given* mọi hàm trong `markdown_lite.dart`, *then* là **hàm thuần** (test ở N5-S1).
6. *Then* `flutter analyze` sạch.

## Kiểm chứng

```powershell
cd flutter_app
flutter analyze
flutter test test/notes_test.dart   # sau N5-S1 (nhóm markdown-lite)
```

## Rủi ro / ghi chú

- Markdown-lite là **văn bản có cú pháp**, không phải rich text thật — khớp phương án A.
  Bảng chỉ chèn khung `| a | b |`; không có UI chỉnh cột (ngoài phạm vi).
- Bọc marker phải idempotent ở mức hợp lý: bấm B lần hai trên cùng vùng nên **bỏ**
  marker (toggle), không lồng `****`.
- Không dùng package markdown ngoài; tự xử lý chuỗi để nhẹ và test được.
