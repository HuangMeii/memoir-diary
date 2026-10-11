#requires -Version 5.1
<#
.SYNOPSIS
    Tao Subtask trong Jira Cloud duoi mot Story/Spike DA TON TAI.

.DESCRIPTION
    Script nay CO TAO issue (khac jira-link-parent.ps1 chi doc/sua). No luon tao
    issuetype co subtask = true duoi mot parent DA duoc xac minh ton tai, nen khong
    the sinh epic trung. Chay lai se SKIP cac subtask da co (so theo Summary).

.PARAMETER ParentKey
    Key that cua Story/Spike cha, vi du MD-53. Lay key bang:
    ./docs/jira/jira-link-parent.ps1 -Csv ./docs/jira/04-stories-batch1.csv -DryRun

.PARAMETER Csv
    CSV danh sach subtask (can cot Summary; tuy chon Description, Labels, Priority).

.PARAMETER DryRun
    Chi in ke hoach, khong tao.

.EXAMPLE
    $env:JIRA_EMAIL = 'you@example.com'
    $env:JIRA_API_TOKEN = '***'
    ./docs/jira/jira-create-subtasks.ps1 -ParentKey MD-53 -Csv ./docs/jira/06-subtasks-md-9-s1.csv -DryRun
#>
[CmdletBinding()]
param(
    [string]$Email      = $env:JIRA_EMAIL,
    [string]$Token      = $env:JIRA_API_TOKEN,
    [string]$BaseUrl    = 'https://huynhmai2755.atlassian.net',
    [Parameter(Mandatory = $true)][string]$ParentKey,
    [Parameter(Mandatory = $true)][string]$Csv,
    [string]$ProjectKey = 'MD',
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
    if ($null -ne $Body) { $p.Body = ($Body | ConvertTo-Json -Depth 20 -Compress) }
    Invoke-RestMethod @p
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

# --- 2. Xac minh parent ton tai ---
$parent = Invoke-Jira -Method Get -Path "/rest/api/3/issue/${ParentKey}?fields=summary,issuetype,subtasks"
if ($parent.fields.issuetype.subtask) { throw "Parent $ParentKey la Subtask - khong the long subtask." }
Write-Host ("Parent: {0} [{1}] {2}" -f $ParentKey, $parent.fields.issuetype.name, $parent.fields.summary) -ForegroundColor DarkGreen

$existing = @()
if ($parent.fields.subtasks) {
    $existing = @($parent.fields.subtasks |
        Where-Object { $_.fields -and $_.fields.summary } |
        ForEach-Object { "$($_.fields.summary)".Trim() })
}
Write-Host ("Da co : {0} subtask" -f $existing.Count) -ForegroundColor Cyan

# --- 3. Tim issue type subtask cua project (khong hardcode ten) ---
$proj = Invoke-Jira -Method Get -Path "/rest/api/3/project/$ProjectKey"
$subTypes = @($proj.issueTypes | Where-Object { $_.subtask -eq $true })
if ($subTypes.Count -eq 0) {
    throw "Project $ProjectKey chua bat Sub-Tasks. Bat tai Settings > Work items > Sub-Tasks."
}
$subType = $subTypes[0]
Write-Host ("Type  : {0} (id {1})`n" -f $subType.name, $subType.id) -ForegroundColor DarkGreen

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

    try {
        $created = Invoke-Jira -Method Post -Path '/rest/api/3/issue' -Body @{ fields = $fields }
        $item.Action = 'OK'; $item.Key = "$($created.key)"
        $existing += $summary
    } catch {
        $item.Action = 'ERROR'; $item.Note = $_.Exception.Message
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

$errors = @($results | Where-Object { $_.Action -eq 'ERROR' }).Count
if ($errors -gt 0) { exit 1 }

