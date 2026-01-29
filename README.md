# Claude Skills Collection

A curated collection of reusable skills for [Claude Code](https://claude.ai/code), Anthropic's official CLI for Claude.

## What Are Skills?

Skills in Claude Code are reusable prompt bundles that extend Claude's capabilities. Each skill defines specific behaviors, workflows, and domain knowledge that can be invoked during a development session.

## Installation

### Quick Setup

Clone the repository:

```bash
git clone https://github.com/mcj-coder-org/claude-skills.git ~/claude-skills
cd claude-skills
```

Then choose one of the following methods:

### Option 1: Symlink (Recommended)

Symlinks allow automatic updates when you pull changes from the repository.

**Windows PowerShell** (requires Developer Mode or Admin):
```powershell
# Enable Developer Mode once: Settings → Update & Security → For developers
# OR run PowerShell as Administrator

.\install.ps1
```

**Linux/macOS**:
```bash
chmod +x install.sh
./install.sh
```

### Option 2: Copy Method (No Admin Required)

Copies files directly. Skills won't update automatically when the repository changes.

**Windows PowerShell**:
```powershell
.\install-copy.ps1
```

### Manual Installation

**Symlinks** (Windows PowerShell):
```powershell
New-Item -ItemType SymbolicLink -Path "$env:USERPROFILE\.claude\skills\session-aware" -Target "$env:USERPROFILE\claude-skills\session-aware"
New-Item -ItemType SymbolicLink -Path "$env:USERPROFILE\.claude\skills\whiteboard" -Target "$env:USERPROFILE\claude-skills\whiteboard"
```

**Symlinks** (Linux/macOS):
```bash
ln -s ~/claude-skills/session-aware ~/.claude/skills/session-aware
ln -s ~/claude-skills/whiteboard ~/.claude/skills/whiteboard
```

### Verify Installation

```bash
# List installed skills
ls ~/.claude/skills/

# Or use Claude Code's help
/oh-my-claudecode:help
```

## Available Skills

### session-aware

Manages session types, state tracking, and transition enforcement for all development work. Ensures work flows through appropriate phases (Vision → Guardrails → Plan → Implement) with clear boundaries.

**Best for:** Projects that benefit from structured development phases and state tracking.

**Usage:** Automatically wraps other skills - no explicit invocation needed.

**See:** [session-aware/README.md](session-aware/README.md)

### whiteboard

Lightweight planning space for rough ideas and exploration. Creates temporary whiteboard documents that can be refined into formal docs (ADRs, design docs, plans) later.

**Best for:** Mid-session exploration when you're unsure or need to think through something.

**Usage:** `whiteboard: {topic}` or `wb: {topic}`

**See:** [whiteboard/README.md](whiteboard/README.md)

## Skill Structure

Each skill in this collection follows a consistent structure:

```
skill-name/
├── SKILL.md          # The actual skill file (read by Claude)
├── README.md         # User-facing documentation
└── template.md       # Optional: templates for generated content
```

### SKILL.md Format

The `SKILL.md` file is the core of each skill. It uses YAML frontmatter for metadata:

```yaml
---
name: skill-name
description: Brief description of what this skill does
---

# Detailed skill instructions
# (This content is loaded into Claude's context)
```

### README.md Format

Each skill includes a user-facing README that explains:
- What the skill does
- When to use it
- How to invoke it
- Example interactions
- Related skills

## Contributing

Want to add a new skill to this collection? See [CONTRIBUTING.md](CONTRIBUTING.md) for guidelines.

## Quick Reference

| Skill | Invoke | Purpose |
|-------|--------|---------|
| session-aware | Automatic | Session state and transition enforcement |
| whiteboard | `whiteboard: {topic}` | Lightweight exploration space |

## Development

### Adding a New Skill

1. Create a new directory following the naming convention
2. Add `SKILL.md` with proper YAML frontmatter
3. Add `README.md` with user documentation
4. Update [SKILLS.md](SKILLS.md) registry
5. Test locally before submitting PR

### Testing Skills Locally

```bash
# Create symlink to test
ln -s ~/path/to/your/skill ~/.claude/skills/your-skill

# Test in Claude Code
/oh-my-claudecode:help
```

## License

MIT License - see [LICENSE](LICENSE) for details.

## Related Resources

- [Claude Code Documentation](https://docs.anthropic.com/en/docs/claude-code)
- [Claude Code GitHub](https://github.com/anthropics/claude-code)
- [Skill Writing Guide](CONTRIBUTING.md)

---

**Version:** 1.0.0
**Last Updated:** 2025-01-29
