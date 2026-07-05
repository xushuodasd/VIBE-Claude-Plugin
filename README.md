<h1 align="center">VIBE-Claude-Plugin</h1>

<p align="center">
  Turn Claude Code into a document-driven engineering system that can clarify, plan, and ship projects from a single idea.
</p>

<p align="center">
  <strong>English</strong> | <a href="./README.zh-CN.md">简体中文</a>
</p>

<p align="center">
  <img src="https://img.shields.io/badge/Claude_Code-Compatible-7B61FF?style=for-the-badge&logo=anthropic" alt="Claude Code" />
  <img src="https://img.shields.io/badge/Skills-23-blue.svg?style=for-the-badge" alt="23 Skills" />
  <img src="https://img.shields.io/badge/License-MIT-green.svg?style=for-the-badge" alt="License" />
  <img src="https://img.shields.io/badge/PRs-Welcome-brightgreen.svg?style=for-the-badge" alt="PRs Welcome" />
</p>

## What It Is

`VIBE-Claude-Plugin` is a Claude Code plugin that adds a structured software delivery workflow on top of the base coding agent.

It is built for teams, solo builders, and even non-technical users who want Claude Code to work more like an engineering system:

- clarify requirements through follow-up questions
- produce planning documents
- split work into smaller modules
- code against explicit contracts
- run tests, security scans, and E2E verification
- keep moving until delivery

The plugin centers on the `vibe-autopilot` workflow and exposes `/vibe` as the main slash command.

## Why This Exists

Claude Code is strong as a single generalist. Larger tasks still tend to break down when context grows, requirements drift, or code changes lose structure.

This plugin adds process where that usually fails:

- document-driven execution instead of ad hoc prompting
- module-by-module delivery instead of one huge pass
- role separation between planning and implementation
- built-in review, testing, security, and E2E checkpoints
- real browser verification before delivery, not just code-level tests

## What Feels Different

Most coding agents are still strongest when the user already knows how to describe the target system. This plugin is designed for a more realistic workflow:

- start from a rough idea instead of a polished spec
- ask follow-up questions until the requirement becomes buildable
- help inexperienced users express what they want in plain language
- keep execution moving through documents, tasks, and checkpoints instead of stopping at the first large answer
- verify the actual running application before calling it "done"

The result is closer to "describe the product you want" than "write the right prompt in one shot".

## Who It Is For

This project is a fit if you want:

- autonomous project execution with less babysitting
- an agent that can ask better questions before it writes code
- a workflow that helps turn non-technical intent into executable requirements
- clearer planning before code generation
- stronger module boundaries in medium or large tasks
- a repeatable workflow for frontend, backend, test, security, E2E, and review stages
- real browser verification so you don't ship a broken UI

It is not a fit if you only want a lightweight prompt pack or a single-shot code generator.

## What It Does

- Adds a `/vibe` command for starting the workflow
- Routes execution into the `vibe-autopilot` engine
- Turns incomplete ideas into structured requirements through guided questioning
- Breaks delivery into requirement analysis, architecture, planning, coding, testing, security review, E2E verification, UI work, and handoff
- Uses a skill-based structure under `skills/` with **23 specialized skills**
- Keeps the workflow grounded in generated docs such as PRD, architecture notes, API docs, and `tasks.md`
- Auto-installs security tools (semgrep, gitleaks, pip-audit) when missing
- Opens a real browser with Playwright to verify every page and button before delivery

## Why It Matters For GitHub Visitors

If you land on this repository with only an idea in mind, the intended experience is:

1. describe the product in plain language
2. let the workflow ask for the missing details
3. approve the generated plan
4. let the system deliver module by module
5. get a verified, working application — not just code that compiles

That combination matters because few coding workflows package requirement discovery, structured planning, modular delivery, real browser verification, and long-running autonomous execution into one plugin.

## Quick Start

### Option 1: Install from Marketplace

Add this to `~/.claude/settings.json`:

```json
{
  "extraKnownMarketplaces": {
    "vibe": {
      "source": {
        "source": "github",
        "repo": "xushuodasd/VIBE-Claude-Plugin"
      }
    }
  }
}
```

Restart Claude Code, then run:

```bash
/plugin install vibe-claude-plugin@vibe
```

### Option 2: Clone into the Plugins Directory

Windows PowerShell:

```powershell
New-Item -ItemType Directory -Force -Path "$env:USERPROFILE\.claude\plugins" | Out-Null
git clone https://github.com/xushuodasd/VIBE-Claude-Plugin.git "$env:USERPROFILE\.claude\plugins\vibe-claude-plugin"
```

macOS / Linux:

```bash
git clone https://github.com/xushuodasd/VIBE-Claude-Plugin.git ~/.claude/plugins/vibe-claude-plugin
```

Restart Claude Code and verify the plugin is loaded:

```bash
/plugins
```

## Usage

Start the workflow with `/vibe`. The slash command is the public entry point. Internally, it triggers the `vibe-autopilot` engine.

```bash
/vibe Build a dark-mode SaaS admin panel with Node.js, PostgreSQL, role-based access control, tests, and deployment docs.
```

If you run `/vibe` without a full requirement, the workflow should begin with requirement discovery and planning.

For fewer approval interruptions during execution, start Claude Code with trust enabled:

```bash
claude --trust
```

## How The Workflow Runs

### Phase 1: Requirement Alignment

The plugin asks questions, clarifies scope, and generates planning artifacts such as:

- PRD
- architecture notes
- database design
- API contracts
- `tasks.md`

### Phase 2: Autonomous Delivery

After approval, the workflow moves through the engineering loop:

1. pick the next smallest task
2. implement in a constrained context
3. test and review
4. run security checks (auto-installs tools if missing)
5. update status in `tasks.md`
6. continue until all tasks complete

### Phase 3: Verification & Handoff

1. **E2E real browser verification** — Playwright opens the app, navigates every route, clicks every button, checks console errors, and screenshots every page
2. frontend-backend integration testing
3. API documentation update
4. deployment and ops documentation
5. bug tracking and delivery summary

## Core Skills (23)

| Area | Skill | Purpose |
| --- | --- | --- |
| Orchestration | `vibe-autopilot` | Main autonomous workflow engine |
| Requirement Analysis | `vibe-analyze-req` / `vibe-analyze-new` | New project and existing project analysis |
| Architecture | `vibe-architecture` / `vibe-database` / `vibe-framework` | Architecture, data, and framework design |
| API | `vibe-api-rules` / `vibe-api-docs` | API design standards and documentation |
| Planning | `vibe-plan` | Task decomposition and delivery staging |
| Implementation | `vibe-frontend` / `vibe-backend` | Module-level coding |
| Integration | `vibe-integrate` | Frontend-backend integration testing |
| Quality | `vibe-test` / `vibe-review` | TDD testing and code review |
| Security | `vibe-security` | OWASP Top 10 scanning with auto-installed tools |
| E2E Verification | `vibe-e2e` | Real browser verification with Playwright |
| UI Design | `vibe-ui-design` | Design system with 15+ styles, industry palettes, UX guidelines |
| UI Polish | `vibe-ui-beautify` | Motion design with WebFetch-powered animation references |
| Delivery | `vibe-startup` / `vibe-deploy` / `vibe-bug-tracker` / `vibe-stage-update` | Documentation and handoff |
| Workflow | `vibe-ai-workflow` / `vibe-file-list` | Workflow generation and file conventions |

## Key Capabilities

### Security Scanning
- **Auto-installs tools**: semgrep, gitleaks, pip-audit, npm audit — no manual setup needed
- **Layered scanning**: dependency CVE → SAST → secret detection → AI business logic audit
- **No silent degradation**: if a tool can't be installed, AI tells you exactly what failed instead of skipping it

### E2E Real Browser Verification
- Launches the dev server and opens a real Chromium browser
- Navigates every route, clicks every button, fills every form
- Checks console errors (zero red errors required)
- Screenshots every page as delivery evidence
- Mobile device testing (iPhone, iPad, Android)
- **P0/P1 issues block delivery** until fixed

### Design System
- 15+ design styles (glassmorphism, brutalism, minimalism, bento grid, etc.)
- 12 industry color palettes (SaaS, e-commerce, medical, finance, etc.)
- 10 font pairings with loading best practices
- 40+ UX guidelines ranked by priority (P0 accessibility → P7 charts)
- Pre-delivery UI checklist with 30+ items
- 9 tech stack implementation guides (React, Vue, Flutter, SwiftUI, etc.)

### Animation Reference Library
- AI uses WebFetch to learn from ThreeJS Examples, ReactBits, GSAP Showcase, and more
- No guessing complex WebGL/shader code — always references real examples first
- Includes React Three Fiber integration for 3D scenes
- Performance-first: 60fps required, 3 failed attempts trigger circuit breaker

## Repository Structure

```text
vibe-claude-plugin/
├── .claude-plugin/          # Plugin metadata
│   ├── plugin.json          # Plugin registration
│   └── marketplace.json     # Marketplace registration
├── commands/                # Slash commands
│   └── vibe.md              # /vibe entry command
├── skills/                  # 23 specialized skills
├── scripts/                 # Tool installation scripts
│   ├── security-setup.ps1   # Windows security tools
│   └── security-setup.sh    # macOS/Linux security tools
├── README.md                # This file (English)
├── README.zh-CN.md          # Chinese documentation
├── CHANGELOG.md             # Version history
├── 使用手册.md              # Chinese user manual
└── AI_DEVELOPMENT_DOC.md    # AI development notes
```

## Circuit Breakers

The workflow includes three circuit breakers that prevent token waste:

| Breaker | Trigger | Action |
| --- | --- | --- |
| **Test** | 3 consecutive test failures | Mark `[Blocked]`, skip, move on |
| **Security** | 3 consecutive fix failures | Mark `[Blocked]`, report, move on |
| **Animation** | 3 consecutive 60fps failures | Mark `[Blocked]`, skip, move on |

## Current Limits

Before promoting this heavily, it helps to be explicit about the limits:

- Claude Code native approval dialogs are controlled by the host product, not this plugin
- workflow quality still depends on model quality, repo quality, and tool access
- large autonomous runs still need clean task decomposition and document discipline
- security tools require a package manager (npm/pip/brew/choco) for auto-installation

## Documentation

- [Changelog](./CHANGELOG.md)
- [Contributing](./CONTRIBUTING.md)
- [Demo Assets](./DEMO_ASSETS.md)
- [Marketing Copy](./MARKETING_COPY.md)
- [Launch Plan](./LAUNCH_PLAN.md)
- [Release Notes](./RELEASE_NOTES.md)
- [AI Development Notes](./AI_DEVELOPMENT_DOC.md)

## Promotion Plan

If you want this repo to grow, the most effective sequence is:

1. add a short demo GIF or video to the top of this README
2. publish 2 to 3 real delivery case studies
3. post English-first launch content to GitHub, X, Reddit, and Product Hunt
4. collect feedback from early users and convert it into installation fixes and clearer docs

## Contributing

Issues and pull requests are welcome. Strong contributions include:

- better workflow constraints
- clearer onboarding
- reproducible case studies
- safer autonomous execution patterns
- new skill modules or design style additions

See [CONTRIBUTING.md](./CONTRIBUTING.md) for contribution expectations and PR guidance.

## License

[MIT](./LICENSE)
