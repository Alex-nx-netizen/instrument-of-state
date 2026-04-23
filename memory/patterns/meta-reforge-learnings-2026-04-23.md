# Meta-Reforge Learnings — 2026-04-23

**来源 docket**：`artifacts/dockets/2026-04-23-meta-reforge/`
**HEAD**：`116f283`（v0.6.0）
**类型**：docket 闭幕写回（patterns + capability gaps）

---

## Pattern：薄别名壳 + 五段式弃用说明（Thin-alias-shell with deprecation five-section）

- **场景**：B3 为六部 skill 引入 `iostate:*` 外部语汇别名（iostate-draft / iostate-review / iostate-dispatch / iostate-deliver / iostate-verify / iostate-publish / iostate-allocate / iostate-emergency）。
- **做法**：每个别名壳仅 5 段——Purpose / Deprecation / Retention / Final verification / Delegation；不重复正主的 SKILL 内容；只保留"我是谁、我委派给谁、什么时候被清理"。
- **为什么可行**：Claude Code 的 skill 路由按文件名匹配，薄壳让外部调用点渐进迁移而不冻结旧名；宪章层只认正主。
- **涉及部门**：Works-Delivery 写壳；Shangshu-Dispatch 在 tool 白名单中同时列壳与正主；Menxia 审薄壳不越权描述实现。
- **复用时机**：任何需要"重命名但不可立即迁走外部调用者"的 skill/agent 改造。

---

## Pattern：一部两模式（Two-modes-in-one-office for agent merge）

- **场景**：B2.3+B3 把"吏部（Personnel Routing）"与"户部（Revenue Budgeting）"合并为"资源调度（Resource Allocation）"单一 agent。
- **做法**：constitutional-rules.md 的条目数六部不变，但 Resource Allocation 条目内明示"分工模式 / 预算模式"可同奏折共触发；agent.md 的交付要求分两组章节，按实际触发模式返回。
- **为什么可行**：合并后不丢失任何一种工作模式的表达力；六部总数稳定便于宪章审计；下游引用只认单一入口。
- **涉及部门**：Zhongshu 起草合并 memorial；Menxia 审六部总数不变；Works-Delivery 重写 agent.md；Justice 在 V1 统计计数。
- **复用时机**：两个职能重叠 agent/部门合并，但两种工作模式仍需独立表达时。

---

## Pattern：契约追加升级 + 双模板同步（Additive contract upgrade with double-template sync）

- **场景**：B5 把 intentPacket.fields 从 5 追加至 10（新增 owner/when/touchpoint/success/adjustPath），同时 intentPacketVersion 默认值 v1→v2。
- **做法**：原 5 项顺序 + 新 5 项顺序严格追加（不打乱旧顺序）；workflow-contract.json 与 run-artifact.template.json 同提交同步；Zhongshu 起草 skill 的意图包展示段也一并同步至 10 字段。
- **为什么可行**：旧运行产物 v1 仍可被解析（追加而非重组）；新产物自然落到 v2；Zhongshu 模板与契约模板双同步，避免后续 draft 漂移。
- **涉及部门**：Zhongshu（模板）；Works-Delivery（契约 + 备份基线 .backup-v0.5.0.json）；Menxia（验收追加性）；Justice（JSON 有效性 + 字段数 + 默认值三重验证）。
- **复用时机**：契约层 schema 需扩展字段但必须向后兼容时。

---

## Pattern：CONDITIONAL→APPROVE 追加子提交（CONDITIONAL→APPROVE re-emission for guard parser）

- **场景**：B3 commit `a77fad4` 被 Menxia 裁 CONDITIONAL（3 项缺口）；以 B3.1 追加子提交 `7243c2f` 精准补齐后转 APPROVE。
- **做法**：不撤回 a77fad4、不 amend、不 squash；B3.1 scope 严格限定在 verdict-3 点名的 3 文件（shangshu 工具白名单 + blueprint 模板 + deal-card 交叉引用字面量）；授权链在 B3.1 commit 注中明示 "Menxia verdict-3 CONDITIONAL→APPROVE (B3.1 scope only)"。
- **为什么可行**：不破坏 commit 阶梯 & 审计链；Menxia 的 CONDITIONAL 缺口可被下一 commit 精确关闭；守护程序只认 APPROVE 路径，追加子提交后自然转绿。
- **涉及部门**：Menxia（点名缺口）；Works-Delivery（scope-tight 追加）；Justice（对 a77fad4+7243c2f 合并态验收）。
- **复用时机**：裁决 CONDITIONAL 但主 commit 已落地、需在不撤回情况下闭合条件时。

---

## Capability gap：守护程序 verdict 解析器对长文+叙述前言失效

- **经验证据**：本 docket 多次 re-emission 中，最小英文 ≤500 字符输出可靠解析为 APPROVE/CONDITIONAL；中文或长文（含叙述前言再进 `## Verdict`）有时被解析为 NONE，尽管 `## Verdict` 结构正确。
- **影响**：Menxia 被迫压缩输出或改用英文裁决卡，降低裁决叙述丰富度；re-emission 消耗轮次。
- **候选修复**：将 parser 从"首匹配"改为"末匹配 `## Verdict` 之后首段"；或要求 parser 明示 verdict 段必须置于输出末尾。
- **归档路径**：建议写入 `memory/capability-gaps.md` 单独一条。

---

## Capability gap：守护程序架构性限制 Justice 跑实时 health

- **经验证据**：V5c 要求 Justice 跑 `bin/instrument-guard.ps1 health`；守护程序允许 `Bash` 但对 `powershell` 直调入口存在白名单限制；Justice 被降级为对"Works 已跑过的 health 证据"做静态复查。
- **性质**：架构特性而非缺陷——Justice 不应有执行态副作用，保持 reviewer 纯度。
- **启示**：未来 V5c 类验收应改为"Works 跑 → 产物落盘 → Justice 读"的接力模式；Memorial 在定义 V 级验收时应显式区分"执行验收"与"证据验收"。
- **归档路径**：建议写入 `memory/capability-gaps.md`。

---

## Capability gap：memorial 计数漂移无自动校验

- **经验证据**：memorial v1 声称 references/*.md 将达 14，实际 B6 完成时为 17（新增 5 doctrine + 原有留存 12）；差值来自 V1 验收标准声明与 B2/B3 合并批次净变化之间的口径不一致，无机制提前暴露。
- **候选修复**：Zhongshu 在起草 memorial 的 V1 类"计数验收"时，要求附"起算值 → 每批 delta → 终值"三列表；或由 skill 层在草拟时自动从当前目录 snapshot 回填起算值。
- **归档路径**：建议写入 `memory/capability-gaps.md`。

---

## 写回建议

- 本文件即 `writebackPacket.patterns` 条目；docket 闭幕时建议由 Rites 在下一次 Lark 发布时一并同步至公开公告的"内部模式复用"段（若 public-ready 授权到位）。
- 三条 capability gap 建议追加合并进 `memory/capability-gaps.md`，保留本文件作为出处 breadcrumb。
