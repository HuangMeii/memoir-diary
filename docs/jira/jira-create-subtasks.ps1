#requires -Version 5.1
<#
.SYNOPSIS
    Tao Subtask trong Jira Cloud duoi mot Story/Spike DA TON TAI.

.DESCRIPTION
    Script nay CO TAO issue (khac jira-link-parent.ps1 chi doc/sua). No luon tao
    issuetype co subtask = true duoi mot parent DA duoc xac minh ton tai, nen khong
    the sinh epic trung. Chay lai se SKIP cac subtask da co (so theo Summary).

.PARAMETER ParentKey
    Key that cua Story/Spike cha, vi du MD-24. Lay key bang:
    ./docs/jira/jira-link-parent.ps1 -Csv ./docs/jira/04-stories-batch1.csv -DryRun

.PARAMETER ParentSummary
    Summary cua Story/Spike cha; script se tu tra key (khop chinh xac).

.PARAMETER Csv
    CSV danh sach subtask (can cot Summary; tuy chon Description, Labels, Priority).

.PARAMETER ShowPayload
    In JSON se gui cho Jira truoc moi lan tao.

.PARAMETER DryRun
    Chi in ke hoach, khong tao.

.EXAMPLE
    $env:JIRA_EMAIL = 'you@example.com'
    $env:JIRA_API_TOKEN = '***'
    ./docs/jira/jira-create-subtasks.ps1 -ParentSummary '[CI] Lint + test cho backend (FastAPI)' -Csv ./docs/jira/06-subtasks-md-9-s1.csv -DryRun
#>
[CmdletBinding()]
param(
    [string]$Email      = $env:JIRA_EMAIL,
    [string]$Token      = $env:JIRA_API_TOKEN,
    [string]$BaseUrl    = 'https://huynhmai2755.atlassian.net',
    [string]$ParentKey,
    [string]$ParentSummary,
    [Parameter(Mandatory = $true)][string]$Csv,
    [string]$ProjectKey = 'MD',
    [int]$SearchLimit   = 50,
    [switch]$ShowPayload,
    [switch]$DryRun
)

Set-StrictMode -Version 2.0
$ErrorActionPreference = 'Stop'
[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12

if (-not $Email) { throw 'Thieu email. Dat $env:JIRA_EMAIL hoac truyen -Email.' }
if (-not $Token) { throw 'Thieu API token. Dat $env:JIRA_API_TOKEN hoac truyen -Token.' }
if (-not (Test-Path -LiteralPath $Csv)) { throw "Khong tim thay CSV: $Csv" }
if (-not $ParentKey -and -not $ParentSummary) { throw 'Thieu parent: truyen -ParentKey MD-xx hoac -ParentSummary "..."' }
if ($ParentKey -and $ParentSummary) { throw 'Chi truyen mot trong -ParentKey hoac -ParentSummary.' }

$BaseUrl = $BaseUrl.TrimEnd('/')
$auth = [Convert]::ToBase64String([Text.Encoding]::UTF8.GetBytes("${Email}:${Token}"))
$Headers = @{ Authorization = "Basic $auth"; Accept = 'application/json' }

function Invoke-Jira {
    param([string]$Method, [string]$Path, $Body)
    $p = @{ Method = $Method; Uri = "$BaseUrl$Path"; Headers = $Headers; ContentType = 'application/json; charset=utf-8' }
    if ($null -ne $Body) {
        # Gui bytes UTF-8: tranh PowerShell 5.1 ma hoa sai tieng Viet trong body.
        $p.Body = [Text.Encoding]::UTF8.GetBytes(($Body | ConvertTo-Json -Depth 20 -Compress))
    }
    Invoke-RestMethod @p
}

# Jira tra than loi JSON nhung Invoke-RestMethod thuong nuot mat -> doc lai.
function Get-ApiErrorBody {
    param($ErrorRecord)
    $msg = ''
    try { if ($ErrorRecord.ErrorDetails -and $ErrorRecord.ErrorDetails.Message) { $msg = "$($ErrorRecord.ErrorDetails.Message)" } } catch { }
    if (-not $msg) {
        try {
            $resp = $ErrorRecord.Exception.Response
            if ($resp) {
                $sr = New-Object System.IO.StreamReader($resp.GetResponseStream())
                $msg = $sr.ReadToEnd()
                $sr.Dispose()
            }
        } catch { }
    }
    if (-not $msg) { $msg = "$($ErrorRecord.Exception.Message)" }
    return $msg
}

function Get-ApiStatusCode {
    param($ErrorRecord)
    try { if ($ErrorRecord.Exception.Response) { return [int]$ErrorRecord.Exception.Response.StatusCode } } catch { }
    return 0
}

function Find-IssuesBySummary {
    param([string]$Summary)
    $esc = '"' + ($Summary -replace '\\', '\\' -replace '"', '\"') + '"'
    $jql = "project = $ProjectKey AND summary ~ $esc"
    $enc = [uri]::EscapeDataString($jql)
    $fld = 'summary'
    try {
        $r = Invoke-Jira -Method Get -Path "/rest/api/3/search/jql?jql=$enc&fields=$fld&maxResults=$SearchLimit"
    } catch {
        $r = Invoke-Jira -Method Get -Path "/rest/api/3/search?jql=$enc&fields=$fld&maxResults=$SearchLimit"
    }
    if ($r.issues) { return @($r.issues) }
    return @()
}

# Jira REST v3 yeu cau description theo ADF (khong nhan chuoi thuong).
function ConvertTo-Adf {
    param([string]$Text)
    $paras = New-Object System.Collections.ArrayList
    foreach ($line in ($Text -split "`r?`n")) {
        if ([string]::IsNullOrWhiteSpace($line)) { continue }
        $null = $paras.Add(@{ type = 'paragraph'; content = @(@{ type = 'text'; text = $line }) })
    }
    if ($paras.Count -eq 0) { $null = $paras.Add(@{ type = 'paragraph'; content = @() }) }
    return @{ type = 'doc'; version = 1; content = @($paras.ToArray()) }
}

# --- 1. Doc CSV ---
$rows = @(Import-Csv -LiteralPath $Csv)
if ($rows.Count -eq 0) { throw "CSV rong: $Csv" }
$cols = @($rows[0].PSObject.Properties.Name)
if ($cols -notcontains 'Summary') { throw "CSV thieu cot 'Summary'. Cot hien co: $($cols -join ', ')" }
$hasDesc     = $cols -contains 'Description'
$hasLabels   = $cols -contains 'Labels'
$hasPriority = $cols -contains 'Priority'

Write-Host "CSV : $Csv ($($rows.Count) dong)" -ForegroundColor Cyan
Write-Host "Jira: $BaseUrl  project=$ProjectKey  DryRun=$([bool]$DryRun)`n" -ForegroundColor Cyan

# --- 2. Xac dinh parent (ho tro -ParentSummary) ---
if (-not $ParentKey) {
    $want = $ParentSummary.Trim()
    $hits = @()
    try { $hits = @(Find-IssuesBySummary -Summary $want) } catch { $hits = @() }
    $exact = @($hits | Where-Object { "$($_.fields.summary)".Trim() -eq $want })
    if ($exact.Count -eq 0) {
        Write-Host "LOI: Khong tim thay issue nao co Summary = '$want' trong project $ProjectKey." -ForegroundColor Red
        Write-Host "  -> Story/Spike chua duoc import? Import ./docs/jira/04-stories-batch1.noparent.csv truoc." -ForegroundColor Yellow
        exit 2
    }
    if ($exact.Count -gt 1) {
        Write-Host ("LOI: Co {0} issue trung Summary '{1}': {2}" -f $exact.Count, $want, (@($exact | ForEach-Object { $_.key }) -join ', ')) -ForegroundColor Red
        Write-Host "  -> Dung -ParentKey <key> de chi ro." -ForegroundColor Yellow
        exit 2
    }
    $ParentKey = "$($exact[0].key)"
    Write-Host ("Resolve: Summary -> {0}" -f $ParentKey) -ForegroundColor Cyan
}

# --- 2b. Xac minh parent ton tai ---
try {
    $parent = Invoke-Jira -Method Get -Path "/rest/api/3/issue/${ParentKey}?fields=summary,issuetype,subtasks"
} catch {
    $status = Get-ApiStatusCode $_
    if ($status -eq 404) {
        Write-Host "LOI: Parent '$ParentKey' khong ton tai hoac ban khong co quyen xem (404)." -ForegroundColor Red
        Write-Host "  -> Kiem tra lai -ParentKey. Lay key that bang:" -ForegroundColor Yellow
        Write-Host "     ./docs/jira/jira-link-parent.ps1 -Csv ./docs/jira/04-stories-batch1.csv -DryRun" -ForegroundColor Yellow
        exit 2
    }
    Write-Host ("LOI goi Jira ({0}): {1}" -f $status, (Get-ApiErrorBody $_)) -ForegroundColor Red
    exit 2
}
if ($parent.fields.issuetype.subtask) { throw "Parent $ParentKey la Subtask - khong the long subtask." }
Write-Host ("Parent: {0} [{1}] {2}" -f $ParentKey, $parent.fields.issuetype.name, $parent.fields.summary) -ForegroundColor DarkGreen

$existing = @()
if ($parent.fields.subtasks) {
    $existing = @($parent.fields.subtasks |
        Where-Object { $_.fields -and $_.fields.summary } |
        ForEach-Object { "$($_.fields.summary)".Trim() })
}
Write-Host ("Da co : {0} subtask" -f $existing.Count) -ForegroundColor Cyan

# --- 3. Issue type subtask: uu tien createmeta (id dung cho API create) ---
$subType = $null
$src = ''
try {
    $meta = Invoke-Jira -Method Get -Path "/rest/api/3/issue/createmeta/$ProjectKey/issuetypes"
    $subTypes = @($meta.values | Where-Object { $_.subtask -eq $true })
    if ($subTypes.Count -gt 0) { $subType = $subTypes[0]; $src = 'createmeta' }
} catch { }
if (-not $subType) {
    $proj = Invoke-Jira -Method Get -Path "/rest/api/3/project/$ProjectKey"
    $subTypes = @($proj.issueTypes | Where-Object { $_.subtask -eq $true })
    if ($subTypes.Count -gt 0) { $subType = $subTypes[0]; $src = 'project' }
}
if (-not $subType) {
    throw "Project $ProjectKey chua bat Sub-Tasks. Bat tai Settings > Work items > Sub-Tasks."
}
if ($src -ne 'createmeta') {
    Write-Warning "createmeta khong tra subtask type; fallback ve /project (id co the sai voi project team-managed)."
}
Write-Host ("Type  : {0} (id {1}, nguon {2})`n" -f $subType.name, $subType.id, $src) -ForegroundColor DarkGreen

# --- 4. Tao subtask ---
$results = New-Object System.Collections.Generic.List[object]
foreach ($row in $rows) {
    $summary = "$($row.Summary)".Trim()
    $item = [ordered]@{ Summary = $summary; Action = ''; Key = ''; Note = '' }

    if (-not $summary) {
        $item.Action = 'WARN'; $item.Note = 'Summary trong'
        $results.Add([pscustomobject]$item); continue
    }
    if ($existing -contains $summary) {
        $item.Action = 'SKIP'; $item.Note = 'da ton tai'
        $results.Add([pscustomobject]$item); continue
    }
    if ($DryRun) {
        $item.Action = 'WOULD CREATE'
        $results.Add([pscustomobject]$item); continue
    }

    $fields = @{
        project   = @{ key = $ProjectKey }
        parent    = @{ key = $ParentKey }
        issuetype = @{ id = "$($subType.id)" }
        summary   = $summary
    }
    if ($hasDesc) { $d = "$($row.Description)".Trim(); if ($d) { $fields.description = (ConvertTo-Adf $d) } }
    if ($hasLabels) {
        $labels = @("$($row.Labels)" -split ',' | ForEach-Object { $_.Trim() } | Where-Object { $_ })
        if ($labels.Count) { $fields.labels = $labels }
    }
    if ($hasPriority) { $pr = "$($row.Priority)".Trim(); if ($pr) { $fields.priority = @{ name = $pr } } }

    if ($ShowPayload) {
        Write-Host ("  payload: " + ($fields | ConvertTo-Json -Depth 20 -Compress)) -ForegroundColor DarkGray
    }

    $attempt = 0
    while ($true) {
        try {
            $created = Invoke-Jira -Method Post -Path '/rest/api/3/issue' -Body @{ fields = $fields }
            $item.Action = 'OK'; $item.Key = "$($created.key)"
            $existing += $summary
            break
        } catch {
            $body = Get-ApiErrorBody $_
            $badField = $null
            try {
                $parsed = $body | ConvertFrom-Json
                if ($parsed.errors) {
                    foreach ($p in $parsed.errors.PSObject.Properties.Name) {
                        if ($fields.ContainsKey($p)) { $badField = $p; break }
                    }
                }
            } catch { }

            if ($badField -and $attempt -lt 3) {
                Write-Warning ("  bo field '$badField' roi thu lai. Jira noi: {0}" -f $body)
                $fields.Remove($badField) | Out-Null
                $attempt++
                continue
            }
            $item.Action = 'ERROR'; $item.Note = $body
            break
        }
    }
    $results.Add([pscustomobject]$item)
}

# --- 5. Tong ket ---
Write-Host ''
$results | Select-Object Summary, Action, Key, Note | Format-Table -AutoSize | Out-String | Write-Host
Write-Host 'Tong ket:' -ForegroundColor Cyan
$results | Group-Object Action | Sort-Object Name | ForEach-Object {
    Write-Host ("  {0}: {1}" -f $_.Name, $_.Count)
}
if ($DryRun) { Write-Host "`n(DRY RUN - chua tao gi. Bo -DryRun de tao that.)" -ForegroundColor Yellow }

$errorRows = @($results | Where-Object { $_.Action -eq 'ERROR' })
if ($errorRows.Count -gt 0) {
    Write-Host "`nChi tiet loi (Jira tra ve):" -ForegroundColor Red
    foreach ($e in $errorRows) {
        Write-Host ("  - {0}" -f $e.Summary) -ForegroundColor Red
        Write-Host ("    {0}" -f $e.Note) -ForegroundColor DarkRed
    }
    exit 1
}

