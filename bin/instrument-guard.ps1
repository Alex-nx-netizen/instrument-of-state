param(
  [Parameter(Position = 0, Mandatory = $true)]
  [string]$Mode
)

Set-StrictMode -Version Latest
$ErrorActionPreference = "Stop"

function Resolve-SafeSessionId([string]$SessionId) {
  if (-not $SessionId) {
    return "session-unknown"
  }

  $safe = [regex]::Replace($SessionId, '[<>:"/\\|?*\x00-\x1F]', '_')
  if (-not $safe) {
    return "session-unknown"
  }

  return $safe
}

function Write-SoftFailure([string]$ModeName) {
  try {
    $payload = [ordered]@{
      hookSpecificOutput = [ordered]@{
        hookEventName = $ModeName
        additionalContext = "Guard degraded gracefully. Main flow continues. Details were written to the local log."
      }
    }
    $payload | ConvertTo-Json -Depth 10
  } catch {
    # Hooks should fail open.
  }
}

function Read-HookInput {
  if ([Console]::IsInputRedirected) {
    $raw = [Console]::In.ReadToEnd()
    if ($raw -and $raw.Trim().Length -gt 0) {
      try {
        return $raw | ConvertFrom-Json
      } catch {
        return [pscustomobject]@{
          _raw_input = $raw
        }
      }
    }
  }

  return [pscustomobject]@{}
}

function Get-ObjectProperty($Object, [string]$Name, $Default = $null) {
  if ($null -eq $Object) {
    return $Default
  }

  $property = $Object.PSObject.Properties.Match($Name)
  if ($property.Count -gt 0) {
    return $property[0].Value
  }

  return $Default
}

function Set-ObjectPropertyIfMissing($Object, [string]$Name, $Value) {
  if ($null -eq $Object) {
    return
  }

  $property = $Object.PSObject.Properties.Match($Name)
  if ($property.Count -eq 0) {
    $Object | Add-Member -NotePropertyName $Name -NotePropertyValue $Value
  }
}

function Ensure-StateDirectory([string]$Cwd) {
  $dir = Join-Path $Cwd ".claude\instrument-of-state\state"
  if (-not (Test-Path -LiteralPath $dir)) {
    New-Item -ItemType Directory -Path $dir -Force | Out-Null
  }
  return $dir
}

function Ensure-LogDirectory([string]$Cwd) {
  $dir = Join-Path $Cwd ".claude\instrument-of-state\logs"
  if (-not (Test-Path -LiteralPath $dir)) {
    New-Item -ItemType Directory -Path $dir -Force | Out-Null
  }
  return $dir
}

function Write-DebugLog([string]$Cwd, [string]$ModeName, [string]$SessionId, [string]$Message) {
  try {
    $dir = Ensure-LogDirectory $Cwd
    $path = Join-Path $dir "hook-debug.log"
    $line = "[{0}] mode={1} session={2} {3}" -f (Get-Date).ToString("o"), $ModeName, (Resolve-SafeSessionId $SessionId), $Message
    Add-Content -LiteralPath $path -Value $line -Encoding UTF8
  } catch {
    # Logging must never break hook execution.
  }
}

function Get-StatePath([string]$Cwd, [string]$SessionId) {
  $dir = Ensure-StateDirectory $Cwd
  $safeSessionId = Resolve-SafeSessionId $SessionId
  return Join-Path $dir "$safeSessionId.json"
}

function New-DefaultState([string]$SessionId) {
  return [ordered]@{
    session_id = $SessionId
    updated_at = (Get-Date).ToString("o")
    meta = [ordered]@{
      stage_state = "PETITION"
      control_state = "NORMAL"
      gate_state = "INTENT_OPEN"
      surface_state = "INTERNAL_ONLY"
      capability_state = "UNKNOWN"
      authority_state = "DRAFT_ONLY"
      writeback_decision = "UNDECIDED"
    }
    gates = [ordered]@{
      intent_locked = $false
      intent_gate_resolved = $false
      memorial_ready = $false
      review_ready = $false
      verification_ready = $false
      summary_closed = $false
      public_ready = $false
    }
    memorial = [ordered]@{
      drafted = $false
      intent_packet = $false
      intent_gate = $false
      updated_at = $null
    }
    menxia = [ordered]@{
      verdict = "NONE"
      approved = $false
      updated_at = $null
    }
    approvals = [ordered]@{
      works_delivery = $false
    }
  }
}

function Ensure-StateShape($State, [string]$SessionId) {
  if ($null -eq $State) {
    return (New-DefaultState $SessionId)
  }

  Set-ObjectPropertyIfMissing $State "session_id" $SessionId
  Set-ObjectPropertyIfMissing $State "updated_at" $null
  Set-ObjectPropertyIfMissing $State "meta" ([pscustomobject]@{})
  Set-ObjectPropertyIfMissing $State "gates" ([pscustomobject]@{})
  Set-ObjectPropertyIfMissing $State "memorial" ([pscustomobject]@{})
  Set-ObjectPropertyIfMissing $State "menxia" ([pscustomobject]@{})
  Set-ObjectPropertyIfMissing $State "approvals" ([pscustomobject]@{})

  $meta = Get-ObjectProperty $State "meta"
  Set-ObjectPropertyIfMissing $meta "stage_state" "PETITION"
  Set-ObjectPropertyIfMissing $meta "control_state" "NORMAL"
  Set-ObjectPropertyIfMissing $meta "gate_state" "INTENT_OPEN"
  Set-ObjectPropertyIfMissing $meta "surface_state" "INTERNAL_ONLY"
  Set-ObjectPropertyIfMissing $meta "capability_state" "UNKNOWN"
  Set-ObjectPropertyIfMissing $meta "authority_state" "DRAFT_ONLY"
  Set-ObjectPropertyIfMissing $meta "writeback_decision" "UNDECIDED"

  $gates = Get-ObjectProperty $State "gates"
  Set-ObjectPropertyIfMissing $gates "intent_locked" $false
  Set-ObjectPropertyIfMissing $gates "intent_gate_resolved" $false
  Set-ObjectPropertyIfMissing $gates "memorial_ready" $false
  Set-ObjectPropertyIfMissing $gates "review_ready" $false
  Set-ObjectPropertyIfMissing $gates "verification_ready" $false
  Set-ObjectPropertyIfMissing $gates "summary_closed" $false
  Set-ObjectPropertyIfMissing $gates "public_ready" $false

  $memorial = Get-ObjectProperty $State "memorial"
  Set-ObjectPropertyIfMissing $memorial "drafted" $false
  Set-ObjectPropertyIfMissing $memorial "intent_packet" $false
  Set-ObjectPropertyIfMissing $memorial "intent_gate" $false
  Set-ObjectPropertyIfMissing $memorial "updated_at" $null

  $menxia = Get-ObjectProperty $State "menxia"
  Set-ObjectPropertyIfMissing $menxia "verdict" "NONE"
  Set-ObjectPropertyIfMissing $menxia "approved" $false
  Set-ObjectPropertyIfMissing $menxia "updated_at" $null

  $approvals = Get-ObjectProperty $State "approvals"
  Set-ObjectPropertyIfMissing $approvals "works_delivery" $false

  return $State
}

function Load-State([string]$Cwd, [string]$SessionId) {
  $path = Get-StatePath $Cwd $SessionId
  if (-not (Test-Path -LiteralPath $path)) {
    return (New-DefaultState $SessionId)
  }

  $raw = Get-Content -LiteralPath $path -Raw
  if (-not $raw.Trim()) {
    return (New-DefaultState $SessionId)
  }

  return (Ensure-StateShape ($raw | ConvertFrom-Json) $SessionId)
}

function Save-State([string]$Cwd, [string]$SessionId, $State) {
  $path = Get-StatePath $Cwd $SessionId
  $normalized = Ensure-StateShape $State $SessionId
  $normalized.updated_at = (Get-Date).ToString("o")
  $json = $normalized | ConvertTo-Json -Depth 20
  Set-Content -LiteralPath $path -Value $json -Encoding UTF8
}

function Get-Verdict([string]$Message) {
  if (-not $Message) {
    return "NONE"
  }

  $englishMatch = [regex]::Match($Message, '(?ms)^## (?:Verdict|\u88c1\u51b3)\s+([A-Z]+)\b|\b(APPROVE|CONDITIONAL|RETURN|REJECT)\b')
  if ($englishMatch.Success) {
    foreach ($index in @(1, 2)) {
      $value = $englishMatch.Groups[$index].Value
      if ($value) {
        return $value.ToUpperInvariant()
      }
    }
  }

  if ($Message -match '\u9644\u6761\u4ef6\u6279\u51c6') {
    return "CONDITIONAL"
  }

  if ($Message -match '\u6279\u51c6') {
    return "APPROVE"
  }

  if ($Message -match '\u9000\u56de') {
    return "RETURN"
  }

  if ($Message -match '\u9a73\u56de') {
    return "REJECT"
  }

  return "NONE"
}

function Get-IntentPacketReady([string]$Message) {
  if (-not $Message) {
    return $false
  }

  return ($Message -match '## Intent Packet' -or $Message -match '## \u610f\u56fe\u5305')
}

function Get-IntentGateReady([string]$Message) {
  if (-not $Message) {
    return $false
  }

  return ($Message -match '## Intent Gate Packet' -or $Message -match '## \u610f\u56fe\u95f8\u95e8\u5305')
}

function Get-MemorialReady([string]$Message) {
  if (-not $Message) {
    return $false
  }

  $requiredSections = @(
    @("## Objective", "## \u76ee\u6807"),
    @("## Recommended Mode", "## \u5efa\u8bae\u6a21\u5f0f"),
    @("## Deliverables", "## \u4ea4\u4ed8\u7269")
  )

  foreach ($alternatives in $requiredSections) {
    $found = $false
    foreach ($section in $alternatives) {
      if ($Message -match [regex]::Escape($section)) {
        $found = $true
        break
      }
    }
    if (-not $found) {
      return $false
    }
  }

  return (Get-IntentPacketReady $Message) -and (Get-IntentGateReady $Message)
}

function Write-PreToolDecision([string]$Decision, [string]$Reason) {
  $payload = [ordered]@{
    hookSpecificOutput = [ordered]@{
      hookEventName = "PreToolUse"
      permissionDecision = $Decision
      permissionDecisionReason = $Reason
    }
  }
  $payload | ConvertTo-Json -Depth 10
}

function Write-AdditionalContext([string]$EventName, [string]$Context) {
  $payload = [ordered]@{
    hookSpecificOutput = [ordered]@{
      hookEventName = $EventName
      additionalContext = $Context
    }
  }
  $payload | ConvertTo-Json -Depth 10
}

# Strip namespace prefix from agent_type strings
function Get-AgentRole([string]$AgentType) {
  if (-not $AgentType) { return "" }
  $idx = $AgentType.LastIndexOf(':')
  if ($idx -ge 0) { return $AgentType.Substring($idx + 1) }
  return $AgentType
}

function Get-SidecarDir {
  return Join-Path $env:TEMP "instrument-of-state-hooks"
}

function Write-AgentSidecar([string]$AgentRole, [string]$Cwd, [string]$SessionId) {
  try {
    $dir = Get-SidecarDir
    if (-not (Test-Path -LiteralPath $dir)) { [IO.Directory]::CreateDirectory($dir) | Out-Null }
    $content = "$Cwd`n$SessionId"
    [IO.File]::WriteAllText((Join-Path $dir "$AgentRole.sidecar"), $content, [Text.Encoding]::UTF8)
  } catch { }
}

function Read-AgentSidecar([string]$AgentRole, [ref]$CwdRef, [ref]$SessionIdRef) {
  try {
    $sf = Join-Path (Get-SidecarDir) "$AgentRole.sidecar"
    if (-not (Test-Path -LiteralPath $sf)) { return }
    $parts = [IO.File]::ReadAllText($sf, [Text.Encoding]::UTF8) -split "`n"
    if ($parts.Count -ge 2) {
      $sideCwd = $parts[0].Trim()
      $sideSession = $parts[1].Trim()
      if ($sideCwd) { $CwdRef.Value = $sideCwd }
      if ($sideSession -and $sideSession -ne "session-unknown") { $SessionIdRef.Value = $sideSession }
    }
  } catch { }
}

function Is-MutatingBash([string]$CommandText) {
  if (-not $CommandText) {
    return $false
  }

  $patterns = @(
    '(^|\s)(git\s+(apply|add|commit|mv|rm|restore|checkout|reset|clean)\b)',
    '(^|\s)(mv|move|cp|copy|rm|del|erase|mkdir|touch)\b',
    '(^|\s)(Move-Item|Copy-Item|Remove-Item|Set-Content|Add-Content|New-Item|Rename-Item)\b',
    '(^|\s)(sed\s+-i|perl\s+-pi)\b',
    '(^|\s)(npm\s+version|pnpm\s+version|cargo\s+fmt|go\s+fmt)\b',
    '\s>>?(?!\s*>)'
  )

  foreach ($pattern in $patterns) {
    if ($CommandText -match $pattern) {
      return $true
    }
  }

  return $false
}

function Get-ToolFilePath($InputData) {
  if ($null -eq $InputData) {
    return $null
  }

  $toolInput = Get-ObjectProperty $InputData "tool_input"
  if ($null -eq $toolInput) {
    return $null
  }

  $candidateNames = @(
    "file_path",
    "path",
    "target_file",
    "filename",
    "destination"
  )

  foreach ($name in $candidateNames) {
    $property = $toolInput.PSObject.Properties.Match($name)
    if ($property.Count -gt 0) {
      $value = [string]$property[0].Value
      if ($value) {
        return $value
      }
    }
  }

  return $null
}

function Is-PlanningArtifactPath([string]$PathValue) {
  if (-not $PathValue) {
    return $false
  }

  $leaf = [System.IO.Path]::GetFileName($PathValue)
  return $leaf -in @("task_plan.md", "findings.md", "progress.md")
}

function Get-LatestRunArtifactPath([string]$Cwd) {
  $artifactDir = Join-Path $Cwd "artifacts\runs"
  if (-not (Test-Path -LiteralPath $artifactDir -PathType Container)) {
    return $null
  }

  $latest = Get-ChildItem -LiteralPath $artifactDir -Filter *.json -File | Sort-Object LastWriteTimeUtc -Descending | Select-Object -First 1
  if ($null -eq $latest) {
    return $null
  }

  return $latest.FullName
}

function Test-RunArtifactPublicReady([string]$ArtifactPath) {
  if (-not $ArtifactPath) {
    return $false
  }

  if (-not (Test-Path -LiteralPath $ArtifactPath -PathType Leaf)) {
    return $false
  }

  try {
    $artifact = Get-Content -LiteralPath $ArtifactPath -Raw | ConvertFrom-Json
    $verificationPacket = Get-ObjectProperty $artifact "verificationPacket"
    $summaryPacket = Get-ObjectProperty $artifact "summaryPacket"
    $publicationPacket = Get-ObjectProperty $artifact "publicationPacket"

    $verifyPassed = [bool](Get-ObjectProperty $verificationPacket "verifyPassed" $false)
    $summaryClosed = [bool](Get-ObjectProperty $summaryPacket "summaryClosed" $false)
    $singleDeliverableMaintained = [bool](Get-ObjectProperty $summaryPacket "singleDeliverableMaintained" $false)
    $deliverableChainClosed = [bool](Get-ObjectProperty $summaryPacket "deliverableChainClosed" $false)
    $consolidatedDeliverablePresent = [bool](Get-ObjectProperty $summaryPacket "consolidatedDeliverablePresent" $false)
    $publicReady = [bool](Get-ObjectProperty $summaryPacket "publicReady" $false)
    $publicReadyEvidence = Get-ObjectProperty $publicationPacket "publicReadyEvidence" @()
    $evidenceCount = if ($null -eq $publicReadyEvidence) { 0 } elseif ($publicReadyEvidence -is [System.Array]) { $publicReadyEvidence.Count } elseif ($publicReadyEvidence -is [System.Collections.IEnumerable] -and -not ($publicReadyEvidence -is [string])) { @($publicReadyEvidence).Count } elseif ([string]$publicReadyEvidence) { 1 } else { 0 }

    return $verifyPassed -and $summaryClosed -and $singleDeliverableMaintained -and $deliverableChainClosed -and $consolidatedDeliverablePresent -and $publicReady -and ($evidenceCount -gt 0)
  } catch {
    return $false
  }
}

try {
  $inputData = Read-HookInput
  $cwdValue = Get-ObjectProperty $inputData "cwd"
  $sessionValue = Get-ObjectProperty $inputData "session_id"
  $cwd = if ($cwdValue) { [string]$cwdValue } else { (Get-Location).Path }
  $sessionId = if ($sessionValue) { [string]$sessionValue } else { "session-unknown" }

  switch ($Mode) {
    "session-context" {
      Write-DebugLog $cwd $Mode $sessionId "session context requested"
      $contextParts = [System.Collections.Generic.List[string]]::new()
      $contextParts.Add("Governed order: for substantial work, open the docket first, then draft with Zhongshu, review with Menxia, and only then unlock Works Delivery.")
      $contextParts.Add("Meta layer: before heavy execution, lock intent through an intent packet and intent gate packet. Do not treat unstated assumptions as settled authority.")
      $contextParts.Add("Capability ladder: local skills and plugins first, then find-skills, then approved marketplaces if a gap remains.")
      $contextParts.Add("Only Works Delivery may land governed file changes. The only exception is planning artifacts: task_plan.md, findings.md, and progress.md.")
      $contextParts.Add("Public-ready law: implementation finished does not automatically mean ready for outward publication. Verification and summary closure must be explicit.")

      $spSkillPath = Join-Path $env:USERPROFILE ".claude\skills\superpowers"
      $spPluginPath = Join-Path $env:USERPROFILE ".claude\plugins\superpowers"
      $superpowersInstalled = (Test-Path -LiteralPath $spSkillPath -PathType Container) -or (Test-Path -LiteralPath $spPluginPath -PathType Container)

      if ($superpowersInstalled) {
        $contextParts.Add("Superpowers is active. Use its skills at the correct governance stage as defined in references/superpowers-integration.md: brainstorming at intake, writing-plans after the memorial, executing-plans and subagent-driven-development for delivery, systematic-debugging for incidents, verification-before-completion and requesting-code-review before close-out.")
      } else {
        $contextParts.Add("Superpowers is not installed. It provides brainstorming, planning, debugging, and verification skills that pair with this governance system. Install it with: /plugin install superpowers@superpowers-marketplace")
      }

      Write-AdditionalContext "SessionStart" ($contextParts -join " ")
      exit 0
    }

    "reset" {
      Write-DebugLog $cwd $Mode $sessionId "reset state"
      $state = New-DefaultState $SessionId
      Save-State $cwd $sessionId $state
      exit 0
    }

    "record-zhongshu" {
      Read-AgentSidecar "zhongshu-agent" ([ref]$cwd) ([ref]$sessionId)
      $state = Load-State $cwd $sessionId
      $message = [string](Get-ObjectProperty $inputData "last_assistant_message" "")
      $drafted = Get-MemorialReady $message
      $intentPacket = Get-IntentPacketReady $message
      $intentGate = Get-IntentGateReady $message
      Write-DebugLog $cwd $Mode $sessionId ("record zhongshu drafted={0} intent_packet={1} intent_gate={2}" -f $drafted, $intentPacket, $intentGate)
      $state.memorial.drafted = $drafted
      $state.memorial.intent_packet = $intentPacket
      $state.memorial.intent_gate = $intentGate
      $state.memorial.updated_at = (Get-Date).ToString("o")
      $state.gates.intent_locked = $intentPacket
      $state.gates.intent_gate_resolved = $intentGate
      $state.gates.memorial_ready = $drafted
      $state.meta.stage_state = "DRAFT"
      $state.meta.gate_state = if ($drafted) { "REVIEW_OPEN" } else { "INTENT_OPEN" }
      $state.meta.authority_state = "REVIEW_ONLY"
      Save-State $cwd $sessionId $state
      exit 0
    }

    "record-menxia" {
      Read-AgentSidecar "menxia-agent" ([ref]$cwd) ([ref]$sessionId)
      $state = Load-State $cwd $sessionId
      $verdict = Get-Verdict ([string](Get-ObjectProperty $inputData "last_assistant_message" ""))
      Write-DebugLog $cwd $Mode $sessionId ("record menxia verdict={0}" -f $verdict)
      $approved = $verdict -eq "APPROVE"
      $state.menxia.verdict = $verdict
      $state.menxia.approved = $approved
      $state.menxia.updated_at = (Get-Date).ToString("o")
      $state.approvals.works_delivery = $approved
      $state.gates.review_ready = $approved
      $state.meta.stage_state = "REVIEW"
      $state.meta.gate_state = if ($approved) { "WORKS_UNLOCKED" } else { "WORKS_LOCKED" }
      $state.meta.authority_state = if ($approved) { "WORKS_UNLOCKED" } else { "REVIEW_ONLY" }
      Save-State $cwd $sessionId $state
      exit 0
    }

    "record-agent-result" {
      $toolInput = Get-ObjectProperty $inputData "tool_input"
      $subagentType = [string](Get-ObjectProperty $toolInput "subagent_type" "")
      $agentRole = Get-AgentRole $subagentType
      $agentOutput = [string](Get-ObjectProperty $inputData "tool_response" "")
      if (-not $agentOutput) { $agentOutput = [string](Get-ObjectProperty $inputData "output" "") }
      if (-not $agentOutput) { $agentOutput = [string](Get-ObjectProperty $inputData "result" "") }
      Write-DebugLog $cwd $Mode $sessionId ("record agent result role={0} output_len={1}" -f $agentRole, $agentOutput.Length)

      if ($agentRole -eq "zhongshu-agent") {
        $state = Load-State $cwd $sessionId
        $drafted = Get-MemorialReady $agentOutput
        $intentPacket = Get-IntentPacketReady $agentOutput
        $intentGate = Get-IntentGateReady $agentOutput
        Write-DebugLog $cwd $Mode $sessionId ("zhongshu result drafted={0} intent_packet={1} intent_gate={2}" -f $drafted, $intentPacket, $intentGate)
        $state.memorial.drafted = $drafted
        $state.memorial.intent_packet = $intentPacket
        $state.memorial.intent_gate = $intentGate
        $state.memorial.updated_at = (Get-Date).ToString("o")
        $state.gates.intent_locked = $intentPacket
        $state.gates.intent_gate_resolved = $intentGate
        $state.gates.memorial_ready = $drafted
        $state.meta.stage_state = "DRAFT"
        $state.meta.gate_state = if ($drafted) { "REVIEW_OPEN" } else { "INTENT_OPEN" }
        $state.meta.authority_state = "REVIEW_ONLY"
        Save-State $cwd $sessionId $state
      } elseif ($agentRole -eq "menxia-agent") {
        $state = Load-State $cwd $sessionId
        $verdict = Get-Verdict $agentOutput
        Write-DebugLog $cwd $Mode $sessionId ("menxia result verdict={0}" -f $verdict)
        $approved = $verdict -eq "APPROVE"
        $state.menxia.verdict = $verdict
        $state.menxia.approved = $approved
        $state.menxia.updated_at = (Get-Date).ToString("o")
        $state.approvals.works_delivery = $approved
        $state.gates.review_ready = $approved
        $state.meta.stage_state = "REVIEW"
        $state.meta.gate_state = if ($approved) { "WORKS_UNLOCKED" } else { "WORKS_LOCKED" }
        $state.meta.authority_state = if ($approved) { "WORKS_UNLOCKED" } else { "REVIEW_ONLY" }
        Save-State $cwd $sessionId $state
      }

      exit 0
    }

    "annotate-start" {
      $state = Load-State $cwd $sessionId
      $agentType = [string](Get-ObjectProperty $inputData "agent_type" "")
      $agentRole = Get-AgentRole $agentType
      Write-DebugLog $cwd $Mode $sessionId ("annotate agent={0}" -f $agentType)

      if ($agentRole -in @("zhongshu-agent", "menxia-agent", "works-delivery-agent")) {
        Write-AgentSidecar $agentRole $cwd $sessionId
      }

      if ($agentRole -eq "zhongshu-agent") {
        Write-AdditionalContext "SubagentStart" "Use planning artifacts if they exist. Draft the memorial only. Include at least ## Intent Packet or ## 意图包, ## Intent Gate Packet or ## 意图闸门包, ## Objective or ## 目标, ## Recommended Mode or ## 建议模式, and ## Deliverables or ## 交付物. Do not execute."
        exit 0
      }

      if ($agentRole -eq "menxia-agent") {
        Write-AdditionalContext "SubagentStart" "Review only. Inspect both the memorial content and the protocol gates. Return an explicit ## Verdict with one of: APPROVE, CONDITIONAL, RETURN, REJECT. Only APPROVE unlocks Works Delivery."
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
      $state = Load-State $cwd $sessionId
      $toolInput = Get-ObjectProperty $inputData "tool_input"
      $subagentType = [string](Get-ObjectProperty $toolInput "subagent_type" "")
      $agentRole = Get-AgentRole $subagentType
      Write-DebugLog $cwd $Mode $sessionId ("guard agent subagent_type={0} memorial={1} approved={2}" -f $subagentType, [bool]$state.memorial.drafted, [bool]$state.approvals.works_delivery)

      if ($agentRole -eq "menxia-agent" -and -not [bool]$state.memorial.drafted) {
        Write-PreToolDecision "deny" "Menxia review is blocked until Zhongshu has produced a formal memorial with intent lock for this petition."
        exit 0
      }

      if ($agentRole -ne "works-delivery-agent") {
        exit 0
      }

      if (-not [bool]$state.approvals.works_delivery) {
        Write-PreToolDecision "deny" "Works Delivery is not unlocked because Menxia has not approved this petition yet."
        exit 0
      }

      exit 0
    }

    "guard-tool" {
      $state = Load-State $cwd $sessionId
      $toolInput = Get-ObjectProperty $inputData "tool_input"
      $agentType = [string](Get-ObjectProperty $inputData "agent_type" "")
      $agentRole = Get-AgentRole $agentType
      $toolName = [string](Get-ObjectProperty $inputData "tool_name" "")
      $filePath = Get-ToolFilePath $inputData
      $isPlanningArtifact = Is-PlanningArtifactPath $filePath
      Write-DebugLog $cwd $Mode $sessionId ("guard tool agent={0} tool={1} path={2}" -f $agentType, $toolName, $filePath)

      if ($agentRole -ne "works-delivery-agent") {
        if ($toolName -in @("Write", "Edit")) {
          if ($isPlanningArtifact) {
            exit 0
          }
          Write-PreToolDecision "deny" "Governed file writes are reserved for Works Delivery. Other offices may inspect and advise, but may not write files."
          exit 0
        }

        if ($toolName -eq "Bash") {
          $commandText = [string](Get-ObjectProperty $toolInput "command" "")
          if ($agentRole -eq "rites-protocol-agent" -and $commandText -match 'lark-cli\s+im\s+\+messages-send\b') {
            $artifactPath = Get-LatestRunArtifactPath $cwd
            $publicReady = Test-RunArtifactPublicReady $artifactPath
            Write-DebugLog $cwd $Mode $sessionId ("publication notify check artifact={0} public_ready={1}" -f $artifactPath, $publicReady)
            if (-not $publicReady) {
              Write-PreToolDecision "deny" "Lark IM notification is blocked until a governed run artifact proves public-ready closure. Update the latest artifacts/runs/*.json summaryPacket and publicationPacket first, or downgrade to plan/doc-only publication."
              exit 0
            }
          }

          if (Is-MutatingBash $commandText) {
            Write-PreToolDecision "deny" "Mutating workspace commands are reserved for Works Delivery after Menxia approval. Other offices may inspect and plan only."
            exit 0
          }
        }

        exit 0
      }

      if ([bool]$state.approvals.works_delivery) {
        exit 0
      }

      if ($toolName -in @("Write", "Edit")) {
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
  if ($cwd -and $sessionId) {
    Write-DebugLog $cwd $Mode $sessionId ("error={0}" -f $_.Exception.Message)
  }
  Write-SoftFailure $Mode
  exit 0
}
