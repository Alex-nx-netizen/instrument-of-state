# 🛠️ Memorial — Guard Hotfix

**Docket:** `2026-04-23-guard-hotfix`
**Path:** Emergency (War-Operations discretion). Post-hoc Menxia review once guard state machine is functional.
**Petitioner:** Coordinator (on behalf of 黄聪)
**Parent docket:** `2026-04-23-meta-reforge` (blocked at B2.1 pending this fix)
**Classification:** Infrastructure hotfix. Out-of-scope of parent docket but blocking it.

---

## 1. Petition

Parent docket `2026-04-23-meta-reforge` B1 committed successfully but B2.1 through B6 cannot proceed because the governance guard's state machine has two deterministic bugs that prevent Menxia approval from unlocking Works-Delivery.

This hotfix docket fixes both bugs so the parent docket can resume with proper governance.

---

## 2. Intent Packet

### 2.1 Primary intent

Fix two guard bugs — minimally — so that: Zhongshu drafting → Menxia APPROVE → Works-Delivery execution is a reliable chain, verifiable by a round-trip test.

### 2.2 Bugs to fix

**Bug 1 — PostToolUse:Agent tool_response never captured.**
- Evidence: every `record-menxia` / `record-zhongshu` log line shows the parsed verdict/drafted flags as `NONE`/`False`. Multiple log entries across 8 days and 3 sessions confirm this is deterministic, not a session fluke.
- Hypothesis: `Get-ObjectProperty $inputData "tool_response"` returns empty because Claude Code's PostToolUse:Agent hook input uses a different field name. Need to inspect actual hook input schema.

**Bug 2 — HMAC roundtrip always fails.**
- Evidence: every `load-state` log line shows `HMAC mismatch — resetting to default state`.
- Hypothesis: `Load-State` reconstructs the pre-_sig body via regex from the raw file, but the reconstruction bytes don't equal the bytes HMAC was computed on during Save-State. Possible causes: BOM, line endings, regex boundary issues.

### 2.3 Scope lock

IN:
- `bin/instrument-guard.ps1` — targeted fixes to both bug sites
- Test harness — a `-Mode test-hmac` or inline smoke test to prove the fix

OUT:
- No re-architecture of the state machine
- No change to verdict-token semantics (CONDITIONAL still means CONDITIONAL; that gap remains logged as scar `memory/scars/guard-conditional-verdict-mismatch-2026-04-23.md` and handled separately)
- No change to the hook registrations (`hooks/hooks.json`)
- No change to HMAC secret or algorithm
- No new state file schema version

### 2.4 Default assumptions (disclosed)

- I assume the hook input field for the Agent tool's output is named one of: `tool_response`, `tool_use_result`, `agent_response`, `output`, `result`, or possibly a nested object. I will inspect the actual hook input via a diagnostic probe before deciding the fix.
- I assume the HMAC body reconstruction regex bug is fixable by canonicalizing the HMAC target to the `ConvertFrom-Json → re-serialize without _sig` result, not the string-replaced raw.

---

## 3. Intent Gate Packet

Preconditions to unlock execution:
- [x] Bug evidence gathered from hook-debug.log
- [x] Parent docket (meta-reforge) has explicit user agreement to pause for hotfix
- [x] Guard is currently in PETITION state (governance inactive for Bash/Write from main conversation), making bootstrap fix possible

---

## 4. Recommended Mode

**War-Operations discretion.** Direct fix from main conversation. Post-fix verification by running zhongshu → menxia → works-delivery on a dummy petition. No sub-agents required for the fix itself because the guard blocks them from doing what we need.

---

## 5. Deliverables

1. Two precise code fixes in `bin/instrument-guard.ps1`, minimal diffs
2. A verification run log (zhongshu → menxia → works chain successfully traverses state machine)
3. Commit message: `fix(guard): tool_response capture + HMAC roundtrip`
4. Scar entry (update existing or add new) logging the root cause

---

## 6. Verification Plan (for Justice / post-hoc Menxia)

| # | Check | Command | Expected |
|---|---|---|---|
| V1 | HMAC roundtrip works | Save a crafted state, reload it, confirm stage_state persists | no `HMAC mismatch` in log during reload |
| V2 | Bug-1 fixed: zhongshu output captured | Invoke a zhongshu-agent with content containing `## Intent Packet` etc. | `record-zhongshu` log shows `drafted=True intent_packet=True intent_gate=True` |
| V3 | Bug-1 fixed: menxia verdict captured | Invoke menxia-agent that outputs `## Verdict\nAPPROVE` | `record-menxia` log shows `verdict=APPROVE` |
| V4 | Chain unlocks works-delivery | After V2+V3, invoking works-delivery-agent does NOT hit the guard-agent deny | PreToolUse:Agent allows the call |

---

## 7. Rollback

Single commit, easy to `git revert`. If revert happens, parent docket is stuck where it is now — no regression.
