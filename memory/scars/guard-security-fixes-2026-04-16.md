# Scar: Guard Security Vulnerabilities — 2026-04-16

## What happened

A security audit of `instrument-guard.ps1` v0.4.x identified eight vulnerabilities ranging from P0 to P2.

## Root causes

| # | Issue | Root cause |
|---|-------|-----------|
| 1 | Sidecar files in %TEMP% | Original implementation used global temp dir for cross-process sidecar handoff |
| 2 | Regex verdict misparse | Bare word search matched "APPROVE" anywhere in agent output |
| 3 | No state file locking | Load/save without mutex; concurrent hooks could corrupt state |
| 4 | Partial lark-cli gate | Only `im +messages-send` was checked; other outbound calls were ungated |
| 5 | Missing hook timeouts | SubagentStart/Stop and PreToolUse had no timeout |
| 6 | Blacklist bash detection | Missed interpreted scripts and custom tooling |
| 7 | No state file integrity | JSON files editable by hand; no tamper detection |
| 8 | Empty memory layer | Evolution writeback designed but never populated |

## What changed in v0.5.0

- Sidecar dir moved to `.claude/instrument-of-state/state/sidecars/` (project-local)
- Verdict parsing restricted to `## Verdict` section header block + bold marker fallback
- File locking added via `.lock` files with 5s timeout and stale-lock cleanup
- All `lark-cli` outbound calls (except read-only get/list) gated behind `public_ready`
- All hooks given `"timeout": 10`
- `Is-MutatingBash` flipped to whitelist strategy
- HMAC-SHA256 signature added to state JSON files
- `memory/capability-gaps.md` and `memory/dispatch-patterns.md` populated

## Lessons

- Guard enforcement is only as strong as its detection logic; regex on raw LLM output is fragile — prefer structural anchors (section headers).
- Temp directories are a shared attack surface; keep plugin state inside the project directory.
- LLM hooks can run concurrently; always treat state files as shared resources requiring locking.
