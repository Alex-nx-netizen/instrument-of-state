# 门下省裁决卡 #2

**Docket:** `2026-04-23-meta-reforge`
**Memorial 版本:** v2 (2026-04-23)
**Reviewer:** Menxia (instrument-of-state:menxia-agent, 2nd pass)
**Reviewed at:** 2026-04-23
**Predecessor:** `verdict-1-menxia.md` (CONDITIONAL)

---

## 裁决

**CONDITIONAL — 附条件批准（极接近 APPROVE）**

- 7/8 订正项已落实到可机械执行
- 1 项部分落实（R2 生成位）：清单齐备，缺上位决策
- **执行权限**：B1/B2/B3/B4 可开工；**B5 前**必须先补 **§4.1-14a** + Menxia 出 verdict-3

---

## 逐项核验结果（Menxia 独立查证）

| # | verdict-1 条目 | 是否落实 | 关键证据（行号） |
|---|---|---|---|
| 1 | publish-to-lark 事实订正 | ✅ | memorial-v2.md §2.3 / §4.1-9 双处措辞一致，无"降级 agent"残留 |
| 2 | 宪法第 99–106 行同步 | ✅ | §4.1-17 + §6 + §7 B2.3；宪章两条独立条目经 Menxia 现场核验存在 |
| 3 | 硬切换终点 | ✅ | §7 B3 + §12 三要素齐全（保留期限 / deprecation 警告 / grep 清零验收）|
| 4 | 契约双保护 | ✅ | §7 B5 + §8 备份 + 单独 APPROVE + 级联 revert 规则闭环 |
| 5 | 验收可证伪 | ✅ | V2a/V4/V7/V8 命令化 |
| 6 | 歧义第 4 项订正 | ✅ | §2.3 与 §4.1-9 同源于 verdict-1 条件 6 |
| R1 | B2 拆 3 sub-commit | ✅ | §7 B2.1/B2.2/B2.3 具体 |
| **R2** | **B5 同批更新生成位** | **⚠ 部分** | 生成位清单有了，但 **`intentPacket.fields` 升级方向（覆盖/叠加）未声明** |

---

## Menxia 新发现的硬事实

当前 `contracts/workflow-contract.json` 第 73–79 行的 `intentPacket.fields` **已经是 5 字段**：
- `trueUserIntent / successCriteria / nonGoals / defaultAssumptions / intentPacketVersion`

v2 §2.2d / §4.1-14 / §5 V5b 要切的新 5 字段是：
- `owner / when / touchpoint / success / adjustPath`

两组**完全不同**的集合。v2 的"五字段强制"表述若无方向说明，Works-Delivery 在 B5 实施时将不得不做架构决策——这违反权力分立。

## Menxia 新增修改要求

| # | 级别 | 要求 |
|---|---|---|
| **1** | 🔴 阻断 B5 | memorial-v2 补 §4.1-14a：明确是覆盖式替换 / 叠加式扩展 / 部分替换 |
| **2** | 🔴 阻断 B5 | 加 V5c：`powershell bin/instrument-guard.ps1 health` 期望退出码 0 + JSON 有效（guard 兼容性） |
| 3 | 🟡 建议 | V5b 改为"前后对比"（抽 B5 前 + B5 后各一份 intentPacket，diff keys） |
| 4 | 🟡 建议 | V2a 把"五特征 或 Five Traits"改为正则 `^## (五特征\|Five Traits)$` |

## Zhongshu 对 14a 的裁决性决定（Coordinator 审议后采用叠加式）

**方案：叠加式扩展** — intentPacket.fields 升级为 10 字段：

| 字段 | 来源 | 语义 |
|---|---|---|
| trueUserIntent | 保留 | 意图声明：用户真实意图的原文 |
| successCriteria | 保留 | 意图声明：整体成功标准 |
| nonGoals | 保留 | 意图声明：明示不做的事 |
| defaultAssumptions | 保留 | 意图声明：Coordinator 的默认假设（歧义披露）|
| intentPacketVersion | 保留 | meta：schema 版本 |
| owner | 新增 | 意图放大：谁执行 |
| when | 新增 | 意图放大：何时 |
| touchpoint | 新增 | 意图放大：通过什么触点 |
| success | 新增 | 意图放大：本触点的成功指标（粒度 < successCriteria）|
| adjustPath | 新增 | 意图放大：效果不好往哪里调 |

**叠加的理由**：两组字段不同粒度——旧组是"意图**声明**"（what/why/constraints），新组是"意图**放大**"（who/when/how）。删旧组会丢失 scope lock 能力与歧义披露能力；这些能力仍是治理必需。

## 分层复审节奏（最终版）

| 批次 | 复审 |
|---|---|
| B1 | 轻 |
| B2 | 轻 + 宪章 diff 必审（B2.3 后）|
| B3 | 门下独立 |
| B4 | 轻 + Windows hook 实测 |
| **B5 pre** | **门下独立 + verdict-3 pre-APPROVE**（本裁决新增）|
| **B5 post** | **门下独立 + verdict-4 post-APPROVE**（本裁决新增）|
| B6 | 轻 |
| 最终汇总 | 门下 verdict-final（第二次总 APPROVE）|

## 下一步指令

1. **Shangshu**：可下 B1 执行令；B1~B4 按 v2 §7 执行
2. **Zhongshu**：立即在 memorial-v2.md 追加 §4.1-14a（叠加式裁决）+ §5 V5c + V5b 改进 + V2a 正则——**本文件已执行此决策，并写入 memorial-v2.md**
3. **Menxia (future self)**：B5 开工前读 memorial-v2 §4.1-14a 出 verdict-3；B5 commit 后出 verdict-4；最终出 verdict-final

## 权力分立检查

本裁决独立于 Coordinator 与用户的"推进意愿"，独立发现了 `intentPacket.fields` 覆盖/叠加的决策缺口；权力分立完整保持。
