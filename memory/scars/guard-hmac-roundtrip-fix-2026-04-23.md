# Scar — Guard HMAC roundtrip broken by raw-file body reconstruction

**Date:** 2026-04-23
**Docket:** `2026-04-23-guard-hotfix`
**Severity:** high (governance-state durability bug)

## What happened

Every `Load-State` call reset guard state to the default `PETITION`
stage, even immediately after a successful `Save-State`. As a result,
Menxia approvals and Zhongshu memorial drafts never persisted between
hook invocations, and Works-Delivery was perpetually blocked regardless
of upstream verdicts.

## Root cause

`Save-State` and `Load-State` computed HMAC against **different byte
sequences** for the same logical state:

- **Save path:** took the in-memory PSCustomObject with `_sig` removed,
  serialized via `ConvertTo-Json -Compress`, and HMAC'd that string.
- **Load path:** read the file as text, then used a regex to slice out
  the pre-`_sig` substring from the raw bytes and HMAC'd *that*.

The raw-file slice diverged from the save-time input due to at least
three drift sources:

1. `Set-Content -Encoding UTF8` prepended a UTF-8 BOM
2. PowerShell's file write introduced CRLF line endings
3. Regex boundary handling differed from `ConvertTo-Json -Compress`
   output around the final brace

Any one of these made every HMAC verification fail, and the guard
dutifully reset to default state on each load.

## Fix (FIX-8)

Introduced `Get-StateCanonicalBody($Object)` — the single source of
truth for the HMAC input on both sides:

- Clone the object via `ConvertTo-Json | ConvertFrom-Json` to strip
  PSCustomObject decorations and normalize numeric types
- Remove the `_sig` property if present
- Re-serialize via `ConvertTo-Json -Depth 20 -Compress`

Both `Save-State` and `Load-State` now HMAC against this canonical
form. The file on disk can carry any BOM, indentation, or line
ending — verification only depends on the parsed object shape.

## Test harness

`bin/test-guard-hmac.ps1` — 8 assertions, all passing:

- Persist-then-load preserves `stage_state`, `memorial.drafted`,
  `gates.memorial_ready`, `menxia.verdict`, `approvals.works_delivery`
- Subsequent update (DRAFT → REVIEW) also persists
- Tampered state file (body mutated post-save) is detected and reset
  to default
- Tampered verdict field is detected and reset to `NONE`

## Reference

- Commit: `6aa8b79`
- Project: `bin/instrument-guard.ps1` lines ~117-271
- Parent docket unblocked: `2026-04-23-meta-reforge` B2.1

## Pattern seed

When computing an integrity signature over a serialized document, the
verifier MUST derive its input from the **parsed object**, not from a
byte slice of the file — serializers are allowed to add BOMs, change
line endings, and reformat whitespace. Canonicalize through the parser
on both sides.
