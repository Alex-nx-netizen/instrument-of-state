# Progress Log — Meta Reforge

**Docket:** `2026-04-23-meta-reforge`

---

## 2026-04-23

| Time | Actor | Event | Result |
|---|---|---|---|
| 14:13 | User | 提交请愿 `/agent-teams-playbook` + 飞书文档链接 + "插件冗杂" | Docket pending |
| 14:20~ | Coordinator | 意图澄清：3 问 → 用户回答 C + 允许改名 + 可见性是核心 | Intent locked |
| 14:25~ | Coordinator | 拉 lark-cli 获取飞书文档全文（标题：元：从混沌许愿到系统治理） | ✅ 文档内容入库 |
| 14:30~ | Explore ×3 (并行) | 调研：references 归并 / agents+skills 元合格性 / 节奏闸门可见性 | ✅ 三份报告返回 |
| 14:45~ | Coordinator | 写 `task_plan.md` / `findings.md` / `progress.md`（规划产物，治理允许） | ✅ 本文件 |
| 14:50~ | Coordinator | 起草 `memorial.md` | ✅ |
| 14:55~ | User | 回复"全部按默认解释" → 触发 Menxia 审查 | ✅ |
| 15:00~ | Menxia | 独立审议 memorial，出具 **CONDITIONAL** 裁决（6 条关键条件 + 2 条风险建议） | ✅ |
| 15:10~ | User | 回复"所所有的按照你推荐的来" = adopt all（采纳全部 6 条件 + 2 风险） | ✅ |
| 15:15~ | Coordinator (Zhongshu revised) | 起草 `memorial-v2.md`（保留 v1 不动，v2 含订正索引 §0） | ✅ |
| 15:30~ | Menxia (2nd pass) | 复审 memorial-v2，出 **verdict-2 = CONDITIONAL**（7/8 已落实；R2 缺 intentPacket 字段覆盖/叠加裁决；B1~B4 可开工，B5 前需补 14a + verdict-3）| ✅ |
| 15:40~ | Coordinator (Zhongshu) | memorial-v2 内补 §4.1-14a（叠加式裁决）+ §5 V5c + V5b 改进 + V2a 正则化 + 订正索引追加 | ✅ |
| 16:00~ | Works-Delivery | B1 commit prep | 3 new doctrines written | ✅ |
| 16:10~ | Coordinator | 暂存 + 提交 B1（`reforge(B1): add meta/cadence/deal-card doctrines`）| ✅ |
| 16:30~ | Works-Delivery | B2.1 UX doctrines 合并 → `ux-response-doctrine.md`（合并 3 → 1，删源文件 3 份）| ✅ |
| 17:00~ | Works-Delivery | B2.2 Lark 发布 doctrines 合并 → `lark-publication-doctrine.md`（合并 3 → 1，删源文件 3 份）| ✅ |
| 17:30~ | Works-Delivery | B2.3 宪章同步（六部合并 Personnel+Revenue → Resource Allocation）+ 吸收 imperial-workflow 原则 + 各 agent.md 内嵌 superpowers 绑定 + 删除 imperial-workflow.md & superpowers-integration.md | ✅ |

### B1 交付清单

- `E:\ai\study\instrument-of-state\references\meta-unit-doctrine.md`（205 行，含 `## 五特征` / `## Five Traits` / `## 四判断` / `## Four Checks` 独立 H2）
- `E:\ai\study\instrument-of-state\references\cadence-doctrine.md`（280 行，含四态各自的中英文 H2：发牌/Dealing/留白/Restraint/跳过/Skip/插队/Preempt）
- `E:\ai\study\instrument-of-state\references\deal-card-doctrine.md`（206 行，含 `## 三判断` / `## Three Checks` 独立 H2）

**自测结果**：V2a 全部 7 个正则单独验证通过；V1 当前计数 references/*.md = 23（B2 合并批次后将最终达到 14）；references 目录条目数 = 24（23 md + 1 json）。

### B2.1 交付清单

- 新增 `E:\ai\study\instrument-of-state\references\ux-response-doctrine.md`：合并 3 → 1，保留全部唯一规则，新增 "Relation to other doctrines" 子节（与 cadence / deal-card / meta-unit 至少三条交叉引用）与 Meta-Unit Self-Check（四判断逐条通过）。
- 删除 `references/ux-response-guidelines.md` / `references/first-use-and-controls.md` / `references/task-type-templates.md`。
- 入站引用盘点（B3/B6 处理）：`skills/shangshu-dispatch/SKILL.md` L24~L26、`skills/menxia-review/SKILL.md` L23~L24 仍指向被删文件；`references/deal-card-doctrine.md` L205 已前瞻性地指向 `ux-response-doctrine.md`，无需改。`artifacts/dockets/2026-04-23-meta-reforge/` 内 memorial/findings 为历史记录，不改。
- **references/*.md 计数**：23 → 21（新增 1、删除 3）。

### B2.2 交付清单

- 新增 `E:\ai\study\instrument-of-state\references\lark-publication-doctrine.md`：合并 `lark-publication-protocol` + `lark-publication-runbook` + `lark-publication-templates` 三文为一，以"本 doctrine 治理什么"开篇明示飞书/Lark 对外发布通道的管辖范围；按 Section A 协议 / Section B 执行序列 / Section C 模板 组织；新增 "Relation to other doctrines" 子节（与 cadence / deal-card / ux-response / run-artifact-protocol / meta-governance-layer 共五条交叉引用）；新增 Meta-Unit Self-Check（四判断逐条通过）。保留全部唯一规则：公开闸门律、权限律、通知律、失败处理律、四值决策矩阵、文档标题范式、主文档骨架、权限矩阵、IM 模板、公开闸门证据块（JSON + 中文双版本）。
- 删除 `references/lark-publication-protocol.md` / `references/lark-publication-runbook.md` / `references/lark-publication-templates.md`。
- 入站引用盘点（B3/B6 处理）：
  - `skills/publish-to-lark/SKILL.md` L19~L21（三条引用指向被删文件）
  - `skills/rites-protocol/SKILL.md` L19~L21（三条引用指向被删文件）
  - `skills/shangshu-dispatch/SKILL.md` L30~L31（两条引用指向被删文件）
  - `references/governance-playbook.md` L158（指向 `lark-publication-protocol.md`）
  - `README.md` L291（外部链接）
  - `README.zh-CN.md` L294（外部链接）
  - `artifacts/dockets/2026-04-23-meta-reforge/` 内 memorial/memorial-v2/findings 为历史记录，不改。
- **references/*.md 计数**：21 → 19（新增 1、删除 3）。

### B2.3 交付清单

- 修订 `references/constitutional-rules.md`：
  - **六部条目合并**（verdict-1 条件 2）：原 "Personnel Routing" 与 "Revenue Budgeting" 两条独立条目合并为单条 "Resource Allocation"，附中文平行段"资源调度（中文表述）"，声明两种工作模式（分工模式 / 预算模式）可在一次奏折中共同触发；总条目数维持六部不变。
  - **下游同步**：Strict mode 的 "Revenue Budgeting must assess..." 与 "Minimum routing rules" 中 "should route to Revenue Budgeting / Personnel Routing" 两行改写为 "Resource Allocation（两种模式）"统一入口。
  - **吸收 imperial-workflow 原则**：在开篇的引用清单之前新增"两层呈现"原则块（court language on the outside / protocol language on the inside / hard gates bind both layers / durable writeback closes every run）；从引用清单中移除 `imperial-workflow.md` 条目（文件本身删除）。
- 各 agent.md 新增 `## 超能力绑定（Superpowers binding）` 小节（9 份全覆盖）：
  - shangshu-agent：brainstorming / dispatching-parallel-agents / subagent-driven-development
  - zhongshu-agent：writing-plans
  - war-operations-agent：systematic-debugging
  - justice-compliance-agent：verification-before-completion / requesting-code-review / receiving-code-review / test-driven-development
  - works-delivery-agent：subagent-driven-development / executing-plans / systematic-debugging / test-driven-development / verification-before-completion / using-git-worktrees
  - menxia-agent / rites-protocol-agent：无专属映射，引用 `rules/common/agents.md`
  - personnel-routing-agent / revenue-budgeting-agent：无专属映射，并注明 B3 将被合并为 resource-allocator（审计留痕目的保留此次编辑）
- 删除 `references/imperial-workflow.md`（原则已融入宪章）+ `references/superpowers-integration.md`（映射表已内嵌至各 agent.md）。

**宪法 diff 关注点（供 Justice-Compliance 宪章 diff 审）**：
- 六部段结构从 "Personnel Routing → Revenue Budgeting → Rites Protocol → War Operations → Justice Compliance → Works Delivery" 改为 "Resource Allocation（含中英双段）→ Rites Protocol → War Operations → Justice Compliance → Works Delivery"；六条未变。
- Resource Allocation 条目的"两种模式"写法是**治理中立**的，与 B3 即将创建的 `agents/resource-allocator-agent.md` 兼容（本 commit 不预先描述 agent 实现细节）。
- 开篇新增"两层呈现 + 硬闸门 + 写回"原则块，用以代替被删除的 `imperial-workflow.md` 中不属于纯过程细节的核心原则。

**入站引用盘点（B3/B4/B6 处理）**：
- `README.md` L287 / `README.zh-CN.md` L290 仍指向 `imperial-workflow.md`（B6 README 重写时一并处理）
- `bin/instrument-guard.ps1` L488 仍引用 `superpowers-integration.md`（memorial §4.2 声明本次不动 bin；需在 B4 可见性或 B6 收尾中跟进，Works-Delivery 不越权修复）
- `skills/shangshu-dispatch/SKILL.md` L17 / L27 指向两份被删文件（B3/B4 改名批次同步处理）
- 历史文件（docket 内 memorial/memorial-v2/findings/task_plan）为历史记录，不改

**references/*.md 计数**：19 → 17（新增 0、删除 2）。

| Time | Actor | Event | Result |
|---|---|---|---|
| 18:00~ | Works-Delivery | B3 Agent/Skill 改名与合并；合并 personnel+revenue → resource-allocator；订正 publish-to-lark 在 rites-agent 中的表述；建立 8 个 /iostate:* 薄别名壳；修复 B2.1+B2.2 入站引用 | ✅ |

### B3 交付清单

**新建文件（9 份）**：
- `agents/resource-allocator-agent.md`（合并生成，含中文交付要求；两模式宪章指向 constitutional-rules.md）
- `skills/resource-allocator/SKILL.md`（薄壳，委派至 agent；两组输出章节按实际触发模式返回）
- `skills/iostate-draft/SKILL.md` → 别名 zhongshu-draft
- `skills/iostate-review/SKILL.md` → 别名 menxia-review
- `skills/iostate-dispatch/SKILL.md` → 别名 shangshu-dispatch
- `skills/iostate-deliver/SKILL.md` → 别名 works-delivery
- `skills/iostate-verify/SKILL.md` → 别名 justice-compliance
- `skills/iostate-publish/SKILL.md` → 别名 publish-to-lark（注明非独立权力中心）
- `skills/iostate-allocate/SKILL.md` → 别名 resource-allocator（合并新生）
- `skills/iostate-emergency/SKILL.md` → 别名 war-operations

**删除文件（4 份）**：
- `agents/personnel-routing-agent.md`
- `agents/revenue-budgeting-agent.md`
- `skills/personnel-routing/SKILL.md`（连带目录）
- `skills/revenue-budgeting/SKILL.md`（连带目录）

**修订文件（5 份）**：
- `agents/rites-protocol-agent.md`：新增"publish-to-lark 的地位（订正）"段，声明其为 Rites 麾下执行 skill，而非独立 Agent/权力中心（memorial-v2 §2.3 歧义 4 / §4.1-9）
- `skills/shangshu-dispatch/SKILL.md`：删除 `imperial-workflow.md` / `ux-response-guidelines.md` / `first-use-and-controls.md` / `task-type-templates.md` / `superpowers-integration.md` / `lark-publication-protocol.md` / `lark-publication-templates.md` 等 7 条失效引用；新增 `ux-response-doctrine.md` + `lark-publication-doctrine.md`
- `skills/menxia-review/SKILL.md`：将 `ux-response-guidelines.md` + `first-use-and-controls.md` 两条合并指向 `ux-response-doctrine.md`
- `skills/publish-to-lark/SKILL.md`：将 `lark-publication-protocol.md` + `lark-publication-runbook.md` + `lark-publication-templates.md` 三条合并指向 `lark-publication-doctrine.md`
- `skills/rites-protocol/SKILL.md`：同 publish-to-lark 的三合一引用修复
- `references/governance-playbook.md` L158：`lark-publication-protocol.md` → `lark-publication-doctrine.md`

**iostate 薄别名壳计数**：8（全部含 Purpose / Deprecation / Retention / Final verification / Delegation 五段完整）。

**入站引用修复（B2.1 + B2.2 遗留 11 条，全部处理）**：
- `skills/shangshu-dispatch/SKILL.md` × 5（ux 三条 + lark 两条 + imperial-workflow 一条 + superpowers-integration 一条顺手清）
- `skills/menxia-review/SKILL.md` × 2（ux 两条）
- `skills/publish-to-lark/SKILL.md` × 3（lark 三条）
- `skills/rites-protocol/SKILL.md` × 3（lark 三条）
- `references/governance-playbook.md` L158 × 1（lark 协议引用）

**plugin.json 状态**：已逐字检查，原文件不含任何将 publish-to-lark 描述为 agent-level power 的措辞；本次不编辑 plugin.json（Menxia verdict-2 条件 6 的修复点集中在 rites-protocol-agent.md，已落实）。

**已知延后项（不属于 B3 scope）**：
- `bin/instrument-guard.ps1` L488 仍引用 `superpowers-integration.md`（memorial §4.2 声明本次不动 bin；B4 可见性或 B6 收尾跟进）
- `README.md` / `README.zh-CN.md` 中对已删 doctrines 的链接（B6 README 重写统一处理）
- 历史 docket 文件（memorial / memorial-v2 / findings / task_plan）保留历史记录不改

**agents/*.md 计数**：9 → 8（新增 1、删除 2）。
**skills 目录计数**：11 → 18（新增 +9：resource-allocator + 8 iostate-* 别名；删除 −2：personnel-routing、revenue-budgeting）。

---

## 状态机当前快照

- **Intent lock**: ✅ locked（C 方向 + 允许改名 + 可见性优先）
- **Docket opened**: ✅
- **Memorial drafted**: ✅ v1 / ✅ v2 / ✅ v2 内补 14a
- **Menxia review**: 🟡 verdict-1 CONDITIONAL → 🟡 verdict-2 CONDITIONAL（放行 B1~B4）→ verdict-3 B5-pre 待出
- **Works delivery unlock**: 🟢 B1~B4 解锁（等用户启动）；🔴 B5 仍锁
- **Verification passed**: ⏸
- **Public-ready**: ⏸
