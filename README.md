<div align="center">

# Instrument of State

[![English](https://img.shields.io/badge/Docs-English-1f6feb?style=for-the-badge)](./README.md)
[![中文文档](https://img.shields.io/badge/Docs-%E4%B8%AD%E6%96%87-0f766e?style=for-the-badge)](./README.zh-CN.md)

**Govern Claude Code before it governs your repo.**

![Plugin](https://img.shields.io/badge/Claude_Code-Plugin-1f6feb?style=flat-square)
![Workflow](https://img.shields.io/badge/Workflow-14%20Stages-0f766e?style=flat-square)
![Agents](https://img.shields.io/badge/Agents-9-7c3aed?style=flat-square)
![Skills](https://img.shields.io/badge/Skills-10-2563eb?style=flat-square)
![Hooks](https://img.shields.io/badge/Hooks-Guarded-c2410c?style=flat-square)
![Lark](https://img.shields.io/badge/Lark-Ready-0891b2?style=flat-square)

<img src="./assets/readme/hero.svg" alt="Instrument of State hero" width="820" />

</div>

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

`instrument-of-state` is a **Claude Code plugin bundle** for governed execution.

It keeps the public mental model of the **Three Departments and Six Ministries**, while layering a stronger **meta-governance core** underneath it:

- Zhongshu drafts the memorial
- Menxia reviews and gates execution
- Shangshu dispatches the right ministries
- Works cannot land governed changes before approval
- publication is gated separately from execution
- meaningful runs can persist artifacts and write durable learning back into memory

This is a plugin bundle, not a single skill.

---

## Architecture

### Public layer: the court workflow

This is what users see:

`Decree -> Intake -> Recon -> Draft -> Review -> Dispatch -> Ministries -> Return -> Publish`

### Hidden layer: the meta-governance core

This is what keeps the workflow stricter internally:

- intent lock before heavy execution
- hidden governance state and gate tracking
- explicit `public-ready` checks before outward publication
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
| 4 | Zhongshu | Drafts the memorial and locks intent |
| 5 | Menxia | Reviews the memorial and clears or blocks execution |
| 6 | Shangshu | Dispatches the right ministries |
| 7 | Six Ministries | Execute only what is needed |
| 8 | Memorial Return | Integrates results, verification, and closure |
| 9 | Rites Publication | Publishes to Lark only when lawful |

<div align="center">
  <img src="./assets/readme/workflow.svg" alt="Imperial workflow diagram" width="920" />
</div>

---

## Quick Start

```text
/plugin marketplace add Dick1109/instrument-of-state
/plugin install instrument-of-state
```

Then run:

```text
/instrument-of-state:shangshu-dispatch Refactor auth and keep a visible stage board.
```

---

## Main Command

| Command | Purpose |
| --- | --- |
| `/instrument-of-state:shangshu-dispatch <task>` | Main governed workflow entrypoint |

Example petitions:

```text
/instrument-of-state:shangshu-dispatch Investigate the login outage, stabilize production, and prepare a formal handoff note.
/instrument-of-state:shangshu-dispatch Redesign the pricing page with a strong visual direction and preserve accessibility.
/instrument-of-state:shangshu-dispatch Audit the release checklist and publish a Feishu handoff document.
```

---

## What It Includes

| Component | Purpose |
| --- | --- |
| `skills/` | Workflow skills such as `shangshu-dispatch`, `zhongshu-draft`, `menxia-review`, `works-delivery`, and `publish-to-lark` |
| `agents/` | Shangshu, Zhongshu, Menxia, Justice, Works, Rites, and other offices |
| `hooks/` | Governance enforcement such as blocking Works before Menxia approval |
| `bin/` | Guard and marketplace helper scripts |
| `contracts/` | Structured governance contracts for packets, gates, rollback, and `public-ready` rules |
| `artifacts/runs/` | Persisted governed run artifacts for auditable packet-chain closure |
| `memory/` | Durable writeback for patterns, scars, dispatch knowledge, and capability gaps |
| `memory/templates/` | Copy-ready writeback templates for patterns, scars, dispatch lessons, and writeback packets |
| `references/` | Constitution, playbooks, workflow docs, publication law, run-artifact protocol, and meta-governance notes |
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
| Doctrine | `/references` | Constitution, playbooks, publication law, run-artifact protocol | Rules for every stage |
| Presentation assets | `/assets` | README visuals and supporting media | Documentation/display only |

### Skill map

| Skill | Office | Main responsibility | Governance position | Main packet/gate it shapes |
| --- | --- | --- | --- | --- |
| `shangshu-dispatch` | Shangshu | Orchestrates the full governed run and close-out | Intake, dispatch, integration, close-out | `dispatchPacket`, `summaryPacket`, `writebackPacket` |
| `zhongshu-draft` | Zhongshu | Drafts the memorial and locks intent | Draft | `intentPacket`, `intentGatePacket`, `memorialPacket` |
| `menxia-review` | Menxia | Reviews the memorial and decides execution authority | Review | `reviewPacket`, `menxia_review_ready`, `works_delivery_unlock` |
| `works-delivery` | Works | Executes approved implementation work | Delivery | write authority, evidence input |
| `justice-compliance` | Justice | Defines or checks evidence, tests, and acceptance gates | Verification | `verificationPacket`, `public_ready` |
| `rites-protocol` | Rites | Designs publication format and outward communication posture | Publication planning | `publicationPacket`, `lark_publication` |
| `publish-to-lark` | Rites executor | Executes document, permission, and IM delivery | Publication execution | `publicationPacket`, `public_ready` proof |
| `personnel-routing` | Personnel | Designs ownership and task routing | Dispatch support | owner assignments |
| `revenue-budgeting` | Revenue | Shapes cost, scope, and dependency tradeoffs | Strict-mode support | dispatch shaping |
| `war-operations` | War | Handles incidents, rollback posture, and emergency routing | Emergency mode | rollback posture |

### Gate map

| Gate | Source | What must be true | What it blocks |
| --- | --- | --- | --- |
| `menxia_review_ready` | `workflow-contract.json` | `intentPacket`, `intentGatePacket`, and `memorialPacket` exist | Review before a real memorial |
| `works_delivery_unlock` | contract + guard | `reviewPacket.verdict == APPROVE` | Works agent start, file writes, mutating commands |
| Non-Works write gate | `instrument-guard.ps1` | Only planning artifacts are exempt | File writes by non-Works actors |
| `intent_locked` | guard state | Zhongshu output includes the intent sections | Heavy execution on hidden assumptions |
| `public_ready` | contract | verification passed, summary closed, deliverable intact, chain closed, consolidated result present | Outward-ready claims and publishability |
| `lark_publication` | contract | `public_ready` plus explicit publication evidence and access readiness | Direct publication path |
| Lark IM notify gate | guard runtime | Latest run artifact proves `publicReady` and contains `publicReadyEvidence` | `lark-cli im +messages-send` |
| `writebackDecision` | doctrine + templates | Explicit `writeback` or `none` close-out posture | Meaningless or incomplete closure |

---

## Key Features

- **Visible stage board**: use a full `Imperial Stage Board` at kickoff and close-out, with compact progress digests in between
- **Intent lock**: substantial work captures intent and ambiguity before heavy execution
- **Guarded delivery**: Works stays blocked until Menxia returns `APPROVE`
- **Run artifacts**: governed runs can persist the packet chain as JSON instead of leaving it only in chat
- **Public-ready gate**: implementation completion does not automatically mean it is ready to publish or announce
- **Publication hard gate**: `publish-to-lark` now requires explicit `public-ready` proof and the guard can block unsafe Lark IM sends
- **Local-first capability search**: local skills/plugins -> global agents -> `find-skills` -> marketplace
- **Lark publication**: Rites can create docs, grant access, send IM, and publish to Wiki
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

When formal communication is needed, Rites can:

1. create the document
2. grant access
3. send IM
4. archive to Wiki

Publication now observes a strict `public-ready` gate, so the project can distinguish:

- approved to execute
- complete enough to verify
- safe to present outward

`publish-to-lark` prefers a governed run artifact as the proof source, and the guard can deny `lark-cli im +messages-send` if the latest run artifact does not prove public-ready closure.

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
- [Imperial Workflow](./references/imperial-workflow.md)
- [Meta Governance Layer](./references/meta-governance-layer.md)
- [Evolution Writeback](./references/evolution-writeback.md)
- [Run Artifact Protocol](./references/run-artifact-protocol.md)
- [Lark Publication Protocol](./references/lark-publication-protocol.md)
- [Frontend Governance](./references/frontend-governance.md)
- [Workflow Contract](./contracts/workflow-contract.json)
- [Run Artifact Template](./contracts/run-artifact.template.json)

---

<div align="center">
Built for governed execution, visible process, lawful publication, auditable run closure, and durable learning.
</div>
