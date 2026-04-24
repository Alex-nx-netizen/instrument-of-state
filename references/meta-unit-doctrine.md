# 元 (Meta-Unit) Doctrine — 元的五特征与四判断

> **来源**：飞书文档《元：从混沌许愿到系统治理》（作者：老金）。
> **定位**：本治理体系的"最小构件法度"。任何被当作独立单元（agent、skill、contract 节点、reference 文档、hook）发布或调用的对象，必须通过本 doctrine 的自检，否则属于未成熟构件。
> **版本**：v0.6.0 首版（随 Meta Reforge docket `2026-04-23-meta-reforge` 落地）

---

## 什么是元

**元**（meta-unit）是本插件的最小可治理构件。它不是一个文件类型，也不是一个目录，而是一种资格：**凡能独立被引用、独立被调用、独立被替换的单元，都必须是元**。

在本插件里，"元"的典型实例：

- 一个 agent（如 `review-agent`）
- 一个 skill（如 `deliver`）
- 一个 reference doctrine（如本文件）
- `workflow-contract.json` 里的一个顶级节点（如 `skipPolicy`）
- `hooks.json` 里的一个 hook 触发器

**元不是**：一段临时胶水代码、一个未命名的中间变量、一个"反正只在这里用一次"的字面量。凡没有名字、没有独立文件/节、没有职责陈述的东西，都不是元，不适用本 doctrine。

---

## 五特征

本节以**中文版**给出完整表述（English mirror 在下文独立小节）。

元必须同时具备以下五项特征：

1. **独立**：能单独说清它负责什么，不依赖其它元的内部细节才能理解。
2. **足够小**：再往下拆的收益开始变低，继续拆只会增加协调成本而不增加清晰度。
3. **边界清晰**：职责范围有明确边线，不与邻近元串味；输入输出契约可写下来。
4. **可替换**：用同契约的另一个实现替换它，系统仍能运转；替换不是"把整个系统拖死"的灾难。
5. **可复用**：下次遇到相近任务时，它能被再次引用；不是一次性脚手架。

**注意**：
- 五项之间有张力。"足够小"与"可复用"可能互相挤压——过小则复用成本上升，过大则边界模糊。本 doctrine 不给机械公式，而是通过"四判断"让作者承担权衡。
- 五特征的体现必须可被旁人核查，不能只存在于作者脑中。

## Five Traits

The English mirror of the same doctrine, for use by verify regex checks and for non-Chinese readers.

A meta-unit MUST satisfy all five traits simultaneously:

1. **Independent** — it can be explained on its own terms without leaking the internals of neighboring units.
2. **Small enough** — further decomposition produces diminishing returns; splitting further raises coordination cost without raising clarity.
3. **Well-bounded** — its responsibility has a sharp edge; its input/output contract can be written down.
4. **Replaceable** — swapping it for another implementation against the same contract must not "bring the whole system down"; replacement is a survivable operation.
5. **Reusable** — when a similar task appears again, this unit can be referenced again; it is not disposable scaffolding.

These traits are in tension. "Small enough" and "Reusable" pull in opposite directions. This doctrine does not offer a mechanical formula — the author bears the weighting via the Four Checks below.

---

## 四判断

"四判断"是把五特征转化为可问答题目的工具。任何被声明为元的构件，作者必须就地回答这四问；答不出或答得含糊，就不是成熟的元。

### 判断 1 — 独立陈述检查
> 单独拿出来，能不能说清它负责什么？

若回答需要先解释另外一个元的上下文，则本元不独立。本判断对应**五特征 · 独立**。

### 判断 2 — 定位检查
> 出问题时，能不能定位到它？

若故障现象无法归因到本元（现象散落在多处而没有归属人），则本元的边界未收拢。本判断对应**五特征 · 边界清晰**。

### 判断 3 — 替换代价检查
> 想替换它时，会不会把整个系统一起拖死？

若替换要求同时改动多个不相关的元、要求停机、要求重写契约，则本元与邻居耦合过紧。本判断对应**五特征 · 可替换**。

### 判断 4 — 复用检查
> 下次遇到相近任务时，它能不能复用？

若本元写死了当次任务的特殊参数，无法用于相近的另一场景，则本元不成熟。本判断对应**五特征 · 可复用**。

**评级约定**：
- 前两问（独立 + 定位）答不出 → **还不是元**：拒绝入库，退回 draft 阶段重写。
- 后两问（替换 + 复用）答不出 → **还不够成熟**：允许入库但标 `maturity: low`，并记录到 `memory/` 作为 capability-gap。
- 四问全过 → **合格元**：正常注册。

## Four Checks

English mirror of the same four questions (required by verify regex):

### Check 1 — Independence
> Taken on its own, can you state what it is responsible for?

If the answer requires loading another meta-unit's context first, this unit is not independent. Maps to **Trait · Independent**.

### Check 2 — Diagnosability
> When something breaks, can you pin the failure on it?

If the symptom cannot be attributed to this unit (symptoms scatter across multiple units with no clear owner), the boundary is not tight. Maps to **Trait · Well-bounded**.

### Check 3 — Replacement Cost
> If you wanted to replace it, would it drag the whole system down?

If replacing it demands simultaneous edits across multiple unrelated units, forces downtime, or requires rewriting contracts, this unit is over-coupled. Maps to **Trait · Replaceable**.

### Check 4 — Reuse Eligibility
> When a similar task appears again, can it be reused?

If this unit hard-codes the specific parameters of one occasion and cannot serve a neighboring occasion, it is not yet mature. Maps to **Trait · Reusable**.

**Grading convention**:
- First two checks fail → **not yet a meta-unit**: reject, return to the draft stage.
- Last two checks fail → **immature meta-unit**: admit with `maturity: low` tag; log into `memory/` as capability-gap.
- All four pass → **qualified meta-unit**: register normally.

---

## 合格性示例

以下示例演示如何把本 doctrine 用在现有构件上。

### 示例 A — `review-agent`（合格的元）

| 判断 | 回答 |
|---|---|
| 独立 | 是。职责陈述："对 memorial 出 4 选 1 裁决（APPROVE / CONDITIONAL / RETURN / REJECT）"；不需要先理解 deliver 的内部即可说清 |
| 定位 | 是。凡"审查阶段被错误放行/错误拦截"的故障都归属 review |
| 替换代价 | 可控。若换一个"审查官"实现，只要仍按 `review-verdict-card.md` 模板出卡，上游 deliver 无需改动 |
| 复用 | 高。每个 docket 都复用它 |

结论：四问全过，合格元。

### 示例 B — `publish`（作为 skill 是合格的元）

**作为独立权力中心时**：独立性不足——它的职责（发消息）其实是 publish（宣示/礼部）部的一个具体触点；把它列为独立官署会让"权力中心"与"执行工具"串味。判断 1 不通过。

**作为 skill 时**：独立性回归——它是 publish 部麾下的执行工具，职责陈述清晰（"把 publication packet 推到飞书"），边界是"飞书 API 调用"这一层。四问全过。

v0.7.0 命名统一后，`publish` 作为本部 skill 明确归属本部署，不再被任何文档表述为独立权力中心。

### 示例 C — 合并前的 `personnel-routing` 与 `revenue-budgeting`（各自都不成熟）

**独立分开时**：
- 判断 4（复用）：实际任务中"派谁干"与"给多少预算"几乎从未单独出现，总是成对出现 → 两个 agent 各自的"下次复用"都只是对方的半截
- 判断 3（替换）：替换任一方时，另一方的引用必然同时修改

结论：两问不过 → 还不够成熟，应合并为 `allocate`。本 docket §4.1-8 即此合并动作。

### 示例 D — 假想反例：`temp-docstring-fixer` skill

假设有人建议新建一个 skill 专门修复某次 review 发现的文档字符串错别字。

| 判断 | 回答 |
|---|---|
| 独立 | 勉强——"修一次错字" |
| 定位 | 勉强 |
| 替换代价 | 低 |
| 复用 | **不过**——下次遇到别的错字，这个 skill 没有参数化机制可用 |

结论：判断 4 不过 → 不是成熟元。正确做法是不新建 skill，直接 inline 修复；或合并到已有的 `refactor-cleaner` 能力中。

---

## 与治理链条的绑定

- **Draft（起草）**：每次新建 agent / skill / reference 时，必须在文件开头或 frontmatter 注明已过四判断（可用"Meta-Unit Self-Check"小节）。
- **Review（审议）**：在 verdict-card 里加一行"四判断复核："，对作者的自检结果出意见。
- **Verify（验收）**：在可证伪清单中新增一条"所有新建元具备 Meta-Unit Self-Check 小节"（未来 docket 追加）。
- **evolution-writeback**：判断 3 或判断 4 失败但仍入库的元，必须写回 `memory/` 作为 `capability-gap`，供下次回顾时纳入合并候选。

---

## 与其他 doctrine 的关系

- `cadence-doctrine.md`：元是"被编排的单位"，节奏是"编排的方式"。节奏四态（发牌/留白/跳过/插队）作用于元之间的切换。
- `deal-card-doctrine.md`：发牌的三判断决定了何时把某个元暴露给用户；本 doctrine 决定了哪些单元有资格被发牌。
- `constitutional-rules.md`：宪法规定了元的"组织镜像"——分工/升级路径/复核点/兜底点。
- `meta-governance-layer.md`：意图层/闸门层/验证层三个隐层，每一层都只由合格元构成。

---

## 附：Meta-Unit Self-Check 模板

建议所有新建元文件（agent.md / SKILL.md / doctrine.md）在开头贴一份：

```markdown
## Meta-Unit Self-Check

- **独立**：[一句话职责陈述]
- **足够小**：[再拆的反例或拆分临界点]
- **边界清晰**：[输入] → [输出]；不处理：[邻居职责列表]
- **可替换**：[替换同契约实现的路径]
- **可复用**：[已复用场景 / 预期复用场景]

四判断自评：独立 ✅ / 定位 ✅ / 替换 ✅ / 复用 ✅（或标记未过项）
```

本 doctrine 本身即为一个元，其 self-check 如下：

- **独立**：定义"什么构件有资格被当作元"
- **足够小**：只做资格审查，不涉及节奏与发牌
- **边界清晰**：输入 = 任意待审构件声明；输出 = 合格/不合格/不成熟 三态判定
- **可替换**：若将来有更成熟的"元合格性"理论出现，可以整文件替换，不影响节奏与发牌 doctrine
- **可复用**：每个新 docket 里所有新增构件都会复用本 doctrine

四判断自评：独立 ✅ / 定位 ✅ / 替换 ✅ / 复用 ✅。
