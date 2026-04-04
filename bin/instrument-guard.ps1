param(
  [Parameter(Position = 0, Mandatory = $true)]
  [string]$Mode
)

Set-StrictMode -Version Latest
$ErrorActionPreference = "Stop"

function Read-HookInput {
  if ([Console]::IsInputRedirected) {
    $raw = [Console]::In.ReadToEnd()
    if ($raw -and $raw.Trim().Length -gt 0) {
      return $raw | ConvertFrom-Json
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

function Get-StatePath([string]$Cwd, [string]$SessionId) {
  $dir = Ensure-StateDirectory $Cwd
  return Join-Path $dir "$SessionId.json"
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

  $chineseVerdictMap = @{
    '批准' = 'APPROVE'
    '附条件批准' = 'CONDITIONAL'
    '退回' = 'RETURN'
    '驳回' = 'REJECT'
  }

  $patterns = @(
    '(?ms)^## (?:Verdict|裁决)\s+([A-Z]+)\b',
    '\b(APPROVE|CONDITIONAL|RETURN|REJECT)\b',
    '(附条件批准|批准|退回|驳回)'
  )

  foreach ($pattern in $patterns) {
    $match = [regex]::Match($Message, $pattern)
    if ($match.Success) {
      $value = $match.Groups[1].Value
      if ($chineseVerdictMap.ContainsKey($value)) {
        return $chineseVerdictMap[$value]
      }
      return $value.ToUpperInvariant()
    }
  }

  return "NONE"
}

function Get-MemorialReady([string]$Message) {
  if (-not $Message) {
    return $false
  }

  # Support both English and Chinese section headers
  $requiredSections = @(
    @("## Objective", "## 目标"),
    @("## Recommended Mode", "## 建议模式"),
    @("## Deliverables", "## 交付物")
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

$inputData = Read-HookInput
$cwdValue = Get-ObjectProperty $inputData "cwd"
$sessionValue = Get-ObjectProperty $inputData "session_id"
$cwd = if ($cwdValue) { [string]$cwdValue } else { (Get-Location).Path }
$sessionId = if ($sessionValue) { [string]$sessionValue } else { "session-unknown" }

switch ($Mode) {
  "session-context" {
    $context = @(
      "Constitutional order: for substantial work open the docket with planning-with-files, then draft with Zhongshu, review with Menxia, and only then dispatch delivery.",
      "Capability ladder: local skills and plugins first, then find-skills, then approved GitHub plugin marketplaces.",
      "Only Works Delivery may land governed file changes. The sole exception is planning artifacts: task_plan.md, findings.md, and progress.md."
    ) -join " "
    Write-AdditionalContext "SessionStart" $context
    exit 0
  }

  "reset" {
    $state = New-DefaultState $sessionId
    Save-State $cwd $sessionId $state
    exit 0
  }

  "record-zhongshu" {
    $state = Load-State $cwd $sessionId
    $drafted = Get-MemorialReady ([string](Get-ObjectProperty $inputData "last_assistant_message" ""))
    $state.memorial.drafted = $drafted
    $state.memorial.updated_at = (Get-Date).ToString("o")
    Save-State $cwd $sessionId $state
    exit 0
  }

  "record-menxia" {
    $state = Load-State $cwd $sessionId
    $verdict = Get-Verdict ([string](Get-ObjectProperty $inputData "last_assistant_message" ""))
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

    if ($agentType -eq "zhongshu-agent") {
      Write-AdditionalContext "SubagentStart" "Use planning artifacts if they exist. Produce a real memorial with ## Objective, ## Recommended Mode, and ## Deliverables. Do not execute."
      exit 0
    }

    if ($agentType -eq "menxia-agent") {
      Write-AdditionalContext "SubagentStart" "Issue an explicit ## Verdict section with one of: APPROVE, CONDITIONAL, RETURN, REJECT. Check planning discipline and capability ladder compliance. Only APPROVE authorizes Works Delivery."
      exit 0
    }

    if ($agentType -eq "works-delivery-agent") {
      $approved = [bool]$state.approvals.works_delivery
      if ($approved) {
        Write-AdditionalContext "SubagentStart" "Menxia approval is recorded for this petition. Deliver only within the approved memorial and review conditions."
      } else {
        Write-AdditionalContext "SubagentStart" "No Menxia APPROVE is currently recorded for this petition. You may inspect, but file landing and mutating commands will be blocked by hook law."
      }
      exit 0
    }

    exit 0
  }

  "guard-agent" {
    $state = Load-State $cwd $sessionId
    $toolInput = Get-ObjectProperty $inputData "tool_input"
    $subagentType = [string](Get-ObjectProperty $toolInput "subagent_type" "")

    if ($subagentType -eq "menxia-agent" -and -not [bool]$state.memorial.drafted) {
      Write-PreToolDecision "deny" "Menxia cannot be spawned until Zhongshu has produced a memorial for the current petition."
      exit 0
    }

    if ($subagentType -ne "works-delivery-agent") {
      exit 0
    }

    if (-not [bool]$state.approvals.works_delivery) {
      Write-PreToolDecision "deny" "Works Delivery cannot be spawned because Menxia has not issued APPROVE for the current petition."
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

    if ($agentType -ne "works-delivery-agent") {
      if ($toolName -in @("Write", "Edit")) {
        if ($isPlanningArtifact) {
          exit 0
        }
        Write-PreToolDecision "deny" "Governed file landing is reserved for Works Delivery. Other ministries may advise but may not write files."
        exit 0
      }

      if ($toolName -eq "Bash") {
        $commandText = [string](Get-ObjectProperty $toolInput "command" "")
        if (Is-MutatingBash $commandText) {
          Write-PreToolDecision "deny" "Mutating shell commands are reserved for Works Delivery after approval. Other ministries may inspect and plan, but may not mutate the workspace."
          exit 0
        }
      }

      exit 0
    }

    if ([bool]$state.approvals.works_delivery) {
      exit 0
    }

    if ($toolName -in @("Write", "Edit")) {
      Write-PreToolDecision "deny" "Works Delivery write access is blocked because Menxia has not issued APPROVE for the current petition."
      exit 0
    }

    if ($toolName -eq "Bash") {
      $commandText = [string](Get-ObjectProperty $toolInput "command" "")
      if (Is-MutatingBash $commandText) {
        Write-PreToolDecision "deny" "Mutating shell commands are blocked because Menxia has not issued APPROVE for the current petition."
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
