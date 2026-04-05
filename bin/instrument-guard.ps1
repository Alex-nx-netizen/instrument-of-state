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
    memorial = [ordered]@{
      drafted = $false
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

function Load-State([string]$Cwd, [string]$SessionId) {
  $path = Get-StatePath $Cwd $SessionId
  if (-not (Test-Path -LiteralPath $path)) {
    return (New-DefaultState $SessionId)
  }

  $raw = Get-Content -LiteralPath $path -Raw
  if (-not $raw.Trim()) {
    return (New-DefaultState $SessionId)
  }

  return $raw | ConvertFrom-Json
}

function Save-State([string]$Cwd, [string]$SessionId, $State) {
  $path = Get-StatePath $Cwd $SessionId
  $State.updated_at = (Get-Date).ToString("o")
  $json = $State | ConvertTo-Json -Depth 20
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

  return $true
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
    '>|>>'
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

try {
  $inputData = Read-HookInput
  $cwdValue = Get-ObjectProperty $inputData "cwd"
  $sessionValue = Get-ObjectProperty $inputData "session_id"
  $cwd = if ($cwdValue) { [string]$cwdValue } else { (Get-Location).Path }
  $sessionId = if ($sessionValue) { [string]$sessionValue } else { "session-unknown" }

  switch ($Mode) {
    "session-context" {
      Write-DebugLog $cwd $Mode $sessionId "session context requested"
      $context = @(
        "Governed order: for substantial work, open the docket first, then draft with Zhongshu, review with Menxia, and only then unlock Works Delivery.",
        "Capability ladder: local skills and plugins first, then find-skills, then approved marketplaces if a gap remains.",
        "Only Works Delivery may land governed file changes. The only exception is planning artifacts: task_plan.md, findings.md, and progress.md."
      ) -join " "
      Write-AdditionalContext "SessionStart" $context
      exit 0
    }

    "reset" {
      Write-DebugLog $cwd $Mode $sessionId "reset state"
      $state = New-DefaultState $sessionId
      Save-State $cwd $sessionId $state
      exit 0
    }

    "record-zhongshu" {
      $state = Load-State $cwd $sessionId
      $drafted = Get-MemorialReady ([string](Get-ObjectProperty $inputData "last_assistant_message" ""))
      Write-DebugLog $cwd $Mode $sessionId ("record zhongshu drafted={0}" -f $drafted)
      $state.memorial.drafted = $drafted
      $state.memorial.updated_at = (Get-Date).ToString("o")
      Save-State $cwd $sessionId $state
      exit 0
    }

    "record-menxia" {
      $state = Load-State $cwd $sessionId
      $verdict = Get-Verdict ([string](Get-ObjectProperty $inputData "last_assistant_message" ""))
      Write-DebugLog $cwd $Mode $sessionId ("record menxia verdict={0}" -f $verdict)
      $approved = $verdict -eq "APPROVE"
      $state.menxia.verdict = $verdict
      $state.menxia.approved = $approved
      $state.menxia.updated_at = (Get-Date).ToString("o")
      $state.approvals.works_delivery = $approved
      Save-State $cwd $sessionId $state
      exit 0
    }

    "annotate-start" {
      $state = Load-State $cwd $sessionId
      $agentType = [string](Get-ObjectProperty $inputData "agent_type" "")
      Write-DebugLog $cwd $Mode $sessionId ("annotate agent={0}" -f $agentType)

      if ($agentType -eq "zhongshu-agent") {
        Write-AdditionalContext "SubagentStart" "Use planning artifacts if they exist. Draft the memorial only. Include at least ## Objective, ## Recommended Mode, and ## Deliverables. Do not execute."
        exit 0
      }

      if ($agentType -eq "menxia-agent") {
        Write-AdditionalContext "SubagentStart" "Review only. Return an explicit ## Verdict with one of: APPROVE, CONDITIONAL, RETURN, REJECT. Only APPROVE unlocks Works Delivery."
        exit 0
      }

      if ($agentType -eq "works-delivery-agent") {
        $approved = [bool]$state.approvals.works_delivery
        if ($approved) {
          Write-AdditionalContext "SubagentStart" "Menxia approval is on record. Works Delivery may execute only within the approved memorial and conditions."
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
      Write-DebugLog $cwd $Mode $sessionId ("guard agent subagent_type={0} memorial={1} approved={2}" -f $subagentType, [bool]$state.memorial.drafted, [bool]$state.approvals.works_delivery)

      if ($subagentType -eq "menxia-agent" -and -not [bool]$state.memorial.drafted) {
        Write-PreToolDecision "deny" "Menxia review is blocked until Zhongshu has produced a formal memorial for this petition."
        exit 0
      }

      if ($subagentType -ne "works-delivery-agent") {
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
      $toolName = [string](Get-ObjectProperty $inputData "tool_name" "")
      $filePath = Get-ToolFilePath $inputData
      $isPlanningArtifact = Is-PlanningArtifactPath $filePath
      Write-DebugLog $cwd $Mode $sessionId ("guard tool agent={0} tool={1} path={2}" -f $agentType, $toolName, $filePath)

      if ($agentType -ne "works-delivery-agent") {
        if ($toolName -in @("Write", "Edit")) {
          if ($isPlanningArtifact) {
            exit 0
          }
          Write-PreToolDecision "deny" "Governed file writes are reserved for Works Delivery. Other offices may inspect and advise, but may not write files."
          exit 0
        }

        if ($toolName -eq "Bash") {
          $commandText = [string](Get-ObjectProperty $toolInput "command" "")
          if (Is-MutatingBash $CommandText) {
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
        if (Is-MutatingBash $CommandText) {
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
