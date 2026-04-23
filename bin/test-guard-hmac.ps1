# Test harness for guard HMAC roundtrip (FIX-8)
# Usage: powershell -NoProfile -File bin/test-guard-hmac.ps1
# Exit 0 on all-pass, non-zero on failure.

Set-StrictMode -Version Latest
$ErrorActionPreference = "Stop"

$guard = Join-Path $PSScriptRoot "instrument-guard.ps1"
if (-not (Test-Path $guard)) { Write-Error "guard not found at $guard"; exit 2 }

# Dot-source helper functions by invoking guard in a mode that doesn't exit
# early. We can't dot-source directly because the param block has a mandatory
# $Mode. Instead we extract the functions we need by reading source and
# Invoke-Expression'ing the helpers block. Simpler: load functions via
# AST inspection — but that's overkill. Use a subprocess with a test mode.

# Approach: Run a temporary .ps1 that dot-sources the guard's functions by
# re-defining param so it's not mandatory.

$funcSrc = @'
param([string]$Mode = "test")
Set-StrictMode -Version Latest
$ErrorActionPreference = "Stop"
'@

$guardLines = Get-Content -LiteralPath $guard
# Skip the original param block: find the line index where a line is exactly ")"
# (optionally with trailing whitespace). The original param block in guard runs
# from line 1 `param(` through the matching `)` before the main body starts.
$closeIdx = -1
for ($i = 0; $i -lt $guardLines.Count; $i++) {
  if ($guardLines[$i] -match '^\s*\)\s*$') { $closeIdx = $i; break }
}
if ($closeIdx -lt 0) { throw "could not locate end of original param block" }
$guardTail = ($guardLines[($closeIdx + 1)..($guardLines.Count - 1)] -join "`n")

$tempFile = [System.IO.Path]::GetTempFileName() + ".ps1"
Set-Content -LiteralPath $tempFile -Value ($funcSrc + "`n" + $guardTail) -Encoding UTF8

try {
  # Now dot-source the temp file — functions become available.
  . $tempFile

  $failures = @()
  $passes   = 0

  function Assert-True([bool]$Cond, [string]$Message) {
    $script:total++
    if ($Cond) { $script:passes++; Write-Host "  PASS: $Message" -ForegroundColor Green }
    else { $script:failures += $Message; Write-Host "  FAIL: $Message" -ForegroundColor Red }
  }
  $script:total = 0
  $script:passes = 0
  $script:failures = @()

  Write-Host "=== HMAC Roundtrip Smoke Test ==="

  # Test 1: default state roundtrips
  $cwd = [System.IO.Path]::GetTempPath()
  $sid = "hmac-roundtrip-test-$([System.Guid]::NewGuid().ToString('N').Substring(0,8))"

  $state = New-DefaultState $sid
  $state.meta.stage_state = "DRAFT"
  $state.memorial.drafted = $true
  $state.gates.memorial_ready = $true

  Save-State $cwd $sid $state
  $loaded = Load-State $cwd $sid

  Assert-True ($loaded.meta.stage_state -eq "DRAFT") `
    "stage_state=DRAFT persisted (actual=$($loaded.meta.stage_state))"
  Assert-True ([bool]$loaded.memorial.drafted) `
    "memorial.drafted=true persisted"
  Assert-True ([bool]$loaded.gates.memorial_ready) `
    "gates.memorial_ready=true persisted"

  # Test 2: approved state with verdict
  $state2 = $loaded
  $state2.menxia.verdict = "APPROVE"
  $state2.menxia.approved = $true
  $state2.approvals.works_delivery = $true
  $state2.meta.stage_state = "REVIEW"
  Save-State $cwd $sid $state2
  $loaded2 = Load-State $cwd $sid

  Assert-True ($loaded2.menxia.verdict -eq "APPROVE") `
    "verdict=APPROVE persisted across save+load"
  Assert-True ([bool]$loaded2.approvals.works_delivery) `
    "works_delivery=true persisted"
  Assert-True ($loaded2.meta.stage_state -eq "REVIEW") `
    "stage_state=REVIEW persisted"

  # Test 3: tampering detection
  $statePath = Get-StatePath $cwd $sid
  $raw = Get-Content -LiteralPath $statePath -Raw
  $tampered = $raw -replace '"verdict":\s*"APPROVE"', '"verdict":"REJECT"'
  Set-Content -LiteralPath $statePath -Value $tampered -Encoding UTF8
  $loaded3 = Load-State $cwd $sid
  Assert-True ($loaded3.meta.stage_state -eq "PETITION") `
    "tampered state detected, reset to default (stage=$($loaded3.meta.stage_state))"
  Assert-True ($loaded3.menxia.verdict -eq "NONE") `
    "tampered verdict reset to NONE"

  # Cleanup
  Remove-Item -LiteralPath $statePath -ErrorAction SilentlyContinue
  $lockPath = "$statePath.lock"
  Remove-Item -LiteralPath $lockPath -ErrorAction SilentlyContinue

  Write-Host ""
  Write-Host "=== Results: $passes/$total passed ==="
  if ($failures.Count -gt 0) {
    Write-Host "Failures:" -ForegroundColor Red
    $failures | ForEach-Object { Write-Host "  - $_" -ForegroundColor Red }
    exit 1
  }
  exit 0
} finally {
  Remove-Item -LiteralPath $tempFile -ErrorAction SilentlyContinue
}
