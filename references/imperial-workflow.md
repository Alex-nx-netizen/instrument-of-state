# Imperial Workflow

This file presents `instrument-of-state` in the court-process language:

`decree -> intake -> recon -> draft -> review -> dispatch -> ministries -> return -> publish`

The court model remains the user-facing mental model.
It now sits on top of a hidden meta-governance layer that handles intent lock, gate state, verification closure, and writeback.

Read `constitutional-rules.md` for doctrine.
Read `meta-governance-layer.md` for the hidden control layer.

## What the plugin does

`instrument-of-state` turns a raw request into:

1. a petition
2. a memorial
3. a reviewed order
4. specialist ministry work
5. a unified report
6. and, when needed, an institutional publication

The court surface prevents one unchecked actor from:

- deciding policy
- approving policy
- executing policy
- and then declaring it ready for public display

## Public court, hidden skeleton

The user should mainly see the court.
The plugin should also quietly keep track of:

- whether intent is locked
- whether capability coverage is clear
- whether Works is actually authorized
- whether verification passed
- whether the result is public-ready
- whether the run produced writeback

That hidden skeleton strengthens the court instead of replacing it.

## Stage map

### Stage 1. Emperor Decree

- Meaning: the user submits the petition
- Hidden concern: new petition resets authority and gate state

### Stage 2. Crown Prince Intake

- Meaning: classify the petition and decide whether governed machinery is needed
- Hidden concern: begin task classification and intent discovery

### Stage 3. Jinyiwei Recon

- Meaning: gather evidence and search capability
- Hidden concern: set the initial `capabilityState`

### Stage 4. Zhongshu Draft

- Meaning: turn the petition into a lawful memorial
- Hidden concern: express `intentPacket`, `intentGatePacket`, and `memorialPacket`

### Stage 5. Menxia Review

- Meaning: independent review and verdict
- Hidden concern: produce `reviewPacket` and decide whether Works may unlock

### Stage 6. Shangshu Dispatch

- Meaning: issue the execution order
- Hidden concern: define `dispatchPacket`, owner routing, rollback posture, and publication posture

### Stage 7. Six Ministries

- Meaning: execute only the ministries that are truly needed
- Hidden concern: maintain authority boundaries and evidence discipline during execution

### Stage 8. Memorial Return

- Meaning: return one integrated close-out report
- Hidden concern: close verification, summary, and public-ready gates

### Stage 9. Rites Publication

- Meaning: publish the result outward when needed
- Hidden concern: only outwardly surface results that are actually public-ready

### Stage 10. Hidden Writeback

This is not a new public court office.
It is the continuity action after the visible proceeding:

- store patterns
- store scars
- record capability gaps
- refine doctrine, skills, agents, or contracts if warranted

## Practical recommendation

Do not turn the project into abstract meta jargon on the surface.

The best version is:

- court language for the user
- protocol language for the internals
- hard gates for execution and publication
- durable writeback after meaningful runs
