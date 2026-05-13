---
name: opentui-doc
description: OpenTUI 是基于 Zig 编写的原生终端 UI 核心，提供 TypeScript 绑定。使用场景：构建终端应用程序、TUI 界面、使用组件化架构和灵活布局创建复杂终端应用。支持 React 和 Solid.js 框架绑定，以及可扩展的键盘映射系统和插件插槽体系。当用户需要在终端中构建用户界面、需要组件化布局系统、或需要键盘快捷键映射时应触发本技能。
---

# OpenTUI 中文文档

OpenTUI 是一个用 Zig 编写的原生终端 UI 核心，提供 TypeScript 绑定。原生核心暴露出 C ABI，可从任何语言使用。OpenTUI 目前在生产环境中驱动 OpenCode，也将驱动 terminal.shop。它提供基于组件的架构和灵活的布局能力，让你能够创建复杂的终端应用。

> 官方文档: https://opentui.com/docs/getting-started/
> GitHub: https://github.com/anomalyco/opentui

## 核心概念

### 架构概览

OpenTUI 的架构分层如下：

| 层级 | 描述 |
|------|------|
| **Zig 原生核心** | 终端渲染、输入处理、布局引擎（Yoga）、缓冲区管理 |
| **@opentui/core** | TypeScript 绑定 - Renderables（命令式 API）、Constructs（声明式 API） |
| **@opentui/react** | React 框架绑定 - JSX 组件、Hooks |
| **@opentui/solid** | Solid.js 框架绑定 - JSX 组件、Hooks |
| **@opentui/keymap** | 宿主无关的键盘绑定引擎 - 层次化快捷键、可发现命令 |

### 两种编程模型

OpenTUI 提供两种构建 UI 的方式：

**1. 命令式（Renderables）**：直接创建 `Renderable` 实例，使用 `add()` 组合，直接修改属性和方法。

**2. 声明式（Constructs）**：使用工厂函数构建轻量 VNode 图，组件在添加到树后才实例化。支持 `delegate()` 路由方法调用到子组件。

详见 [Renderables 和 Constructs 参考](references/renderables-and-constructs.md)。

## 快速开始

### 安装

OpenTUI 当前是 Bun 独占的，Deno 和 Node 支持正在开发中。

```bash
mkdir my-tui && cd my-tui
bun init -y
bun add @opentui/core
```

### Hello World

```typescript
import { createCliRenderer, Text } from "@opentui/core"

const renderer = await createCliRenderer({
  exitOnCtrlC: true,
})

renderer.root.add(
  Text({
    content: "Hello, OpenTUI!",
    fg: "#00FF00",
  }),
)
```

运行: `bun index.ts`

### 组合组件

组件天然地支持嵌套：

```typescript
import { createCliRenderer, Box, Text } from "@opentui/core"

const renderer = await createCliRenderer({
  exitOnCtrlC: true,
})

renderer.root.add(
  Box(
    { borderStyle: "rounded", padding: 1, flexDirection: "column", gap: 1 },
    Text({ content: "Welcome", fg: "#FFFF00" }),
    Text({ content: "Press Ctrl+C to exit" }),
  ),
)
```

`Box` 和 `Text` 是工厂函数。第一个参数是 props，额外参数是子元素。

## 常见模式

### 1. 使用 Constructs 构建表单

```typescript
import { createCliRenderer, Box, Text, Input, delegate } from "@opentui/core"

const renderer = await createCliRenderer()

function LabeledInput(props: { id: string; label: string; placeholder: string }) {
  return delegate(
    { focus: `${props.id}-input` },
    Box(
      { flexDirection: "row", marginBottom: 1 },
      Text({ content: props.label.padEnd(12), fg: "#888888" }),
      Input({
        id: `${props.id}-input`,
        placeholder: props.placeholder,
        width: 20,
        backgroundColor: "#222",
        focusedBackgroundColor: "#333",
        textColor: "#FFF",
        cursorColor: "#0F0",
      }),
    ),
  )
}

const form = Box(
  { width: 40, borderStyle: "rounded", title: "Login", padding: 1 },
  LabeledInput({ id: "username", label: "Username:", placeholder: "Enter username" }),
  LabeledInput({ id: "password", label: "Password:", placeholder: "Enter password" }),
)

renderer.root.add(form)
```

### 2. 使用 Renderables 构建面板

```typescript
import { BoxRenderable, TextRenderable, createCliRenderer } from "@opentui/core"

const renderer = await createCliRenderer()

const panel = new BoxRenderable(renderer, {
  id: "panel",
  width: 40, height: 10, borderStyle: "rounded", padding: 1,
})

panel.add(new TextRenderable(renderer, { id: "title", content: "My Panel", fg: "#FFFF00" }))
panel.add(new TextRenderable(renderer, { id: "content", content: "Content here", fg: "#AAAAAA" }))

renderer.root.add(panel)
```

### 3. 响应式布局

```typescript
renderer.on("resize", (width, height) => {
  if (width < 80) {
    container.flexDirection = "column"
  } else {
    container.flexDirection = "row"
  }
})
```

### 4. Tab 导航

```typescript
const inputs = [input1, input2]
let focusIndex = 0

renderer.keyInput.on("keypress", (key) => {
  if (key.name === "tab") {
    focusIndex = (focusIndex + 1) % inputs.length
    inputs[focusIndex].focus()
  }
})
```

### 5. 自定义构造组件

```typescript
function Card(props: { title: string }, ...children: VChild[]) {
  return Box(
    { border: true, padding: 1, flexDirection: "column" },
    Text({ content: props.title, fg: "#FFFF00" }),
    Box({ flexDirection: "column" }, ...children),
  )
}

renderer.root.add(
  Card({ title: "User Info" },
    Text({ content: "Name: Alice" }),
    Text({ content: "Role: Admin" }),
  ),
)
```

## 安装参考

### 核心包

```bash
bun add @opentui/core
```

### React 绑定

```bash
bun install @opentui/react @opentui/core react
```

TypeScript 配置:
```json
{
  "compilerOptions": {
    "jsx": "react-jsx",
    "jsxImportSource": "@opentui/react"
  }
}
```

### Solid.js 绑定

```bash
bun install solid-js @opentui/solid
```

TypeScript 配置:
```json
{
  "compilerOptions": {
    "jsx": "preserve",
    "jsxImportSource": "@opentui/solid"
  }
}
```

Bun 配置 (bunfig.toml):
```toml
preload = ["@opentui/solid/preload"]
```

### Keymap 包

```bash
bun install @opentui/keymap
```

## 组件速查

| 组件 | 描述 | Construct | Renderable |
|------|------|-----------|------------|
| Text | 显示文本 | `Text({...})` | `TextRenderable` |
| Box | 容器/边框 | `Box({...})` | `BoxRenderable` |
| Input | 单行输入 | `Input({...})` | `InputRenderable` |
| Textarea | 多行输入 | - | `TextareaRenderable` |
| Select | 列表选择 | `Select({...})` | `SelectRenderable` |
| TabSelect | 标签选择 | `TabSelect({...})` | `TabSelectRenderable` |
| ScrollBox | 滚动容器 | `ScrollBox({...})` | `ScrollBoxRenderable` |
| ScrollBar | 滚动条 | - | `ScrollBarRenderable` |
| Slider | 滑动条 | - | `SliderRenderable` |
| Code | 语法高亮代码 | `Code({...})` | `CodeRenderable` |
| Markdown | Markdown 渲染 | - | `MarkdownRenderable` |
| LineNumber | 行号 | - | `LineNumberRenderable` |
| FrameBuffer | 自定义图形 | `FrameBuffer({...})` | `FrameBufferRenderable` |
| ASCIIFont | ASCII 艺术字体 | `ASCIIFont({...})` | `ASCIIFontRenderable` |
| Diff | diff 对比 | - | `DiffRenderable` |

## 参考文档

- [Renderer 渲染器](references/renderer.md) - CliRenderer 配置、屏幕模式、滚动写入、渲染循环
- [Renderables 和 Constructs](references/renderables-and-constructs.md) - 两种编程模型的详细对比
- [布局系统](references/layout.md) - Yoga flexbox 布局属性
- [颜色系统](references/colors.md) - RGBA 类、颜色意图、终端调色板
- [组件参考](references/components.md) - 15 个组件的完整属性表
- [React 和 Solid 绑定](references/bindings.md) - 框架集成、Hooks、JSX 组件
- [Keymap 键鼠映射](references/keymap.md) - 键盘绑定引擎、宿主适配器、内置插件
- [插件插槽系统](references/plugin-slots.md) - 插件 API、运行时插件加载
- [Tree-sitter 集成](references/tree-sitter.md) - 语法高亮解析器配置
- [生命周期和环境变量](references/lifecycle-and-env.md) - 清理、信号处理、音频、env vars
