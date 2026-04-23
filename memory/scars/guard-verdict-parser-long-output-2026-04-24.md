# Scar — Guard Get-Verdict NONE on long / narrative Menxia outputs

**Date:** 2026-04-24
**Docket:** `2026-04-24-v0.6.1-capability-gaps`
**Severity:** medium (governance-gate false negative)

## What happened

During the meta-reforge docket, several Menxia invocations returned a
properly-formed `## Verdict\n\nAPPROVE` card but `Get-Verdict` parsed
`NONE`. Menxia had to re-emit the card in a shorter minimal-English form
before the guard would register approval. Short English-only outputs
parsed reliably; long Chinese outputs with narrative preamble did not.

## Root cause

`Get-Verdict` used `[regex]::Match` (singular), which returns only the
FIRST hit of the `(?ms)^#{1,3}\s*(?:Verdict|裁决)\s*\r?\n+\s*([A-Z]+)\b`
pattern. When Menxia's output contained earlier text such as "the
verdict-final card below summarizes..." or a prompt-template echo,
the first header-to-keyword match could land on a non-authoritative
position where the first `[A-Z]+` token beneath a `## Verdict`-shaped
header was not one of the four valid verdict keywords. The function
then rejected the match (group value not in whitelist) and fell through
to the weaker fallbacks, which did not catch the authoritative card
either — returning NONE.

Short outputs did not hit this because they contained only one `##
Verdict` header, with the keyword directly beneath.

## Fix (FIX-9)

Switched from `[regex]::Match` to `[regex]::Matches` and take the LAST
match. Rationale: the authoritative verdict card is conventionally the
last one in Menxia's output; earlier mentions are narrative or
template-echo.

`bin/instrument-guard.ps1` Get-Verdict:

```
$allMatches = [regex]::Matches($Message, $sectionPattern)
if ($allMatches.Count -gt 0) {
  $last = $allMatches[$allMatches.Count - 1]
  $v = $last.Groups[1].Value.ToUpperInvariant()
  if ($v -in @("APPROVE","CONDITIONAL","RETURN","REJECT")) { return $v }
}
```

Fallbacks (bold-inline `**APPROVE**`, Chinese keyword under `## 裁决`)
are preserved.

## Pattern seed

When parsing a structured section from LLM output, prefer
LAST-of-many over FIRST-of-one. Narrative preamble and prompt-template
echo tend to occupy earlier positions; the authoritative statement is
usually at the tail.

## Reference

- `bin/instrument-guard.ps1` Get-Verdict (around lines 279-306)
- Parent docket: `2026-04-23-meta-reforge` (multiple re-emission cycles
  of verdict-1-menxia, verdict-2-menxia)
