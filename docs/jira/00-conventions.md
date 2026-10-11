# Quy ước backlog — Jira project MD

Áp dụng cho `https://huynhmai2755.atlassian.net`, project key **MD**.
Đây là nguồn chân lý cho mọi file CSV trong `docs/jira/`.

## 1. Issue types & phân cấp

```
Epic  →  { Story, Spike, Bug }  →  Subtask
```

| Type | Dùng khi | Cấp |
|---|---|---|
| Epic | Khối giá trị lớn, kéo dài nhiều sprint | 1 |
| Story | Giao **giá trị cho người dùng**, viết được AC Given/When/Then | 2 (con Epic) |
| Spike | Việc **điều tra**, có **timebox**, output = quyết định/ADR/POC | 2 (con Epic) |
| Subtask | Việc nhỏ nằm trong 1 Story/Spike (≤ 4 giờ) | 3 (con Story/Spike) |
| Bug | Lỗi cần sửa | 2 |

**Quy tắc: KHÔNG dùng `Task` ở cấp riêng.** Trong Jira, `Task` là **anh em** của
`Story` (cùng cấp 2) — dùng song song sẽ chẻ đôi board/velocity/báo cáo. Việc kỹ
thuật không gắn người dùng vẫn là **Story**, hoặc **Subtask** của Story đó.

## 2. Chính sách Subtask — just-in-time

- Chỉ tạo Subtask **khi Story bắt đầu được làm**; **không** tạo hàng loạt (~63) trước.
- Bắt đầu từ **MD-9-S1** → danh sách ở `06-subtasks-md-9-s1.csv`.
- Subtask **bắt buộc có parent** ⇒ **không** import bằng file `.noparent.csv`. Tạo
  bằng `jira-create-subtasks.ps1 -ParentKey <key story>` (hoặc UI: *Add a child issue*).
- Cập nhật `02-stories.md` nếu danh sách subtask đổi.

## 3. Naming

- Epic: `[Khu vực] Tên` — ví dụ `[Platform] Tooling - CI/CD và bảo vệ nhánh`.
- Story / Spike / Subtask: `[Khu vực] Tên` — ví dụ `[CI] Lint + test cho backend (FastAPI)`.
- Khu vực dùng đúng chữ trong ngoặc vuông: `CI`, `Repo`, `Serverpod`, `Test`, `A11y`,
  `Perf`, `i18n`, `Platform`, `Release`, `Ops`…
- Tiếng Việt có dấu; không viết tắt tuỳ tiện.

## 4. Labels

| Nhóm | Giá trị |
|---|---|
| Khu vực | `area:backend`, `area:flutter`, `area:serverpod`, `area:infra` |
| Loại | `type:feature`, `type:infra`, `type:tech-debt`, `type:spike` |
| Chất lượng | `quality`, `ci`, `docs`, `a11y`, `perf`, `release` |
| Rủi ro | `risk:high`, `security` |

- `type:spike` là bắt buộc trên mọi Spike (dùng để **lọc khỏi velocity**).
- Multi-value trong CSV phân tách bằng **dấu phẩy** (bọc cả cell trong `"`).

## 5. Estimate

- Story: Fibonacci `1, 2, 3, 5, 8` (Story ≤ 5; `8` chỉ cho story tích hợp lớn).
- Subtask: ≤ 4 giờ, **không** đánh điểm.
- Spike: timebox 1–2 ngày, **không** đánh điểm ⇒ **không tính vào velocity**.
- Hết timebox **phải kết luận** dù chưa xong.

## 6. Definition of Ready (DoR)

Một Story/Spike vào sprint khi: có AC (hoặc câu hỏi cần trả lời cho Spike), có
estimate; phụ thuộc đã xác định; không còn câu hỏi chặn việc bắt đầu.

## 7. Definition of Done (DoD)

Code + test + `analyze`/lint sạch + PR review 1 người + docs cập nhật (nếu đổi
API/schema) + verify web & mobile + có rollback nếu đổi hạ tầng.

## 8. Import & liên kết parent

- **Import mặc định:** dùng file `.noparent.csv`.
- **Liên kết parent:** chạy `jira-link-parent.ps1` (REST, gắn theo **key**, không
  tạo issue) — xem README.
- **Không** dựa vào cột `Issue Id`/`Parent` trong CSV để auto-link; xem lý do ở
  README, mục *"Vì sao `Issue Id`/`Parent` CSV không gắn được parent"*.
