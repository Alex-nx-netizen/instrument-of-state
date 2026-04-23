---
name: iostate-allocate
description: Semantic alias for the new resource-allocator skill. Prefer this name. Covers both personnel mode (ownership/reviewers/partitioning) and budgeting mode (cost/time/dependencies/priority).
argument-hint: [task or objective]
---

# /iostate:allocate

Semantic alias for legacy `/instrument-of-state:personnel-routing` and `/instrument-of-state:revenue-budgeting` (both absorbed into `resource-allocator` during B3) — prefer this new name.

## 废弃声明 / Deprecation notice

⚠ Legacy names (`/instrument-of-state:personnel-routing` and `/instrument-of-state:revenue-budgeting`) are still accepted in v0.6.0 but are deprecated.
They will be removed in v0.7.0.
Please use `/iostate:allocate` going forward.

## 保留期限 / Retention window

Removal: ≤ v0.7.0 (per memorial-v2 §7 B3 条件 3).

## 最终验收 / Final verification statement

At removal time, `grep -rE "personnel-routing|revenue-budgeting" --include='*.md'` should only match changelog and learning-side docs.

## 委派 / Delegation

Treat this entry as an alias shell. The actual implementation pointer is the `resource-allocator` skill (at `skills/resource-allocator/SKILL.md`). Invoke that skill's execution contract with the same `$ARGUMENTS`. Do not duplicate logic here.

This alias fronts a unified two-mode office: personnel mode and budgeting mode. A single invocation may exercise either or both.

## Input

$ARGUMENTS
