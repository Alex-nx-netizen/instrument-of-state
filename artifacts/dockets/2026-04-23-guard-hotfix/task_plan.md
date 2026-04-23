# Task Plan — Guard Hotfix

**Docket:** `2026-04-23-guard-hotfix`
**Opened:** 2026-04-23
**Parent:** `2026-04-23-meta-reforge` (blocked)

## Scope

Two deterministic bugs in `bin/instrument-guard.ps1` blocking governance chain:

1. **Bug 1** — `tool_response` field not captured from PostToolUse:Agent hook input
2. **Bug 2** — HMAC roundtrip always fails on Load-State

## Progression

| # | Step | Status |
|---|---|---|
| 1 | Docket open + memorial + task_plan | ✅ |
| 2 | Probe hook input schema (write a diagnostic mode) | ⏸ |
| 3 | Diagnose Bug 1 precisely | ⏸ |
| 4 | Reproduce Bug 2 precisely | ⏸ |
| 5 | Write fix for Bug 1 | ⏸ |
| 6 | Write fix for Bug 2 | ⏸ |
| 7 | Verification round-trip | ⏸ |
| 8 | Commit | ⏸ |
| 9 | Resume meta-reforge B2.1 | ⏸ |

## Errors Encountered

| # | Step | Issue | Fix |
|---|---|---|---|
| — | — | — | — |

## Success Criteria

- Manual invoke zhongshu-agent → state records `memorial.drafted=true`
- Manual invoke menxia-agent returning APPROVE → state records `menxia.verdict=APPROVE, approvals.works_delivery=true`
- Works-Delivery-agent not blocked afterward
- All verified in hook-debug.log
