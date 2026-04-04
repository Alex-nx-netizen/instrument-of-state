<div align="center">

# 国之重器 / Instrument of State

**先起草，再审核，再执行。**

![插件](https://img.shields.io/badge/Claude_Code-Plugin-1f6feb?style=flat-square)
![流程](https://img.shields.io/badge/Workflow-14%20Stages-0f766e?style=flat-square)
![Agents](https://img.shields.io/badge/Agents-9-7c3aed?style=flat-square)
![Skills](https://img.shields.io/badge/Skills-10-2563eb?style=flat-square)
![Hooks](https://img.shields.io/badge/Hooks-Guarded-c2410c?style=flat-square)
![Lark](https://img.shields.io/badge/Lark-Ready-0891b2?style=flat-square)

<img src="./assets/readme/hero.svg" alt="Instrument of State hero" width="820" />

</div>

---

## 它解决什么问题

很多 AI 编码流程会把这些事混成一步：

- 规划
- 审批
- 落地
- 汇报

小任务可以，大任务就容易失控。

---

## 它是什么

`instrument-of-state` 是一个 **Claude Code 插件**，不是单独的 skill。

它会把一个任务变成受治理的流程：

- 中书省起草
- 门下省审核
- 尚书省发令
- 六部按需执行
- 工部没有批准不能落地

---

## 流程

```text
下旨 -> 承旨 -> 侦察 -> 起草 -> 审核 -> 发令 -> 六部 -> 回呈 -> 宣示
```

| 阶段 | 官署 | 作用 |
| --- | --- | --- |
| 1 | 皇上以下旨 | 用户提交任务 |
| 2 | 太子承旨 | 判断模式、范围、风险 |
| 3 | 锦衣卫侦察 | 立案卷、查能力 |
| 4 | 中书省 | 起草 memorial |
| 5 | 门下省 | 给出 verdict |
| 6 | 尚书省 | 调度各部 |
| 7 | 六部 | 按需执行 |
| 8 | 奏折回呈 | 汇总结果 |
| 9 | 礼部宣示 | 需要时走飞书/Lark 发布 |

<div align="center">
  <img src="./assets/readme/workflow.svg" alt="Imperial workflow diagram" width="920" />
</div>

---

## 快速安装

```text
/plugin marketplace add Dick1109/instrument-of-state
/plugin install instrument-of-state
```

然后运行主流程：

```text
/instrument-of-state:shangshu-dispatch 重构 auth 模块，并保持可视化阶段看板。
```

---

## 主命令

| 命令 | 用途 |
| --- | --- |
| `/instrument-of-state:shangshu-dispatch <任务>` | 主入口，启动完整治理流程 |

示例：

```text
/instrument-of-state:shangshu-dispatch 调查登录故障，先稳住生产，再生成正式交接说明。
/instrument-of-state:shangshu-dispatch 重做 pricing 页面，要求风格鲜明并保持可访问性。
/instrument-of-state:shangshu-dispatch 审核发布清单，并发布飞书交接文档。
```

---

## 插件里有什么

| 组件 | 作用 |
| --- | --- |
| `skills/` | `shangshu-dispatch`、`zhongshu-draft`、`menxia-review`、`works-delivery`、`publish-to-lark` 等能力 |
| `agents/` | 尚书省、中书省、门下省、刑部、工部、礼部等执行角色 |
| `hooks/` | 技术执法，例如“门下未批准不得工部落地” |
| `bin/` | 守卫脚本和市场辅助脚本 |
| `.claude-plugin/plugin.json` | 插件清单 |
| `.claude-plugin/marketplace.json` | marketplace 清单 |

---

## 核心特点

- **可视化阶段看板**：输出 `Imperial Banner` 和 `Imperial Stage Board`
- **强制审批后落地**：门下未 `APPROVE`，工部不能写
- **本地优先能力搜索**：本地 skill/plugin -> `find-skills` -> marketplace
- **礼部发布链**：可生成文档、授权、发 IM、归档 Wiki
- **前端双技能法**：界面任务必须走 `ui-ux-pro-max` + `frontend-design`
- **superpowers 归位**：辅助能力按官署归位，而不是乱用
---

## 前端规则

界面任务必须同时使用：

- `ui-ux-pro-max`：负责 UX 结构、可访问性、响应式、交互质量
- `frontend-design`：负责视觉方向、字体、构图、动效、避免普通 AI 风格界面

---

## 礼部发布

需要正式对外交付时，礼部会按顺序处理：

1. 建文档
2. 授权
3. 发 IM
4. 归档 Wiki

<div align="center">
  <img src="./assets/readme/publication-chain.svg" alt="Lark publication chain" width="920" />
</div>

---

## 参考文档

- [English README](./README.md)
- [宪法规则](./references/constitutional-rules.md)
- [治理手册](./references/governance-playbook.md)
- [朝廷流程](./references/imperial-workflow.md)
- [阶段看板规则](./references/imperial-stage-board.md)
- [前端治理](./references/frontend-governance.md)
- [Superpowers 集成](./references/superpowers-integration.md)

---

<div align="center">
为可治理、可见、可交付的 Claude Code 执行流程而生。
</div>
