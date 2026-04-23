---
name: tool-trace
description: Replay the current docket's full tool, agent, and skill invocation timeline from hook-debug log and docket artifacts.
context: fork
user-invocable: true
allowed-tools: Read Bash Grep Glob
---

# Tool Trace

Replay THIS docket's full invocation timeline.

本 skill 的职责是把一次奏折从请愿到交付之间，中书 / 门下 / 工部 / tool / skill 的全部调用按时间顺序复盘，回答「到底发生了什么、顺序如何、在哪一步出了分叉」。

## 数据源

- `.claude/instrument-of-state/logs/hook-debug.log`（逐行，每行 `[timestamp] mode=<mode> session=<id> <detail>`）
- `artifacts/dockets/<current-docket>/` 内的 `memorial*.md` / `verdict-*.md` / `progress.md`
- （可选）`.claude/instrument-of-state/state/<session_id>.json` 用于比对最终态

## 重建步骤

Step 1 — 打开 hook-debug.log；仅保留文件最新尾部（可 `tail -n 500`），避免处理跨会话噪声。

Step 2 — 锁定当前 session_id。取法如下（优先第一种）：

- 运行 `powershell bin/instrument-guard.ps1 health`，从其输出的 JSON 读出 `session_id`
- 或从日志最后一条非 `session-unknown` 的行里取 session

Step 3 — 对该 session 过滤并分组事件：

- `mode=annotate-start`  → subagent 启动（zhongshu / menxia / works-delivery / …）
- `mode=record-zhongshu` / `record-menxia` / `record-works-delivery`  → subagent 落定状态
- `mode=record-agent-result`  → subagent 返回解析
- `mode=guard-tool`  → 主线工具调用（Write / Edit / Bash），含 agent 上下文
- `mode=guard-agent`  → Task 分派决策（允许 / 拒绝）
- `mode=session-context`  → 会话起点
- `mode=load-state` 且含 `HMAC mismatch`  → 疤痕事件

Step 4 — 枚举 docket 产物：

- `ls -t artifacts/dockets/<current>/*.md`，提取各文件的顶部 H1/H2 作为归档标题
- 对 `verdict-*-menxia.md` 按序号列出
- `progress.md` 最后 N 行用于比对日志与书面账是否一致

Step 5 — 组装时间轴表（以下为推荐列序，Markdown 表）：

| 时间 | 角色 | 动作 | 结果/关键字 |
|---|---|---|---|
| 01:10 | zhongshu-agent | annotate-start | memorial drafting required |
| 01:12 | Read/Write/Bash | tool call | path=... |
| 01:20 | zhongshu-agent | record-agent-result | drafted=true |
| 01:22 | menxia-agent | annotate-start | ready for review |
| 01:30 | menxia-agent | record-agent-result | verdict=APPROVE |
| 01:32 | works-delivery-agent | annotate-start | approved — executing |
| …    | …              | …                 | … |

Step 6 — 比对差异：把日志中出现但 progress.md 未记录的动作单列；反之亦然。

## 输出契约

以中文返回以下章节：

## 会话识别
写出 session_id、起始时间、docket 路径。

## 时间轴
上表照搬，时间、角色、动作、结果四列齐全。

## Docket 产物清单
按生成时间列出 memorial / verdict / progress，标注文件大小或行数。

## 疤痕与异常
列出 HMAC mismatch、soft-failure、非预期 DENY、顺序倒置（如 menxia 在 zhongshu 前出现）等。

## 书面账与日志差异
progress.md 与 hook-debug.log 之间互相独有的条目。

## Meta-Unit Self-Check

### 五特征 / Five Traits

- **足够小 (small enough)**: 只做日志回放与排版
- **足够正交 (orthogonal)**: 与 stage-board 互补（时间轴 vs 瞬时快照）
- **足够可组合 (composable)**: 输出可直接贴入 docket 的 writeback 段
- **足够可审计 (auditable)**: 全部字段来自 hook-debug.log 与 docket 内文件
- **足够谦卑 (humble)**: 不重写历史，只呈现

### 四判断 / Four Checks

- **目标判断 (goal check)**: 能回答「这次发生了什么」？✅ 时间轴 + 产物清单双证
- **能力判断 (capability check)**: Read / Grep / Bash 即可，无能力缺口
- **边界判断 (boundary check)**: 不修改日志；不重写 progress；只读
- **证据判断 (evidence check)**: 每一行都指向一条 log 时间戳或一份 docket 文件
