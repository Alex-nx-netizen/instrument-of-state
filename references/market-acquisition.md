# Marketplace Acquisition

Use this process when the memorial identifies a genuine capability gap.

Read `governance-playbook.md` for the full state ladder. This file focuses on capability search and acquisition.

## Principle

Acquire external capability only after local capability has been checked and recorded.

## Local-first ladder

1. Search project-local skills.
2. Search user-local skills.
3. Search currently installed local plugins.
4. For institutional communication or handoff, check local Lark skills before looking elsewhere.
5. If the gap remains, invoke `find-skills` with a focused capability query.
6. If the gap still remains, search approved GitHub plugin marketplaces.
7. Install the narrowest suitable plugin.
8. If nothing suitable is found, fall back to generic agents and record the gap.

## Docket discipline

Record these in `findings.md` when the task is substantial:

- the query used
- local skill matches
- local plugin matches
- `find-skills` recommendations
- marketplace candidates
- the selected capability and why it won

For communication or reporting tasks, explicitly note whether these local skills were considered:

- `lark-doc`
- `lark-drive`
- `lark-im`
- `lark-contact`
- `lark-wiki`

## Recommended command flow

Use the bundled helper from plugin `bin/` after local discovery and `find-skills`:

- `instrument-market.cmd inventory "<query>"`
- `instrument-market.cmd resolve "<query>"`
- `instrument-market.cmd search "<query>"`
- `instrument-market.cmd install <github-repo> <plugin-name> [local|project|user]`

Examples:

- `instrument-market.cmd inventory "planning docs github release"`
- `instrument-market.cmd resolve "github issue triage release notes"`
- `instrument-market.cmd search "database migration validation"`
- `instrument-market.cmd install daymade/claude-code-skills git-helper project`

## Search coverage

The bundled helper now searches these local roots when present:

- project `.claude/skills`, `.codex/skills`, `.agents/skills`
- user `.claude/skills`, `.codex/skills`, `.agents/skills`
- project or user plugin roots that contain `.claude-plugin/plugin.json`
- this plugin's bundled `skills/`

## Sourcing policy

Prefer known marketplaces listed in `known-marketplaces.json`.

If a plugin is not available locally and a high-confidence match appears in a known marketplace:

- install automatically only when the memorial already justifies the capability
- prefer `project` or `local` scope
- report the source, marketplace, plugin name, and scope in the final order

If confidence is weak or the source is not known:

- present candidates instead of auto-installing
- let the user decide

## Constitutional reminder

Marketplace acquisition expands state capacity. It does not bypass review or verify gates.
