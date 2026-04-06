# Frontend Governance

This file defines the mandatory handling of frontend-visible work inside `instrument-of-state`.

Read this file whenever the petition affects how a product looks, feels, moves, or is interacted with.

## When the frontend doctrine applies

Apply this doctrine when the petition involves any of the following:

- pages, screens, flows, dashboards, landing pages, or marketing surfaces
- components, forms, tables, charts, navigation, or layout systems
- color, typography, spacing, motion, interaction states, or art direction
- accessibility, responsive behavior, or interface quality review

Do not apply it to backend-only, infrastructure-only, or non-visual automation work.

## Frontend capability requirements

Frontend work requires two categories of capability, sourced through the standard capability ladder (global agents → session skills → find-skills → marketplace):

- **UX 结构能力**：UX structure, accessibility, responsive behavior, layout logic, interaction states, platform adaptation, and design-system coherence
- **视觉设计能力**：aesthetic direction, typography character, composition, atmosphere, motion moments, and protection against generic AI-looking output

No specific skill or agent name is prescribed. The best available tools should be discovered dynamically for each project context. When multiple candidates exist, prefer the one that best matches the project's technology stack, design system, and quality requirements.

## Core law

1. Frontend is not generic implementation. It is governed design, experience, and delivery.
2. Every frontend petition needs an explicit product surface, audience, and user outcome.
3. Every frontend memorial needs an experience thesis, not just a list of components.
4. Every frontend dispatch must state which frontend tools were selected through the capability ladder and why.
5. Every frontend review must check accessibility, responsiveness, and interaction clarity, not just visual polish.
6. Every frontend implementation must either preserve the established product language or deliberately choose a new one and justify it.
7. Generic AI aesthetics are forbidden for greenfield frontend work.

## Design law for greenfield or redesigned interfaces

When the task creates a new interface or substantially redesigns an existing one:

- choose a deliberate visual direction
- avoid default font stacks such as Inter, Roboto, Arial, or system-only pairings unless the product already requires them
- define design tokens or CSS variables for color, typography, spacing, and surface treatment
- prefer atmosphere, texture, gradients, shapes, layering, or other contextual depth over flat generic surfaces
- use motion to explain hierarchy, feedback, or sequence; do not scatter decorative motion randomly
- ensure the interface works on both desktop and mobile unless the memorial explicitly limits the target

## Preservation law for established products

When working inside an existing app, site, design system, or brand:

- preserve the established visual language unless the petition explicitly asks for redesign
- adapt the paired frontend skills to the existing system rather than replacing it with a new aesthetic
- prefer compatibility, coherence, and maintainability over novelty

## Office responsibilities

### Shangshu

- identify that the petition is frontend-visible during intake or reconnaissance
- record platform, surfaces, audience, current design system, and responsive targets in the docket
- dispatch the paired frontend instruments explicitly

### Zhongshu

- draft the memorial with UI scope, target users, experience goals, design-system constraints, and aesthetic direction

### Menxia

- reject or return frontend memorials that lack a clear surface, UX goal, review gate, or experience thesis

### Justice

- define accessibility, interaction, responsiveness, contrast, focus, and usability gates

### Works

- implement the interface using the paired frontend instruments
- deliver code that is both functional and intentionally designed

### Rites

- define design handoff, demo, release-note, screenshot, or stakeholder artifact shape when the interface must be presented externally

## Docket requirements for frontend petitions

When the docket exists, it should record:

- target platform and interface surface
- user type or audience
- current design system or brand constraints
- responsive and accessibility expectations
- proposed visual direction when redesign or greenfield work is involved

## Final reporting requirement

When frontend work is governed, the final report should state:

- which frontend capability tools were selected and how they were discovered
- the chosen visual or UX direction
- the main accessibility and responsive checks that were applied
