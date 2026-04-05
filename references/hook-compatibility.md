# Hook 兼容与排障

本文件用于处理 Windows 环境下的 hook 兼容问题，特别是以下症状：

- `PreToolUse:Agent hook error`
- `PreToolUse:Bash hook error`
- 子 Agent 已运行，但前置守卫显示失败

## 已采用的兼容策略

当前插件使用以下策略降低 Windows 上的 hook 风险：

1. hook 入口统一走 `bin/instrument-guard.cmd`
2. `instrument-guard.cmd` 再调用 `instrument-guard.ps1`
3. PowerShell 以 `-NoLogo -NoProfile -NonInteractive` 启动
4. `instrument-guard.ps1` 失败时采用 fail-open，不因守卫异常中断主流程
5. 守卫日志写入 `.claude/instrument-of-state/logs/hook-debug.log`

## 用户可见文案

如果守卫异常但主流程仍可继续，用户面不应直接看到 `hook error` 这类技术词。

推荐统一文案：

`治理守卫已降级，主流程继续。技术细节已写入本地日志。`

说明：

- 用户面只看结果，不看内部 hook 名称
- 技术原因留给日志和排障人员

## 排查顺序

### 1. 先确认插件是否已重载

如果刚修改过以下文件，必须重开 Claude Code 会话或重新加载插件：

- `hooks/hooks.json`
- `bin/instrument-guard.cmd`
- `bin/instrument-guard.ps1`

否则 Claude 可能仍在使用旧 hook 命令。

### 2. 查看本地 hook 日志

检查：

`E:\ai\study\instrument-of-state\.claude\instrument-of-state\logs\hook-debug.log`

重点看：

- 是否有 `mode=guard-agent`
- 是否有 `subagent_type=...`
- 是否有 `error=...`

如果只有 `session-context`，说明 hook 命令能启动，但 Agent 事件输入可能未按预期传入。

### 3. 检查是否是旧 shell 或 profile 干扰

当前实现已尽量规避 shell profile 干扰。如果仍报错，优先怀疑：

- Claude 仍使用旧配置缓存
- hook 事件输入结构与当前脚本假设不一致
- 平台在该版本下对 Windows 命令字符串处理存在差异

### 4. 验证守卫脚本本身

可本地验证以下命令：

```powershell
powershell -NoProfile -ExecutionPolicy Bypass -File .\bin\instrument-guard.ps1 session-context
Get-Content .\tmp-hook.json -Raw | powershell -NoProfile -ExecutionPolicy Bypass -File .\bin\instrument-guard.ps1 guard-agent
```

如果这两条都正常，而 Claude 里仍显示 `hook error`，则高概率是平台未重载或调用方式差异，不是脚本语法错误。

## 建议处理策略

1. 重开 Claude Code 会话
2. 重新安装或重新加载插件
3. 重新触发一次最小子 Agent 场景
4. 对照 `hook-debug.log` 判断是命令未启动、事件未传入，还是权限决策被拒绝
