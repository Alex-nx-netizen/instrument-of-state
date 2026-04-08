# Memory

This directory stores durable learning from governed runs.

The goal is to turn temporary reasoning into reusable state assets for future work.

## Structure

- `patterns/`: repeatable governance and delivery patterns
- `scars/`: failures, near-misses, and prevention rules
- `capability-gaps.md`: unresolved capability needs
- `dispatch-patterns.md`: routing patterns that proved useful
- `templates/`: copy-ready writeback templates for patterns, scars, dispatch decisions, and packet close-out

## Rule

If a run claims a `writebackDecision` of `writeback`, it should point to at least one concrete file in this directory or another explicit repository target.

## Suggested workflow

1. Open `memory/templates/writeback-packet.template.json`
2. Choose the concrete writeback targets
3. Copy the matching markdown template
4. Fill the artifact immediately while the governed run is still fresh
