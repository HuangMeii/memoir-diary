# Quy ước — bộ task Đi chợ / Warm Editorial Canvas

Áp dụng cho mọi file trong `docs/dicho/`. Kế thừa `docs/jira/00-conventions.md`
(Epic → Story/Spike → Subtask, AC Given/When/Then, DoD) và bổ sung phần kỹ thuật
riêng của tính năng Đi chợ.

## 1. Cấu trúc một file task

Mỗi file là **một task nhỏ**, theo đúng thứ tự sau:

```markdown
# <ID> · <Tên task>
**Epic:** DI CHO-01 · **Ước lượng:** <n> pts · **Phụ thuộc:** <ID>
**Nguồn thiết kế:** ui-figma/dicho   (chỉ task UI)

## Mục tiêu
## Phạm vi              (file đụng tới · KHÔNG đụng tới)
## Việc cần làm         (checklist từng bước)
## Acceptance Criteria  (Given/When/Then, đánh số)
## Kiểm chứng           (câu lệnh chạy được)
## Rủi ro / ghi chú
```

- ID theo `DC-<n>` (khớp bảng ở `README.md`).
- Ước lượng theo Fibonacci; task ≤ 5 điểm. Task > 5 phải tách tiếp.
- Mọi task UI **bắt buộc** ghi `Nguồn thiết kế: ui-figma/dicho` + tên section
  trong `code.html` để đối chiếu khi dựng.

## 2. Quy ước code

| Chủ đề | Quy ước |
|---|---|
| Ngôn ngữ | Code/comment **tiếng Anh**; tài liệu/UI **tiếng Việt** (theo `PLAN.md` §6) |
| Flutter | feature-first; Riverpod cho state; repository cho API |
| Font thiết kế | `Newsreader` → `Lora` (`serifFamily`); `Plus Jakarta Sans` → `Inter` (`sansFamily`) |
| Màu thiết kế | Dùng `MemoirPalette` / `Theme.of`; **không** hard-code mã hex Stitch (`#254d36`, `#f7faf5`…) trực tiếp vào widget |
| Khoảng cách & bán kính | Dùng `MemoirSpace` / `MemoirRadius` từ `tokens.dart`; không hard-code px rời rạc |

## 3. DoD của tính năng (áp dụng cho toàn bộ epic)

- [ ] `flutter analyze` sạch (app).
- [ ] `dart format` đã chạy (app).
- [ ] `flutter test` xanh (app).
- [ ] Đã verify trên web (`flutter run -d chrome --web-port 8080`) đối chiếu
  `ui-figma/dicho/screen.png` và `ui-figma/dicho/code.html`.
- [ ] `docs/dicho/README.md`, `docs/dicho/00-conventions.md` đã cập nhật.