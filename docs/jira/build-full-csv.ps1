# Gộp toàn bộ backlog Jira thành 1 file CSV hoàn chỉnh: docs/jira/jira-full-backlog.csv
# Cột: Summary, Issue Type, Description, Labels, Priority, Story Points, Parent (sau import)
# Lưu UTF-8 không BOM. Chạy: powershell -ExecutionPolicy Bypass -File docs\jira\build-full-csv.ps1
$ErrorActionPreference = 'Stop'
$dir = Split-Path -Parent $MyInvocation.MyCommand.Path

$epics    = Import-Csv (Join-Path $dir '03-backlog-import.csv')
$stories  = Import-Csv (Join-Path $dir '04-stories-batch1.noparent.csv')
$spikes   = Import-Csv (Join-Path $dir '05-spikes.noparent.csv')
$subtasks = Import-Csv (Join-Path $dir '06-subtasks-md-9-s1.csv')

# ---- 2 issue mới cho đợt này (cập nhật sau khi code xong) ----
$batch2 = @(
  [pscustomobject]@{
    Summary        = '[Journal] Dựng trang Nhật ký theo Figma JOURNAL-02'
    'Issue Type'   = 'Story'
    Description    = 'Rebuild entry_editor theo frame Figma JOURNAL-02 (97:3, 99:118, 99:460, 99:574, 99:688, 99:232, 99:346): save-bar sticky 72px (Trạng thái + Huỷ + Lưu nhật ký 160x52), banner Đã lưu/Lỗi lưu, dialog Rời màn khi chưa lưu 3 nút, 2 cột 884+24+300 trên content 1208, cột trái 9 field + block "2 câu hôm nay", cột phải card Ngày đang ghi / Thời tiết / Cảm xúc / Ảnh kèm theo, responsive 1 cột dưới 1024. Acceptance: dart analyze 0 issue; đúng token surface.card/border.default/radius 20-10; states New/Existing/Saving/Saved/Error/Leave dialog đều có.'
    Labels         = 'area:flutter,type:feature,journal-02'
    Priority       = 'Highest'
    'Story Points' = '5'
    'Parent (sau import)' = 'Epic [Journal] Nhật ký và ảnh'
  },
  [pscustomobject]@{
    Summary        = '[Quotes][Bug] Home hiển thị đủ 2 câu khi kho self message < 10'
    'Issue Type'   = 'Bug'
    Description    = 'Server ghép quote + quote2 khi selfCount < 10 (daily_quotes_endpoint.dart) nhưng UI chỉ render câu lớn + dòng note nên câu quote2 bị ẩn. Fix _QuoteBody: có quote2 thì divider + label "Câu thứ hai dành cho bạn" + câu nhỏ (body) + tác giả; có self message thì giữ nguyên 1 lớn + lời nhắn. Acceptance: DailyQuotePair.hasQuote2=true hiện đủ 2 câu trên web/mobile; 39 tests pass.'
    Labels         = 'area:flutter,type:bug,quotes'
    Priority       = 'High'
    'Story Points' = '2'
    'Parent (sau import)' = 'Epic [Quotes] Kho câu - cặp câu và phản tư'
  }
)

$out = @()

foreach ($e in $epics) {
  $out += [pscustomobject]@{
    Summary = $e.Summary; 'Issue Type' = $e.'Issue Type'; Description = $e.Description
    Labels = $e.Labels; Priority = $e.Priority; 'Story Points' = ''; 'Parent (sau import)' = ''
  }
}
foreach ($s in $stories) {
  $out += [pscustomobject]@{
    Summary = $s.Summary; 'Issue Type' = $s.'Issue Type'; Description = $s.Description
    Labels = $s.Labels; Priority = $s.Priority; 'Story Points' = $s.'Story Points'; 'Parent (sau import)' = ''
  }
}
foreach ($s in $batch2) { $out += $s }
foreach ($s in $spikes) {
  $out += [pscustomobject]@{
    Summary = $s.Summary; 'Issue Type' = $s.'Issue Type'; Description = $s.Description
    Labels = $s.Labels; Priority = $s.Priority; 'Story Points' = ''; 'Parent (sau import)' = ''
  }
}
foreach ($t in $subtasks) {
  $out += [pscustomobject]@{
    Summary = $t.Summary; 'Issue Type' = $t.'Issue Type'; Description = $t.Description
    Labels = $t.Labels; Priority = $t.Priority; 'Story Points' = ''
    'Parent (sau import)' = 'MD-9-S1 (Story: [CI] Lint + test cho backend (FastAPI))'
  }
}

$dest = Join-Path $dir 'jira-full-backlog.csv'
$out | Export-Csv -Path $dest -NoTypeInformation -Encoding UTF8
# Bỏ BOM để Jira đọc đúng
$text = [IO.File]::ReadAllText($dest)
[IO.File]::WriteAllText($dest, $text, (New-Object Text.UTF8Encoding($false)))

$counts = $out | Group-Object 'Issue Type' | ForEach-Object { "$($_.Name)=$($_.Count)" }
Write-Host "Wrote $dest — $($out.Count) rows — $($counts -join ', ')"
