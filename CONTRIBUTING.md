# Contributing Skills

This guide covers how to create and contribute new skills to the claude-skills collection.

## Skill Structure

Every skill follows this structure:

```
skill-name/
├── SKILL.md          # Required: The actual skill file
├── README.md         # Required: User-facing documentation
└── template.md       # Optional: Templates for generated content
```

## Creating a New Skill

### Step 1: Define the Skill Purpose

Before writing code, answer these questions:

- **What problem does this skill solve?**
- **When should a user invoke this skill?**
- **What specific output should it produce?**
- **Is this distinct from existing skills?**

### Step 2: Create SKILL.md

The `SKILL.md` file is the core skill definition. It uses YAML frontmatter for metadata:

```markdown
---
name: your-skill-name
description: A one-sentence description of what this skill does. This appears in skill listings.
---

# Skill Name

## Overview

Brief overview of what this skill does and when to use it.

## Core Behavior

Detailed instructions for Claude when this skill is active:
- What triggers the skill
- What the skill should do
- How to format output
- Edge cases to handle

## Agent Behavior

Specific rules and patterns Claude should follow:
- Step-by-step workflows
- Response formats
- Error handling

## Related Skills

- `other-skill` - When to use that instead
- `another-skill` - How it integrates
```

**Key Principles:**

1. **Clear scope** - Define exactly what the skill does (and doesn't do)
2. **Explicit triggers** - What keywords or patterns invoke this skill?
3. **Actionable instructions** - Claude should know exactly what to do
4. **Edge cases** - Cover common failure modes

### Step 3: Create README.md

The README is for users, not Claude. Keep it practical:

```markdown
# Skill Name

## What It Does

One-paragraph summary of the skill's purpose.

## When to Use It

**Perfect For:**
- Clear scenario where this skill shines
- Another good use case

**Not For:**
- Scenario where another skill is better → Use `other-skill`
- Tasks that should be done directly

## How to Use

### Trigger the Skill

**Explicitly:**
```
skill-name: do something
```

**Implicitly (auto-detects):**
```
"phrases that trigger this skill"
```

### What Happens

Step-by-step of what the user experiences.

## Example Session

```
User: "something that triggers the skill"

Claude: [response showing the skill in action]

[...interaction continues...]
```

## Key Features

- **Feature 1** - Description
- **Feature 2** - Description

## Related Skills

- `related-skill` - How it compares

## Commands

| You Say | What Happens |
| ------- | ------------ |
| `command` | Result |
```

### Step 4: (Optional) Create template.md

If your skill generates documents or structured output, provide a template:

```markdown
# Template: {Purpose}

**Date:** {YYYY-MM-DD}
**Status:** status
**Context:** {trigger context}

## Section 1
> Guidance for this section

{Content placeholder}

## Section 2
> Guidance for this section

{Content placeholder}
```

### Step 5: Update SKILLS.md

Add your skill to the registry:

```markdown
| Skill | Description | Invoke | Category |
|-------|-------------|--------|----------|
| your-skill | Brief description | `skill-name:` | Category |
```

## Best Practices

### DO:

- **Keep skills focused** - One clear purpose per skill
- **Use descriptive names** - `git-master` not `g`
- **Document edge cases** - What happens when X goes wrong?
- **Provide examples** - Show, don't just tell
- **Link related skills** - Help users discover alternatives

### DON'T:

- **Overlap existing skills** - Check if something similar exists first
- **Make skills too broad** - "helper" is too vague
- **Skip the README** - Users need to know how to use your skill
- **Forget the description** - The YAML frontmatter appears in listings

## Skill Categories

When categorizing your skill:

| Category | Description | Examples |
|----------|-------------|----------|
| Planning | Project breakdown, task management | `plan`, `whiteboard` |
| Session | State management, workflow | `session-aware` |
| Development | Coding, implementation | `tdd`, `git-master` |
| Analysis | Debugging, investigation | `analyze`, `deepsearch` |
| Infrastructure | Setup, configuration | `mcp-setup`, `doctor` |

## Testing Your Skill

Before submitting:

1. **Test locally** - Symlink and invoke in Claude Code
2. **Test edge cases** - What happens with ambiguous input?
3. **Test documentation** - Can a new user understand it?
4. **Test interactions** - How does it work with other skills?

### Local Testing Script

```bash
# Create symlink for testing
ln -s /path/to/your/skill ~/.claude/skills/your-skill

# In Claude Code, test:
/oh-your-skill-name

# Or let it auto-detect based on triggers
```

## Submitting

1. Fork the repository
2. Create a feature branch: `git checkout -b skill/your-skill-name`
3. Commit your changes
4. Push to your fork
5. Open a pull request

Include in your PR:
- Description of the skill
- When to use it
- Example session (optional but helpful)
- Any dependencies

## Review Process

Skills are reviewed for:
- **Clarity** - Is the purpose clear?
- **Uniqueness** - Does it fill a new need?
- **Quality** - Are instructions actionable?
- **Documentation** - Is the README complete?
- **Compatibility** - Does it work with existing skills?

## Questions?

Open an issue with the `question` label.
