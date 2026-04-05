# 全局 Agent 路由

本文件定义 `instrument-of-state` 如何检测并集成用户在 `~/.claude/agents/` 目录下配置的全局 Agent。

## 核心原则

1. 全局 Agent 是增援力量，不替代内置官署。
2. 检测到全局 Agent 时优先使用，而非退化到泛用 agent。
3. 按关键词匹配将全局 Agent 路由到对应部门。
4. 团队蓝图中必须体现已检测到的全局 Agent 增援。

## 检测协议

在太子承旨或锦衣卫侦察阶段，执行以下检测：

1. 检查 `~/.claude/agents/` 目录是否存在。
2. 如果存在，扫描其子目录结构：
   - `academic/` — 学术领域专家
   - `design/` — 设计与 UX 专家
   - `engineering/` — 工程实现专家
   - `game-development/` — 游戏开发专家
   - `marketing/` — 营销与增长专家
   - `paid-media/` — 付费媒体专家
   - `product/` — 产品管理专家
   - `project-management/` — 项目管理专家
   - `sales/` — 销售策略专家
   - `spatial-computing/` — 空间计算专家
   - `specialized/` — 专业领域专家
   - `support/` — 运营支持专家
   - `testing/` — 测试与验证专家
   - `strategy/` — 策略与文档
3. 读取每个 agent 文件的 YAML frontmatter，获取 `name` 字段作为 `subagent_type` 值。
4. 根据任务内容和下方的关键词路由表，确定哪些全局 Agent 与本次任务相关。
5. 将相关 Agent 纳入团队蓝图并分配到对应部门。

## 目录到部门的映射

| 全局 Agent 目录 | 主要映射部门 | 次要映射部门 |
|----------------|-------------|-------------|
| `engineering/` | 工部（代码执行） | 刑部（验证/验收） |
| `testing/` | 刑部（验证/验收） | — |
| `design/` | 工部（代码执行） | 礼部（文档/发布） |
| `product/` | 中书省（起草方案） | 吏部（分工/责任） |
| `project-management/` | 吏部（分工/责任） | 户部（成本/范围） |
| `sales/` | 礼部（文档/发布） | — |
| `marketing/` | 礼部（文档/发布） | — |
| `paid-media/` | 礼部（文档/发布） | 户部（成本/范围） |
| `support/` | 户部（成本/范围） | 礼部（文档/发布） |
| `specialized/` | 按具体 agent 判断 | — |
| `academic/` | 中书省（起草方案） | — |
| `spatial-computing/` | 工部（代码执行） | — |
| `game-development/` | 工部（代码执行） | — |

## 关键词路由表

### 工部（代码执行）增援

以下关键词触发工部增援 Agent 的候选：

| 关键词 | 全局 Agent 文件 | Agent Name (subagent_type) |
|--------|----------------|--------------------------|
| frontend, react, vue, angular, css, component, 前端, 组件 | `engineering/engineering-frontend-developer.md` | `Frontend Developer` |
| backend, api, server, microservice, 后端, 服务端 | `engineering/engineering-backend-architect.md` | `Backend Architect` |
| mobile, ios, android, flutter, react native, 移动端 | `engineering/engineering-mobile-app-builder.md` | `Mobile App Builder` |
| database, sql, query, index, 数据库, 查询优化 | `engineering/engineering-database-optimizer.md` | `Database Optimizer` |
| devops, ci/cd, pipeline, docker, kubernetes, deploy, 部署 | `engineering/engineering-devops-automator.md` | `DevOps Automator` |
| architecture, system design, scalability, 架构, 系统设计 | `engineering/engineering-software-architect.md` | `Software Architect` |
| full-stack, complex feature, senior, 全栈 | `engineering/engineering-senior-developer.md` | `Senior Developer` |
| prototype, mvp, poc, 原型, 快速验证 | `engineering/engineering-rapid-prototyper.md` | `Rapid Prototyper` |
| cms, wordpress, drupal, 内容管理 | `engineering/engineering-cms-developer.md` | `CMS Developer` |
| ml, ai, machine learning, model, 机器学习, 模型 | `engineering/engineering-ai-engineer.md` | `AI Engineer` |
| solidity, smart contract, blockchain, ethereum, 智能合约 | `engineering/engineering-solidity-smart-contract-engineer.md` | `Solidity Smart Contract Engineer` |
| embedded, firmware, iot, hardware, 嵌入式, 固件 | `engineering/engineering-embedded-firmware-engineer.md` | `Embedded Firmware Engineer` |
| wechat, mini program, 微信, 小程序 | `engineering/engineering-wechat-mini-program-developer.md` | `WeChat Mini Program Developer` |
| feishu, lark, 飞书 | `engineering/engineering-feishu-integration-developer.md` | `Feishu Integration Developer` |
| git, branch, merge, rebase, commit, 版本控制 | `engineering/engineering-git-workflow-master.md` | `Git Workflow Master` |
| data pipeline, etl, spark, 数据管道 | `engineering/engineering-data-engineer.md` | `Data Engineer` |
| email, smtp, deliverability, 邮件 | `engineering/engineering-email-intelligence-engineer.md` | `Email Intelligence Engineer` |

### 刑部（验证/验收）增援

| 关键词 | 全局 Agent 文件 | Agent Name (subagent_type) |
|--------|----------------|--------------------------|
| security, vulnerability, threat, owasp, auth, 安全 | `engineering/engineering-security-engineer.md` | `Security Engineer` |
| accessibility, wcag, a11y, screen reader, 无障碍 | `testing/testing-accessibility-auditor.md` | `Accessibility Auditor` |
| evidence, proof, screenshot, 证据, 截图 | `testing/testing-evidence-collector.md` | `Evidence Collector` |
| verify, validate, production ready, 验证, 生产就绪 | `testing/testing-reality-checker.md` | `Reality Checker` |
| api test, endpoint test, integration test, 接口测试 | `testing/testing-api-tester.md` | `API Tester` |
| performance, benchmark, load test, 性能, 压测 | `testing/testing-performance-benchmarker.md` | `Performance Benchmarker` |
| test results, coverage, metrics, 测试结果, 覆盖率 | `testing/testing-test-results-analyzer.md` | `Test Results Analyzer` |
| compliance, soc2, iso, hipaa, pci, 合规 | `specialized/compliance-auditor.md` | `Compliance Auditor` |
| smart contract audit, blockchain security, 合约审计 | `specialized/blockchain-security-auditor.md` | `Blockchain Security Auditor` |
| code review, 代码审查 | `engineering/engineering-code-reviewer.md` | `Code Reviewer` |
| threat detection, siem, 威胁检测 | `engineering/engineering-threat-detection-engineer.md` | `Threat Detection Engineer` |

### 吏部（分工/责任）增援

| 关键词 | 全局 Agent 文件 | Agent Name (subagent_type) |
|--------|----------------|--------------------------|
| project, task, sprint, kanban, 项目管理 | `project-management/` 下的相关 agent | 按文件 name 字段 |
| hire, recruit, talent, 招聘, 人才 | `specialized/recruitment-specialist.md` | `Recruitment Specialist` |
| jira, workflow, issue tracking | `project-management/` 下的 jira 相关 agent | `Jira Workflow Steward` |

### 户部（成本/范围）增援

| 关键词 | 全局 Agent 文件 | Agent Name (subagent_type) |
|--------|----------------|--------------------------|
| finance, budget, expense, cost, 财务, 预算 | `support/` 下的 finance 相关 agent | `Finance Tracker` |
| priority, sprint, backlog, 优先级 | `product/product-sprint-prioritizer.md` | `Sprint Prioritizer` |
| analytics, metrics, data, 数据分析 | `support/` 下的 analytics 相关 agent | `Analytics Reporter` |
| supply chain, procurement, 供应链 | `specialized/supply-chain-strategist.md` | `Supply Chain Strategist` |

### 礼部（文档/发布）增援

| 关键词 | 全局 Agent 文件 | Agent Name (subagent_type) |
|--------|----------------|--------------------------|
| documentation, docs, api docs, readme, 文档 | `engineering/engineering-technical-writer.md` | `Technical Writer` |
| pdf, document, report, generate, 报告生成 | `specialized/specialized-document-generator.md` | `Document Generator` |
| summary, executive, brief, 摘要 | `support/` 下的 summary 相关 agent | `Executive Summary Generator` |
| content, article, blog, 内容创作 | `marketing/` 下的 content 相关 agent | 按文件 name 字段 |
| brand, visual identity, 品牌 | `design/` 下的 brand 相关 agent | `Brand Guardian` |
| ui design, visual design, 界面设计 | `design/` 下的 ui 相关 agent | `UI Designer` |

### 兵部（应急/故障）增援

| 关键词 | 全局 Agent 文件 | Agent Name (subagent_type) |
|--------|----------------|--------------------------|
| incident, outage, p0, p1, 故障, 宕机 | `engineering/engineering-incident-response-commander.md` | `Incident Response Commander` |
| sre, reliability, observability, monitoring, 可靠性 | `engineering/engineering-sre.md` | `SRE (Site Reliability Engineer)` |
| deploy, rollback, ci/cd, 部署回滚 | `engineering/engineering-devops-automator.md` | `DevOps Automator` |

### 中书省（起草方案）增援

| 关键词 | 全局 Agent 文件 | Agent Name (subagent_type) |
|--------|----------------|--------------------------|
| prd, product, roadmap, 产品需求 | `product/product-manager.md` | `Product Manager` |
| research, trend, market, 市场研究 | `product/product-trend-researcher.md` | `Trend Researcher` |
| user feedback, user research, 用户反馈 | `product/product-feedback-synthesizer.md` | `Feedback Synthesizer` |
| workflow, process, 工作流 | `specialized/specialized-workflow-architect.md` | `Workflow Architect` |
| ux, usability, 用户体验 | `design/` 下的 ux 相关 agent | `UX Researcher` 或 `UX Architect` |

### 特殊领域增援（按需路由）

| 关键词 | 全局 Agent 文件 | Agent Name (subagent_type) | 建议部门 |
|--------|----------------|--------------------------|---------|
| mcp, model context protocol | `specialized/specialized-mcp-builder.md` | `MCP Builder` | 工部 |
| salesforce, crm | `specialized/specialized-salesforce-architect.md` | `Salesforce Architect` | 工部 |
| game, unity, unreal, godot, roblox | `game-development/` 下的相关 agent | 按文件 name 字段 | 工部 |
| visionos, xr, ar, vr, spatial | `spatial-computing/` 下的相关 agent | 按文件 name 字段 | 工部 |
| civil engineering, 土木工程 | `specialized/specialized-civil-engineer.md` | `Civil Engineer` | 工部 |
| legal, compliance, 法律合规 | `support/` 下的 legal 相关 agent | `Legal Compliance Checker` | 刑部 |
| infrastructure, 基础设施 | `support/` 下的 infra 相关 agent | `Infrastructure Maintainer` | 兵部 |
| customer support, 客户支持 | `support/` 下的 support 相关 agent | `Support Responder` | 礼部 |
| automation, n8n, 自动化 | `specialized/automation-governance-architect.md` | `Automation Governance Architect` | 工部 |
| blockchain, web3, 区块链 | `specialized/blockchain-security-auditor.md` | `Blockchain Security Auditor` | 刑部 |

## 调用优先级

当任务涉及专业领域时，能力调度遵循以下优先级：

1. **全局 Agent**（`~/.claude/agents/`）：用户已配置的专业 Agent，优先使用
2. **内置官署 Agent**（本插件 `agents/`）：治理流程的核心角色，不可替代
3. **内置 Skill**（本插件 `skills/`）：治理流程的核心能力
4. **会话中已加载的外部 Skill**：当前会话可用的外部能力
5. **find-skills 发现的外部 Skill**：按需发现的外部能力
6. **泛用 Agent**（`general-purpose`）：无专业 Agent 匹配时的兜底

注意：全局 Agent 优先于泛用 Agent，但不替代内置官署。例如：

- 工部仍然负责治理流程中的文件写入授权
- 全局 `Frontend Developer` 作为工部增援，在工部框架内执行前端实现
- 全局 `Security Engineer` 作为刑部增援，在刑部框架内执行安全审查

## 增援调用方式

### 通过 Agent 工具调用全局 Agent

```
Agent(
  subagent_type = "<Agent Name from frontmatter>",
  model = "<opus|sonnet|haiku>",
  prompt = "<task description>"
)
```

示例：

```
Agent(
  subagent_type = "Frontend Developer",
  model = "sonnet",
  prompt = "Implement the React component refactoring as specified in the approved memorial..."
)
```

### 增援角色在团队蓝图中的命名

格式：`<所属部门>增援·<角色简称>`

示例：
- `工部增援·前端专家`
- `刑部增援·安全工程师`
- `刑部增援·代码审查`
- `礼部增援·技术文档`
- `户部增援·财务分析`

## 运行时检测流程

在 shangshu-dispatch 的太子承旨阶段，执行以下步骤：

1. 使用 `Glob` 检查 `~/.claude/agents/` 是否存在且非空。
2. 如果存在，扫描子目录获取 agent 文件列表。
3. 分析当前请示的关键词，与上方路由表匹配。
4. 对匹配到的 agent，读取其 YAML frontmatter 获取准确的 `name` 字段。
5. 将匹配结果记录到团队蓝图中。
6. 在能力调度章节说明检测到了哪些全局 Agent、实际使用了哪些、为什么选择或跳过。

## 无全局 Agent 时的降级

如果用户没有配置 `~/.claude/agents/` 目录，或目录为空：

1. 团队蓝图只展示内置官署角色。
2. 不显示任何增援行。
3. 能力调度章节说明"未检测到全局 Agent 配置，使用内置官署执行"。
4. 仍然按正常治理流程执行。

## 注意事项

1. 全局 Agent 是增援力量，它们在对应部门的治理框架内工作，不独立行使治理权。
2. 一个全局 Agent 可能同时映射到多个部门（例如 DevOps Automator 可映射到工部和兵部），按实际任务需求决定归属。
3. 关键词匹配应综合判断请示内容、奏折目标和各部职责，避免机械匹配。
4. 当检测到相关全局 Agent 但实际不需要时，在蓝图中标记为"待命"而非直接省略，让用户知道该能力可用。
5. 全局 Agent 的 `name` 字段是精确的调用标识，必须从文件 frontmatter 中读取，不可猜测。
