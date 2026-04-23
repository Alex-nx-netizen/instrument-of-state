# Governance Playbook

This playbook defines how `instrument-of-state` should run a governed task now that the project has both:

- a public court workflow
- a hidden meta-governance layer

Read `constitutional-rules.md` for doctrine.
Read `meta-governance-layer.md` for the hidden state and packet model.
Read `evolution-writeback.md` for memory and writeback law.
Read `run-artifact-protocol.md` when you want the packet chain to persist as a governed run artifact.

## Core idea

Do not treat every task as immediate execution.
Treat substantial work as a governed proceeding with:

- a docket
- an intent lock
- a capability ladder
- lawful review and execution gates
- a public-ready gate
- a writeback decision

## Phase 0: Open the docket

For any task that is multi-step, repository-affecting, cross-functional, or likely to need new capability:

1. Invoke `planning-with-files`.
2. Maintain these files as the state docket:
   - `task_plan.md`
   - `findings.md`
   - `progress.md`
3. Treat these as governance artifacts, not delivery artifacts.
4. When the task is substantial, risky, publishable, or multi-ministry, create a governed run artifact by copying `contracts/run-artifact.template.json` into `artifacts/runs/`.

## Phase 1: Lock intent

Before heavy execution, establish the logical contents of:

- `intentPacket`
- `intentGatePacket`

At minimum, lock:

- the true user intent
- success criteria
- non-goals
- default assumptions
- whether ambiguity is resolved enough to proceed
- whether user choice is still required

If the intent gate is still genuinely open, stop at the cleanest decision boundary instead of pretending execution is fully authorized.

## Phase 2: Capability discovery ladder

Before installing anything new, run capability discovery in this order:

1. Project-local skills and plugins
2. User-local skills and plugins
3. Global agents from `~/.claude/agents/`
4. Built-in session capabilities
5. `find-skills`
6. Approved GitHub plugin marketplaces
7. Generic agents only when the above paths do not yield a suitable capability

Record the winning capability, rejected candidates, and the reason in `findings.md`.

## Phase 3: Draft the memorial

Invoke `zhongshu-draft` after the docket and intent lock exist for substantial work.

The memorial should become the authoritative description of:

- objective
- scope
- out-of-scope boundary
- constraints
- risks
- ministries
- mode
- deliverables
- capability needs

The memorial should also carry the user-facing expression of the intent packet and intent gate packet.

## Phase 4: Review the memorial

Invoke `menxia-review` only after a real memorial exists.

Menxia should test:

- whether intent was actually locked
- whether planning was skipped for work that needed it
- whether capability discovery respected the local-first ladder
- whether the route is proportional to the task
- whether publication prerequisites are visible when publication is implied

Only `APPROVE` unlocks governed delivery.

## Phase 5: Dispatch ministries

After approval, Shangshu dispatches the minimum necessary ministries.

The dispatch order should make explicit:

- selected ministries
- owner responsibility
- capability decision
- rollback posture where relevant
- publication posture

When multiple independent domains exist, prefer parallel ministry work over one monolithic execution stream.

## Phase 6: Deliver and verify

If delivery is required, route to `works-delivery`.

During or after delivery:

- `justice-compliance` should define or check evidence
- `progress.md` should reflect major milestones
- verification should happen before any completion claim

For risky work, verification should include:

- evidence gathered
- tests or checks performed
- open findings
- rollback level if execution drifted

## Phase 7: Decide public-ready status

Before any outward-ready summary, release note, or publication:

1. confirm verification has passed
2. confirm summary closure
3. confirm one primary deliverable still exists
4. confirm the deliverable chain is closed
5. confirm a consolidated result exists

If those conditions are not met:

- keep the result internal
- or downgrade to plan-only or document-only publication

When a run artifact exists, record this decision in:

- `verificationPacket`
- `summaryPacket`
- `publicationPacket`

## Phase 8: Publish and hand off

When the result needs institutional communication, cross-team handoff, or user-requested Feishu output:

1. Route through `rites-protocol`.
2. If Lark skills are available, use the publication stack defined in `lark-publication-doctrine.md`.
3. Publish only when the public-ready gate is satisfied, or explicitly downgrade the publication mode.
4. Ensure permissions are granted before or with notification.
5. Notify stakeholders through the appropriate channel.

## Phase 9: Write back what was learned

Every governed run should end with an explicit `writebackDecision`.

When the answer is `writeback`, record durable learning in one or more of:

- `memory/patterns/`
- `memory/scars/`
- `memory/capability-gaps.md`
- `memory/dispatch-patterns.md`
- `references/`
- `skills/`
- `agents/`
- `contracts/workflow-contract.json`

Prefer the templates under `memory/templates/` instead of inventing a new writeback shape from scratch.

## Stage gate summary

- No governed task without a docket for substantial work
- No heavy execution without intent lock
- No Menxia review without a memorial
- No Works Delivery without Menxia `APPROVE`
- No marketplace installation before local-first discovery
- No public-ready claim without verification and summary closure
- No institutional publication link before access and publication gates are addressed
- No governed close-out without a writeback decision
