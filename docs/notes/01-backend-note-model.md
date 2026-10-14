# N1-S1 · Mở rộng model `Note`

**Epic:** N1 · **Ước lượng:** 2 pts · **Phụ thuộc:** —
**Nguồn thiết kế:** `ui-figma/ghichu/screen.png` (tiêu đề card, thẻ, filter
"Đã ghim" / "Đã lưu trữ", nút "Xem thùng rác")

## Mục tiêu

Bổ sung vào bảng `notes` những cột mà thiết kế cần nhưng schema hiện tại chưa có:
`title`, `tags`, `isArchived`, `isTrashed`. Giữ nguyên `content`, `color`,
`isPinned`, `createdAt`, `updatedAt`.

## Phạm vi

- **Sửa:** `memoir_server/memoir_server_server/lib/src/notes/note.spy.yaml`.
- **KHÔNG sửa:** `lib/src/generated/**`, `memoir_server_client/**` (generator ghi
  đè), `notes_endpoint.dart` (task N1-S5).

## Việc cần làm

- [ ] Thêm `title: String?` (tiêu đề riêng; `content` vẫn là thân note).
- [ ] Thêm `tags: List<String>, default=[]` (thẻ `#DuLịch`, `#CôngViệc`…).
- [ ] Thêm `isArchived: bool, default=false` (filter "Đã lưu trữ").
- [ ] Thêm `isTrashed: bool, default=false` (thùng rác).
- [ ] Chạy `serverpod generate` để sinh lại model + client.
- [ ] Xác nhận `generated/notes/note.dart` có đủ field mới và `default` hoạt động.

Nội dung `.spy.yaml` sau khi sửa:

```yaml
### Quick note.
class: Note
table: notes
fields:
  id: UuidValue?, defaultPersist=random_v7
  userId: UuidValue, relation(parent=users, onDelete=Cascade)
  ### Tiêu đề riêng; `content` giữ vai trò thân ghi chú.
  title: String?
  content: String
  color: String?
  ### Thẻ tự do, không phân cấp; UI hiển thị dạng `#tag`.
  tags: List<String>, default=[]
  isPinned: bool, default=false
  isArchived: bool, default=false
  isTrashed: bool, default=false
  createdAt: DateTime, default=now
  updatedAt: DateTime, default=now
```

## Acceptance Criteria

1. *Given* `.spy.yaml` đã sửa, *when* chạy `serverpod generate`, *then* lệnh kết
   thúc mã 0 và `lib/src/generated/notes/note.dart` chứa `title`, `tags`,
   `isArchived`, `isTrashed`.
2. *Given* một `Note` mới tạo không truyền `tags`/`isArchived`/`isTrashed`,
   *then* `tags == const []`, `isArchived == false`, `isTrashed == false`.
3. *Then* `memoir_server_client` export `Note` có đủ field mới (client build được).
4. *Then* `dart analyze` trong `memoir_server_server` sạch.

## Kiểm chứng

```powershell
cd memoir_server\memoir_server_server
serverpod generate
dart analyze
```

Kiểm tra nhanh: `Select-String -Path 'lib\src\generated\notes\note.dart' -Pattern 'isTrashed|List<String>'`

## Rủi ro / ghi chú

- `content` giữ `NOT NULL` để không phá dữ liệu hiện có; ghi chú "chỉ có tiêu đề"
  vẫn lưu `content` là chuỗi rỗng.
- `List<String>` đã được backend này dùng (`weather_forecast.spy.yaml` có
  `daily: List<WeatherDay>`), nên generator hỗ trợ sẵn.
- Chưa thêm index; index mới thuộc task N1-S7.
