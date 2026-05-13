# OpenTUI 框架绑定参考文档

## React 绑定 (`@opentui/react`)

### 安装

```bash
bun install @opentui/react @opentui/core react
```

TypeScript 配置 (`tsconfig.json`):

```json
{
  "compilerOptions": {
    "jsx": "react-jsx",
    "jsxImportSource": "@opentui/react"
  }
}
```

### 快速开始

```typescript jsx
import { createCliRenderer } from "@opentui/core"
import { createRoot } from "@opentui/react"

function App() {
  return <text>Hello, world!</text>
}

const renderer = await createCliRenderer()
createRoot(renderer).render(<App />)
```

### JSX 组件

**布局与显示：** `<text>`, `<box>`, `<scrollbox>`, `<ascii-font>`

**输入组件：** `<input>`, `<textarea>`, `<select>`, `<tab-select>`

**代码与差异：** `<code>`, `<line-number>`, `<diff>`, `<markdown>`

**文本修饰：** `<span>`, `<strong>` / `<b>`, `<em>` / `<i>`, `<u>`, `<br>`, `<a>`

### API

| 函数 | 描述 |
|------|------|
| `createRoot(renderer)` | 创建 React 根节点，将组件树挂载到指定渲染器 |

### Hooks

| Hook | 描述 |
|------|------|
| `useRenderer()` | 访问渲染器实例 |
| `useKeyboard(handler, options?)` | 监听键盘事件 |
| `useOnResize(callback)` | 监听终端窗口缩放 |
| `useTerminalDimensions()` | 获取反应式尺寸，返回 `{ width, height }` |
| `usePaste(handler)` | 监听粘贴事件 |
| `useFocus(handler)` / `useBlur(handler)` | 监听焦点事件 |
| `useSelectionHandler(handler)` | 处理文本选择 |
| `useTimeline(options?)` | 动画支持 |

### 运行时插件加载

在入口文件顶部导入以启用运行时插件支持：

```typescript
import "@opentui/react/runtime-plugin-support"
```

### 组件扩展

通过 `extend` 注册自定义渲染组件：

```typescript
import { createRoot, extend } from "@opentui/react"
extend({ consoleButton: ConsoleButtonRenderable })
```

### React DevTools 调试

```bash
bun add --dev react-devtools-core@7
npx react-devtools@7
DEV=true bun run your-app.ts
```

设置 `DEV=true` 环境变量后，OpenTUI 会自动连接 React DevTools。

### 完整示例 — 登录表单

```typescript jsx
import { createCliRenderer } from "@opentui/core"
import { createRoot, useKeyboard } from "@opentui/react"
import { useCallback, useState } from "react"

function App() {
  const [username, setUsername] = useState("")
  const [password, setPassword] = useState("")
  const [focused, setFocused] = useState("username")

  useKeyboard((key) => {
    if (key.name === "tab") {
      setFocused((prev) =>
        prev === "username" ? "password" : "username"
      )
    }
  })

  return (
    <box border padding={2} flexDirection="column" gap={1}>
      <text fg="#FFFF00">登录表单</text>
      <box title="用户名" border width={40} height={3}>
        <input
          placeholder="请输入用户名..."
          focused={focused === "username"}
        />
      </box>
      <box title="密码" border width={40} height={3}>
        <input
          placeholder="请输入密码..."
          focused={focused === "password"}
        />
      </box>
    </box>
  )
}

const renderer = await createCliRenderer()
createRoot(renderer).render(<App />)
```

### 样式

**方式一：直接属性**

```typescript jsx
<box backgroundColor="blue" padding={2}>
  <text>Hello</text>
</box>
```

**方式二：`style` prop**

```typescript jsx
<box style={{ backgroundColor: "blue", padding: 2 }}>
  <text>Hello</text>
</box>
```

---

## Solid.js 绑定 (`@opentui/solid`)

### 安装

```bash
bun install solid-js @opentui/solid
```

TypeScript 配置 (`tsconfig.json`):

```json
{
  "compilerOptions": {
    "jsx": "preserve",
    "jsxImportSource": "@opentui/solid"
  }
}
```

bunfig.toml (预加载 Solid 运行时):

```toml
preload = ["@opentui/solid/preload"]
```

### 快速开始

```typescript jsx
import { render } from "@opentui/solid"

const App = () => <text>Hello, World!</text>

render(App)
```

### JSX 组件

> **注意：** Solid 绑定使用 **snake_case** 命名风格。

**布局与显示：** `<text>`, `<box>`, `<scrollbox>`, `<ascii_font>`

**输入组件：** `<input>`, `<textarea>`, `<select>`, `<tab_select>`

**代码与差异：** `<code>`, `<line_number>`, `<diff>`, `<markdown>`

**文本修饰：** `<span>`, `<strong>` / `<b>`, `<em>` / `<i>`, `<u>`, `<br>`, `<a>`

### API

| 函数 | 描述 |
|------|------|
| `render(node, rendererOrConfig?)` | 渲染 Solid 组件树到终端 |
| `testRender(node, options?)` | 创建测试渲染器，用于单元测试 |
| `extend(components)` | 注册自定义渲染组件 |
| `getComponentCatalogue()` | 获取已注册的组件目录 |

### Scrollback Writers（回滚写入器）

将 Solid JSX 写入渲染器的回滚缓冲区：

**方式一：直接写入**

```typescript jsx
import { writeSolidToScrollback } from "@opentui/solid"

writeSolidToScrollback(
  renderer,
  () => <text fg="#8BD5CA">API 响应时间 12ms</text>
)
```

**方式二：创建可复用的写入器**

```typescript jsx
import { createScrollbackWriter } from "@opentui/solid"

const writer = createScrollbackWriter(
  () => <text>记录于 {Date.now()}</text>
)
renderer.writeToScrollback(writer)
```

### Hooks

| Hook | 描述 |
|------|------|
| `useRenderer()` | 访问渲染器实例 |
| `useKeyboard(handler, options?)` | 监听键盘事件 |
| `onResize(callback)` | 监听终端窗口缩放 |
| `onFocus(callback)` / `onBlur(callback)` | 监听焦点事件 |
| `useTerminalDimensions()` | 返回 Solid signal，例如 `dimensions().width` |
| `usePaste(handler)` | 监听粘贴事件 |
| `useSelectionHandler(callback)` | 处理文本选择 |
| `useTimeline(options?)` | 动画支持 |

### 特殊组件

```typescript jsx
import { Portal, Dynamic } from "@opentui/solid"
```

| 组件 | 描述 |
|------|------|
| `Portal` | 将子组件渲染到不同的挂载点 |
| `Dynamic` | 根据 props 动态渲染任意元素 |

### 运行时插件支持

```typescript
import "@opentui/solid/runtime-plugin-support"
```

### 构建生产版本

使用 OpenTUI 提供的 Bun 插件构建 Solid 应用：

```typescript
import solidPlugin from "@opentui/solid/bun-plugin"

await Bun.build({
  entrypoints: ["./index.tsx"],
  target: "bun",
  plugins: [solidPlugin],
})
```

### 示例：计数器

```typescript jsx
import { render, useKeyboard, useRenderer } from "@opentui/solid"
import { createSignal } from "solid-js"

const App = () => {
  const [count, setCount] = createSignal(0)
  const renderer = useRenderer()

  useKeyboard((key) => {
    if (key.name === "up") setCount((c) => c + 1)
    if (key.name === "down") setCount((c) => c - 1)
    if (key.name === "escape") renderer.destroy()
  })

  return (
    <box border padding={2}>
      <text>计数: {count()}</text>
      <text fg="#888">上/下方向键调整，ESC 退出</text>
    </box>
  )
}

render(App)
```

---

## React vs Solid 差异对比

| 方面 | Solid | React |
|------|-------|-------|
| **渲染函数** | `render(() => <App />)` | `createRoot(renderer).render(<App />)` |
| **组件命名风格** | snake_case（如 `ascii_font`） | kebab-case（如 `ascii-font`） |
| **状态管理** | `createSignal` | `useState` |
| **副作用** | `onMount`, `onCleanup` | `useEffect` |
| **缩放 Hook** | `onResize(callback)` | `useOnResize(callback)` |
| **尺寸返回值** | Signal：`dimensions().width` | 普通对象：`dimensions.width` |
| **额外 Hooks** | `onFocus`, `onBlur`, `usePaste`, `useSelectionHandler` | — |
| **特殊组件** | `Portal`, `Dynamic` | — |

### 键鼠绑定 Hooks

**React：**

| Hook | 描述 |
|------|------|
| `useBindings(createLayer, deps?)` | 创建键鼠绑定层 |
| `useActiveKeys(options?)` | 获取当前按下的按键集合 |
| `usePendingSequence()` | 获取待完成的按键序列 |
| `reactiveMatcherFromStore()` | 从状态仓库创建反应式匹配器 |

**Solid：**

| Hook | 描述 |
|------|------|
| `useBindings(createLayer)` | 创建键鼠绑定层 |
| `useKeymapSelector(selector)` | 基于选择器响应式获取键位映射状态 |
| `reactiveMatcherFromSignal()` | 从 Solid signal 创建反应式匹配器 |

**两者共享：**

- `KeymapProvider` — 键位映射上下文提供者
- `useKeymap()` — 访问当前键位映射配置

---

## 常见问题

### Q: React 和 Solid 的组件名为什么不同？

React 绑定遵循 JSX 惯例使用 kebab-case（`ascii-font`），而 Solid 绑定使用 snake_case（`ascii_font`）。这是因为 Solid 的 JSX 编译实现不同，snake_case 更便于与 Solid 的响应式系统集成。

### Q: Solid 版为什么要配置 bunfig.toml 的 preload？

Solid 运行时需要在 JSX 编译之前完成初始化。`preload` 配置确保 `@opentui/solid/preload` 在所有模块加载前执行，建立必要的运行时环境。

### Q: 两个框架可以混用吗？

不可以。每个 OpenTUI 应用只能使用一个框架绑定。混用会导致运行时错误。

### Q: 如何选择合适的绑定？

- 如果团队熟悉 React 生态，或者已有 React 项目需要集成 CLI 界面，选择 `@opentui/react`
- 如果追求更小的打包体积和更精细的响应式性能，选择 `@opentui/solid`
- Solid 版额外提供了 `Portal`、`Dynamic` 组件和 Scrollback Writer 工具，适合需要高级渲染控制的场景
