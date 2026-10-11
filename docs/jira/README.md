# Backlog Jira — Memoir

Thư mục này chứa các artifact để theo dõi dự án Memoir trên Jira
(`https://huynhmai2755.atlassian.net`, project key **MD**).

| File | Nội dung |
|---|---|
| `03-backlog-import.csv` | 15 Epic để import (không có cột `Project Key`) |
| `03-backlog-import.min.csv` | Bản tối giản 2 cột (`Summary`, `Issue Type`) để thử import khi bị lỗi |
| `00-conventions.md` | Issue types, phân cấp, DoR/DoD, naming, labels, estimate, chính sách import |
| `01-epics.md` | *(sẽ thêm)* epic + link thật sau khi tạo |
| `02-stories.md` | **Batch 1**: Story + Subtask + Acceptance Criteria (MD-9, MD-20, MD-22) |
| `04-stories-batch1.noparent.csv` | ✅ **Mặc định** — 19 Story/Spike Batch 1 (không `Issue Id`/`Parent`) |
| `05-spikes.noparent.csv` | ✅ **Mặc định** — 10 Spike cho epic sắp làm (MD-11/17/18/19/20/21/23) |
| `06-subtasks-md-9-s1.csv` | 4 Subtask của `MD-9-S1` (tạo just-in-time bằng script bên dưới) |
| `jira-link-parent.ps1` | Script REST gắn `Parent` theo **key** (có `-DryRun`, **không** tạo issue) |
| `jira-create-subtasks.ps1` | Script REST tạo Subtask dưới 1 Story (có `-DryRun`, chống trùng) |
| `04-stories-batch1.csv` | ⚠️ Không khuyến nghị — có `Issue Id`/`Parent` để thử auto-link |
| `05-spikes.csv` | ⚠️ Không khuyến nghị — có `Issue Id`/`Parent` để thử auto-link |

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

## Liên kết Story/Spike vào Epic

**Mặc định:** import file `.noparent.csv` (không có `Issue Id`/`Parent`), rồi gắn
parent bằng script `jira-link-parent.ps1` (mục *"Gắn parent tự động"*).

### Vì sao `Issue Id`/`Parent` trong CSV **không** gắn được parent

Cơ chế parent của CSV import chỉ hoạt động **trong nội bộ một file**:

- `Issue Id` là *"reference number **solely designated within the CSV**"* — **không
  phải field Jira**; Jira không lưu nó ở đâu ⇒ bạn **không thấy tác dụng** của nó.
- Cột `Parent` phải chứa **Issue ID nội bộ của file CSV**, **không phải issue key**.
  Đặt `MD-11` (key) vào `Parent` ⇒ **không match** ⇒ phải gắn tay. (Atlassian KB:
  *"Confirm you used the parent's Issue ID (the numeric ID) … not the Issue key"*.)
- Parent phải **nằm trên** child trong file (importer xử lý từ trên xuống).
- Muốn trỏ tới epic **đã tồn tại** phải thêm **dòng placeholder** cho epic đó và gán
  `Issue Id` số ⇒ **rủi ro tạo epic trùng / ghi đè field**.

Ngoài ra cột `Issue ID`/`Parent` **có thể không xuất hiện** trong wizard nếu thiếu
điều kiện tiên quyết (Atlassian KB):

- Bật **Sub-Tasks**: `Settings → Work items → Sub-Tasks`.
- Thêm field **Linked Issues** vào **mọi screen** của project.
- Nếu vẫn lỗi: dùng **`Settings → System → External system import` → *Switch to the
  old experience*** (liên quan bug đang mở **JRACLOUD-92272**).

> Kết luận: **không** dùng `Issue Id`/`Parent` trong CSV để auto-link.
> `04-stories-batch1.csv` và `05-spikes.csv` chỉ giữ để tham chiếu.

### Gắn parent tự động (khuyến nghị)

```powershell
$env:JIRA_EMAIL    = 'you@example.com'
$env:JIRA_API_TOKEN = '***'           # tạo ở id.atlassian.com → API tokens
./docs/jira/jira-link-parent.ps1 -Csv ./docs/jira/05-spikes.csv -DryRun   # xem trước
./docs/jira/jira-link-parent.ps1 -Csv ./docs/jira/05-spikes.csv           # gắn thật
```

Script chỉ `GET` + `PUT …/parent` theo **key** ⇒ **không thể tạo epic trùng**.
Lấy API token: https://id.atlassian.com/manage-profile/security/api-tokens

### Gắn parent thủ công (khi không dùng token)

- **Backlog** → *Group by: Epic* → kéo issue vào nhóm epic, hoặc
- Mở epic → **Issues in epic → Add issues** (chọn nhiều), hoặc
- JQL `project = MD AND labels = "type:spike"` → **Bulk change** (nếu field `Parent`
  cho bulk edit).

## Tạo Subtask (just-in-time)

**Vì sao không import CSV:** Subtask **bắt buộc có parent**, nên file
`06-subtasks-*.csv` **không** import trực tiếp được (khác Story/Spike) — import kiểu
`.noparent` sẽ bị Jira từ chối. Dùng script REST bên dưới.

### 1) Xác định Story cha

**Cách A (khỏi cần biết key)** — truyền Summary, script tự tra key:

```powershell
./docs/jira/jira-create-subtasks.ps1 -ParentSummary '[CI] Lint + test cho backend (FastAPI)' -Csv ./docs/jira/06-subtasks-md-9-s1.csv -DryRun
```

**Cách B** — lấy key thật rồi truyền `-ParentKey`. `02-stories.md` dùng id nội bộ
(`MD-9-S1`); Jira cấp key thật (`MD-24`…). Lấy key:

```powershell
./docs/jira/jira-link-parent.ps1 -Csv ./docs/jira/04-stories-batch1.csv -DryRun
# -> xem cột Key của story "[CI] Lint + test cho backend (FastAPI)"
```

> ⚠️ Mọi key xuất hiện trong tài liệu (`MD-24`, `MD-9`, `MD-11`…) chỉ là **ví dụ /
> placeholder**. Luôn lấy key thật bằng Cách A hoặc B.

### 2) Tạo Subtask — ⚠️ script này **CÓ tạo issue**

```powershell
$env:JIRA_EMAIL     = 'you@example.com'
$env:JIRA_API_TOKEN = '***'
./docs/jira/jira-create-subtasks.ps1 -ParentSummary '[CI] Lint + test cho backend (FastAPI)' -Csv ./docs/jira/06-subtasks-md-9-s1.csv -DryRun
./docs/jira/jira-create-subtasks.ps1 -ParentSummary '[CI] Lint + test cho backend (FastAPI)' -Csv ./docs/jira/06-subtasks-md-9-s1.csv
```

- Script verify parent tồn tại; lấy **issue type từ `createmeta`** (id đúng cho API
  create — dùng id từ `/project/{key}` có thể bị **400**); **chống trùng** theo
  `Summary` ⇒ chạy lại ra `SKIP`.
- Chỉ tạo `Subtask` dưới parent đã tồn tại ⇒ **không thể sinh epic trùng**.
- Lỗi Jira được **in nguyên văn** (cột `Note` + mục "Chi tiết lỗi"), và script tự
  **bỏ field gây lỗi rồi thử lại 1 lần** (self-heal).
- `-ShowPayload` in JSON gửi đi để tự đối chiếu.
- Không muốn dùng token: mở Story → **Add a child issue** → dán từng Summary.

### 3) Lỗi thường gặp

| Mã | Nguyên nhân | Cách xử lý |
|---|---|---|
| **401** | Token sai / đã revoke / hết hạn, hoặc `$env:JIRA_EMAIL` không khớp tài khoản | Tạo token mới, set lại biến trong **đúng cửa sổ** |
| **401 ở `api.atlassian.com`** | Token **classic** (không scopes) không dùng được gateway | Dùng domain site, hoặc tạo token **có scopes** |
| **403** | Tài khoản không có quyền tạo/sửa issue trong project | Kiểm tra quyền trong project `MD` |
| **404** | Không thấy project/issue: sai key, hoặc token thuộc **tài khoản khác** | Lấy key thật (Cách A/B); kiểm tra tài khoản của token |
| **400** *"target project doesn't exist…"* | `issuetype` id sai (project-scoped) | Bản v2 đã tự lấy id từ `createmeta` |
| **Token có scopes** | Phải gọi qua `api.atlassian.com/ex/jira/{cloudId}` | Thêm `-BaseUrl https://api.atlassian.com/ex/jira/<cloudId>` |

## Spike — khi nào dùng

- **Story** = giao được **giá trị cho người dùng** (có AC dạng Given/When/Then).
- **Spike** = việc **điều tra**, có **timebox**, kết quả là **quyết định/kiến thức**
  (ADR, POC vứt đi, ước lượng) — *không* tạo ra hành vi mới cho người dùng.

Quy tắc nhanh: nếu **không viết được AC Given/When/Then** mà chỉ viết được
*“trả lời câu hỏi X / chọn phương án Y”* → đó là **Spike**.

Lưu ý khi quản lý:

- Spike **không tính vào velocity** — lọc theo label `type:spike` để loại khỏi báo cáo.
- Hết timebox **phải kết luận** dù chưa xong.
- Kết quả của mỗi spike thường **sinh ra 1 Story mới** kèm ước lượng.
- Dòng `[i18n] Spike: tách chuỗi hay không?` trong `04-stories-batch1.csv` đã là
  `Issue Type = Spike` → map thẳng `Spike → Spike` (issue type `Spike` đã được tạo
  trong project).
- `05-spikes.noparent.csv` chứa 10 spike cho các epic sắp làm; import **sau** khi
  các epic `MD-11/17/18/19/20/21/23` đã tồn tại, rồi gắn parent bằng script.

### Import spike — `05-spikes.noparent.csv`

1. Dùng **`05-spikes.noparent.csv`** (khuyến nghị) — import như bảng ở trên.
   `05-spikes.csv` (có `Issue Id`/`Parent`) **không** auto-link được, xem mục trên.
2. Sau khi import, gắn parent vào `MD-11/17/18/19/20/21/23` bằng
   `jira-link-parent.ps1 -Csv ./docs/jira/05-spikes.csv` (hoặc gắn thủ công).
3. File **không** có `Story Points` — spike không tính vào velocity.

## Lưu ý

- `03-backlog-import.csv` (epic) chỉ có 5 cột: `Summary, Issue Type, Description,
  Labels, Priority`. **Không** có `Project Key` (Jira lấy project từ wizard) và
  **không** có `Epic Name` (bản Jira Cloud hiện tại dùng `Summary` làm tên epic).
- `04-stories-batch1.csv` thêm `Issue Id`, `Parent`, `Story Points`;
  `05-spikes.csv` thêm `Issue Id`, `Parent`. Hai file này **không khuyến nghị**:
  `Issue Id` chỉ là số tham chiếu nội bộ CSV, và `Parent` cần **Issue ID** (không
  phải key) — xem mục *"Vì sao `Issue Id`/`Parent` …"*.
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
