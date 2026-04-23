# 🏛️ Memorial — Meta Reforge (v0.6.0)

> 本文件由 Zhongshu（草案人）起草，待 Menxia（审议）裁决后进入 Works Delivery。
> **此 memorial 的作用**：锁定意图、圈定范围、明示调度与验收、交出可审查的批次计划。

**Docket:** `2026-04-23-meta-reforge`
**Drafter:** Zhongshu
**Classification:** 实质、跨部、公开可发布、破坏性变更（major doctrine reforge）

---

## 1. Petition Restatement（请愿复述）

用户请求把飞书文档《元：从混沌许愿到系统治理》（作者：老金）的核心思想融入本插件，并**解决目前的"冗杂"问题**——冗杂被用户重新定义为：

> "使用起来不明确，不知道在干什么，不知道使用了哪些东西。执行起来没有我想要的用了什么东西，比如 skills 用了哪些等等。然后也没有用到主流的思想。"

即**可见性缺失 + 主线思想未显性化**，而不是单纯文件数量多。

---

## 2. Intent Packet（意图包）

### 2.1 主意图

把插件的**内核**从"三省六部隐喻驱动"切换为"**元 / 组织镜像 / 节奏编排 / 意图放大 + 发牌**驱动"；三省六部作为**外显隐喻保留**，不再是内核。

### 2.2 次要意图（同等优先）

a. **可见性强化**：让用户在任意时刻能回答三个问题——"我现在在哪个阶段？""用过了哪些 agent/skill？""下一步要做什么？"
b. **结构收敛**：references 20 → 14（含 3 份新 doctrine）；agents 9 → 8；`publish-to-lark` 从 agent 降为 skill。
c. **节奏补齐**：契约层显式写出"跳过（skip）/插队（preempt）"规则，补上当前 2/10 与 3/10 的评分缺口。
d. **意图放大落盘**：`intentPacket` 从"任意 JSON"升级为**五字段强制结构**（owner/when/touchpoint/success/adjust-path）。

### 2.3 歧义披露（用户后续有否决权）

| 歧义点 | 默认解释 | 若用户不同意则需回复 |
|---|---|---|
| 古风命名是否保留 | 保留，但降为"学习侧"；主入口切语义命名 `/iostate:*` | 回复"全部保留旧名" 或 "全部换新名" |
| `stage-board` 和 `tool-trace` 是独立 skill 还是合成一个 `iostate:status` | 独立两个（职责分离，符合元的"足够小"原则） | 回复"合成一个" |
| `resource-allocator` 是否进一步拆为 `personnel` + `budget` 子 skill | 不拆，一个 skill 内部提供两种 mode | 回复"保留原两个 skill" |
| `publish-to-lark` 是彻底删除还是保留 skill 并去掉 agent 身份 | 保留 skill，去掉 agent 身份（不再作为权力中心） | 回复"彻底删除" |
| 版本号跳到 0.6.0 还是 1.0.0 | `0.6.0`（仍在孵化期，非公开稳定承诺） | 回复"直接 1.0.0" |

---

## 3. Intent Gate Packet（意图闸门）

### 3.1 能进入 Works Delivery 的前置条件

- [ ] 本 memorial 被用户审阅（至少一次回复确认或指出异议）
- [ ] 本 memorial 被 Menxia 出具 `APPROVE` / `CONDITIONAL` 裁决
- [ ] `task_plan.md` / `findings.md` / `progress.md` 已落地（已完成 ✅）

### 3.2 意图锁字段（五字段）

| 字段 | 内容 |
|---|---|
| **owner（谁做）** | Coordinator（本会话）统筹；Works-Delivery 执行；Menxia 审查；Justice 验收 |
| **when（何时）** | 本会话内分 6 批完成；每批 1 commit；批间暂停让用户确认 |
| **touchpoint（触点）** | 每批结束时：一条"本批做了什么 / 动了哪些文件 / 验收状态"的短摘要 |
| **success（成功指标）** | §5 的 V1~V8 八条全部过；README 30 秒内能回答"是什么/有什么/什么时候用" |
| **adjust-path（调优路径）** | 若某批 Menxia 退回 → 回到本 memorial §7 对应 batch 修订；若用户撤回意图 → 走 writeback 记下 scar 后关闭 docket |

---

## 4. Scope Lock

### 4.1 In-scope（14 项）

**A. 新 doctrine（3 份）**
1. `references/meta-unit-doctrine.md` — 元的五特征 + 四判断；如何把 agent/skill 当作"元"审查
2. `references/cadence-doctrine.md` — 节奏四态（发牌 / 留白 / 跳过 / 插队），含每态的触发条件与示例
3. `references/deal-card-doctrine.md` — 发牌的三判断（减少不确定性 / 提高清晰度 / 不过度打断），含反例

**B. References 合并（删 9 建 3 = 净减 6）**
4. 合成 `references/ux-response-doctrine.md`（合并 ux-response-guidelines + first-use-and-controls + task-type-templates）
5. 合成 `references/lark-publication-doctrine.md`（合并 lark-publication-protocol + runbook + templates）
6. `constitutional-rules.md` 吸收 `imperial-workflow.md` 的原则部分
7. 删除 `superpowers-integration.md`（映射表内嵌到各 agent.md 的"超能力绑定"小节）

**C. Agent/Skill 精简（改名 + 合并 + 降级）**
8. 合并 `agents/personnel-routing-agent.md` + `agents/revenue-budgeting-agent.md` → `agents/resource-allocator-agent.md`；同步 skills
9. `publish-to-lark` 从 agent 降级：删 `agents/publish-to-lark-agent.md` 不存在（本来就没有），确保 `skills/publish-to-lark/` 保留但在 `plugin.json` 不再作为独立权力描述
10. 新增语义命名入口（与旧古风命名并存，旧命名内部重定向）：
    - `/iostate:draft` ← zhongshu-draft
    - `/iostate:review` ← menxia-review
    - `/iostate:dispatch` ← shangshu-dispatch
    - `/iostate:deliver` ← works-delivery
    - `/iostate:verify` ← justice-compliance
    - `/iostate:publish` ← publish-to-lark
    - `/iostate:allocate` ← resource-allocator（新）
    - `/iostate:emergency` ← war-operations

**D. 可见性三件套**
11. 新 skill `skills/stage-board/SKILL.md` + 实现 → 输出当前 stage / gate 状态 / 已用 agent/skill / 剩余未解锁
12. 新 skill `skills/tool-trace/SKILL.md` + 实现 → 回放本 docket 内所有 agent/skill/tool 调用
13. `hooks/hooks.json` 增强 SessionStart + SubagentStart：向用户输出一行人话（"现在调用 X，因为 Y"）；SessionStart 末尾附"本会话可用工具箱清单"

**E. 契约升级**
14. `contracts/workflow-contract.json` 增补：
    - 顶级 `skipPolicy`：规定哪些阶段可被跳过、跳过需要的证据
    - 顶级 `preemptPolicy`：规定 war-operations 的插队条件（P0/P1 定义、先插队后补手续）
    - `intentPacket` schema 升级为五字段强制（owner/when/touchpoint/success/adjust-path）

**F. Plugin 元信息与 README**
15. `plugin.json` 与 `marketplace.json` 版本统一 `0.6.0`；description 更新
16. README.md / README.zh-CN.md 双语重写：顶部 30 秒速览 + 工具箱清单表

### 4.2 Out-of-scope

- 不改 `bin/instrument-guard.ps1` 的核心状态机（只消费新契约字段）
- 不改 HMAC 格式（向后兼容）
- 不搭自动化测试框架
- 不删除 `memory/` 及模板
- 不改现有 `artifacts/runs/` 已有记录

---

## 5. Verification Spec（Justice-Compliance 验收项）

| ID | 条件 | 量化指标 | 验收方式 |
|---|---|---|---|
| V1 | References 收敛 | 最终 ≤14 份，含 3 份新 doctrine | `ls references/` 计数 |
| V2 | 主线思想显性 | meta/cadence/deal-card 三份新文件齐备；每份含对应"五特征 / 四态 / 三判断"小节 | grep 小节标题 |
| V3 | Agent 清单收敛 | `ls agents/` 为 8；`publish-to-lark-agent.md` 不存在 | `ls` 计数 |
| V4 | 可见性达标 | 在任何 session 启动时 SessionStart 输出末尾含"本会话可用工具箱"；`skills/stage-board` 与 `skills/tool-trace` 目录存在且 SKILL.md 非空 | 手动跑一次 `/iostate:dispatch` + `/iostate:status` 观察 |
| V5 | 契约节奏补齐 | `workflow-contract.json` 顶级含 `skipPolicy` 与 `preemptPolicy`；JSON 语法有效 | `jq . workflow-contract.json` |
| V6 | 版本一致 | plugin.json 与 marketplace.json 都是 `0.6.0` | grep |
| V7 | 治理不破 | Menxia 无 memorial 仍拒绝；Works 无 APPROVE 仍拒绝；Lark 无 public-ready 仍拒绝；hooks.json 语法有效 | 手动回归 3 条拦截路径 |
| V8 | 文档可读 | README 顶部 30 秒内能回答"是什么/有什么工具/什么时候用" | 人读 + 计时 |

---

## 6. Ministries Dispatch 计划

| Ministry | 角色 | 本次任务 | 估算工作量 |
|---|---|---|---|
| Zhongshu | 草案 | 已完成本 memorial + 起草所有新 doctrine 初稿 | 中 |
| Menxia | 审议 | 审本 memorial；必要时审每批变更清单 | 小 |
| Justice-Compliance | 验收 | V1~V8 逐项检查 | 中 |
| Works-Delivery | 执行 | §7 的 B1~B6 批次落地 | 大 |
| Rites-Protocol | 形式 | README 发布语气、版本说明样式 | 小 |
| Resource-Allocator（合并新生） | 分配 | 本次自身即改造对象，改造完成后立即生效 | 小 |
| War-Operations | 应急 | 仅在 guard 被破坏时启用 | ⏸ |

---

## 7. Batch Plan（6 批次）

**原则**：每批 1 commit（前缀 `reforge(Bn):`），批后暂停向用户交出短摘要，用户 `go` / `halt` / `revise` 三选一后进下一批。

### B1 — 主线 doctrine 上线（低风险，纯新增）
- 新建 `references/meta-unit-doctrine.md`
- 新建 `references/cadence-doctrine.md`
- 新建 `references/deal-card-doctrine.md`
- progress.md 记录
- **验收点**：三份文件可读、主线完整、示例不少于 2 条/份

### B2 — References 合并（中风险，改动大）
- 建合成文件 `ux-response-doctrine.md` / `lark-publication-doctrine.md`
- 删除 3+3+1 份被合并/过时文件
- `constitutional-rules.md` 吸收 imperial-workflow 原则
- 每个被合并 agent.md 的"超能力绑定"小节内嵌原 superpowers-integration 映射
- **验收点**：`ls references/` 得到 14；旧内容要点未丢失

### B3 — Agent/Skill 改名与合并（中高风险，入口变动）
- 新建 `agents/resource-allocator-agent.md`、`skills/resource-allocator/SKILL.md`
- 删除原 personnel-routing 与 revenue-budgeting 的 agent+skill
- `publish-to-lark` 在 plugin.json 中调整描述（保留 skill，不作为权力中心）
- 新语义命名 skill 目录建立：`skills/iostate-{draft,review,dispatch,deliver,verify,publish,allocate,emergency}/` 作为薄别名壳（内部调原 skill）
- **验收点**：`ls agents/` = 8；新旧命名皆可调用

### B4 — 可见性三件套（中风险，hook 改动）
- 新 `skills/stage-board/SKILL.md` + 实现
- 新 `skills/tool-trace/SKILL.md` + 实现
- 升级 `hooks/hooks.json` 的 SessionStart（末尾附工具箱清单）与 SubagentStart（输出"现在调用 X，因为 Y"一行人话）
- **验收点**：手动启动一次对话能看到工具箱清单；调用 draft 时能看到触发行

### B5 — 契约升级（中高风险，动权威）
- `workflow-contract.json` 添加 `skipPolicy`（跳过政策）和 `preemptPolicy`（插队政策）顶级节点
- `intentPacket` schema 升级为五字段强制
- `run-artifact.template.json` 同步更新
- **验收点**：JSON 仍有效；guard 能读取不报错（跑一次 `powershell bin/instrument-guard.ps1 health`）

### B6 — 元信息与 README（低风险，收尾）
- `plugin.json` / `marketplace.json` 统一 `0.6.0`
- README.md 与 README.zh-CN.md 重写：顶部 30 秒速览 + 工具箱清单表 + 新主线解说
- **验收点**：V6 + V8

---

## 8. Rollback Posture

- 每批独立 commit。失败则 `git revert <batch-sha>`，不用 `reset --hard`。
- 契约层变更（B5）额外加一张 scar 模板至 `memory/`，即便成功也留痕。
- 若 3 批以上失败 → 暂停整个 docket，升级用户决定。

---

## 9. Public-Ready Criteria

完成后才可对外宣告 / 发布到 Lark：
- V1~V8 全过
- `git log --oneline | head -10` 显示完整 6 个 `reforge(Bn):` commit
- 至少一次完整回归：`/iostate:dispatch` 全流程走通且 stage-board 输出正确
- Menxia 对最终汇总出具二次 APPROVE

---

## 10. Writeback Intent

本次改造完成后，向 `memory/` 写入：
- **pattern**: "doctrine reforge 的最小改动路径"
- **scar（若发生）**: 任何 revert 的批次
- **capability-gap**: 是否暴露了新的未覆盖场景（比如 dashboard 还不够）

---

## 11. Menxia 审议提示

请 Menxia 按 `menxia-verdict-card.md` 模板出 4 选 1：
- **APPROVE** — 全部通过，进入 Works Delivery B1
- **CONDITIONAL** — 附条件通过，条件列表
- **REMAND** — 退回修订，修订点列表
- **REJECT** — 驳回，理由

审议重点（建议）：
1. §2.3 歧义披露的默认解释是否可接受？
2. §4.1 第 10 项的"新旧命名并存"会不会长期留债？建议何时彻底切换？
3. §7 B3 和 B5 是中高风险批次，是否需要额外拆细？
4. §4.2 out-of-scope 中是否遗漏了应该本次做的项？
