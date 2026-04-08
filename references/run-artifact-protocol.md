# Run Artifact Protocol

This repository now includes a concrete governed run artifact template:

- `contracts/run-artifact.template.json`

Use it when a substantial petition needs its packet chain to exist as a durable, inspectable artifact rather than only in chat and markdown summaries.

## Purpose

The run artifact makes the hidden meta-governance layer tangible.

It gives one place to record:

- intent lock
- intent gate status
- memorial structure
- review verdict
- dispatch decisions
- verification evidence
- summary closure
- publication readiness
- writeback outcome

## Recommended location

Store governed run artifacts under:

- `artifacts/runs/`

Suggested file name:

- `<YYYY-MM-DD>-<short-slug>.json`

## Minimum rule

For a governed run, keep these packets aligned with the contract:

1. `intentPacket`
2. `intentGatePacket`
3. `memorialPacket`
4. `reviewPacket`
5. `dispatchPacket`
6. `verificationPacket`
7. `summaryPacket`
8. `publicationPacket`
9. `writebackPacket`

## When to use it

Strongly prefer a run artifact when any of these are true:

- the task is `Strict` or `Emergency`
- publication is requested or implied
- multiple ministries are involved
- the task is multi-file, risky, or cross-functional
- the team expects to reuse the pattern later

## Public-ready use

`publish-to-lark` should treat the run artifact as the cleanest proof source for publication gating.

The strongest publish path is:

- `summaryPacket.publicReady == true`
- `verificationPacket.verifyPassed == true`
- `publicationPacket.publicReadyEvidence` is non-empty

If that proof is missing, publication should downgrade instead of pretending the result is ready.

## Writeback use

At close-out, the run artifact should also record:

- whether writeback happened
- where it was written
- why those targets were chosen

That makes the run auditable after the chat ends.
