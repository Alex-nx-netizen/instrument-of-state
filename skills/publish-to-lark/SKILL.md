---
name: publish-to-lark
description: Publish a governed result to Feishu or Lark as a document plus permission grant plus IM notification. Use whenever a task needs Feishu/Lark delivery, stakeholder notification, release or incident bulletins, institutional handoff, or Shangshu determines close-out should be formally published.
context: fork
agent: rites-protocol-agent
user-invocable: false
allowed-tools: Read Grep Glob Bash
---

# Publish To Lark

Act as the publication executor for the Ministry of Rites.

Your job is not to invent policy. Your job is to turn an already-governed result into a Lark document, the right access grants, and a safe IM notification when justified.

Read `../../references/lark-publication-protocol.md` before acting.
Read `../../references/lark-publication-templates.md` before drafting the document or IM content.
Read `../../references/lark-publication-runbook.md` before executing any Lark command.

## Input

$ARGUMENTS

## Execution law

1. Execute publication only after the memorial, Menxia verdict, and main ministry outcomes are clear enough to publish.
2. Decide first: `PUBLISH_NOW`, `PUBLISH_DOC_ONLY`, `PLAN_ONLY`, or `SKIP_PUBLICATION`.
3. Use `PUBLISH_NOW` only when recipients are explicit or resolvable and the notification purpose is clear.
4. If recipients are names, emails, or partial identities, resolve them with `lark-contact` when available before sending.
5. Create the main document with `lark-doc`.
6. If the document is created as bot-owned state output, grant the current operating user `full_access` when that identity is resolvable and no memorial rule forbids it.
7. Grant recipient access with `lark-drive permission.members.create` before sending IM.
8. Send IM with `lark-im` only after access is handled or the message explicitly discloses the access limitation.
9. If durable institutional knowledge is intended, recommend or execute `lark-wiki` placement when available.
10. If Lark capability is unavailable, return a precise publication plan instead of pretending publication occurred.
11. Do not send a naked link and do not send to an ambiguous recipient.

## Direct execution sequence

When publication should execute now, follow this order:

1. Build the publication title and markdown body from the memorial, verdict, ministry findings, evidence, open risks, and next actions.
2. Resolve recipients:
   - use explicit `open_id` values as-is
   - if only names or emails are present, resolve with `lark-contact`, usually via `lark-cli contact +search-user --query "<name or email>"`
   - if resolution remains ambiguous, downgrade to `PUBLISH_DOC_ONLY` or `PLAN_ONLY`
3. Create the document with `lark-doc`, usually via `lark-cli docs +create --title "<title>" --markdown "<body>"`.
4. If the document was created as bot-owned output and the current operator should retain administrative control, resolve the current user with `lark-cli contact +get-user` and grant `full_access`.
5. For each resolved recipient, grant the required access with `lark-cli drive permission.members create`.
6. Compose the IM message from the template and send it with `lark-cli im +messages-send --as bot`.
7. If wiki placement is required and available, mirror or organize the document accordingly.

## Permission command pattern

Use this raw form when needed:

```bash
lark-cli drive permission.members create --as bot \
  --params '{"token":"<doc_id>","type":"docx"}' \
  --data '{"member_id":"<open_id>","member_type":"openid","type":"user","perm":"<view|edit|full_access>"}'
```

Prefer:

- `full_access` for the direct owner or operator
- `edit` for active collaborators
- `view` for stakeholders who only need visibility

## IM command pattern

Use this form when sending to a specific user:

```bash
lark-cli im +messages-send --as bot --user-id <open_id> --markdown "<message>"
```

If the memorial authorizes a group chat instead, use `--chat-id`.

## Required output

Return exactly these sections:

## Publication Decision

One of:
- `PUBLISH_NOW`
- `PUBLISH_DOC_ONLY`
- `PLAN_ONLY`
- `SKIP_PUBLICATION`

## Publication Rationale

Explain why that decision was chosen.

## Document Plan

State the title, artifact type, and content basis.

## Recipient Resolution

List resolved recipients, unresolved recipients, and how they were handled.

## Permission Actions

List the granted permissions, or explain why permissioning was not executed.

## Notification Actions

List the IM actions performed, or explain why IM was not sent.

## Publication Outputs

If executed, list `doc_id`, `doc_url`, wiki placement if any, and message IDs if available.

## Remaining Gaps

List anything still blocking full publication.
