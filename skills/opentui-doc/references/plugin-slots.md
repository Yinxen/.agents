# 插件插槽系统参考

插件插槽允许宿主应用定义命名的布局位置（如状态栏、侧边栏、面板），插件在运行时为这些位置贡献 UI。

## 核心概念

- **宿主 (Host)**：定义插槽名称和插槽属性类型
- **插件 (Plugin)**：贡献一个或多个插槽渲染回调，可包含生命周期钩子
- **注册表 (Registry)**：注册插件并解析插槽的贡献
- **插槽模式 (Slot Mode)**：控制插件输出和后备 UI 的组合方式

## 定义插槽和宿主上下文

```typescript
import type { PluginContext } from "@opentui/core"

type AppSlots = {
  statusbar: { user: string }
  sidebar: { section: "left" | "right" }
}

interface AppContext extends PluginContext {
  appName: string
  version: string
}
```

## 创建注册表

```typescript
import { createSlotRegistry } from "@opentui/core"

const context = { appName: "my-app", version: "1.0.0" }
const registry = createSlotRegistry<string, AppSlots, typeof context>(renderer, "my-app:plugins", context)
```

类型参数：`TNode` 是框架节点类型（`BaseRenderable` / `ReactNode` / `JSX.Element`）。

`createSlotRegistry` 是渲染器作用域的。对于相同的 `(renderer, key)` 对，总是返回同一个注册表实例。

### 注册表选项

```typescript
const registry = createSlotRegistry(renderer, "my-key", context, {
  onPluginError: (event) => {},
  debugPluginErrors: true,
  maxPluginErrors: 100,
})
```

## 注册插件

```typescript
const unregister = registry.register({
  id: "clock-plugin",
  order: 0,
  setup(ctx, renderer) { /* 初始化资源 */ },
  dispose() { /* 清理资源 */ },
  slots: {
    statusbar(ctx, props) {
      return `${ctx.appName}:${props.user}`
    },
  },
})

unregister() // 移除插件
```

### 插件接口

| 字段 | 类型 | 必需 | 描述 |
|------|------|------|------|
| `id` | `string` | 是 | 唯一标识符 |
| `order` | `number` | 否 | 排序优先级（升序），默认 0 |
| `setup` | `(ctx, renderer) => void` | 否 | 注册时调用一次 |
| `dispose` | `() => void` | 否 | 插件取消注册时调用 |
| `slots` | `{ [slotName]: (ctx, props) => TNode }` | 是 | 插槽渲染回调 |

## 插槽模式

| 模式 | 行为 |
|------|------|
| `"append"` | 后备 UI 优先，然后是所有插件输出（默认） |
| `"replace"` | 仅插件输出；无插件贡献时显示后备 |
| `"single_winner"` | 仅排序第一的插件 |

## 解析贡献

```typescript
const entries = registry.resolveEntries("statusbar")
const slotRenderers = registry.resolve("statusbar")
```

## 注册表方法

| 方法 | 描述 |
|------|------|
| `register(plugin)` | 添加插件，返回取消注册函数 |
| `unregister(id)` | 按 ID 移除插件 |
| `updateOrder(id, order)` | 更改插件排序 |
| `clear()` | 移除并销毁所有插件 |
| `resolve(slot)` | 返回排序后的插槽渲染回调 |
| `resolveEntries(slot)` | 返回排序后的 `{ id, renderer }` 项 |
| `subscribe(listener)` | 监听注册变更 |
| `getPluginErrors()` | 返回缓冲的错误数组 |

## Core 插槽

```typescript
import { createCoreSlotRegistry, registerCorePlugin, SlotRenderable } from "@opentui/core"

const registry = createCoreSlotRegistry<"statusbar", typeof context>(renderer, context)

registerCorePlugin(registry, {
  id: "clock-plugin",
  slots: {
    statusbar(_ctx, data) {
      return new TextRenderable(renderer, { content: `clock: ${data.label}` })
    },
  },
})

const slot = new SlotRenderable(renderer, {
  id: "statusbar-slot",
  registry,
  name: "statusbar",
  mode: "append",
  fallback: () => new TextRenderable(renderer, { content: "fallback" }),
})

renderer.root.add(slot)
```

### 托管插槽对象

```typescript
registerCorePlugin(registry, {
  id: "managed-plugin",
  slots: {
    statusbar: {
      render(_ctx, data) { return new TextRenderable(renderer, { content: "managed" }) },
      onActivate(ctx) {},   // 插件在该插槽变为活跃（可见）
      onDeactivate(ctx) {}, // 不再活跃
      onDispose(ctx) {},    // 被移除或销毁
    },
  },
})
```

## React 插槽

```typescript
import { createReactSlotRegistry, Slot } from "@opentui/react"

const registry = createReactSlotRegistry<Slots, typeof context>(renderer, context)

const AppSlot = Slot<Slots, typeof context>

function App() {
  return (
    <AppSlot registry={registry} name="statusbar" user="sam" mode="replace">
      <text>fallback-statusbar</text>
    </AppSlot>
  )
}
```

### 便捷辅助函数

```typescript
const AppSlot = createSlot(registry) // 绑定注册表
```

## Solid 插槽

```typescript
import { createSolidSlotRegistry, Slot } from "@opentui/solid"

const registry = createSolidSlotRegistry<Slots, typeof context>(renderer, context)
const AppSlot = Slot<Slots, typeof context>

const App = () => (
  <AppSlot registry={registry} name="statusbar" user="sam" mode="replace">
    <text>fallback-statusbar</text>
  </AppSlot>
)
```

### 便捷辅助函数

```typescript
const AppSlot = createSlot(registry)
```

## 运行时加载外部插件

### Core
```typescript
import "@opentui/core/runtime-plugin-support"
const mod = await import(pathToFileURL(pluginPath).href)
registry.register(mod.loadExternalPlugin())
```

### React
```typescript
import "@opentui/react/runtime-plugin-support"
```

### Solid
```typescript
import "@opentui/solid/runtime-plugin-support"
```

### 配置运行时模块

```typescript
import { ensureRuntimePluginSupport } from "@opentui/react/runtime-plugin-support/configure"
ensureRuntimePluginSupport({
  additional: {
    "my-runtime-module": { marker: "ok" },
  },
})
```

## 错误处理

```typescript
registry.onPluginError((event) => {
  console.error(event.pluginId, event.phase, event.error.message)
})
```
