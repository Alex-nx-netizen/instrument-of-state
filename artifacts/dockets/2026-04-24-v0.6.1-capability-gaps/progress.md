# 执行日志 — v0.6.1 能力缺口补丁

## 交付批次

| # | 项目 | 状态 | 备注 |
|---|---|---|---|
| 1 | Guard verdict 解析鲁棒性 | 待执行 | `Get-Verdict` 扫全部段取 LAST |
| 2 | Justice health 白名单 | 待执行 | `guard-tool` 支路插入自省白名单 |
| 3 | memorial-math.ps1 辅助 | 待执行 | 新建 bin 脚本 + SKILL.md 文案 |
| 4 | Gap1 scar | 待执行 | `memory/scars/guard-verdict-parser-long-output-2026-04-24.md` |
| 5 | Gap2 scar | 待执行 | `memory/scars/guard-justice-health-blocked-2026-04-24.md` |
| 6 | origin URL 修正 | 待执行 | set-url 到 Alex-nx-netizen |
| 7 | v0.5.0 回溯打标 | 待执行 | 指向 37893c7 |
| 8 | 版本号 0.6.0 → 0.6.1 | 待执行 | plugin.json + marketplace.json 双位点 |
| 9 | HMAC 回归测试 | 待执行 | 期望 8/8 pass |
| 10 | 缓存同步 | 待执行 | diff 应为空 |
| 11 | 单提交 + push | 待执行 | conventional fix(v0.6.1) |
| 12 | v0.6.1 tag + release | 待执行 | gh release create |

## 执行记录

- **Gap 1 — Get-Verdict:** `bin/instrument-guard.ps1` Get-Verdict 改为 `[regex]::Matches` 扫全部取 LAST 匹配项（FIX-9），保留两条 fallback。
- **Gap 2 — 守卫白名单:** `guard-tool` Bash 支路 `Is-MutatingBash` 之前插入 `instrument-guard.ps1 (health|session-context)` 白名单，排除 `| > < ; && ||` 连接符（FIX-10）。
- **Gap 3 — memorial-math:** 新建 `bin/memorial-math.ps1`（Start + Deltas → Expected end）；`skills/iostate-draft/SKILL.md` 增补批次算术校验指引。
- **Scars:** `memory/scars/guard-verdict-parser-long-output-2026-04-24.md`、`memory/scars/guard-justice-health-blocked-2026-04-24.md` 已写入。
- **origin URL:** `Dick1109 → Alex-nx-netizen` 已切换，`git remote -v` 验证。
- **v0.5.0 回溯标签:** 打到 `37893c7`，本地可见。
- **版本:** `plugin.json` 0.6.0 → 0.6.1；`marketplace.json` 两个位点 0.6.0 → 0.6.1。
- **验证:**
  - `powershell bin/test-guard-hmac.ps1` → 8/8 pass
  - `file bin/instrument-guard.ps1` → UTF-8 with BOM（保留）
  - 缓存同步 `~/.claude/plugins/cache/.../bin/instrument-guard.ps1`，`diff` 空
  - `powershell -Command "& ./bin/memorial-math.ps1 -Start 20 -Deltas @(3,-2,-2,-2)"` → `Expected end: 17`
