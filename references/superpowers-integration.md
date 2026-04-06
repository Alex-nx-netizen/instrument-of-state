# Superpowers Integration

This file defines how the local `superpowers` skill suite should be integrated into `instrument-of-state`.

The principle is simple:

- `instrument-of-state` remains the governing constitution
- `superpowers` provides specialist workflows that strengthen specific court offices
- `find-skills` remains part of reconnaissance and capability acquisition, not a free-floating action
- for frontend-visible work, `superpowers` does not replace the dynamically discovered frontend capability tools

## Meta rule

Treat `using-superpowers` as a discipline reminder, not as a ministry by itself.

In the court model, use concrete `superpowers` skills at the proper stage rather than invoking the whole suite vaguely.

## Frontend doctrine

When the petition affects a UI, page, screen, component, or visual system:

- use the dynamically discovered frontend capability tools as the primary frontend path
- let `superpowers` support planning, dispatch, or verification around the discovered tools
- never let `superpowers` become a substitute for explicit frontend design and UX discipline

## Stage-to-skill mapping

### 太子承旨

Use these when the petition is new-feature work, creative design, or requires deliberate shaping before execution:

- `brainstorming`
- `writing-plans` only after the memorial or validated design is stable enough to become an execution plan

Role in court:

- intake shaping
- option comparison
- deciding whether the throne should mobilize the full apparatus

### 锦衣卫侦察

Use these during reconnaissance and capability search:

- `find-skills`
- `systematic-debugging` for bug or failure petitions
- `dispatching-parallel-agents` when multiple independent investigations exist

Role in court:

- evidence gathering
- root-cause tracing
- local and external capability reconnaissance

### 中书省

Use these to refine a governed memorial into a structured plan when execution is large:

- `writing-plans`

Role in court:

- turning a memorial into an implementation-grade action plan

### 尚书省

Use these to coordinate large or parallel execution:

- `dispatching-parallel-agents`
- `subagent-driven-development`
- `executing-plans`

Role in court:

- dispatch architecture
- choosing whether execution is same-session, task-by-task, or separate-session

### 兵部

Use:

- `systematic-debugging`

Role in court:

- incident stabilization
- urgent technical diagnosis

### 刑部

Use these as gates before completion claims:

- `verification-before-completion`
- `requesting-code-review`
- `receiving-code-review`
- `test-driven-development`

Role in court:

- proof
- review
- acceptance
- correctness discipline

### 工部

Use these during actual implementation when lawful authority exists:

- `subagent-driven-development`
- `executing-plans`
- `systematic-debugging`
- `test-driven-development`
- `verification-before-completion`
- `using-git-worktrees`

Role in court:

- implementation
- defect repair
- verified completion

### 礼部

Use these when the work approaches handoff, PR closure, or formal release:

- `finishing-a-development-branch`

Role in court:

- orderly close-out
- branch and release ceremony

## Find-skills law

`find-skills` belongs under 锦衣卫侦察 and Shangshu capability acquisition.

It should be used:

- after local skills and plugins were checked
- before approved GitHub marketplace installation
- when a narrow external capability query is needed

It should not be used:

- as a replacement for local-first discovery
- as a substitute for Menxia review
- as a reason to install tools without a memorial need

## Recommended agent attachment

Attach `superpowers` skills to these offices:

- `shangshu-agent`: `brainstorming`, `dispatching-parallel-agents`, `subagent-driven-development`
- `zhongshu-agent`: `writing-plans`
- `war-operations-agent`: `systematic-debugging`
- `justice-compliance-agent`: `verification-before-completion`, `requesting-code-review`, `receiving-code-review`, `test-driven-development`
- `works-delivery-agent`: `subagent-driven-development`, `executing-plans`, `systematic-debugging`, `test-driven-development`, `verification-before-completion`, `using-git-worktrees`

## Constitutional note

`superpowers` strengthens court discipline. It does not override:

- the memorial requirement
- Menxia review
- Works Delivery authorization
- local-first capability law
- the frontend rule that UI work should use dynamically discovered frontend capability tools
