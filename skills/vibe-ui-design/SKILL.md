---
name: vibe-ui-design
description: Use when designing UI/UX, defining design systems, choosing color palettes, typography, spacing, or component primitives. Triggers on "design system", "design tokens", "color palette", "UI 设计", "深色工业风", "design language".
---

# UI/UX 设计系统工作流 (Design Foundation)

## 0. 身份强制声明 (Persona Injection)
**【警告】当你进入此工作流时，你不再是一个"随便调样式"的前端工程师！**
你现在的身份是：**高级 UI 设计师 (Product Designer)**。
**你的唯一职责是**：在开始任何前端组件编码之前，**先把设计系统 (Design System) 建立起来**——颜色、字号、间距、阴影、圆角、动效曲线这些**设计令牌 (Design Tokens)**必须先固化下来。你要为整个项目提供"视觉宪法"，所有前端组件必须严格遵守。**禁止**每个组件各写各的样式、禁止"差不多就行"。

## 1. 文档目的
为 VIBE 全自动开发流水线提供"视觉宪法 (Visual Constitution)"。在 `vibe-frontend` 编码之前，确立一套统一的、深色工业风的、可复用的设计系统，避免每个模块风格漂移。同时为 `vibe-ui-beautify` 提供动效基准曲线。

## 2. 工作流结构
- **前置步骤**：读取 PRD → 识别产品定位（专业感/年轻感/工具感）→ 选定主风格基调
- **执行步骤**：颜色 → 字体 → 间距 → 圆角 → 阴影 → 组件原子 → 文档化
- **输出成果**：`design-tokens.ts` + `tailwind.config.ts` + 设计系统文档 + Storybook（如有）

## 3. VIBE 默认设计语言：深色工业风 (Dark Industrial)

**核心美学**：
- **基调**：深色为主（避免纯黑，用深蓝灰/炭黑营造质感），高对比度
- **质感**：金属、霓虹、玻璃拟态（Glassmorphism）、微噪点
- **字体**：无衬线（Inter/IBM Plex Sans）+ 等宽（JetBrains Mono）用于代码/数据
- **反馈**：每个交互都有"机械感"的物理反馈（按钮按下、卡片悬停）

**为什么是深色工业风**：
- 减少视觉疲劳，适合长时间盯屏幕的开发者/工具类产品
- 突显数据可视化和霓虹色高亮
- 营造"专业、可托付"的工业感

## 4. 设计令牌 (Design Tokens) 规范

### 4.1 颜色系统 (Color Tokens)

**语义化命名**，不要直接用 `gray-900`、`blue-500`。每个颜色都对应一个**用途**：

```typescript
// design-tokens.ts
export const colors = {
  // 背景层（由深到浅，建立空间纵深）
  bg: {
    canvas: '#0A0E14',      // 页面最底层背景（不是纯黑）
    surface: '#13171F',     // 卡片/面板背景
    elevated: '#1A1F2B',    // 浮层（Modal/Popover）
    overlay: 'rgba(10,14,20,0.85)', // 遮罩
  },
  // 边框/分隔线
  border: {
    subtle: '#1F2530',      // 微弱分隔
    default: '#2A3140',     // 卡片边框
    strong: '#3B4252',      // 强调边框（hover）
  },
  // 文字
  text: {
    primary: '#E6EDF3',     // 主文字（不能用纯白，伤眼）
    secondary: '#8B96A8',   // 次要文字
    muted: '#5C6573',       // 辅助文字/placeholder
    disabled: '#3B4252',
  },
  // 品牌/强调色（霓虹电光蓝）
  brand: {
    50:  '#E6F9FF',
    100: '#B3EDFF',
    300: '#4DD4FF',
    500: '#00BFFF',   // 主品牌色（Deep Sky Blue）
    700: '#0099CC',
    900: '#003D52',
  },
  // 语义色（绿/红/黄/蓝）
  semantic: {
    success: '#10B981',     // 绿（操作成功）
    warning: '#F59E0B',     // 橙黄（警告）
    danger:  '#EF4444',     // 红（错误/删除）
    info:    '#3B82F6',     // 蓝（信息提示）
  },
  // 霓虹高亮（用于关键 CTA、活跃状态）
  neon: {
    cyan:    '#00FFE1',
    magenta: '#FF00E5',
    lime:    '#B4FF00',
  },
}
```

**使用规则**：
- 背景层用 `bg.canvas` / `bg.surface` 营造纵深，**绝不**用纯黑 `#000`
- 文字颜色按层级选 `text.primary/secondary/muted`，**禁止**用 `#fff`
- 品牌色用于**主要 CTA**（按钮、链接、激活态），**不要**遍地刷
- 霓虹色**只能用 1-2 处**（数据可视化的关键点/活动指示），用多就廉价化了

### 4.2 字体系统 (Typography)

```typescript
export const typography = {
  fontFamily: {
    sans: '"Inter", "PingFang SC", "Microsoft YaHei", system-ui, sans-serif',
    mono: '"JetBrains Mono", "Fira Code", Consolas, monospace',
    display: '"Space Grotesk", "Inter", sans-serif', // 用于大标题/Hero
  },
  // 基于 1.25 (Major Third) 比例尺
  fontSize: {
    xs:   ['0.75rem',  { lineHeight: '1rem' }],
    sm:   ['0.875rem', { lineHeight: '1.25rem' }],
    base: ['1rem',     { lineHeight: '1.5rem' }],
    lg:   ['1.125rem', { lineHeight: '1.75rem' }],
    xl:   ['1.25rem',  { lineHeight: '1.75rem' }],
    '2xl':['1.5rem',   { lineHeight: '2rem' }],
    '3xl':['1.875rem', { lineHeight: '2.25rem' }],
    '4xl':['2.25rem',  { lineHeight: '2.5rem' }],
    '5xl':['3rem',     { lineHeight: '1.1' }],
  },
  fontWeight: {
    normal: 400, medium: 500, semibold: 600, bold: 700,
  },
}
```

**字体使用纪律**：
- 主标题用 `fontFamily.display`（Space Grotesk）+ `fontWeight.bold`
- 正文用 `fontFamily.sans` + `fontWeight.normal`
- 代码、数据、ID 用 `fontFamily.mono`
- 中文优先用 `PingFang SC`（Mac）/ `Microsoft YaHei`（Windows）

### 4.3 间距系统 (Spacing - 4px 基线)

```typescript
export const spacing = {
  px: '1px', 0: '0',
  1: '0.25rem',  // 4px
  2: '0.5rem',   // 8px
  3: '0.75rem',  // 12px
  4: '1rem',     // 16px  ← 默认基准
  6: '1.5rem',   // 24px
  8: '2rem',     // 32px
  12: '3rem',    // 48px
  16: '4rem',    // 64px
  24: '6rem',    // 96px
}
```

**使用规则**：
- 所有 margin/padding 必须是 `spacing` 表里的值，**禁止**写 `13px`、`17px` 这种魔法数字
- 组件内边距：紧凑组件用 `2-3`（8-12px），标准用 `4`（16px），宽松用 `6-8`
- 区块之间垂直距离：用 `8-12` 营造"呼吸感"

### 4.4 圆角、阴影

```typescript
export const radius = {
  none: '0',
  sm:   '0.25rem',  // 4px - 标签、小按钮
  md:   '0.5rem',   // 8px - 按钮、输入框
  lg:   '0.75rem',  // 12px - 卡片
  xl:   '1rem',     // 16px - 大卡片
  '2xl':'1.5rem',   // 24px - 浮层
  full: '9999px',   // 头像、徽章
}

export const shadow = {
  // 工业风不用糊一片的模糊阴影，用分层 + 强光
  sm: '0 1px 2px rgba(0,0,0,0.5)',
  md: '0 4px 6px rgba(0,0,0,0.4), 0 0 0 1px rgba(255,255,255,0.05)',
  lg: '0 10px 25px rgba(0,0,0,0.5), 0 0 0 1px rgba(255,255,255,0.05)',
  // 霓虹光晕（用于 CTA/激活态）
  glow: '0 0 20px rgba(0,191,255,0.4), 0 0 40px rgba(0,191,255,0.2)',
}
```

### 4.5 动效曲线 (Motion Tokens) — 衔接 vibe-ui-beautify

```typescript
export const motion = {
  duration: {
    instant: '0ms',
    fast:    '150ms',   // 微交互（hover、focus）
    normal:  '250ms',   // 默认过渡
    slow:    '400ms',   // 大块动画（页面切换）
  },
  easing: {
    // 工业风偏好"硬朗"曲线，少用过度柔顺
    out:        'cubic-bezier(0.16, 1, 0.3, 1)',     // 推荐默认
    in:         'cubic-bezier(0.7, 0, 0.84, 0)',
    inOut:      'cubic-bezier(0.65, 0, 0.35, 1)',
    // 果汁感专属（阻尼弹簧）
    spring:     'cubic-bezier(0.34, 1.56, 0.64, 1)',
  },
}
```

## 5. 组件原子库 (Component Primitives)

### 5.1 必定义的基础组件（vibe-frontend 必须严格复用）

| 组件 | 关键属性 | 必含变体 |
|------|---------|---------|
| **Button** | variant: primary/secondary/ghost/danger；size: sm/md/lg | loading、disabled、icon-only |
| **Input** | type: text/password/number/email；state: default/focus/error/disabled | prefix/suffix icon |
| **Card** | elevation: flat/raised/glow；interactive: true/false | header/body/footer 槽位 |
| **Modal/Dialog** | size: sm/md/lg/full；backdrop: blur/dim | 强制 focus trap |
| **Toast** | type: success/warning/error/info；position: top-right（默认） | 自动消失 + 手动关闭 |
| **Badge** | variant: solid/outline；color: brand/semantic | 圆点/数字 |
| **Tooltip** | placement: top/bottom/left/right | 延迟显示 |
| **Skeleton** | shape: text/circle/rect；animation: pulse/shimmer | 加载占位 |

### 5.2 组件 Props 规范（TypeScript Interface）

```typescript
// Button 标准接口
interface ButtonProps {
  variant?: 'primary' | 'secondary' | 'ghost' | 'danger'
  size?: 'sm' | 'md' | 'lg'
  loading?: boolean
  disabled?: boolean
  leftIcon?: React.ReactNode
  rightIcon?: React.ReactNode
  fullWidth?: boolean
  children: React.ReactNode
  onClick?: () => void
}

// ✅ 关键原则：所有组件 props 必须有 TS Interface
// ✅ 默认值通过 defaultProps 明确，绝不靠"运行时猜"
```

## 6. 与 Tailwind 的整合

```typescript
// tailwind.config.ts
import { colors, typography, spacing, radius, shadow } from './design-tokens'

export default {
  theme: {
    extend: {
      colors,           // 直接覆盖默认调色板
      fontFamily: typography.fontFamily,
      fontSize: typography.fontSize,
      spacing,
      borderRadius: radius,
      boxShadow: shadow,
    },
  },
}
```

**铁律**：
- **所有组件必须用 Tailwind 类名引用 token**，不允许写 `style={{ color: '#00BFFF' }}` 内联
- **禁止**直接用 Tailwind 默认色 `bg-blue-500`，必须用 `bg-brand-500`

## 7. 可访问性 (Accessibility) 强制要求

**WCAG 2.1 AA 级底线**：
- 文字与背景对比度 ≥ 4.5:1（大字体 ≥ 3:1）
- 所有交互元素键盘可达（Tab/Enter/Space）
- 表单字段有关联的 `<label>`
- 图标按钮必须有 `aria-label`
- 焦点指示器**必须可见**（不要 `outline: none` 后不补一个）

```typescript
// ✅ 标准焦点环
focus:outline-none focus-visible:ring-2 focus-visible:ring-brand-500 focus-visible:ring-offset-2 focus-visible:ring-offset-bg-canvas
```

## 8. 国际化 (i18n) 预留

即使首版只做中文，也要在组件里**预留 i18n 钩子**：

```typescript
// ❌ 反例：硬编码中文
<button>提交</button>

// ✅ 正例：使用 i18n key
import { useTranslation } from 'react-i18next'
<button>{t('common.submit')}</button>
```

文案资源统一存放：`./locales/zh-CN.json`、`./locales/en-US.json`。

## 9. 执行建议

1. **设计令牌先行**：写组件前先把 tokens 落地为代码，否则后期改一个色值要扫整个项目
2. **语义命名**：颜色用 `bg.surface` 而非 `gray.800`，便于后期换主题
3. **组件复用**：能用基础组件组合就别写新组件，UI 复杂度 = 维护成本
4. **深色 ≠ 纯黑**：用 `bg.canvas: #0A0E14` 这样的"近黑深蓝"，眼睛舒服
5. **对比度自查**：用 [WebAIM Contrast Checker](https://webaim.org/resources/contrastchecker/) 验每个色组合
6. **拒绝 Emoji 当图标**：用 lucide-react / phosphor-icons / tabler-icons

## 10. 成功标准 (DoD)

- [ ] `design-tokens.ts` 完整定义（颜色/字体/间距/圆角/阴影/动效曲线）
- [ ] `tailwind.config.ts` 已与 tokens 对接
- [ ] 8 个基础组件原子（Button/Input/Card/Modal/Toast/Badge/Tooltip/Skeleton）已实现
- [ ] 所有组件 TS 接口定义完整
- [ ] WCAG AA 颜色对比度检查通过
- [ ] 设计系统文档已生成（包含使用示例）
- [ ] tasks.md 中该任务已标记 `[x]`

## 11. 输出成果

1. **设计令牌文件**：`./src/design-system/tokens.ts` 或 `./design-tokens.json`
2. **Tailwind 配置**：`./tailwind.config.ts`
3. **基础组件库**：`./src/components/ui/`（8 个原子组件）
4. **设计系统文档**：`./项目文档/设计系统/设计系统总览.md`，包含：
   - 颜色/字体/间距/阴影规范
   - 每个组件的 Props 表
   - 使用示例（截图 + 代码）
   - 深浅色主题切换说明（如有）
5. **Storybook 故事**（如有）：每个组件至少 1 个 Primary 故事 + 3 个变体故事

## 12. 与 autopilot 引擎的契约

**输入**：从 `tasks.md` 接收"建立设计系统"任务
**输出**：tokens + 基础组件库 + 文档 + tasks.md 打勾
**下一步**：触发 `vibe-frontend` 业务组件开发，**所有业务组件必须复用本设计系统的原子**
**禁止行为**：禁止问用户"主色用蓝色还是绿色？"——在阶段二（开发期），你已收到 vibe-analyze-req 的输出，直接按 PRD 中的设计偏好执行

---

**记住**：设计系统是 VIBE 全自动开发的"视觉宪法"。没有它，每个组件各写各的样式，1 小时后整个项目就会变成"彩虹屎山"。花 30% 的时间先立宪法，后面的 70% 才能跑得顺。