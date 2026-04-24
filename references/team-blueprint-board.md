# 团队蓝图

当 `dispatch` 技能准备用户可见的回复时，除了朝政进度清单，还必须展示团队蓝图表。

团队蓝图与朝政进度互补：

- 朝政进度：说明流程走到了哪一步（纵向时间线）
- 团队蓝图：说明谁在做什么、用什么能力（横向组织图）

## 蓝图格式

使用 markdown 表格，固定列顺序：

```
| # | 角色名 | 具体职责 | 模型 | Agent 类型 | 调用方式 | 当前状态 |
|---|--------|---------|------|-----------|---------|---------|
```

列定义：

1. `#`：从 1 开始的序号
2. `角色名`：官署中文名 + 人话别名，例如 `尚书省（调度执行）`
3. `具体职责`：本次任务中该角色的具体职责描述
4. `模型`：`opus` / `sonnet` / `haiku`
5. `Agent 类型`：实际调用的 agent subagent_type，例如 `dispatch-agent`、`Code Reviewer`、`Security Engineer`
6. `调用方式`：`Skill: skill-name` 表示通过 Skill 调用，`Type: subagent-type` 表示通过 Agent 类型调用
7. `当前状态`：该角色在本次任务中的状态

## 状态标记

使用以下中文状态词：

- `执行中`：该角色正在工作
- `等待中`：该角色尚未开始，等待前置角色完成
- `等待联动`：该角色已就绪，等待上游输出后启动
- `已完成`：该角色已完成本次任务
- `已跳过`：该角色本次任务不需要
- `待命`：该角色已分配但尚未进入工作队列
- `已阻塞`：该角色因前置条件未满足无法推进

## 模型分配规则

内置官署的默认模型分配：

| 官署 | 默认模型 | 理由 |
|------|---------|------|
| dispatch（调度 / 尚书省） | opus | 总调度，需要最深推理 |
| draft（起草 / 中书省） | sonnet | 结构化起草 |
| review（审校 / 门下省） | sonnet | 独立审查 |
| deliver（交付 / 工部） | sonnet | 代码实现 |
| verify（验证 / 刑部） | sonnet | 验证验收 |
| emergency（应急 / 兵部） | sonnet | 应急处理 |
| allocate（资源调度） | haiku | 分工与成本评估（两种模式） |
| publish（宣示 / 礼部） | haiku | 文档协议 |

全局 Agent 的模型分配根据任务复杂度决定：

- `opus`：架构设计、深度分析、复杂重构
- `sonnet`：标准实现、调试、审查
- `haiku`：快速查找、轻量扫描、简单检查

## 展示节奏

与朝政进度保持一致的展示节奏：

1. 完整蓝图：
   - 首个实质性回复：完整列出所有参与角色
   - 里程碑跃迁：当角色状态发生变化时
   - 最终收口：展示所有角色的最终状态
2. 简报蓝图：
   - 中间过程更新：只列出状态发生变化的角色
   - 不重复展示未变化的角色

## 完整蓝图模板

```md
## 团队蓝图

| # | 角色名 | 具体职责 | 模型 | Agent 类型 | 调用方式 | 当前状态 |
|---|--------|---------|------|-----------|---------|---------|
| 1 | dispatch（调度执行） | 总调度、流程管控与最终整合 | opus | dispatch-agent | Skill: dispatch | 执行中 |
| 2 | draft（起草方案） | 将请示转化为正式奏折 | sonnet | draft-agent | Skill: draft | 等待中 |
| 3 | review（审校裁决） | 独立审查奏折并作出裁决 | sonnet | review-agent | Skill: review | 等待联动 |
| 4 | deliver（代码执行） | 执行代码实现与交付 | sonnet | deliver-agent | Skill: deliver | 已阻塞 |
| 5 | verify（验证/验收） | 定义测试门槛与合规边界 | sonnet | verify-agent | Skill: verify | 等待中 |
| 6 | allocate（分工/成本） | 分工与成本评估（两种模式按需触发） | haiku | allocate-agent | Skill: allocate | 等待中 |
| 7 | publish（文档/发布） | 正式文档与发布仪式 | haiku | publish-agent | Skill: publish | 等待中 |
| 8 | emergency（应急/故障） | 本案非紧急事件 | sonnet | emergency-agent | Skill: emergency | 已跳过 |
```

## 含全局 Agent 增援的蓝图模板

当任务涉及专业领域且用户配置了全局 Agent 时，蓝图中应体现增援角色：

```md
## 团队蓝图

| # | 角色名 | 具体职责 | 模型 | Agent 类型 | 调用方式 | 当前状态 |
|---|--------|---------|------|-----------|---------|---------|
| 1 | dispatch（调度执行） | 总调度与流程管控 | opus | dispatch-agent | Skill: dispatch | 执行中 |
| 2 | draft（起草方案） | 起草前端重构方案 | sonnet | draft-agent | Skill: draft | 已完成 |
| 3 | review（审校裁决） | 审查重构方案合理性 | sonnet | review-agent | Skill: review | 已完成 |
| 4 | deliver（代码执行） | 前端组件重构实现 | sonnet | deliver-agent | Skill: deliver | 执行中 |
| 5 | deliver 增援·前端专家 | React 组件与性能优化 | sonnet | Frontend Developer | Type: Frontend Developer | 等待联动 |
| 6 | deliver 增援·架构师 | 系统架构与模块边界设计 | opus | Backend Architect | Type: Backend Architect | 已完成 |
| 7 | verify（验证/验收） | 测试覆盖与验收门槛 | sonnet | verify-agent | Skill: verify | 等待中 |
| 8 | verify 增援·安全工程师 | 安全审查与漏洞扫描 | sonnet | Security Engineer | Type: Security Engineer | 待命 |
| 9 | verify 增援·代码审查 | 代码质量与最佳实践审查 | sonnet | Code Reviewer | Type: Code Reviewer | 待命 |
```

## 简报蓝图模板

中间过程更新时只列出状态有变化的角色：

```md
## 团队蓝图（更新）

| # | 角色名 | 当前状态 | 变化说明 |
|---|--------|---------|---------|
| 2 | draft（起草方案） | 已完成 | 奏折已提交 |
| 3 | review（审校裁决） | 执行中 | 正在审查奏折 |
| 4 | deliver（代码执行） | 等待联动 | 等待审校裁决 |
```

## 规则

1. 团队蓝图必须紧跟朝政进度之后展示。
2. 首个实质性回复必须展示完整蓝图，列出所有已确定参与的角色。
3. 不需要的角色标记为"已跳过"并简要说明原因。
4. 全局 Agent 增援角色的命名格式为：`<所属部门>增援·<角色简称>`。
5. Agent 类型必须填写实际的 subagent_type 值，确保可执行。
6. 调用方式中：`Skill: name` 表示通过内置 Skill 调用；`Type: name` 表示通过 Agent subagent_type 调用全局 Agent。
7. 模型分配应根据实际任务复杂度调整，不机械套用默认值。
8. 当全局 Agent 被检测到且与任务相关时，必须在蓝图中体现，即使最终未实际调用也应标记为"待命"或"已跳过"。
9. 蓝图中的状态必须与朝政进度中对应阶段的状态一致。
10. 所有蓝图内容使用中文，Agent 类型和 Skill 名称保留英文原名（因需要精确匹配调用）。

## 语言规则

蓝图表格中的中文列（角色名、具体职责、当前状态）使用中文。Agent 类型和调用方式列保留英文原名，因为这些是技术标识符，需要精确匹配才能正确调用。
