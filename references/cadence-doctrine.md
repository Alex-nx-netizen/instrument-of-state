# 节奏 (Cadence) Doctrine — 节奏四态

> **来源**：飞书文档《元：从混沌许愿到系统治理》。
> **定位**：规定"何时向用户释放动作机会 / 何时保持沉默 / 何时允许跳过某阶段 / 何时允许高优先级插队"。本 doctrine 与 `deal-card-doctrine.md` 配套使用：cadence 决定"什么时候发牌"，deal-card 决定"这张牌该不该发"。
> **版本**：v0.6.0 首版（随 Meta Reforge docket `2026-04-23-meta-reforge` 落地）。
> **契约落点**：`contracts/workflow-contract.json` 顶级将新增 `skipPolicy` 与 `preemptPolicy` 两节（B5 批次交付），本 doctrine 为其语义规范。

---

## 四态总览

本插件的节奏由四种态组成，任意时刻系统处于其中一态（或从一态过渡到另一态）。

| 态 | 简述 | 默认倾向 |
|---|---|---|
| 发牌 Dealing | 释放下一步动作机会 / 信息 / 选择 | 有证据支持才发 |
| 留白 Restraint | 保持安静，不打断用户当前任务 | 默认倾向 |
| 跳过 Skip | 允许略过某个通常会走的阶段 | 需要显式证据 |
| 插队 Preempt | 高优先级事项抢占当前队列 | 需要显式触发条件 |

**关键默认**：在"无明确证据支持应打断"的情况下，系统应处于**留白**态。这一条是整个节奏体系的基准线，对抗"模型急于证明自己在工作"的倾向。

---

## 发牌

### 定义
**发牌** = 系统根据当前状态判断应向用户释放一次动作机会、一条关键信息、或一个可选择的分支。每次发牌都有明确的发出者（某个 agent / hook / gate）、明确的触点（输出位置）、明确的成功指标（见 deal-card doctrine 的三判断）。

### 触发条件
- 完成了一个 gate（memorial 出来了 / verdict 出来了 / 交付完成了）
- 用户原意图中包含一个分支点，需要用户确认才能推进
- 系统观察到风险信号但该信号尚未越过"插队"阈值
- 某个 skill 运行结束且其输出需要被用户可见地消费

### 示例
- review 出具 verdict 后，coordinator 向用户发一张"批准 / 有条件 / 退回 / 驳回"牌
- B1 批次完成后，deliver 向用户发一张"go / halt / revise"牌
- SessionStart hook 末尾附一份"本会话可用工具箱"清单——每个工具都是一次潜在的发牌

### 反模式
- **盲发牌**：没有发生 gate 切换就主动问用户"下一步怎么办"。污染节奏，应走留白。
- **合并发牌**：一次发牌塞多个决策点（"您是要 A 还是 B；另外 C 是不是也改一下"）。违反 deal-card 的"提高下一步清晰度"。
- **隐式发牌**：在长段技术说明里埋一句"您看这样行不行"。用户会错过，相当于没发。

## Dealing

English mirror for regex compliance and non-Chinese readers.

### Definition
**Dealing** = the system, based on current state, decides to release a next-step opportunity, a key piece of information, or a branching choice to the user. Every deal has a declared emitter (an agent / hook / gate), a declared touchpoint (output location), and success criteria (see `deal-card-doctrine.md`).

### Triggers
- A gate has just closed (memorial produced / verdict produced / delivery batch complete)
- The original intent contains a branch point requiring user confirmation to continue
- A risk signal is observed that has not yet crossed the preempt threshold
- A skill just finished and its output must be visibly consumed by the user

### Examples
- After review issues a verdict, coordinator deals an "approve / conditional / remand / reject" card
- After B1 batch completes, deliver deals a "go / halt / revise" card
- SessionStart hook appends a "tools available this session" list — each tool is a latent deal

### Anti-patterns
- **Blind dealing**: asking "what's next?" when no gate transitioned. Pollutes rhythm — should be restraint.
- **Bundled dealing**: one deal carrying multiple decisions. Violates deal-card clarity.
- **Implicit dealing**: burying a question inside long technical prose. Users miss it; effectively not dealt.

---

## 留白

### 定义
**留白** = 系统在缺乏打断证据时保持安静，不向用户释放新动作机会。留白是**默认态**，不是"什么也没发生"——它是一个主动的选择。

### 触发条件
- 不满足任一发牌触发条件
- 当前阶段的 owner 仍在进行中且未报告阻塞
- 风险信号尚未越过任何阈值
- 用户上一条输入含"让它跑完"、"别打断"这类显式信号

### 示例
- deliver 在执行 B1 的中段写文件，无阻塞，不向用户发任何消息；只在 B1 结束时一次性发牌
- review 正在独立审议中，draft 与 deliver 都不应主动询问进度
- Hook 层发现一个可自动处理的 UTF-8 BOM 问题并自愈，不打断用户会话

### 反模式
- **焦虑发声**：模型因"怕用户以为我卡住了"而周期性输出进度短句。用户体验恶化。
- **伪留白**：宣布"我先安静一下"然后继续输出评论。真正的留白是零输出，不是告知自己要留白。
- **越权留白**：在该发牌的节点上保持沉默（例如 gate 已切换但未向用户交出摘要），事实上吞掉了用户的知情权。

## Restraint

### Definition
**Restraint** = the system stays silent when evidence for interruption is absent. Restraint is the **default state**, not "nothing happening" — it is an active choice.

### Triggers
- None of the dealing triggers fires
- The current stage's owner is making progress without reporting blockage
- Risk signals remain below all thresholds
- The user's last message contained explicit signals like "let it run" or "don't interrupt"

### Examples
- deliver mid-execution of B1 writing files with no blockers — emits no message until B1 finishes and then deals once
- review is in independent deliberation — neither draft nor deliver should ask about progress
- The hook layer silently heals a UTF-8 BOM issue without disturbing the session

### Anti-patterns
- **Anxious chatter**: periodic progress quips driven by the fear that the user thinks the model is stuck. Degrades UX.
- **Pseudo-restraint**: announcing "I'll be quiet now" and continuing to comment. True restraint is zero output.
- **Over-restraint**: staying silent at a point where a deal is owed (e.g., a gate transitioned but the user received no summary) — effectively swallowing the user's right-to-know.

---

## 跳过

### 定义
**跳过** = 节点知道自己在什么情况下可以被略过，上游无需为此重新编排。跳过不是"偷懒"，是契约里事先声明的合法路径。

### 触发条件（必须满足全部）
1. 本阶段的成功指标可由上游阶段的证据直接满足（无独立新增信息）
2. 跳过留下了可审计的记录（为什么跳，基于什么证据）
3. 下游阶段的输入契约不因跳过而缺失字段

### 示例
- 某 docket 的 scope 纯为文档修订，无代码变更 → `emergency` 阶段被跳过，记录为 `skip: no-operational-surface`
- 某批次只新增文件、无删除、无改名 → `rollback-rehearsal` 阶段被跳过，记录为 `skip: pure-addition`
- 用户上一条输入已明示"我不需要公开发布" → `publish` 的 publication 段被跳过，记录为 `skip: user-explicit-opt-out`

### 反模式
- **无证跳过**：跳过但不记录理由，下游无法追责。
- **沉默跳过**：跳过了但不向用户/后续审查者披露（应在 stage-board 上以 `skipped` 状态显示）。
- **滥用跳过**：把"本节点实施困难"当作跳过依据。跳过是合法路径而非逃避路径——若一个阶段"难做"，走留白或升级，不要走跳过。

### 契约绑定
B5 批次后，`workflow-contract.json` 将含 `skipPolicy` 顶级字段，声明哪些阶段可被跳过、跳过需要什么证据字段。未列入 `skipPolicy` 的阶段不得被跳过。

## Skip

### Definition
**Skip** = a stage knows under what conditions it can be legitimately bypassed; upstream does not need to re-choreograph. Skip is not "laziness" — it is a legal path declared in the contract.

### Triggers (all required)
1. This stage's success criteria are already satisfied by upstream evidence (no new independent information)
2. The skip leaves an auditable record (why, based on what evidence)
3. Downstream input contracts do not lose any required fields because of the skip

### Examples
- A docket whose scope is pure doc revision with no code change → `emergency` stage is skipped with `skip: no-operational-surface`
- A batch that only adds files without deletions or renames → `rollback-rehearsal` stage is skipped with `skip: pure-addition`
- The user explicitly said "no public release needed" → `publish` publication sub-stage is skipped with `skip: user-explicit-opt-out`

### Anti-patterns
- **Undocumented skip**: skipped without recording a reason — downstream cannot audit.
- **Silent skip**: skipped but not surfaced to the user/auditor (must show as `skipped` on the stage board).
- **Abused skip**: treating "this stage is hard" as skip grounds. Skip is a legal path, not an escape hatch — if a stage is "hard," use restraint or escalation, not skip.

### Contract binding
After batch B5, `workflow-contract.json` will carry a top-level `skipPolicy` declaring which stages are skippable and what evidence fields a skip requires. Stages not listed in `skipPolicy` MUST NOT be skipped.

---

## 插队

### 定义
**插队** = 高优先级事项抢占当前节奏，允许先动作后补手续。插队是对"默认留白"的破坏，代价高，仅在严格条件下允许。

### 触发条件（满足任一）
- **P0**：用户会话安全 / 数据丢失 / 治理硬拦截被绕过 / secret 泄漏 → 立即插队，先止血
- **P1**：核心 gate（review 审议通道、verify 验收通道）失效 → 插队修复
- **全局影响**：一个公共组件（guard 脚本、hooks.json、workflow-contract.json）故障影响所有 docket → 插队修复
- **用户显式升级**：用户以"紧急 / 先停下 / halt"等关键词明示抢占 → 插队

### 先插队后补手续规则
插队允许跳过常规 gate（如 memorial → review → deliver 的顺序），但必须在事后 72 小时内：
1. 补一份 post-hoc memorial，记载为什么插队
2. 补一次 review（回溯审议）
3. 把插队事件写回 `memory/` 作为 scar

未补手续的插队将触发 `emergency` 的自检失败并 DENY 后续动作。

### 示例
- `bin/instrument-guard.ps1` 出现 parse error 影响所有 Write 操作 → emergency 立即热修，事后补 memorial
- 用户输入"halt, guard 行为异常" → 立即暂停所有 in-flight subagent，进入诊断，事后补审议
- secret 出现在 git 日志 → 立即执行 secret 轮换 + 历史清除，事后 review 复审

### 反模式
- **伪插队**：把"我很急"当作插队依据，绕过 review 审议。这是权力分立被破坏的信号，应被 guard 层硬拦截。
- **插队不补**：事后 72h 内不补手续，事实上等同于永久性越权。
- **多重插队**：一次插队未补完又发起下一次插队，形成"永久紧急态"。emergency 在检测到连续 3 次未补完的插队时应自动熔断。

### 契约绑定
B5 批次后，`workflow-contract.json` 将含 `preemptPolicy` 顶级字段，声明 P0/P1 的精确定义、补手续时限、熔断规则。

## Preempt

### Definition
**Preempt** = a high-priority event seizes the current rhythm, acting first and filing paperwork later. Preempt breaks default restraint; its cost is high; it is admitted only under strict conditions.

### Triggers (any one)
- **P0**: user session safety / data loss / governance hard-rail bypassed / secret leaked → preempt immediately, stop the bleeding first
- **P1**: a core gate (review channel, verify channel) is broken → preempt to repair
- **Global impact**: a shared component (guard script, `hooks.json`, `workflow-contract.json`) fails and affects all dockets → preempt to repair
- **Explicit user escalation**: user says "urgent / halt / stop everything" → preempt

### Act-first-paperwork-later rule
Preempt may bypass the usual gate sequence (memorial → review → deliver), but within 72 hours post-event must:
1. File a post-hoc memorial recording why the preempt happened
2. File a retrospective review
3. Write the preempt event back to `memory/` as a scar

Preempts without paperwork filed will fail `emergency` self-check and DENY subsequent actions.

### Examples
- `bin/instrument-guard.ps1` throws a parse error affecting all Write ops → emergency hot-fixes immediately, files memorial post-hoc
- User says "halt, guard is misbehaving" → pause all in-flight subagents, enter diagnosis, file deliberation post-hoc
- A secret shows up in git log → execute rotation + history scrub immediately, file review post-hoc

### Anti-patterns
- **Fake preempt**: using "I'm in a hurry" as preempt grounds to bypass review. This is a signal that separation of powers is being breached — should be caught by the guard layer.
- **Paperwork default**: not filing within 72h — effectively a permanent power-grab.
- **Serial preempt**: new preempt started before previous preempt is paperworked — a "permanent emergency" state. Emergency must auto-break after 3 consecutive unpaperworked preempts.

### Contract binding
After B5, `workflow-contract.json` gains a top-level `preemptPolicy` declaring the precise P0/P1 definitions, paperwork deadlines, and circuit-breaker rules.

---

## 态之间的转移规则

```
留白 (default)
  │
  ├── gate 切换 / owner 完成 / 风险信号到达阈值 ──→ 发牌
  ├── 本阶段证据已被上游满足且入列 skipPolicy ──→ 跳过
  ├── P0/P1/全局影响/用户显式升级 ──────────────→ 插队
  └── (其它情况)                                  留白

发牌 ──→ 用户响应 / 超时 / 用户 halt ──→ 留白（或进入下一阶段）

跳过 ──→ 记录 skip 原因 + 证据 ──→ 留白（由下游继续）

插队 ──→ 止血完成 ──→ 72h 内补手续 ──→ 留白（常态恢复）
```

---

## 评分基线与未来检验

飞书文档源 doctrine 对现状打分：

| 态 | 现状分（v0.5.0） | 目标（v0.6.0 结束时） |
|---|---|---|
| 发牌 | 7/10 | 8/10（补可见性三件套后） |
| 留白 | 6/10 | 8/10（hook 人话输出抑制焦虑发声后） |
| 跳过 | 2/10 | 6/10（contract `skipPolicy` 上线后） |
| 插队 | 3/10 | 6/10（contract `preemptPolicy` 上线后） |

评分方法：每态准备 5 个场景问"系统会不会正确处理"，通过数 / 5 × 10 取整。

---

## 与其他 doctrine 的关系

- `deal-card-doctrine.md`：cadence 说"什么时候可以发"，deal-card 说"这张牌值不值得发"；两者是互补约束。
- `meta-unit-doctrine.md`：被编排的单位都是合格元；非元不参与节奏。
- `meta-governance-layer.md`：意图层 / 闸门层 / 验证层决定 cadence 的硬边界。
- `evolution-writeback.md`：插队事件必须写回 scar；跳过的历史记录用于识别冗余阶段。

---

## Meta-Unit Self-Check

- **独立**：定义节奏的四个合法态与转移规则
- **足够小**：仅规范"何时行动 / 何时安静"，不规范单次动作的内容
- **边界清晰**：输入 = 当前系统状态 + 事件；输出 = 四态之一 + 转移指令
- **可替换**：将来若引入更细节奏（例如"半发牌"），可整文件替换，不影响元 doctrine 与发牌 doctrine
- **可复用**：每个 docket 每个阶段都复用

四判断自评：独立 ✅ / 定位 ✅ / 替换 ✅ / 复用 ✅。
