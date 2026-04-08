# Lark Publication Templates

Use these templates when `publish-to-lark` is preparing a document or IM notification.

## Publication decision matrix

Choose one of these outcomes:

- `PUBLISH_NOW`: publication is required and recipients are explicit or resolvable
- `PUBLISH_DOC_ONLY`: a formal document is warranted, but recipient notification is not yet safe or specific enough
- `PLAN_ONLY`: Lark publication is warranted, but identities, permissions, or Lark capability are missing
- `SKIP_PUBLICATION`: the task is local, private, or explicitly marked as not needing external publication

Default to `PUBLISH_NOW` when any of these are true:

- the user explicitly asks to send a Feishu or Lark document
- the user explicitly asks to notify someone in Feishu or Lark
- the task is in `Strict` or `Emergency` mode and affects multiple stakeholders
- the work is a release, incident, handoff, audit summary, or governance record

Default to `PUBLISH_DOC_ONLY` when:

- a formal artifact is needed, but recipients are not explicit
- recipients exist, but their identities are not yet resolved
- the result is not yet proven public-ready enough for `PUBLISH_NOW`

Default to `SKIP_PUBLICATION` when:

- the task is purely local and no handoff or institutional record is needed
- the user explicitly says not to notify or not to publish

## Document title patterns

- Task summary: `State Dispatch | <short task name> | <YYYY-MM-DD>`
- Release note: `Release Dispatch | <service or feature> | <YYYY-MM-DD>`
- Incident bulletin: `Incident Bulletin | <incident name> | <YYYY-MM-DD>`
- Handoff note: `Handoff Memorial | <workstream> | <YYYY-MM-DD>`

## Main document template

Prefer this structure:

```markdown
## Petition Summary

<one paragraph>

## Memorial Summary

- Objective: ...
- Scope: ...
- Mode: ...
- Ministries: ...

## Review Verdict

- Verdict: ...
- Conditions: ...

## Action Taken

- What was delivered, changed, decided, or stabilized

## Evidence and Gates

- Tests:
- Reviews:
- Security or compliance:

## Open Risks

- Residual risk 1
- Residual risk 2

## Next Actions

- Owner:
- Needed follow-up:
```

## Permission matrix

Use these defaults unless the memorial says otherwise:

- direct responsible owner or current operator: `full_access`
- active collaborators who must edit: `edit`
- stakeholders who only need visibility: `view`

For wiki publication, use `perm_type: container` unless the memorial explicitly says the permission should apply only to a single page.

## IM message template

The IM message should be short and decision-oriented:

```markdown
Published: <document title>
- Reason: <why they are receiving this>
- Decision: <most important conclusion or action>
- Link: <doc_url>
```

## Direct execution checklist

Before `publish-to-lark` sends anything externally, confirm:

- the publication decision is not `SKIP_PUBLICATION`
- the result has explicit public-ready evidence
- the recipient is explicit or resolvable
- the sending identity is the bot and that is memorial-authorized or user-requested
- the document exists
- the required permissions were granted or the message explicitly discloses access limitations

## Public-ready evidence block

Prefer passing publication one of these:

```json
{
  "summaryPacket": {
    "publicReady": true
  },
  "verificationPacket": {
    "verifyPassed": true
  },
  "publicationPacket": {
    "publicReadyEvidence": [
      "verificationPacket.verifyPassed",
      "summaryPacket.summaryClosed",
      "summaryPacket.deliverableChainClosed"
    ]
  }
}
```

Or a Chinese summary block:

```markdown
## 校验与公开闸门

- 验证通过：是
- 汇总闭合：是
- 单一交付物保持完整：是
- 交付链闭合：是
- 汇总结果完整可对外说明：是
```

## Safety and delivery notes

- Do not send IM unless the recipient and message purpose are explicit, user-approved, or memorial-authorized.
- Do not send a naked link.
- If permission grant fails, do not silently claim publication succeeded. Report the failure precisely.
