# Lark 发布 Doctrine — 协议 / 执行序列 / 模板

> **定位**：本 doctrine 治理 `iostate` 插件面向飞书（Lark / Feishu）的一切外部发布行为，包括判定是否发布、如何落地文档、如何授权、如何通知、以及何时降级。凡是要把本插件的产物推出到飞书这个"国家公报"通道上的动作，都在本 doctrine 的管辖范围内。
> **版本**：v0.6.0 首版（随 Meta Reforge docket `2026-04-23-meta-reforge` 合并 `lark-publication-protocol` + `lark-publication-runbook` + `lark-publication-templates` 三文而成）
> **合宪位**：publish（宣示/礼部）承担执行；dispatch（调度）承担路由判定；review（审校）仍是发布前的批准前置。本 doctrine 不绕过审校、验证、公开闸门律。

---

## 本 doctrine 治理什么

飞书/Lark 是本插件的**国家发布与通知通道**。任何跨团队交接、对外宣示、发布说明、事件公告、治理留档、或用户明确点名要飞书送达的场景，都属于本 doctrine 的管辖。

本 doctrine 同时回答三个问题：

1. **协议**（Section A）—— 什么时候该发、什么时候不该发、发什么样的形态。
2. **执行序列**（Section B）—— 真要发了，按什么顺序调哪些 `lark-cli` 能力，什么条件下降级。
3. **模板**（Section C）—— 文稿标题怎么起、正文骨架长什么样、IM 通知写几行、公开闸门证据块怎么落。

三者缺一不可：光有协议没有执行序列会导致"说了要发但没人知道怎么发"；光有执行序列没有模板会导致每次落稿形态漂移；光有模板没有协议会导致在不该发的时候也发。

---

## Section A — 发布协议

### 何时启用本 doctrine

以下任一成立时，即启用本 doctrine：

- 用户显式要求飞书/Lark 输出
- 工作需要跨团队交接或干系人通知
- 奏折（memorial）要求正式摘要、发布公告、事件公告、或治理留档
- 任务运行在 `Strict` 或 `Emergency` 模式下且需要制度化发布

此时把 Lark 当作本插件的**国家发布与通知系统**。

### 可用的国家仪器

当前会话若暴露以下本地 skill，则它们是首选的发布栈：

- `lark-doc`
- `lark-drive`
- `lark-im`
- `lark-contact`
- `lark-wiki`

如环境未暴露这些 skill，按 Section B §降级规则 处理。

### 发布序列（高阶）

1. 判定本次是**强制发布**、**可选发布**、还是**显式请求发布**
2. 核查结果是否已经通过公开闸门（public-ready gate）
3. 在执行 `PUBLISH_NOW` 之前，必须已有显式的公开闸门证据
4. 解析收件人与所有者
5. 用 `lark-doc` 创建主文档
6. 用 `lark-drive` 授予合适的权限
7. 用 `lark-im` 发送通知
8. 若该产物是长期制度性知识，用 `lark-wiki` 镜像或归档

### 公开闸门律（public-ready law）

**不能只因为实现存在就向外发布。**

外部发布仅在以下条件同时为真时为合法：

- 验证已通过（verification passed）
- 汇总已闭合（summary closed）
- 保留有唯一主交付物
- 交付链闭合
- 存在一个已合并的最终结果

首选的证据来源是一个受治理的 run artifact，且：

- `verificationPacket.verifyPassed == true`
- `summaryPacket.publicReady == true`
- `publicationPacket.publicReadyEvidence` 非空

若该证据缺失，则发布路径必须降级。可降级至：

- 仅规划文档（document-only planning）
- 只起草不通知的文档（document draft without notification）
- 显式跳过并给出原因（explicit skip with explanation）

### 自动发布触发条件

dispatch 通常应把发布视为必需，当：

- 用户明确要求飞书/Lark 送达
- 任务属于发布、事故、审计、交接、或治理总结
- 任务在 `Strict` 或 `Emergency` 模式且影响多个干系方
- 奏折明确要求干系人通知或制度留档

dispatch 通常应跳过发布，当任务完全本地化、无交接、无对外留档需要。

### 主文档必备内容

主发布正文通常应包含：

- 请愿或任务摘要
- 奏折摘要
- 门下裁决
- 已改变或决定的内容
- 证据、测试、或审校闸门
- 未决风险与下一步行动
- 相关所有者或收件人

### 权限律

**不得在未授权或未明示权限缺失的情况下把文档链接发出去。**

发送带文档链接的通知时，要么读者已被授权访问，要么消息显式声明访问权限仍待授予。

### 通知律

IM 消息不得只是一条裸链接。至少要包含：

- 文档是什么
- 为什么这位收件人会收到这条消息
- 最重要的结论或下一步动作

### 失败处理

如果 Lark 未配置或相关 skill 不可用：

- 不得伪造发布事实
- 应返回一份"发布计划"替代
- 并说明被卡在哪一步：身份解析、文档创建、权限、通知、或公开闸门闭合

### 合宪定位

Lark 发布由 dispatch 调度、由 publish 执行。
它**不得绕过**门下审校、刑部验证、以及本 doctrine 的公开闸门律。

---

## Section B — 执行序列（Runbook）

本节把协议转为可被 `publish-to-lark` 直接执行的操作序列。

### 前置条件

发布可被执行，仅当以下全部为真：

- 奏折、门下裁决、各部结果清晰可发
- 发布决策为 `PUBLISH_NOW` 或 `PUBLISH_DOC_ONLY`
- 收件人、消息用途、发送身份（bot 身份）要么显式、要么经奏折授权、要么用户直接要求
- 公开闸门证据显式存在

首选的公开闸门证据：

- 一个受治理的 run artifact，带 `summaryPacket.publicReady == true`
- `verificationPacket.verifyPassed == true`
- `publicationPacket.publicReadyEvidence` 非空

当身份解析、权限、或工具访问不全时，降级为 `PLAN_ONLY`。
当公开闸门证据不全时，降级为 `PLAN_ONLY` 或 `PUBLISH_DOC_ONLY`。

### 执行阶梯（依序执行）

#### 1. 解析发布决策

- `PUBLISH_NOW`：创建文档、授予权限、通知收件人
- `PUBLISH_DOC_ONLY`：创建文档、授予最小安全权限，但不发 IM
- `PLAN_ONLY`：返回精确计划与阻塞点
- `SKIP_PUBLICATION`：不做任何外部动作

选择 `PUBLISH_NOW` 前，必须确认公开闸门证据来源显式且完整。

#### 2. 解析收件人

- 若用户已直接给出 `open_id`，直接使用
- 若用户给的是姓名、邮箱、或部分标识符，先解析：

```bash
lark-cli contact +search-user --query "<name or email>"
```

- 若 bot 创建文档后还需当前操作人持续管理，解析当前操作人：

```bash
lark-cli contact +get-user
```

- 若多个可能收件人都匹配且奏折未消歧，降级为 `PUBLISH_DOC_ONLY` 或 `PLAN_ONLY`

#### 3. 创建主文档

用从奏折 / 裁决 / 各部结果 / 证据 / 风险 / 下一步推导出的标题与 markdown 正文创建文档：

```bash
lark-cli docs +create --title "<title>" --markdown "<markdown body>"
```

至少捕获：

- `doc_id`
- `doc_url`

若 wiki 节点或 wiki 空间是交付一部分，则改在 wiki 下创建：

```bash
lark-cli docs +create --title "<title>" --wiki-node <wiki_token> --markdown "<markdown body>"
```

#### 4. 通知前先授权

若文档是以 bot 身份创建的，且当前操作人身份可解析、奏折未禁止，则授予当前操作人 `full_access`。

再按访问矩阵授予收件人权限：

- 直接所有者或操作人：`full_access`
- 活跃协作者：`edit`
- 仅知悉型干系人：`view`

命令范式：

```bash
lark-cli drive permission.members create --as bot \
  --params '{"token":"<doc_id>","type":"docx"}' \
  --data '{"member_id":"<open_id>","member_type":"openid","type":"user","perm":"<view|edit|full_access>"}'
```

若某位收件人的授权失败，**不得**假装整体发布已成功。

#### 5. 确认访问安全后再发 IM

若决策为 `PUBLISH_NOW`，仅当以下之一为真时才发 IM：

- 授权已成功
- 消息本身明确说明访问权限仍待授予

首选直连消息范式：

```bash
lark-cli im +messages-send --as bot --user-id <open_id> --markdown "<message>"
```

群聊范式：

```bash
lark-cli im +messages-send --as bot --chat-id <chat_id> --markdown "<message>"
```

IM 必须包含：

- 文档是什么
- 收件人为什么会收到
- 主结论或请求的下一步动作
- 文档链接

#### 6. 必要时归档到 wiki

若本次收尾要成为制度性留档，则镜像或归置到约定的 wiki 位置。

有 `lark-wiki` 则调用；否则返回精确的 wiki 归置计划。

### 降级规则

出现以下任一情况时，从 `PUBLISH_NOW` 降级：

- 公开闸门证据缺失或不完整
- 收件人身份歧义
- 操作人无法判断 bot 身份是否可接受
- 授权失败且用户未授权"带警告发送"路径
- Lark 栈在当前环境不可用

降级目标：

- 文档已存在但通知尚不安全 → `PUBLISH_DOC_ONLY`
- 连文档都无法安全创建 → `PLAN_ONLY`

### 留痕要求

执行发生时，回报：

- 已解析的收件人
- 已授予的权限
- `doc_id`
- `doc_url`
- IM 发送时的消息 ID
- wiki 归档位置（如有）

不执行时，精确说出阻塞点，而不是声称发布成功。

---

## Section C — 模板

本节规定发布产物的文字形态。

### 发布决策矩阵

发布决策必须落在以下四值之一：

- `PUBLISH_NOW`：发布必需且收件人显式或可解析
- `PUBLISH_DOC_ONLY`：应出正式文稿，但收件人通知尚不安全或尚不够明确
- `PLAN_ONLY`：应走飞书发布，但身份 / 权限 / Lark 能力缺失
- `SKIP_PUBLICATION`：任务本地、私有、或被明确标为不需对外

**默认 `PUBLISH_NOW`**，当以下任一为真：

- 用户明确要求发送飞书/Lark 文档
- 用户明确要求在飞书/Lark 通知某人
- 任务处 `Strict` 或 `Emergency` 模式且涉及多个干系方
- 工作是发布、事故、交接、审计摘要、或治理留档

**默认 `PUBLISH_DOC_ONLY`**，当：

- 需要正式产物，但收件人未指明
- 收件人存在但身份尚未解析
- 结果尚未到 `PUBLISH_NOW` 所要求的 public-ready 强度

**默认 `SKIP_PUBLICATION`**，当：

- 任务完全本地且无交接或制度留档需要
- 用户明确说不通知或不发布

### 文档标题范式

- 任务总结：`State Dispatch | <short task name> | <YYYY-MM-DD>`
- 发布说明：`Release Dispatch | <service or feature> | <YYYY-MM-DD>`
- 事件公告：`Incident Bulletin | <incident name> | <YYYY-MM-DD>`
- 交接备忘：`Handoff Memorial | <workstream> | <YYYY-MM-DD>`

### 主文档骨架

首选以下结构：

```markdown
## Petition Summary

<one paragraph>

## Memorial Summary

- Objective: ...
- Scope: ...
- Mode: ...
- Ministries: ...

## Review Verdict

- Verdict: ...
- Conditions: ...

## Action Taken

- What was delivered, changed, decided, or stabilized

## Evidence and Gates

- Tests:
- Reviews:
- Security or compliance:

## Open Risks

- Residual risk 1
- Residual risk 2

## Next Actions

- Owner:
- Needed follow-up:
```

### 权限矩阵

奏折未明示例外时用以下默认：

- 直接责任所有者或当前操作人：`full_access`
- 需要编辑的活跃协作者：`edit`
- 只需知悉的干系人：`view`

wiki 发布时，除非奏折明确说明权限只限单页，默认使用 `perm_type: container`。

### IM 消息模板

IM 应短且决策导向：

```markdown
Published: <document title>
- Reason: <why they are receiving this>
- Decision: <most important conclusion or action>
- Link: <doc_url>
```

### 直接执行前的清单

`publish-to-lark` 在对外发送任何东西前，确认：

- 发布决策不是 `SKIP_PUBLICATION`
- 结果带有显式公开闸门证据
- 收件人显式或可解析
- 发送身份是 bot 且该身份经奏折授权或用户请求
- 文档已存在
- 已授予必需权限，或消息显式声明访问权限限制

### 公开闸门证据块

首选把以下之一传入发布：

```json
{
  "summaryPacket": {
    "publicReady": true
  },
  "verificationPacket": {
    "verifyPassed": true
  },
  "publicationPacket": {
    "publicReadyEvidence": [
      "verificationPacket.verifyPassed",
      "summaryPacket.summaryClosed",
      "summaryPacket.deliverableChainClosed"
    ]
  }
}
```

或中文摘要块：

```markdown
## 校验与公开闸门

- 验证通过：是
- 汇总闭合：是
- 单一交付物保持完整：是
- 交付链闭合：是
- 汇总结果完整可对外说明：是
```

### 安全与送达注意事项

- 收件人与消息用途未显式、未经用户批准、未经奏折授权时，不得发 IM
- 不得发裸链接
- 授权失败时，不得静默声称发布成功；精确回报失败

---

## Relation to other doctrines

Lark 发布 doctrine 处于治理链条的"对外宣示"末端——它消费其它 doctrine 的结果，并把它们推送给国家通道（飞书）。与相邻 doctrine 的具体衔接如下：

- **`cadence-doctrine.md`（节奏 doctrine）**：
  - cadence 的「发牌」形态决定了**什么时机**才把一个产物推到对外发布这一环；本 doctrine 则承担发布时机触发后的实际操作。
  - cadence 的「跳过」形态直接对应本 doctrine 的 `SKIP_PUBLICATION` 决策——二者必须一致：cadence 说"本次跳过节点"时，本 doctrine 不得自作主张发飞书；cadence 说"必发节点"时，本 doctrine 必须至少给出 `PUBLISH_DOC_ONLY` 或 `PLAN_ONLY` 的降级回应，不得无声沉默。
  - 交叉引用：cadence-doctrine §跳过 ↔ 本 doctrine §Section C §发布决策矩阵 / §自动发布触发条件。

- **`deal-card-doctrine.md`（发牌 doctrine）**：
  - 一次飞书发布本质上就是"向用户/干系人发出一张官方牌"——发布决策四值（`PUBLISH_NOW` / `PUBLISH_DOC_ONLY` / `PLAN_ONLY` / `SKIP_PUBLICATION`）就是发牌 doctrine 的「是否减少不确定性、是否提高下一步清晰度、是否不过度打断」三判断在对外场景下的具体收束。
  - deal-card 规定"发什么牌"；本 doctrine 规定"这张牌对外时用飞书的什么形态（文档 / IM / wiki）、发给谁、何时发、带不带警告"。
  - 交叉引用：deal-card-doctrine §三判断 ↔ 本 doctrine §Section A §通知律 / §Section C §IM 消息模板。

- **`ux-response-doctrine.md`（UX 响应 doctrine）**：
  - 本 doctrine 的 IM 消息与文档正文都属于"用户可见文字"，其文案风格（结论优先、官署配人话、不暴露 hook/技术字样、降级文案改写）必须服从 UX 响应 doctrine。
  - 当本 doctrine 要写「授权失败，访问仍待授予」这类降级说明时，文案必须按 UX 响应 doctrine §错误与降级文案 的规则改写，不得直接把 `permission_grant_failed` 这类内部状态词暴露给飞书读者。
  - 交叉引用：ux-response-doctrine §结论优先顺序 / §错误与降级文案 ↔ 本 doctrine §Section A §通知律 / §Section C §IM 消息模板。

- **`run-artifact-protocol.md`（受治理的 run artifact 协议）**：
  - 本 doctrine 的公开闸门证据源首选来自受治理的 run artifact；因此本 doctrine 与 `run-artifact-protocol.md` 在 `publicationPacket.publicReadyEvidence` 字段上形成契约连接。run artifact 是"证据"的生产者，本 doctrine 是"证据"的消费者。

- **`meta-governance-layer.md`**：决定"本次结果是否真的适合向外宣示"的上层判断由 meta-governance-layer 给出；本 doctrine 接收该判断后再决定 Lark 通道上的具体执行路径。

---

## Meta-Unit Self-Check

按 `meta-unit-doctrine.md` 的四判断自检本 doctrine：

1. **独立陈述检查**：本 doctrine 陈述"面向飞书的对外发布要满足公开闸门律、先授权后通知、不发裸链、失败要精确回报"——这是一条可被独立表述的规则集，不依赖具体 Lark SDK 版本或具体 skill 实现即可理解。通过。
2. **定位检查**：治理链条中明确定位在"对外宣示"末端。它在 cadence 决定"是否该发"、deal-card 决定"发什么牌"、UX 响应 doctrine 决定"话怎么说"之后，约束"这张牌以飞书形态发出时的操作序列与文字骨架"。发布通道若未来从 Lark 换为其它（如企业微信、Slack），本 doctrine 可被整体替换，其它 doctrine 不需要联动改。通过。
3. **替换代价检查**：替换本 doctrine 影响面限于 `publish` skill、`dispatch` skill 中对发布栈的指向，以及两份 README 的外部链接——均为引用型依赖，修改成本可控；不牵动 cadence / deal-card / ux-response / meta-unit 的结构。耦合是向上单向依赖的。通过。
4. **复用检查**：Section A 的公开闸门律可被任何"对外宣示"型 skill 复用（不限于 Lark）；Section B 的执行阶梯被 `publish` skill 继承；Section C 的标题范式、主文档骨架、IM 模板、公开闸门证据块被 `dispatch` 调度时直接套用。复用面覆盖多个 skill。通过。

四条全部通过，本 doctrine 作为独立元单位合格。
