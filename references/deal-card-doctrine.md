# 发牌 (Deal-Card) Doctrine — 发牌的三判断

> **来源**：飞书文档《元：从混沌许愿到系统治理》。
> **定位**：每一次向用户释放动作机会 / 选择 / 信息前，必须通过三判断自检，否则该"牌"不发。本 doctrine 与 `cadence-doctrine.md` 配套：cadence 说"是否处于可发牌的态"，本 doctrine 说"这张具体的牌够不够格发"。
> **版本**：v0.6.0 首版（随 Meta Reforge docket `2026-04-23-meta-reforge` 落地）。

---

## 为什么需要发牌 doctrine

本插件既是自动化工具，也是用户要与之协作的对象。每次系统向用户输出（提问、报告、摘要、请求确认），都在消耗用户的一小段注意力。注意力不是免费的——过度发牌让用户疲劳，最终要么关掉工具、要么盲目 `go`，两种结局都破坏治理。

因此，本插件把"发牌"当作一种有成本的动作，在 cadence doctrine 判定"现在可以发牌"之后，再用三判断筛选"这张牌值不值得发"。

---

## 三判断

对每一次即将发生的发牌，发起者（agent / hook / gate）必须就地回答以下三个问题；任一问答"否"或"不确定"，该牌不发。

### 判断 1 — 减少不确定性
> 这张牌有没有减少用户的不确定性？

- **过**：用户收到这张牌后，对"系统在做什么 / 已经做完什么 / 下一步要做什么"更清楚
- **不过**：用户收到后并没有比之前知道得更多（例如只是个空洞的"正在处理"通知）

### 判断 2 — 提高下一步清晰度
> 这张牌有没有提高下一步动作的清晰度？

- **过**：用户在这张牌之后能明确回答"我现在应该做什么 / 不做什么"
- **不过**：用户收到后不知道需不需要回应、该怎么回应、回应多久

### 判断 3 — 不过度打断
> 这张牌有没有过度打断用户当前任务？

- **过**：发牌时机与用户当前心智节奏匹配（gate 切换点、阶段结束点、风险信号到达阈值点）
- **不过**：在用户深度工作中间插入非紧急信息，或一次塞入多个决策点让用户被迫停下详读

**三问全过才发牌**。任一不过需要选择：改牌（让它变得值得发）、延后（等到节拍更合适时）、或吞下（永远不发）。

## Three Checks

English mirror for regex compliance and non-Chinese readers.

Every forthcoming deal MUST be self-checked by its emitter against these three questions on the spot. Any "no" or "unsure" blocks the deal.

### Check 1 — Does it reduce uncertainty?
Does the user know more — about what the system is doing / has finished / will do next — after receiving this card than before?

- **Pass**: user is strictly less uncertain
- **Fail**: user merely receives a hollow "working on it" notification

### Check 2 — Does it increase next-step clarity?
After this card, can the user clearly answer "what should I do next / not do"?

- **Pass**: next step is unambiguous
- **Fail**: user cannot tell whether response is required, how, or on what timeline

### Check 3 — Does it avoid over-interrupting?
Does the timing match the user's mental rhythm — at gate transitions, stage ends, or when a risk signal crossed threshold?

- **Pass**: deal lands at a breath-taking point
- **Fail**: deal lands mid-deep-work with non-urgent info, or bundles multiple decisions forcing a long stop

**Only all-three-pass deals go out**. Any failure leads to: revise the card, defer the deal, or drop it entirely.

---

## 正例

以下是符合三判断的真实发牌场景。

### 正例 1 — Menxia verdict 出具后的发牌

**发牌内容**：
> 门下省对 memorial-v2 出具 **CONDITIONAL**。
> 7/8 已落实，剩一项（intentPacket 覆盖/叠加方向未定）。
> B1~B4 可开工；B5 前必须补 §4.1-14a + verdict-3。
> 您的选择：(a) 采纳门下建议补 §4.1-14a (b) 改由你亲自拍板 (c) 驳回裁决

| 判断 | 通过？ | 理由 |
|---|---|---|
| 减少不确定性 | ✅ | 用户之前不知道门下结论，现在知道 7/8 + 具体缺口 |
| 提高清晰度 | ✅ | 给了三个明确选项 a/b/c |
| 不过度打断 | ✅ | 在 gate 切换点（memorial 审议结束）发 |

### 正例 2 — B1 批次完成后的发牌

**发牌内容**：
> **B1 已完成** — 本批动作：新建 3 份 doctrine，文件：meta-unit / cadence / deal-card。
> **验收自测**：V2a 正则全过，references 计数 21→24。
> **下一步**：您 `go` 则进 B2 宪法合并批次；`halt` 暂停；`revise` 要求返工。

| 判断 | 通过？ |
|---|---|
| 减少不确定性 | ✅（用户知道 B1 的输出与自测） |
| 提高清晰度 | ✅（三词选项 go/halt/revise） |
| 不过度打断 | ✅（批次结束点） |

---

## 反例

以下是**不应发出**的牌——本节保留作为训练数据，让未来的 emitter 对照自检。

### 反例 1 — 焦虑进度条

**拟发内容**：
> 正在处理中，请稍等...（3 秒后又一条）正在继续处理...（再 5 秒）还在继续...

| 判断 | 通过？ | 理由 |
|---|---|---|
| 减少不确定性 | ❌ | 没说在做什么，没说还剩多久 |
| 提高清晰度 | ❌ | 用户不知道要不要做什么 |
| 不过度打断 | ❌ | 周期性插入，破坏深度任务 |

**正确处理**：吞下。进入留白态，让 cadence doctrine 接管；真正进度由 stage-board skill 按需查询。

### 反例 2 — 打包决策

**拟发内容**：
> 我建议采取 A 方案。另外，顺便问一下您要不要把 B 也改了？还有 C 目录下那几个文件要不要清理？另外版本号是升到 0.6.0 还是 1.0.0？

| 判断 | 通过？ | 理由 |
|---|---|---|
| 减少不确定性 | ⚠ 半过 | A 方案明确了，但后面三个决策点引入新的不确定性 |
| 提高清晰度 | ❌ | 四个决策点混在一张牌里，用户不知道先回哪个 |
| 不过度打断 | ❌ | 单次发牌塞四个决策，过载 |

**正确处理**：拆为四次独立发牌，按 cadence 节奏分散发出；当前只发 A 决策，其它延后到各自 gate。

### 反例 3 — 隐式发牌

**拟发内容**：
> （1200 字的技术说明，中间第 8 段第 3 句）"...所以这里可能有风险，您看这样处理行不行？"（继续说明 400 字）

| 判断 | 通过？ | 理由 |
|---|---|---|
| 减少不确定性 | ❌ | 问题被大段技术说明淹没 |
| 提高清晰度 | ❌ | 用户多半没注意到被问了，回不了话 |
| 不过度打断 | ⚠ | 表面看没打断，实际等于没发——用户错过后系统默默继续 |

**正确处理**：把决策点提出来单独发一张短牌；技术说明作为"附 · 背景"放在后面。

### 反例 4 — 无证件发牌

**拟发内容**：
> 我觉得这个应该没问题，您同意吗？

| 判断 | 通过？ | 理由 |
|---|---|---|
| 减少不确定性 | ❌ | "应该没问题"没有任何证据，用户更不确定了 |
| 提高清晰度 | ❌ | "同意"什么？范围不明 |
| 不过度打断 | — | 即便时机合适，内容本身已不合格 |

**正确处理**：补齐证据（跑命令、读文件、引用 verdict）后再发牌，或直接走留白。

---

## 发牌的形态规范

一张合格的牌应具备以下结构（可视为发牌的最小模板）：

```
[发起者]：[动作/gate 简述]

- 做了什么：[客观事实 1~3 条]
- 当前状态：[此时系统在哪/卡在哪]
- 您的选择：[A / B / C]（或"无需您回应"）
```

**原则**：
- 一张牌 ≤ 120 字为佳；超长意味着多决策点混杂，该拆。
- 选项必须离散可枚举（A/B/C），不要开放式（"您怎么看"）。
- 若不需要用户回应，明示"无需您回应"，避免用户误以为被催促。

---

## 与治理链条的绑定

- **Zhongshu**：起草 memorial 与发布草案时，每一段"请用户决定"的位置都要过三判断。
- **Menxia**：verdict-card 本身就是一次发牌，其"下一步指令"节要满足清晰度。
- **Works-Delivery**：批次结束向用户交付摘要时，摘要本身就是一张牌。
- **Hook 层**：SessionStart / SubagentStart 的人话输出每次都过一次三判断的最小版（至少满足"减少不确定性"）。
- **war-operations**：插队态下的"先动作后补手续"也要在动作完成后立即发牌告知用户。

---

## Meta-Unit Self-Check

- **独立**：定义"一次具体的对用户输出动作值不值得发生"
- **足够小**：只做单次发牌的资格审查，不涉及节奏态转移与元合格性
- **边界清晰**：输入 = 一次拟发内容 + 当前上下文；输出 = 发 / 改 / 延 / 吞 四选一
- **可替换**：将来若引入更细的发牌度量（如基于用户响应历史），可整文件替换，不影响节奏与元 doctrine
- **可复用**：每次任何 agent / hook / gate 要输出给用户时都复用

四判断自评：独立 ✅ / 定位 ✅ / 替换 ✅ / 复用 ✅。

---

## 与其他 doctrine 的关系

- `cadence-doctrine.md`：cadence 是上游总开关（"此时能发吗"），deal-card 是下游过滤器（"这张够格吗"）。
- `meta-unit-doctrine.md`：发牌的发起者必须是合格元；非元不得发牌。
- `ux-response-doctrine.md`：UX 语气规范在发牌形态之上施加额外约束（用户可见语气）。该 doctrine 在 B2.1 中由三份前身 UX 文档（语气规范 / 首次使用与控制 / 任务类型模板）合并而成，成为单一治理入口。
- `meta-governance-layer.md`：意图层 / 闸门层 / 验证层都受发牌三判断约束。
