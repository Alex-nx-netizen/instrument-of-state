# Meta Governance Layer

`instrument-of-state` keeps the court model as the public surface, but governed work now also follows a hidden meta layer underneath it.

This file explains that hidden layer so the plugin can absorb the stronger ideas of protocol-first AI governance without abandoning its own identity.

## Why this layer exists

The court model already provides:

- visible stages
- separation between drafting, review, dispatch, and execution
- lawful execution gates
- institutional publication discipline

What it still needed was a way to answer these questions in machine-shaped terms:

- what exactly was the user's real intent
- what ambiguities were resolved and what is still assumed
- what must be true before something is publicly reportable
- what should be written back after the run so the system gets better over time

This layer answers those questions.

## Design rule

Do not replace the court.

Use the court as the public governance language.
Use the meta layer as the hidden protocol and state skeleton.

In short:

- public surface: petition -> memorial -> verdict -> dispatch -> ministries -> return -> publication
- hidden control: intent packets -> state gates -> verification gates -> writeback decision

## Hidden state skeleton

The readable stage board is not enough on its own.

Under the stage board, governed work should track these state dimensions:

| State | Purpose | Typical values |
| --- | --- | --- |
| `stageState` | canonical progression | `petition`, `draft`, `review`, `delivery`, `publication` |
| `controlState` | reroute rhythm without inventing fake stages | `normal`, `conditional`, `skip`, `interrupt`, `rollback`, `iteration` |
| `gateState` | distinguish visible progress from lawful clearance | `intent_open`, `works_locked`, `verification_open`, `public_ready` |
| `surfaceState` | decide what may be shown outward | `internal_only`, `internal_ready`, `public_ready` |
| `capabilityState` | make capability coverage explicit | `covered`, `partial`, `gap`, `escalated` |
| `authorityState` | record what execution power exists | `draft_only`, `review_only`, `works_unlocked`, `publish_ready` |

The state skeleton is not another user-facing board.
It exists to support gates, interrupts, rollback, and publication decisions.

## Packet-first doctrine

For substantial governed work, the plugin should behave as if the run contains these logical packets:

1. `intentPacket`
2. `intentGatePacket`
3. `memorialPacket`
4. `reviewPacket`
5. `dispatchPacket`
6. `verificationPacket`
7. `summaryPacket`
8. `writebackPacket`

The repository now includes a concrete template at `contracts/run-artifact.template.json`.

Not every tiny task needs a persisted JSON artifact.
But substantial governed runs should now prefer a real run artifact over leaving the packet chain only in chat and markdown.

## Intent packets

### Intent Packet

This packet locks what the work is actually trying to do before heavy execution begins.

It should capture:

- true user intent
- success criteria
- non-goals
- default assumptions

### Intent Gate Packet

This packet decides whether intent is clear enough to proceed.

It should capture:

- whether ambiguities have been resolved
- whether the user still needs to choose among real options
- which assumptions are currently being used as the default path
- which choices are still pending

If the intent gate is still open, the run may draft and explore, but it should not pretend the path is fully settled.

## Public-ready gate

The court already knows when Works may execute.
The meta layer adds a second hard question:

When is the result fit for outward display or publication?

Treat a result as `public_ready` only when all of the following are true:

- verification passed
- summary is closed
- one primary deliverable is still intact
- the deliverable chain is closed
- a consolidated result exists

This matters especially for:

- final user claims that the task is done
- Lark publication
- release or handoff summaries
- incident close-out

## Rollback doctrine

Governance without rollback is incomplete governance.

Use four rollback levels:

1. `file`: isolated regression in one file
2. `subtask`: one task slice broke its own area
3. `partial`: keep successful work, roll back only the failing slice
4. `full`: invalid assumptions or cross-module contamination; return to earlier stages

Rollback is not failure.
Rollback is lawful refusal to make the situation worse.

## Evolution writeback

Every governed run should end with an explicit writeback decision:

- `writeback`: store reusable learning in a durable location
- `none`: explain why no durable writeback is justified

Typical writeback targets live under `memory/` and may also include:

- new or revised references
- adjusted skill law
- updated agent boundaries
- contract refinement

## Court mapping

The court remains the official story shown to the user.
The hidden meta layer maps into it like this:

| Court stage | Hidden meta concern |
| --- | --- |
| Crown Prince Intake | initial task classification and intent discovery |
| Jinyiwei Recon | capability state and evidence gathering |
| Zhongshu | `intentPacket` + `intentGatePacket` + `memorialPacket` |
| Menxia | `reviewPacket` and gate review |
| Shangshu Dispatch | `dispatchPacket`, owner selection, rollback level |
| Ministries | execution under authority and capability constraints |
| Memorial Return | `verificationPacket` + `summaryPacket` |
| Rites Publication | `surfaceState=public_ready` and publication law |
| Post-run close-out | `writebackPacket` |

## Practical rule

If a future change must choose between:

- making the court story clearer to the user, or
- making the hidden protocol stricter and more checkable

the best answer is usually to do both, but never by exposing raw protocol jargon as the main user experience.
