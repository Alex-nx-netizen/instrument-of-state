---
name: iostate-publish
description: Semantic alias for legacy /instrument-of-state:publish-to-lark. Prefer this name. Publishes a governed result to Feishu/Lark only after explicit public-ready proof.
argument-hint: [publication context]
---

# /iostate:publish

Semantic alias for legacy `/instrument-of-state:publish-to-lark` — prefer this new name.

## 废弃声明 / Deprecation notice

⚠ Legacy names (`/instrument-of-state:publish-to-lark`) are still accepted in v0.6.0 but are deprecated.
They will be removed in v0.7.0.
Please use `/iostate:publish` going forward.

## 保留期限 / Retention window

Removal: ≤ v0.7.0 (per memorial-v2 §7 B3 条件 3).

## 最终验收 / Final verification statement

At removal time, `grep -r "publish-to-lark" --include='*.md'` should only match changelog and learning-side docs.

## 委派 / Delegation

Treat this entry as an alias shell. The actual implementation pointer is the legacy skill `publish-to-lark` (at `skills/publish-to-lark/SKILL.md`). Invoke that skill's execution contract with the same `$ARGUMENTS`. Do not duplicate logic here.

Note: `publish-to-lark` is a Rites-owned executing skill, not an independent power center. This alias inherits that framing.

## Input

$ARGUMENTS
