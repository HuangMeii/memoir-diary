#requires -Version 5.1
<#
.SYNOPSIS
    Day (push) cac field tu CSV backlog len Jira Cloud theo cot `Jira Key`.

.DESCRIPTION
    Script CHI cap nhat issue DA TON TAI (PUT /rest/api/3/issue/{key}) nen KHONG BAO GIO
    tao issue/epic moi => khong the sinh issue trung. Chay lai nhieu lan van an toan.

    Field duoc day tu `jira-full-backlog.csv`:
      Summary      <- cot `Summary`
      Description  <- cot `Description`   (text -> ADF)
      Labels       <- cot `Labels`        (tach theo dau phay: 'ci,area:infra' -> 2 label)
      Priority     <- cot `Priority`      (ten: Highest/High/Medium/Low)
      Story Points <- cot `Story Points`  -> customfield_10016
      Parent       <- cot `Parent Key`    (key that; bo qua neu rong)

.PARAMETER Csv
    CSV co cot `Jira Key`. Mac dinh: <thu muc script>/jira-full-backlog.csv

.PARAMETER StoryPointsField
    Id cua field Story Points. Mac dinh `customfield_10016`.

.PARAMETER SkipParent
    Khong day field `Parent`.

.PARAMETER DryRun
    Chi in ke hoach, khong goi PUT.

.EXAMPLE
    $env:JIRA_EMAIL = 'you@example.com'
    $env:JIRA_API_TOKEN = '***'
    ./docs/jira/jira-push-fields.ps1 -DryRun
    ./docs/jira/jira-push-fields.ps1
#>
[CmdletBinding()]
param(
    [string]$Email            = $env:JIRA_EMAIL,
    [string]$Token            = $env:JIRA_API_TOKEN,
    [string]$BaseUrl          = 'https://huynhmai2755.atlassian.net',
    [string]$Csv,
    [string]$StoryPointsField = 'customfield_10016',
    [switch]$SkipParent,
    [switch]$DryRun
)

Set-StrictMode -Version 2.0
$ErrorActionPreference = 'Stop'
[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12

if (-not $Email) { throw 'Thieu email. Dat $env:JIRA_EMAIL hoac truyen -Email.' }
if (-not $Token) { throw 'Thieu API token. Dat $env:JIRA_API_TOKEN hoac truyen -Token.' }
if (-not $Csv) { $Csv = Join-Path (Split-Path -Parent $MyInvocation.MyCommand.Path) 'jira-full-backlog.csv' }
if (-not (Test-Path -LiteralPath $Csv)) { throw "Khong tim thay CSV: $Csv" }

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

# Text -> Atlassian Document Format (moi dong = 1 paragraph).
function ConvertTo-Adf {
    param([string]$Text)
    if ([string]::IsNullOrWhiteSpace($Text)) { return $null }
    $content = New-Object System.Collections.Generic.List[object]
    foreach ($line in ($Text -split "\r?\n")) {
        if ($line.Trim() -eq '') {
            $content.Add(@{ type = 'paragraph'; content = @() })
        } else {
            $content.Add(@{ type = 'paragraph'; content = @(@{ type = 'text'; text = $line }) })
        }
    }
    @{ type = 'doc'; version = 1; content = @($content) }
}

function Split-Labels {
    param([string]$Value)
    if (-not $Value) { return @() }
    @($Value -split ',' | ForEach-Object { $_.Trim() } | Where-Object { $_ })
}

$rows = @(Import-Csv -LiteralPath $Csv)
if ($rows.Count -eq 0) { throw "CSV rong: $Csv" }
$cols = @($rows[0].PSObject.Properties.Name)
if ($cols -notcontains 'Jira Key') { throw "CSV thieu cot 'Jira Key'. Cot hien co: $($cols -join ', ')" }

Write-Host "CSV : $Csv ($($rows.Count) dong)" -ForegroundColor Cyan
Write-Host "Jira: $BaseUrl  DryRun=$([bool]$DryRun)`n" -ForegroundColor Cyan

$results = New-Object System.Collections.Generic.List[object]
foreach ($row in $rows) {
    $key  = "$($row.'Jira Key')".Trim()
    $item = [ordered]@{ Key = $key; Action = ''; Fields = ''; Note = '' }

    if (-not $key) {
        $item.Action = 'WARN'; $item.Note = 'khong co Jira Key -> bo qua'
        $results.Add([pscustomobject]$item); continue
    }

    $fields = [ordered]@{}
    if ("$($row.Summary)".Trim()) { $fields.summary = "$($row.Summary)".Trim() }
    $adf = ConvertTo-Adf "$($row.Description)"
    if ($adf) { $fields.description = $adf }
    $labels = Split-Labels "$($row.Labels)"
    if ($labels.Count -gt 0) { $fields.labels = $labels }
    if ("$($row.Priority)".Trim()) { $fields.priority = @{ name = "$($row.Priority)".Trim() } }
    $sp = "$($row.'Story Points')".Trim()
    if ($sp) { $fields.$StoryPointsField = [double]$sp }
    if (-not $SkipParent -and ($cols -contains 'Parent Key')) {
        $pk = "$($row.'Parent Key')".Trim()
        if ($pk) { $fields.parent = @{ key = $pk } }
    }

    $item.Fields = (($fields.Keys) -join ',')
    if ($DryRun) {
        $item.Action = 'WOULD UPDATE'
        $results.Add([pscustomobject]$item); continue
    }
    try {
        [void](Invoke-Jira -Method Put -Path "/rest/api/3/issue/$key" -Body @{ fields = $fields })
        $item.Action = 'OK'
    } catch {
        $item.Action = 'ERROR'; $item.Note = $_.Exception.Message
    }
    $results.Add([pscustomobject]$item)
}

Write-Host ''
$results | Select-Object Key, Action, Fields, Note | Format-Table -AutoSize | Out-String | Write-Host
Write-Host 'Tong ket:' -ForegroundColor Cyan
$results | Group-Object Action | Sort-Object Name | ForEach-Object {
    Write-Host ("  {0}: {1}" -f $_.Name, $_.Count)
}
if ($DryRun) { Write-Host "`n(DRY RUN - chua thay doi gi. Bo -DryRun de day that.)" -ForegroundColor Yellow }

$errors = @($results | Where-Object { $_.Action -eq 'ERROR' }).Count
if ($errors -gt 0) { exit 1 }
