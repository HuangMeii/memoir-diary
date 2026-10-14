# N1-S6 · `entries.get(id)`

**Epic:** N1 · **Ước lượng:** 2 pts · **Phụ thuộc:** —
**Nguồn thiết kế:** `ui-figma/taoghichu/code.html` (panel liên kết cần nút
"Mở trang nhật ký" → cần lấy một entry theo id)

## Mục tiêu

Bổ sung endpoint lấy **một** `DiaryEntry` theo id, phục vụ panel liên kết và nút
"Mở trang nhật ký" (hiện chỉ có `byDate`, `list` theo tháng/khoảng).

## Phạm vi

- **Sửa:** `memoir_server/memoir_server_server/lib/src/journal/entries_endpoint.dart`.
- **KHÔNG sửa:** `diary_entry.spy.yaml`; `notes_endpoint.dart`.

## Việc cần làm

- [ ] Thêm `Future<DiaryEntry?> get(Session session, UuidValue id)`.
- [ ] Dùng cùng cách kiểm tra quyền như `byDate` (chỉ trả entry của user hiện tại;
  không thuộc user → trả `null` hoặc ném "not found", khớp hành vi `byDate` hiện có).
- [ ] `serverpod generate` + `dart analyze`.

## Acceptance Criteria

1. *Given* entry E thuộc user A, *when* A gọi `get(E.id)`, *then* trả đúng E.
2. *Given* entry E thuộc user B, *when* A gọi `get(E.id)`, *then* không trả E
   (null/lỗi not-found, **không** lộ nội dung).
3. *Given* id không tồn tại, *then* trả `null` (khớp `byDate` trả null khi thiếu).
4. *Then* `dart analyze` sạch.

## Kiểm chứng

```powershell
cd memoir_server\memoir_server_server
serverpod generate ; dart analyze
Select-String -Path 'lib\src\generated\endpoints.dart' -Pattern "'get'"
```

## Rủi ro / ghi chú

- Nếu `NoteDetail` (N1-S4) đã trả kèm `List<DiaryEntry>`, task này chỉ cần khi
  người dùng bấm **mở** một trang nhật ký cụ thể hoặc gỡ/thêm liên kết cần refresh
  riêng lẻ. Vẫn làm để panel hoạt động độc lập với payload của `NoteDetail`.
- Đặt tên `get` để khớp `entries` domain; client sẽ map qua `GET /entries/{id}` (N2-S1).
