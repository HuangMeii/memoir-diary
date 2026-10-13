#requires -Version 5.1
<#
.SYNOPSIS
    Gan Parent (epic/story) cho cac issue DA TON TAI tren Jira Cloud, theo cot
    `Parent` trong file CSV backlog cua project MD.

.DESCRIPTION
    Script CHI doc (GET) va CHI cap nhat field Parent (PUT). No KHONG BAO GIO tao
    issue/epic moi => khong the sinh epic trung.

    Cach hoat dong:
      1. Doc CSV (can cot `Summary` va `Parent`).
      2. Kiem tra moi parent dich trong cot `Parent` co ton tai that tren Jira.
      3. Tim issue theo JQL roi khop CHINH XAC Summary.
      4. Parent da dung -> SKIP (idempotent). Chua dung -> PUT parent theo KEY.

.PARAMETER Csv
    Duong dan CSV co cot Summary + Parent. Vi du: docs/jira/05-spikes.csv

.PARAMETER DryRun
    Chi in ra ke hoach, khong goi PUT (khong thay doi gi).

.EXAMPLE
    $env:JIRA_EMAIL = 'you@example.com'
    $env:JIRA_API_TOKEN = '***'
    ./docs/jira/jira-link-parent.ps1 -Csv ./docs/jira/05-spikes.csv -DryRun
#>
[CmdletBinding()]
param(
    [string]$Email      = $env:JIRA_EMAIL,
    [string]$Token      = $env:JIRA_API_TOKEN,
    [string]$BaseUrl    = 'https://huynhmai2755.atlassian.net',
    [Parameter(Mandatory = $true)][string]$Csv,
    [string]$ProjectKey = 'MD',
    [int]$SearchLimit   = 50,
    [switch]$DryRun
)

Set-StrictMode -Version 2.0
$ErrorActionPreference = 'Stop'
[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12

if (-not $Email) { throw 'Thieu email. Dat $env:JIRA_EMAIL hoac truyen -Email.' }
if (-not $Token) { throw 'Thieu API token. Dat $env:JIRA_API_TOKEN hoac truyen -Token.' }
if (-not (Test-Path -LiteralPath $Csv)) { throw "Khong tim thay CSV: $Csv" }

$BaseUrl = $BaseUrl.TrimEnd('/')
$auth = [Convert]::ToBase64String([Text.Encoding]::UTF8.GetBytes("${Email}:${Token}"))
$Headers = @{ Authorization = "Basic $auth"; Accept = 'application/json' }

function Invoke-Jira {
    param([string]$Method, [string]$Path, $Body)
    $p = @{ Method = $Method; Uri = "$BaseUrl$Path"; Headers = $Headers; ContentType = 'application/json' }
    if ($null -ne $Body) { $p.Body = ($Body | ConvertTo-Json -Depth 10 -Compress) }
    Invoke-RestMethod @p
}

function ConvertTo-JqlText {
    param([string]$Value)
    '"' + ($Value -replace '\\', '\\' -replace '"', '\"') + '"'
}

function Find-IssuesBySummary {
    param([string]$Summary)
    $jql = "project = $ProjectKey AND summary ~ $(ConvertTo-JqlText $Summary)"
    $enc = [uri]::EscapeDataString($jql)
    $fld = 'summary,parent'
    try {
        $r = Invoke-Jira -Method Get -Path "/rest/api/3/search/jql?jql=$enc&fields=$fld&maxResults=$SearchLimit"
    } catch {
        # Instance cu: fallback ve endpoint /search
        $r = Invoke-Jira -Method Get -Path "/rest/api/3/search?jql=$enc&fields=$fld&maxResults=$SearchLimit"
    }
    if ($r.issues) { return @($r.issues) }
    return @()
}

# --- 1. Doc CSV ---
$rows = @(Import-Csv -LiteralPath $Csv)
if ($rows.Count -eq 0) { throw "CSV rong: $Csv" }
$cols = @($rows[0].PSObject.Properties.Name)
foreach ($need in @('Summary', 'Parent')) {
    if ($cols -notcontains $need) { throw "CSV thieu cot '$need'. Cot hien co: $($cols -join ', ')" }
}

Write-Host "CSV : $Csv ($($rows.Count) dong)" -ForegroundColor Cyan
Write-Host "Jira: $BaseUrl  project=$ProjectKey  DryRun=$([bool]$DryRun)`n" -ForegroundColor Cyan

# --- 2. Kiem tra parent dich ton tai ---
$parentKeys = @($rows | ForEach-Object { "$($_.Parent)".Trim() } | Where-Object { $_ } | Sort-Object -Unique)
$parentExists = @{}
Write-Host "Kiem tra $($parentKeys.Count) parent dich:" -ForegroundColor Cyan
foreach ($pk in $parentKeys) {
    try {
        $it = Invoke-Jira -Method Get -Path "/rest/api/3/issue/${pk}?fields=summary,issuetype"
        $parentExists[$pk] = $true
        Write-Host ("  OK   {0} [{1}] {2}" -f $pk, $it.fields.issuetype.name, $it.fields.summary) -ForegroundColor DarkGreen
    } catch {
        $parentExists[$pk] = $false
        Write-Warning ("  MISS {0} khong ton tai -> bo qua cac dong tro toi no" -f $pk)
    }
}

# --- 3+4. Gan parent ---
$results = New-Object System.Collections.Generic.List[object]
foreach ($row in $rows) {
    $summary = "$($row.Summary)".Trim()
    $target  = "$($row.Parent)".Trim()
    $item = [ordered]@{ Summary = $summary; Parent = $target; Action = ''; Key = ''; Note = '' }

    if (-not $target) {
        $item.Action = 'WARN'; $item.Note = 'Parent trong CSV rong'
        $results.Add([pscustomobject]$item); continue
    }
    if (-not $parentExists[$target]) {
        $item.Action = 'WARN'; $item.Note = "parent $target khong ton tai"
        $results.Add([pscustomobject]$item); continue
    }

    $found = @()
    try { $found = @(Find-IssuesBySummary -Summary $summary) } catch { }
    $exact = @($found | Where-Object { "$($_.fields.summary)".Trim() -eq $summary })

    if ($exact.Count -eq 0) {
        $item.Action = 'WARN'; $item.Note = 'khong tim thay issue theo Summary'
        $results.Add([pscustomobject]$item); continue
    }
    if ($exact.Count -gt 1) {
        $item.Action = 'WARN'; $item.Note = "$($exact.Count) issue trung Summary -> bo qua"
        $results.Add([pscustomobject]$item); continue
    }

    $issue = $exact[0]
    $item.Key = "$($issue.key)"

    $curParent = ''
    if ($issue.fields.parent -and $issue.fields.parent.key) { $curParent = "$($issue.fields.parent.key)" }
    $from = 'trong'; if ($curParent) { $from = $curParent }

    if ($curParent -eq $target) {
        $item.Action = 'SKIP'; $item.Note = 'parent da dung'
        $results.Add([pscustomobject]$item); continue
    }
    if ($DryRun) {
        $item.Action = 'WOULD SET'; $item.Note = "tu '$from' -> '$target'"
        $results.Add([pscustomobject]$item); continue
    }

    try {
        $body = @{ fields = @{ parent = @{ key = $target } } }
        [void](Invoke-Jira -Method Put -Path "/rest/api/3/issue/$($issue.key)" -Body $body)
        $item.Action = 'OK'; $item.Note = "tu '$from'"
    } catch {
        $item.Action = 'ERROR'; $item.Note = $_.Exception.Message
    }
    $results.Add([pscustomobject]$item)
}

# --- 5. Tong ket ---
Write-Host ''
$results | Select-Object Summary, Parent, Action, Key, Note | Format-Table -AutoSize | Out-String | Write-Host
Write-Host 'Tong ket:' -ForegroundColor Cyan
$results | Group-Object Action | Sort-Object Name | ForEach-Object {
    Write-Host ("  {0}: {1}" -f $_.Name, $_.Count)
}
if ($DryRun) { Write-Host "`n(DRY RUN - chua thay doi gi. Bo -DryRun de gan that.)" -ForegroundColor Yellow }

$errors = @($results | Where-Object { $_.Action -eq 'ERROR' }).Count
if ($errors -gt 0) { exit 1 }


