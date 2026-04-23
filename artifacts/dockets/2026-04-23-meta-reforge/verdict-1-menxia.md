# 门下省裁决卡 #1

**Docket:** `2026-04-23-meta-reforge`
**Memorial 版本:** 初稿 (2026-04-23)
**Reviewer:** Menxia (instrument-of-state:menxia-agent)
**Reviewed at:** 2026-04-23

---

## 裁决

**CONDITIONAL — 附条件批准**

- 执行权限：**暂未解锁工部**
- 下一动作：中书省按 6 条关键条件修订奏折后重报
- 复审节奏：**B3、B5、最终汇总**三个刚性独立复审节点；其余为轻复审

---

## 6 条关键条件

1. **事实订正**：`publish-to-lark` 从来不是 agent（agents/ 仅 9 份且无该文件）。"降级"叙事失真。改为"确认 publish-to-lark 保持 skill 身份，并在 plugin.json 描述中去除权力中心暗示"。
2. **宪法同步**：合并 personnel + revenue 必须同步修改 `constitutional-rules.md` 第 99–106 行的六部独立条目。本项需显式纳入 B2（或新批次）。
3. **硬切换终点**：memorial §4.1-10 的"新旧命名并存"必须写明：保留期限（建议 ≤v0.7.0 移除）+ deprecation 警告实现方式 + 彻底切换前最后一批验收项。
4. **契约双保护**：B5 前必须 `contracts/workflow-contract.backup-v0.5.0.json` 备份；B5 后增加独立门下复审；明确 B5 revert 是否级联到 B3/B4。
5. **验收可证伪**：V4/V7/V8 必须从"手动观察/30 秒内/手动回归"升级为可执行命令 + 期望输出/退出码。V2 需枚举小节标题文本。V5 需加语义检查（不只 jq）。
6. **歧义第 4 项订正**：用户回复的"保留 skill 去掉 agent 身份"是伪动作。改为"`publish-to-lark` 在 `rites-protocol-agent.md` 与 `plugin.json` 的描述中不得被表述为独立权力中心，只能作为 rites 麾下执行工具"。

## 2 条额外风险（建议并入订正）

- **B2 原子性陷阱**：7 份文件合进一个 commit，任一失败 revert 会带走其他成功合成。建议 B2 拆为 `B2.1/B2.2/B2.3` 三个 sub-commit。
- **B5 契约升级后 packet 生成位静默不变**：仅改 schema 不改 zhongshu 草稿模板会导致契约升级形同虚设。建议 B5 同批次更新至少一处 packet 生成位 + 加 V5b "抽样一份新生成 intentPacket 验证五字段齐备"。

## 分层复审节奏（裁决中指定）

| 批次 | 复审级别 |
|---|---|
| B1 | 轻复审（凭 Justice 报告） |
| B2 | 轻复审 + 宪章 diff 必审 |
| **B3** | **门下独立复审** |
| B4 | 轻复审 + Windows hook 实测证据 |
| **B5** | **门下独立复审 + 单独 APPROVE** |
| B6 | 轻复审 |
| **最终汇总** | **门下第二次 APPROVE**（public-ready 前提） |

## 协议链状态

- `menxia_review_ready` 闸门：**形式通过**（三包齐备）
- `works_delivery_unlock`：**未解锁**（等重报）
- `intent_locked`：**部分收敛**，待条件 6 订正后算真锁
- `public_ready`：距离 6 项前提

## 权力分立状态

完整保持。Menxia 对用户默认解释第 4 项做出独立订正（条件 6），未照搬 Coordinator 口径。
