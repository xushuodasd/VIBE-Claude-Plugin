# AI_DEVELOPMENT_DOC

## 文档目的
本文档用于记录 VIBE-Claude-Plugin 框架开发过程中的架构设计、核心逻辑、踩坑记录及经验总结，以便于 AI 在后续开发或维护中参考，避免重复犯错。

## 1. 核心架构与逻辑
本插件参考了 `superpowers` 的设计模式，将软件工程生命周期拆解为多个独立的、可由 Claude Code 自动触发的 Skill 模块。

### 1.1 技能(Skill)运作机制
- **触发机制**：通过 `SKILL.md` 的 `description` 和 `name` 字段，Claude Code 能在用户输入自然语言时（例如“帮我测试这个功能”、“优化一下页面的动画”）自动匹配并执行相应的规则。
- **强制约束**：每个技能都内嵌了工作流结构（前置步骤 -> 沟通 -> 执行 -> 验证），强制 AI 遵循“先思考方案，再一次性改好”的原则。

### 1.2 企业级分层与子智能体分发 (Subagent Delegation)
由于 AI 上下文窗口的限制，如果让单个 AI 处理整个页面的开发，极易出现逻辑遗漏或代码幻觉。为了达到企业级开发标准：
1. **文档驱动 (Document-Driven)**：所有编码动作（`vibe-frontend` / `vibe-backend`）前必须先验证对应的 API 接口文档存在，做到**无文档不开发，有文档 100% 对齐契约**。
2. **最小模块化 (Minimal Modularization)**：系统必须拆解为最小单元（例如：单一按钮组件、单独的数据持久层 DAO）。
3. **分层架构**：前端严格遵守 `Pages -> Components -> Hooks -> API Clients` 分层；后端严格遵守 `Controller -> Service -> Repository -> Model` 分层。
4. **子智能体开发**：在 Autopilot 引擎调度下，对每一个最小模块分配一次独立的开发上下文，开发完成后再进行组合，避免记忆混乱。

### 1.3 目录结构
```text
vibe-claude-plugin/
  ├── README.md               # 插件说明与安装指南
  ├── AI_DEVELOPMENT_DOC.md   # AI 开发记录与避坑指南
  └── skills/                 # 核心技能目录
      ├── vibe-analyze-req/   # 需求分析
      ├── vibe-plan/          # 开发计划
      ├── vibe-frontend/      # 前端开发
      ├── vibe-backend/       # 后端开发
      ├── vibe-test/          # 测试与验证
      ├── vibe-security/      # 安全审查
      ├── vibe-ui-design/     # UI/UX 设计
      ├── vibe-ui-beautify/   # 前端特效与美化
      ├── vibe-autopilot/     # 24小时无人值守引擎
      └── ... (共22个全链路技能)

## 2. 踩坑记录与避坑指南

### 2.1 坑点：Claude Code 技能加载路径问题
- **问题描述**：Claude Code 在识别自定义 skill 时，强依赖于目录结构和 `SKILL.md` 的存在。如果结构嵌套过深，或者 `---` 头部元数据缺失，将导致技能无法加载。
- **解决方案**：确保所有的技能都在 `skills/` 的一级子目录下（如 `skills/vibe-test/SKILL.md`），并且每个 `SKILL.md` 都有标准的 YAML Frontmatter（包含 `name` 和 `description`）。

### 2.2 坑点：前端动画与“果汁感”实现的性能问题
- **问题描述**：在执行 `vibe-ui-beautify` 时，大量使用 CSS 动画或 JavaScript 物理引擎可能导致掉帧或卡顿，特别是与复杂的 3D 渲染结合时。
- **解决方案**：
  1. 优先使用硬件加速属性（如 `transform` 和 `opacity`）进行动画处理。
  2. 对于弹簧阻尼等物理反馈，推荐使用 `Framer Motion`，并开启 `layout` 或 `will-change` 优化。
  3. 注意在低端设备上进行降级处理。

### 2.3 坑点：多模块联动的上下文遗忘
- **问题描述**：在 24 小时全链路不间断编程中，AI 在进行到后期（如部署、交付）时，容易遗忘早期（如需求分析、架构设计）的约束条件。
- **解决方案**：
  在工作流的前置步骤中，强制要求 AI **读取并检查先前的产物文档**（如 PRD、架构设计文档），以此重新加载上下文。

## 3. 下一步优化方向
- **自动化测试强化**：目前 `vibe-test` 偏向指导规范，后续可增加针对 Jest/Cypress 的具体自动化配置脚手架生成能力。
- **MCP 深度集成**：结合 Model Context Protocol，将技能从纯文本提示升级为可以自动调用数据库或 CI/CD 接口的执行体。
