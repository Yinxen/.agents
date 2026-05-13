# OpenTUI Keymap 键鼠映射引擎参考文档

## 概述

Keymap 是一个宿主无关的键鼠绑定引擎，支持层次化快捷键、可发现命令、序列处理和框架就绪状态。它可以用在任何需要键盘绑定的 TypeScript/JavaScript 项目中，包括终端 UI、Web 应用等场景。

---

## 安装

```bash
bun install @opentui/keymap
```

---

## 快速开始

```typescript
import { Keymap, type KeymapHost } from "@opentui/keymap"

const keymap = new Keymap(host as KeymapHost<object>)
```

### 便利创建函数

| 函数 | 描述 |
|------|------|
| `new Keymap(host)` | 裸引擎，直接传入宿主适配实例 |
| `createOpenTuiKeymap(renderer)` | 创建已适配 OpenTUI 渲染器的 Keymap 实例 |
| `createHtmlKeymap(root)` | 创建已适配 HTML 根元素的 Keymap 实例 |
| `createDefaultOpenTuiKeymap(renderer)` | 创建已适配 OpenTUI 且包含默认按键绑定的 Keymap 实例 |
| `createDefaultHtmlKeymap(root)` | 创建已适配 HTML 且包含默认按键绑定的 Keymap 实例 |

---

## 绑定（Bindings）

绑定是将按键映射到命令的核心机制。

### 基本用法

```typescript
keymap.registerLayer({
  commands: [
    { name: "quit", run() { renderer.destroy() } },
  ],
  bindings: [
    { key: "x", cmd: "save-file" },
    { key: "ctrl+x", cmd: "cut" },
    { key: "dd", cmd: "delete-line" },
    { key: "<leader>s", cmd: ":write session.log" },
    { key: { name: "return", ctrl: true }, cmd: "submit" },
  ],
})
```

### 绑定字段

| 字段 | 类型 | 默认值 | 描述 |
|------|------|--------|------|
| `key` | `string \| KeyObject` | 必填 | 键字符串或描述键的对象 |
| `cmd` | `string \| CommandFn` | 必填 | 命令名（字符串）或行内处理函数 |
| `event` | `"press" \| "release"` | `"press"` | 响应的事件类型，`"release"` 表示释放时触发 |
| `preventDefault` | `boolean` | `true` | 是否阻止事件进一步传播 |
| `fallthrough` | `boolean` | `false` | 是否允许后续绑定继续执行（即使当前绑定已匹配） |

### 键字符串语法

| 模式 | 示例 | 说明 |
|------|------|------|
| 单键 | `"x"`, `"enter"`, `"space"` | 单个按键名称 |
| 修饰符组合 | `"ctrl+x"`, `"ctrl+shift+a"` | 修饰符与按键的组合 |
| 序列 | `"dd"`, `"<leader>s"`, `"{count}j"` | 多个按键依次按下 |
| 对象形式 | `{ name: "return", ctrl: true }` | 以对象精确描述键位和修饰符 |

**对象形式支持的属性：**

| 属性 | 类型 | 描述 |
|------|------|------|
| `name` | `string` | 按键名称，如 `"return"`, `"a"`, `"space"` |
| `ctrl` | `boolean` | 是否要求 Ctrl 修饰键 |
| `shift` | `boolean` | 是否要求 Shift 修饰键 |
| `alt` | `boolean` | 是否要求 Alt（Option）修饰键 |
| `meta` | `boolean` | 是否要求 Meta（Command/Windows）修饰键 |
| `super` | `boolean` | 是否要求 Super 修饰键 |

---

## 层（Layers）

层是组织绑定和命令的逻辑单元，支持优先级和焦点范围控制。

### 全局层

```typescript
keymap.registerLayer({
  // 省略 target —— 全局层，总是活跃
  commands: [
    { name: "save", run() {} },
  ],
})
```

### 局部层

```typescript
keymap.registerLayer({
  target: editor,            // 局部层绑定的宿主目标
  targetMode: "focus-within", // 或 "focus"
  priority: 10,
  bindings: [
    { key: "ctrl+s", cmd: "save" },
  ],
})
```

### 层字段

| 字段 | 类型 | 描述 |
|------|------|------|
| `target` | `Target` | 局部层的宿主目标；省略则为全局层 |
| `targetMode` | `"focus-within" \| "focus"` | `"focus-within"` 表示目标或其子元素聚焦时激活，`"focus"` 表示仅目标自身聚焦时激活 |
| `priority` | `number` | 优先级，数字越大优先级越高；高优先级层优先处理事件 |
| `bindings` | `Binding[]` | 该层包含的绑定列表 |
| `commands` | `Command[]` | 该层包含的命令列表 |

---

## KeymapHost 接口

宿主适配器需要实现 `KeymapHost` 接口，将不同平台的事件模型统一到 Keymap 引擎。

### 宿主必须实现的成员

| 成员 | 类型 | 必需 | 描述 |
|------|------|------|------|
| `metadata` | `HostMetadata` | 是 | 声明平台和修饰符能力信息 |
| `rootTarget` | `Target` | 是 | 根目标对象 |
| `getFocusedTarget()` | `() => Target \| null` | 是 | 获取当前聚焦的目标 |
| `getParentTarget(target)` | `(target: Target) => Target \| null` | 是 | 获取指定目标的父级目标 |
| `onKeyPress` | `(handler) => Disposer` | 是 | 订阅按键按下事件 |
| `onKeyRelease` | `(handler) => Disposer` | 是 | 订阅按键释放事件 |
| `onFocusChange` | `(handler) => Disposer` | 是 | 订阅焦点变更事件 |
| `onTargetDestroy` | `(handler) => Disposer` | 是 | 订阅目标销毁事件 |
| `createCommandEvent()` | `(cmd, payload?) => CommandEvent` | 是 | 创建合成命令事件 |

### 宿主元数据（HostMetadata）

```typescript
const md = keymap.getHostMetadata()
// 输出示例：
// {
//   platform: "linux",
//   primaryModifier: "ctrl",
//   modifiers: { ctrl: "supported", alt: "supported", meta: "unsupported", ... }
// }
```

**元数据字段：**

| 字段 | 类型 | 描述 |
|------|------|------|
| `platform` | `"linux" \| "macos" \| "windows" \| "unknown"` | 当前运行平台 |
| `primaryModifier` | `"ctrl" \| "meta"` | 平台主修饰键（Linux/Windows 为 ctrl，macOS 为 meta） |
| `modifiers` | `Record<string, "supported" \| "unsupported">` | 各修饰键的支持情况 |

---

## 令牌（Tokens）

令牌是可复用的键序列片段，用于简化重复的绑定定义。

```typescript
// 注册令牌：将 <leader> 定义为空格键
keymap.registerToken({ name: "leader", key: { name: "space" } })

// 在绑定中使用令牌
keymap.registerLayer({
  bindings: [
    { key: "<leader>s", cmd: "save-file" },
  ],
})
```

### 令牌字段

| 字段 | 类型 | 描述 |
|------|------|------|
| `name` | `string` | 令牌名称，在绑定字符串中用 `<name>` 引用 |
| `key` | `string \| KeyObject` | 令牌展开后的键定义 |

---

## 序列模式（Sequence Patterns）

序列模式定义自定义的序列匹配逻辑，允许匹配动态按键序列（如数字计数）。

```typescript
keymap.registerSequencePattern({
  name: "count",
  match(event) {
    // 如果是数字键，返回匹配值
    return /^\d$/.test(event.name) ? { value: event.name } : undefined
  },
  finalize(values) {
    // 将所有匹配的数字合并为整数
    return Number(values.join(""))
  },
})
```

### 序列模式字段

| 字段 | 类型 | 描述 |
|------|------|------|
| `name` | `string` | 模式名称，在绑定中用 `{name}` 引用 |
| `match` | `(event) => { value: any } \| undefined` | 匹配函数，接收按键事件，返回匹配值或 undefined |
| `finalize` | `(values: any[]) => any` | 终结函数，将所有匹配值合并为最终值 |

### 在绑定中使用序列模式

```typescript
// 绑定：输入数字计数后按 j 键
// 例如 12j 表示向下移动 12 行
{ key: "{count}j", cmd: "move-down" }
```

---

## 命令（Commands）

命令是可执行的命名操作，绑定最终触发命令执行。

### 定义命令

```typescript
keymap.registerLayer({
  commands: [{
    name: "save-file",             // 命令名（必填）
    title: "Save File",            // 可读标题（可选，用于 UI 显示）
    category: "file",              // 分类（可选）
    group: "file.operations",      // 分组（可选）
    run({ payload }) {
      // 命令执行逻辑
      // payload 包含触发事件和序列模式解析值等信息
    },
  }],
  bindings: [
    { key: "ctrl+s", cmd: "save-file" },
  ],
})
```

### 命令执行

```typescript
// 直接执行命令（绕过调度系统）
const result = keymap.runCommand("save-file")

// 通过活跃层调度执行
const result = keymap.dispatchCommand("save-file")
```

### 执行结果

```typescript
// 返回结果结构
{
  ok: true / false,                // 是否执行成功
  reason?:                         // 失败原因
    "not-found"   |                // 命令未注册
    "inactive"    |                // 命令所在的层未激活
    "disabled"    |                // 命令被禁用
    "rejected"    |                // 命令被拦截器拒绝
    "error"                         // 执行时抛出异常
}
```

### 命令查询

```typescript
// 查询所有已注册的命令
keymap.getCommands({ visibility: "registered" })

// 查询当前可到达的命令（含搜索过滤）
keymap.getCommandEntries({ visibility: "reachable", search: "save" })

// 查询命令的绑定信息
keymap.getCommandBindings({
  visibility: "registered",
  commands: ["file.save"],
})
```

**查询可见性选项：**

| 值 | 描述 |
|------|------|
| `"registered"` | 所有已注册的项 |
| `"reachable"` | 当前层活跃状态下可触发的项 |

---

## 状态与发现（State & Discovery）

Keymap 提供运行时数据存储和状态查询能力，用于实现 UI 提示和调试。

### 数据存储

```typescript
// 设置数据
keymap.setData("app.mode", "normal")
keymap.setData("app.count", 42)

// 读取数据
const mode = keymap.getData("app.mode")
const count = keymap.getData("app.count")
```

### 状态查询

```typescript
// 获取当前活跃的按键列表（含元数据）
keymap.getActiveKeys({ includeMetadata: true })

// 获取当前正在等待的序列（部分输入的按键序列）
const pending = keymap.getPendingSequence()
// 示例：用户按了 "g" 还没按下一个键时，pending 为 ["g"]

// 清除等待序列
keymap.clearPendingSequence()

// 弹出等待序列的最后一个条目
keymap.popPendingSequence()
```

---

## 事件与拦截（Events & Intercepts）

Keymap 提供事件订阅和拦截机制，用于监听内部状态变化或在调度流程中插入自定义逻辑。

### 事件订阅

```typescript
// 状态变更事件（批处理）
keymap.on("state", () => {
  // 层激活状态、数据等发生变更时的回调
})

// 等待序列变更事件
keymap.on("pendingSequence", (parts: string[]) => {
  // 部分按键序列更新时触发（如用户输入 "g" 等待 "g" 或 "l" 时）
})

// 命令调度追踪事件
keymap.on("dispatch", (event) => {
  // 每次命令调度时触发
  console.log(`Dispatching: ${event.command}`)
})

// 警告事件
keymap.on("warning", (event) => {
  console.warn(`Keymap warning: ${event.message}`)
})

// 错误事件
keymap.on("error", (event) => {
  console.error(`Keymap error: ${event.message}`)
})
```

### 拦截器（Intercepts）

拦截器允许在键事件处理的各个阶段插入自定义逻辑。

```typescript
// 调度前拦截（键事件处理前）
keymap.intercept("key", ({ event, consume }) => {
  if (event.name === "Escape") {
    // 消费事件（阻止进一步处理）
    consume()
  }
})

// 调度后拦截（键事件处理后）
keymap.intercept("key:after", ({ handled, reason }) => {
  if (!handled) {
    console.log(`Unhandled key: ${reason}`)
  }
})

// 原始输入拦截（最低层级）
keymap.intercept("raw", ({ sequence, stop }) => {
  if (sequence === "debug") {
    stop()  // 停止序列处理
  }
})
```

**拦截点类型：**

| 类型 | 触发时机 | 用途 |
|------|----------|------|
| `"key"` | 键事件调度前 | 阻止或修改即将处理的键事件 |
| `"key:after"` | 键事件调度后 | 处理未匹配的键事件（如回退） |
| `"raw"` | 原始输入到达时 | 最低层级的输入拦截 |

---

## 扩展点（Extensions）

Keymap 提供丰富的扩展机制，允许深度定制引擎行为。

### 注册器（均返回 disposer 函数）

```typescript
// 注册自定义令牌
keymap.registerToken(token)

// 注册序列模式
keymap.registerSequencePattern(pattern)

// 为层添加自定义字段
keymap.registerLayerFields(fields)

// 为绑定添加自定义字段
keymap.registerBindingFields(fields)

// 为命令添加自定义字段
keymap.registerCommandFields(fields)

// 预置绑定解析器（自定义键字符串语法）
keymap.prependBindingParser(parser)

// 预置绑定展开器（将绑定展开为多个子绑定）
keymap.prependBindingExpander(expander)

// 预置绑定转换器（修改绑定定义）
keymap.prependBindingTransformer(fn)

// 预置事件匹配解析器（自定义事件匹配逻辑）
keymap.prependEventMatchResolver(fn)

// 预置消歧解析器（自定义序列歧义处理）
keymap.prependDisambiguationResolver(fn)
```

### 字段编译器（Binding Fields）

通过字段编译器可以为绑定、层、命令添加自定义行为。

```typescript
keymap.registerBindingFields({
  // 自定义字段 "mode"，控制绑定仅在特定模式下生效
  mode(value, ctx) {
    // 条件：需要 app.mode 数据与指定值匹配
    ctx.require("app.mode", value)

    // 元数据（用于查询和 UI）
    ctx.attr("mode", value)

    // 任意活跃条件
    ctx.activeWhen(() => someCondition())
  },
})

// 使用自定义字段
keymap.registerLayer({
  bindings: [
    { key: "j", cmd: "move-down", mode: "normal" },
    { key: "j", cmd: "insert-newline", mode: "insert" },
  ],
})
```

**字段编译器上下文（ctx）方法：**

| 方法 | 描述 |
|------|------|
| `ctx.require(key, value)` | 设置数据条件（需 state data 匹配） |
| `ctx.attr(name, value)` | 设置元数据属性 |
| `ctx.activeWhen(() => boolean)` | 设置任意活跃条件函数 |

### 消歧（Disambiguation）

当序列匹配存在歧义时（如 `g` 既可能是 `gg` 的第一部分也可能是 `g` 自身），消歧解析器决定处理方式。

```typescript
keymap.appendDisambiguationResolver((ctx) => {
  if (ctx.sequence.length === 1) {
    // 只有一个键时，继续等待序列完成
    return ctx.continueSequence()
  }
  // 多个键时，立即执行精确匹配
  return ctx.runExact()
})
```

**消歧上下文方法：**

| 方法 | 描述 |
|------|------|
| `ctx.continueSequence()` | 继续等待后续键输入 |
| `ctx.runExact()` | 立即执行精确匹配的绑定 |
| `ctx.sequence` | 当前按键序列 |

---

## 内置插件（Addons）

内置插件位于 `@opentui/keymap/addons`，通过导入调用即可增强功能。

### 默认配置

| 函数 | 描述 |
|------|------|
| `registerDefaultKeys()` | 安装默认键名解析器和事件匹配器 |
| `registerEnabledFields()` | 为层和命令添加启用/禁用开关字段 |
| `registerMetadataFields()` | 添加 esc/group/title/category 等元数据字段 |
| `registerBindingOverrides()` | 支持绑定覆盖（允许用户覆盖默认绑定） |

### 语法扩展

| 函数 | 描述 |
|------|------|
| `registerCommaBindings()` | 支持逗号分隔绑定，如 `x, y` 表示两个独立的绑定 |
| `registerEmacsBindings()` | 支持 Emacs 风格序列，如 `ctrl+x ctrl+s` |
| `registerLeader()` | 注册 Leader 键支持 |
| `registerTimedLeader()` | 注册带超时的 Leader 键支持 |
| `registerModBindings()` | 支持 `mod+...` 语法（平台感知，自动映射到 ctrl 或 meta） |

### 序列管理

| 函数 | 描述 |
|------|------|
| `registerBackspacePopsPendingSequence()` | Backspace 键弹出等待序列的最后一部分 |
| `registerEscapeClearsPendingSequence()` | Escape 键清除当前等待序列 |
| `registerNeovimDisambiguation()` | 注册 NeoVim 风格的消歧策略 |

### Ex 命令（Ex Commands）

```typescript
import { registerExCommands } from "@opentui/keymap/addons"

registerExCommands(keymap)

keymap.registerLayer({
  commands: [
    {
      name: "write",
      namespace: "excommands",      // 命名空间标记
      run({ payload }) {
        // 保存文件逻辑
      },
    },
  ],
})
```

### OpenTUI 特定插件（`@opentui/keymap/addons/opentui`）

| 函数 | 描述 |
|------|------|
| `registerBaseLayoutFallback()` | Kitty 终端基本布局回退处理 |
| `registerEditBufferCommands()` | 编辑缓冲区相关命令 |
| `registerManagedTextareaLayer()` | Textarea 元素的集成管理 |

---

## 工具函数（Helpers）

位于 `@opentui/keymap/extras`，提供便捷的工具方法。

### 快捷绑定映射

```typescript
import { commandBindings, formatCommandBindings, createBindingLookup } from "@opentui/keymap/extras"

// 命令名到键的快捷映射（简化绑定定义）
const bindings = commandBindings({
  "save-file": "ctrl+s",
  quit: "q",
})
// 等价于：
// [
//   { key: "ctrl+s", cmd: "save-file" },
//   { key: "q", cmd: "quit" },
// ]

// 格式化命令绑定（用于 UI 显示）
const formatted = formatCommandBindings(keymap, "save-file")
// 返回: "Ctrl+S"

// 创建绑定查询器
const lookup = createBindingLookup({ show_palette: "ctrl+p" })

keymap.registerLayer({
  bindings: lookup.gather("app", ["app.palette.show"]),
})
```

### createBindingLookup 方法

| 方法 | 描述 |
|------|------|
| `lookup.gather(namespace, entries)` | 收集绑定列表，自动生成命名空间版的命令名 |

---

## 框架绑定

### React（`@opentui/keymap/react`）

```tsx
import { KeymapProvider, useBindings, useActiveKeys } from "@opentui/keymap/react"

// 顶层 Provider
<KeymapProvider keymap={keymap}>
  <App />
</KeymapProvider>

// 在组件中使用绑定
function App() {
  useBindings(() => ({
    commands: [
      { name: "quit", run() {} },
    ],
    bindings: [
      { key: "q", cmd: "quit" },
    ],
  }), [])  // deps 数组可选

  return <div>Press q to quit</div>
}
```

**React Hooks：**

| Hook | 描述 |
|------|------|
| `useKeymap()` | 获取当前 Keymap 实例 |
| `useBindings(createLayer, deps?)` | 注册层，与组件生命周期绑定 |
| `useActiveKeys()` | 获取当前活跃按键列表（响应式） |
| `usePendingSequence()` | 获取当前等待序列（响应式） |
| `reactiveMatcherFromStore()` | 从状态仓库创建响应式匹配器 |

### Solid（`@opentui/keymap/solid`）

```tsx
import { KeymapProvider, useBindings } from "@opentui/keymap/solid"

// 顶层 Provider
<KeymapProvider keymap={keymap}>
  <App />
</KeymapProvider>

// 在组件中使用绑定
function App() {
  useBindings(() => ({
    commands: [
      { name: "quit", run() {} },
    ],
    bindings: [
      { key: "q", cmd: "quit" },
    ],
  }))
  // Solid 版本无需 deps 数组
}
```

**Solid Hooks：**

| Hook | 描述 |
|------|------|
| `useKeymap()` | 获取当前 Keymap 实例 |
| `useBindings(createLayer)` | 注册层，与组件生命周期绑定 |
| `useKeymapSelector(selector)` | 响应式选择 Keymap 中的特定状态 |
| `reactiveMatcherFromSignal()` | 从 Signal 创建响应式匹配器 |

---

## 宿主适配

### OpenTUI 宿主（`@opentui/keymap/opentui`）

| 配置项 | 说明 |
|--------|------|
| 根目标 | `renderer.root` |
| 聚焦目标 | `renderer.currentFocusedRenderable` |
| 事件来源 | `renderer.keyInput` |

```typescript
import { createOpenTuiKeymap } from "@opentui/keymap"
import { createDefaultOpenTuiKeymap } from "@opentui/keymap"

// 基本适配
const keymap = createOpenTuiKeymap(renderer)

// 含默认按键适配
const keymap = createDefaultOpenTuiKeymap(renderer)
```

### HTML 宿主（`@opentui/keymap/html`）

| 配置项 | 说明 |
|--------|------|
| 根目标 | `HTMLElement`（传入的根元素） |
| 聚焦目标 | `document.activeElement` |
| 键盘标准化 | `ArrowLeft` → `left`，`Enter` → `return`，`A` → `a`，`metaKey` → `super` |

```typescript
import { createHtmlKeymap } from "@opentui/keymap"
import { createDefaultHtmlKeymap } from "@opentui/keymap"

// 基本适配
const keymap = createHtmlKeymap(document.getElementById("app")!)

// 含默认按键适配
const keymap = createDefaultHtmlKeymap(document.getElementById("app")!)
```

### 自定义宿主

实现 `KeymapHost` 接口的全部必需成员，然后传入 `new Keymap(host)` 即可。

```typescript
import { Keymap, type KeymapHost, type Target } from "@opentui/keymap"

const customHost: KeymapHost<object> = {
  metadata: {
    platform: "linux",
    primaryModifier: "ctrl",
    modifiers: { ctrl: "supported", alt: "supported", meta: "unsupported" },
  },
  rootTarget: myRootTarget,
  getFocusedTarget() { return currentFocus },
  getParentTarget(target) { return target.parent ?? null },
  onKeyPress(handler) { /* 注册按键按下监听 */ return disposer },
  onKeyRelease(handler) { /* 注册按键释放监听 */ return disposer },
  onFocusChange(handler) { /* 注册焦点变更监听 */ return disposer },
  onTargetDestroy(handler) { /* 注册目标销毁监听 */ return disposer },
  createCommandEvent(cmd, payload) { /* 创建命令事件 */ return event },
}

const keymap = new Keymap(customHost)
```

---

## 完整示例

### OpenTUI + React

```tsx
import { createDefaultOpenTuiKeymap } from "@opentui/keymap"
import { KeymapProvider, useBindings, useActiveKeys } from "@opentui/keymap/react"

// 创建 Keymap
const keymap = createDefaultOpenTuiKeymap(renderer)

function App() {
  const [mode, setMode] = useState("normal")

  useBindings(() => ({
    commands: [
      {
        name: "switch-mode",
        title: "Switch Mode",
        run({ payload }) {
          setMode(mode === "normal" ? "insert" : "normal")
        },
      },
    ],
    bindings: [
      { key: "i", cmd: "switch-mode", mode: "normal" },
      { key: "escape", cmd: "switch-mode", mode: "insert" },
    ],
  }), [mode])

  return (
    <div>
      <div>Mode: {mode}</div>
      <StatusBar />
    </div>
  )
}

function StatusBar() {
  const activeKeys = useActiveKeys()
  return <div>Active: {activeKeys.join(", ")}</div>
}

// 渲染
renderer.render(
  <KeymapProvider keymap={keymap}>
    <App />
  </KeymapProvider>
)
```
