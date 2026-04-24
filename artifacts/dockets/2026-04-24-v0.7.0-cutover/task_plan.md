# v0.7.0 硬切换任务计划

## 意图

plugin 重命名 `instrument-of-state` → `iostate`，古风命名全部删除，技能/agent 目录精简，完整引用更新，发布 v0.7.0。

## Menxia 授权

本批次 Menxia APPROVE 已在上游承接（来自 v0.6.1 verdict），Works Delivery 可直接进入。

## 总体步骤

1. Part 1：plugin 重命名（plugin.json / marketplace.json）
2. Part 2：技能目录迁移（8 对 → 8 规范目录 + 2 可见性 = 10 个）
3. Part 3：agent 重命名（8 个 agents，全部改短名）
4. Part 4：hooks.json matcher 重命名
5. Part 5：instrument-guard.ps1 Get-AgentRole + downstream 分支 + error messages + record-* 模式
6. Part 6：memorial-math 引用迁移到新 draft skill
7. Part 7：references 全量更新
8. Part 8：contracts 更新
9. Part 9：README + README.zh-CN 重写
10. Part 10：progress.md 落地
11. Part 11：最终校验（5 个检查项）
12. Part 12：commit + push + tag + release

## 重点边界

- 保留 BOM（instrument-guard.ps1）
- 保留 docket 历史档案（artifacts/dockets/ 下的历史文件不动）
- 技能正文保留实质内容（古风叙事版本），只去除"deprecation"段
- 决策：`skills/status/` 和 `skills/rites-protocol/` 因不在目标 10 目录列表中，需要删除或合并。`rites-protocol/` 的实质（礼部职责描述）实际由 `publish-to-lark/` 的框架覆盖；`status/` 功能已被 stage-board 覆盖。两者均删除。

## 风险

- instrument-guard.ps1 改动多，BOM 可能在编辑中丢失 → 每次编辑后重新 `file` 校验
- 未捕获的古风遗留名会污染发布 → Part 11 最后一道 grep 捕获
- 现行会话的 state JSON 可能不兼容 → 不改 schema，只改字符串匹配

## 回滚

本批次为单一大 commit，失败则 `git reset --hard HEAD~1`。
