---
name: whiteboard
description: Lightweight planning space for rough ideas and exploration. Detects existing docs structure (ADR, design, plans) and creates temporary whiteboard docs in docs/whiteboards/ that can be refined into formal docs later.  Use during Planning, Brainstorming or discussing changes/modifications mid-plan.
---

# Whiteboard Skill

## Overview

The whiteboard skill creates a lightweight, temporary planning space for exploring ideas mid-session. Unlike formal planning sessions that create detailed implementation plans, whiteboards are quick, informal spaces for:
- Roughing out approaches when you're unsure
- Parking branches of thought during exploration
- Capturing insights before committing to direction
- Temporary context switches during active work

**Key difference from planning**: Whiteboards are **ephemeral** and **iterative**. They're not formal plans - they're thinking tools you can refine into proper docs later.

**Scope boundary**: Whiteboards explore **future requirements and options** to feed into planning. Do NOT derailing into implementation planning during whiteboarding. Requirements must be cohesive and complete BEFORE moving to planning.

## When to Use

### Trigger Conditions

The whiteboard activates when you detect these user signals:

**Explicit Triggers:**
- "whiteboard", "wb:", "whiteboard this"
- "rough this out", "sketch this out"
- "let me think about this", "explore this approach"
- "park this thought", "branch this idea"
- "not sure yet, let's brainstorm"

**Implicit Triggers:**
- User switches topics mid-session without "discuss"/"brainstorm" keywords
- User asks "what do you think" during active work
- You detect 2+ divergent approaches being considered
- User seems uncertain or exploring options
- Context switching needed during feature implementation
- **Scope/plan deviation detected** (see Scope Guardrail below)

**When NOT to use:**
- Clear request for implementation plan → Use `plan` skill
- Specific, well-defined requirements → Delegate directly
- Quick lookup/clarification → Answer directly
- User says "stop brainstorming" → Return to previous work

### Scope Guardrail: Push Back on Plan Deviations

When you detect a request that would **alter the agreed plan's scope** or **deviate from the approved approach**:

**Detection signals:**
- Request adds features not in the original plan
- Request changes architecture/data model already agreed upon
- Request expands acceptance criteria beyond what was documented
- Request conflicts with an existing ADR or design doc
- "While we're at it, let's also add..." during implementation

**Your response pattern:**
```
"⚠️ **SCOPE CHANGE DETECTED**

This request would alter the scope of the approved plan:
- Current plan: {cite the plan file and relevant section}
- Agreed scope: {what was approved}
- Requested change: {what user is asking for}
- Impact: {how this changes scope/effort/architecture}

**I recommend whiteboarding this change** rather than implementing immediately.
This allows us to:
- Understand the full impact on existing work
- Update the plan with revised scope/acceptance criteria
- Consider dependencies on other planned work
- Potentially create an ADR if architectural

Shall we whiteboard this?"
```

**If user insists on implementing without whiteboard:**
- Reiterate the impact with specific evidence
- Ask them to confirm they want to proceed anyway
- Document the decision in the relevant plan file with a "Scope Change" note
- Update acceptance criteria if applicable

**When NOT to use:**
- Clear request for implementation plan → Use `plan` skill
- Specific, well-defined requirements → Delegate directly
- Quick lookup/clarification → Answer directly
- User says "stop brainstorming" → Return to previous work

## How It Works

### Workflow

```
1. DETECT trigger (explicit or implicit)
   ↓
2. CHECK for existing docs structure
   - docs/adr/ (Architecture Decision Records)
   - docs/design/ (Design docs)
   - docs/plans/ (Implementation plans)
   - docs/phase-plans/ (Phase-based planning)
   ↓
3. CREATE temporary whiteboard
   - docs/whiteboards/{YYYY-MM-DD}-{topic-slug}.md
   - From template.md (section structure below)
   ↓
4. ANNOUNCE mode transition
   "Switching to WHITEBOARD mode for exploration..."
   ↓
5. TRACK session
   - Register in docs/whiteboards/_open-sessions.md
   - Update status on state changes
   ↓
6. CONDUCT exploration
   - Quick bullets, not formal structure
   - Multiple branches/alternatives
   - Pin key insights
   - User drives, you facilitate
   ↓
7. RESOLVE on completion
   - Archive: Move to appropriate formal doc type
   - Park: Keep for later (status: parked)
   - Discard: Delete if obsolete
   - Resume: Return to interrupted work
```

### Worktree Protocol (Isolation)

**ALL whiteboards must be created on `whiteboard/{topic}` branches.** Never create whiteboards on main or feature branches.

```
1. CHECK current branch
   - If already on whiteboard/* → Use existing branch
   - If on main or feature/* → Create new whiteboard branch
   ↓
2. CREATE whiteboard branch (if needed)
   - git checkout -b whiteboard/{topic-slug}
   - OR: git worktree add ../{repo}-wb-{topic} -b whiteboard/{topic-slug}
   ↓
3. CREATE whiteboard file
   - docs/whiteboards/{YYYY-MM-DD}-{topic-slug}.md
   - From template.md
   ↓
4. IF interrupting active work
   - Populate Context Snapshot with interrupted state
   - Note original branch for return
   ↓
5. COMMIT whiteboard
   - git add docs/whiteboards/
   - git commit with descriptive message
   ↓
6. ON completion
   - Refine into formal docs OR park as-is
   - PR whiteboard branch → main
   - Return to original branch if interrupted
```

**Why always whiteboard branches?**
- Keeps exploration isolated from production code
- Clean git history (no exploratory commits mixed with real work)
- Easy to discard whiteboard without affecting main
- Consistent pattern regardless of context

### Mode Transitions

**Entering Whiteboard Mode:**
```
"Switching to WHITEBOARD mode for exploration..."

- Creating temporary planning space at docs/whiteboards/{date}-{topic}.md
- Detected existing docs structure: [list found]
- This will NOT create a formal plan yet, just a space to think
- Type 'done', 'archive this', or 'back to work' when ready
```

**Exiting Whiteboard Mode:**
```
"Exiting WHITEBOARD mode..."

Whiteboard refined into:
- [Formal doc type] at [path]
- Resuming work on [feature branch/task]

OR

Whiteboard parked at docs/whiteboards/{topic}.md (status: parked)
Resuming work on [feature branch/task]
```

## Agent Behavior Rules

### For You (Conductor)

1. **Detect existing docs** before creating whiteboard
   ```bash
   ls docs/adr docs/design docs/plans docs/phase-plans 2>/dev/null
   ```

2. **Always use whiteboard branches** - NEVER create whiteboards on main or feature branches
   - Check current branch: `git branch --show-current`
   - If not `whiteboard/*`: create `whiteboard/{topic-slug}` branch first
   - Commit whiteboard files to this branch
   - This applies to ALL whiteboards, not just mid-session interruptions

3. **Track sessions** in `_open-sessions.md`
   - Register new whiteboards with status: active
   - Update to parked/archived on resolution

4. **Announce clearly** when mode switching
   - Use transition messages above
   - Make state explicit

5. **Pin insights IMMEDIATELY** when creating valuable content
   - **What counts as valuable**: Tables, frameworks, structured lists, decisions, root cause analysis
   - **When to pin**: RIGHT AFTER creating the content, before continuing
   - **How to capture**: Include context, user quote, and your verbatim response
   - **Never rely on summarization at end** - details WILL be lost
   - **Do not prompt** - just pin it automatically

   **Pinned insight format in whiteboard:**
   ```markdown
   **{Insight title:}**
   > **Context:** {Brief summary of conversation leading to this insight}
   >
   > **User said:** "{exact user quote}"
   >
   > **Insight:** {your verbatim table/framework/insight}
   ```

6. **Capture context precisely** when mid-session switch
   - **User quote**: Include exact user message that triggered the branch
   - **Your response summary**: Brief summary of what you were discussing
   - **Why we branched**: Blocker, ambiguity, new idea, refactor needed, etc.
   - **Recent conversation context**: Topic we were on, recent actions, state
   - This enables accurate restoration when returning

7. **Guide, don't drive**
   - User controls whiteboard content
   - You facilitate structure and organization
   - Offer 2-3 approaches, not solutions

8. **Document decisions COMPLETELY** (prevents information loss)
   - **CRITICAL**: When presenting options A/B/C to user, you MUST document:
     - The full options presented (with descriptions and trade-offs)
     - The user's response (letter choice + any reasoning)
     - The final resolution
   - **Never** document just "User said: 'A'" without the options
   - **Decision record format:**
     ```markdown
     ### Gap/Question #N: [Title]

     **Options Presented:**
     | Option | Description | Trade-offs |
     |--------|-------------|------------|
     | A | [description] | [trade-offs] |
     | B | [description] | [trade-offs] |
     | C | [description] | [trade-offs] |

     > **User said:** "A" [or full quote with reasoning]

     **Resolution:**
     [The chosen approach with rationale]

     **Rejected Options:**
     - B: [reason rejected, if discussed]
     - C: [reason rejected, if discussed]
     ```
   - This prevents future readers from seeing "User chose A" with no context

9. **Resolution Protocol - Collaborative Decisions**
   - When gaps/questions/issues are identified, follow this sequence:
     1. **PRESENT** - Show the item to the user clearly
     2. **OPTIONS** - If multiple valid approaches, list them with trade-offs
     3. **DECIDE** - Ask user to choose OR ask "how should we handle this?"
     4. **PIN** - Record the decision with user quote AND full options
     5. **NEXT** - Only then move to next item
   - **DO NOT** resolve multiple items at once without user input on each
   - **DO NOT** mark items as DEFERRED without user confirmation
   - ALL items start as OPEN; only change to RESOLVED/DEFERRED after user discussion
   - "Defer" is a decision - user must confirm what's deferred and why

10. **Expert Review before exit** - Catch issues before finalizing
    - Before marking whiteboard complete, delegate to relevant expert personas
    - **Two types of experts needed:**
      - **Technical experts:** architect, security-reviewer, performance specialist
      - **Domain experts:** Subject-matter experts who can identify non-functional gaps
    - Examples of domain expertise:
      - "RPG Game Developer" for game mechanics, progression, simulation
      - "UX Researcher" for user experience, workflows, discoverability
      - "DevOps Engineer" for deployment, monitoring, observability
    - Expert reviews for: gaps, inconsistencies, missing requirements, overlooked edge cases
    - Add any findings to OPEN QUESTIONS; resolve with user before exit
    - This prevents "we thought we were done" issues later

11. **Stay in scope - Requirements NOT Implementation**
    - **WHITEBOARDING** = exploring requirements, options, understanding the problem
    - **PLANNING** = breaking down implementation, tasks, dependencies
    - Do NOT offer to "create implementation plan" or "delegate to architect for spec" during whiteboarding
    - Only when ALL requirements are cohesive and complete, ask user: "Ready to move to planning?"
    - If you catch yourself drifting into implementation, stop and return to requirements exploration
    - This is the most common cause of whiteboard process failure

### When Delegating to Subagents

**Context to pass:**
- Current whiteboard path
- Existing docs structure detected
- Whether in worktree or main repo
- Active feature branch context (if interrupted work)

**Agent instructions:**
```
You are working in WHITEBOARD mode.

Whiteboard location: docs/whiteboards/{date}-{topic}.md
Existing docs: [list detected directories]
Worktree: [yes/no + path if yes]

Your role:
- Facilitate exploration, don't direct
- Keep bullets brief and informal
- Pin key insights as they emerge
- Track multiple branches of thought
- Follow template structure from template.md

When user signals done:
- Ask: "Archive as ADR/design/plan/park/discard?"
- Execute resolution
- Update _open-sessions.md
```

## Integration with Existing Docs

### Detecting Doc Types

On whiteboard creation, probe for existing structure:

```bash
# Check for ADR structure
if [[ -f "docs/adr/0000-use-adrs.md" ]]; then
  HAS_ADR=true
  ADR_NEXT=$(ls docs/adr/*.md | tail -1 | grep -oP '\d+' | awk '{print $1+1}')
fi

# Check for design docs
if [[ -d "docs/design" ]]; then
  HAS_DESIGN=true
fi

# Check for plans
if [[ -d "docs/plans" ]] || [[ -d "docs/phase-plans" ]]; then
  HAS_PLANS=true
fi
```

### Refinement Paths

When whiteboard is complete, offer appropriate options based on detected structure:

| Whiteboard Content | Refine Into       | Template/Process                  |
| ------------------ | ----------------- | --------------------------------- |
| Technical decision | ADR               | docs/adr/{next-number}-{topic}.md |
| Game mechanic      | Design doc        | docs/design/gdd-{topic}.md        |
| Implementation     | Plan              | docs/plans/{topic}.md             |
| Multi-phase work   | Phase plan        | docs/phase-plans/phase-{N}.md     |
| Not ready yet      | Parked whiteboard | docs/whiteboards/{topic}.md       |
| Obsolete           | Discarded         | (delete file)                     |

## Open Sessions Tracking

**Location:** `docs/whiteboards/_open-sessions.md`

**Format:**
```markdown
# Open Whiteboard Sessions

| Date       | Topic              | File                          | Status | Created During          |
| ---------- | ------------------ | ----------------------------- | ------ | ----------------------- |
| 2025-01-28 | Combat refactoring | 2025-01-28-combat-refactor.md | active | feature/combat-overhaul |
| 2025-01-27 | NPC needs system   | 2025-01-27-npc-needs.md       | parked | main                    |
```

**Status values:**
- `active` - Currently being worked on
- `parked` - Saved for later, not abandoned
- `archived` - Refined into formal doc (link in "Refined Into" section)

**Update rules:**
- Create entry when whiteboard created
- Update status on state change
- Add "Refined Into" link when archived
- Remove entry only when discarded

## Examples

### Example 1: Mid-Session Exploration

```
User: "I'm implementing the combat system but just realized
      I need to think through how morale affects target selection."

You: [Detects implicit trigger during active work]

     "Switching to WHITEBOARD mode for exploration...

      Creating temporary planning space at docs/whiteboards/2025-01-28-morale-target-selection.md
      Detected existing docs: adr/, design/, plans/
      Context Snapshot: feature/combat-system branch, implementing CombatResolver

      Let's explore this..."

[Create whiteboard with enhanced Context Snapshot:]

## Context Snapshot

**What Just Happened (Trigger):**
- User quote: "I'm implementing the combat system but just realized I need to think through how morale affects target selection."
- Your response summary: We were discussing the CombatResolver implementation and you identified an ambiguity in how morale influences target selection decisions
- Why we branched: Unclear requirements - need to explore mechanics before continuing

**Conversation Context (Recent Summary):**
- Topic we were on: Implementing CombatResolver.CalculateTargets()
- Recent actions: Defined base target selection algorithm, about to add morale modifier
- State of conversation: Mid-implementation, hit ambiguity in design

**Interrupted Work:**
- Branch: feature/combat-system
- Task: Implementing CombatResolver class
- Tracking file: docs/plans/2025-01-25-combat-implementation.md
- Worktree: C:/Projects/cozy-fantasy-rpg/

**State to Restore:**
- Files modified: src/Combat/CombatResolver.cs (partially complete)
- Next step: Continue morale modifier implementation after resolution
- Uncommitted changes: yes
```

### Example 2: Explicit Whiteboard Request

```
User: "whiteboard: I'm not sure whether to use event sourcing or
      direct state updates for the inventory system"

You: [Detects explicit trigger]

     "Switching to WHITEBOARD mode for exploration...

      Creating whiteboard at docs/whiteboards/2025-01-28-inventory-persistence.md
      Existing docs structure found:
      - docs/adr/ (Architecture Decision Records)
      - docs/design/ (Design docs)

      I see 2-3 approaches here. Let's sketch them out..."

[Create whiteboard, list approaches, let user drive]
```

### Example 3: Parking a Branch

```
User: "Wait, I just thought of something - what if we made
      crafting quality affect enchantment capacity too?"

You: [Detects branch during whiteboard]

     "That's a different branch. Let me park it in the whiteboard
     so we don't lose it..."

[Add to "Branches" section in whiteboard]
```

### Example 4: Refining to Formal Doc

```
User: "Okay, this makes sense. Let's turn this into an ADR."

You: [Detects refinement signal]

     "Exiting WHITEBOARD mode...

      Whiteboard refined into:
      - ADR at docs/adr/0042-inventory-event-sourcing.md

      Resuming work on feature/inventory-persistence..."

[Copy key content to ADR, archive whiteboard, update _open-sessions.md]
```

### Example 5: Scope Guardrail - Pushing Back on Plan Deviation

```
User: "While we're implementing the inventory system, can we also add
      item durability that degrades with use?"

You: [Detects scope expansion - not in agreed plan]

     "⚠️ **SCOPE CHANGE DETECTED**

      This request would alter the scope of the approved plan:
      - Current plan: docs/plans/2025-01-20-inventory-implementation.md
      - Agreed scope: Basic inventory CRUD, stacking, and persistence
      - Requested change: Add item durability system with degradation
      - Impact: New feature not in scope, requires data model changes,
                adds significant effort, affects related systems (crafting, combat)

      **I recommend whiteboarding this change** rather than implementing immediately.
      This allows us to:
      - Understand the full impact on existing work
      - Update the plan with revised scope/acceptance criteria
      - Consider dependencies on other planned work
      - Potentially create an ADR for the durability mechanics

      Shall we whiteboard this?"

User: "Yeah, you're right. Let's whiteboard it."

You: "Switching to WHITEBOARD mode for scope exploration..."
```

### Example 6: Immediate Insight Pinning

```
[During discussion about session management]

User: "How long the session run depends on the task. For example, starting a fresh
      project I want to brainstorm the vision for the project, tech stack, features, etc.
      I generally want to complete this overview in a session and then have a list of
      key topics to review in detail as we drill down."

You: [Creates session hierarchy table, then immediately pins it]

     "That's a really clear hierarchical structure. Let me reflect what I'm hearing:

      Your Ideal Session Hierarchy:
      | Level | Scope | Duration | Output | Checkpoint |
      |-------|-------|----------|--------|------------|
      | 1. Vision | Project kickoff | 1 session | Vision docs... | Scope locked |
      | 2. Guardrails | Tooling/standards | 1 session | Repo setup... | Ready for planning |
      [...]

      [Pinning this to whiteboard ✓]

      The core principle: Each session has clear inputs, clear outputs, and a checkpoint..."
```

## Template Structure

See `template.md` for the whiteboard template with all sections:

- **Header** - Topic, date, status, triggered by
- **Context Snapshot** - Interrupted work state (if mid-session)
- **Session Intent** - What we're exploring
- **Pinned Insights** - Key findings as we go
- **Branches** - Alternative ideas to revisit
- **Active Thread** - Current exploration thread
- **Next Steps** - What to do when done (if resolved)
- **Refined Into** - Link to formal doc (if archived)

## Related Skills

- `brainstorming` - More structured exploration with interview workflow
- `plan` - Formal planning session with implementation tasks
- `note` - Quick memory capture (single facts, not exploration)

**Whiteboard is lighter than all of these** - it's for roughing out ideas quickly, not creating formal outputs.
