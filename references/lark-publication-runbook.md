# Lark Publication Runbook

Use this runbook when `publish-to-lark` is executing a real Feishu or Lark publication chain.

This file turns the publication protocol into an operator sequence that can be run directly with the local Lark stack.

## Preconditions

Publication may execute only when all of these are true:

- the memorial, Menxia verdict, and ministry outputs are clear enough to publish
- the publication decision is `PUBLISH_NOW` or `PUBLISH_DOC_ONLY`
- the recipient, message purpose, and bot-sender identity are explicit, memorial-authorized, or directly requested by the user
- explicit public-ready evidence exists

Preferred public-ready evidence:

- a governed run artifact with `summaryPacket.publicReady == true`
- `verificationPacket.verifyPassed == true`
- non-empty `publicationPacket.publicReadyEvidence`

Downgrade to `PLAN_ONLY` when identity resolution, permissions, or tool access are incomplete.
Downgrade to `PLAN_ONLY` or `PUBLISH_DOC_ONLY` when public-ready evidence is incomplete.

## Execution ladder

Follow this sequence in order.

### 1. Resolve the publication decision

- `PUBLISH_NOW`: create the document, grant permissions, and notify recipients
- `PUBLISH_DOC_ONLY`: create the document and grant the minimum safe permissions, but do not send IM
- `PLAN_ONLY`: return the exact plan and blocker
- `SKIP_PUBLICATION`: do nothing external

Before choosing `PUBLISH_NOW`, confirm that the public-ready proof source is explicit and complete.

### 2. Resolve recipients

If the user already supplied `open_id` values, use them directly.

If the user supplied names, email addresses, or partial identifiers, resolve them first:

```bash
lark-cli contact +search-user --query "<name or email>"
```

If the publication should also remain manageable by the current human operator after bot creation, resolve the current user:

```bash
lark-cli contact +get-user
```

If more than one plausible recipient is returned and the memorial does not disambiguate, downgrade to `PUBLISH_DOC_ONLY` or `PLAN_ONLY`.

### 3. Create the main document

Create the document with a title and markdown body derived from the memorial, verdict, ministry results, evidence, risks, and next actions:

```bash
lark-cli docs +create --title "<title>" --markdown "<markdown body>"
```

Capture at least:

- `doc_id`
- `doc_url`

If a wiki node or wiki space is explicitly part of the close-out, create there instead:

```bash
lark-cli docs +create --title "<title>" --wiki-node <wiki_token> --markdown "<markdown body>"
```

### 4. Grant permissions before notification

If the document was created as the bot, grant the current operating user `full_access` when that identity is resolvable and the memorial does not forbid it.

Then grant recipients according to the access matrix:

- direct owner or operator: `full_access`
- active collaborator: `edit`
- visibility-only stakeholder: `view`

Command pattern:

```bash
lark-cli drive permission.members create --as bot \
  --params '{"token":"<doc_id>","type":"docx"}' \
  --data '{"member_id":"<open_id>","member_type":"openid","type":"user","perm":"<view|edit|full_access>"}'
```

If permission grant fails for a recipient, do not silently continue as though publication succeeded.

### 5. Send IM only after access is safe

If the decision is `PUBLISH_NOW`, send IM only after one of these is true:

- permission grant succeeded
- the message explicitly says access is still pending

Preferred direct message pattern:

```bash
lark-cli im +messages-send --as bot --user-id <open_id> --markdown "<message>"
```

Group-chat pattern:

```bash
lark-cli im +messages-send --as bot --chat-id <chat_id> --markdown "<message>"
```

The IM must say:

- what the document is
- why the recipient is receiving it
- the main conclusion or requested next action
- the document link

### 6. Place durable records in wiki when required

If the close-out is meant to become institutional knowledge, mirror or place it under the approved wiki location.

Use `lark-wiki` when available; otherwise return the exact wiki placement plan.

## Downgrade rules

Downgrade from `PUBLISH_NOW` when any of these occur:

- public-ready evidence is missing or partial
- recipient identity is ambiguous
- the operator cannot determine whether bot identity is acceptable
- permission grant fails and the user did not authorize a send-with-warning path
- the Lark stack is unavailable in the current environment

Downgrade target:

- to `PUBLISH_DOC_ONLY` when the document exists but notification is not yet safe
- to `PLAN_ONLY` when even document creation cannot be completed safely

## Recording requirements

When execution occurs, report:

- resolved recipients
- permissions granted
- `doc_id`
- `doc_url`
- message IDs when IM is sent
- wiki location when used

When execution does not occur, report the blocker precisely instead of claiming success.
