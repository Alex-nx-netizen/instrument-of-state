---
name: iostate-draft
description: Semantic alias for legacy /instrument-of-state:zhongshu-draft. Prefer this name. Drafts a memorial under the Three Departments governance.
argument-hint: [task or objective]
---

# /iostate:draft

Semantic alias for legacy `/instrument-of-state:zhongshu-draft` — prefer this new name.

## 废弃声明 / Deprecation notice

⚠ Legacy names (`/instrument-of-state:zhongshu-draft`) are still accepted in v0.6.0 but are deprecated.
They will be removed in v0.7.0.
Please use `/iostate:draft` going forward.

## 保留期限 / Retention window

Removal: ≤ v0.7.0 (per memorial-v2 §7 B3 条件 3).

## 最终验收 / Final verification statement

At removal time, `grep -r "zhongshu-draft" --include='*.md'` should only match changelog and learning-side docs.

## 委派 / Delegation

Treat this entry as an alias shell. The actual implementation pointer is the legacy skill `zhongshu-draft` (at `skills/zhongshu-draft/SKILL.md`). Invoke that skill's execution contract with the same `$ARGUMENTS`. Do not duplicate logic here.

## 批次算术校验 / Batch accounting check

When writing V-check accounting in a memorial (e.g. "V1: references/*.md count, target 14"),
use `bin/memorial-math.ps1` to validate the arithmetic before committing.

Example:

```
powershell -NoProfile -File bin/memorial-math.ps1 -Start 20 -Deltas 3,-2,-2,-2
# Output: Expected end: 17
```

Rationale: the v0.6.0 memorial-v2 stated V1 target as 14 while actual batch math
produced 17. The drift was not caught during drafting because there was no
auto-validation step. Always run this helper when the memorial contains
`reference count delta` language in its V-checks.

## Input

$ARGUMENTS
