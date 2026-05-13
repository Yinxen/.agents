# Renderables 和 Constructs 参考

OpenTUI 提供两种构建 UI 的方式：命令式 Renderable API 和声明式 Construct API。

## Renderables（命令式）

直接创建 `Renderable` 实例，使用 `add()` 组合，直接修改实例的属性和方法。

```typescript
import { BoxRenderable, TextRenderable, InputRenderable, createCliRenderer } from "@opentui/core"

const renderer = await createCliRenderer()

const container = new BoxRenderable(renderer, {
  id: "container", flexDirection: "column", padding: 1,
})
container.add(new TextRenderable(renderer, { id: "title", content: "My App" }))
container.add(new InputRenderable(renderer, { id: "input", placeholder: "Type here..." }))
renderer.root.add(container)
```

### 特点
- 创建时需要 `RenderContext`
- 直接修改实例
- 手动导航访问嵌套组件
- 对组件生命周期有明确控制

### 内置 Renderable 类

| 类 | 描述 |
|----|------|
| `BoxRenderable` | 容器，支持边框、背景和布局 |
| `TextRenderable` | 只读文本显示 |
| `InputRenderable` | 单行文本输入 |
| `TextareaRenderable` | 多行可编辑文本 |
| `SelectRenderable` | 下拉/列表选择 |
| `TabSelectRenderable` | 水平标签选择 |
| `ScrollBoxRenderable` | 可滚动容器 |
| `ScrollBarRenderable` | 独立滚动条 |
| `CodeRenderable` | 语法高亮代码 |
| `LineNumberRenderable` | 行号槽 |
| `DiffRenderable` | 统一或分屏 diff |
| `ASCIIFontRenderable` | ASCII 艺术字体 |
| `FrameBufferRenderable` | 原始帧缓冲 |
| `MarkdownRenderable` | Markdown 渲染 |
| `SliderRenderable` | 数值滑动条 |

### 子节点管理

```typescript
container.add(child)
container.remove("child-id")
const child = container.getRenderable("id")
const deepChild = container.findDescendantById("nested-id")
const children = container.getChildren()
```

### 生命周期方法

```typescript
class CustomRenderable extends Renderable {
  onUpdate(deltaTime: number) {}
  onResize(width: number, height: number) {}
  onRemove() {}
  renderSelf(buffer: OptimizedBuffer, deltaTime: number) {}
}
```

### 销毁

```typescript
renderable.destroy()
container.destroyRecursively()
```

## Constructs（声明式）

使用工厂函数构建轻量 VNode 图。组件在添加到树后才实例化。VNode 会排队方法调用并在实例化时回放。

```typescript
import { createCliRenderer, Text, Input, Box, delegate } from "@opentui/core"

const renderer = await createCliRenderer()

renderer.root.add(
  Box(
    { width: 40, height: 10, borderStyle: "rounded", padding: 1 },
    Text({ content: "Welcome!" }),
    Input({ placeholder: "Enter your name..." }),
  ),
)
```

### 特点
- 实例化前不需要 `RenderContext`
- VNode 排队方法调用
- `delegate()` 将 API 路由到嵌套组件
- 声明式、类似 React 的语法

### 可用 Construct 函数

```typescript
import { ASCIIFont, Box, Code, FrameBuffer, Input, ScrollBox, Select, TabSelect, Text, SyntaxStyle, RGBA } from "@opentui/core"

const box = Box({ border: true })
const text = Text({ content: "Hello" })
const input = Input({ placeholder: "Type here..." })
const code = Code({ content: "const x = 1", filetype: "typescript", syntaxStyle })
const scrollBox = ScrollBox({ width: 40, height: 10 })
const frameBuffer = FrameBuffer({ width: 20, height: 10 })
const ascii = ASCIIFont({ text: "OPEN", font: "tiny" })
```

### 自定义 Construct 函数

```typescript
function LabeledInput(props: { label: string; placeholder: string }) {
  return Box(
    { flexDirection: "row", gap: 1 },
    Text({ content: props.label }),
    Input({ placeholder: props.placeholder, width: 20 }),
  )
}
```

### VNode 方法链

```typescript
const input = Input({ id: "my-input", placeholder: "Type here..." })
input.focus()  // 排队，添加后执行
renderer.root.add(input)
```

## delegate() 函数

将外部方法调用路由到特定子组件：

```typescript
import { delegate, Box, Text, Input } from "@opentui/core"

function LabeledInput(props: { id: string; label: string; placeholder: string }) {
  return delegate(
    {
      focus: `${props.id}-input`,     // .focus() 路由到 input
      value: `${props.id}-input`,      // .value 代理到 input
    },
    Box(
      { flexDirection: "row" },
      Text({ content: props.label }),
      Input({ id: `${props.id}-input`, placeholder: props.placeholder, width: 20 }),
    ),
  )
}

const username = LabeledInput({ id: "username", label: "Name:", placeholder: "Enter name..." })
username.focus()  // 实际聚焦 Input，而非外层的 Box
renderer.root.add(username)
```

## 何时使用哪种方式

### 使用 Renderables 当：
- 需要对组件生命周期进行细粒度控制
- 构建底层自定义组件
- 需要立即访问 renderable 方法
- 性能关键场景，需要避免 VNode 开销

### 使用 Constructs 当：
- 偏好声明式、组合式代码
- 构建更高级的 UI 组件
- 想要更清晰、更可读的组件定义
- 熟悉 React/Solid 模式

## 混合使用

两种方式可以在同一个应用中混合使用：

```typescript
import { BoxRenderable, Text, Input } from "@opentui/core"

const container = new BoxRenderable(renderer, { id: "container", flexDirection: "column" })
container.add(Text({ content: "Title" }), Input({ placeholder: "Type here..." }))
renderer.root.add(container)
```

## Renderable 布局属性

所有 Renderable 支持 Yoga flexbox 属性：

```typescript
const panel = new BoxRenderable(renderer, {
  id: "panel",
  width: 40, height: "50%",
  minWidth: 20, maxHeight: 30,
  flexGrow: 1, flexShrink: 0,
  flexDirection: "column",
  justifyContent: "center",
  alignItems: "flex-start",
  position: "absolute", left: 10, top: 5,
  padding: 2, margin: 1,
})
```

## 焦点管理

```typescript
input.focus()
input.blur()
console.log(input.focused)

// 焦点事件
input.on(RenderableEvents.FOCUSED, () => {})
input.on(RenderableEvents.BLURRED, () => {})

// 后代焦点
// panel.hasFocusedDescendant — 当任何子元素有焦点时为 true
```

## 事件处理

### 鼠标事件

```typescript
const button = new BoxRenderable(renderer, {
  onMouseDown: (event) => {},
  onMouseOver: (event) => {},
  onMouseOut: (event) => {},
  onMouseMove: (event) => {},
  onMouseDrag: (event) => {},
  onMouseScroll: (event) => {},
})
```

### 键盘事件

```typescript
const input = new InputRenderable(renderer, {
  onKeyDown: (key) => {},
  onPaste: (event) => {},
})
```

## 其他属性

```typescript
panel.visible = false      // 隐藏（也从布局中移除）
panel.opacity = 0.5        // 半透明
panel.zIndex = 100         // 层级控制
renderable.translateX = 10 // 平移偏移（不影响布局）
renderable.translateY = -5
```
