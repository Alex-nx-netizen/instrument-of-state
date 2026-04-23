---
name: iostate-review
description: Semantic alias for legacy /instrument-of-state:menxia-review. Prefer this name. Reviews a drafted memorial and issues an independent verdict.
argument-hint: [memorial content]
---

# /iostate:review

Semantic alias for legacy `/instrument-of-state:menxia-review` — prefer this new name.

## 废弃声明 / Deprecation notice

⚠ Legacy names (`/instrument-of-state:menxia-review`) are still accepted in v0.6.0 but are deprecated.
They will be removed in v0.7.0.
Please use `/iostate:review` going forward.

## 保留期限 / Retention window

Removal: ≤ v0.7.0 (per memorial-v2 §7 B3 条件 3).

## 最终验收 / Final verification statement

At removal time, `grep -r "menxia-review" --include='*.md'` should only match changelog and learning-side docs.

## 委派 / Delegation

Treat this entry as an alias shell. The actual implementation pointer is the legacy skill `menxia-review` (at `skills/menxia-review/SKILL.md`). Invoke that skill's execution contract with the same `$ARGUMENTS`. Do not duplicate logic here.

## Input

$ARGUMENTS
