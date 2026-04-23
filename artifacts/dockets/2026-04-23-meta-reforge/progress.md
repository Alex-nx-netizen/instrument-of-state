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
| 18:30~ | Menxia (3rd pass) | 对 B3 commit `a77fad4` 出具裁决 **CONDITIONAL**：指出 shangshu 工具白名单仍含已删 agent、team-blueprint-board 仍列 8/9 行旧模板、deal-card-doctrine L205 仍含 `ux-response-guidelines.md` 字面量三项缺口；同意以追加子提交 B3.1 精准修补后转 APPROVE | ✅ |
| 18:45~ | Works-Delivery | B3.1 追加子提交：修复 `agents/shangshu-agent.md` L4 工具白名单（去 personnel-routing/revenue-budgeting，加 resource-allocator-agent）；合并 `references/team-blueprint-board.md` 蓝图模板与模型分配表中 personnel+revenue 两行为 Resource Allocation 单行（9→8）；重写 `references/deal-card-doctrine.md` L205 去除 `ux-response-guidelines.md` / `first-use-and-controls` / `task-type-templates` 文件名字面量，改为叙述形式；授权链 = Menxia verdict-3 CONDITIONAL→APPROVE（B3.1 scope only） | ✅ |
| 01:35~ | Works-Delivery | B4 可见性三件套：新建 `skills/stage-board/SKILL.md` + `skills/tool-trace/SKILL.md`；`bin/instrument-guard.ps1` 两处增强（session-context 尾部附 Available toolbox 枚举；annotate-start 三角色 guidance 前缀 "Now invoking X because Y"）；`agents/shangshu-agent.md` L46-47 术语同步；BOM 保留；8/8 HMAC 通过；插件缓存已同步 | ✅ |

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

### B4 交付清单

**新建文件（2 份）**：
- `skills/stage-board/SKILL.md`（82 行；frontmatter `context: fork` / `user-invocable: true` / `allowed-tools: Read Bash Grep Glob`；含五步读取流程 + 闸门矩阵表 + Meta-Unit Self-Check 五特征四判断两节独立 H3）
- `skills/tool-trace/SKILL.md`（82 行；frontmatter 同形；含五步时间轴重建流程 + Meta-Unit Self-Check）

**修订文件（3 份）**：
- `bin/instrument-guard.ps1`：
  - `session-context` 模式（原 L484~L494）：在 `Write-AdditionalContext "SessionStart" ...` 之前追加 7 行 `try/catch` 块，枚举 `agents/*.md` / `skills/iostate-*` / `references/*-doctrine.md`，向 `$contextParts` 追加一条 `Available toolbox: agents=[...] | iostate-aliases=[...] | doctrines=[...]`。
  - `annotate-start` 模式（原 L650~L666）：三条角色 guidance 原地前缀：
    - zhongshu → `Now invoking Zhongshu because memorial drafting is required. <旧文>`
    - menxia → `Now invoking Menxia because the memorial is ready for review. <旧文>`
    - works-delivery（approved）→ `Now invoking Works-Delivery because Menxia approved — executing. <旧文>`
    - works-delivery（未批）→ `Now invoking Works-Delivery because a delivery attempt was requested — but approval is absent. <旧文>`
  - 行数 763 → 770；首四字节仍为 `EFBB BF70`（UTF-8 BOM 保留）。
- `agents/shangshu-agent.md` L46-47：`吏部（分工）` / `户部（成本）` → `资源调度（分工模式）` / `资源调度（预算模式）`（B3 Menxia 关闭注中的美观订正，零结构改动）
- `artifacts/dockets/2026-04-23-meta-reforge/progress.md`：新增 B4 行与本交付清单段

**Hook 未改动**：
- `hooks/hooks.json` 未触碰（契约层改动属 B5 范畴）
- `contracts/*` 未触碰
- `README*.md` / `.claude-plugin/plugin.json` 未触碰（B6 收尾处理）

**自测结果**：
- `bin/test-guard-hmac.ps1`：8/8 通过
- `echo {} | powershell -NoProfile -File bin/instrument-guard.ps1 session-context` 输出尾部含 `Available toolbox: agents=[... 8 份 ...] | iostate-aliases=[... 8 份 ...] | doctrines=[cadence-doctrine, deal-card-doctrine, lark-publication-doctrine, meta-unit-doctrine, ux-response-doctrine]`
- `diff bin/instrument-guard.ps1 ~/.claude/plugins/cache/instrument-of-state/instrument-of-state/0.5.0/bin/instrument-guard.ps1`：无输出（缓存已同步）

**V4（可见性验收）对应情况**：
- `ls skills/stage-board/SKILL.md` ✅ 存在 82 行 > 30
- `ls skills/tool-trace/SKILL.md` ✅ 存在 82 行 > 30
- session-context 输出含 `Available toolbox:` ✅
- SubagentStart 注入含 `Now invoking` 人话格式 ✅（三角色四分支均加 prefix）

**skills 目录计数**：18 → 20（新增 +2：stage-board、tool-trace；无删除）。

## 2026-04-24

| Time | Actor | Event | Result |
|---|---|---|---|
| 01:40~ | Menxia (3rd pass) | verdict-3 双裁决：B4 close + B5 pre-APPROVE（7 条 binding） | ✅ |
| 01:45~ | Works-Delivery | B5 启动：备份 `contracts/workflow-contract.json` → `.backup-v0.5.0.json` | ✅ |
| 01:50~ | Works-Delivery | B5 契约升级：新增 `skipPolicy` + `preemptPolicy` 两个顶层节点；`intentPacket.fields` 5 → 10（保留原 5 项 + 新增 owner/when/touchpoint/success/adjustPath）；模板中 `intentPacketVersion` 默认值 v1 → v2 | ✅ |
| 01:55~ | Works-Delivery | B5 生成器同步：`contracts/run-artifact.template.json` 意图包占位位升级至 10 字段 v2；`skills/zhongshu-draft/SKILL.md` 意图包小节展示十字段 | ✅ |
| 02:00~ | Works-Delivery | B5 守护程序检查：`bin/instrument-guard.ps1` session-context 模式未含 intentPacket 字段字面引用（仅通用 "intent packet" 叙述），按 verdict-3 binding 4 保持不改 | ✅ |
| 02:05~ | Works-Delivery | B5 验证：3 个 JSON 文件全部有效；`powershell bin/instrument-guard.ps1 health` exit 0 + 输出合法 JSON | ✅ |

### B5 交付清单

**修订文件（3 份）**：
- `contracts/workflow-contract.json`：
  - `protocols.intentPacket.fields` 字段数组：5 → 10（追加式，保留原 5 项顺序不变），新 5 项顺序为 `owner`、`when`、`touchpoint`、`success`、`adjustPath`（严格按 verdict-3 binding 3）
  - 根层新增 `skipPolicy` 节点（snake_case 字段遵循现有 schema 约定）：`description` / `skippable_stages=[menxia, justice]` / `skip_requires_evidence=true` / `evidence_fields=[skip_reason, skip_authorized_by, skip_scope]` / `audit_trail=required`
  - 根层新增 `preemptPolicy` 节点：`description` / `preempt_triggers=[P0_incident, P1_data_loss_risk, production_outage]` / `preempt_scope=single_action_with_post_hoc_memorial` / `preempt_audit_requirement=mandatory_post_memorial_within_24h`
- `contracts/run-artifact.template.json`：`intentPacket` 占位位升级至 10 字段（保留原 5 项占位位，追加 5 项新占位位），`intentPacketVersion` 默认值 `v1` → `v2`
- `skills/zhongshu-draft/SKILL.md`：`## 意图包` 小节由 4 项列表升级至 10 项列表，明示中文名 + 英文键名对应关系；Zhongshu 今后起草意图包会按十字段产出

**新建文件（1 份）**：
- `contracts/workflow-contract.backup-v0.5.0.json`（B5 回滚基线，原契约完整副本，文件名严格按 verdict-3 binding 1）

**未触碰（按 verdict-3 binding 4/5 明令）**：
- `bin/instrument-guard.ps1`：全文 grep `trueUserIntent|successCriteria|nonGoals|defaultAssumptions|intentPacketVersion|intentPacket` 零命中（session-context 仅叙述性提及 "intent packet"），按 binding 4 保持不动
- `hooks/hooks.json` / `.claude-plugin/plugin.json` / `marketplace.json` / `README*.md` / `agents/` 全员保持不动
- 守护程序缓存 (`~/.claude/plugins/cache/...`)：因守护程序未修改，无需同步

**验证证据**：
- `contracts/workflow-contract.json`：JSON 解析通过；根层 keys 包含 `contract_version / public_model / meta_layer / state_model / protocols / run_artifact / gates / rollback_levels / writeback_targets / skipPolicy / preemptPolicy`
- `contracts/run-artifact.template.json`：JSON 解析通过；`intentPacket` 含 10 键 + `intentPacketVersion=v2`
- `powershell bin/instrument-guard.ps1 health`：exit 0；stdout 为合法 JSON（`hookSpecificOutput.additionalContext` 亦为合法 JSON 子串），表明契约 JSON 升级未破坏守护程序读取
- V5b（/iostate:draft 差分测试）按 verdict-3 说明：B5 改动为契约与模板层，差分验证需要一次新 draft 运行才能落地 → 推迟到 B5 之后的 verdict-4 阶段处理

## 2026-04-24（续）

| Time | Actor | Event | Result |
|---|---|---|---|
| 02:15~ | Menxia (4th pass) | verdict-4 APPROVE B6 entry | ✅ |
| 02:20~ | Works-Delivery | B6 启动：更新 plugin.json / marketplace.json 至 0.6.0；description 同步 doctrine 层语言 | ✅ |
| 02:25~ | Works-Delivery | B6 README 双语重写：顶部 30 秒速览 + 工具箱表 + 何时使用；V8 三锚点命中；字数前 40 行 en=239 / zh=162（均 ≤300） | ✅ |
| 02:30~ | Works-Delivery | B6 收尾清理：`bin/instrument-guard.ps1` L488 `superpowers-integration.md` 悬空引用改为指向"各 agent.md 超能力绑定小节（见 constitutional-rules.md）"；BOM 保留；缓存已同步；HMAC 8/8 过 | ✅ |
| 02:35~ | Works-Delivery | B6 README 残留引用清理：`README.md` L287 / `README.zh-CN.md` L290 原 `imperial-workflow.md` 与 L291/L294 `lark-publication-protocol.md` 全部移除或改指新 doctrine | ✅ |

### B6 交付清单

**修订文件（5 份）**：
- `.claude-plugin/plugin.json`：`version` 0.5.0 → 0.6.0；`description` 重写为 meta-reforge doctrine 层声明（长度 < 300 字符单段）
- `.claude-plugin/marketplace.json`：`metadata.version` 0.4.1 → 0.6.0；`plugins[0].version` 0.4.1 → 0.6.0；两处 description 对齐 plugin.json
- `bin/instrument-guard.ps1` L488：`references/superpowers-integration.md` → `each agent.md 'Superpowers binding' section (see references/constitutional-rules.md)`（BOM `EFBB BF` 保留，缓存已同步，HMAC 8/8 通过）
- `README.md`：顶部重写 V8 合规版（lines 1-30 含 `governed execution` / toolbox skills 表 / `When to use`）；中部 skill/gate 表补录 `stage-board` / `tool-trace` / `resource-allocator` / `skipPolicy` / `preemptPolicy` 条目；References 小节去除 `imperial-workflow` 与 `lark-publication-protocol` 悬空，改指 `meta-unit-doctrine` / `cadence-doctrine` / `deal-card-doctrine` / `ux-response-doctrine` / `lark-publication-doctrine` 五份新 doctrine 与 `constitutional-rules`
- `README.zh-CN.md`：同上，中文平行版（前 10 行含 `治理`；工具箱表含 `skills` 列；何时使用节；References 小节清理同英文）

**自测结果（B6 scope 内）**：
- `jq -r '.version' .claude-plugin/plugin.json` → `0.6.0`
- `jq -r '.metadata.version, .plugins[0].version' .claude-plugin/marketplace.json` → `0.6.0` / `0.6.0`
- `head -40 README.md | wc -w` → `239` ≤ 300 ✅
- `head -40 README.zh-CN.md | wc -w` → `162` ≤ 300 ✅
- V8 锚点 1（前 10 行 `governed execution` / `治理`）：两份 README 均 grep 命中 ✅
- V8 锚点 2（工具箱 skills 列）：两份 README 前 40 行均含 markdown 表且列名含 `skill(s)` ✅
- V8 锚点 3（何时使用）：英文 `### When to use`；中文 `### 何时使用` ✅
- `file bin/instrument-guard.ps1` → `UTF-8 (with BOM) text` ✅
- `bin/test-guard-hmac.ps1` → 8/8 passed ✅
- `diff bin/instrument-guard.ps1 ~/.claude/plugins/cache/instrument-of-state/instrument-of-state/0.5.0/bin/instrument-guard.ps1` → 无差异 ✅
- 残留悬空引用：`grep -n "imperial-workflow\|lark-publication-protocol" README.md README.zh-CN.md` → 零命中 ✅

**版本影响**：本 commit 落地 0.5.0 → 0.6.0 版本号；首次 v0.6.0 发布基线形成（契约层 B5 已就位，可见性 B4 已就位，命名改造 B3 已就位，doctrines B1+B2 已就位）。

**已延后项（B6 scope 外，纳入 verdict-4 后的最终验收）**：
- V1~V8 + V5b + V5c 最终回归尚未执行（预计由 Justice-Compliance 在 verdict-final 前跑齐）
- 缓存目录 `~/.claude/plugins/cache/instrument-of-state/instrument-of-state/0.5.0/` 名称仍带旧版本号，属 Claude Code 插件管理器行为，非本 docket scope

**保留邀请**：intentPacketVersion 字段本身的名字保留不变（非改名，而是 *值* 由 v1 → v2），旧运行产物 `intentPacketVersion: v1` 仍可被解析（Zhongshu 新模板产出 v2）；若未来启用严格版本校验，再在 V5 验收中加测。

---

## 状态机当前快照

- **Intent lock**: ✅ locked（C 方向 + 允许改名 + 可见性优先）
- **Docket opened**: ✅
- **Memorial drafted**: ✅ v1 / ✅ v2 / ✅ v2 内补 14a
- **Menxia review**: 🟡 verdict-1 CONDITIONAL → 🟡 verdict-2 CONDITIONAL → 🟢 verdict-3 B4-close + B5 pre-APPROVE
- **Works delivery unlock**: 🟢 B1~B6 已交付（verdict-4 APPROVE）；⏸ V1~V8 + V5b + V5c 最终验收待执行
- **Verification passed**: ⏸
- **Public-ready**: ⏸
