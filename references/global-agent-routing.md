# 全局 Agent 路由

本文件定义 `iostate` 插件如何检测并集成用户在 `~/.claude/agents/` 目录下配置的全局 Agent。

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
| `engineering/` | deliver（代码执行） | verify（验证/验收） |
| `testing/` | verify（验证/验收） | — |
| `design/` | deliver（代码执行） | publish（文档/发布） |
| `product/` | draft（起草方案） | allocate（分工/责任） |
| `project-management/` | allocate（分工/责任） | allocate（成本/范围） |
| `sales/` | publish（文档/发布） | — |
| `marketing/` | publish（文档/发布） | — |
| `paid-media/` | publish（文档/发布） | allocate（成本/范围） |
| `support/` | allocate（成本/范围） | publish（文档/发布） |
| `specialized/` | 按具体 agent 判断 | — |
| `academic/` | draft（起草方案） | — |
| `spatial-computing/` | 工部（代码执行） | — |
| `game-development/` | 工部（代码执行） | — |

## 关键词路由表

### 工部（代码执行）增援

以下关键词触发工部增援 Agent 的候选：

| 关键词 | 全局 Agent 文件 | Agent Name (subagent_type) |
|--------|----------------|--------------------------|
| frontend, react, vue, angular, svelte, solid, next, nuxt, remix, astro, gatsby, vite, webpack, rollup, esbuild, css, scss, sass, less, tailwind, styled-components, emotion, css-in-js, component, widget, layout, responsive, UI, 前端, 组件, 页面, 界面, 样式, 布局, 响应式, 交互, 动画, 表单, 路由, 状态管理, 渲染, SSR, CSR, SSG, hydration, DOM, virtual DOM, JSX, TSX, HTML, 模板 | `engineering/engineering-frontend-developer.md` | `Frontend Developer` |
| backend, api, server, microservice, REST, GraphQL, gRPC, WebSocket, middleware, controller, service, repository, ORM, endpoint, route, handler, authentication, authorization, JWT, OAuth, session, cache, Redis, message queue, RabbitMQ, Kafka, Spring, Django, Express, FastAPI, NestJS, Laravel, Rails, Gin, Echo, Fiber, 后端, 服务端, 接口, 中间件, 控制器, 路由, 鉴权, 缓存, 消息队列 | `engineering/engineering-backend-architect.md` | `Backend Architect` |
| mobile, ios, android, flutter, react native, swift, kotlin, SwiftUI, Jetpack Compose, Xcode, Android Studio, APK, IPA, App Store, Google Play, push notification, deep link, 移动端, 移动应用, 手机, 安卓, 苹果 | `engineering/engineering-mobile-app-builder.md` | `Mobile App Builder` |
| database, sql, query, index, PostgreSQL, MySQL, MongoDB, SQLite, Oracle, DynamoDB, Supabase, PlanetScale, migration, schema, table, column, join, aggregate, transaction, connection pool, 数据库, 查询优化, 索引, 表结构, 迁移, 事务 | `engineering/engineering-database-optimizer.md` | `Database Optimizer` |
| devops, ci/cd, pipeline, docker, kubernetes, deploy, terraform, ansible, nginx, AWS, GCP, Azure, CloudFlare, Vercel, Netlify, GitHub Actions, GitLab CI, Jenkins, ArgoCD, Helm, 部署, 运维, 容器, 编排, 云服务, 自动化部署 | `engineering/engineering-devops-automator.md` | `DevOps Automator` |
| architecture, system design, scalability, distributed, microservice architecture, DDD, domain-driven, event-driven, CQRS, saga, service mesh, load balancing, high availability, fault tolerance, 架构, 系统设计, 分布式, 可扩展, 高可用, 领域驱动 | `engineering/engineering-software-architect.md` | `Software Architect` |
| full-stack, complex feature, senior, refactor, large-scale, cross-cutting, 全栈, 重构, 复杂功能 | `engineering/engineering-senior-developer.md` | `Senior Developer` |
| prototype, mvp, poc, proof of concept, demo, hackathon, spike, 原型, 快速验证, 概念验证, 最小可行产品 | `engineering/engineering-rapid-prototyper.md` | `Rapid Prototyper` |
| cms, wordpress, drupal, strapi, contentful, headless CMS, 内容管理 | `engineering/engineering-cms-developer.md` | `CMS Developer` |
| ml, ai, machine learning, deep learning, model, neural network, training, inference, LLM, NLP, computer vision, PyTorch, TensorFlow, 机器学习, 模型, 深度学习, 人工智能, 训练, 推理 | `engineering/engineering-ai-engineer.md` | `AI Engineer` |
| solidity, smart contract, blockchain, ethereum, web3, DeFi, NFT, ERC-20, ERC-721, hardhat, foundry, 智能合约, 区块链 | `engineering/engineering-solidity-smart-contract-engineer.md` | `Solidity Smart Contract Engineer` |
| embedded, firmware, iot, hardware, ESP32, Arduino, STM32, RTOS, PlatformIO, sensor, 嵌入式, 固件, 物联网 | `engineering/engineering-embedded-firmware-engineer.md` | `Embedded Firmware Engineer` |
| wechat, mini program, 微信, 小程序, WXML, WXSS, 微信支付, 公众号 | `engineering/engineering-wechat-mini-program-developer.md` | `WeChat Mini Program Developer` |
| feishu, lark, 飞书, 飞书机器人, 飞书审批, 多维表格 | `engineering/engineering-feishu-integration-developer.md` | `Feishu Integration Developer` |
| git, branch, merge, rebase, commit, cherry-pick, stash, worktree, conflict, 版本控制, 分支管理, 合并冲突 | `engineering/engineering-git-workflow-master.md` | `Git Workflow Master` |
| data pipeline, etl, elt, spark, dbt, Airflow, data warehouse, data lake, lakehouse, BigQuery, Snowflake, Redshift, 数据管道, 数据仓库, 数据湖, 数据治理 | `engineering/engineering-data-engineer.md` | `Data Engineer` |
| email, smtp, deliverability, IMAP, 邮件, 邮件发送 | `engineering/engineering-email-intelligence-engineer.md` | `Email Intelligence Engineer` |

### 刑部（验证/验收）增援

| 关键词 | 全局 Agent 文件 | Agent Name (subagent_type) |
|--------|----------------|--------------------------|
| security, vulnerability, threat, owasp, auth, XSS, CSRF, SQL injection, SSRF, RCE, CVE, pentest, penetration, encryption, TLS, SSL, certificate, secret, credential, token, 安全, 漏洞, 渗透, 注入, 加密, 认证, 授权 | `engineering/engineering-security-engineer.md` | `Security Engineer` |
| accessibility, wcag, a11y, screen reader, aria, keyboard navigation, contrast, focus, alt text, 无障碍, 可访问性, 键盘导航, 对比度 | `testing/testing-accessibility-auditor.md` | `Accessibility Auditor` |
| evidence, proof, screenshot, visual test, 证据, 截图, 视觉验证 | `testing/testing-evidence-collector.md` | `Evidence Collector` |
| verify, validate, production ready, sanity check, smoke test, 验证, 生产就绪, 上线检查 | `testing/testing-reality-checker.md` | `Reality Checker` |
| api test, endpoint test, integration test, contract test, Postman, 接口测试, 集成测试, 契约测试 | `testing/testing-api-tester.md` | `API Tester` |
| performance, benchmark, load test, stress test, latency, throughput, profiling, flame graph, 性能, 压测, 负载测试, 延迟, 吞吐量 | `testing/testing-performance-benchmarker.md` | `Performance Benchmarker` |
| test results, coverage, metrics, regression, flaky test, 测试结果, 覆盖率, 回归测试 | `testing/testing-test-results-analyzer.md` | `Test Results Analyzer` |
| compliance, soc2, iso, hipaa, pci, gdpr, ccpa, audit, 合规, 审计, 数据保护 | `specialized/compliance-auditor.md` | `Compliance Auditor` |
| smart contract audit, blockchain security, 合约审计 | `specialized/blockchain-security-auditor.md` | `Blockchain Security Auditor` |
| code review, pull request review, PR review, code quality, lint, 代码审查, 代码质量, 代码评审 | `engineering/engineering-code-reviewer.md` | `Code Reviewer` |
| threat detection, siem, detection rule, sigma, yara, 威胁检测, 告警规则 | `engineering/engineering-threat-detection-engineer.md` | `Threat Detection Engineer` |

### 吏部（分工/责任）增援

| 关键词 | 全局 Agent 文件 | Agent Name (subagent_type) |
|--------|----------------|--------------------------|
| project, task, sprint, kanban, scrum, agile, backlog, story, epic, milestone, 项目管理, 任务管理, 迭代, 排期 | `project-management/` 下的相关 agent | 按文件 name 字段 |
| hire, recruit, talent, headcount, onboarding, JD, 招聘, 人才, 入职 | `specialized/recruitment-specialist.md` | `Recruitment Specialist` |
| jira, workflow, issue tracking, ticket, board, 工单, 看板 | `project-management/` 下的 jira 相关 agent | `Jira Workflow Steward` |

### 户部（成本/范围）增援

| 关键词 | 全局 Agent 文件 | Agent Name (subagent_type) |
|--------|----------------|--------------------------|
| finance, budget, expense, cost, revenue, pricing, billing, invoice, ROI, TCO, 财务, 预算, 成本, 费用, 收入, 定价 | `support/` 下的 finance 相关 agent | `Finance Tracker` |
| priority, sprint, backlog, capacity, velocity, estimation, sizing, story point, 优先级, 容量, 估算, 排序 | `product/product-sprint-prioritizer.md` | `Sprint Prioritizer` |
| analytics, metrics, data, dashboard, KPI, OKR, funnel, conversion, retention, 数据分析, 仪表盘, 指标, 转化率 | `support/` 下的 analytics 相关 agent | `Analytics Reporter` |
| supply chain, procurement, logistics, inventory, warehouse, 供应链, 采购, 物流, 库存 | `specialized/supply-chain-strategist.md` | `Supply Chain Strategist` |

### 礼部（文档/发布）增援

| 关键词 | 全局 Agent 文件 | Agent Name (subagent_type) |
|--------|----------------|--------------------------|
| documentation, docs, api docs, readme, changelog, guide, tutorial, reference, JSDoc, Swagger, OpenAPI, 文档, 说明文档, 接口文档, 使用指南 | `engineering/engineering-technical-writer.md` | `Technical Writer` |
| pdf, document, report, generate, export, 报告生成, 导出, 报表 | `specialized/specialized-document-generator.md` | `Document Generator` |
| summary, executive, brief, digest, 摘要, 总结, 简报 | `support/` 下的 summary 相关 agent | `Executive Summary Generator` |
| content, article, blog, newsletter, copywriting, 内容创作, 文章, 博客, 文案 | `marketing/` 下的 content 相关 agent | 按文件 name 字段 |
| brand, visual identity, brand guideline, logo, 品牌, 视觉识别, 品牌规范 | `design/` 下的 brand 相关 agent | `Brand Guardian` |
| ui design, visual design, mockup, wireframe, design system, Figma, sketch, 界面设计, 视觉设计, 设计系统, 原型图, 线框图 | `design/` 下的 ui 相关 agent | `UI Designer` |

### 兵部（应急/故障）增援

| 关键词 | 全局 Agent 文件 | Agent Name (subagent_type) |
|--------|----------------|--------------------------|
| incident, outage, p0, p1, downtime, error spike, 5xx, 故障, 宕机, 线上问题, 生产事故 | `engineering/engineering-incident-response-commander.md` | `Incident Response Commander` |
| sre, reliability, observability, monitoring, alerting, Grafana, Prometheus, Datadog, SLO, SLI, error budget, 可靠性, 可观测性, 监控, 告警 | `engineering/engineering-sre.md` | `SRE (Site Reliability Engineer)` |
| deploy, rollback, ci/cd, release, canary, blue-green, 部署回滚, 灰度发布, 蓝绿部署 | `engineering/engineering-devops-automator.md` | `DevOps Automator` |

### 中书省（起草方案）增援

| 关键词 | 全局 Agent 文件 | Agent Name (subagent_type) |
|--------|----------------|--------------------------|
| prd, product, roadmap, feature, requirement, spec, user story, acceptance criteria, 产品需求, 需求文档, 产品规划, 路线图 | `product/product-manager.md` | `Product Manager` |
| research, trend, market, competitive analysis, industry, benchmark, 市场研究, 竞品分析, 行业趋势 | `product/product-trend-researcher.md` | `Trend Researcher` |
| user feedback, user research, survey, interview, NPS, satisfaction, persona, 用户反馈, 用户调研, 用户画像, 满意度 | `product/product-feedback-synthesizer.md` | `Feedback Synthesizer` |
| workflow, process, automation, pipeline design, 工作流, 流程设计, 流程优化 | `specialized/specialized-workflow-architect.md` | `Workflow Architect` |
| ux, usability, user experience, information architecture, user journey, interaction design, heuristic, 用户体验, 可用性, 交互设计, 信息架构, 用户旅程 | `design/` 下的 ux 相关 agent | `UX Researcher` 或 `UX Architect` |

### 特殊领域增援（按需路由）

| 关键词 | 全局 Agent 文件 | Agent Name (subagent_type) | 建议部门 |
|--------|----------------|--------------------------|---------|
| mcp, model context protocol, tool server, 工具服务 | `specialized/specialized-mcp-builder.md` | `MCP Builder` | 工部 |
| salesforce, crm, HubSpot, 客户关系管理 | `specialized/specialized-salesforce-architect.md` | `Salesforce Architect` | 工部 |
| game, unity, unreal, godot, roblox, game loop, sprite, physics, 游戏, 游戏开发 | `game-development/` 下的相关 agent | 按文件 name 字段 | 工部 |
| visionos, xr, ar, vr, spatial, mixed reality, 空间计算, 混合现实 | `spatial-computing/` 下的相关 agent | 按文件 name 字段 | 工部 |
| civil engineering, structural, 土木工程, 结构设计 | `specialized/specialized-civil-engineer.md` | `Civil Engineer` | 工部 |
| legal, compliance, regulation, privacy policy, terms of service, 法律合规, 隐私政策, 条款 | `support/` 下的 legal 相关 agent | `Legal Compliance Checker` | 刑部 |
| infrastructure, server, cluster, CDN, DNS, load balancer, 基础设施, 服务器, 集群 | `support/` 下的 infra 相关 agent | `Infrastructure Maintainer` | 兵部 |
| customer support, helpdesk, ticket, FAQ, 客户支持, 工单, 帮助中心 | `support/` 下的 support 相关 agent | `Support Responder` | 礼部 |
| automation, n8n, Zapier, Make, workflow automation, 自动化, 流程自动化 | `specialized/automation-governance-architect.md` | `Automation Governance Architect` | 工部 |
| blockchain, web3, DApp, 区块链, 去中心化 | `specialized/blockchain-security-auditor.md` | `Blockchain Security Auditor` | 刑部 |

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
- `deliver 增援·前端专家`
- `verify 增援·安全工程师`
- `verify 增援·代码审查`
- `publish 增援·技术文档`
- `allocate 增援·财务分析`

## 运行时检测流程

在 dispatch 技能的意图承接阶段，执行以下步骤：

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
2. 一个全局 Agent 可能同时映射到多个部门（例如 DevOps Automator 可映射到 deliver 和 emergency），按实际任务需求决定归属。
3. 关键词匹配应综合判断请示内容、奏折目标和各部职责，避免机械匹配。
4. 当检测到相关全局 Agent 但实际不需要时，在蓝图中标记为"待命"而非直接省略，让用户知道该能力可用。
5. 全局 Agent 的 `name` 字段是精确的调用标识，必须从文件 frontmatter 中读取，不可猜测。
