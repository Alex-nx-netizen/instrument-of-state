# Dispatch Patterns

Reusable routing decisions learned from governed runs.

## Pattern template

See `templates/dispatch-pattern-template.md`.

## Known patterns

### Pattern: Security-sensitive file changes

**Trigger**: Petition involves auth, tokens, cryptography, or user data  
**Routing**: Works Delivery + Justice Compliance (mandatory) + Revenue Budgeting (scope)  
**Mode**: strict  
**Learned**: 2026-04-16

---

### Pattern: Publication-only petitions

**Trigger**: No code changes; only docs, announcements, or Lark publications  
**Routing**: Rites Protocol only; skip Works Delivery  
**Mode**: standard  
**Gate note**: public_ready still required before any outbound lark-cli call  
**Learned**: 2026-04-16

---

### Pattern: Emergency stabilization

**Trigger**: Production outage, broken CI, P0/P1  
**Routing**: War Operations leads; dispatch before full Menxia review  
**Mode**: emergency  
**Post-action**: Menxia + Justice post-review mandatory within 24h  
**Learned**: 2026-04-16

---

### Pattern: Multi-ministry parallel dispatch

**Trigger**: Large feature spanning product, infra, and comms  
**Routing**: Personnel + Revenue in parallel (planning group); Works + Justice in parallel (delivery group); Rites last  
**Mode**: strict  
**Learned**: 2026-04-16
