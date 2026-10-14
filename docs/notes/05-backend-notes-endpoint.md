# N1-S5 · Endpoint `notes` mở rộng

**Epic:** N1 · **Ước lượng:** 5 pts · **Phụ thuộc:** N1-S4
**Nguồn thiết kế:** `ui-figma/ghichu` (ghim, lưu trữ, thùng rác, thẻ) +
`ui-figma/taoghichu` (tự động lưu, checklist, màu, ghim, liên kết)

## Mục tiêu

Mở rộng `NotesEndpoint` để phục vụ toàn bộ hành vi thiết kế: đọc theo bộ lọc, lấy
chi tiết, tạo/sửa đầy đủ field, reconcile checklist + liên kết, soft-delete và
khôi phục/xoá vĩnh viễn.

## Phạm vi

- **Sửa:** `memoir_server/memoir_server_server/lib/src/notes/notes_endpoint.dart`.
- **Phụ thuộc:** model `Note`, `NoteChecklistItem`, `NoteEntryLink`, `NoteDetail`.
- **KHÔNG sửa:** file generated; `note.spy.yaml` (đã xong ở N1-S1).

## Việc cần làm

- [ ] `list(session, {bool includeArchived = true, bool trashedOnly = false})`:
  lọc `isTrashed == trashedOnly`, `isArchived` theo cờ; sắp xếp
  `isPinned desc, updatedAt desc` (thay vì `createdAt desc` hiện tại).
- [ ] `get(session, UuidValue id) -> NoteDetail`: note + checklist (theo `sortOrder`)
  + `DiaryEntry` liên kết; dùng `ensureOwned`.
- [ ] `create(...)`: thêm `title`, `tags`, `checklist` (`List<NoteChecklistItem>`),
  `entryIds` (`List<UuidValue>`); `isArchived`/`isTrashed` mặc định false.
- [ ] `update(...)`: thêm `title`, `tags`, `isArchived`, `isTrashed`; **reconcile**
  checklist (xoá item không còn id, update item có id, insert item mới với
  `sortOrder` theo vị trí) và links (`entryIds` là danh sách cuối cùng).
  `updatedAt = DateTime.now().toUtc()` như hiện tại.
- [ ] `restore(session, UuidValue id)`: `isTrashed = false`.
- [ ] `archive(session, UuidValue id, bool isArchived)`: đặt cờ (dùng cho
  "Đã lưu trữ" / bỏ lưu trữ).
- [ ] `purge(session, UuidValue id)`: xoá cứng (chỉ khi đang ở thùng rác).
- [ ] Đổi `delete` hiện tại thành **soft-delete** (`isTrashed = true`).
- [ ] Giữ `requireLogin = true`, `currentUserId(session)`, `_owned`/`ensureOwned`.
- [ ] `serverpod generate` + `dart analyze`.

Chữ ký gợi ý (giữ tên tham số camelCase như client generator):

```dart
Future<List<Note>> list(Session session, {bool includeArchived, bool trashedOnly});
Future<NoteDetail> get(Session session, UuidValue id);
Future<Note> create(Session session, {
  required String content,
  String? title, String? color, List<String>? tags, bool? isPinned,
  List<NoteChecklistItem>? checklist, List<UuidValue>? entryIds,
});
Future<Note> update(Session session, {
  required UuidValue id, String? title, String? content, String? color,
  List<String>? tags, bool? isPinned, bool? isArchived, bool? isTrashed,
  List<NoteChecklistItem>? checklist, List<UuidValue>? entryIds,
});
Future<void> restore(Session session, UuidValue id);
Future<Note> archive(Session session, UuidValue id, bool isArchived);
Future<void> purge(Session session, UuidValue id);
Future<void> delete(Session session, UuidValue id);   // soft-delete
```

## Acceptance Criteria

1. *Given* user A đăng nhập, *when* `list()`, *then* chỉ thấy note của A và note
   đã ghim đứng trước, sắp theo `updatedAt` giảm dần.
2. *Given* `trashedOnly: true`, *then* chỉ trả note `isTrashed == true`;
   `includeArchived: false` loại note `isArchived == true`.
3. *Given* `get(id)` của note có 3 checklist item và 2 entry liên kết, *then* trả
   `checklist` đúng thứ tự `sortOrder` và `entries` đủ 2 phần tử.
4. *Given* `update` với `checklist` mới, *then* item bị bỏ khỏi danh sách bị xoá,
   item giữ id được update, item mới được thêm — tổng khớp danh sách gửi lên.
5. *Given* `update` với `entryIds: []`, *then* mọi liên kết cũ bị gỡ.
6. *Given* `delete(id)`, *then* note chuyển `isTrashed = true` và **vẫn** hiện khi
   `trashedOnly: true`; `restore(id)` đưa lại danh sách thường; `purge(id)` xoá hẳn.
7. *Given* user B gọi `get/update/delete` trên note của A, *then* bị từ chối
   (`ensureOwned` ném lỗi, không lộ dữ liệu).
8. *Then* `dart analyze` sạch, `serverpod generate` không lỗi.

## Kiểm chứng

```powershell
cd memoir_server\memoir_server_server
serverpod generate ; dart analyze ; dart format .
# sau khi N1-S8 xong:
dart test test/integration/notes_endpoint_test.dart
```

## Rủi ro / ghi chú

- **Reconcile checklist/links phải chạy trong transaction** (`session.db.transaction`)
  để tránh nửa vời khi lỗi giữa chừng.
- Đổi `delete` sang soft-delete là **thay đổi hành vi** với client hiện tại (UI cũ
  gọi `DELETE /notes/{id}`); UI mới (N3/N4) hiểu thùng rác, nên đổi cùng đợt.
- `updatedAt` dùng `toUtc()` như code hiện tại để nhất quán với các domain khác.
