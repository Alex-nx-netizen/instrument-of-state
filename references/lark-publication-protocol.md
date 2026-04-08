# Lark Publication Protocol

Use this protocol when any of the following is true:

- the user explicitly asks for Feishu or Lark output
- the work needs cross-team handoff or stakeholder notification
- the memorial calls for a formal summary, release bulletin, incident bulletin, or governance record
- the task runs in Strict or Emergency mode and needs institutional publication

This protocol treats Lark as the state publication and notification system.

Read `lark-publication-templates.md` for templates and decision matrices.
Read `lark-publication-runbook.md` when the publication chain should actually execute.
Read `meta-governance-layer.md` when deciding whether the result is truly ready to be surfaced outward.
Read `run-artifact-protocol.md` when a governed run artifact is available as the proof source.

## Available state instruments

When the current session exposes them, these local skills are the preferred publication stack:

- `lark-doc`
- `lark-drive`
- `lark-im`
- `lark-contact`
- `lark-wiki`

## Publication sequence

1. Determine whether publication is required, optional, or explicitly requested.
2. Check whether the result has cleared the public-ready gate.
3. Require explicit public-ready evidence before any `PUBLISH_NOW` execution.
3. Resolve intended recipients and owners.
4. Create the main Lark document with `lark-doc`.
5. Grant the right Drive permissions with `lark-drive`.
6. Send the notification through `lark-im`.
7. If the artifact is durable institutional knowledge, mirror or organize it in `lark-wiki`.

## Public-ready law

Do not publish outward merely because implementation exists.

Treat outward publication as lawful only when all of the following are true:

- verification passed
- summary is closed
- one primary deliverable is maintained
- the deliverable chain is closed
- a consolidated result exists

The preferred proof source is a governed run artifact with:

- `verificationPacket.verifyPassed == true`
- `summaryPacket.publicReady == true`
- non-empty `publicationPacket.publicReadyEvidence`

If that proof is missing, the publication path must downgrade.

If these conditions are not met, downgrade publication to one of:

- document-only planning
- document draft without notification
- explicit skip with explanation

## Automatic publication triggers

Shangshu should usually treat publication as required when any of these are true:

- the user explicitly asks for Feishu or Lark delivery
- the task is a release, incident, audit, handoff, or governance summary
- the task is in `Strict` or `Emergency` mode and affects multiple parties
- the memorial says the output needs stakeholder notification or institutional record

Shangshu should usually skip publication when the task is purely local and no handoff or external record is needed.

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

## Notification law

The IM message should not be just a naked link. Include:

- what the document is
- why the recipient is receiving it
- the most important conclusion or next action

## Failure handling

If Lark is not configured or the relevant skills are unavailable:

- do not fabricate publication
- return a publication plan instead
- state which step is blocked: identity lookup, document creation, permissioning, notification, or public-ready closure

## Constitutional note

Lark publication is governed by Shangshu and executed through Rites Protocol.
It does not bypass Menxia review, verification, or public-ready law.
