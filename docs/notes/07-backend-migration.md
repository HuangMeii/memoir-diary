# N1-S7 · Migration cho model Ghi chú

**Epic:** N1 · **Ước lượng:** 2 pts · **Phụ thuộc:** N1-S5, N1-S6

## Mục tiêu

Sinh migration cho các thay đổi schema của N1-S1…N1-S6 và bảo đảm nó **không mất
dữ liệu** khi áp lên DB Neon thật.

## Phạm vi

- **Sinh mới:** `memoir_server/memoir_server_server/migrations/<timestamp>/`
  (do generator tạo) + cập nhật `migrations/migration_registry.txt`.
- **Được sửa tay:** chỉ `migration.sql` của migration vừa sinh (khi cần index thủ công).
- **KHÔNG sửa:** các file khác trong thư mục migration; `definition.sql` phải khớp
  schema cuối cùng.

## Việc cần làm

- [ ] Trong `memoir_server_server`, chạy `serverpod create-migration`.
- [ ] Rà `migration.sql` sinh ra có đúng:
  - `ALTER TABLE "notes" ADD COLUMN "title" text;`
  - `ADD COLUMN "tags"` (mặc định rỗng), `"isArchived" boolean NOT NULL DEFAULT false`,
    `"isTrashed" boolean NOT NULL DEFAULT false`;
  - `CREATE TABLE "note_checklist_items"` (+ FK cascade tới `notes`);
  - `CREATE TABLE "note_entry_links"` (+ FK cascade tới `notes`, `diary_entries`);
- [ ] Vì mọi cột mới đều nullable hoặc có `DEFAULT`, **không** cần `--force`.
  Nếu generator đòi `--force` ⇒ dừng, đọc SQL và báo lại (dấu hiệu nó định drop cột).
- [ ] Thêm index thủ công (nếu generator không tạo) — chỉ trong `migration.sql`:

```sql
-- Trang danh sách ghi chú sắp theo "mới cập nhật".
CREATE INDEX IF NOT EXISTS "idx_notes_user_updated"
  ON "notes" ("userId", "updatedAt" DESC);
-- Thùng rác / lưu trữ lọc theo cờ.
CREATE INDEX IF NOT EXISTS "idx_notes_user_flags"
  ON "notes" ("userId", "isTrashed", "isArchived");
-- Giữ thứ tự checklist khi đọc 1 note.
CREATE INDEX IF NOT EXISTS "idx_note_checklist_note"
  ON "note_checklist_items" ("noteId", "sortOrder");
```

- [ ] **Đối chiếu**: thêm index vào `definition.sql` **đúng chỗ** để
  `definition.sql` và `migration.sql` cho ra schema giống nhau (DB mới tạo từ
  `definition.sql` và không chạy `migration.sql`).
- [ ] Kiểm tra `migration_registry.txt` có thêm timestamp mới, không trùng.

## Acceptance Criteria

1. *Given* đã sửa model, *when* chạy `serverpod create-migration`, *then* sinh một
   thư mục migration mới + một dòng mới trong `migration_registry.txt`.
2. *Given* `migration.sql`, *then* nó chỉ chứa `ADD COLUMN` (có default) và
   `CREATE TABLE`/`CREATE INDEX` — **không** có `DROP COLUMN`/`DROP TABLE` trên
   bảng có dữ liệu.
3. *Given* DB đang có dữ liệu `notes`, *when* `serverpod start` áp migration,
   *then* số hàng `notes` không đổi và cột mới nhận default.
4. *Then* schema kết thúc của `migration.sql` khớp `definition.sql`
   (so `notes`, `note_checklist_items`, `note_entry_links` + index).
5. *Then* `dart test` (nhóm notes) chạy được sau khi migration áp vào DB test.

## Kiểm chứng

```powershell
cd memoir_server\memoir_server_server
serverpod create-migration
Get-ChildItem migrations | Select-Object Name
Get-Content (Get-ChildItem migrations | Sort-Object Name | Select-Object -Last 1 | ForEach-Object { Join-Path $_.FullName 'migration.sql' })
# apply là bước của bạn:
# serverpod start
```

## Rủi ro / ghi chú

- **Đây là bước chạm DB thật** khi `serverpod start`. Trước khi apply, đọc kỹ
  `migration.sql`; nếu muốn an toàn, chạy trên nhánh Neon tạm hoặc backup trước.
- Nếu generator tạo `definition.sql` khác `migration.sql` ở phần index, sửa
  `definition.sql` cho khớp (index là phần duy nhất được thêm tay).
- Index `idx_notes_user (user_id, created_at DESC)` cũ (nếu có) giữ nguyên; index
  mới phục vụ sắp theo `updatedAt`.
