# 🏛️ Memorial v2 — Meta Reforge (v0.6.0)

> **订正说明**：本 v2 订正 v1 六条关键条件 + 两条风险建议，源于门下裁决 `verdict-1-menxia.md`。v1 文件保留不动，作为审议历史。
> **此 memorial 的作用**：锁定意图、圈定范围、明示调度与验收、交出可审查的批次计划。

**Docket:** `2026-04-23-meta-reforge`
**Drafter:** Zhongshu (revised)
**Based-on verdict:** `verdict-1-menxia.md` (CONDITIONAL, 6 conditions + 2 risks)
**Classification:** 实质、跨部、公开可发布、破坏性变更（major doctrine reforge）
**Supersedes:** `memorial.md` (v1)

---

## 0. 订正索引（供 Menxia 快速核对）

| Verdict-1 条目 | 订正落点 |
|---|---|
| 条件 1（`publish-to-lark` 事实订正） | §2.3 / §4.1-9 |
| 条件 2（宪法第 99–106 行同步） | §4.1-17（新增）/ §6 / §7 B2.3 |
| 条件 3（硬切换终点） | §7 B3 末段 / 新 §12 |
| 条件 4（契约双保护） | §7 B5 末段 / §8 |
| 条件 5（验收可证伪） | §5 全表重写 |
| 条件 6（歧义第 4 项订正） | §2.3 第 4 行 / §4.1-9 |
| 风险 1（B2 拆子 commit） | §7 B2 改为 B2.1/B2.2/B2.3 |
| 风险 2（B5 同批更新生成位） | §7 B5 / §5 V5b |

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
b. **结构收敛**：references 20 → 14（含 3 份新 doctrine）；agents 9 → 8（合并 `personnel-routing` + `revenue-budgeting` → `resource-allocator`）；宪法同步修订六部条目。
c. **节奏补齐**：契约层显式写出"跳过（skip）/ 插队（preempt）"规则，补上当前 2/10 与 3/10 的评分缺口。
d. **意图放大落盘**：`intentPacket` 新增**意图放大分组的五字段**（owner/when/touchpoint/success/adjustPath），以**叠加式**合并至当前契约既有的五个意图声明字段上（详见 §4.1-14a）。并同步升级 Zhongshu 草稿生成位。

### 2.3 歧义披露（含 Menxia 独立订正）

| # | 歧义点 | 订正后解释（含 Menxia verdict-1 条件 6） | 若用户不同意则回复 |
|---|---|---|---|
| 1 | 古风命名是否保留 | 保留，但降为"学习侧"；主入口切语义命名 `/iostate:*` | "全部保留旧名" / "全部换新名" |
| 2 | `stage-board` 和 `tool-trace` 是独立 skill 还是合成一个 `iostate:status` | 独立两个（职责分离，符合元的"足够小"原则） | "合成一个" |
| 3 | `resource-allocator` 是否进一步拆为 `personnel` + `budget` 子 skill | 不拆，一个 skill 内部提供两种 mode | "保留原两个 skill" |
| 4 | `publish-to-lark` 的处置 | **[订正 verdict-1 条件 6]** `publish-to-lark` 从来不是 agent，只是 skill；本次动作不是"降级"而是"在 `rites-protocol-agent.md` 与 `plugin.json` 的描述中不得被表述为独立权力中心，只能作为 rites 麾下执行工具"。skill 目录本身保留不动。 | "彻底删除 skill" |
| 5 | 版本号跳到 0.6.0 还是 1.0.0 | `0.6.0`（仍在孵化期，非公开稳定承诺） | "直接 1.0.0" |

---

## 3. Intent Gate Packet（意图闸门）

### 3.1 能进入 Works Delivery 的前置条件

- [x] 本 memorial 被用户审阅（v1 `go` + v2 `adopt all`）
- [ ] 本 memorial **v2** 被 Menxia 出具 `APPROVE`（二审）
- [x] `task_plan.md` / `findings.md` / `progress.md` 已落地

### 3.2 意图锁字段（五字段）

| 字段 | 内容 |
|---|---|
| **owner（谁做）** | Coordinator（本会话）统筹；Works-Delivery 执行；Menxia 审查；Justice 验收 |
| **when（何时）** | 本会话内分 6 批完成（B2 内部含 3 个 sub-commit）；批间暂停让用户确认 |
| **touchpoint（触点）** | 每批结束时：一条"本批做了什么 / 动了哪些文件 / 验收状态"的短摘要 |
| **success（成功指标）** | §5 的 V1~V8 + V5b 共 9 条全部过；README 按 V8 的具体计数指标过 |
| **adjust-path（调优路径）** | 若某批门下退回 → 回到本 memorial §7 对应 batch 修订；若用户撤回意图 → 走 writeback 记下 scar 后关闭 docket |

---

## 4. Scope Lock

### 4.1 In-scope（17 项，+1 为宪法同步）

**A. 新 doctrine（3 份）**
1. `references/meta-unit-doctrine.md` — 元的五特征 + 四判断；如何把 agent/skill 当作"元"审查
2. `references/cadence-doctrine.md` — 节奏四态（发牌 / 留白 / 跳过 / 插队），含每态的触发条件与示例
3. `references/deal-card-doctrine.md` — 发牌的三判断（减少不确定性 / 提高清晰度 / 不过度打断），含反例

**B. References 合并（删 9 建 3 = 净减 6）**
4. 合成 `references/ux-response-doctrine.md`（合并 ux-response-guidelines + first-use-and-controls + task-type-templates）
5. 合成 `references/lark-publication-doctrine.md`（合并 lark-publication-protocol + runbook + templates）
6. `constitutional-rules.md` 吸收 `imperial-workflow.md` 的原则部分
7. 删除 `superpowers-integration.md`（映射表内嵌到各 agent.md 的"超能力绑定"小节）

**C. Agent/Skill 精简（改名 + 合并）**
8. 合并 `agents/personnel-routing-agent.md` + `agents/revenue-budgeting-agent.md` → `agents/resource-allocator-agent.md`；同步 skills
9. **[订正 verdict-1 条件 1 & 6]** `publish-to-lark` 保持 skill 身份不变（其本就非 agent），但在 `rites-protocol-agent.md` 与 `.claude-plugin/plugin.json` 的描述中明确：它是 rites 麾下的执行工具，**不得被表述为独立权力中心**。skill 目录结构不动。
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

**E. 契约升级（含风险 2 修复）**
14. `contracts/workflow-contract.json` 增补：
    - 顶级 `skipPolicy`：规定哪些阶段可被跳过、跳过需要的证据
    - 顶级 `preemptPolicy`：规定 war-operations 的插队条件（P0/P1 定义、先插队后补手续）
    - `intentPacket` schema 新增意图放大分组的五字段（owner/when/touchpoint/success/adjustPath）——**叠加式**，见 14a
14a. **[订正 verdict-2 修改要求 1]** intentPacket 字段升级方向裁决：**叠加式扩展**。
    - 保留旧 5 字段不动：`trueUserIntent` / `successCriteria` / `nonGoals` / `defaultAssumptions` / `intentPacketVersion`
    - 新增 5 字段：`owner` / `when` / `touchpoint` / `success` / `adjustPath`
    - 升级后 `intentPacket.fields` 共 10 字段；`intentPacketVersion` 由 v1 升至 v2
    - **理由**：旧字段是"意图**声明**"粒度（what/why/constraints），新字段是"意图**放大**"粒度（who/when/how）；两组不同粒度，覆盖会丢失 scope lock 能力与歧义披露能力，叠加才符合飞书文档主线
    - **命名冲突处理**：`success`（新）与 `successCriteria`（旧）允许并存；语义区别为 `successCriteria` = 全局成功标准，`success` = 本触点/本 owner 的局部成功指标
15. **[订正风险 2]** B5 同批次**必须**同步升级以下 packet 生成位，确保契约升级不是空改：
    - `skills/zhongshu-draft/SKILL.md` 内 intentPacket 模板段落
    - `contracts/run-artifact.template.json` 内 intentPacket 占位
    - 任何 hook 注入上下文中提到 intentPacket 字段的位置（`bin/instrument-guard.ps1 session-context` 输出）

**F. Plugin 元信息与 README**
16. `plugin.json` 与 `marketplace.json` 版本统一 `0.6.0`；description 更新反映思想重塑
17. **[新增 verdict-1 条件 2]** 修订 `references/constitutional-rules.md`：
    - §"The six ministries" 第 99–106 行的六部条目中，将原独立列出的 "Personnel Routing" 与 "Revenue Budgeting" **合并为一条 "Resource Allocation"**；措辞与 `agents/resource-allocator-agent.md` 统一
    - 对应条文的英文表述同步
    - diff 作为 B2.3 sub-commit 的核心产出
18. README.md / README.zh-CN.md 双语重写：顶部 30 秒速览 + 工具箱清单表

### 4.2 Out-of-scope

- 不改 `bin/instrument-guard.ps1` 的核心状态机（只消费新契约字段 + 注入 SessionStart 增强行）
- 不改 HMAC 格式（向后兼容）
- 不搭自动化测试框架
- 不删除 `memory/` 及模板
- 不改现有 `artifacts/runs/` 已有记录
- 不触发 marketplace 安装（本次纯内部重塑）

---

## 5. Verification Spec（Justice-Compliance 验收项，全部可证伪）

**[订正 verdict-1 条件 5]** 所有指标给出可执行命令 + 期望输出/退出码，消除"手动观察"主观判定。

| ID | 条件 | 可证伪命令 / 方式 | 期望结果 |
|---|---|---|---|
| V1 | References 数量 | `ls references/*.md \| wc -l` | 等于 `14` |
| V2 | 三份主线 doctrine 含必需小节 | `grep -l "五特征\|Five Traits" references/meta-unit-doctrine.md` 等 3 条 | 3 条 grep 均命中且文件非空（>50 行） |
| V2a | 具体小节标题枚举（**[verdict-2 建议 4]** 用正则严格匹配，避免副标题或行内命中） | `meta-unit-doctrine.md`：`grep -E '^## (五特征\|Five Traits)$'` 命中 1 次 + `grep -E '^## (四判断\|Four Checks)$'` 命中 1 次；`cadence-doctrine.md`：`grep -E '^## (发牌\|Dealing)$'` / `^## (留白\|Restraint)$` / `^## (跳过\|Skip)$` / `^## (插队\|Preempt)$` 各命中 1 次（共 4 节）；`deal-card-doctrine.md`：`grep -E '^## (三判断\|Three Checks)$'` 命中 1 次 | 全部 grep 退出码 0 且命中次数 ≥1 |
| V3 | agents 数量 | `ls agents/*.md \| wc -l` | 等于 `8`，且 `ls agents/publish-to-lark-agent.md 2>&1` 返回 "No such file" |
| V4 | 可见性达标 | 执行命令清单（见 §5.1 V4 命令表）| 每条命令退出码 + 输出片段匹配 |
| V5 | 契约节奏字段 | `jq '.skipPolicy, .preemptPolicy' contracts/workflow-contract.json` | 两字段均非 null |
| **V5b** | **[风险 2 + verdict-2 建议 3]** 契约升级未空改（前后对比） | (a) 取一份 B5 commit 前的最后一份 intentPacket（从 `artifacts/runs/` 最新 non-B5 run 中拿）`jq 'keys'`；(b) B5 后手动跑一次 `/iostate:draft` 产出新 intentPacket，`jq 'keys'`；(c) diff 两个 keys 列表 | 新 keys 必须是旧 keys 的**超集**（叠加式），且新增 5 字段 `owner/when/touchpoint/success/adjustPath` 全部出现；旧字段 `trueUserIntent/successCriteria/nonGoals/defaultAssumptions` 仍保留 |
| **V5c** | **[verdict-2 修改要求 2]** guard 兼容性 | `powershell bin/instrument-guard.ps1 health` | 退出码 `0`；stdout 是有效 JSON（`jq . <output>` 不报 error）；无 `parse error` 关键字 |
| V6 | 版本一致 | `jq -r '.version' .claude-plugin/plugin.json` 与 `.claude-plugin/marketplace.json` | 两者均输出 `0.6.0` |
| V7 | 治理硬拦截仍有效 | §5.2 V7 三条回归命令 | 三条均按期望被 DENY |
| V8 | README 可读 | `head -40 README.md \| wc -w` 得 ≤300；`head -40` 内含有三个必备锚点字符串（见 §5.3 V8 锚点表） | 字数达标 + 三锚点 grep 命中 |

### 5.1 V4 命令表（可见性验收）

| 命令 | 期望 |
|---|---|
| `ls skills/stage-board/SKILL.md` | 存在且非空（≥30 行） |
| `ls skills/tool-trace/SKILL.md` | 存在且非空（≥30 行） |
| `powershell bin/instrument-guard.ps1 session-context` | 输出末尾包含字符串 `Available skills:` 或等价工具箱清单 |
| 模拟启动一次 `/iostate:draft`（真实触发 SubagentStart hook）| hook 输出中含"现在调用 X，因为 Y"人话格式（grep `现在调用\|Now invoking`）|

### 5.2 V7 三条回归命令（治理不破）

| 回归场景 | 命令（示意） | 期望 |
|---|---|---|
| 无 memorial 时调 menxia | 清空 state 目录后触发 menxia-agent | guard 返回非零 + 输出含 `memorial` 关键字 |
| 无 APPROVE 时 works 写文件 | 构造未 APPROVE 状态 + 触发 Write（非规划产物） | guard DENY Write |
| 无 public-ready 时调 lark IM send | 清空 latest run artifact 后触发 `lark-cli im +messages-send` | guard DENY Bash |

### 5.3 V8 README 三锚点

`head -40 README.md` 与 `head -40 README.zh-CN.md` 必须均含：

1. **"是什么"锚**：字符串 `governed execution` 或 `治理` 出现在前 10 行
2. **"有什么工具"锚**：一张工具箱表格（识别为 markdown 表格，含"skill"或"skills"列名）
3. **"什么时候用"锚**：字符串 `when to use` 或 `何时使用` 或等价的用例引导

---

## 6. Ministries Dispatch 计划

| Ministry | 角色 | 本次任务 | 估算工作量 |
|---|---|---|---|
| Zhongshu | 草案 | 本 memorial v2 + 所有新 doctrine 初稿 | 中 |
| Menxia | 审议 | 已出 verdict-1；待出 verdict-2（针对 v2）；并在 B3/B5/最终汇总做三次独立复审 | 中 |
| Justice-Compliance | 验收 | V1~V8 + V5b 逐项检查；**[verdict-1 额外]** 在 B2 后执行 `constitutional-rules.md` 第 99–106 行 diff 审 | 中 |
| Works-Delivery | 执行 | §7 的 B1~B6 批次落地（B2 拆 3 个 sub-commit） | 大 |
| Rites-Protocol | 形式 | README 发布语气、版本说明样式；并确认自身 `rites-protocol-agent.md` 对 `publish-to-lark` 的表述订正 | 小 |
| Resource-Allocator（合并新生） | 分配 | 本次自身即改造对象，改造完成后立即生效 | 小 |
| War-Operations | 应急 | 仅在 guard 被破坏时启用 | ⏸ |

---

## 7. Batch Plan（6 批次，B2 拆 3 sub）

**原则**：每批 1 commit（前缀 `reforge(Bn):`）；B2 拆 B2.1/B2.2/B2.3 三 sub-commit；批后暂停向用户交出短摘要，用户 `go` / `halt` / `revise` 三选一后进下一批。

### B1 — 主线 doctrine 上线（低风险，纯新增）
- 新建 `references/meta-unit-doctrine.md`
- 新建 `references/cadence-doctrine.md`
- 新建 `references/deal-card-doctrine.md`
- progress.md 记录
- **验收点**：V2、V2a 过；三份文件可读、主线完整、示例不少于 2 条/份
- **复审级别**：轻复审（Justice 报告凭签）

### B2 — References 合并 + 宪章同步（中风险，改动大，**拆 3 sub-commit**）
**[订正风险 1]** 原单 commit 拆为：

- **B2.1** — UX 三合一
  - 建 `ux-response-doctrine.md`
  - 删 `ux-response-guidelines.md` / `first-use-and-controls.md` / `task-type-templates.md`
  - commit: `reforge(B2.1): merge UX doctrines`
- **B2.2** — Lark 发布三合一
  - 建 `lark-publication-doctrine.md`
  - 删 `lark-publication-protocol.md` / `lark-publication-runbook.md` / `lark-publication-templates.md`
  - commit: `reforge(B2.2): merge lark publication doctrines`
- **B2.3** — 宪章同步 + 清理
  - `constitutional-rules.md` 吸收 `imperial-workflow.md` 原则；**[verdict-1 条件 2]** 同时改第 99–106 行，六部从 Personnel+Revenue 独立合并为 Resource Allocation 一条
  - 删 `imperial-workflow.md`、`superpowers-integration.md`（映射表内嵌到各 agent.md）
  - commit: `reforge(B2.3): constitutional ministries merge + superpowers inline`
- **验收点**：V1 过（数量达 14）；Justice 额外跑宪章 diff 审；三 sub 任一失败可精确 `git revert` 该 sub
- **复审级别**：轻复审 + Justice 宪章 diff 必审

### B3 — Agent/Skill 改名与合并（中高风险，入口变动，**门下独立复审**）
- 新建 `agents/resource-allocator-agent.md`、`skills/resource-allocator/SKILL.md`
- 删除原 personnel-routing 与 revenue-budgeting 的 agent + skill
- 修订 `agents/rites-protocol-agent.md` 与 `.claude-plugin/plugin.json`：去掉 `publish-to-lark` 作为权力中心的表述
- 新语义命名 skill 目录建立：`skills/iostate-{draft,review,dispatch,deliver,verify,publish,allocate,emergency}/` 作为薄别名壳（内部调原 skill）
- **[订正 verdict-1 条件 3]** 硬切换终点，必须写入各薄别名壳的 SKILL.md：
  - **保留期限**：≤ v0.7.0 移除；在 v0.6.0 阶段新旧命名并存
  - **Deprecation 警告**：旧命名（如 `zhongshu-draft`）调用时，SessionStart/SubagentStart hook 输出一行 `⚠ deprecated: please use /iostate:draft (old name will be removed in v0.7.0)`
  - **最后验收项**（v0.7.0 切换前）：`grep -r "zhongshu-draft" --include="*.md"` 仅出现在 changelog 和 references/learning-side（学习侧）文档；其它调用路径零匹配
- **验收点**：V3 过（agents=8 且无 publish-to-lark-agent.md）；新旧命名皆可调用；deprecation 警告能触发
- **复审级别**：**门下独立复审**（不接受 Justice 转述）

### B4 — 可见性三件套（中风险，hook 改动）
- 新 `skills/stage-board/SKILL.md` + 实现
- 新 `skills/tool-trace/SKILL.md` + 实现
- 升级 `hooks/hooks.json` 的 SessionStart（末尾附工具箱清单）与 SubagentStart（输出"现在调用 X，因为 Y"一行人话）
- **验收点**：V4 过（4 条命令表）；Windows 下 UTF-8 BOM 兼容（参考最近 commit `37893c7`）
- **复审级别**：轻复审 + Windows hook 实测证据必审

### B5 — 契约升级 + 生成位同步（中高风险，动权威，**门下独立复审 + 单独 APPROVE**）
**[订正 verdict-1 条件 4 + 风险 2]**：

- **B5 前置动作**（必须）：
  - 拷贝 `contracts/workflow-contract.json` → `contracts/workflow-contract.backup-v0.5.0.json`（作为 B5 回滚基线保留入仓）
- **契约字段**（主动作）：
  - `workflow-contract.json` 顶级加 `skipPolicy` + `preemptPolicy` 节点
  - `intentPacket` schema 升级为五字段强制
- **生成位同步**（主动作，防空改）：
  - 升级 `skills/zhongshu-draft/SKILL.md` 内 intentPacket 模板段落为五字段
  - 升级 `contracts/run-artifact.template.json` 内 intentPacket 占位为五字段
  - SessionStart 输出（`bin/instrument-guard.ps1 session-context`）若提到 intentPacket 字段处同步
- **验收点**：V5 + V5b 均过；`powershell bin/instrument-guard.ps1 health` 输出不含 parse error
- **复审级别**：**门下独立复审 + 单独出具 APPROVE**，未 APPROVE 不得进 B6
- **级联 revert 规则**：
  - 若 B5 revert → **不** 级联 revert B3/B4（因 B3 改名与 B4 可见性与契约字段解耦）
  - 若 B5 revert → `workflow-contract.json` 直接用 `workflow-contract.backup-v0.5.0.json` 覆盖恢复；生成位（B5 内部改动）随 git revert 自动回滚
  - 若 B5 revert 后 v0.6.0 整体目标无法达成 → 升级用户决定是否关闭 docket

### B6 — 元信息与 README（低风险，收尾）
- `plugin.json` / `marketplace.json` 统一 `0.6.0`
- README.md 与 README.zh-CN.md 重写：顶部 30 秒速览 + 工具箱清单表 + 新主线解说（元 / 组织镜像 / 节奏 / 意图 / 发牌）
- **验收点**：V6 + V8
- **复审级别**：轻复审

---

## 8. Rollback Posture（含 B5 双保护）

- 每批独立 commit；B2 拆 3 sub-commit。失败则 `git revert <批次 sha>`，不用 `reset --hard`。
- **[订正 verdict-1 条件 4]** B5 特殊双保护：
  1. B5 前建 `contracts/workflow-contract.backup-v0.5.0.json`，随 B5 commit 入仓
  2. B5 的 revert 路径明确为"backup 覆盖 + git revert"而非单纯 git revert
  3. B5 revert **不级联** B3/B4（已在 §7 B5 级联规则声明）
- 契约层变更（B5）额外加一张 scar 模板至 `memory/`，即便成功也留痕。
- 若 3 批以上失败 → 暂停整个 docket，升级用户决定。

---

## 9. Public-Ready Criteria

完成后才可对外宣告 / 发布到 Lark：
- V1~V8 + V5b 全过
- `git log --oneline | head -20` 显示完整 6 批（B2 显示 3 sub-commit）共约 8 个 `reforge(Bn*):` commit
- 至少一次完整回归：`/iostate:dispatch` 全流程走通且 stage-board 输出正确
- Menxia 对最终汇总出具**第二次 APPROVE**（本次裁决 verdict-1 为 v2 memorial 前置审；最终汇总为 verdict-final）
- `constitutional-rules.md` 宪章 diff 已审

---

## 10. Writeback Intent

本次改造完成后，向 `memory/` 写入：
- **pattern**: "doctrine reforge 的最小改动路径"+ "B2 多文件合并应拆 sub-commit"
- **scar（若发生）**: 任何 revert 的批次（特别关注 B5）
- **capability-gap**: 是否暴露了新的未覆盖场景（比如 stage-board 输出还不够）

---

## 11. Menxia 二审提示

请 Menxia 按 `menxia-verdict-card.md` 模板对本 v2 出 4 选 1：
- **APPROVE** — 全部通过，解锁 B1
- **CONDITIONAL** — 附条件通过，列剩余条件
- **REMAND** — 继续退回修订
- **REJECT** — 驳回

审议重点（建议）：
1. 订正索引 §0 的 8 个落点是否**真的**都已落实（请用 grep / diff 验证，不凭 Zhongshu 声明）
2. §5 可证伪验收是否真的消除了主观判定
3. §7 B2 的 3 sub-commit 拆分是否合理，是否还有进一步原子化需求
4. §7 B5 的双保护 + 级联 revert 规则是否闭合
5. §4.1-17 的宪章修订是否具体到足以让 Works-Delivery 机械执行，不会二次扩大 scope

---

## 12. 新旧命名硬切换时间表（对 verdict-1 条件 3 的集中声明）

| 版本 | 状态 | 动作 |
|---|---|---|
| **v0.6.0**（本次） | 新旧命名并存；旧命名内部重定向；调旧命名时 hook 输出 deprecation 警告 | 本 memorial B3 落地 |
| **v0.7.0** | **切换终点**：旧命名（zhongshu-draft / menxia-review / shangshu-dispatch / works-delivery / justice-compliance / personnel-routing / revenue-budgeting / war-operations）**彻底移除** | 届时独立 memorial |
| **验收**（v0.7.0 切换前必做） | `grep -rE "zhongshu-draft\|menxia-review\|shangshu-dispatch\|works-delivery\|justice-compliance\|personnel-routing\|revenue-budgeting\|war-operations" --include="*.md" --include="*.json"` 除 `CHANGELOG.md` 与 `references/learning-side-legacy.md`（学习侧）外零匹配 | v0.7.0 memorial 的 In-scope 之一 |

本表作为 `evolution-writeback` 的 pattern 记录，v0.7.0 memorial 起草时必须引用本条。
