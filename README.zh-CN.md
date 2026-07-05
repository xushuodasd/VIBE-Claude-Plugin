<h1 align="center">VIBE-Claude-Plugin</h1>

<p align="center">
  把 Claude Code 变成一个能从一句想法出发，主动澄清需求、规划实现并持续交付的工程系统。
</p>

<p align="center">
  <a href="./README.md">English</a> | <strong>简体中文</strong>
</p>

<p align="center">
  <img src="https://img.shields.io/badge/Claude_Code-Compatible-7B61FF?style=for-the-badge&logo=anthropic" alt="Claude Code" />
  <img src="https://img.shields.io/badge/License-MIT-green.svg?style=for-the-badge" alt="License" />
  <img src="https://img.shields.io/badge/PRs-Welcome-brightgreen.svg?style=for-the-badge" alt="PRs Welcome" />
</p>

## 这是什么

`VIBE-Claude-Plugin` 是一个面向 Claude Code 的插件。它不是单纯的提示词合集，而是一套把需求、架构、拆解、编码、测试、审查、交付串起来的工程化工作流。

它的核心目标很明确：让 Claude Code 在处理中大型任务时，少一点上下文失控，少一点反复重写，多一点可追踪、可复盘、可持续推进的交付过程。

它面向的不只是熟悉技术的人。如果你只是知道自己想做什么，但说不清表结构、接口设计、模块边界，它也应该能先把问题问明白，再把事情往下推进。

项目的核心引擎是 `vibe-autopilot`，对外入口是 `/vibe` 斜杠命令。

## 为什么要做它

Claude Code 本身很强，但当任务变长、模块变多、约束变复杂时，常见问题会一起出现：

- 需求没有对齐就开始写
- 文档缺失，前后端契约飘移
- 一个上下文里塞太多模块，改着改着变乱
- 修一个问题时顺手破坏另一个问题

这个插件就是为了解决这些工程化失控点。它补的不是“更会写代码”，而是“更像一个有流程的研发系统”。

## 它和普通代码生成有什么不同

很多代码工具的前提是：用户已经能把需求描述得足够完整。但真实世界里，很多人只有一个模糊想法，甚至不知道该怎么提需求。

这个插件想解决的正是这一步：

- 你可以先用自然语言说出一个粗略想法
- 它会主动追问关键细节，把需求问清楚
- 就算你不懂技术名词，它也会把目标整理成可执行的文档和任务
- 一旦进入执行阶段，它会沿着文档、任务和检查点持续推进，而不是只吐出一大段代码就停下

更接近的体验是“把你想做的产品讲出来”，而不是“你必须先写出一条足够专业的 prompt”。

## 适合谁

如果你符合下面几类场景，这个项目会比较适合：

- 想让 Claude Code 更少人工盯守
- 希望 AI 先把需求问明白，再进入开发
- 本身不是专业开发者，但希望把一个想法落成项目
- 想先出文档和任务清单，再进入开发
- 希望前后端、测试、安全、UI 都按固定流程推进
- 希望中大型任务按最小模块逐步完成，而不是一次性生成一大片代码

如果你只是想要一个简单 prompt 包，或者更偏向一次性快速生成，这个项目不是最优解。

## 它能做什么

- 提供 `/vibe` 作为统一启动入口
- 通过 `/vibe` 触发 `vibe-autopilot` 自动驾驶引擎
- 把不完整的想法，通过追问和整理，变成可执行的需求文档
- 按 `需求分析 -> 架构设计 -> 任务拆解 -> 编码 -> 测试 -> 审查 -> 安全 -> 交付` 的顺序推进
- 用 `skills/` 下的技能体系约束每个阶段的职责
- 用 PRD、架构文档、API 文档、`tasks.md` 这些产物承载状态，而不是只靠上下文记忆

## 为什么这些点值得写进 GitHub 首页

一个第一次来到仓库的人，最关心的通常不是“你有多少个 skill”，而是“我只有一个想法时，你到底能不能帮我做出来”。

这个项目首页需要明确传达的体验应该是：

1. 你先说想做什么
2. 系统主动把缺失信息问出来
3. 产出计划和任务清单
4. 再按模块持续自动化推进

因为真正稀缺的，不是单次生成代码，而是把“需求澄清 + 文档规划 + 模块化开发 + 长链路自动推进”放进同一个工作流里。

## 快速安装

### 方式一：通过 Marketplace 安装

打开 `~/.claude/settings.json`，加入：

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

重启 Claude Code，然后执行：

```bash
/plugin install vibe-claude-plugin@vibe
```

### 方式二：直接克隆到插件目录

Windows PowerShell：

```powershell
New-Item -ItemType Directory -Force -Path "$env:USERPROFILE\.claude\plugins" | Out-Null
git clone https://github.com/xushuodasd/VIBE-Claude-Plugin.git "$env:USERPROFILE\.claude\plugins\vibe-claude-plugin"
```

macOS / Linux：

```bash
git clone https://github.com/xushuodasd/VIBE-Claude-Plugin.git ~/.claude/plugins/vibe-claude-plugin
```

重启 Claude Code 后先执行：

```bash
/plugins
```

确认列表里有 `vibe-claude-plugin`。

## 如何使用

### 主入口

最常用的命令就是 `/vibe`。内部由 `vibe-autopilot` 引擎负责执行。

```bash
/vibe 帮我做一个深色风格的 SaaS 管理后台，后端用 Node.js 和 PostgreSQL，要有 RBAC、测试和部署文档。
```

如果你只输入 `/vibe` 或者描述比较粗略，系统会先主动问你问题，把需求聊清楚，然后再进入计划、编码、测试、安全审查和交付。

为了减少执行过程中的权限打断，建议用信任模式启动 Claude Code：

```bash
claude --trust
```

### 子命令速查表

大部分场景用 `/vibe` 就够了。下面的子命令适合在特定环节单独调用：

| 命令 | 用途 |
|---|---|
| `/vibe-analyze-req` | 新项目需求分析，输出 PRD |
| `/vibe-analyze-new` | 已有项目新增功能分析 |
| `/vibe-architecture` | 设计整体架构与部署方案 |
| `/vibe-database` | 设计数据库表结构与 ER 图 |
| `/vibe-framework` | 定义技术框架与非功能性设计 |
| `/vibe-api-rules` | 制定 RESTful API 规范 |
| `/vibe-plan` | 根据已有文档生成 `tasks.md` 开发计划 |
| `/vibe-frontend` | 按 API 契约实现前端模块 |
| `/vibe-backend` | 按 API 契约实现后端模块 |
| `/vibe-test` | 编写或运行单元/集成测试 |
| `/vibe-review` | 代码审查，检查质量与规范 |
| `/vibe-security` | 安全扫描（semgrep/gitleaks/依赖审计/OWASP Top 10） |
| `/vibe-ui-design` | 输出视觉设计系统与设计令牌 |
| `/vibe-ui-beautify` | 注入微交互与动画 |
| `/vibe-assets` | 自动获取图片、图标、字体、插画、Logo |
| `/vibe-integrate` | 前后端联调与 API 对接测试 |
| `/vibe-e2e` | 启动真实浏览器，逐页逐按钮验证 |
| `/vibe-api-docs` | 从代码生成 API 文档 |
| `/vibe-startup` | 编写项目启动文档 |
| `/vibe-deploy` | 编写部署与运维文档 |
| `/vibe-bug-tracker` | 记录与分类 Bug |
| `/vibe-stage-update` | 更新项目阶段状态 |
| `/vibe-ai-workflow` | 创建新的 AI 工作流 SOP |

### 常用示例

**从一个想法开始完整项目：**

```bash
/vibe 帮我做一个深色工业风的待办 App，用 SQLite，支持用户登录。
```

**先出计划再开发：**

```bash
/vibe-plan 我已经有 PRD 和 API 文档了，生成 MVP 的 tasks.md。
```

**只写前端：**

```bash
/vibe-frontend 根据 ./docs/api/users.md 实现用户资料页。
```

**补测试：**

```bash
/vibe-test 给 UserService 写单元测试，覆盖率要到 80%。
```

**交付前安全扫描：**

```bash
/vibe-security 对当前项目做一次 OWASP Top 10 扫描。
```

**交付前浏览器验证：**

```bash
/vibe-e2e 打开浏览器，验证每个页面都能渲染、每个按钮都能点。
```

## 工作流怎么跑

### 第一阶段：需求对齐

这一阶段允许提问，核心任务是把方向定准，并生成过程文档：

- PRD
- 架构设计
- 数据库设计
- API 文档
- `tasks.md`

### 第二阶段：自动推进

确认开始后，工作流会围绕 `tasks.md` 逐项推进：

1. 读取下一个最小任务
2. 在受限上下文里实现该模块
3. 跑测试和代码审查
4. 做安全检查
5. 更新任务状态
6. 继续下一项，直到交付

## 仓库结构

```text
vibe-claude-plugin/
├── .claude-plugin/
├── commands/
├── skills/
├── README.md
├── README.zh-CN.md
├── 使用手册.md
└── AI_DEVELOPMENT_DOC.md
```

## 核心技能

| 模块 | 技能 | 作用 |
| --- | --- | --- |
| 调度中枢 | `vibe-autopilot` | 自动驾驶主流程 |
| 需求分析 | `vibe-analyze-req` / `vibe-analyze-new` | 新项目与已有项目需求分析 |
| 架构设计 | `vibe-architecture` / `vibe-database` | 架构和数据设计 |
| 交付实现 | `vibe-frontend` / `vibe-backend` | 最小模块编码 |
| 质量保障 | `vibe-test` / `vibe-review` | 测试与代码审查 |
| 安全审查 | `vibe-security` | 安全检查 |
| 视觉体验 | `vibe-ui-design` / `vibe-ui-beautify` | UI 设计与动效美化 |
| 素材获取 | `vibe-assets` | 真实图标/字体/图片/插画/Logo 自动获取 |
| 真机验证 | `vibe-e2e` | Playwright 浏览器逐页逐按钮验证 |
| 工作流 | `vibe-ai-workflow` / `vibe-file-list` | 工作流生成与文件清单规范 |

## 当前边界

为了让项目更容易传播，边界也需要写清楚：

- Claude Code 原生的英文审批弹窗由宿主控制，插件不能改成中文
- 自动化效果依赖模型能力、仓库质量和工具权限
- 长链路无人值守要建立在文档和任务拆解做得足够好的前提上

## 相关文档

- [English README](./README.md)
- [使用手册](./使用手册.md)
- [AI 开发文档](./AI_DEVELOPMENT_DOC.md)
- [宣发文案](./MARKETING_COPY.md)

## 怎么让它更容易火起来

我建议按这个顺序做：

1. 在 README 顶部补一个 30 到 90 秒的演示视频或 GIF
2. 做 2 到 3 个真实案例，展示从一句需求到交付的全过程
3. 同时发中文和英文社区，文案统一但表达各自本地化
4. 把早期用户的安装问题、误解点和成功案例持续写回文档

## 贡献

欢迎提 Issue 和 Pull Request。优先级最高的贡献方向包括：

- 更稳定的自动化约束
- 更顺滑的安装体验
- 更强的案例和演示素材
- 更清晰的工作流文档

## 许可证

[MIT](./LICENSE)
