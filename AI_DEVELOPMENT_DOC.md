# AI_DEVELOPMENT_DOC

> **当前版本：2.0.0** | 版本号定义在 `VERSION` 文件和 `plugin.json` 中，单一来源为 `VERSION` 文件。

## 文档目的
本文档用于记录 VIBE-Claude-Plugin 框架开发过程中的架构设计、核心逻辑、踩坑记录及经验总结，以便于 AI 在后续开发或维护中参考，避免重复犯错。

## 版本管理规范
- **版本号来源**：仓库根目录的 `VERSION` 文件是版本号的**单一来源（Single Source of Truth）**，只包含一行 `MAJOR.MINOR.PATCH`。
- **同步位置**：`plugin.json` 的 `version` 字段必须与 `VERSION` 文件保持一致。
- **语义化版本（SemVer）**：
  - `MAJOR`：不兼容的架构变更（如新增技能、删除技能、工作流重大调整）
  - `MINOR`：向后兼容的功能增强（如技能内新增章节、新增配置项）
  - `PATCH`：Bug 修复、文档修正、兼容性修复
- **版本查询**：用户问"vibe 版本"时，AI 读取 `VERSION` 文件回答。
- **发布流程**：每次发布时更新 `VERSION` → 同步 `plugin.json` → 更新 `CHANGELOG.md` → 提交并推送。

## 1. 核心架构与逻辑
本插件参考了 `superpowers` 的设计模式，将软件工程生命周期拆解为多个独立的、可由 Claude Code 自动触发的 Skill 模块。

### 1.1 技能(Skill)运作机制
- **触发机制**：通过 `SKILL.md` 的 `description` 和 `name` 字段，Claude Code 能在用户输入自然语言时（例如"帮我测试这个功能"、"优化一下页面的动画"）自动匹配并执行相应的规则。
- **强制约束**：每个技能都内嵌了工作流结构（前置步骤 -> 沟通 -> 执行 -> 验证），强制 AI 遵循"先思考方案，再一次性改好"的原则。

### 1.2 企业级分层与子智能体分发 (Subagent Delegation)
由于 AI 上下文窗口的限制，如果让单个 AI 处理整个页面的开发，极易出现逻辑遗漏或代码幻觉。为了达到企业级开发标准：
1. **文档驱动 (Document-Driven)**：所有编码动作（`vibe-frontend` / `vibe-backend`）前必须先验证对应的 API 接口文档存在，做到**无文档不开发，有文档 100% 对齐契约**。
2. **最小模块化 (Minimal Modularization)**：系统必须拆解为最小单元（例如：单一按钮组件、单独的数据持久层 DAO）。
3. **分层架构**：前端严格遵守 `Pages -> Components -> Hooks -> API Clients` 分层；后端严格遵守 `Controller -> Service -> Repository -> Model` 分层。
4. **子智能体开发**：在 Autopilot 引擎调度下，对每一个最小模块分配一次独立的开发上下文，开发完成后再进行组合，避免记忆混乱。

### 1.3 目录结构
```text
vibe-claude-plugin/
  ├── .claude-plugin/          # 插件元数据
  │   ├── plugin.json          # 插件注册信息
  │   └── marketplace.json     # Marketplace 注册信息
  ├── commands/                # 斜杠命令
  │   └── vibe.md              # /vibe 入口命令
  ├── skills/                  # 核心技能目录（23个）
  │   ├── vibe-autopilot/      # 24小时无人值守引擎
  │   ├── vibe-analyze-req/    # 全新项目需求分析
  │   ├── vibe-analyze-new/    # 已有项目新需求分析
  │   ├── vibe-architecture/   # 架构设计
  │   ├── vibe-database/       # 数据库设计
  │   ├── vibe-framework/      # 框架设计
  │   ├── vibe-api-rules/      # API 设计规范
  │   ├── vibe-api-docs/       # API 文档生成
  │   ├── vibe-plan/           # 任务拆解
  │   ├── vibe-frontend/       # 前端开发
  │   ├── vibe-backend/        # 后端开发
  │   ├── vibe-integrate/      # 前后端联调
  │   ├── vibe-test/           # 测试（TDD）
  │   ├── vibe-security/       # 安全审查
  │   ├── vibe-review/         # 代码审查
  │   ├── vibe-ui-design/      # UI/UX 设计系统
  │   ├── vibe-ui-beautify/    # 动效与美化
  │   ├── vibe-e2e/            # 端到端真机验证
  │   ├── vibe-bug-tracker/    # Bug 追踪
  │   ├── vibe-stage-update/   # 阶段更新
  │   ├── vibe-startup/        # 启动文档
  │   ├── vibe-deploy/         # 部署运维文档
  │   ├── vibe-file-list/      # 文件清单规范
  │   └── vibe-ai-workflow/    # 工作流生成器
  ├── scripts/                 # 工具安装脚本
  │   ├── security-setup.ps1   # Windows 安全工具安装
  │   └── security-setup.sh    # Mac/Linux 安全工具安装
  ├── install.ps1              # Windows 插件安装脚本
  ├── install.sh               # Mac/Linux 插件安装脚本
  ├── README.md                # 插件说明（英文主版）
  ├── AI_DEVELOPMENT_DOC.md    # AI 开发记录与避坑指南
  └── 使用手册.md              # 中文使用手册
```

### 1.4 全链路开发流程

```
用户输入 /vibe + 需求
    ↓
═══════════════════════════════════════════
阶段一：需求期（允许且鼓励提问）
═══════════════════════════════════════════
  ├─ vibe-analyze-req / vibe-analyze-new  → PRD
  ├─ vibe-architecture                    → 架构设计
  ├─ vibe-database                        → 数据库设计
  ├─ vibe-framework                       → 框架设计
  ├─ vibe-api-rules                       → API 规范
  ├─ vibe-plan                            → tasks.md
  └─ 最后确认："是否开始全自动开发？"
    ↓
═══════════════════════════════════════════
阶段二：开发期（绝对静默，无人值守循环）
═══════════════════════════════════════════
  读取 tasks.md 中每个 [ ] 任务：
  ├─ vibe-ui-design   → 建立设计系统（前端任务前置）
  ├─ vibe-frontend / vibe-backend → 最小模块编码
  ├─ vibe-test        → TDD 红→绿→重构（3次失败熔断）
  ├─ vibe-security    → 安全扫描（工具缺失自动安装）
  ├─ vibe-review      → 代码审查（含 UI 质量检查）
  ├─ vibe-ui-beautify → 动效注入（3次掉帧熔断）
  ├─ 打勾 [x] + Git Commit
  └─ 继续下一个任务
    ↓
═══════════════════════════════════════════
阶段三：交付期
═══════════════════════════════════════════
  ├─ vibe-e2e        → 端到端真机验证（Playwright 打开浏览器逐页验证）
  ├─ vibe-integrate  → 前后端联调
  ├─ vibe-api-docs   → 更新 API 文档
  ├─ vibe-startup    → 启动文档
  ├─ vibe-deploy     → 部署运维文档
  ├─ vibe-bug-tracker → Bug 记录
  ├─ vibe-stage-update → 阶段更新
  └─ 输出交付总结报告
```

### 1.5 技能全清单（23个）

| #   | 技能              | 职能                   | 触发场景        |
| --- | ----------------- | ---------------------- | --------------- |
| 1   | vibe-autopilot    | 总指挥，24h 全自动引擎 | `/vibe` 触发    |
| 2   | vibe-analyze-req  | 全新项目需求分析       | 新项目需求      |
| 3   | vibe-analyze-new  | 已有项目新需求分析     | 增量需求        |
| 4   | vibe-architecture | 架构设计               | 需求确认后      |
| 5   | vibe-database     | 数据库设计             | 架构确认后      |
| 6   | vibe-framework    | 框架设计               | 架构确认后      |
| 7   | vibe-api-rules    | API 设计规范           | 开发前          |
| 8   | vibe-api-docs     | API 文档生成           | 交付期          |
| 9   | vibe-plan         | 任务拆解               | 需求/架构完成后 |
| 10  | vibe-frontend     | 前端开发               | 开发期循环      |
| 11  | vibe-backend      | 后端开发               | 开发期循环      |
| 12  | vibe-integrate    | 前后端联调             | 交付期          |
| 13  | vibe-test         | 测试（TDD）            | 编码后立即      |
| 14  | vibe-security     | 安全审查               | 测试通过后      |
| 15  | vibe-review       | 代码审查（含 UI 质量） | 安全通过后      |
| 16  | vibe-ui-design    | UI/UX 设计系统         | 前端编码前      |
| 17  | vibe-ui-beautify  | 动效与美化             | review 通过后   |
| 18  | vibe-e2e          | 端到端真机验证         | 交付前最后防线  |
| 19  | vibe-bug-tracker  | Bug 追踪               | 交付期          |
| 20  | vibe-stage-update | 阶段更新               | 阶段切换时      |
| 21  | vibe-startup      | 启动文档               | 交付期          |
| 22  | vibe-deploy       | 部署运维文档           | 交付期          |
| 23  | vibe-ai-workflow  | 工作流生成器           | 创建新工作流    |

### 1.6 三大核心机制

1. **身份催眠 (Persona Injection)**：开发类技能强制声明身份（总监看全局、员工只看单模块），物理隔离上下文
2. **事不过三熔断器**：测试/安全/动效/真机验证连续 3 次失败自动标记 `[Blocked]` 跳过，不烧 Token
3. **状态机依赖**：所有进度写在 `tasks.md`，不靠记忆，`/clear` 后读文件即可满血复活

## 2. 踩坑记录与避坑指南

### 2.1 坑点：技能包安装不等于插件安装
- **问题描述**：把 `skills/` 单独复制到 `~/.claude/skills`，只能让部分技能被自然语言命中，不能保证 `commands/` 下的 slash command 生效，因此 `/vibe` 可能完全不会出现。
- **解决方案**：
  1. VIBE 必须按**标准插件**安装到 `~/.claude/plugins/vibe-claude-plugin`。
  2. 安装内容必须包含整个仓库，至少包括 `.claude-plugin/`、`commands/`、`skills/`、`scripts/`。
  3. 安装完成后必须彻底重启 Claude Code，并先用 `/plugins` 检查插件是否已经被真正加载。

### 2.2 坑点：slash command 文件格式与本地状态文件污染
- **问题描述**：
  1. `commands/vibe.md` 如果使用了不兼容的 frontmatter 形式，可能导致 Claude Code 不注册 `/vibe`。
  2. `.orphaned_at` 这类本地插件状态文件如果被误提交进仓库，会让插件看起来像"孤儿副本"，增加加载异常风险。
- **解决方案**：
  1. `commands/*.md` 采用纯 Markdown 说明文档格式，和本机已验证可用的插件命令保持一致。
  2. 将 `.orphaned_at` 加入 `.gitignore`，禁止提交到仓库。

### 2.3 坑点：Claude Code 技能加载路径问题
- **问题描述**：Claude Code 在识别自定义 skill 时，强依赖于目录结构和 `SKILL.md` 的存在。如果结构嵌套过深，或者 `---` 头部元数据缺失，将导致技能无法加载。
- **解决方案**：确保所有的技能都在 `skills/` 的一级子目录下（如 `skills/vibe-test/SKILL.md`），并且每个 `SKILL.md` 都有标准的 YAML Frontmatter（包含 `name` 和 `description`）。

### 2.4 坑点：前端动画与"果汁感"实现的性能问题
- **问题描述**：在执行 `vibe-ui-beautify` 时，大量使用 CSS 动画或 JavaScript 物理引擎可能导致掉帧或卡顿，特别是与复杂的 3D 渲染结合时。
- **解决方案**：
  1. 优先使用硬件加速属性（如 `transform` 和 `opacity`）进行动画处理。
  2. 对于弹簧阻尼等物理反馈，推荐使用 `Framer Motion`，并开启 `layout` 或 `will-change` 优化。
  3. 注意在低端设备上进行降级处理。

### 2.5 坑点：多模块联动的上下文遗忘
- **问题描述**：在 24 小时全链路不间断编程中，AI 在进行到后期（如部署、交付）时，容易遗忘早期（如需求分析、架构设计）的约束条件。
- **解决方案**：
  在工作流的前置步骤中，强制要求 AI **读取并检查先前的产物文档**（如 PRD、架构设计文档），以此重新加载上下文。

### 2.6 坑点：对外命令名和内部引擎名混用
- **问题描述**：项目内部核心技能名是 `vibe-autopilot`，但用户在 Claude Code 中真正输入的是 `/vibe`。如果 README、使用手册、安装提示把这两个名字混着写，用户会误以为 `/vibe-autopilot` 是可直接执行的命令，导致首轮试用失败。
- **解决方案**：
  1. 对外文档统一写清：`/vibe` 是公开入口命令，`vibe-autopilot` 是内部自动驾驶引擎。
  2. 安装手册、README、宣发文案必须使用同一口径，避免传播后出现错误用法。

### 2.7 坑点：GitHub 对外文档只做中文会损失传播面
- **问题描述**：项目当前用户以中文为主，但 GitHub、X、Reddit、Product Hunt 等开源流量主战场以英文为主。如果仓库首页只有中文，海外用户很难在 10 秒内理解项目价值，Star、转发和试用转化都会下降。
- **解决方案**：
  1. `README.md` 采用英文主版，服务 GitHub 首屏与英文社区传播。
  2. 新增 `README.zh-CN.md` 承载中文完整介绍。
  3. 使用手册继续保留中文，降低中文用户上手门槛。
  4. 额外维护宣发文案文件，减少每次发帖时临时拼装内容造成的表述漂移。

### 2.8 坑点：决定做英文主导后，首页不能再继续承担双语入口
- **问题描述**：如果已经决定项目走 GitHub 国际传播路线，但 `README.md` 仍然把中文内容和英文主叙事混排在首屏，或者把中文手册作为主要导流目标，就会削弱英文首屏的聚焦效果。用户会在"这是国际项目还是中文项目"之间产生犹豫。
- **解决方案**：
  1. `README.md` 保持英文主导，不做中英混排主内容。
  2. 中文文档保留在仓库中，但不再占据主宣传链路。
  3. 如果需要照顾中文用户，只保留轻量级语言切换链接，而不是双语首页正文。
  4. 对外发布节奏、宣发文案、发布说明统一采用英文优先。

### 2.9 坑点：没有发布节奏文档，传播动作会再次退回临时发挥
- **问题描述**：只有 README 和文案，还不足以支撑一次像样的开源发布。没有明确渠道顺序、素材准备和首周节奏，后续传播很容易变成"想到哪发到哪"，导致前期热度无法转成安装和反馈。
- **解决方案**：
  1. 增加 `LAUNCH_PLAN.md`，明确渠道、顺序、素材和首周节奏。
  2. 增加 `RELEASE_NOTES.md`，让每次对外发布都有可复用的说明文本。
  3. 把"演示素材"和"真实案例"视为高优先级资产，而不是可选项。

### 2.10 坑点：没有开源协作模板，流量进来后无法高质量承接
- **问题描述**：如果仓库只有 README，没有 `CONTRIBUTING.md`、Issue 模板和 PR 模板，用户即使感兴趣，也很难用统一格式反馈安装问题、提需求或提交贡献。结果通常是 issue 信息不全、维护成本上升、首波流量承接变差。
- **解决方案**：
  1. 增加 `CONTRIBUTING.md`，明确贡献范围和最小协作规范。
  2. 增加 `.github/ISSUE_TEMPLATE/` 与 `PULL_REQUEST_TEMPLATE.md`。
  3. 在 `README.md` 中直接链接这些协作入口，降低参与门槛。

### 2.11 坑点：没有明确的 demo 资产标准，演示内容容易又长又空
- **问题描述**：很多开源项目知道"需要做 demo"，但没有定义最小素材集合和镜头顺序，最后产出的往往是冗长终端录屏，既不利于 GitHub 首屏，也不利于 X、Reddit、Product Hunt 分发。
- **解决方案**：
  1. 增加 `DEMO_ASSETS.md`，明确最小素材包和镜头顺序。
  2. 统一演示逻辑：安装 -> `/vibe` -> 需求对齐 -> `tasks.md` -> 执行 -> 结果。
  3. 对外演示始终强调可见产物，不只讲抽象卖点。

### 2.12 坑点：插件元数据、命令说明和 README 语言不一致
- **问题描述**：如果 `README.md` 已经走英文主导，但 `.claude-plugin/plugin.json`、`.claude-plugin/marketplace.json` 和 `commands/vibe.md` 仍然混用中文或不同风格的描述，用户会在安装入口、仓库首页和命令文档之间感受到明显割裂，影响项目专业度。
- **解决方案**：
  1. `plugin.json` 与 `marketplace.json` 统一使用同一条英文短描述。
  2. `commands/vibe.md` 改为英文优先，与公开仓库语言一致。
  3. 为对外发布新增 `CHANGELOG.md`，让文档、版本说明和发布动作形成闭环。

### 2.13 坑点：GitHub 首页只写流程和技能，不写"为什么普通人也能用"
- **问题描述**：如果 README 只强调多智能体、文档驱动、技能编排这类系统设计，技术用户可能能看懂，但第一次访问仓库的人未必能立刻明白真正价值：即使需求不完整、甚至不懂技术细节，也能先把想法说出来，让系统通过追问逐步澄清并推进到交付。
- **解决方案**：
  1. README 首屏和 `What It Is` 必须明确写出"从一个粗略想法开始"。
  2. 增加"它和普通代码生成有什么不同"这类用户视角章节，强调主动追问、对非技术用户友好、以及长链路自动推进。
  3. 对外文案避免只堆"23 个技能""多智能体架构"这类内部实现词，优先表达用户得到的结果和体验。

### 2.14 坑点：vibe-security 工具链"写在文档里却跑不起来"
- **问题描述**：`vibe-security/SKILL.md` 中引用了 `npm audit`、`semgrep`、`gitleaks` 等开源安全扫描工具，但插件本身**没有提供任何工具安装脚本**，也没有**工具可用性检测机制**。用户系统里大概率没装这些工具，AI 执行扫描命令会直接报错，然后**静默降级为纯 AI 审计**，但报告中完全不体现降级状态，给用户一种"做了完整安全扫描"的错觉。实际效果：已知 CVE 扫不到、硬编码密钥扫不到、SAST 规则匹配跑不了，只剩 AI 逐行看代码的业务逻辑审计。
- **解决方案**：
  1. **核心原则：用户不应手动安装任何工具，AI 负责装好一切。必须全装好才能跑，不存在降级模式。**
  2. 在 `vibe-security/SKILL.md` 中新增第 2.1 节"安全工具可用性检测与强制安装"，强制要求在执行任何扫描命令前先检测工具是否安装，缺失时 AI 立即执行安装命令。
  3. **层层解决依赖**：安装工具时如果依赖也缺失，AI 继续向下解决。例如：semgrep 缺失 → 需要 pip → pip 缺失 → 需要 Python → AI 执行 `brew install python` / `apt install python3-pip` / `winget install Python.Python.3`。
  4. **装不上必须告诉用户**：如果 AI 尝试了所有安装方式仍然失败，必须停下来，在对话中明确告诉用户：卡在哪个工具、具体失败原因、用户需要执行什么命令解决。绝不静默跳过，绝不假装扫过了。
  5. 扫描命令不再有 `if command -v` 条件判断和 `.skipped` 文件——所有工具在 Step 0 必须装好，Step 1-4 直接执行扫描。
  6. 安全审查报告头部包含**工具可用性矩阵**（每个工具标注 OK/INSTALLED）和**工具自动安装日志**（初始状态、安装命令、最终状态）。
  7. 与 autopilot 契约新增三条禁止行为：
     - 禁止要求用户手动安装工具——AI 自己装
     - 禁止降级跳过——工具没装好就停下来告诉用户
     - 禁止静默跳过——装不上必须在对话中明确告诉用户卡在哪里
  8. 新增 `scripts/security-setup.ps1`（Windows）和 `scripts/security-setup.sh`（Mac/Linux）备用安装脚本，仅供 AI 自动安装失败后用户手动补救用。`install.ps1` 和 `install.sh` 已同步更新，复制时包含 `scripts/` 目录。
  9. **PowerShell 5 兼容性**：`security-setup.ps1` 使用独立变量而非哈希表，避免 `$toolStatus["key"] = value` 的 null 索引报错；`Install-WithPip` 优先用 `pip3`，兼容老系统用 `pip`。

### 2.15 vibe-ui-design 设计知识库增强（2026-07-04）
**问题**：vibe-ui-design 原本只支持"深色工业风"一种风格，缺少风格库、行业色板、字体配对、UX 准则等专业设计知识，导致面对非开发者类项目（如电商/医疗/教育）时设计能力不足。

**解决方案**：在 vibe-ui-design/SKILL.md 末尾追加 6 个新章节（第 13-18 节），**不修改任何现有章节**：
1. **第 13 节 设计风格库**：15 种风格速选矩阵 + 风格决策树 + 风格切换指南
2. **第 14 节 行业色板推荐**：12 个行业的主色/辅助色/背景色推荐 + 60-30-10 配色法则
3. **第 15 节 字体配对推荐**：10 组字体配对（标题+正文+等宽）+ 字体加载规范 + 4 种字号比例尺
4. **第 16 节 UX 准则速查**：按优先级分 8 级（P0 无障碍 ~ P7 图表数据），共 40+ 条准则
5. **第 17 节 Pre-Delivery Checklist**：交付前 UI 质量检查清单，6 大类 30+ 检查项
6. **第 18 节 技术栈实现指南**：9 种技术栈（React/Next.js/Vue/Svelte/shadcn/RN/Flutter/SwiftUI）的 token 对接方式

**联动改动**：
- `vibe-review/SKILL.md` 第二步前端代码检查新增"第 5 项 UI 质量检查"，引用 vibe-ui-design 第 17 节 Pre-Delivery Checklist，覆盖视觉规范/交互规范/可访问性/响应式/一致性五项。
- 原有第 1-12 节内容**零改动**，深色工业风仍是默认风格，新增内容只在 PRD 指定其他风格时激活。

### 2.16 vibe-ui-beautify 动画参考库增强（2026-07-04）
**问题**：vibe-ui-beautify 原有的动效配方只覆盖 CSS/Framer Motion 微交互，缺少 3D/WebGL/背景特效等高级视效的参考。AI 凭记忆写复杂 WebGL 代码容易出错（API 会变、参数记不准）。

**解决方案**：在 vibe-ui-beautify/SKILL.md 末尾追加第 16 节"动画参考库"，**不修改任何现有章节**：
1. **第 16.1 节 参考网站速选矩阵**：7 个参考网站（ThreeJS/ReactBits/Godly/Awwwards/Animista/GSAP/LottieFiles）
2. **第 16.2 节 AI 学习机制**：明确 AI 必须先用 WebFetch 抓取参考网站学习后再编码，给出了 WebFetch 使用示例和 5 步分析流程
3. **第 16.3 节 ThreeJS 动画库**：7 类常用示例（光照/几何体/粒子/着色器/动画/相机/后期处理）+ React Three Fiber 集成代码
4. **第 16.4 节 ReactBits 动画组件库**：5 个核心组件 + Grainient 完整参数表（从官网抓取）+ 安装使用示例
5. **第 16.5 节 场景匹配决策树**：6 种动效需求场景 → 对应参考网站 → WebFetch 抓取
6. **第 16.6 节 WebFetch 学习后的 AI 行动规范**：6 步行动流程 + 4 条禁止行为

**核心机制**：AI 遇到"3D"/"WebGL"/"粒子"/"流体背景"等关键词时，**必须先 WebFetch 抓取对应参考网站**，学习技术栈/参数/依赖/性能影响后再编码。禁止凭记忆写复杂动画代码。

### 2.17 新增 vibe-e2e 端到端真机验证技能（2026-07-04）
**问题**：VIBE 原有的交付前验证全部在代码层面（vibe-test 单元测试 / vibe-security 安全扫描 / vibe-review 代码审查），但**没有"打开浏览器看页面"这一步**。所有测试都过了，用户打开页面可能发现白屏、按钮失灵、样式崩溃、接口 404。代码测试全过 ≠ 页面能用。

**解决方案**：新建 `vibe-e2e` 技能，作为交付前最后一道防线：
1. **工具安装**：自动安装 Playwright（含降级方案），安装失败告诉用户
2. **项目启动**：自动识别项目类型启动开发服务器，等待就绪，curl 验证可访问
3. **页面路由遍历**：读取路由配置，逐个访问每个路由，截图存证
4. **交互验证**：每个按钮点击验证响应、每个表单输入验证提交、每个导航链接验证跳转
5. **控制台错误检查**：零 Error 才能通过
6. **API 响应验证**：零个 4xx/5xx 才能通过
7. **移动端验证**：iPhone/iPad/Android 三设备截图验证（如 PRD 要求响应式）
8. **验证结果分级**：P0 致命/P1 严重/P2 一般/P3 轻微，**P0=0 且 P1=0 才能交付**

**联动改动**：
- `vibe-autopilot/SKILL.md` 阶段三新增第 1 步"端到端真机验证"，在 `vibe-api-docs` 之前执行
- 技能总数从 22 → 23

### 2.18 Marketplace 安装问题与手动注册方案
**问题描述**：在 `settings.json` 中配置了 `extraKnownMarketplaces`，但执行 `/plugin install vibe-claude-plugin@vibe` 仍然报 "Marketplace not found"。Claude Code 的 `/plugin install` 命令对自定义 Marketplace 的处理可能只认官方源。
**解决方案**：
1. 确保仓库根目录有 `.claude-plugin/marketplace.json`（注册 Marketplace）和 `.claude-plugin/plugin.json`（注册插件）。
2. **最可靠方案：直接克隆到插件目录**。
   ```powershell
   # Windows
   New-Item -ItemType Directory -Force -Path "$env:USERPROFILE\.claude\plugins" | Out-Null
   git clone https://github.com/xushuodasd/VIBE-Claude-Plugin.git "$env:USERPROFILE\.claude\plugins\vibe-claude-plugin"
   ```
   ```bash
   # macOS/Linux
   git clone https://github.com/xushuodasd/VIBE-Claude-Plugin.git ~/.claude/plugins/vibe-claude-plugin
   ```
3. 如果之前通过 Marketplace 安装过，Claude Code 可能在 `installed_plugins.json` 中留下了指向 cache 旧版本的记录（见 2.19），必须手动修正为本地目录路径。
4. 重启 Claude Code 后用 `/plugins` 检查是否加载。

### 2.19 坑点：installed_plugins.json 指向 cache 旧版本导致 /vibe 不生效（2026-07-04）
**问题描述**：用户通过 `git clone` 把最新代码放到 `~/.claude/plugins/vibe-claude-plugin/`，但重启 Claude Code 后 `/vibe` 仍然报 `Unknown command`，而 `/vibe-plan` 等子 skill 却可用。排查发现 `~/.claude/plugins/installed_plugins.json` 中 `vibe-claude-plugin@vibe` 指向的是 `cache/vibe/vibe-claude-plugin/1.0.0/` 这个旧版本缓存，而不是本机更新的插件目录。Claude Code 实际加载的是 cache 里的旧代码，所以 commands/vibe.md 的修改不生效。

**症状**：
- `/vibe` → `Unknown command`
- `/vibe-plan` 等子 skill 可用（说明插件部分加载）
- 修改本地 `commands/vibe.md` 并重启后仍无效

**解决方案**：
1. 打开 `~/.claude/plugins/installed_plugins.json`。
2. 找到 `vibe-claude-plugin@vibe` 条目，把 `installPath` 改为本地插件目录：
   ```json
   {
     "scope": "user",
     "installPath": "C:\\Users\\14028\\.claude\\plugins\\vibe-claude-plugin",
     "version": "2.0.0",
     "installedAt": "...",
     "lastUpdated": "...",
     "gitCommitSha": "d0facdd"
   }
   ```
3. 确保 `settings.json` 中 `enabledPlugins` 包含 `"vibe-claude-plugin@vibe": true`。
4. **完全退出 Claude Code 并重新打开**。
5. 输入 `/plugins` 检查加载路径是否为本地目录。

**预防措施**：
- 优先使用 `git clone` 直接安装到 `~/.claude/plugins/vibe-claude-plugin/`，不走 Marketplace `/plugin install`。
- 更新插件时，在插件目录执行 `git pull`，然后检查 `installed_plugins.json` 的 `installPath` 没有偷偷变回 cache 路径。

## 3. 下一步优化方向
- **E2E 测试强化**：`vibe-e2e` 目前偏向 Playwright 指导规范，后续可增加 E2E 测试脚手架自动生成能力（自动读取路由配置生成 `.spec.ts` 文件）。
- **自动化测试强化**：目前 `vibe-test` 偏向指导规范，后续可增加针对 Jest/Cypress 的具体自动化配置脚手架生成能力。
- **MCP 深度集成**：结合 Model Context Protocol，将技能从纯文本提示升级为可以自动调用数据库或 CI/CD 接口的执行体。
- **演示素材建设**：补充 30 到 90 秒短视频、GIF 和真实案例，把"概念卖点"变成"可验证结果"。
- **开源发布执行**：围绕 `LAUNCH_PLAN.md` 落地英文首发，优先拿到真实安装反馈和早期 issue。
- **社区承接建设**：围绕 `CONTRIBUTING.md` 和 GitHub 模板持续收敛 issue 质量，减少首波用户反馈噪声。
- **安全工具链扩展**：当前 `scripts/security-setup.*` 覆盖 Node.js/Python/Go 三种技术栈，后续可扩展 Rust（cargo audit）、Java（OWASP Dependency-Check）、Ruby（bundle audit）的自动安装支持。
- **设计知识库持续扩充**：vibe-ui-design 的 15 种风格库可继续扩充，每种风格补充更具体的代码示例和截图参考。
