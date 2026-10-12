# JOURNAL-03 — Ảnh nhật ký

**Nền tảng:** MVP · Mobile + Web

## Thành phần

- Nút thêm ảnh từ gallery/file picker.
- Grid thumbnail.
- Preview ảnh toàn màn hình.
- Caption tùy chọn.
- Menu xóa ảnh và dialog xác nhận.

## States

Empty, uploading progress, loaded, upload failed, delete confirmation.

## Quy tắc

Ảnh thuộc về entry hiện tại; lỗi upload phải giữ nguyên các field nhật ký.

## Thiết kế Figma — `JOURNAL-03 · …`

**Trạng thái: chưa dựng** (đợt "gọn" chỉ dựng `JOURNAL-02` — xem
`07-journal-editor.md`). Trong app, phần này nằm trong màn `JOURNAL-02`
(`ui/widgets/entry_images_section.dart`) chứ không phải màn riêng, nên frame chỉ
cần thể hiện 4 state của khối ảnh. Hai frame web `JOURNAL-02 · Web · Đã có nhật
ký` (`99:118`) và mobile (`99:346`) đã có card "Ảnh kèm theo" ở trạng thái khoá;
khi dựng `JOURNAL-03` thì nhân bản từ đó và thay khối dashed bằng grid thumbnail.


### Frame cần dựng

| Frame | Nội dung |
| --- | --- |
| `JOURNAL-03 · Web · Ảnh kèm theo` | 4 biến thể cạnh nhau trong một frame: `Empty` (khung nét đứt + `Thêm ảnh`) · `Uploading` (thumbnail mờ + progress) · `Loaded` (grid 2×N, nút ✕ trên mỗi ảnh) · `Upload failed` (viền `feedback.error` + dòng lỗi + `Thử lại`) |
| `JOURNAL-03 · Web · Xoá ảnh` | Dialog 420: tiêu đề `Xoá ảnh?`, mô tả `Ảnh sẽ bị xoá khỏi bộ nhớ và không thể khôi phục.`, hai nút `Hủy` / `Xoá` |
| `JOURNAL-03 · Mobile · Ảnh kèm theo` | Cùng 4 biến thể, xếp một cột |

### Spec (đo từ HOME-01 / login)

| Thành phần | Số đo | Token |
| --- | --- | --- |
| Thumbnail | 104×104, radius 12, gap 10 | `border.default` |
| Nút xoá trên ảnh | 28×28 góc trên phải, icon 18 | `surface.card`, `feedback.error` |
| Khung rỗng | nét đứt 1 px, radius 12, cao 104 | `border.default`, `text.secondary` |
| Progress upload | thanh 4 px radius `pill` | `action.primary` trên `border.default` |
| Dialog | 420 rộng, radius 20, padding 24, nút `Xoá` nền `feedback.error` | `surface.card`, `elevation.drop-shadow-3` |

