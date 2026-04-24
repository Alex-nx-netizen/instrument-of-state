<div align="center">

# iostate / Governed Execution Plugin for Claude Code

[![English](https://img.shields.io/badge/Docs-English-1f6feb?style=for-the-badge)](./README.md)
[![中文文档](https://img.shields.io/badge/Docs-%E4%B8%AD%E6%96%87-0f766e?style=for-the-badge)](./README.zh-CN.md)
[![Claude Code Plugin](https://img.shields.io/badge/Claude%20Code-Plugin-7c3aed?style=for-the-badge)](https://docs.claude.com/en/docs/claude-code/plugins)
[![Governed Execution](https://img.shields.io/badge/Governed-Execution-0ea5e9?style=for-the-badge)](#what-this-project-is)

[![version](https://img.shields.io/badge/version-0.7.0-2563eb)](./.claude-plugin/plugin.json)
[![license](https://img.shields.io/badge/license-Apache--2.0-green.svg)](./LICENSE)
[![platform](https://img.shields.io/badge/platform-Claude%20Code-7c3aed)](https://docs.claude.com/en/docs/claude-code/plugins)
[![status](https://img.shields.io/badge/status-stable%20(v0.7.0)-0ea5e9)](./artifacts/dockets/2026-04-24-v0.7.0-cutover/progress.md)

[![last commit](https://img.shields.io/github/last-commit/Alex-nx-netizen/instrument-of-state?color=blue)](https://github.com/Alex-nx-netizen/instrument-of-state/commits/main)
[![issues](https://img.shields.io/github/issues/Alex-nx-netizen/instrument-of-state?color=orange)](https://github.com/Alex-nx-netizen/instrument-of-state/issues)

</div>

**A governed execution plugin for Claude Code.** Split one session into six auditable gates: draft → review → dispatch → deliver → verify → publish. Every gate carries an intent packet, entry conditions, evidence requirements, and a rollback level; any out-of-order execution is hard-blocked at the hook layer.

**What it solves**

- Turns "I ask the AI to do the work" into "I can hold the AI accountable at every step"
- Surfaces four silent failure modes to the gate layer: fuzzy intent, scope drift, skipped review, unverified code-change
- Visibility first: stage board, tool trace, and hook logs are all transparent

**Core capabilities**

- **Intent gate**: heavy execution requires a locked intent packet + intent gate packet
- **Minimum-authority rule**: only the Deliver office may land governed file changes (planning artifacts excepted)
- **Capability ladder**: local skills → `find-skills` → approved marketplaces, every step recorded
- **Public-ready law**: verification pass ≠ publication right; publish is an independent gate
- **Falsifiable acceptance**: Verify demands an evidence chain, not a self-claimed "done"

**30-second speed-run:** `/iostate:draft` → `/iostate:review` → `/iostate:dispatch` → `/iostate:deliver` → `/iostate:verify` → `/iostate:publish`

### Who is this for?

- Teams using Claude Code where multi-file, cross-role, or publishable work must survive an audit later.
- Individual engineers who want a visible process (stage board, tool trace) instead of one opaque AI pass.
- Maintainers of production repos where "AI declared done" is not enough — evidence and gate passage are required.
- Authors preparing outward-facing artifacts (Lark/Feishu docs, releases) that must clear a public-ready gate before leaving the session.

### Toolbox (agents, skills, doctrines)

| Kind | Name | Role |
|---|---|---|
| agent | draft / review / dispatch / deliver / verify / publish / allocate / emergency | Office boundaries |
| skills (commands) | draft, review, dispatch, deliver, verify, publish, allocate, emergency | Governed execution entrypoints |
| skills (visibility) | stage-board, tool-trace | Answer "where am I / what was used" |
| doctrine | meta-unit, cadence, deal-card, ux-response, lark-publication, constitutional-rules | Internal rules |

### When to use

- Multi-file or cross-role work that needs draft -> review -> deliver discipline.
- Any task that must publish to Lark only after a `public-ready` gate.
- Sessions where visibility (stage board, tool trace) matters more than raw speed.

---

## What's new in v0.7.0 (Breaking)

v0.7.0 is a hard cutover. The plugin itself is renamed and all legacy command names are removed.

- Plugin name: `instrument-of-state` -> `iostate`
- Commands: classical 古风 names (`zhongshu-draft`, `menxia-review`, `shangshu-dispatch`, `works-delivery`, `justice-compliance`, `publish-to-lark`, `resource-allocator`, `war-operations`) are fully removed. Use the verb-form commands below.
- Migration: users on v0.6.x must `/plugin uninstall instrument-of-state` and then `/plugin install iostate` from the marketplace.

What is preserved: the Three Departments + Six Ministries mental model, the meta-governance layer, verdict semantics, scar/pattern templates, run artifact shape.

---

## What Problem It Solves

Most AI coding sessions still compress complex work into one unchecked pass:

- infer the intent
- plan on the fly
- implement immediately
- declare completion

That may be fast, but it is fragile for real repository work, especially when the task spans files, roles, risk, review, and publication.

---

## What This Project Is

`iostate` is a **Claude Code plugin bundle** for governed execution.

It keeps the public mental model of the **Three Departments and Six Ministries**, while layering a stronger **meta-governance core** underneath it (元 / 组织镜像 / 节奏 / 意图放大 + 发牌):

- draft produces the memorial
- review issues the verdict that gates execution
- dispatch routes the right ministries
- deliver cannot land governed changes before approval
- publication is gated separately from execution
- meaningful runs can persist artifacts and write durable learning back into memory

This is a plugin bundle, not a single skill.

---

## What It Is NOT

- Not a standalone runtime or process — it is a Claude Code plugin that layers governance onto your existing session.
- Not a single skill — it is a bundle of 10 skills + 8 agents + guard hooks + contracts.
- Not a code generator — it is a discipline layer that makes existing AI execution auditable.
- Not a replacement for human review — it is a structure that makes human review enforceable.
- Not coupled to any one LLM — it is bound to Claude Code as the host, but the governance shape is model-agnostic.

---

## Architecture

### Public layer: the court workflow

This is what users see:

`Decree -> Intake -> Recon -> Draft -> Review -> Dispatch -> Ministries -> Return -> Publish`

### Hidden layer: the meta-governance core

This is what keeps the workflow stricter internally:

- intent lock before heavy execution (10-field intentPacket v2: declaration + amplification)
- hidden governance state and gate tracking
- explicit `public-ready` checks before outward publication
- `skipPolicy` + `preemptPolicy` cadence gates (skip / preempt require explicit evidence)
- governed run artifacts in JSON for packet-chain closure
- evolution writeback into `memory/`
- a protocol-first contract in `contracts/workflow-contract.json`

The goal is to keep the user experience readable while making the underlying governance more rigorous and reusable.

---

## Court Workflow

| Stage | Office | What it does |
| --- | --- | --- |
| 1 | Emperor Decree | User submits the petition |
| 2 | Crown Prince Intake | Classifies mode, scope, and escalation |
| 3 | Jinyiwei Recon | Opens the docket, gathers evidence, and searches capability |
| 4 | Draft (classical: 中书省) | Drafts the memorial and locks intent |
| 5 | Review (classical: 门下省) | Reviews the memorial and clears or blocks execution |
| 6 | Dispatch (classical: 尚书省) | Dispatches the right ministries |
| 7 | Six Ministries | Execute only what is needed |
| 8 | Memorial Return | Integrates results, verification, and closure |
| 9 | Publication | Publishes to Lark only when lawful |

<div align="center">
  <img src="./assets/readme/workflow.svg" alt="Imperial workflow diagram" width="920" />
</div>

---

## Quick Start

```text
/plugin marketplace add Alex-nx-netizen/instrument-of-state
/plugin install iostate
```

Then run:

```text
/iostate:dispatch Refactor auth and keep a visible stage board.
```

---

## Main Commands

| Command | Purpose |
| --- | --- |
| `/iostate:draft <task>` | Draft memorial, lock intent |
| `/iostate:review` | Review verdict |
| `/iostate:dispatch <task>` | Main governed workflow entrypoint |
| `/iostate:deliver` | Deliver approved work (approval-gated) |
| `/iostate:verify` | Evidence, tests, acceptance gates |
| `/iostate:publish` | Lark publication (public-ready gate) |
| `/iostate:allocate` | Resource allocation (two modes) |
| `/iostate:emergency` | Incident / preempt |
| `/iostate:stage-board` | Visibility: current stage + gate state |
| `/iostate:tool-trace` | Visibility: replay invocation timeline |

Example petitions:

```text
/iostate:dispatch Investigate the login outage, stabilize production, and prepare a formal handoff note.
/iostate:dispatch Redesign the pricing page with a strong visual direction and preserve accessibility.
/iostate:dispatch Audit the release checklist and publish a Feishu handoff document.
```

---

## What It Includes

| Component | Purpose |
| --- | --- |
| `skills/` | 8 canonical skills (draft, review, dispatch, deliver, verify, publish, allocate, emergency) + 2 visibility skills (stage-board, tool-trace) |
| `agents/` | 8 agents matching the skill namespace (draft-agent, review-agent, dispatch-agent, deliver-agent, verify-agent, publish-agent, allocate-agent, emergency-agent) |
| `hooks/` | Governance enforcement such as blocking deliver before review approval |
| `bin/` | Guard and marketplace helper scripts |
| `contracts/` | Structured governance contracts for packets, gates, rollback, `skipPolicy`, `preemptPolicy`, and `public-ready` rules |
| `artifacts/runs/` | Persisted governed run artifacts for auditable packet-chain closure |
| `memory/` | Durable writeback for patterns, scars, dispatch knowledge, and capability gaps |
| `memory/templates/` | Copy-ready writeback templates for patterns, scars, dispatch lessons, and writeback packets |
| `references/` | Constitution, doctrines (meta-unit / cadence / deal-card / ux-response / lark-publication), playbooks, workflow docs, run-artifact protocol, and meta-governance notes |
| `.claude-plugin/plugin.json` | Plugin manifest |
| `.claude-plugin/marketplace.json` | Marketplace catalog manifest |

---

## Capability Map

### Directory map

| Layer | Directory | Role in the system | Position in the governance chain |
| --- | --- | --- | --- |
| Plugin entry | `/.claude-plugin` | Plugin identity, install surface, marketplace metadata | Session/bootstrap entry |
| Office definitions | `/agents` | Defines the office boundaries and agent roles | Maps to each court office |
| Workflow execution | `/skills` | Defines the executable workflow behavior | Runs the visible court process |
| Guard runtime | `/bin` | Tracks state, enforces gates, blocks unlawful tool usage | Hard enforcement layer |
| Hook wiring | `/hooks` | Connects Claude lifecycle events to the guard | Session start, subagent start/stop, pre-tool checks |
| Contract layer | `/contracts` | Defines packets, states, gates, rollback, and writeback law | Hidden meta-governance skeleton |
| Run artifacts | `/artifacts/runs` | Persists governed runs as auditable JSON artifacts | Packet-chain closure for substantial work |
| Memory | `/memory` | Stores durable patterns, scars, dispatch lessons, and gaps | Evolution/writeback layer |
| Writeback templates | `/memory/templates` | Ready-to-use templates for post-run capture | Writeback execution support |
| Doctrine | `/references` | Constitution, doctrines, playbooks, publication law, run-artifact protocol | Rules for every stage |
| Presentation assets | `/assets` | README visuals and supporting media | Documentation/display only |

### Skill map

| Skill | Office | Main responsibility | Governance position | Main packet/gate it shapes |
| --- | --- | --- | --- | --- |
| `dispatch` | Dispatch (尚书) | Orchestrates the full governed run and close-out | Intake, dispatch, integration, close-out | `dispatchPacket`, `summaryPacket`, `writebackPacket` |
| `draft` | Draft (中书) | Drafts the memorial and locks intent | Draft | `intentPacket` (10 fields), `intentGatePacket`, `memorialPacket` |
| `review` | Review (门下) | Reviews the memorial and decides execution authority | Review | `reviewPacket`, review_ready, deliver_unlock |
| `deliver` | Deliver (工部) | Executes approved implementation work | Delivery | write authority, evidence input |
| `verify` | Verify (刑部) | Defines or checks evidence, tests, and acceptance gates | Verification | `verificationPacket`, `public_ready` |
| `publish` | Publish (礼部) | Executes document, permission, and IM delivery to Lark | Publication | `publicationPacket`, `public_ready` proof |
| `allocate` | Allocate (吏户) | Ownership routing and cost/scope shaping (two modes) | Dispatch support | owner assignments, dispatch shaping |
| `emergency` | Emergency (兵部) | Handles incidents, rollback posture, and emergency routing | Emergency mode | rollback posture, preempt |
| `stage-board` | Visibility | Shows current stage / gate state / used agents / remaining unlocks | Visibility | read-only |
| `tool-trace` | Visibility | Replays agent/skill/tool calls within the docket | Visibility | read-only |

### Gate map

| Gate | Source | What must be true | What it blocks |
| --- | --- | --- | --- |
| review_ready | `workflow-contract.json` | `intentPacket`, `intentGatePacket`, and `memorialPacket` exist | Review before a real memorial |
| deliver_unlock | contract + guard | `reviewPacket.verdict == APPROVE` | Deliver agent start, file writes, mutating commands |
| Non-deliver write gate | `instrument-guard.ps1` | Only planning artifacts are exempt | File writes by non-deliver actors |
| intent_locked | guard state | Draft output includes the intent sections | Heavy execution on hidden assumptions |
| `skipPolicy` | contract | Skip requires explicit evidence fields (skip_reason, skip_authorized_by, skip_scope) | Silent stage skipping |
| `preemptPolicy` | contract | P0/P1 incident triggers + mandatory post-memorial within 24h | Preempt without audit |
| `public_ready` | contract | verification passed, summary closed, deliverable intact, chain closed, consolidated result present | Outward-ready claims and publishability |
| `lark_publication` | contract | `public_ready` plus explicit publication evidence and access readiness | Direct publication path |
| Lark IM notify gate | guard runtime | Latest run artifact proves `publicReady` and contains `publicReadyEvidence` | `lark-cli im +messages-send` |
| `writebackDecision` | doctrine + templates | Explicit `writeback` or `none` close-out posture | Meaningless or incomplete closure |

---

## Key Features

- **Visible stage board**: full stage board at kickoff and close-out, compact progress digests in between; `/iostate:stage-board` + `/iostate:tool-trace` answer "where am I / what was used"
- **Intent lock (10 fields)**: substantial work captures intent (declaration + amplification) before heavy execution
- **Guarded delivery**: Deliver stays blocked until Review returns `APPROVE`
- **Cadence gates**: `skipPolicy` + `preemptPolicy` make skip/preempt explicit and auditable
- **Run artifacts**: governed runs can persist the packet chain as JSON instead of leaving it only in chat
- **Public-ready gate**: implementation completion does not automatically mean it is ready to publish or announce
- **Publication hard gate**: `publish` requires explicit `public-ready` proof and the guard can block unsafe Lark IM sends
- **Local-first capability search**: local skills/plugins -> global agents -> `find-skills` -> marketplace
- **Lark publication**: the publish office can create docs, grant access, send IM, and publish to Wiki
- **Evolution writeback**: durable patterns, scars, dispatch lessons, and capability gaps can be written back after meaningful runs
- **Frontend governance**: UI work discovers the best frontend tools through the capability ladder

---

## Run Artifacts

For substantial, risky, multi-ministry, or publishable work, the project now supports a governed run artifact:

- template: `contracts/run-artifact.template.json`
- protocol: `references/run-artifact-protocol.md`
- suggested storage: `artifacts/runs/<YYYY-MM-DD>-<slug>.json`

The run artifact captures:

- `intentPacket`
- `intentGatePacket`
- `memorialPacket`
- `reviewPacket`
- `dispatchPacket`
- `verificationPacket`
- `summaryPacket`
- `publicationPacket`
- `writebackPacket`

This makes the hidden meta layer inspectable after the chat ends.

---

## Publication and Lark

When formal communication is needed, the publish office can:

1. create the document
2. grant access
3. send IM
4. archive to Wiki

Publication now observes a strict `public-ready` gate, so the project can distinguish:

- approved to execute
- complete enough to verify
- safe to present outward

`publish` prefers a governed run artifact as the proof source, and the guard can deny `lark-cli im +messages-send` if the latest run artifact does not prove public-ready closure.

<div align="center">
  <img src="./assets/readme/publication-chain.svg" alt="Lark publication chain" width="920" />
</div>

---

## Memory and Writeback

The project now treats writeback as a concrete close-out action rather than a vague reminder.

Use:

- `memory/templates/pattern-template.md`
- `memory/templates/scar-template.md`
- `memory/templates/dispatch-pattern-template.md`
- `memory/templates/capability-gap-entry-template.md`
- `memory/templates/writeback-packet.template.json`

This keeps post-run learning durable and reusable.

---

## Frontend Rule

For UI-facing work, this plugin requires two categories of frontend capability:

- **UX structure**: accessibility, responsive behavior, layout logic, interaction quality
- **Visual design**: art direction, typography, composition, motion, anti-generic output

These capabilities are discovered dynamically through the capability ladder, not hardcoded to specific skill names.

---

## References

- [Chinese README](./README.zh-CN.md)
- [Constitution](./references/constitutional-rules.md)
- [Governance Playbook](./references/governance-playbook.md)
- [Meta-Unit Doctrine](./references/meta-unit-doctrine.md)
- [Cadence Doctrine](./references/cadence-doctrine.md)
- [Deal-Card Doctrine](./references/deal-card-doctrine.md)
- [UX Response Doctrine](./references/ux-response-doctrine.md)
- [Meta Governance Layer](./references/meta-governance-layer.md)
- [Evolution Writeback](./references/evolution-writeback.md)
- [Run Artifact Protocol](./references/run-artifact-protocol.md)
- [Lark Publication Doctrine](./references/lark-publication-doctrine.md)
- [Frontend Governance](./references/frontend-governance.md)
- [Workflow Contract](./contracts/workflow-contract.json)
- [Run Artifact Template](./contracts/run-artifact.template.json)

---

<div align="center">
Built for governed execution, visible process, lawful publication, auditable run closure, and durable learning.
</div>
