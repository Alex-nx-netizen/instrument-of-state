# v0.7.0 硬切换执行记录

## 基线

- HEAD：37893c7 fix(encoding): add UTF-8 BOM to instrument-guard.ps1（即 v0.6.1 post-fix）
- HMAC 基线：8/8 PASS
- BOM 基线：UTF-8 with BOM 已确认

## Part 1：plugin 重命名 ✅

- `.claude-plugin/plugin.json` → `"name": "iostate"`
- `.claude-plugin/marketplace.json` → 镜像一致

## Part 2：技能目录迁移 ✅

- 迁入：`skills/allocate/`、`skills/deliver/`、`skills/dispatch/`、`skills/draft/`、`skills/emergency/`、`skills/publish/`、`skills/review/`、`skills/verify/`
- 可见性保留：`skills/stage-board/`、`skills/tool-trace/`
- 迁出：`iostate-*`（8 个）、`zhongshu-draft`、`menxia-review`、`shangshu-dispatch`、`works-delivery`、`justice-compliance`、`rites-protocol`、`resource-allocator`、`war-operations`、`publish-to-lark`、`status`（共 17 个）
- 合并/裁撤：`rites-protocol/` 实质由 `publish/` 框架覆盖；`status/` 功能被 `stage-board` 覆盖；两者删除

## Part 3：agent 重命名 ✅

- 新建 8 个：`allocate-agent`、`deliver-agent`、`dispatch-agent`、`draft-agent`、`emergency-agent`、`publish-agent`、`review-agent`、`verify-agent`
- 删除 8 个旧古风名：`justice-compliance-agent`、`menxia-agent`、`resource-allocator-agent`、`rites-protocol-agent`、`shangshu-agent`、`war-operations-agent`、`works-delivery-agent`、`zhongshu-agent`

## Part 4：hooks.json ✅

- 所有 `"matcher"` 字段切到新短名：`draft-agent`、`review-agent`、`deliver-agent`（及通用 `Agent` / `Write|Edit|Bash`）
- 无旧古风 matcher 残留（Part 11 CHECK 5 已证）

## Part 5：instrument-guard.ps1 ✅

- `Get-AgentRole` 已按新短名分发
- 分支判定：`draft-agent` / `review-agent` / `deliver-agent`
- 错误消息已切到动词形式（"Review is blocked until Draft..."、"Deliver is not unlocked because Review..."）
- HMAC key 保持 `"iostate-guard-v1"`
- `record-*` 模式全部生效
- BOM 保留 `EF BB BF`
- State schema 字段 `state.menxia.*` 按 task_plan §37 意图保留（不改 schema）

## Part 6：memorial-math 引用 ✅

- `skills/draft/SKILL.md:57,62` 指向 `bin/memorial-math.ps1`
- 其它 skill / agent 未再引用旧路径

## Part 7：references 全量更新 ✅

**首批（v0.6.1 后续 + K1 scope）**：`governance-playbook.md` §68-160 所有命令标识符动词化，Stage Gate Summary 两行（§184-185）K1 补齐

**K2 扫尾**（23 行跨 7 文件）：
- `references/cadence-doctrine.md`：9 行（§37-38、§60-61、§83-84、§104-105、§202）
- `references/deal-card-doctrine.md`：§73 小标题
- `references/lark-publication-doctrine.md`：§85、§92、§130
- `references/ux-response-doctrine.md`：§255
- `references/meta-unit-doctrine.md`：§43、§88、§165-167
- `references/market-acquisition.md`：§83 宪法提醒
- `memory/dispatch-patterns.md`：§14、§23、§33、§35（跨 A2 + Y 两批）
- `memory/templates/pattern-template.md`：§17-19 slot

**意图保留（court theater / 剧场映射）**：
- `references/constitutional-rules.md` §85-103 bilingual 标题 + Historical note
- `references/meta-governance-layer.md` §158-160 Court-stage ↔ Hidden meta concern 映射表
- `references/frontend-governance.md` §58-68 bilingual 角色标题
- `skills/stage-board/SKILL.md`、`skills/tool-trace/SKILL.md` 技能叙事态
- `assets/readme/*.svg` 图内剧场标签
- `README.md` / `README.zh-CN.md` §36 迁移声明列表
- `bin/memorial-math.ps1` docstring
- 各文件中完整古风词组"门下省 / 中书省 / 尚书省 / 工部 / 刑部 / 礼部"

**归档保留（历史档案）**：
- `memory/capability-gaps.md:14`（2026-04-16 dated incident）
- `memory/scars/*`、`memory/patterns/meta-reforge-learnings-*`
- `artifacts/dockets/2026-04-23-*`

## Part 8：contracts ✅

- `contracts/workflow-contract.json` 命令参照迁至动词形式
- `contracts/run-artifact.template.json` 同步
- Schema 字段 `menxia_review_ready` 按 task_plan §37 意图保留
- backup-v0.5.0 历史版本原样保留

## Part 9：README ✅

- `README.md` / `README.zh-CN.md` 重写
- §36 列出被删除的古风命令名作为明确迁移声明

## Part 10：ledger ✅

- 本文件

## Part 11：validation ✅

Part 11 最终 5 项校验结果：

| # | 校验项 | 结果 |
|---|--------|------|
| 1 | HMAC 8/8 roundtrip | ✅ 8/8 PASS |
| 2 | `bin/instrument-guard.ps1` BOM | ✅ UTF-8 (with BOM) |
| 3 | 活跃源码内英文古风标识符残留 | ✅ 零残留（意图保留项已白名单） |
| 4 | `plugin.json` vs `marketplace.json` name 对齐 | ✅ 均为 `"iostate"` |
| 5 | `hooks.json` matcher 对齐新 agent 名 | ✅ 无旧 matcher |

## Part 12：commit + push + tag + release ✅

- Commit 1：`ce7782a` `reforge(v0.7.0): hard rename — plugin iostate, verb-form commands`（55 文件，646 insertions / 844 deletions，git 自动识别 17 个 renames）
- Commit 2（follow-up）：`dd60f7f` `fix(docs): update README marketplace install owner to Alex-nx-netizen`（README.md:120 + README.zh-CN.md:123，用户名切换）
- Tag：`v0.7.0`（annotated，HEAD = dd60f7f）
- Push：`origin/main` `61dc0df..dd60f7f` + tag `v0.7.0` → `github.com/Alex-nx-netizen/instrument-of-state`
- Release：<https://github.com/Alex-nx-netizen/instrument-of-state/releases/tag/v0.7.0>（含 breaking 说明、migration 指令、验证清单）

## Part 13：README 二轮修订（2026-04-24 后续）

petition：用户要求 (a) 替换副标题"治理执行运行时"为更贴合本项目的名称，(b) 重写 README.md / README.zh-CN.md 以更准确地描述当前项目，(c) 在标题下方扩充类似 shields.io 的彩色徽章行（用户参考了一张外部项目 166k stars 的截图）。

**事实校准（不可造假）**：

| 维度 | 真实值 | 用户参考图中的虚假项 |
|---|---|---|
| License | Apache-2.0 | 图中显示 MIT — 不可照抄 |
| 语言 | PowerShell + Markdown + JSON（175 .md / 38 .json / 8 .ps1） | 图中 TS/Python/Go/Java/Perl — 本项目不存在 |
| Stars | 0 | 图中 166k — 不可造假 |
| Forks | 0 | 图中 26k — 不可造假 |
| Contributors | 1 | 图中 159 — 不可造假 |
| Weekly downloads | 无统计 | 图中 1.9k/week — 不可造假 |
| Owner | Alex-nx-netizen | — |
| 最新 Release | v0.7.0（2026-04-24） | — |
| Repo description | "Govern Claude Code before it governs your repo." | — |

执行序：docket → draft → review → deliver → verify → 收口。

**执行结果（2026-04-24 收口）**：

- **副标题 (EN)**：`iostate / Governed Execution Plugin for Claude Code`（README.md:3）
- **副标题 (CN)**：`iostate / Claude Code 治理执行插件`（README.zh-CN.md:3）
- **tagline**：`runtime` → `plugin` / `运行时` → `插件`（行 20）
- **徽章行**：2 枚 → 10 枚，三行混排（for-the-badge 4 枚 + flat 4 枚 + dynamic 2 枚），stars 明确排除
- **新增段落**：`Who is this for?` / `谁该用这个插件`（行 38-43）+ `What It Is NOT` / `它不是什么`（行 104-110 / 107-113）
- **License 徽章**：Apache-2.0（非 MIT）
- **未触碰文件**：`.claude-plugin/*`、hooks、agents、skills、contracts、assets、references 保持不变
- **治理闸门**：draft → review（第 1 轮 RETURN，第 2 轮 CONDITIONAL，第 3 轮 APPROVE 但 verdict 未被 guard 识别为 NONE，第 4 轮重发 guard-parseable APPROVE 成功解锁）→ deliver（10 次 Edit 零偏离）
- **疤痕写回候选**：`Get-Verdict` 正则对"批准（APPROVE）"形式不识别，需要 `## 裁决\n\nAPPROVE` 格式；review 输出模板应显式 guard-parseable 化
- **模式写回候选**：字面锁定 + 锚点上下文 是 README-class 交付的首选合约形态，可阻断 deliver 层文学化漂移

## 备注 — 本批次 scope 变更轨迹

- 初始 A1 scope：2 行 prose（governance-playbook §184-185）
- 用户追加 A2：+2 行（dispatch-patterns §33, §35）
- deliver 报告同文件还有 §14、§23 同类残留，用户 Y 追加
- 进一步扫描发现其它 6 个 references/ 文件 + 1 个 memory/templates/ 有同类命名分散，用户 K2 决定全量扫尾
- 最终 prose 扫尾范围：23 行，跨 9 个文件
