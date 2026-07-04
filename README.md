<h1 align="center">VIBE-Claude-Plugin</h1>

<p align="center">
  Turn Claude Code into a document-driven, multi-agent engineering workflow.
</p>

<p align="center">
  <strong>English</strong> | <a href="./README.zh-CN.md">简体中文</a>
</p>

<p align="center">
  <img src="https://img.shields.io/badge/Claude_Code-Compatible-7B61FF?style=for-the-badge&logo=anthropic" alt="Claude Code" />
  <img src="https://img.shields.io/badge/License-MIT-green.svg?style=for-the-badge" alt="License" />
  <img src="https://img.shields.io/badge/PRs-Welcome-brightgreen.svg?style=for-the-badge" alt="PRs Welcome" />
</p>

## What It Is

`VIBE-Claude-Plugin` is a Claude Code plugin that adds a structured software delivery workflow on top of the base coding agent.

It is built for teams and solo builders who want Claude Code to work more like an engineering system:

- clarify requirements first
- produce planning documents
- split work into smaller modules
- code against explicit contracts
- run tests and review steps
- keep moving until delivery

The plugin centers on the `vibe-autopilot` workflow and exposes `/vibe` as the main slash command.

## Why This Exists

Claude Code is strong as a single generalist. Larger tasks still tend to break down when context grows, requirements drift, or code changes lose structure.

This plugin adds process where that usually fails:

- document-driven execution instead of ad hoc prompting
- module-by-module delivery instead of one huge pass
- role separation between planning and implementation
- built-in review, testing, and security checkpoints

## Who It Is For

This project is a fit if you want:

- autonomous project execution with less babysitting
- clearer planning before code generation
- stronger module boundaries in medium or large tasks
- a repeatable workflow for frontend, backend, test, and review stages

It is not a fit if you only want a lightweight prompt pack or a single-shot code generator.

## What It Does

- Adds a `/vibe` command for starting the workflow
- Routes execution into the `vibe-autopilot` engine
- Breaks delivery into requirement analysis, architecture, planning, coding, testing, security review, UI work, and handoff
- Uses a skill-based structure under `skills/`
- Keeps the workflow grounded in generated docs such as PRD, architecture notes, API docs, and `tasks.md`

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
4. run security checks
5. update status in `tasks.md`
6. continue until delivery

## Repository Structure

```text
vibe-claude-plugin/
├── .claude-plugin/
├── commands/
├── skills/
├── README.md
├── README.zh-CN.md
├── CHANGELOG.md
├── 使用手册.md
└── AI_DEVELOPMENT_DOC.md
```

## Core Skills

| Area | Skill | Purpose |
| --- | --- | --- |
| Orchestration | `vibe-autopilot` | Main autonomous workflow |
| Requirement Analysis | `vibe-analyze-req` / `vibe-analyze-new` | New project and existing project analysis |
| Architecture | `vibe-architecture` / `vibe-database` | Architecture and data design |
| Delivery | `vibe-frontend` / `vibe-backend` | Module implementation |
| Quality | `vibe-test` / `vibe-review` | Testing and code review |
| Security | `vibe-security` | Security checks |
| UI | `vibe-ui-design` / `vibe-ui-beautify` | Design and interaction polish |

## Current Limits

Before promoting this heavily, it helps to be explicit about the limits:

- Claude Code native approval dialogs are controlled by the host product, not this plugin
- workflow quality still depends on model quality, repo quality, and tool access
- large autonomous runs still need clean task decomposition and document discipline

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

See [CONTRIBUTING.md](./CONTRIBUTING.md) for contribution expectations and PR guidance.

## License

[MIT](./LICENSE)
