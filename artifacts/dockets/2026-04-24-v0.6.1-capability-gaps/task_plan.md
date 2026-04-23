# 任务方案 — v0.6.1 能力缺口补丁

**Docket:** 2026-04-24-v0.6.1-capability-gaps
**上游授权:** 2026-04-23-meta-reforge verdict-final-menxia.md (APPROVE, 记录在案)
**执行模式:** 工部交付（自治执行，Menxia 授权自动携带）

## 目标

收敛 v0.6.0 发布后识别的三处能力缺口，辅以仓库卫生修复与回溯打标，发布 v0.6.1 patch。

## 范围

### Gap 1 — Guard verdict 解析对长文本/叙事性前言的鲁棒性

**现象:** `bin/instrument-guard.ps1` 的 `Get-Verdict` 在 Menxia 输出含叙事前言、长篇中文内容时返回 `NONE`。短英文输出正常。
**根因:** 正则 `[regex]::Match` 取第一个 `## Verdict` 段。叙事中若提及 "verdict" 字样或 prompt 模板回显，会抢占权威裁决卡位置。
**修复:** 改用 `[regex]::Matches` 扫描全部并取 LAST 匹配项为权威。保留两条 fallback（`**VERDICT**` 粗体、中文关键词）。

### Gap 2 — Justice Compliance 健康自检被守卫误封

**现象:** `justice-compliance-agent` 跑 `powershell bin/instrument-guard.ps1 health` 做 V5c 活体验证时，`guard-tool` 把它当 mutating bash 拒掉，Justice 只能做静态审计。
**根因:** `Is-MutatingBash` 白名单未收录守卫自省命令。
**修复:** 在 `guard-tool` 分支 `Is-MutatingBash` 检查之前，加入只读自省白名单：`instrument-guard.ps1 (health|session-context)` 无管道/连接符时允许所有官署执行。

### Gap 3 — Memorial 批次算术辅助

**现象:** memorial-v2 V1 标注目标 14（references/*.md），实际批次算术得 17。起草时无校验手段。
**修复:** 新增 `bin/memorial-math.ps1`（Start + Deltas → Expected end）。在 `skills/iostate-draft/SKILL.md` 补充起草时调用要求。

### 附加项

- 2 个 scar 文件（Gap1、Gap2 根因+修复）
- origin URL 修正 `Dick1109 → Alex-nx-netizen`（GitHub 重定向）
- v0.5.0 回溯打标到 `37893c7`（开启 `git log v0.5.0..v0.6.0` 对比能力）
- `plugin.json` 与 `marketplace.json` 双位点版本号 0.6.0 → 0.6.1

## 验证

- `powershell bin/test-guard-hmac.ps1` 仍 8/8 pass（无回归）
- guard 文件保留 UTF-8 BOM
- 插件缓存 `~/.claude/plugins/cache/instrument-of-state/instrument-of-state/0.5.0/bin/instrument-guard.ps1` 与源文件 diff empty
- `powershell bin/memorial-math.ps1 -Start 20 -Deltas 3,-2,-2,-2` 输出 `Expected end: 17`
- `git remote -v` 显示新 URL
- v0.5.0、v0.6.1 标签本地 + 远端可见
- GitHub release v0.6.1 创建成功

## 不在本次范围

- v0.7.0 legacy 名称下线（下一轮任务）
- Lark 发布（未获 user public-ready 确认）

## 风险

- 修改 `Get-Verdict` 主正则，若语义误变可能让 APPROVE 失效。缓解：仅改变"取首"→"取尾"，候选集不变，fallback 保留；HMAC 测试 8/8 pass 覆盖 record-menxia 路径。
- guard-tool 白名单扩宽若正则写松可能被绕过。缓解：只白名单固定命令名 `instrument-guard.ps1 (health|session-context)`，并排除 `| > < ; && ||` 等连接符。
