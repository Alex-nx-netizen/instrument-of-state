# memorial-math.ps1 — minimal batch-accounting helper for Zhongshu drafts.
#
# Purpose: prevent accounting drifts in memorial V-checks by computing the
# expected end count from a starting reference count and a list of per-batch
# deltas. Rooted in the v0.6.0 memorial-v2 V1 drift (stated 14 vs actual 17).
#
# Usage:
#   powershell -NoProfile -File bin/memorial-math.ps1 -Start 20 -Deltas 3,-2,-2,-2
#
# Output (stdout):
#   Start: 20
#   Deltas: 3, -2, -2, -2
#   Expected end: 17
#
# Exit code: 0 on success, 1 on invalid input.

param(
  [Parameter(Mandatory = $true)][int]$Start,
  [Parameter(Mandatory = $true)][int[]]$Deltas
)

Set-StrictMode -Version Latest
$ErrorActionPreference = "Stop"

$sum = $Start
foreach ($d in $Deltas) { $sum += $d }

Write-Output ("Start: {0}" -f $Start)
Write-Output ("Deltas: {0}" -f ($Deltas -join ', '))
Write-Output ("Expected end: {0}" -f $sum)
exit 0
