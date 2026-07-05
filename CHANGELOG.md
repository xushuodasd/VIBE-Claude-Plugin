# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.1.0/).

## [2.1.0] - 2026-07-04

### Added

- **vibe-assets skill (NEW)**: Automatic asset acquisition. Fetches icons (Lucide/Iconify), fonts (Google Fonts), images (Unsplash API), illustrations (LottieFiles), and generates SVG logos. Bans placeholder images, emoji icons, and system-default fonts. Skills total: 24 → 25 (also corrected vibe-file-list omission in prior skill lists).
- **vibe-autopilot parallel subagent orchestration (Section 6)**: Explicit instructions for using Claude Code's Task tool to launch parallel sub-agents. Includes parallel decision tree, task template, file isolation rules, and 5-subagent concurrency limit.
- **vibe-autopilot progress dashboard (Section 7)**: Auto-generates `.vibe/progress.html` after each task completion. Users can open it in a browser to see real-time progress, task status, and blocked items without watching the terminal.
- **vibe-autopilot auto-recovery (Section 8)**: Blocked tasks get a second chance after all other tasks complete. AI searches for solutions, tries alternative approaches, and only marks as `[Needs Human]` if the second attempt also fails.
- **vibe-plan API Mock parallel mechanism**: Generates `api-contract.json` and `server.json` alongside `tasks.md`. Frontend develops with Mock, backend develops independently, integration happens last. Tasks now include `depends` and `parallel_group` fields for autopilot parallel scheduling.

### Changed

- **vibe-plan output**: Now generates 5 outputs instead of 3 (added Mock contract and server config).
- **vibe-autopilot**: Sections 6-8 added without modifying sections 1-5. Existing workflow logic preserved.
- **Skills total**: 24 → 25 (corrected vibe-file-list omission in prior lists).
- **README.md / README.zh-CN.md**: Updated skill count to 25, added vibe-assets to sub-command table.
- **install.ps1 / install.sh**: Now also copy `CHANGELOG.md` and `README.zh-CN.md` for complete local documentation.
- **AI_DEVELOPMENT_DOC.md**: Added pitfall 2.21 documenting the vibe-file-list omission root cause and the three-place sync rule for future skill additions.

## [2.0.0] - 2026-07-04

### Added

- **vibe-e2e skill**: End-to-end real browser verification with Playwright. Launches dev server, navigates every route, clicks every button, checks console errors, screenshots every page. P0/P1 issues block delivery.
- **vibe-security auto-install**: AI detects missing security tools (semgrep, gitleaks, pip-audit) and installs them automatically. No manual setup required. Fallback to `scripts/security-setup.ps1` / `scripts/security-setup.sh` if AI install fails.
- **vibe-ui-design design system**: 15+ design styles, 12 industry color palettes, 10 font pairings, 40+ UX guidelines (P0-P7 priority), 30+ pre-delivery UI checklist items, 9 tech stack implementation guides.
- **vibe-ui-beautify animation reference library**: WebFetch-powered learning from ThreeJS Examples, ReactBits, GSAP Showcase, LottieFiles. AI must reference real examples before writing complex WebGL/shader code.
- **vibe-review UI quality checkpoint**: New checkpoint in frontend code review referencing vibe-ui-design Pre-Delivery Checklist.
- **vibe-autopilot Phase 3 E2E step**: E2E verification runs as the first step of Phase 3 (delivery), before API docs.
- **scripts/security-setup.ps1**: Windows fallback script for security tool installation.
- **scripts/security-setup.sh**: macOS/Linux fallback script for security tool installation.
- **VERSION file**: Single source of truth for version number at repo root.
- **Marketplace install support**: Added `.claude-plugin/marketplace.json` for `/plugin install` command.

### Changed

- **vibe-security**: Removed degraded mode. Tools must all be installed before scanning. AI auto-installs missing tools and tells the user if installation fails.
- **vibe-autopilot**: Phase 3 now starts with E2E verification instead of API docs.
- **README.md**: Added Key Capabilities section (Security, E2E, Design System, Animation), Circuit Breakers table, 23 skills table, Phase 3 workflow.
- **AI_DEVELOPMENT_DOC.md**: Full restructure with skill list (23), workflow diagram, 18 pitfall records, 3 core mechanisms.
- **install.ps1 / install.sh**: Now copy `scripts/` directory during installation.
- Skills total: 22 → 23.

### Fixed

- PowerShell 5 compatibility in `security-setup.ps1`: replaced hashtable with independent variables, prefer `pip3` over `pip`.

## [1.0.0] - 2026-07-03

### Added

- Initial release with 22 skills covering the full software delivery lifecycle.
- `/vibe` slash command as the public entry point.
- `vibe-autopilot` 24-hour autonomous workflow engine.
- Document-driven execution: PRD, architecture, database, API contracts, `tasks.md`.
- Module-by-module delivery with subagent delegation.
- Built-in testing, security review, code review, and UI design skills.
- Circuit breakers for test, security, and animation failures.
- English-first README with Chinese documentation support.
- GitHub issue templates and pull request template.
- Launch planning, release notes, contribution guide, and demo asset guidance.
- Marketplace and plugin metadata with consistent English descriptions.
