# Capability Gaps

Use this ledger when a governed run identifies missing capability that should remain visible after the run ends.

## Entry template

| Date | Gap | Where it surfaced | Current workaround | Next action |
| --- | --- | --- | --- | --- |

## Known gaps

| Date | Gap | Where it surfaced | Current workaround | Next action |
| --- | --- | --- | --- | --- |
| 2026-04-16 | No automated test execution in Justice Compliance | guard-tool / verification stage | Manual verification checklist in memorialPacket | Add `justice-compliance` skill that runs `npm test` / `mvn test` and writes verificationPacket |
| 2026-04-16 | Is-MutatingBash whitelist incomplete for interpreted scripts (python, node, dotnet) | guard-tool PreToolUse | Whitelist strategy introduced in v0.5.0 — unknown scripts now blocked by default | Expand whitelist with common read-only script invocations as they are discovered |
| 2026-04-16 | No multi-session coordination | state files are per-session only | Each session governs independently | Consider a shared project-level lock file for multi-agent long-running tasks |
| 2026-04-16 | Superpowers integration is context-injected but not enforced at gate level | session-context | Informational only | Add capability_state tracking for superpowers presence and surface in stage board |
