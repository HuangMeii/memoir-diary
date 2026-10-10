# Backlog Jira — Memoir

Thư mục này chứa các artifact để theo dõi dự án Memoir trên Jira
(`https://huynhmai2755.atlassian.net`, project key **MD**).

| File | Nội dung |
|---|---|
| `03-backlog-import.csv` | 15 Epic, import trực tiếp vào Jira |
| `00-conventions.md` | *(sẽ thêm)* issue types, workflow, DoR/DoD, naming, labels |
| `01-epics.md` | *(sẽ thêm)* epic + link thật sau khi tạo |
| `02-stories.md` | *(sẽ thêm)* story + subtask + acceptance criteria |

## Import CSV vào Jira Cloud

1. Jira → menu **Filters** → **Import issues from CSV** (hoặc trong project:
   **Project settings → Import**).
2. Chọn file `03-backlog-import.csv` → **Next**.
3. Ở bước map field:

| Cột trong CSV | Map tới |
|---|---|
| `Project Key` | Project key (giá trị `MD`) |
| `Issue Type` | Issue Type |
| `Summary` | Summary |
| `Epic Name` | Epic Name — nếu project đã bỏ field này thì chọn **Do not map** (Jira dùng Summary làm tên epic) |
| `Description` | Description |
| `Labels` | Labels — **delimiter của multi-value là dấu phẩy** |
| `Priority` | Priority (`Highest/High/Medium/Low` có sẵn trong Jira) |

4. **Begin import**.

## Lưu ý

- Số issue thật do Jira sinh; nếu project `MD` đã có issue khác thì epic mới
  **không** bắt đầu ở `MD-1`. Sau khi import, cập nhật lại link thật vào
  `01-epics.md`.
- CSV lưu **UTF-8 (không BOM)** để Jira đọc đúng tiếng Việt. Nếu mở bằng Excel
  trước, dùng *Data → From Text/CSV* và chọn encoding UTF-8, nếu không sẽ lỗi
  dấu.
- `Fix Version` chưa đưa vào CSV vì project chưa tạo version `v0.1…v1.0`; tạo
  version trong Jira trước rồi gán sau.
- Các epic **ưu tiên xử lý trước**: `Tooling and CI/CD`, `Serverpod Migration`,
  `Quality`.
