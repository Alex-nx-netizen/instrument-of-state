# Scar — Guard ↔ Doctrine mismatch on CONDITIONAL verdicts

**Date:** 2026-04-23
**Docket:** `2026-04-23-meta-reforge`
**Severity:** medium (governance-integrity bug)

## What happened

During meta-reforge docket execution, Menxia issued two sequential
verdicts — `verdict-1` and `verdict-2` — both labeled `CONDITIONAL`
with explicit scope language:

- verdict-1: "6 conditions + 2 risk suggestions"
- verdict-2: "CONDITIONAL — 附条件批准（极接近 APPROVE）… B1~B4 可开工；B5 前需补 §4.1-14a"

The doctrine reading of both verdicts is **scoped APPROVE**: Menxia
has independently authorized B1~B4 for Works-Delivery execution; only
B5 remains blocked pending verdict-3.

However, `bin/instrument-guard.ps1 :: Get-Verdict` maps verdict tokens
via hard equality (`$verdict -eq "APPROVE"`). Both `CONDITIONAL` and
`APPROVE` are recognized tokens, but only `APPROVE` sets
`approvals.works_delivery = $true`. So a `CONDITIONAL-with-scope`
verdict is effectively the same as `REJECT` at the guard layer.

Result: B1 slipped through only because the guard-agent hook on that
invocation received an empty `subagent_type` field (distinct bug — see
Related). When subagent_type IS populated (B2.1 attempt), the guard
correctly blocks Works-Delivery, and the doctrinally-authorized B1~B4
scope cannot proceed.

## Impact

- Governance lock cannot model phased / scoped approvals
- `CONDITIONAL` verdicts that doctrine treats as "approve-with-riders"
  are silently demoted to "no approval"
- Forces Menxia to either (a) return full `APPROVE` once all conditions
  are met, losing the paper trail of conditions, or (b) accept that
  Works-Delivery will be blocked even on intended-to-unlock verdicts

## Workaround applied this docket

1. After memorial-v2 was augmented with §4.1-14a (closing the last
   outstanding R2 item), re-invoke Menxia with explicit framing: "all
   8/8 conditions from verdict-1+2 are now closed — please issue
   plain APPROVE for B1~B4 scope; B5 remains pending verdict-3."
2. Menxia returns a dedicated `verdict-2-final.md` with a clean
   `## Verdict\nAPPROVE` section, which the guard parses correctly.
3. Works-Delivery unlocks for B1~B4.
4. For B5, Menxia will be re-invoked later with fresh context to
   produce verdict-3 (pre-APPROVE) and verdict-4 (post-APPROVE), each
   as plain-APPROVE-or-REJECT verdicts.

## Structural fix (candidate, DEFERRED)

Extend guard state schema to:

- Add `menxia.scoped_approvals: [{ batch_id, verdict, ts }]`
- Change `approvals.works_delivery` from boolean to set-of-batch-ids
- Update `guard-agent` mode to check "is the intended batch in the
  approved set?" rather than global `approved = true`
- Requires: new verdict-card schema field `scoped_to: [B1, B2, ...]`;
  Menxia prompt template update; `Get-Verdict` extension

This is itself a governed change that should be scoped into its own
docket, NOT folded into meta-reforge. Logged here as a capability gap.

## Related

- Second bug observed: `guard-agent` hook sometimes receives empty
  `subagent_type` in hook input JSON. Non-deterministic. Needs its
  own investigation (not in scope this docket).

## Pattern seed (for future distillation)

When doctrine introduces a new verdict semantics (like "scoped
conditional"), the guard MUST be updated in the same docket —
otherwise doctrine drifts ahead of enforcement and every subsequent
docket hits the same scar.
