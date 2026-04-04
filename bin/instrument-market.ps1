Set-StrictMode -Version Latest
$ErrorActionPreference = "Stop"

$rawInvocation = $env:INSTRUMENT_MARKET_RAWARGS
if ($rawInvocation) {
  $env:INSTRUMENT_MARKET_RAWARGS = ""
} elseif ($args.Count -gt 0) {
  $rawInvocation = ($args -join " ")
} else {
  throw "Usage: instrument-market.cmd <inventory|search|resolve|install> ..."
}

$rawInvocation = $rawInvocation.Trim()
if ($rawInvocation -notmatch '^\s*(\S+)\s*(.*)$') {
  throw "Could not parse marketplace command."
}

$Mode = $matches[1]
$Tail = $matches[2].Trim()

function Get-Query([string]$RawTail) {
  $query = $RawTail.Trim()
  if ($query.StartsWith('"') -and $query.EndsWith('"') -and $query.Length -ge 2) {
    return $query.Substring(1, $query.Length - 2)
  }
  return $query
}

function Get-Tokens([string]$RawTail) {
  if (-not $RawTail) {
    return @()
  }
  return ($RawTail -split '\s+' | Where-Object { $_ })
}

function Normalize-Terms([string]$Query) {
  if (-not $Query) {
    return @()
  }

  return ($Query.ToLowerInvariant() -split '[^a-z0-9\u4e00-\u9fff]+' | Where-Object { $_ -and $_.Length -ge 2 })
}

function Get-Score([string]$Text, [string[]]$Terms) {
  if (-not $Text) {
    return 0
  }

  $haystack = $Text.ToLowerInvariant()
  $score = 0
  foreach ($term in $Terms) {
    if ($haystack.Contains($term)) {
      $score += 1
    }
  }
  return $score
}

function Get-OptionalProperty($Object, [string]$Name, $Default = $null) {
  if ($null -eq $Object) {
    return $Default
  }
  if ($Object.PSObject.Properties.Name -contains $Name) {
    return $Object.$Name
  }
  return $Default
}

function Parse-SkillManifest([string]$Path) {
  $content = Get-Content -LiteralPath $Path -Raw
  $match = [regex]::Match($content, '(?ms)^---\s*(.*?)\s*---')
  if (-not $match.Success) {
    return $null
  }

  $frontmatter = $match.Groups[1].Value
  $name = [regex]::Match($frontmatter, '(?m)^name:\s*(.+)$').Groups[1].Value.Trim()
  $description = [regex]::Match($frontmatter, '(?m)^description:\s*(.+)$').Groups[1].Value.Trim()

  if (-not $name) {
    return $null
  }

  return [pscustomobject]@{
    name = $name
    description = $description
    path = $Path
  }
}

function Parse-PluginManifest([string]$Path) {
  try {
    $json = Get-Content -LiteralPath $Path -Raw | ConvertFrom-Json
  } catch {
    return $null
  }

  $name = [string](Get-OptionalProperty $json "name" "")
  if (-not $name) {
    return $null
  }

  return [pscustomobject]@{
    name = $name
    description = [string](Get-OptionalProperty $json "description" "")
    path = $Path
  }
}

function Get-LocalSkillCandidates([string]$Cwd, [string[]]$Terms) {
  $roots = @(
    (Join-Path $Cwd ".claude\skills"),
    (Join-Path $Cwd ".codex\skills"),
    (Join-Path $Cwd ".agents\skills"),
    (Join-Path $HOME ".claude\skills"),
    (Join-Path $HOME ".codex\skills"),
    (Join-Path $HOME ".agents\skills"),
    (Join-Path $PSScriptRoot "..\skills")
  ) | Select-Object -Unique

  $results = @()
  foreach ($root in $roots) {
    if (-not (Test-Path -LiteralPath $root)) {
      continue
    }

    $files = Get-ChildItem -LiteralPath $root -Recurse -Filter SKILL.md -File -ErrorAction SilentlyContinue
    foreach ($file in $files) {
      $meta = Parse-SkillManifest $file.FullName
      if ($null -eq $meta) {
        continue
      }
      $score = Get-Score "$($meta.name) $($meta.description)" $Terms
      if ($score -gt 0) {
        $results += [pscustomobject]@{
          source = "local-skill"
          name = $meta.name
          description = $meta.description
          path = $meta.path
          score = $score
        }
      }
    }
  }

  return $results | Sort-Object -Property @{ Expression = "score"; Descending = $true }, @{ Expression = "name"; Descending = $false }
}

function Get-LocalPluginCandidates([string]$Cwd, [string[]]$Terms) {
  $roots = @(
    (Join-Path $Cwd ".claude\plugins"),
    (Join-Path $Cwd ".codex\plugins"),
    (Join-Path $Cwd "plugins"),
    (Join-Path $HOME ".claude\plugins"),
    (Join-Path $HOME ".codex\plugins"),
    (Join-Path $HOME ".codex\plugins\cache")
  ) | Select-Object -Unique

  $results = @()
  foreach ($root in $roots) {
    if (-not (Test-Path -LiteralPath $root)) {
      continue
    }

    $files = Get-ChildItem -LiteralPath $root -Recurse -File -Filter plugin.json -ErrorAction SilentlyContinue |
      Where-Object { $_.FullName -match '[\\/]\.claude-plugin[\\/]plugin\.json$' }

    foreach ($file in $files) {
      $meta = Parse-PluginManifest $file.FullName
      if ($null -eq $meta) {
        continue
      }
      $score = Get-Score "$($meta.name) $($meta.description) $($meta.path)" $Terms
      if ($score -gt 0) {
        $results += [pscustomobject]@{
          source = "local-plugin"
          name = $meta.name
          description = $meta.description
          path = $meta.path
          score = $score
        }
      }
    }
  }

  return $results | Sort-Object -Property @{ Expression = "score"; Descending = $true }, @{ Expression = "name"; Descending = $false }
}

function Get-KnownMarketplaces {
  $path = Join-Path $PSScriptRoot "..\references\known-marketplaces.json"
  $json = Get-Content -LiteralPath $path -Raw | ConvertFrom-Json
  return $json.marketplaces
}

function Get-GitHubJson([string]$Repo, [string]$ContentPath) {
  $uri = "https://api.github.com/repos/$Repo/contents/$ContentPath"
  $headers = @{
    "User-Agent" = "instrument-of-state"
    "Accept" = "application/vnd.github+json"
  }

  $response = Invoke-RestMethod -Method Get -Uri $uri -Headers $headers
  if (-not $response.content) {
    return $null
  }

  $decoded = [System.Text.Encoding]::UTF8.GetString([Convert]::FromBase64String(($response.content -replace "`n", "")))
  return $decoded | ConvertFrom-Json
}

function Get-MarketplaceCandidates([string[]]$Terms) {
  $results = @()
  foreach ($marketplace in Get-KnownMarketplaces) {
    try {
      $catalog = Get-GitHubJson $marketplace.repo ".claude-plugin/marketplace.json"
    } catch {
      continue
    }

    foreach ($plugin in (Get-OptionalProperty $catalog "plugins" @())) {
      $pluginPath = $null
      $pluginDescription = ""
      $pluginSource = Get-OptionalProperty $plugin "source"
      $pluginCategory = [string](Get-OptionalProperty $plugin "category" "")
      $pluginName = [string](Get-OptionalProperty $plugin "name" "")

      if ($null -ne $pluginSource -and (Get-OptionalProperty $pluginSource "source") -eq "local" -and (Get-OptionalProperty $pluginSource "path")) {
        $pluginPath = (((Get-OptionalProperty $pluginSource "path") -replace '^[.][/\\]+', '') -replace '\\', '/').Trim('/')
        $pluginManifestPath = "$pluginPath/.claude-plugin/plugin.json"
        try {
          $pluginManifest = Get-GitHubJson $marketplace.repo $pluginManifestPath
          $pluginDescription = [string](Get-OptionalProperty $pluginManifest "description" "")
        } catch {
          $pluginDescription = ""
        }
      }

      $basis = @(
        $pluginName,
        $pluginCategory,
        [string]$pluginDescription
      ) -join " "

      $score = Get-Score $basis $Terms
      if ($score -gt 0) {
        $results += [pscustomobject]@{
          source = "github-marketplace"
          marketplace = [string](Get-OptionalProperty $catalog "name" "")
          repo = [string]$marketplace.repo
          plugin = $pluginName
          description = $pluginDescription
          category = $pluginCategory
          score = $score
        }
      }
    }
  }

  return $results | Sort-Object -Property @{ Expression = "score"; Descending = $true }, @{ Expression = "plugin"; Descending = $false }
}

function Resolve-InstallScope([string[]]$Args) {
  $scope = $Args | Select-Object -Last 1
  if ($scope -in @("local", "project", "user")) {
    return $scope
  }
  return "project"
}

switch ($Mode) {
  "inventory" {
    $query = Get-Query $Tail
    $terms = Normalize-Terms $query
    $cwd = (Get-Location).Path
    $localSkills = @(Get-LocalSkillCandidates $cwd $terms)
    $localPlugins = @(Get-LocalPluginCandidates $cwd $terms)
    $payload = [ordered]@{
      query = $query
      local_skills = $localSkills
      local_plugins = $localPlugins
    }
    $payload | ConvertTo-Json -Depth 10
    exit 0
  }

  "search" {
    $query = Get-Query $Tail
    $terms = Normalize-Terms $query
    $results = Get-MarketplaceCandidates $terms
    $results | ConvertTo-Json -Depth 10
    exit 0
  }

  "resolve" {
    $query = Get-Query $Tail
    $terms = Normalize-Terms $query
    $cwd = (Get-Location).Path
    $localSkills = @(Get-LocalSkillCandidates $cwd $terms)
    $localPlugins = @(Get-LocalPluginCandidates $cwd $terms)
    $marketplaces = @(Get-MarketplaceCandidates $terms)
    $payload = [ordered]@{
      query = $query
      local = $localSkills
      local_skills = $localSkills
      local_plugins = $localPlugins
      marketplaces = $marketplaces
    }
    $payload | ConvertTo-Json -Depth 10
    exit 0
  }

  "install" {
    $installArgs = Get-Tokens $Tail
    if ($installArgs.Length -lt 2) {
      throw "Usage: instrument-market.cmd install <github-repo> <plugin-name> [local|project|user]"
    }

    $repo = $installArgs[0]
    $plugin = $installArgs[1]
    $scope = Resolve-InstallScope $installArgs
    $catalog = Get-GitHubJson $repo ".claude-plugin/marketplace.json"
    $marketplaceName = [string]$catalog.name

    try {
      & claude plugin marketplace add $repo | Out-Null
    } catch {
      # Marketplace may already be configured. Continue to install.
    }

    & claude plugin install "$plugin@$marketplaceName" --scope $scope
    exit $LASTEXITCODE
  }

  default {
    throw "Unknown mode: $Mode"
  }
}
