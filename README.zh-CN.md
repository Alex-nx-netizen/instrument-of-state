<div align="center">

# 国之重器 / Instrument of State

[![English](https://img.shields.io/badge/Docs-English-1f6feb?style=for-the-badge)](./README.md)
[![中文文档](https://img.shields.io/badge/Docs-%E4%B8%AD%E6%96%87-0f766e?style=for-the-badge)](./README.zh-CN.md)

**先起草，再审校，再执行；先验明，再宣示。**

![插件](https://img.shields.io/badge/Claude_Code-Plugin-1f6feb?style=flat-square)
![流程](https://img.shields.io/badge/Workflow-14%20Stages-0f766e?style=flat-square)
![Agents](https://img.shields.io/badge/Agents-9-7c3aed?style=flat-square)
![Skills](https://img.shields.io/badge/Skills-10-2563eb?style=flat-square)
![Hooks](https://img.shields.io/badge/Hooks-Guarded-c2410c?style=flat-square)
![Lark](https://img.shields.io/badge/Lark-Ready-0891b2?style=flat-square)

<img src="./assets/readme/hero.svg" alt="Instrument of State hero" width="820" />

</div>

---

## 它在解决什么问题

很多 AI 编码流程会把复杂任务压缩成一次无门禁的直线动作：

- 先猜用户意图
- 一边想一边规划
- 直接动手实现
- 最后顺手宣布完成

这种方式在真实仓库里很脆弱，尤其是一旦涉及多文件改动、跨角色协作、风险控制、审核验收和正式发布，问题就会迅速放大。

---

## 这个项目是什么

`instrument-of-state` 是一个 **Claude Code 插件套件**，不是单个 skill。

它保留了“三省六部”的对外工作流，同时把更“元”的治理思想吸收到内部骨架里：

- 中书省起草 memorial
- 门下省审校并放行或阻断执行
- 尚书省调度正确的部门
- 工部未获批不得落地
- “能执行”与“能公开宣示”分成两个闸门
- 重要运行结果可以落成 run artifact，并把有价值的经验写回 memory

换句话说，它现在是：

- **前台**：朝廷式、可见的治理流程
- **后台**：协议化、状态化、可审计、可沉淀的元治理内核

---

## 双层架构

### 对外：朝廷工作流

用户主要看到的是：

`下旨 -> 承旨 -> 侦缉 -> 起草 -> 审校 -> 发令 -> 六部 -> 回呈 -> 宣示`

### 对内：元治理骨架

内部现在有几层关键机制：

- 执行前先锁定意图
- 用隐藏状态跟踪 gate，而不是只靠文案描述
- 对外宣示前增加 `public-ready` 闸门
- 用 run artifact 持久化 packet 链
- 用 `memory/` 和模板体系做演化写回
- 用 `contracts/workflow-contract.json` 把协议规则结构化

项目不是把“三省六部”推翻重来，而是把它变得更严谨、更可验证。

---

## 朝廷流程

| 阶段 | 官署 | 作用 |
| --- | --- | --- |
| 1 | 皇上下旨 | 用户提交请示 |
| 2 | 太子承旨 | 判断模式、范围与是否升级治理 |
| 3 | 锦衣卫侦缉 | 开卷立案、勘察证据、搜索能力 |
| 4 | 中书省 | 起草 memorial，并锁定意图 |
| 5 | 门下省 | 审校 memorial，并决定是否放行执行 |
| 6 | 尚书省 | 调度正确的部门 |
| 7 | 六部 | 只执行真正需要的部分 |
| 8 | 奏折回呈 | 汇总执行、校验与收口 |
| 9 | 礼部宣示 | 仅在合法时发布到 Lark / 飞书 |

<div align="center">
  <img src="./assets/readme/workflow.svg" alt="Imperial workflow diagram" width="920" />
</div>

---

## 快速安装

```text
/plugin marketplace add Dick1109/instrument-of-state
/plugin install instrument-of-state
```

然后运行主流程：

```text
/instrument-of-state:shangshu-dispatch 重构 auth 模块，并保持可视化阶段看板。
```

---

## 主命令

| 命令 | 用途 |
| --- | --- |
| `/instrument-of-state:shangshu-dispatch <任务>` | 主入口，启动完整治理流程 |

示例：

```text
/instrument-of-state:shangshu-dispatch 调查登录故障，先稳住生产，再准备正式交接说明。
/instrument-of-state:shangshu-dispatch 重做 pricing 页面，要求风格鲜明并保持可访问性。
/instrument-of-state:shangshu-dispatch 审核发布清单，并发布飞书交接文档。
```

---

## 插件里有什么

| 组件 | 作用 |
| --- | --- |
| `skills/` | `shangshu-dispatch`、`zhongshu-draft`、`menxia-review`、`works-delivery`、`publish-to-lark` 等核心流程技能 |
| `agents/` | 尚书省、中书省、门下省、刑部、工部、礼部等执行角色 |
| `hooks/` | 守卫机制，例如“门下未批准，工部不得落地” |
| `bin/` | guard 与 marketplace 辅助脚本 |
| `contracts/` | 协议合同层，定义 packet、gate、rollback、`public-ready` 规则 |
| `artifacts/runs/` | 运行工件层，复杂任务可把完整 packet 链落成 JSON 归档 |
| `memory/` | 演化写回层，沉淀 patterns、scars、能力缺口与调度经验 |
| `memory/templates/` | 可直接复制使用的写回模板，覆盖 pattern、scar、dispatch、writeback packet |
| `references/` | 宪法、治理手册、工作流说明、发布协议、run artifact 协议、元治理说明 |
| `.claude-plugin/plugin.json` | 插件清单 |
| `.claude-plugin/marketplace.json` | marketplace 清单 |

---

## 能力地图

### 目录分层图

| 层级 | 目录 | 在系统中的职责 | 在治理链中的位置 |
| --- | --- | --- | --- |
| 插件入口层 | `/.claude-plugin` | 定义插件身份、安装入口与 marketplace 元数据 | 会话/安装入口 |
| 官署定义层 | `/agents` | 定义各官署与 agent 的角色边界 | 对应朝廷各官署 |
| 技能执行层 | `/skills` | 定义可执行的工作流行为 | 驱动可见治理流程 |
| 守卫运行层 | `/bin` | 跟踪状态、执行 gate、阻断违规工具调用 | 硬门禁执行层 |
| Hook 接线层 | `/hooks` | 把 Claude 生命周期事件接到守卫 | 会话开始、子代理开始/结束、工具调用前 |
| 合同层 | `/contracts` | 定义 packet、state、gate、rollback、writeback 规则 | 隐藏元治理骨架 |
| 运行工件层 | `/artifacts/runs` | 把 governed run 落成可审计的 JSON 工件 | 重大任务的 packet 链闭合层 |
| 记忆层 | `/memory` | 存储 patterns、scars、dispatch lessons、capability gaps | 演化写回层 |
| 写回模板层 | `/memory/templates` | 提供可直接复用的写回模板 | 写回执行支撑层 |
| 制度文档层 | `/references` | 宪法、治理手册、发布协议、run artifact 协议 | 为所有阶段提供规则依据 |
| 展示资源层 | `/assets` | README 视觉资源与辅助素材 | 仅展示，不参与治理 |

### 技能与官署图

| 技能 | 官署 | 主要职责 | 在治理链中的位置 | 主要影响的 packet / gate |
| --- | --- | --- | --- | --- |
| `shangshu-dispatch` | 尚书省 | 统筹整条 governed run 与最终收口 | Intake、Dispatch、Integration、Close-out | `dispatchPacket`、`summaryPacket`、`writebackPacket` |
| `zhongshu-draft` | 中书省 | 起草 memorial 并锁定意图 | Draft | `intentPacket`、`intentGatePacket`、`memorialPacket` |
| `menxia-review` | 门下省 | 审校 memorial 并决定执行权限 | Review | `reviewPacket`、`menxia_review_ready`、`works_delivery_unlock` |
| `works-delivery` | 工部 | 执行已批准的实现工作 | Delivery | 写权限、证据输入 |
| `justice-compliance` | 刑部 | 定义或校验证据、测试、验收门 | Verification | `verificationPacket`、`public_ready` |
| `rites-protocol` | 礼部 | 设计文书格式与对外沟通路径 | Publication planning | `publicationPacket`、`lark_publication` |
| `publish-to-lark` | 礼部执行器 | 执行文档、权限、IM 发送链 | Publication execution | `publicationPacket`、`public_ready` 证明链 |
| `personnel-routing` | 吏部 | 设计 owner、分工与协作路径 | Dispatch support | owner assignments |
| `revenue-budgeting` | 户部 | 评估成本、范围与依赖压力 | Strict mode support | dispatch shaping |
| `war-operations` | 兵部 | 处理故障、回滚姿态与应急调度 | Emergency mode | rollback posture |

### Gate 图

| Gate | 来源 | 满足条件 | 阻断什么 |
| --- | --- | --- | --- |
| `menxia_review_ready` | `workflow-contract.json` | 已有 `intentPacket`、`intentGatePacket`、`memorialPacket` | 没有正式 memorial 就不能审 |
| `works_delivery_unlock` | 合同 + 守卫 | `reviewPacket.verdict == APPROVE` | 工部 agent 启动、文件写入、变更命令 |
| 非工部写入门 | `instrument-guard.ps1` | 只有 planning artifacts 是例外 | 非工部角色写文件 |
| `intent_locked` | 守卫状态 | 中书省输出了意图相关章节 | 在意图未锁定时重执行 |
| `public_ready` | 合同层 | 验证通过、汇总闭合、交付物完整、交付链闭合、结果可整合对外说明 | 对外宣示与发布资格 |
| `lark_publication` | 合同层 | `public_ready` 成立，且有明确发布证据与权限准备 | 直接进入发布链 |
| Lark IM 通知门 | 守卫运行层 | 最新 run artifact 证明 `publicReady` 且含 `publicReadyEvidence` | `lark-cli im +messages-send` |
| `writebackDecision` | 制度层 + 模板层 | 明确给出 `writeback` 或 `none` | 草率或无沉淀的收口 |

---

## 核心特性

- **可视化阶段看板**：首屏和收口显示完整 `Imperial Stage Board`，中途改用紧凑进度摘要
- **意图锁定**：重大任务在重执行前先沉淀 `intentPacket` 和 `intentGatePacket`
- **强制审批后落地**：门下省未 `APPROVE`，工部不能写文件
- **Run Artifact**：治理型任务可把完整 packet 链持久化，而不只留在对话里
- **公开就绪闸门**：代码改完不等于可以直接对外宣示或发布
- **发布硬门禁**：`publish-to-lark` 需要明确的 `public-ready` 证据，守卫还能拦截不安全的 Lark IM 发送
- **本地优先能力搜索**：本地 skills/plugins -> 全局 agents -> `find-skills` -> marketplace
- **礼部发布链**：可生成文档、授权、发 IM、归档 Wiki
- **演化写回**：可把有价值的模式、疤痕、调度经验、能力缺口写回到 `memory/`
- **前端治理**：界面任务按能力阶梯动态发现最合适的前端工具

---

## Run Artifact

对于重大、风险高、涉及多部门、或者需要对外发布的任务，项目现在支持治理运行工件：

- 模板：`contracts/run-artifact.template.json`
- 协议：`references/run-artifact-protocol.md`
- 建议存放：`artifacts/runs/<YYYY-MM-DD>-<slug>.json`

它可以记录：

- `intentPacket`
- `intentGatePacket`
- `memorialPacket`
- `reviewPacket`
- `dispatchPacket`
- `verificationPacket`
- `summaryPacket`
- `publicationPacket`
- `writebackPacket`

这样一来，隐藏的元治理链条不再只存在于聊天记录里，而是可以被审计、复盘、复用。

---

## 礼部宣示 / Lark 发布

当任务需要正式沟通时，礼部可以：

1. 创建文档
2. 授权访问
3. 发送 IM
4. 归档到 Wiki

现在这里多了一层严格的 `public-ready` 判断，用来区分：

- 已获准执行
- 已完成实现但仍待校验
- 已经具备对外宣示条件

`publish-to-lark` 会优先使用 run artifact 作为证明来源；如果最新运行工件不能证明 `public-ready` 已闭合，守卫可以直接阻断 `lark-cli im +messages-send`。

<div align="center">
  <img src="./assets/readme/publication-chain.svg" alt="Lark publication chain" width="920" />
</div>

---

## Memory 与写回模板

项目现在把“演化写回”从抽象规则变成了可直接操作的模板体系。

可以直接使用：

- `memory/templates/pattern-template.md`
- `memory/templates/scar-template.md`
- `memory/templates/dispatch-pattern-template.md`
- `memory/templates/capability-gap-entry-template.md`
- `memory/templates/writeback-packet.template.json`

这让每次重要运行后的知识沉淀更稳定，也更容易复用。

---

## 前端规则

凡是 UI 相关任务，这个插件要求两类能力同时具备：

- **UX 结构能力**：可访问性、响应式、布局逻辑、交互质量
- **视觉设计能力**：视觉方向、字体、构图、动效、避免通用 AI 风格

这些能力通过能力阶梯动态发现，而不是把 skill 名字硬编码死。

---

## 参考文档

- [English README](./README.md)
- [宪法规则](./references/constitutional-rules.md)
- [治理手册](./references/governance-playbook.md)
- [朝廷工作流](./references/imperial-workflow.md)
- [元治理层](./references/meta-governance-layer.md)
- [演化写回](./references/evolution-writeback.md)
- [Run Artifact Protocol](./references/run-artifact-protocol.md)
- [Lark Publication Protocol](./references/lark-publication-protocol.md)
- [前端治理](./references/frontend-governance.md)
- [Workflow Contract](./contracts/workflow-contract.json)
- [Run Artifact Template](./contracts/run-artifact.template.json)

---

<div align="center">
为可治理、可见、可宣示、可审计、可沉淀的 Claude Code 执行流程而生。
</div>
