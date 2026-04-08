# Evolution Writeback

This file defines how `instrument-of-state` captures learning after a governed run.

The court should not merely finish a task.
It should also decide whether that task produced something worth preserving.

## Core rule

Every governed run ends with a `writebackDecision`.

Allowed values:

- `writeback`
- `none`

If the decision is `writeback`, list the concrete targets.
If the decision is `none`, explain why the run does not justify durable capture.

## Preferred storage targets

| Target | Use it for |
| --- | --- |
| `memory/patterns/` | repeatable execution patterns, workflow shapes, reusable playbooks |
| `memory/scars/` | failures, regressions, near-misses, and prevention rules |
| `memory/capability-gaps.md` | unresolved missing skills, plugins, or agents |
| `memory/dispatch-patterns.md` | ministry routing patterns and when they worked |
| `references/` | new doctrine or clarified governance law |
| `skills/` | upgrades to execution discipline |
| `agents/` | cleaner role boundaries |
| `contracts/workflow-contract.json` | stricter gates, packets, and closure rules |

## Template-first writeback

Use the templates in `memory/templates/` instead of inventing a format every time.

Recommended mapping:

| Need | Template |
| --- | --- |
| reusable pattern | `memory/templates/pattern-template.md` |
| scar / prevention rule | `memory/templates/scar-template.md` |
| dispatch lesson | `memory/templates/dispatch-pattern-template.md` |
| capability gap entry | `memory/templates/capability-gap-entry-template.md` |
| writeback packet summary | `memory/templates/writeback-packet.template.json` |

## What counts as a pattern

A pattern is worth writing back when:

- the same kind of task is likely to return
- the routing or sequencing was unusually effective
- the team discovered a good decomposition or acceptance strategy
- the workflow can now avoid rethinking the same thing next time

## What counts as a scar

A scar is worth writing back when:

- a review gate caught something important late
- a hidden assumption caused drift
- a role boundary proved too weak
- a publication or permissions step almost failed
- rollback was necessary

Scars are not blame records.
They are prevention records.

## Minimum close-out question set

Before a governed task is closed, ask:

1. Did this run expose a reusable pattern?
2. Did this run expose a scar or prevention rule?
3. Did this run reveal a capability gap?
4. Did this run show that a ministry or agent boundary should change?
5. Did this run justify a contract change?

## Relation to the court

Writeback is not a new public office.
It is the hidden continuity layer that strengthens future petitions.

User-facing close-out may summarize the decision briefly.
The durable artifact belongs in `memory/` or another explicit repository target.
