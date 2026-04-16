# /status — Governance Status

Reads the current session's governance state and prints a summary table.

## Usage

```
/status
```

## What It Shows

| Field | Meaning |
|-------|---------|
| `stage_state` | Current stage: PETITION / DRAFT / REVIEW / DELIVERY / VERIFICATION / SUMMARY / PUBLICATION |
| `gate_state` | Gate: INTENT_OPEN / REVIEW_OPEN / WORKS_UNLOCKED / WORKS_LOCKED |
| `menxia_verdict` | NONE / APPROVE / CONDITIONAL / RETURN / REJECT |
| `works_delivery_approved` | Whether Works Delivery is unlocked |
| `intent_locked` | Intent packet submitted |
| `memorial_ready` | Memorial complete |
| `review_ready` | Menxia approved |
| `verification_ready` | Verification section detected in delivery output |
| `summary_closed` | Summary section detected in delivery output |
| `public_ready` | Run artifact cleared for publication |

## Implementation

Run the `health` mode of instrument-guard to get the current state, then format it for the user.

```bash
powershell -NoLogo -NoProfile -NonInteractive -ExecutionPolicy Bypass \
  -File "${CLAUDE_PLUGIN_ROOT}/bin/instrument-guard.ps1" health
```

The output is a JSON object. Parse and display as a table.

## Instructions

When the user runs `/status`:

1. Run the health check command shown above (adapt path to actual plugin root).
2. Parse the JSON from `hookSpecificOutput.additionalContext`.
3. Print a formatted table like:

```
Stage:      PETITION
Gate:       INTENT_OPEN
Menxia:     NONE
Delivery:   locked

Gates:
  intent_locked        false
  memorial_ready       false
  review_ready         false
  verification_ready   false
  summary_closed       false
  public_ready         false
```

4. If `stage_state` is PETITION, add: "Governance is inactive. Submit a petition to begin governed work."
5. If `works_delivery_approved` is true, add: "Works Delivery is UNLOCKED."
