# Demo Assets

This file defines the minimum demo package needed before broad public launch.

## Goal

Show the workflow in a way that is concrete, short, and believable.

The demo should prove three things:

1. the plugin installs
2. `/vibe` starts a structured workflow
3. the workflow produces visible planning and delivery artifacts

## Minimum Asset Set

Prepare these assets first:

- one 30 to 60 second GIF or short video
- one screenshot of installation
- one screenshot of requirement alignment
- one screenshot of generated artifacts such as `tasks.md`
- one screenshot of implementation, testing, or review flow

## Demo Flow

Use this order:

1. show the repository home page
2. show installation or plugin verification
3. run `/vibe`
4. show requirement questions or planning
5. show generated docs or `tasks.md`
6. show implementation progress
7. end on the delivered result

## Capture Rules

- keep the screen clean
- use a readable terminal font size
- hide unrelated windows and noise
- keep the clip short
- do not over-edit the footage

## Recommended Scenes

### Scene 1: Repo Intro

Show:

- repository title
- one-line positioning

### Scene 2: Installation

Show one of:

- `/plugin install vibe-claude-plugin@vibe`
- `/plugins` with the plugin loaded

### Scene 3: Workflow Start

Show:

```bash
/vibe Build a dark-mode SaaS admin panel with Node.js, PostgreSQL, role-based access control, tests, and deployment docs.
```

### Scene 4: Planning Artifacts

Show:

- PRD
- architecture notes
- `tasks.md`

### Scene 5: Execution

Show:

- coding progress
- test or review output
- task progress updates

### Scene 6: Result

Show:

- final delivered artifact
- repo link

## Asset Use By Channel

### GitHub

- GIF near the top of `README.md`
- 2 to 4 screenshots lower on the page or in release posts

### X

- short clip or GIF
- one still screenshot as fallback

### Reddit

- screenshots with text explanation

### Product Hunt

- 3 to 5 screenshots
- one clean cover visual

## What To Avoid

- long silent terminal recordings
- marketing claims without visible proof
- showing internal naming in a confusing way
- mixing `/vibe` and `vibe-autopilot` as if they were the same user-facing command
