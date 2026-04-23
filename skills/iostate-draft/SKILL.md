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

## Input

$ARGUMENTS
