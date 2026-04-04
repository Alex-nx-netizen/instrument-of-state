# Imperial Stage Board

Use this file when `shangshu-dispatch` prepares a user-visible response.

Every governed task should begin with a visible stage banner and a full court board so the user can see:

- which stage is active
- which stages are waiting
- which stages are complete
- which stages were skipped
- which stage is blocked and by what

## Status vocabulary

Use exactly one of these status markers per stage:

- `DONE`
- `ACTIVE`
- `WAITING`
- `BLOCKED`
- `SKIPPED`

## Banner format

Return this before the board:

```markdown
## Imperial Banner

国之重器 | <petition summary> | Mode: <Standard|Strict|Emergency>
```

## Board law

1. Always list the full board, even if some stages are skipped.
2. Always list all six ministries individually.
3. The board must reflect the actual current proceeding, not an imagined ideal flow.
4. If a stage is not yet in motion, mark it `WAITING` and name the dependency.
5. If a stage is not needed, mark it `SKIPPED` and give a short reason.
6. If a stage is blocked, mark it `BLOCKED` and state exactly what it is waiting on.
7. If a stage is active, say who is working and on what.
8. If a stage is waiting or blocked, name the office, verdict, dossier, or artifact it is waiting for.

## Stage order

Use this exact order:

1. 皇上以下旨 / Emperor Decree
2. 太子承旨 / Crown Prince Intake
3. 锦衣卫侦察 / Jinyiwei Recon
4. 中书省起草 / Zhongshu Draft
5. 门下省封驳 / Menxia Review
6. 尚书省发令 / Shangshu Dispatch
7. 吏部 / Personnel
8. 户部 / Revenue
9. 礼部 / Rites
10. 兵部 / War
11. 刑部 / Justice
12. 工部 / Works
13. 奏折回呈 / Memorial Return
14. 礼部宣示 / Rites Publication

## Board template

```markdown
## Imperial Stage Board

1. [DONE] 皇上以下旨 / Emperor Decree：用户已提交请示“<petition summary>”
2. [ACTIVE] 太子承旨 / Crown Prince Intake：`shangshu-agent` 正在判定模式、风险与是否立案
3. [WAITING] 锦衣卫侦察 / Jinyiwei Recon：等待太子承旨返回 intake 结论
4. [WAITING] 中书省起草 / Zhongshu Draft：等待锦衣卫卷宗与能力侦察结果
5. [WAITING] 门下省封驳 / Menxia Review：等待中书省返回 memorial
6. [WAITING] 尚书省发令 / Shangshu Dispatch：等待门下省 verdict
7. [SKIPPED] 吏部 / Personnel：本案无额外分工设计需求
8. [WAITING] 户部 / Revenue：等待尚书省决定是否需要成本评估
9. [WAITING] 礼部 / Rites：等待尚书省决定是否需要正式文书或对外通报
10. [SKIPPED] 兵部 / War：本案不是应急或事故任务
11. [WAITING] 刑部 / Justice：等待尚书省决定是否需要高风险校验
12. [BLOCKED] 工部 / Works：等待门下省 `APPROVE`
13. [WAITING] 奏折回呈 / Memorial Return：等待各部 findings 与交付结果
14. [WAITING] 礼部宣示 / Rites Publication：等待尚书省 close-out publication 决议
```

## Notes style

Each line should be short but concrete. Mention either:

- the active executor
- the blocking dependency
- the reason the stage was skipped

Good examples:

- ``shangshu-agent` 正在审查代码逻辑与风险边界`
- `等待中书省返回 memorial`
- `等待门下省 APPROVE`
- `已完成收件人解析与权限授予`
- `本案无需兵部介入`

Avoid vague notes like:

- `处理中`
- `分析中`
- `待定`

Say what is actually happening or actually missing.
