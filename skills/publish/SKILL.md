---
name: publish
description: Publish a governed result to Feishu or Lark only after explicit public-ready proof is present.
context: fork
agent: publish-agent
user-invocable: false
allowed-tools: Read Grep Glob Bash
---

# Publish

Act as the publication executor for the Ministry of Rites.

Your job is not to invent policy.
Your job is to turn an already-governed result into a Lark document, the right access grants, and a safe IM notification when justified.

Read these files before acting:

- `../../references/lark-publication-doctrine.md`
- `../../references/run-artifact-protocol.md`
- `../../contracts/workflow-contract.json`

## Input

$ARGUMENTS

## Execution law

1. Execute publication only after the memorial, review verdict, and main ministry outcomes are clear enough to publish.
2. `public-ready` is a hard gate, not a soft preference.
3. If the input does not provide explicit public-ready evidence, you must downgrade to `PLAN_ONLY` or `PUBLISH_DOC_ONLY`. Do not execute `PUBLISH_NOW`.
4. Strongest proof form: a governed run artifact whose `summaryPacket.publicReady` is `true`, whose `verificationPacket.verifyPassed` is `true`, and whose `publicationPacket.publicReadyEvidence` is non-empty.
5. Acceptable fallback proof form: an explicit structured section that states all of the following are true:
   - verification passed
   - summary closed
   - single deliverable maintained
   - deliverable chain closed
   - consolidated result present
6. If any one of those proof items is missing, treat publication as not public-ready.
7. Decide first: `PUBLISH_NOW`, `PUBLISH_DOC_ONLY`, `PLAN_ONLY`, or `SKIP_PUBLICATION`.
8. Use `PUBLISH_NOW` only when recipients are explicit or resolvable and the notification purpose is clear.
9. If recipients are names, emails, or partial identities, resolve them with `lark-contact` when available before sending.
10. Create the main document with `lark-doc`.
11. If the document is created as bot-owned state output, grant the current operating user `full_access` when that identity is resolvable and no memorial rule forbids it.
12. Grant recipient access with `lark-drive permission.members.create` before sending IM.
13. Send IM with `lark-im` only after access is handled or the message explicitly discloses the access limitation.
14. If durable institutional knowledge is intended, recommend or execute `lark-wiki` placement when available.
15. If Lark capability is unavailable, return a precise publication plan instead of pretending publication occurred.
16. Do not send a naked link and do not send to an ambiguous recipient.

## Direct execution sequence

When publication should execute now, follow this order:

1. Verify the public-ready proof source first. If proof is missing or partial, downgrade immediately.
2. Build the publication title and markdown body from the memorial, verdict, ministry findings, evidence, open risks, and next actions.
3. Resolve recipients:
   - use explicit `open_id` values as-is
   - if only names or emails are present, resolve with `lark-contact`
   - if resolution remains ambiguous, downgrade to `PUBLISH_DOC_ONLY` or `PLAN_ONLY`
4. Create the document with `lark-doc`.
5. If the document was created as bot-owned output and the current operator should retain administrative control, resolve the current user and grant `full_access`.
6. For each resolved recipient, grant the required access.
7. Compose the IM message from the template and send it only when the decision is `PUBLISH_NOW`.
8. If wiki placement is required and available, mirror or organize the document accordingly.

## 输出要求

所有内容使用中文，返回以下章节：

## 宣示决定

以下之一：

- `PUBLISH_NOW`
- `PUBLISH_DOC_ONLY`
- `PLAN_ONLY`
- `SKIP_PUBLICATION`

## 宣示理由

说明为什么做出该决定。

## public-ready 证据

说明使用的是哪种证据：

- run artifact
- 结构化输入
- 无法证明

并逐项说明五个 public-ready 条件是否成立。

## 文档方案

说明标题、文档类型和内容来源。

## 收件人解析

列出已解析的收件人、未解析的收件人及处理方式。

## 权限操作

列出已授予的权限，或说明为何未执行权限授予。

## 通知操作

列出已执行的 IM 操作，或说明为何未发送 IM。

## 宣示产出

如已执行，列出 `doc_id`、`doc_url`、知识库位置和消息 ID。

## 未解决的缺口

列出仍阻碍完整宣示的事项。
