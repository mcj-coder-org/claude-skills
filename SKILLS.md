# Skills Registry

This document lists all available skills in the collection.

## Overview

| Skill | Description | Invoke | Category |
|-------|-------------|--------|----------|
| [session-aware](session-aware/README.md) | Manages session types, state tracking, and transition enforcement | Automatic | Session |
| [whiteboard](whiteboard/README.md) | Lightweight planning space for rough ideas and exploration | `whiteboard:` | Planning |

## Detailed List

### session-aware

**Description:** Manages session types, state tracking, and transition enforcement for all development work. Wraps other skills with session awareness.

**Invoke:** Automatic (no explicit invocation needed)

**Use when:** You want structured development phases with clear boundaries between Vision, Guardrails, Plan, and Implement sessions.

**See:** [session-aware/README.md](session-aware/README.md) | [session-aware/SKILL.md](session-aware/SKILL.md)

---

### whiteboard

**Description:** Lightweight planning space for rough ideas and exploration. Creates temporary whiteboard docs that can be refined into formal docs later.

**Invoke:** `whiteboard: {topic}` or `wb: {topic}`

**Use when:** You're unsure, need to think through something mid-session, or want to explore options before committing to a plan.

**See:** [whiteboard/README.md](whiteboard/README.md) | [whiteboard/SKILL.md](whiteboard/SKILL.md)

---

## Categories

### Planning

Skills for planning, brainstorming, and organizing work.

| Skill | Description |
|-------|-------------|
| [whiteboard](whiteboard/README.md) | Lightweight exploration space |

### Session

Skills for managing session state and workflow.

| Skill | Description |
|-------|-------------|
| [session-aware](session-aware/README.md) | Session state and transition enforcement |

## Dependency Graph

```
session-aware
    ├─ wraps → whiteboard
    └─ wraps → [other skills]
```

The `session-aware` skill wraps other skills, providing session management without requiring explicit invocation.

## Version History

| Version | Date | Changes |
|---------|------|---------|
| 1.0.0 | 2025-01-29 | Initial release with session-aware and whiteboard |
