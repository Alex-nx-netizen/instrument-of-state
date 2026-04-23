# Task Plan — Meta Reforge (思想重塑 v0.6.0)

**Docket:** `2026-04-23-meta-reforge`
**Opened:** 2026-04-23
**Petitioner:** 黄聪
**Route:** `/agent-teams-playbook` → governance (Zhongshu → Menxia → Works)
**Scope class:** Substantial, multi-ministry, public-ready required
**Version target:** `0.6.0` (breaking-doctrine change, invitations for renames)

---

## 1. 请愿与意图（raw petition）

> 把飞书文档《元：从混沌许愿到系统治理》的核心思想融入插件；插件目前"使用起来不明确，不知道在干什么、不知道用了哪些东西，执行起来看不到用了什么"；且"没有用到主流思想"。

**已锁定的三个关键决策（用户已确认）：**

| 锚点 | 用户选择 | 含义 |
|---|---|---|
| 方向 | C — 思想重塑 | 以"元/组织镜像/节奏/意图 + 发牌"为顶层轴线彻底重组 doctrine；三省六部可作为外显隐喻保留，但不再是内核 |
| 命名 | 允许改名，包括 `zhongshu` 这类调用方式 | 采用语义命名为主入口，古风隐喻作为学习侧辅助 |
| 冗杂定义 | **可见性**才是核心 | 用户不满的不是"文件多"，而是"黑盒：不知道用了哪个 skill / hook / gate"——这是最高优先级 |

---

## 2. 源文档主线（必须显式落地）

来源：飞书文档 `IJSKdSyGVoBPvdx0R4rch483nTf`《元：从混沌许愿到系统治理》。

主线：**元 → 组织镜像 → 节奏编排 → 意图放大**；外加**发牌**作为节奏的核心能力。

| 概念 | 必须显式出现的形式 |
|---|---|
| 元（五特征） | 一份 `meta-unit-doctrine.md`；每个 agent / skill 的定义必须过"五特征 + 四判断"自检 |
| 组织镜像 | 宪章文档必须写"分工 / 升级路径 / 复核点 / 兜底点"四件事 |
| 节奏（发牌 / 留白 / 跳过 / 插队） | 新 `cadence-doctrine.md`；workflow-contract 增补 `skipPolicy` + `preemptPolicy` |
| 发牌（三判断） | 新 `deal-card-doctrine.md`：减少不确定性 / 提高下一步清晰度 / 不过度打断 |
| 意图放大 | 升级 `intentPacket`：强制"谁做 / 何时 / 触点 / 成功指标 / 调优路径"五字段 |

---

## 3. 调研结论摘要（数据见 findings.md）

**A. References：** 当前 20 份文件，可合并为 **~11 份** + 新增 **3 份新 doctrine**（meta / cadence / deal-card）→ 最终约 **14 份**，但层级更清晰。

**B. Agents：** 9 → **8**（`personnel-routing` + `revenue-budgeting` 合并为 `resource-allocator`）；`publish-to-lark` 从 agent 级降为 rites 的执行 skill。

**C. 节奏四态自评：** 发牌 7/10 / 留白 6/10 / **跳过 2/10** / **插队 3/10**——跳过和插队缺失严重。

**D. 可见性评估：** 契约/hook/guard 完备 ⭐⭐⭐⭐⭐；可见性 ⭐（用户只能知道"被拦了"，看不到"当前 stage / 已用 skill / 剩余未解锁 gate"）。**这是本次改造的头号痛点。**

---

## 4. Scope Lock

### In-scope（本次必做）

1. **新增 3 份主线 doctrine**：meta-unit / cadence / deal-card
2. **References 合并**：20 → 11，删除过度特化的小文档
3. **Agent/Skill 精简与改名**：
   - 合并 `personnel-routing` + `revenue-budgeting` → `resource-allocator`
   - 降级 `publish-to-lark` 为 rites 的 skill（不再作为 agent 身份）
   - 新增语义命名主入口：`/iostate:draft|review|dispatch|deliver|verify|publish|allocate|emergency`
   - 旧的古风命名（`/instrument-of-state:zhongshu-draft` 等）保留一版做兼容映射，在下一个大版本移除
4. **可见性三件套**：
   - 新 `stage-board` skill：输出当前 stage / gate 状态 / 已用 agent / 剩余未解锁
   - 新 `tool-trace` skill：回放本次 docket 从开启到现在调用过的所有 agent / skill / tool
   - SessionStart hook 增强：每次 Subagent 启停 / 进入 gate 时，向用户输出一行人话："现在在用 X，因为 Y"
5. **契约升级**：
   - `workflow-contract.json` 增加 `skipPolicy` 和 `preemptPolicy` 节点
   - `intentPacket` schema 升级为五字段（owner / when / touchpoint / success / adjust-path）
6. **Plugin 元信息**：
   - `.claude-plugin/plugin.json` 与 `marketplace.json` 版本统一为 `0.6.0`
   - description 更新反映思想重塑
7. **README 双语重写**：把新主线摆到顶部；工具箱清单明示（解决"不知道用了啥"）

### Out-of-scope（本次不做）

- 不重写 PowerShell guard 脚本核心逻辑（只加新钩子）
- 不改变 HMAC 状态文件格式（向后兼容）
- 不做自动化测试框架搭建（后续版本）
- 不删除 `memory/` 下的 writeback 体系（保留）

---

## 5. Ministry Dispatch 计划

| Ministry | 是否参与 | 任务 |
|---|---|---|
| Zhongshu（起草） | ✅ | 本文件 + memorial + 所有新 doctrine 初稿 |
| Menxia（审查） | ✅ | 审 memorial；审每批落地前的变更清单 |
| Justice-Compliance（验收） | ✅ | 定义验收标准（见 §7），验收每批落地 |
| Works-Delivery（执行） | ✅ | 所有文件变更（分 6 批） |
| Rites-Protocol（发布规范） | ✅ 轻参与 | README 发布风格、版本说明文档样式 |
| War-Operations（应急） | ⏸ 备用 | 若过程中 guard 被破坏需紧急修复 |
| Resource-Allocator（新合并） | ✅ | 本次改造自身就包含它的合并——它既是工具也是对象 |

---

## 6. 分批落地计划（6 batches）

每批结束后走一次"小验证 + 用户短确认"，再进下一批。

| Batch | 内容 | 变更面 | 风险 |
|---|---|---|---|
| **B1** | 新增 3 份 doctrine（meta/cadence/deal-card）；`task_plan` + `findings` + `progress` 已落地 | 仅新增 references，不动其他 | 低 |
| **B2** | References 合并：UX 三合一、Lark 三合一、宪章整理；删除 `superpowers-integration.md`（内容迁入各 agent 定义） | 改动 6~8 份现有文件 | 中（改动范围大，靠 git diff 兜底） |
| **B3** | Agent/Skill 改名与合并：建 `resource-allocator`，删 personnel + revenue；`publish-to-lark` 从 agent 降为 skill；新语义命名 skill 建立 | 创建 + 删除 + 改 plugin 注册 | 中高（改了调用入口，需保留旧别名） |
| **B4** | 可见性三件套：`stage-board` skill + `tool-trace` skill + SessionStart hook 人话输出 | 新建 2 个 skill + 增强 1 个 hook | 中（hook 改动需在 Windows 下验证） |
| **B5** | 契约升级：`workflow-contract.json` 补 `skipPolicy`/`preemptPolicy`；`intentPacket` 升级五字段；guard 联动 | 契约文件 + guard 脚本微调 | 中高（契约是权威，动它要 Menxia 二次审） |
| **B6** | Plugin 元信息统一到 0.6.0；README 双语重写；顶部明示工具箱 | plugin.json + marketplace.json + README × 2 | 低 |

---

## 7. 验收标准（Justice-Compliance 使用）

可量化的通过条件：

| # | 条件 | 量化指标 |
|---|---|---|
| V1 | references 数量砍到合理范围 | 20 → ≤14（含 3 份新 doctrine） |
| V2 | 主流思想可见 | `meta-unit-doctrine.md` / `cadence-doctrine.md` / `deal-card-doctrine.md` 三份新文件齐备，每份含五特征 / 四态 / 三判断的显式小节 |
| V3 | Agent/Skill 清单收敛 | agents 9→8；`publish-to-lark` 不再列为 agent 身份 |
| V4 | 可见性达标 | `stage-board` 与 `tool-trace` 两个 skill 可运行；SessionStart 输出的上下文明示"本会话可用的 agent/skill 清单" |
| V5 | 契约层节奏补齐 | workflow-contract.json 含 `skipPolicy` 与 `preemptPolicy` 顶级字段；JSON 可被 guard 解析不报错 |
| V6 | 版本号一致 | plugin.json / marketplace.json 均为 `0.6.0` |
| V7 | 治理不破 | 所有 gate 仍能阻止非法操作；`hooks.json` 语法有效；SessionStart 可正常注入上下文 |
| V8 | 文档可读性 | README 顶部能在 30 秒内回答"这个插件是什么 / 有哪些工具 / 什么时候用"三个问题 |

---

## 8. Rollback Posture

每批单独提交一个 commit，commit message 前缀 `reforge(Bn):`；任何一批验收不过则 `git revert` 该批次；不做 `reset --hard`。

---

## 9. Errors Encountered

| # | 阶段 | 问题 | 解决 |
|---|---|---|---|
| — | — | — | — |

（空：执行中遇到错误在此登记）

---

## 10. 阶段追踪

| Stage | 状态 | 开始 | 完成 | 备注 |
|---|---|---|---|---|
| Docket 开启 | ✅ | 2026-04-23 | 2026-04-23 | 本文件 |
| 调研 | ✅ | 2026-04-23 | 2026-04-23 | 3 个 Explore agent，见 findings.md |
| Zhongshu memorial | 🔄 进行中 | 2026-04-23 | — | 起草中 |
| 用户审查 memorial | ⏸ | — | — | 等 memorial 就绪 |
| Menxia 审查 | ⏸ | — | — | 等用户批准 |
| Works Delivery B1 | ⏸ | — | — | 等 Menxia APPROVE |
| … B2~B6 | ⏸ | — | — | 依次 |
| Justice 验收 | ⏸ | — | — | — |
| 汇总报告 | ⏸ | — | — | — |
