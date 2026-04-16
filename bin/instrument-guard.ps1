param(
  [Parameter(Position = 0, Mandatory = $true)]
  [string]$Mode
)

Set-StrictMode -Version Latest
$ErrorActionPreference = "Stop"

# ── Helpers ──────────────────────────────────────────────────────────────────

function Resolve-SafeSessionId([string]$SessionId) {
  if (-not $SessionId) { return "session-unknown" }
  $safe = [regex]::Replace($SessionId, '[<>:"/\\|?*\x00-\x1F]', '_')
  if (-not $safe) { return "session-unknown" }
  return $safe
}

function Write-SoftFailure([string]$ModeName) {
  try {
    @{ hookSpecificOutput = @{
        hookEventName     = $ModeName
        additionalContext = "Guard degraded gracefully. Main flow continues. Details were written to the local log."
    }} | ConvertTo-Json -Depth 10
  } catch {}
}

function Read-HookInput {
  if ([Console]::IsInputRedirected) {
    $raw = [Console]::In.ReadToEnd()
    if ($raw -and $raw.Trim().Length -gt 0) {
      try   { return $raw | ConvertFrom-Json }
      catch { return [pscustomobject]@{ _raw_input = $raw } }
    }
  }
  return [pscustomobject]@{}
}

function Get-ObjectProperty($Object, [string]$Name, $Default = $null) {
  if ($null -eq $Object) { return $Default }
  $p = $Object.PSObject.Properties.Match($Name)
  if ($p.Count -gt 0) { return $p[0].Value }
  return $Default
}

function Set-ObjectPropertyIfMissing($Object, [string]$Name, $Value) {
  if ($null -eq $Object) { return }
  if ($Object.PSObject.Properties.Match($Name).Count -eq 0) {
    $Object | Add-Member -NotePropertyName $Name -NotePropertyValue $Value
  }
}

# ── Directory helpers ─────────────────────────────────────────────────────────

function Ensure-StateDirectory([string]$Cwd) {
  $dir = Join-Path $Cwd ".claude\instrument-of-state\state"
  if (-not (Test-Path -LiteralPath $dir)) { New-Item -ItemType Directory -Path $dir -Force | Out-Null }
  return $dir
}

function Ensure-LogDirectory([string]$Cwd) {
  $dir = Join-Path $Cwd ".claude\instrument-of-state\logs"
  if (-not (Test-Path -LiteralPath $dir)) { New-Item -ItemType Directory -Path $dir -Force | Out-Null }
  return $dir
}

# FIX-1: Sidecar files now live inside the project directory, not %TEMP%.
function Get-SidecarDir([string]$Cwd) {
  $dir = Join-Path $Cwd ".claude\instrument-of-state\state\sidecars"
  if (-not (Test-Path -LiteralPath $dir)) { New-Item -ItemType Directory -Path $dir -Force | Out-Null }
  return $dir
}

function Write-DebugLog([string]$Cwd, [string]$ModeName, [string]$SessionId, [string]$Message) {
  try {
    $dir  = Ensure-LogDirectory $Cwd
    $path = Join-Path $dir "hook-debug.log"
    $line = "[{0}] mode={1} session={2} {3}" -f (Get-Date).ToString("o"), $ModeName, (Resolve-SafeSessionId $SessionId), $Message
    Add-Content -LiteralPath $path -Value $line -Encoding UTF8
  } catch {}
}

function Get-StatePath([string]$Cwd, [string]$SessionId) {
  $dir = Ensure-StateDirectory $Cwd
  return Join-Path $dir "$(Resolve-SafeSessionId $SessionId).json"
}

# ── FIX-3: File locking ───────────────────────────────────────────────────────

function Get-LockPath([string]$StatePath) { return "$StatePath.lock" }

function Acquire-StateLock([string]$StatePath) {
  $lockPath  = Get-LockPath $StatePath
  $deadline  = (Get-Date).AddSeconds(5)
  while ((Get-Date) -lt $deadline) {
    try {
      $fs = [System.IO.File]::Open($lockPath,
            [System.IO.FileMode]::CreateNew,
            [System.IO.FileAccess]::Write,
            [System.IO.FileShare]::None)
      return $fs
    } catch {
      Start-Sleep -Milliseconds 50
    }
  }
  # Timed out — remove stale lock and proceed (fail-open)
  try { Remove-Item -LiteralPath $lockPath -Force -ErrorAction SilentlyContinue } catch {}
  return $null
}

function Release-StateLock($LockStream, [string]$StatePath) {
  if ($null -ne $LockStream) {
    try { $LockStream.Close(); $LockStream.Dispose() } catch {}
    try { Remove-Item -LiteralPath (Get-LockPath $StatePath) -Force -ErrorAction SilentlyContinue } catch {}
  }
}

# ── FIX-7: HMAC helpers ───────────────────────────────────────────────────────

function Get-StateHmac([string]$JsonBody) {
  $key   = [System.Text.Encoding]::UTF8.GetBytes("instrument-of-state-guard-v1")
  $data  = [System.Text.Encoding]::UTF8.GetBytes($JsonBody)
  $hmac  = [System.Security.Cryptography.HMACSHA256]::new($key)
  return [System.Convert]::ToBase64String($hmac.ComputeHash($data))
}

function Test-StateHmac([string]$JsonBody, [string]$Signature) {
  if (-not $Signature) { return $false }
  return (Get-StateHmac $JsonBody) -eq $Signature
}

# ── Default state ─────────────────────────────────────────────────────────────

function New-DefaultState([string]$SessionId) {
  return [ordered]@{
    schema_version = "2"
    session_id     = $SessionId
    updated_at     = (Get-Date).ToString("o")
    meta = [ordered]@{
      stage_state        = "PETITION"
      control_state      = "NORMAL"
      gate_state         = "INTENT_OPEN"
      surface_state      = "INTERNAL_ONLY"
      capability_state   = "UNKNOWN"
      authority_state    = "DRAFT_ONLY"
      writeback_decision = "UNDECIDED"
    }
    gates = [ordered]@{
      intent_locked        = $false
      intent_gate_resolved = $false
      memorial_ready       = $false
      review_ready         = $false
      verification_ready   = $false
      summary_closed       = $false
      public_ready         = $false
    }
    memorial = [ordered]@{
      drafted      = $false
      intent_packet = $false
      intent_gate  = $false
      updated_at   = $null
    }
    menxia = [ordered]@{
      verdict    = "NONE"
      approved   = $false
      updated_at = $null
    }
    approvals = [ordered]@{
      works_delivery = $false
    }
  }
}

function Ensure-StateShape($State, [string]$SessionId) {
  if ($null -eq $State) { return (New-DefaultState $SessionId) }
  Set-ObjectPropertyIfMissing $State "schema_version" "2"
  Set-ObjectPropertyIfMissing $State "session_id"     $SessionId
  Set-ObjectPropertyIfMissing $State "updated_at"     $null
  Set-ObjectPropertyIfMissing $State "meta"     ([pscustomobject]@{})
  Set-ObjectPropertyIfMissing $State "gates"    ([pscustomobject]@{})
  Set-ObjectPropertyIfMissing $State "memorial" ([pscustomobject]@{})
  Set-ObjectPropertyIfMissing $State "menxia"   ([pscustomobject]@{})
  Set-ObjectPropertyIfMissing $State "approvals"([pscustomobject]@{})
  $meta = Get-ObjectProperty $State "meta"
  Set-ObjectPropertyIfMissing $meta "stage_state"        "PETITION"
  Set-ObjectPropertyIfMissing $meta "control_state"      "NORMAL"
  Set-ObjectPropertyIfMissing $meta "gate_state"         "INTENT_OPEN"
  Set-ObjectPropertyIfMissing $meta "surface_state"      "INTERNAL_ONLY"
  Set-ObjectPropertyIfMissing $meta "capability_state"   "UNKNOWN"
  Set-ObjectPropertyIfMissing $meta "authority_state"    "DRAFT_ONLY"
  Set-ObjectPropertyIfMissing $meta "writeback_decision" "UNDECIDED"
  $gates = Get-ObjectProperty $State "gates"
  Set-ObjectPropertyIfMissing $gates "intent_locked"        $false
  Set-ObjectPropertyIfMissing $gates "intent_gate_resolved" $false
  Set-ObjectPropertyIfMissing $gates "memorial_ready"       $false
  Set-ObjectPropertyIfMissing $gates "review_ready"         $false
  Set-ObjectPropertyIfMissing $gates "verification_ready"   $false
  Set-ObjectPropertyIfMissing $gates "summary_closed"       $false
  Set-ObjectPropertyIfMissing $gates "public_ready"         $false
  $memorial = Get-ObjectProperty $State "memorial"
  Set-ObjectPropertyIfMissing $memorial "drafted"       $false
  Set-ObjectPropertyIfMissing $memorial "intent_packet" $false
  Set-ObjectPropertyIfMissing $memorial "intent_gate"   $false
  Set-ObjectPropertyIfMissing $memorial "updated_at"    $null
  $menxia = Get-ObjectProperty $State "menxia"
  Set-ObjectPropertyIfMissing $menxia "verdict"    "NONE"
  Set-ObjectPropertyIfMissing $menxia "approved"   $false
  Set-ObjectPropertyIfMissing $menxia "updated_at" $null
  $approvals = Get-ObjectProperty $State "approvals"
  Set-ObjectPropertyIfMissing $approvals "works_delivery" $false
  return $State
}

function Load-State([string]$Cwd, [string]$SessionId) {
  $path = Get-StatePath $Cwd $SessionId
  if (-not (Test-Path -LiteralPath $path)) { return (New-DefaultState $SessionId) }
  $raw = Get-Content -LiteralPath $path -Raw
  if (-not $raw.Trim()) { return (New-DefaultState $SessionId) }
  try {
    $obj = $raw | ConvertFrom-Json
    # FIX-7: Verify HMAC signature when present
    $sig = Get-ObjectProperty $obj "_sig" ""
    if ($sig) {
      $body = $raw -replace '"_sig"\s*:\s*"[^"]*",?\s*', '' -replace ',\s*}', '}'
      if (-not (Test-StateHmac $body $sig)) {
        Write-DebugLog $Cwd "load-state" $SessionId "HMAC mismatch — resetting to default state"
        return (New-DefaultState $SessionId)
      }
    }
    return (Ensure-StateShape $obj $SessionId)
  } catch {
    return (New-DefaultState $SessionId)
  }
}

function Save-State([string]$Cwd, [string]$SessionId, $State) {
  $path   = Get-StatePath $Cwd $SessionId
  $lock   = Acquire-StateLock $path
  try {
    $normalized = Ensure-StateShape $State $SessionId
    $normalized.updated_at = (Get-Date).ToString("o")
    # Remove stale sig before computing
    if ($normalized.PSObject.Properties.Match("_sig").Count -gt 0) {
      $normalized.PSObject.Properties.Remove("_sig")
    }
    $body = $normalized | ConvertTo-Json -Depth 20
    # FIX-7: Attach HMAC
    $sig  = Get-StateHmac $body
    $normalized | Add-Member -NotePropertyName "_sig" -NotePropertyValue $sig -Force
    $normalized | ConvertTo-Json -Depth 20 | Set-Content -LiteralPath $path -Encoding UTF8
  } finally {
    Release-StateLock $lock $path
  }
}

# ── FIX-2: Strict section-based verdict parsing ───────────────────────────────

function Get-Verdict([string]$Message) {
  if (-not $Message) { return "NONE" }
  # Only match the verdict inside a ## Verdict or ## 裁决 section header block
  $sectionMatch = [regex]::Match(
    $Message,
    '(?ms)^#{1,3}\s*(?:Verdict|裁决)\s*\r?\n+\s*([A-Z]+)\b'
  )
  if ($sectionMatch.Success) {
    $v = $sectionMatch.Groups[1].Value.ToUpperInvariant()
    if ($v -in @("APPROVE","CONDITIONAL","RETURN","REJECT")) { return $v }
  }
  # Fallback: look for bold/inline verdict marker **APPROVE** etc (less risky than bare word)
  $boldMatch = [regex]::Match($Message, '\*\*(APPROVE|CONDITIONAL|RETURN|REJECT)\*\*')
  if ($boldMatch.Success) { return $boldMatch.Groups[1].Value.ToUpperInvariant() }
  # Chinese fallback (only under a section header)
  if ($Message -match '(?ms)^#{1,3}\s*裁决[^\r\n]*\r?\n.*附条件批准') { return "CONDITIONAL" }
  if ($Message -match '(?ms)^#{1,3}\s*裁决[^\r\n]*\r?\n.*批准')       { return "APPROVE" }
  if ($Message -match '(?ms)^#{1,3}\s*裁决[^\r\n]*\r?\n.*退回')       { return "RETURN" }
  if ($Message -match '(?ms)^#{1,3}\s*裁决[^\r\n]*\r?\n.*驳回')       { return "REJECT" }
  return "NONE"
}

# ── Intent / memorial detection (unchanged logic, stricter anchoring) ──────────

function Get-IntentPacketReady([string]$Message) {
  if (-not $Message) { return $false }
  return ($Message -match '(?ms)^#{1,3}\s*(?:Intent Packet|意图包)\b' )
}

function Get-IntentGateReady([string]$Message) {
  if (-not $Message) { return $false }
  return ($Message -match '(?ms)^#{1,3}\s*(?:Intent Gate Packet|意图闸门包)\b')
}

function Get-MemorialReady([string]$Message) {
  if (-not $Message) { return $false }
  $required = @(
    @("(?ms)^#{1,3}\s*(?:Objective|目标)\b",         $true),
    @("(?ms)^#{1,3}\s*(?:Recommended Mode|建议模式)\b", $true),
    @("(?ms)^#{1,3}\s*(?:Deliverables|交付物)\b",    $true)
  )
  foreach ($pair in $required) {
    if ($Message -notmatch $pair[0]) { return $false }
  }
  return (Get-IntentPacketReady $Message) -and (Get-IntentGateReady $Message)
}

# ── Output helpers ────────────────────────────────────────────────────────────

function Write-PreToolDecision([string]$Decision, [string]$Reason) {
  @{ hookSpecificOutput = @{
      hookEventName           = "PreToolUse"
      permissionDecision      = $Decision
      permissionDecisionReason = $Reason
  }} | ConvertTo-Json -Depth 10
}

function Write-AdditionalContext([string]$EventName, [string]$Context) {
  @{ hookSpecificOutput = @{
      hookEventName     = $EventName
      additionalContext = $Context
  }} | ConvertTo-Json -Depth 10
}

function Get-AgentRole([string]$AgentType) {
  if (-not $AgentType) { return "" }
  $idx = $AgentType.LastIndexOf(':')
  if ($idx -ge 0) { return $AgentType.Substring($idx + 1) }
  return $AgentType
}

# ── FIX-1: Sidecar helpers (project-local, not %TEMP%) ────────────────────────

function Write-AgentSidecar([string]$AgentRole, [string]$Cwd, [string]$SessionId) {
  try {
    $dir  = Get-SidecarDir $Cwd
    $content = "$Cwd`n$SessionId"
    [System.IO.File]::WriteAllText((Join-Path $dir "$AgentRole.sidecar"), $content, [System.Text.Encoding]::UTF8)
  } catch {}
}

function Read-AgentSidecar([string]$AgentRole, [string]$ProjectCwd, [ref]$CwdRef, [ref]$SessionIdRef) {
  try {
    $sf = Join-Path (Get-SidecarDir $ProjectCwd) "$AgentRole.sidecar"
    if (-not (Test-Path -LiteralPath $sf)) { return }
    $parts = [System.IO.File]::ReadAllText($sf, [System.Text.Encoding]::UTF8) -split "`n"
    if ($parts.Count -ge 2) {
      $sideCwd     = $parts[0].Trim()
      $sideSession = $parts[1].Trim()
      if ($sideCwd)                                          { $CwdRef.Value     = $sideCwd }
      if ($sideSession -and $sideSession -ne "session-unknown") { $SessionIdRef.Value = $sideSession }
    }
  } catch {}
}

# ── FIX-6: Whitelist-based mutating bash detection ────────────────────────────
# Anything NOT in this read-only whitelist is treated as potentially mutating.

$READONLY_PATTERNS = @(
  '^(cat|type|Get-Content)\b',
  '^(ls|dir|Get-ChildItem)\b',
  '^(echo|Write-Output|Write-Host)\b',
  '^(pwd|Get-Location)\b',
  '^git\s+(status|log|diff|show|branch|remote\s+(-v|show)|fetch\s+--dry-run|stash\s+list)\b',
  '^(grep|Select-String|findstr)\b',
  '^(find|Get-ChildItem\s+-Recurse)\b',
  '^(head|tail|Select-Object)\b',
  '^(wc|Measure-Object)\b',
  '^(which|where|Get-Command)\b',
  '^(env|Get-ChildItem\s+Env:)\b',
  '^(date|Get-Date)\b',
  '^(ps|Get-Process)\b',
  '^(whoami)\b',
  '^\s*#',           # comment lines
  '^\s*$'            # empty lines
)

function Is-MutatingBash([string]$CommandText) {
  if (-not $CommandText) { return $false }
  $trimmed = $CommandText.Trim()
  foreach ($pattern in $READONLY_PATTERNS) {
    if ($trimmed -match $pattern) { return $false }
  }
  return $true
}

function Get-ToolFilePath($InputData) {
  if ($null -eq $InputData) { return $null }
  $toolInput = Get-ObjectProperty $InputData "tool_input"
  if ($null -eq $toolInput) { return $null }
  foreach ($name in @("file_path","path","target_file","filename","destination")) {
    $p = $toolInput.PSObject.Properties.Match($name)
    if ($p.Count -gt 0) {
      $v = [string]$p[0].Value
      if ($v) { return $v }
    }
  }
  return $null
}

function Is-PlanningArtifactPath([string]$PathValue) {
  if (-not $PathValue) { return $false }
  return ([System.IO.Path]::GetFileName($PathValue) -in @("task_plan.md","findings.md","progress.md"))
}

function Test-IsProjectPath([string]$FilePath, [string]$ProjectCwd) {
  if (-not $FilePath -or -not $ProjectCwd) { return $true }
  try {
    $nf = [System.IO.Path]::GetFullPath($FilePath)
    $nc = [System.IO.Path]::GetFullPath($ProjectCwd).TrimEnd('\','/')
    return $nf.StartsWith($nc + '\', [System.StringComparison]::OrdinalIgnoreCase) -or
           $nf.StartsWith($nc + '/', [System.StringComparison]::OrdinalIgnoreCase) -or
           ($nf -ieq $nc)
  } catch { return $true }
}

function Get-LatestRunArtifactPath([string]$Cwd) {
  $artifactDir = Join-Path $Cwd "artifacts\runs"
  if (-not (Test-Path -LiteralPath $artifactDir -PathType Container)) { return $null }
  $latest = Get-ChildItem -LiteralPath $artifactDir -Filter *.json -File |
            Sort-Object LastWriteTimeUtc -Descending | Select-Object -First 1
  if ($null -eq $latest) { return $null }
  return $latest.FullName
}

function Test-RunArtifactPublicReady([string]$ArtifactPath) {
  if (-not $ArtifactPath -or -not (Test-Path -LiteralPath $ArtifactPath -PathType Leaf)) { return $false }
  try {
    $a   = Get-Content -LiteralPath $ArtifactPath -Raw | ConvertFrom-Json
    $vp  = Get-ObjectProperty $a "verificationPacket"
    $sp  = Get-ObjectProperty $a "summaryPacket"
    $pp  = Get-ObjectProperty $a "publicationPacket"
    $ok  = ([bool](Get-ObjectProperty $vp "verifyPassed" $false)) -and
           ([bool](Get-ObjectProperty $sp "summaryClosed" $false)) -and
           ([bool](Get-ObjectProperty $sp "singleDeliverableMaintained" $false)) -and
           ([bool](Get-ObjectProperty $sp "deliverableChainClosed" $false)) -and
           ([bool](Get-ObjectProperty $sp "consolidatedDeliverablePresent" $false)) -and
           ([bool](Get-ObjectProperty $sp "publicReady" $false))
    $evidence = Get-ObjectProperty $pp "publicReadyEvidence" @()
    $evidenceCount = if ($null -eq $evidence) { 0 }
                     elseif ($evidence -is [System.Array]) { $evidence.Count }
                     elseif ($evidence -is [System.Collections.IEnumerable] -and -not ($evidence -is [string])) { @($evidence).Count }
                     elseif ([string]$evidence) { 1 } else { 0 }
    return $ok -and ($evidenceCount -gt 0)
  } catch { return $false }
}

# ── Main dispatch ─────────────────────────────────────────────────────────────

try {
  $inputData   = Read-HookInput
  $cwdValue    = Get-ObjectProperty $inputData "cwd"
  $sessionValue = Get-ObjectProperty $inputData "session_id"
  $cwd         = if ($cwdValue)    { [string]$cwdValue }    else { (Get-Location).Path }
  $sessionId   = if ($sessionValue){ [string]$sessionValue } else { "session-unknown" }

  switch ($Mode) {
    "session-context" {
      Write-DebugLog $cwd $Mode $sessionId "session context requested"
      $contextParts = [System.Collections.Generic.List[string]]::new()
      $contextParts.Add("Governed order: for substantial work, open the docket first, then draft with Zhongshu, review with Menxia, and only then unlock Works Delivery.")
      $contextParts.Add("Meta layer: before heavy execution, lock intent through an intent packet and intent gate packet. Do not treat unstated assumptions as settled authority.")
      $contextParts.Add("Capability ladder: local skills and plugins first, then find-skills, then approved marketplaces if a gap remains.")
      $contextParts.Add("Only Works Delivery may land governed file changes. The only exception is planning artifacts: task_plan.md, findings.md, and progress.md.")
      $contextParts.Add("Public-ready law: implementation finished does not automatically mean ready for outward publication. Verification and summary closure must be explicit.")
      $spSkillPath  = Join-Path $env:USERPROFILE ".claude\skills\superpowers"
      $spPluginPath = Join-Path $env:USERPROFILE ".claude\plugins\superpowers"
      $superpowersInstalled = (Test-Path -LiteralPath $spSkillPath -PathType Container) -or (Test-Path -LiteralPath $spPluginPath -PathType Container)
      if ($superpowersInstalled) {
        $contextParts.Add("Superpowers is active. Use its skills at the correct governance stage as defined in references/superpowers-integration.md.")
      } else {
        $contextParts.Add("Superpowers is not installed. Install with: /plugin install superpowers@superpowers-marketplace")
      }
      Write-AdditionalContext "SessionStart" ($contextParts -join " ")
      exit 0
    }

    "reset" {
      Write-DebugLog $cwd $Mode $sessionId "reset state"
      Save-State $cwd $sessionId (New-DefaultState $sessionId)
      exit 0
    }

    "soft-reset" {
      Write-DebugLog $cwd $Mode $sessionId "soft-reset"
      $state = Load-State $cwd $sessionId
      $state.meta.stage_state    = "PETITION"
      $state.meta.gate_state     = "INTENT_OPEN"
      $state.meta.authority_state = "DRAFT_ONLY"
      $state.meta.control_state  = "NORMAL"
      Save-State $cwd $sessionId $state
      exit 0
    }

    "record-zhongshu" {
      Read-AgentSidecar "zhongshu-agent" $cwd ([ref]$cwd) ([ref]$sessionId)
      $state       = Load-State $cwd $sessionId
      $message     = [string](Get-ObjectProperty $inputData "last_assistant_message" "")
      $drafted     = Get-MemorialReady $message
      $intentPkt   = Get-IntentPacketReady $message
      $intentGate  = Get-IntentGateReady $message
      Write-DebugLog $cwd $Mode $sessionId ("record zhongshu drafted={0} intent_packet={1} intent_gate={2}" -f $drafted, $intentPkt, $intentGate)
      $state.memorial.drafted       = $drafted
      $state.memorial.intent_packet = $intentPkt
      $state.memorial.intent_gate   = $intentGate
      $state.memorial.updated_at    = (Get-Date).ToString("o")
      $state.gates.intent_locked        = $intentPkt
      $state.gates.intent_gate_resolved = $intentGate
      $state.gates.memorial_ready       = $drafted
      $state.meta.stage_state    = "DRAFT"
      $state.meta.gate_state     = if ($drafted) { "REVIEW_OPEN" } else { "INTENT_OPEN" }
      $state.meta.authority_state = "REVIEW_ONLY"
      Save-State $cwd $sessionId $state
      exit 0
    }

    "record-menxia" {
      Read-AgentSidecar "menxia-agent" $cwd ([ref]$cwd) ([ref]$sessionId)
      $state   = Load-State $cwd $sessionId
      $verdict = Get-Verdict ([string](Get-ObjectProperty $inputData "last_assistant_message" ""))
      Write-DebugLog $cwd $Mode $sessionId ("record menxia verdict={0}" -f $verdict)
      $approved = $verdict -eq "APPROVE"
      $state.menxia.verdict    = $verdict
      $state.menxia.approved   = $approved
      $state.menxia.updated_at = (Get-Date).ToString("o")
      $state.approvals.works_delivery = $approved
      $state.gates.review_ready       = $approved
      $state.meta.stage_state    = "REVIEW"
      $state.meta.gate_state     = if ($approved) { "WORKS_UNLOCKED" } else { "WORKS_LOCKED" }
      $state.meta.authority_state = if ($approved) { "WORKS_UNLOCKED" } else { "REVIEW_ONLY" }
      Save-State $cwd $sessionId $state
      exit 0
    }

    "record-agent-result" {
      $toolInput   = Get-ObjectProperty $inputData "tool_input"
      $subType     = [string](Get-ObjectProperty $toolInput "subagent_type" "")
      $agentRole   = Get-AgentRole $subType
      $agentOutput = [string](Get-ObjectProperty $inputData "tool_response" "")
      if (-not $agentOutput) { $agentOutput = [string](Get-ObjectProperty $inputData "output" "") }
      if (-not $agentOutput) { $agentOutput = [string](Get-ObjectProperty $inputData "result" "") }
      Write-DebugLog $cwd $Mode $sessionId ("record agent result role={0} output_len={1}" -f $agentRole, $agentOutput.Length)

      if ($agentRole -eq "zhongshu-agent") {
        $state = Load-State $cwd $sessionId
        $drafted   = Get-MemorialReady $agentOutput
        $intentPkt = Get-IntentPacketReady $agentOutput
        $intentGte = Get-IntentGateReady $agentOutput
        $state.memorial.drafted       = $drafted
        $state.memorial.intent_packet = $intentPkt
        $state.memorial.intent_gate   = $intentGte
        $state.memorial.updated_at    = (Get-Date).ToString("o")
        $state.gates.intent_locked        = $intentPkt
        $state.gates.intent_gate_resolved = $intentGte
        $state.gates.memorial_ready       = $drafted
        $state.meta.stage_state    = "DRAFT"
        $state.meta.gate_state     = if ($drafted) { "REVIEW_OPEN" } else { "INTENT_OPEN" }
        $state.meta.authority_state = "REVIEW_ONLY"
        Save-State $cwd $sessionId $state
      } elseif ($agentRole -eq "menxia-agent") {
        $state   = Load-State $cwd $sessionId
        $verdict = Get-Verdict $agentOutput
        Write-DebugLog $cwd $Mode $sessionId ("menxia result verdict={0}" -f $verdict)
        $approved = $verdict -eq "APPROVE"
        $state.menxia.verdict    = $verdict
        $state.menxia.approved   = $approved
        $state.menxia.updated_at = (Get-Date).ToString("o")
        $state.approvals.works_delivery = $approved
        $state.gates.review_ready       = $approved
        $state.meta.stage_state    = "REVIEW"
        $state.meta.gate_state     = if ($approved) { "WORKS_UNLOCKED" } else { "WORKS_LOCKED" }
        $state.meta.authority_state = if ($approved) { "WORKS_UNLOCKED" } else { "REVIEW_ONLY" }
        Save-State $cwd $sessionId $state
      } elseif ($agentRole -eq "works-delivery-agent") {
        $state = Load-State $cwd $sessionId
        $verificationReady = $agentOutput -match '(?ms)^#{1,3}\s*(?:Verification|验证)\b|verification_ready.*true|verifyPassed.*true'
        $summaryClosed     = $agentOutput -match '(?ms)^#{1,3}\s*(?:Summary|总结)\b|summary_closed.*true|summaryClosed.*true'
        $state.gates.verification_ready = $verificationReady
        $state.gates.summary_closed     = $summaryClosed
        $state.meta.stage_state = if ($summaryClosed) { "SUMMARY" } elseif ($verificationReady) { "VERIFICATION" } else { "DELIVERY" }
        Save-State $cwd $sessionId $state
      }
      exit 0
    }

    "record-works-delivery" {
      Read-AgentSidecar "works-delivery-agent" $cwd ([ref]$cwd) ([ref]$sessionId)
      $state   = Load-State $cwd $sessionId
      $message = [string](Get-ObjectProperty $inputData "last_assistant_message" "")
      $verificationReady = $message -match '(?ms)^#{1,3}\s*(?:Verification|验证)\b|verification_ready.*true|verifyPassed.*true'
      $summaryClosed     = $message -match '(?ms)^#{1,3}\s*(?:Summary|总结)\b|summary_closed.*true|summaryClosed.*true'
      Write-DebugLog $cwd $Mode $sessionId ("record works delivery verification_ready={0} summary_closed={1}" -f $verificationReady, $summaryClosed)
      $state.gates.verification_ready = $verificationReady
      $state.gates.summary_closed     = $summaryClosed
      $state.meta.stage_state = if ($summaryClosed) { "SUMMARY" } elseif ($verificationReady) { "VERIFICATION" } else { "DELIVERY" }
      Save-State $cwd $sessionId $state
      exit 0
    }

    "health" {
      $state    = Load-State $cwd $sessionId
      $meta     = Get-ObjectProperty $state "meta"
      $gates    = Get-ObjectProperty $state "gates"
      $menxia   = Get-ObjectProperty $state "menxia"
      $approvals = Get-ObjectProperty $state "approvals"
      $summary  = [ordered]@{
        session_id              = $sessionId
        stage_state             = [string](Get-ObjectProperty $meta "stage_state" "PETITION")
        control_state           = [string](Get-ObjectProperty $meta "control_state" "NORMAL")
        gate_state              = [string](Get-ObjectProperty $meta "gate_state" "INTENT_OPEN")
        menxia_verdict          = [string](Get-ObjectProperty $menxia "verdict" "NONE")
        works_delivery_approved = [bool](Get-ObjectProperty $approvals "works_delivery" $false)
        intent_locked           = [bool](Get-ObjectProperty $gates "intent_locked" $false)
        memorial_ready          = [bool](Get-ObjectProperty $gates "memorial_ready" $false)
        review_ready            = [bool](Get-ObjectProperty $gates "review_ready" $false)
        verification_ready      = [bool](Get-ObjectProperty $gates "verification_ready" $false)
        summary_closed          = [bool](Get-ObjectProperty $gates "summary_closed" $false)
        public_ready            = [bool](Get-ObjectProperty $gates "public_ready" $false)
      }
      Write-AdditionalContext "health" ($summary | ConvertTo-Json -Depth 5 -Compress)
      exit 0
    }

    "annotate-start" {
      $state     = Load-State $cwd $sessionId
      $agentType = [string](Get-ObjectProperty $inputData "agent_type" "")
      $agentRole = Get-AgentRole $agentType
      Write-DebugLog $cwd $Mode $sessionId ("annotate agent={0}" -f $agentType)
      if ($agentRole -in @("zhongshu-agent","menxia-agent","works-delivery-agent")) {
        Write-AgentSidecar $agentRole $cwd $sessionId
      }
      if ($agentRole -eq "zhongshu-agent") {
        Write-AdditionalContext "SubagentStart" "Use planning artifacts if they exist. Draft the memorial only. Include at least ## Intent Packet or ## 意图包, ## Intent Gate Packet or ## 意图闸门包, ## Objective or ## 目标, ## Recommended Mode or ## 建议模式, and ## Deliverables or ## 交付物. Do not execute."
        exit 0
      }
      if ($agentRole -eq "menxia-agent") {
        Write-AdditionalContext "SubagentStart" "Review only. Inspect both the memorial content and the protocol gates. Return an explicit ## Verdict section with exactly one of: APPROVE, CONDITIONAL, RETURN, REJECT on its own line. Only APPROVE unlocks Works Delivery."
        exit 0
      }
      if ($agentRole -eq "works-delivery-agent") {
        $approved = [bool]$state.approvals.works_delivery
        if ($approved) {
          Write-AdditionalContext "SubagentStart" "Menxia approval is on record. Works Delivery may execute only within the approved memorial and conditions. Include delivery evidence and a writeback suggestion in your return."
        } else {
          Write-AdditionalContext "SubagentStart" "Menxia approval is not on record yet. Inspection is allowed, but write access and mutating commands will remain blocked."
        }
        exit 0
      }
      exit 0
    }

    "guard-agent" {
      $state     = Load-State $cwd $sessionId
      $toolInput = Get-ObjectProperty $inputData "tool_input"
      $subType   = [string](Get-ObjectProperty $toolInput "subagent_type" "")
      $agentRole = Get-AgentRole $subType
      Write-DebugLog $cwd $Mode $sessionId ("guard agent subagent_type={0} memorial={1} approved={2}" -f $subType, [bool]$state.memorial.drafted, [bool]$state.approvals.works_delivery)
      if ($agentRole -eq "menxia-agent" -and -not [bool]$state.memorial.drafted) {
        Write-PreToolDecision "deny" "Menxia review is blocked until Zhongshu has produced a formal memorial with intent lock for this petition."
        exit 0
      }
      if ($agentRole -ne "works-delivery-agent") { exit 0 }
      if (-not [bool]$state.approvals.works_delivery) {
        Write-PreToolDecision "deny" "Works Delivery is not unlocked because Menxia has not approved this petition yet."
        exit 0
      }
      exit 0
    }

    "guard-tool" {
      $state     = Load-State $cwd $sessionId
      $toolInput = Get-ObjectProperty $inputData "tool_input"
      $agentType = [string](Get-ObjectProperty $inputData "agent_type" "")
      $agentRole = Get-AgentRole $agentType
      $toolName  = [string](Get-ObjectProperty $inputData "tool_name" "")
      $filePath  = Get-ToolFilePath $inputData
      $isPlanningArtifact = Is-PlanningArtifactPath $filePath
      Write-DebugLog $cwd $Mode $sessionId ("guard tool agent={0} tool={1} path={2}" -f $agentType, $toolName, $filePath)

      $meta = Get-ObjectProperty $state "meta"
      $ss   = [string](Get-ObjectProperty $meta "stage_state" "PETITION")
      if ($ss -eq "PETITION") { Write-DebugLog $cwd $Mode $sessionId "governance inactive - allow"; exit 0 }

      if ($filePath -and -not (Test-IsProjectPath $filePath $cwd)) {
        Write-DebugLog $cwd $Mode $sessionId ("path outside project - allow: {0}" -f $filePath)
        exit 0
      }

      if ($agentRole -ne "works-delivery-agent") {
        if ($toolName -in @("Write","Edit")) {
          if ($isPlanningArtifact) { exit 0 }
          Write-PreToolDecision "deny" "Governed file writes are reserved for Works Delivery. Other offices may inspect and advise, but may not write files."
          exit 0
        }
        if ($toolName -eq "Bash") {
          $commandText = [string](Get-ObjectProperty $toolInput "command" "")

          # FIX-4: public_ready gate covers ALL lark-cli outbound calls, not just im +messages-send
          if ($agentRole -eq "rites-protocol-agent" -and $commandText -match '\blark-cli\b') {
            $isReadOnlyLark = $commandText -match 'lark-cli\s+(doc\s+get|wiki\s+get|im\s+(list|get)|calendar\s+get)\b'
            if (-not $isReadOnlyLark) {
              $artifactPath = Get-LatestRunArtifactPath $cwd
              $publicReady  = Test-RunArtifactPublicReady $artifactPath
              Write-DebugLog $cwd $Mode $sessionId ("lark-cli outbound check artifact={0} public_ready={1}" -f $artifactPath, $publicReady)
              if (-not $publicReady) {
                Write-PreToolDecision "deny" "All outbound lark-cli operations (doc create, wiki publish, IM send, etc.) are blocked until a governed run artifact proves public-ready closure. Update the latest artifacts/runs/*.json summaryPacket and publicationPacket first, or downgrade to plan/doc-only publication."
                exit 0
              }
            }
          }

          if (Is-MutatingBash $commandText) {
            Write-PreToolDecision "deny" "Mutating workspace commands are reserved for Works Delivery after Menxia approval. Other offices may inspect and plan only."
            exit 0
          }
        }
        exit 0
      }

      if ([bool]$state.approvals.works_delivery) { exit 0 }

      if ($toolName -in @("Write","Edit")) {
        Write-PreToolDecision "deny" "Works Delivery may not write files yet because Menxia has not approved this petition."
        exit 0
      }
      if ($toolName -eq "Bash") {
        $commandText = [string](Get-ObjectProperty $toolInput "command" "")
        if (Is-MutatingBash $commandText) {
          Write-PreToolDecision "deny" "Works Delivery may not run mutating commands yet because Menxia has not approved this petition."
          exit 0
        }
      }
      exit 0
    }

    default {
      Write-Error "Unknown mode: $Mode"
      exit 1
    }
  }
} catch {
  if ($cwd -and $sessionId) { Write-DebugLog $cwd $Mode $sessionId ("error={0}" -f $_.Exception.Message) }
  Write-SoftFailure $Mode
  exit 0
}
