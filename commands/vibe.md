# /vibe Command

Start the VIBE autonomous engineering workflow.

## Usage

```bash
/vibe <your project requirement>
```

## What This Command Does

When a user runs `/vibe`, the command should:

1. Trigger the `vibe-autopilot` skill.
2. Start with requirement analysis and architecture planning, then generate artifacts such as the PRD, architecture notes, database notes, and `tasks.md`.
3. After the user approves the plan, continue through the execution loop:
   - requirement analysis
   - architecture design
   - task breakdown
   - iterative implementation with isolated sub-tasks
   - testing
   - security review
   - UI polish
   - delivery
4. During execution, minimize interruptions and keep moving with the best available option.

## If No Requirement Is Provided

If the user only types `/vibe`, begin requirement discovery. Ask about the project goal, core features, preferred stack, and UI direction.
