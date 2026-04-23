# Scar — Justice Compliance cannot run guard self-introspection live

**Date:** 2026-04-24
**Docket:** `2026-04-24-v0.6.1-capability-gaps`
**Severity:** medium (ergonomics / capability gap, not a correctness bug)

## What happened

During meta-reforge V5c Justice final verification, the
`justice-compliance-agent` attempted to call
`powershell bin/instrument-guard.ps1 health` to read live session
state. The `guard-tool` hook treated the bash invocation as a
mutating workspace command and denied it. Justice was forced to
downgrade V5c to static code audit, which proves the guard's code
is correct but does not prove the running session actually honors
that code.

## Root cause

`Is-MutatingBash` in `bin/instrument-guard.ps1` uses a read-only
whitelist — anything not matching is treated as mutating. The
whitelist covered generic read-only tools (`cat`, `ls`, `git status`,
etc.) but not the project's own `instrument-guard.ps1` health /
session-context self-introspection. Those subcommands mutate nothing;
they only read `$cwd/.claude/instrument-of-state/state/*.json` and
emit a JSON summary via the PostToolUse/SessionStart hook contracts.

Architecturally the restriction was over-conservative: any office
inspecting the running guard was forced to either read the JSON file
directly (bypassing the guard's HMAC verification and state-shape
normalization) or limit itself to static audit.

## Fix (FIX-10)

In `guard-tool` Bash branch, before `Is-MutatingBash`, allow
`instrument-guard.ps1 (health|session-context)` invocation for any
office. Connector characters (`|`, `>`, `<`, `;`, `&&`, `||`) still
force the check to fall through — the exemption is for pure
invocation only, not for chained or redirected commands.

```
if ($commandText -match 'instrument-guard\.ps1\s+(health|session-context)\b' -and
    $commandText -notmatch '[><|;]' -and
    $commandText -notmatch '&&' -and
    $commandText -notmatch '\|\|') {
  Write-DebugLog $cwd $Mode $sessionId "guard self-introspection - allow"
  exit 0
}
```

This lets Justice-Compliance run V5c as a live check, matching the
verification semantics expected by the constitutional-rules doctrine.

## Pattern seed

When a governance tool's whitelist blocks the tool's own introspection
from non-executive offices, the tool becomes a black box that only
the executive office can audit. Introspection surface area (read-only
self-queries) should be open to all offices; execution surface area
(mutating commands) stays guarded.

## Reference

- `bin/instrument-guard.ps1` guard-tool Bash branch (FIX-10)
- Parent docket verdict-final note V5c
- Related prior scar: `guard-security-fixes-2026-04-16.md` (original
  whitelist design intent)
