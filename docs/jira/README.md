# Backlog Jira — Memoir

Thư mục này chứa các artifact để theo dõi dự án Memoir trên Jira
(`https://huynhmai2755.atlassian.net`, project key **MD**).

| File | Nội dung |
|---|---|
| `03-backlog-import.csv` | 15 Epic để import (không có cột `Project Key`) |
| `03-backlog-import.min.csv` | Bản tối giản 2 cột (`Summary`, `Issue Type`) để thử import khi bị lỗi |
| `00-conventions.md` | *(sẽ thêm)* issue types, workflow, DoR/DoD, naming, labels |
| `01-epics.md` | *(sẽ thêm)* epic + link thật sau khi tạo |
| `02-stories.md` | **Batch 1**: Story + Subtask + Acceptance Criteria (MD-9, MD-20, MD-22) |
| `04-stories-batch1.csv` | 19 Story/Spike của Batch 1, có `Issue Id` + `Parent` (Cách 1) |
| `04-stories-batch1.noparent.csv` | Bản không có `Parent`/`Issue Id` (Cách 2 — chắc ăn nhất) |

## Import CSV vào Jira Cloud

1. **Filters → Import issues from CSV**, hoặc **⚙ Settings → System → Import and
   export → External system import → CSV**, hoặc URL trực tiếp
   `https://huynhmai2755.atlassian.net/secure/ImportWizard!default.jspa`.
2. Chọn file `03-backlog-import.csv` → **Next**.
3. Chọn **Project = MD** ở dropdown. CSV **không** có cột `Project Key`: project
   luôn được chọn trong wizard, không map từ file.
4. Ở bước map field, kiểm tra 3 thiết lập dưới đây trước (sai delimiter là
   nguyên nhân phổ biến nhất của lỗi "thiếu Summary"):

| Thiết lập | Giá trị đúng |
|---|---|
| Delimiter | **Comma (`,`)** |
| First line is the header | **Bật** |
| Encoding | **UTF-8** |

Bảng map cột:

| Cột trong CSV | Map tới |
|---|---|
| `Summary` | Summary |
| `Issue Type` | Issue Type |
| `Description` | Description |
| `Labels` | Labels (delimiter của multi-value là dấu phẩy) |
| `Priority` | Priority (`Highest/High/Medium/Low` có sẵn trong Jira) |

5. **Begin import**.

### Nếu vẫn báo "thiếu Summary"
Import thử `03-backlog-import.min.csv` — chỉ có `Summary,Issue Type` và **không
chứa dấu phẩy nào trong Summary**. Nếu file này chạy được thì lỗi nằm ở 3 thiết
lập delimiter/header/encoding, không phải ở dữ liệu.

## Liên kết Story vào Epic khi import

Jira chỉ hiểu cột `Parent` khi có mapping **`Issue Id`** ("You have to define which
CSV column maps to Issue Id if you want to import parents"). Vì vậy có 3 cách:

- **Cách 1 (thử trước):** dùng `04-stories-batch1.csv` — map `Issue Id` → Issue Id
  và `Parent` → Parent. Nếu Jira báo không tìm thấy parent thì chuyển Cách 2.
- **Cách 2 (chắc ăn nhất):** dùng `04-stories-batch1.noparent.csv` (không có
  `Parent`/`Issue Id`). Import xong thì gắn story vào epic trong Jira: mở epic →
  *Issues in epic* → **Add issues**, hoặc kéo story vào nhóm epic ở Backlog view.
- **Cách 3:** project *company-managed* cũ có thể dùng cột `Epic Link` = `MD-9`
  (nhận key của epic đã tồn tại, không cần `Issue Id`).

## Lưu ý

- CSV chỉ có 5 cột: `Summary, Issue Type, Description, Labels, Priority`.
  **Không** có `Project Key` (Jira lấy project từ wizard) và **không** có
  `Epic Name` (bản Jira Cloud hiện tại dùng `Summary` làm tên epic).
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
