# N1-S8 · Integration test endpoint `notes`

**Epic:** N1 · **Ước lượng:** 3 pts · **Phụ thuộc:** N1-S7
**Nguồn mẫu:** `memoir_server/memoir_server_server/test/integration/auth_endpoint_test.dart`

## Mục tiêu

Phủ các luồng CRUD mới của `NotesEndpoint` (ghim, lưu trữ, thùng rác, checklist,
liên kết, cách ly user) bằng test tích hợp chạy trên PostgreSQL nhúng của Serverpod
(`config/test.yaml` đã đặt `database.dataPath`, **không cần Docker**).

## Phạm vi

- **Tạo mới:** `memoir_server/memoir_server_server/test/integration/notes_endpoint_test.dart`.
- **Được dùng:** `test/integration/test_tools/serverpod_test_tools.dart`.
- **KHÔNG sửa:** `auth_endpoint_test.dart`.

## Việc cần làm

- [ ] Bắt chước setup/teardown của `auth_endpoint_test.dart` (tạo user, đăng nhập,
  lấy session).
- [ ] Test nhóm A — đọc: `list` sắp ghim trước; `trashedOnly`; `includeArchived`.
- [ ] Test nhóm B — tạo/sửa: tạo với `title/tags/checklist/entryIds`; `update`
  reconcile checklist (thêm/giữ/xoá) và `entryIds: []` gỡ hết liên kết.
- [ ] Test nhóm C — vòng đời: `delete` → nằm trong thùng rác → `restore` → quay lại
  → `purge` → không còn; `archive` đặt cờ.
- [ ] Test nhóm D — cách ly: user B không đọc/sửa/xoá được note của user A.
- [ ] Chạy `dart test` và giữ runtime ≤ 1 phút.

## Acceptance Criteria

1. *Given* hai note (một ghim), *when* `list()`, *then* note ghim đứng đầu.
2. *Given* `update` gửi checklist mới thiếu một item, *then* item đó bị xoá và
   `get(id).checklist` khớp danh sách gửi lên (đúng thứ tự).
3. *Given* `delete` rồi `list(trashedOnly: true)`, *then* note xuất hiện;
   `restore` rồi `list()`, *then* note trở lại và không còn trong thùng rác.
4. *Given* `purge`, *then* `get(id)` không tìm thấy.
5. *Given* user B gọi `get/update/delete` trên note của A, *then* test khẳng định
   bị từ chối và **không** trả dữ liệu của A.
6. *Then* `dart test` xanh, không cần Docker.

## Kiểm chứng

```powershell
cd memoir_server\memoir_server_server
dart test test/integration/notes_endpoint_test.dart
dart analyze
```

## Rủi ro / ghi chú

- File test cần **đăng nhập giả** như `auth_endpoint_test.dart`; đừng dựa vào user
  có sẵn trong DB thật.
- Nếu nhóm C phụ thuộc transaction của N1-S5, thêm test "lỗi giữa chừng không để lại
  trạng thái nửa vời" (tuỳ chọn).
- Giữ test **độc lập thứ tự** (mỗi test tự tạo dữ liệu riêng) để chạy song song được.
