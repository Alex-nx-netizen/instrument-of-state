---
name: stage-board
description: Report current governance stage, gate states, agents/skills used, and remaining unlocked gates for this docket.
context: fork
user-invocable: true
allowed-tools: Read Bash Grep Glob
---

# Stage Board

Governance state visibility report.

本 skill 用于任意时刻回答三个可见性问题：我在哪个阶段？已动用了哪些 agent / skill？下一步还要解锁哪些闸门？

## 如何读取治理状态

Step 1 — 读取本会话状态快照（二选一，优先第一条）

- 直接读 `.claude/instrument-of-state/state/<session_id>.json`（结构为 `meta / gates / memorial / menxia / approvals`）
- 或调用 `powershell bin/instrument-guard.ps1 health`，其 stdout 为 `hookSpecificOutput.additionalContext` 内含紧凑 JSON 摘要

Step 2 — 识别当前 docket：`ls -t artifacts/dockets/ | head -1`。若当前目录下已存在 `memorial.md` / `memorial-v2.md` / `progress.md`，以最新 docket 目录为准。

Step 3 — 枚举本会话已触发的 subagent：
`grep 'mode=annotate-start' .claude/instrument-of-state/logs/hook-debug.log | grep <session_id>`
按时间顺序提取 `agent=...` 字段，去重得到角色清单（zhongshu / menxia / works-delivery / 其他 ministries）。

Step 4 — 组装状态矩阵（Markdown 表）

| 维度 | 字段 | 本会话取值 | 下一步解锁动作 |
|---|---|---|---|
| stage | `meta.stage_state` | PETITION / DRAFT / REVIEW / DELIVERY / VERIFICATION / SUMMARY | 见 references/meta-governance-layer.md |
| gate | `meta.gate_state` | INTENT_OPEN / REVIEW_OPEN / WORKS_UNLOCKED / WORKS_LOCKED | —— |
| memorial | `memorial.drafted` | true / false | 未起草则请调用 /iostate:draft |
| menxia | `menxia.verdict` | NONE / APPROVE / CONDITIONAL / RETURN / REJECT | 未 APPROVE 则不可进入工部 |
| works | `approvals.works_delivery` | true / false | 由 menxia APPROVE 解锁 |
| verification | `gates.verification_ready` | true / false | 工部返回含 `## 验证` / `## Verification` 即可置位 |
| summary | `gates.summary_closed` | true / false | 工部返回含 `## 总结` / `## Summary` 即可置位 |
| public | `gates.public_ready` | true / false | 需 run artifact 的 publicationPacket 闭合 |

Step 5 — 明确列出剩余未解锁闸门及阻塞原因，例如：

- 「B5 仍锁 — 等待 verdict-3 独立 APPROVE」
- 「public-ready 未满足 — 最新 run artifact 尚未闭合 summaryPacket」

## 输出契约

以中文返回以下章节：

## 当前阶段
一行写出 stage / gate / authority 三态。

## 闸门矩阵
上表照抄，列出所有关键字段。

## 已动用 agent/skill
从 annotate-start 日志聚合，按首次出现时间排序。

## 未解锁闸门与阻塞
逐条列出 `gates.*` 为 false 的项，并注明解锁所需动作。

## 建议下一步
最多三条，对接 shangshu-agent 的调度建议。

## Meta-Unit Self-Check

### 五特征 / Five Traits

- **足够小 (small enough)**: 只做状态读取与排版，不写文件
- **足够正交 (orthogonal)**: 与 tool-trace 分工（静态快照 vs 时间轴）
- **足够可组合 (composable)**: 输出结构供 shangshu-dispatch / menxia-review 直接引用
- **足够可审计 (auditable)**: 数据源头全部为 JSON state 与 hook-debug.log
- **足够谦卑 (humble)**: 不作决策，仅报告

### 四判断 / Four Checks

- **目标判断 (goal check)**: 三问可见性是否达标？✅ 一份表覆盖 stage/gate/approvals/verification/summary/public
- **能力判断 (capability check)**: 依赖 Read/Bash/Grep，无外部能力缺口
- **边界判断 (boundary check)**: 不越界写文件；不触碰 state JSON；只读
- **证据判断 (evidence check)**: 每一条取值都指向具体文件或日志行
