<h1 align="center">🚀 VIBE-Claude-Plugin</h1>

<p align="center">
  <strong>让 Claude Code 变身 24 小时无人值守的虚拟软件公司</strong><br>
  <em>A 24/7 Autonomous Multi-Agent Framework for Claude Code</em>
</p>

<p align="center">
  <img src="https://img.shields.io/badge/Claude_Code-Compatible-7B61FF?style=for-the-badge&logo=anthropic" alt="Claude Code" />
  <img src="https://img.shields.io/badge/License-MIT-green.svg?style=for-the-badge" alt="License" />
  <img src="https://img.shields.io/badge/PRs-Welcome-brightgreen.svg?style=for-the-badge" alt="PRs Welcome" />
</p>

---

## 💡 这是什么？(What is this?)

**VIBE-Claude-Plugin** 是一个专为 **Claude Code** 打造的全链路 AI 编程技能库（Skill Library）。

Claude Code 原生是一个强大的“单体全栈工程师”，但由于大模型上下文窗口的限制，在开发中大型项目时极易出现“幻觉”、“代码越改越乱”、“死循环烧 Token”的问题。

本项目通过注入 **22 个强制性 Markdown 工作流**，用纯文本协议将 Claude Code Hack 成了一个**多智能体（Multi-Agent）系统**。它赋予了 AI “研发总监”与“底层员工”的身份隔离能力，实现了真正的 **24 小时零点击全自动开发**。

## ✨ 核心杀手锏 (Killer Features)

- 🤖 **Smart Autopilot (自动驾驶引擎)**：只需一句话触发，AI 自动完成 `需求对齐 -> 架构设计 -> 拆解任务 -> 循环写代码 -> 测试 -> 安全审查 -> UI美化 -> 交付` 的全生命周期，期间**无需人类确认 (No Human Pauses)**。
- 👥 **子智能体分发 (Subagent Delegation)**：强制的身份催眠（Persona Injection）。让 AI 扮演“总监”时只看全局架构，扮演“员工”时视野被物理隔离在单个组件中，彻底根除上下文精神分裂。
- 🛡️ **事不过三熔断器 (Circuit Breaker)**：内置防死磕机制。修 Bug 超过 3 次自动标记阻塞并跳过，绝不浪费你的 API 余额。
- 🏭 **企业级契约驱动 (Contract-Driven)**：无 API 文档不开发，前后端强制分层（Controller/Service/DAO & Pages/Components/Hooks），输出真正的工业级可用代码。
- 🎨 **“果汁感”动效注入**：内置专属于现代前端的 `vibe-ui-beautify` 技能，自动为你的应用注入深色工业风、3D 视效及符合物理直觉的阻尼反馈。

## 📦 极简安装 (Installation)

由于 Claude Code 的安全机制与插件规范，你需要通过以下正规方式安装本插件：

### 方式一：克隆到本地全局插件目录（推荐）

直接将本仓库克隆到 Claude Code 的官方全局插件目录下。

**对于 Mac/Linux 用户：**
```bash
git clone https://github.com/xushuodasd/VIBE-Claude-Plugin.git ~/.claude/plugins/vibe-claude-plugin
```

**对于 Windows 用户 (PowerShell)：**
```powershell
# 1. 确保插件目录存在
New-Item -ItemType Directory -Force -Path "$env:USERPROFILE\.claude\plugins" | Out-Null
# 2. 将项目克隆到插件目录
git clone https://github.com/xushuodasd/VIBE-Claude-Plugin.git "$env:USERPROFILE\.claude\plugins\vibe-claude-plugin"
```

克隆完成后，**重启你的 Claude Code** 即可生效。

### 方式二：项目级别安装 (Project Level)

如果你只想在当前项目中使用，可以将本仓库的文件直接放置在项目根目录下的 `.claude` 文件夹中：
```bash
git clone https://github.com/xushuodasd/VIBE-Claude-Plugin.git .claude/plugins/vibe-claude-plugin
```

重启 Claude Code 生效。

## 🚀 开启全自动开发 (Usage)

为了实现真正的零点击挂机，请在启动时信任终端（`claude --trust`），然后在聊天框输入魔法指令：

> **“开启全自动开发：我要从头做一个前端待办事项网站。要求深色工业风，按钮有物理反馈感。后端用 Node.js 存 SQLite。”**

### 运作流程：
1. **🗣️ 需求期（它会主动问你）**：它会化身产品经理和架构师，出具 PRD、架构图和 `tasks.md` 任务清单，并向你做最后确认。
2. **🤫 开发期（它将彻底闭嘴）**：一旦你同意开始，它将化身总监和无情的编码机器。不再问“您看这样可以吗”，遇到报错自动用最优解修复，自动切分支、跑测试、提交 Git Commit，直到整个清单全部打勾。

## 📂 技能库清单 (Skills Catalog)

| 阶段 | 核心技能 | 作用 |
| --- | --- | --- |
| **中枢神经** | `vibe-autopilot` | **24小时全自动无人值守编程引擎** |
| 需求阶段 | `vibe-analyze-req` / `new` | 全新项目或老项目的新需求分析，生成 PRD |
| 架构设计 | `vibe-architecture` / `database`| 架构分层、技术栈选型与 ER 模型设计 |
| 开发阶段 | `vibe-frontend` / `backend` | **子智能体最小模块隔离开发** |
| 质量保证 | `vibe-test` / `vibe-review` | TDD 测试驱动与代码质量审查 |
| 安全审查 | `vibe-security` | 防注入、防越权及依赖漏洞扫描 |
| 视觉交互 | `vibe-ui-design` / `beautify` | 现代化深色工业风 UI 与 3D 动效美化 |
| ... | 其他 11 个技能 | 涵盖 API 规范、部署、版本迭代等全链路 |

## 📖 详细文档
- [使用手册 (User Guide)](./使用手册.md)
- [AI 开发防坑指南 (AI Development Doc)](./AI_DEVELOPMENT_DOC.md)

## 🤝 贡献 (Contributing)
欢迎提交 Pull Requests 或 Issues。如果你发现了新的大模型“幻觉”痛点，欢迎在 `skills` 目录下增加你的专属“紧箍咒”。

## 📄 许可证 (License)
本项目基于 [MIT License](./LICENSE) 开源。