# N5-S2 · Cập nhật tài liệu dự án

**Epic:** N5 · **Ước lượng:** 2 pts · **Phụ thuộc:** N1-S7, N3-S6, N4-S5

## Mục tiêu

Đồng bộ tài liệu dự án với schema/API/UI mới để lần sau đọc lại không bị lệch.

## Phạm vi

- **Sửa:** `docs/03-database-schema.md`, `docs/04-api-reference.md`,
  `docs/UI-design/09-notes.md`, `README.md`, `PLAN.md`.
- **KHÔNG sửa:** `docs/notes/**` (bộ kế hoạch, đã là nguồn chi tiết).

## Việc cần làm

- [ ] `docs/03-database-schema.md` §12 (`notes`): thêm cột `title`, `tags`,
  `is_archived`, `is_trashed`; thêm mục bảng `note_checklist_items` và
  `note_entry_links`; thêm index mới (`idx_notes_user_updated`,
  `idx_notes_user_flags`, `idx_note_checklist_note`).
- [ ] `docs/04-api-reference.md` §11 (Notes): thêm `GET /notes/{id}`,
  `POST /notes/{id}/restore`, `DELETE /notes/{id}/purge`, `PUT /notes/{id}/archive`;
  nêu tham số `archived`/`trashed` của `GET /notes` và việc `DELETE /notes/{id}`
  nay là **soft-delete**.
- [ ] `docs/UI-design/09-notes.md`: thay brief cũ bằng bản khớp thiết kế — bố cục
  tham chiếu `ui-figma/ghichu`, trạng thái, responsive; thêm mục cho trình soạn thảo
  (tham chiếu `ui-figma/taoghichu`) hoặc tách file `09b` nếu thấy dài.
- [ ] `README.md` §features + bảng tài liệu (§5): mô tả Ghi chú nâng cấp (tiêu đề,
  thẻ, checklist, thùng rác, liên kết nhật ký) + link `docs/notes/README.md`.
- [ ] `PLAN.md`: đánh dấu mục Ghi chú đã nâng cấp.
- [ ] Ghi rõ trong PR: **nguồn Stitch** (`ui-figma/ghichu`, `ui-figma/taoghichu`) và
  những gì **chưa** ship (nếu có).

## Acceptance Criteria

1. *Given* đọc `docs/03-database-schema.md` §12, *then* liệt kê đúng cột/bảng/index
   như migration đã áp (N1-S7).
2. *Given* đọc `docs/04-api-reference.md` §11, *then* thấy đủ endpoint mới và ghi chú
   soft-delete, khớp `notes_endpoint.dart`.
3. *Given* đọc `docs/UI-design/09-notes.md`, *then* có mô tả cả hai màn hình + link
   tới ảnh `screen.png` tương ứng.
4. *Given* `README.md`, *then* bảng tài liệu có dòng trỏ tới `docs/notes/README.md`.
5. *Then* không còn câu tài liệu nào nói Ghi chú chỉ có `content`.

## Kiểm chứng

```powershell
cd d:\OldLapData\Memoir
Select-String -Path 'docs\03-database-schema.md','docs\04-api-reference.md','docs\UI-design\09-notes.md','README.md','PLAN.md' -Pattern 'is_trashed|purge|note_checklist_items|docs/notes'
git --no-pager diff --stat
```

## Rủi ro / ghi chú

- Chỉ **cập nhật** tài liệu, không viết lại toàn bộ; diff nên gọn.
- Nếu schema thực tế lệch kế hoạch (ví dụ bỏ `unique` tổ hợp), tài liệu phải phản ánh
  **thực tế**, không phải kế hoạch.
