# Governance Playbook

This playbook defines where official skills and market acquisition belong in the constitution of `instrument-of-state`.

For a user-facing, stage-based explanation of the same process, read `imperial-workflow.md`.
For the mandatory task board shown to users, read `imperial-stage-board.md`.
For auxiliary `superpowers` routing, read `superpowers-integration.md`.
For UI-facing petitions, read `frontend-governance.md`.

## Core idea

Do not treat every task as immediate execution. Treat complex work as a governed proceeding with a case file, a capability ladder, and stage gates.

## Phase 0: Open the docket

For any task that is multi-step, repository-affecting, cross-functional, or likely to need new capability:

1. Invoke `planning-with-files`.
2. Maintain these files as the state docket:
   - `task_plan.md`: current plan, phase, blockers, explicit next step
   - `findings.md`: evidence, repository discoveries, external research, capability matches
   - `progress.md`: execution log, decisions, completed actions
3. Treat these files as governance artifacts, not delivery artifacts. They may be updated before Menxia approval.

This is where the official planning skill belongs: under Shangshu as a mandatory prelude for substantial work.

## Phase 1: Capability discovery ladder

Before installing anything new, run the capability ladder in this order:

1. Project-local skills and plugins
2. User-local skills and plugins
3. Global agents from `~/.claude/agents/` — detect availability, match keywords against the routing table in `global-agent-routing.md`, and register matched agents as ministry reinforcements in the team blueprint
4. Built-in plugin skills already available in the current session
5. `find-skills` for external skill discovery
6. Approved GitHub plugin marketplaces via `instrument-market.cmd`
7. Generic agents only when the above paths do not yield a suitable capability

Record the winning capability, rejected candidates, and the reason in `findings.md`.

This is where the official discovery skill belongs: under Shangshu as a formal capability search step, not as a free-floating tool each ministry uses ad hoc.

When the petition is a failure, bug, or emergency diagnosis task, this phase should also inherit `systematic-debugging` discipline.

When the petition is frontend-visible, this phase should also identify:

- target platform and interface surface
- audience or primary user type
- existing design system or brand constraints
- responsive and accessibility exposure
- whether the task is preservation, extension, or redesign

## Phase 2: Draft the memorial

Invoke `zhongshu-draft` after the docket exists for substantial work. Zhongshu should use:

- the petition
- any relevant repository evidence
- the planning docket if present
- capability findings gathered in Phase 1

The memorial should become the authoritative description of objective, scope, risks, deliverables, ministries, mode, and capability needs.

When the petition is frontend-visible, Zhongshu should also encode:

- the UI surfaces involved
- the experience goal
- the visual or interaction direction
- responsive expectations
- accessibility obligations

## Phase 3: Review the memorial

Invoke `menxia-review` only after a real memorial exists.

Menxia should explicitly test:

- whether the memorial is complete enough to govern
- whether planning was skipped for work that needed it
- whether capability discovery respected the local-first ladder
- whether the execution route is proportional to the task

Only `APPROVE` unlocks governed delivery.

## Phase 4: Dispatch ministries

After approval, Shangshu dispatches the minimum necessary ministries. Ministry routing is based on the memorial plus Menxia amendments.

When multiple independent domains exist, this phase may use `dispatching-parallel-agents` or `subagent-driven-development` rather than one monolithic execution stream.

When the petition is frontend-visible:

- treat `ui-ux-pro-max` plus `frontend-design` as the mandatory paired delivery path when both are available
- route to `works-delivery`
- normally route to `justice-compliance` for accessibility, interaction, and responsive gates
- route to `rites-protocol` when the interface needs formal handoff, screenshots, demos, stakeholder publication, or release communication

## Phase 5: Deliver, verify, and report

If delivery is required, route to `works-delivery`.

- `works-delivery` may land artifacts
- `justice-compliance` defines proof and gates
- `progress.md` should continue to reflect major milestones
- `verification-before-completion` should gate any completion claim
- `requesting-code-review` should be used when the delivery is major, risky, or merge-bound

For frontend-visible delivery, the report should also make clear:

- what visual direction or system was followed
- how accessibility and responsive behavior were checked
- whether the result preserved an existing design language or introduced a new one deliberately

## Phase 6: Publish and hand off

When the result needs institutional communication, cross-team handoff, or user-requested Feishu output:

1. Route through `rites-protocol`.
2. If Lark skills are available, use the publication stack defined in `lark-publication-protocol.md`.
3. Publish the memorial result in the right form: document, bulletin, handoff note, or knowledge-base entry.
4. Ensure permissions are granted before or with notification.
5. Notify stakeholders through the appropriate channel.
6. Choose the close-out state explicitly: `PUBLISH_NOW`, `PUBLISH_DOC_ONLY`, `PLAN_ONLY`, or `SKIP_PUBLICATION`.

This is where the Feishu or Lark workflow belongs: under Rites and Shangshu close-out, not scattered across the ministries.

## Capability acquisition law

Search may happen before review. Installation should happen only when:

1. the memorial justifies the capability,
2. Menxia has approved the proceeding or the condition explicitly allows acquisition, and
3. the source is local, trusted, or an approved GitHub marketplace.

Prefer the narrowest install scope that satisfies the memorial:

- `project` for task-specific or repo-specific capability
- `local` for workspace-scoped tools
- `user` only when the capability is broadly reusable

## Stage gate summary

- No governed task without a docket for substantial work
- No Menxia review without a memorial
- No Works Delivery without Menxia `APPROVE`
- No marketplace installation before local-first discovery
- No non-Works file landing except planning artifacts
- No institutional publication link should be sent before access is handled or explicitly called out
