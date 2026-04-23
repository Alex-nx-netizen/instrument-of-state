# Findings — Meta Reforge 调研记录

**Docket:** `2026-04-23-meta-reforge`
**Sources:** 飞书文档 `IJSKdSyGVoBPvdx0R4rch483nTf` + 3 个并行 Explore agent 调研

---

## F1. 飞书文档《元：从混沌许愿到系统治理》核心主线摘录

### 主骨：**元 → 组织镜像 → 节奏编排 → 意图放大**

### 元的五特征
- 独立（能单独说清它负责什么）
- 足够小（不再往下拆收益开始变低）
- 边界清晰（不与别人串味）
- 可替换（换掉不会把系统拖死）
- 可复用（下次相近任务能再用）

### 元的四判断问题
- 单独拿出来，能不能说清它负责什么？
- 出问题时，能不能定位到它？
- 想替换它时，会不会把整个系统一起拖死？
- 下次遇到相近任务时，它能不能复用？

> 前两个答不出来 = 还不是元；后两个答不出来 = 还不够成熟。

### 组织镜像的四件事
- 明确分工
- 明确升级路径
- 明确复核点
- 明确兜底点

### 节奏四态
- **发牌**：系统在当前状态下判断释放什么信息/动作机会
- **留白**：没有明确证据证明"打断更优"时默认不打断
- **跳过**：不是每个节点都必须走，节点知道何时可被跳过
- **插队**：高风险/公共组件/全局影响时优先级上升

### 发牌的三判断
- 它有没有减少用户的不确定性？
- 它有没有提高下一步动作的清晰度？
- 它有没有过度打断用户当前任务？

### 意图放大五字段
- 谁来做 / 何时做 / 通过什么触点 / 由哪张牌推动 / 做到什么算完成 / 效果不好往哪里调

### 五步落地
1. 把任务拆成元
2. 给每个元写职责边界
3. 画出先后顺序，以及跳过/插队条件
4. 定义关键牌的触发条件和成功指标
5. 给关键环节加上校验、修复和回滚

---

## F2. References 盘点（当前 20 份，来自 Explore Agent A）

### 文件清单（摘要）

| 文件名 | 行数 | 主题 |
|---|---|---|
| constitutional-rules.md | 249 | 治理宪法与分权 |
| governance-playbook.md | 190 | 9 阶段操作手册 |
| imperial-workflow.md | 107 | 法庭模型与隐层关系 |
| meta-governance-layer.md | 174 | 意图/网关/验证隐层 |
| ux-response-guidelines.md | 107 | 用户可见文案 |
| first-use-and-controls.md | 49 | 首次使用引导 |
| task-type-templates.md | 94 | 四类任务输出模板 |
| menxia-verdict-card.md | 98 | 门下裁决卡格式 |
| imperial-stage-board.md | 185 | 进度清单展示 |
| team-blueprint-board.md | 143 | 团队蓝图矩阵 |
| frontend-governance.md | 102 | 前端工作约束 |
| superpowers-integration.md | 168 | Superpowers 集成 |
| global-agent-routing.md | 234 | Agent 路由规则 |
| market-acquisition.md | 84 | 能力获取阶梯 |
| hook-compatibility.md | 83 | Windows Hook 兼容 |
| run-artifact-protocol.md | 80 | 持久化契约 |
| evolution-writeback.md | 86 | 学习回写体系 |
| lark-publication-protocol.md | 111 | 发布协议 |
| lark-publication-runbook.md | 154 | 发布执行序列 |
| lark-publication-templates.md | 152 | 发布模板库 |

### 合并链（3 组明确的重叠）

**合并 ①** — UX 三合一（→ `ux-response-doctrine.md`）：
- `ux-response-guidelines.md` + `first-use-and-controls.md` + `task-type-templates.md`

**合并 ②** — Lark 三合一（→ `lark-publication-doctrine.md`）：
- `lark-publication-protocol.md` + `lark-publication-runbook.md` + `lark-publication-templates.md`

**合并 ③** — 宪章整理（→ 增补进 `constitutional-rules.md`）：
- `imperial-workflow.md` 的原则部分并入宪章

**删除：** `superpowers-integration.md`（内容迁入各 agent 定义，保留一份 skill 映射表）

**保持独立：** meta-governance-layer / governance-playbook / run-artifact-protocol / evolution-writeback / menxia-verdict-card / imperial-stage-board / team-blueprint-board / frontend-governance / global-agent-routing / market-acquisition / hook-compatibility

### 最终：20 → 14（含新增 3 份 doctrine）

---

## F3. Agents / Skills 元合格性（来自 Explore Agent B）

### 当前 9 个 Agent 的元合格性

| 名称 | 独立 | 小 | 边界 | 可替换 | 问题 |
|---|---|---|---|---|---|
| shangshu | Y | Y | Y | N | 编排核心 |
| zhongshu | Y | Y | Y | N | 意图唯一来源 |
| menxia | Y | Y | Y | N | 审查唯一权 |
| justice-compliance | Y | Y | Y | N | 质量门槛唯一定义 |
| personnel-routing | Y | Y | Y | **Y** | 可与 revenue 合并 |
| revenue-budgeting | Y | Y | Y | **Y** | 可与 personnel 合并 |
| rites-protocol | Y | **N** | Y | N | 范围过广：定义+执行合一 |
| war-operations | Y | Y | Y | Y | 少触发 |
| works-delivery | Y | Y | Y | N | 执行唯一权源 |

### 合并建议

- `personnel-routing` + `revenue-budgeting` → **`resource-allocator`**（资源配置 = 分工 + 预算）
- `publish-to-lark` 从 agent 身份 **降级为 rites 的 skill**（它本身是工具，不是权力中心）
- `rites-protocol` 范围过广，但保留（内部再分发布 skill，外部仍是单一权力）

### 最终形态：8 个 agent + 精简后的 skill 集

---

## F4. 节奏/闸门/可见性现状（来自 Explore Agent C）

### A. 契约层（workflow-contract.json）

- **9 种 packet**：intent / intentGate / memorial / review / dispatch / verification / summary / publication / writeback
- **4 种 gate**：menxia_review_ready / works_delivery_unlock / public_ready / lark_publication
- **回滚**：4 级（file / subtask / partial / full）+ 6 种控制状态（normal / conditional / **skip** / interrupt / rollback / iteration）—— `skip` 状态已定义但**无激活规则**

### B. Hook 层（hooks.json）

- `SessionStart`：注入治理上下文
- `SubagentStart`：按角色注入约束（zhongshu=仅草稿；menxia=仅审议；works=仅交付）
- `SubagentStop`：捕获输出并更新状态机
- `PreToolUse`：检查 Agent / Write / Edit / Bash
- `PostToolUse (Agent)`：登记结果

### C. Guard 层（bin/instrument-guard.ps1）

- 11 种模式、HMAC-SHA256 完整性、双语 Verdict 解析、可变 Bash 反向白名单 14 条
- **硬拦截**：无 memorial → Menxia DENY；未 APPROVE → Works DENY；未 public_ready → Lark outbound DENY

### D. 节奏四态评分

| 四态 | 评分 | 现状 |
|---|---|---|
| 发牌 | 7/10 | Gate 驱动释放，但缺"可跳过某阶段"的决策点 |
| 留白 | 6/10 | 有"仅查阅"vs"可交付"区分，但**无用户可见的暂停机制** |
| 跳过 | **2/10** | 控制状态有 skip 但无激活规则——**几乎空缺** |
| 插队 | **3/10** | interrupt/rollback 存在，但**无 war-operations 专用通道**；定义不显式 |

### E. 可见性评估（⭐⭐⭐⭐⭐ 控制 / ⭐ 可见性）

| 维度 | 现状 |
|---|---|
| 用户能否看到当前 agent/skill/hook/gate？ | ❌ 仅被拦时才知道 |
| 实时 stage board？ | ❌ 无 |
| 调用链回放？ | ❌ 无 |
| 唯一可用 | `powershell bin/instrument-guard.ps1 health` 输出 JSON，无 UI |

### 关键差距（要补的）

- 实时 dashboard（CLI 文本，不要求 Web）
- Hook 事件日志可视化（每个 gate transition）
- Agent trace（谁调了谁，哪些 skill 被激活）
- Stage timeline（耗时分析可选）

---

## F5. Plugin 元信息状态

- `.claude-plugin/plugin.json`：version `0.5.0`
- `.claude-plugin/marketplace.json`：version `0.4.1`（**不一致**）
- 最近 commit：`37893c7 fix(encoding): add UTF-8 BOM to instrument-guard.ps1` / `de94113 fix(guard): v0.5.0 - security hardening and memory layer init`

**需要修**：本次统一升级到 `0.6.0`（breaking-doctrine change）。

---

## F6. 映射表：用户痛点 → 改造动作

| 用户原话 | 对应文档概念 | 改造动作 |
|---|---|---|
| "使用起来不明确，不知道在干什么" | 发牌（提高清晰度） | SessionStart 增强 + `stage-board` skill |
| "不知道使用了哪些东西，比如 skills" | 发牌（减少不确定性） | `tool-trace` skill + SessionStart 列工具箱 |
| "执行起来看不到用了什么" | 发牌（过程可见） | hooks 每次 Subagent/Gate 向用户输出一行 |
| "没有用到主流的思想" | 元/组织镜像/节奏/意图 | 新增 3 份主线 doctrine + 契约补跳过/插队 |
| "插件有点冗杂" | 元的可替换/足够小 | References 20→14；Agents 9→8；skills 降级 |
