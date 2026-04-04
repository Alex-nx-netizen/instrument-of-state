# Lark Publication Protocol

Use this protocol when any of the following is true:

- the user explicitly asks for Feishu or Lark output
- the work needs cross-team handoff or stakeholder notification
- the memorial calls for a formal summary, release bulletin, incident bulletin, or governance record
- the task runs in Strict or Emergency mode and needs institutional publication

This protocol treats Lark as the state publication and notification system.

Read `lark-publication-templates.md` when you need the decision matrix, document template, permission matrix, or IM message shape.
Read `lark-publication-runbook.md` when the publication chain should actually execute.

## Available state instruments

When the current session exposes them, these local skills are the preferred publication stack:

- `lark-doc`: create or update the primary document
- `lark-drive`: grant permissions and manage document access
- `lark-im`: notify recipients with the document and action summary
- `lark-contact`: resolve recipients, owners, or stakeholder identities
- `lark-wiki`: publish durable knowledge-base entries when the output should live beyond the task

## Publication sequence

1. Determine whether publication is required, optional, or explicitly requested.
2. Resolve intended recipients and owners. If identities are unclear and `lark-contact` is available, use it.
3. Create the main Lark document with `lark-doc`.
4. Grant the right Drive permissions with `lark-drive`. Do not assume recipients already have access.
5. Send the notification through `lark-im`.
6. If the artifact is durable institutional knowledge, mirror or organize it in `lark-wiki`.

When execution is real rather than merely planned, follow the exact sequencing in `lark-publication-runbook.md`.

## Automatic publication triggers

Shangshu should treat publication as required when any of these are true:

- the user explicitly asks for Feishu or Lark delivery
- the task is a release, incident, audit, handoff, or governance summary
- the task is in `Strict` or `Emergency` mode and affects multiple parties
- the memorial says the output needs stakeholder notification or institutional record

Shangshu should usually skip publication when the task is purely local and no handoff or external record is needed.

If publication is warranted but recipients are not explicit enough, create the document or plan first and stop short of IM notification.

## Required content for the main document

The main publication should usually include:

- petition or task summary
- memorial summary
- Menxia verdict
- what was changed or decided
- evidence, tests, or review gates
- open risks and next actions
- owners or recipients where relevant

## Permission law

Do not send a notification with a document link unless the intended readers have access or the message explicitly warns that access still needs to be granted.

Permission scope should match the memorial:

- direct collaborators: editor or full access where justified
- informed stakeholders: view or comment access
- broad institutional record: wiki or shared folder placement

## Notification law

The IM message should not be just a naked link. Include:

- what the document is
- why the recipient is receiving it
- the most important conclusion or next action

If recipient, content purpose, or sending identity is ambiguous, stop and return a publication plan rather than sending.

## Failure handling

If Lark is not configured or the relevant skills are unavailable:

- do not fabricate publication
- return a publication plan instead
- state which step is blocked: identity lookup, document creation, permissioning, or notification

## Constitutional note

Lark publication is governed by Shangshu and executed through Rites Protocol. It does not bypass Menxia review for governed delivery.
