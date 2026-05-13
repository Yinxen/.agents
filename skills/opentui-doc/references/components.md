# 组件参考

OpenTUI 提供 15 个核心组件，涵盖文本显示、输入、容器、代码渲染、Markdown、滑动条、滚动条等。每个组件均支持命令式 `Renderable` API 和声明式 Construct 函数两种使用方式。

---

## 目录

1. [Text — 文本显示](#text--文本显示)
2. [Box — 容器](#box--容器)
3. [Input — 单行输入](#input--单行输入)
4. [Textarea — 多行文本编辑](#textarea--多行文本编辑)
5. [Select — 列表选择](#select--列表选择)
6. [TabSelect — 标签页选择](#tabselect--标签页选择)
7. [ScrollBox — 可滚动容器](#scrollbox--可滚动容器)
8. [ScrollBar — 滚动条](#scrollbar--滚动条)
9. [Slider — 滑动条](#slider--滑动条)
10. [Code — 语法高亮代码](#code--语法高亮代码)
11. [Markdown — Markdown 渲染](#markdown--markdown-渲染)
12. [LineNumber — 行号](#linenumber--行号)
13. [FrameBuffer — 帧缓冲](#framebuffer--帧缓冲)
14. [ASCIIFont — ASCII 艺术字体](#asciifont--ascii-艺术字体)
15. [Diff — Diff 对比](#diff--diff-对比)

---

## Text — 文本显示

显示只读文本，支持颜色、文本属性和选择。

### 基本使用

```typescript
// Renderable API
const text = new TextRenderable(renderer, {
  id: "greeting",
  content: "Hello!",
  fg: "#00FF00",
})

// Construct API
import { Text } from "@opentui/core"
const text = Text({ content: "Hello!", fg: "#00FF00" })
```

### 属性

| 属性 | 类型 | 描述 |
|------|------|------|
| `content` | `string` | 显示的文本内容 |
| `fg` | `string \| RGBA` | 前景色 |
| `bg` | `string \| RGBA` | 背景色 |
| `attributes` | `TextAttributes` | 文本属性（见下方） |
| `selectable` | `boolean` | 是否可被选中 |
| `position` | `Position` | 位置 |
| `id` | `string` | 组件标识 |

### TextAttributes 文本属性

通过位运算组合：

| 属性 | 描述 |
|------|------|
| `TextAttributes.BOLD` | 粗体 |
| `TextAttributes.DIM` | 暗色 |
| `TextAttributes.ITALIC` | 斜体 |
| `TextAttributes.UNDERLINE` | 下划线 |
| `TextAttributes.BLINK` | 闪烁 |
| `TextAttributes.INVERSE` | 反转 |
| `TextAttributes.HIDDEN` | 隐藏 |
| `TextAttributes.STRIKETHROUGH` | 删除线 |

```typescript
Text({
  content: "粗体+下划线",
  attributes: TextAttributes.BOLD | TextAttributes.UNDERLINE,
})
```

### 模板文字样式

使用 t\`\` 模板函数在文本中混入样式：

```typescript
import { t, bold, underline, fg, bg, italic } from "@opentui/core"

const richText = Text({
  content: t`${bold("重要:")} ${fg("#FF0000")(underline("警告!"))}`,
})
```

内联样式函数：

| 函数 | 描述 |
|------|------|
| `bold(text)` | 粗体 |
| `dim(text)` | 暗色 |
| `italic(text)` | 斜体 |
| `underline(text)` | 下划线 |
| `blink(text)` | 闪烁 |
| `reverse(text)` | 反转 |
| `strikethrough(text)` | 删除线 |
| `fg(color)(text)` | 设置前景色 |
| `bg(color)(text)` | 设置背景色 |

---

## Box — 容器

通用容器组件，支持边框、背景色和 flexbox 布局。

### 基本使用

```typescript
import { Box, Text } from "@opentui/core"

const container = Box({
  width: 40,
  height: 10,
  border: true,
  borderStyle: "rounded",
  backgroundColor: "#1e1e1e",
  padding: 1,
  flexDirection: "column",
  gap: 1,
}, Text({ content: "Hello" }))
```

### 属性

| 属性 | 类型 | 默认值 | 描述 |
|------|------|--------|------|
| `width` | `number \| string` | — | 宽度，支持百分比 |
| `height` | `number \| string` | — | 高度，支持百分比 |
| `backgroundColor` | `string \| RGBA` | — | 背景色 |
| `border` | `boolean` | `false` | 是否显示边框 |
| `borderStyle` | `string` | `"single"` | 边框样式：`"single"` \| `"double"` \| `"rounded"` \| `"heavy"` |
| `borderColor` | `string \| RGBA` | — | 边框颜色 |
| `title` | `string` | — | 顶部标题 |
| `titleAlignment` | `string` | — | 标题对齐方式 |
| `bottomTitle` | `string` | — | 底部标题 |
| `bottomTitleAlignment` | `string` | — | 底部标题对齐方式 |
| `padding` | `number` | `0` | 内边距 |
| `gap` | `number` | `0` | 子元素间距 |
| `flexDirection` | `string` | `"column"` | 主轴方向 |
| `justifyContent` | `string` | — | 主轴对齐方式 |
| `alignItems` | `string` | — | 交叉轴对齐方式 |
| `position` | `string` | — | 定位方式 |
| `onMouseDown` | `function` | — | 鼠标按下事件 |
| `onMouseOver` | `function` | — | 鼠标悬停事件 |
| `onMouseOut` | `function` | — | 鼠标离开事件 |
| `onMouseMove` | `function` | — | 鼠标移动事件 |
| `onMouseDrag` | `function` | — | 鼠标拖拽事件 |
| `onMouseDragEnd` | `function` | — | 鼠标拖拽结束事件 |
| `onMouseDrop` | `function` | — | 鼠标释放事件 |
| `onMouseScroll` | `function` | — | 鼠标滚轮事件 |
| `onMouse` | `function` | — | 通用鼠标事件 |

### 子节点管理

```typescript
// Renderable API
container.add(child)
container.remove("child-id")
const child = container.getRenderable("id")
const deepChild = container.findDescendantById("nested-id")
const children = container.getChildren()

// Construct API — 直接在构造函数中传入
Box({}, text1, text2, box2)
```

---

## Input — 单行输入

单行文本输入字段。

### 基本使用

```typescript
import { Input } from "@opentui/core"

const input = Input({
  width: 30,
  placeholder: "输入你的名字...",
  value: "",
  maxLength: 100,
})
```

### 属性

| 属性 | 类型 | 描述 |
|------|------|------|
| `width` | `number` | 输入框宽度 |
| `value` | `string` | 初始值 |
| `placeholder` | `string` | 占位文本 |
| `maxLength` | `number` | 最大字符数 |
| `backgroundColor` | `string \| RGBA` | 背景色 |
| `focusedBackgroundColor` | `string \| RGBA` | 聚焦时的背景色 |
| `textColor` | `string \| RGBA` | 文本颜色 |
| `cursorColor` | `string \| RGBA` | 光标颜色 |
| `position` | `Position` | 位置 |

### 事件

```typescript
// 失焦/按回车时触发（最终值）
input.on(InputRenderableEvents.CHANGE, (value: string) => {
  console.log("最终值:", value)
})

// 每次按键时触发
input.on(InputRenderableEvents.INPUT, (value: string) => {
  console.log("当前值:", value)
})

// 回车键按下时触发
input.on(InputRenderableEvents.ENTER, (value: string) => {
  console.log("提交:", value)
})
```

---

## Textarea — 多行文本编辑

功能完整的多行文本编辑器，支持光标移动、文本选择、键绑定、撤销/重做。

### 基本使用

```typescript
import { Textarea } from "@opentui/core"

const textarea = Textarea({
  width: 60,
  height: 20,
  placeholder: "输入内容...",
  wrapMode: "word",
})

// 监听事件
textarea.on("contentChange", (content: string) => {})
textarea.on("cursorChange", (cursor: { row: number; col: number }) => {})
textarea.on("submit", (content: string) => {})
```

### 属性

| 属性 | 类型 | 默认值 | 描述 |
|------|------|--------|------|
| `width` | `number` | — | 宽度 |
| `height` | `number` | — | 高度 |
| `initialValue` | `string` | `""` | 初始文本 |
| `placeholder` | `string` | — | 占位文本 |
| `placeholderColor` | `string \| RGBA` | — | 占位文本颜色 |
| `backgroundColor` | `string \| RGBA` | — | 背景色 |
| `textColor` | `string \| RGBA` | — | 文本颜色 |
| `focusedBackgroundColor` | `string \| RGBA` | — | 聚焦时的背景色 |
| `focusedTextColor` | `string \| RGBA` | — | 聚焦时的文本颜色 |
| `wrapMode` | `"none" \| "char" \| "word"` | `"none"` | 换行模式 |
| `selectionBg` | `string \| RGBA` | — | 选中区域背景色 |
| `selectionFg` | `string \| RGBA` | — | 选中区域前景色 |
| `cursorColor` | `string \| RGBA` | — | 光标颜色 |
| `cursorStyle` | `string` | — | 光标样式 |
| `keyBindings` | `object` | — | 自定义键绑定 |
| `onSubmit` | `function` | — | 提交回调 |
| `onContentChange` | `function` | — | 内容变化回调 |
| `onCursorChange` | `function` | — | 光标变化回调 |

### 实用属性

| 属性 | 类型 | 描述 |
|------|------|------|
| `plainText` | `string` | 纯文本内容（无样式） |
| `cursorOffset` | `number` | 光标在文本中的偏移量 |
| `logicalCursor` | `object` | 逻辑光标位置 (row, col) |
| `visualCursor` | `object` | 视觉光标位置 |
| `traits` | `object` | 编辑器特性 |

### Traits 特性

| 属性 | 类型 | 描述 |
|------|------|------|
| `traits.capture` | `(string \| RegExp)[]` | 需要捕获的按键 |
| `traits.suspend` | `boolean` | 是否挂起输入 |
| `traits.status` | `string` | 状态字符串 |

### 光标移动方法

```typescript
textarea.moveCursorLeft()
textarea.moveCursorLeft({ select: true })   // 带选择
textarea.moveCursorRight()
textarea.moveCursorRight({ select: true })
textarea.moveCursorUp()
textarea.moveCursorDown()
textarea.moveWordForward()
textarea.moveWordBackward()
textarea.gotoLineStart()
textarea.gotoLineEnd()
textarea.gotoBufferHome()
textarea.gotoBufferEnd()
```

### 选择方法

```typescript
textarea.setSelection(start: number, end: number)
textarea.selectAll()
textarea.clearSelection()
textarea.deleteSelection()
```

### 编辑方法

```typescript
textarea.insertChar("a")
textarea.insertText("Hello World")
textarea.deleteChar()
textarea.deleteCharBackward()
textarea.undo()
textarea.redo()
```

---

## Select — 列表选择

垂直列表选择组件，支持键盘导航。

### 基本使用

```typescript
import { Select } from "@opentui/core"

const select = Select({
  width: 30,
  height: 10,
  options: [
    { name: "选项 A", description: "这是选项 A 的描述", value: "a" },
    { name: "选项 B", description: "这是选项 B 的描述", value: "b" },
    { name: "选项 C", description: "这是选项 C 的描述", value: "c" },
  ],
  selectedIndex: 0,
})
```

### 属性

| 属性 | 类型 | 描述 |
|------|------|------|
| `width` | `number` | 宽度 |
| `height` | `number` | 高度 |
| `options` | `SelectOption[]` | 选项列表（见下方） |
| `selectedIndex` | `number` | 初始选中索引 |
| `backgroundColor` | `string \| RGBA` | 背景色 |
| `textColor` | `string \| RGBA` | 文本颜色 |
| `focusedBackgroundColor` | `string \| RGBA` | 聚焦项背景色 |
| `focusedTextColor` | `string \| RGBA` | 聚焦项文本颜色 |
| `selectedBackgroundColor` | `string \| RGBA` | 选中项背景色 |
| `selectedTextColor` | `string \| RGBA` | 选中项文本颜色 |
| `descriptionColor` | `string \| RGBA` | 描述文本颜色 |
| `showDescription` | `boolean` | 是否显示描述 |
| `showScrollIndicator` | `boolean` | 是否显示滚动指示器 |
| `wrapSelection` | `boolean` | 是否循环选择 |
| `itemSpacing` | `number` | 项间距 |
| `fastScrollStep` | `number` | 快滚步长 |

### SelectOption

| 属性 | 类型 | 描述 |
|------|------|------|
| `name` | `string` | 选项显示名称 |
| `description` | `string` | 选项描述 |
| `value` | `any` | 选项值（可选） |

### 事件

```typescript
select.on(SelectEvents.ITEM_SELECTED, (option: SelectOption) => {})
select.on(SelectEvents.SELECTION_CHANGED, (index: number) => {})
```

### 键盘绑定

| 按键 | 操作 |
|------|------|
| `Up` / `k` | 上移一项 |
| `Down` / `j` | 下移一项 |
| `Shift+Up` / `Shift+Down` | 快滚（默认 5 项） |
| `Enter` | 选择当前项 |

### 方法

```typescript
select.getSelectedIndex()        // number
select.getSelectedOption()       // SelectOption | undefined
select.setSelectedIndex(3)
select.moveUp(n?: number)        // 上移 n 项
select.moveDown(n?: number)      // 下移 n 项
select.selectCurrent()           // 触发选中当前项
```

---

## TabSelect — 标签页选择

水平标签选择组件。

### 基本使用

```typescript
import { TabSelect } from "@opentui/core"

const tabs = TabSelect({
  width: 60,
  options: [
    { name: "首页", value: "home" },
    { name: "设置", value: "settings" },
    { name: "关于", value: "about" },
  ],
  tabWidth: 20,
})
```

### 属性

| 属性 | 类型 | 默认值 | 描述 |
|------|------|--------|------|
| `width` | `number` | — | 宽度 |
| `options` | `TabSelectOption[]` | — | 标签选项列表 |
| `tabWidth` | `number` | `20` | 每个标签的宽度 |
| `backgroundColor` | `string \| RGBA` | — | 背景色 |
| `textColor` | `string \| RGBA` | — | 文本颜色 |
| `focusedBackgroundColor` | `string \| RGBA` | — | 聚焦标签背景色 |
| `focusedTextColor` | `string \| RGBA` | — | 聚焦标签文本色 |
| `selectedBackgroundColor` | `string \| RGBA` | — | 选中标签背景色 |
| `selectedTextColor` | `string \| RGBA` | — | 选中标签文本色 |
| `showScrollArrows` | `boolean` | — | 是否显示滚动箭头 |
| `showDescription` | `boolean` | — | 是否显示描述 |
| `showUnderline` | `boolean` | — | 是否显示下划线 |
| `wrapSelection` | `boolean` | — | 是否循环选择 |
| `keyBindings` | `object` | — | 自定义键绑定 |
| `keyAliasMap` | `object` | — | 键别名映射 |

### 键盘绑定

| 按键 | 操作 |
|------|------|
| `Left` / `[` | 上一个标签 |
| `Right` / `]` | 下一个标签 |
| `Enter` | 选择当前标签 |

---

## ScrollBox — 可滚动容器

提供垂直和水平滚动的容器组件。

### 基本使用

```typescript
import { ScrollBox, Text } from "@opentui/core"

const scroller = ScrollBox({
  width: 40,
  height: 20,
  scrollY: true,
  scrollX: false,
  stickyScroll: true,
}, Text({ content: "很长的内容..." }))
```

### 属性

| 属性 | 类型 | 默认值 | 描述 |
|------|------|--------|------|
| `scrollX` | `boolean` | `false` | 启用水平滚动 |
| `scrollY` | `boolean` | `true` | 启用垂直滚动 |
| `stickyScroll` | `boolean` | `false` | 粘性滚动 |
| `stickyStart` | `"top" \| "bottom" \| "left" \| "right"` | — | 粘性起始位置 |
| `viewportCulling` | `boolean` | `true` | 视口裁剪优化 |
| `scrollAcceleration` | `number` | — | 滚动加速 |
| `rootOptions` | `object` | — | 根容器选项 |
| `wrapperOptions` | `object` | — | 包装器选项 |
| `viewportOptions` | `object` | — | 视口选项 |
| `contentOptions` | `object` | — | 内容区域选项 |
| `scrollbarOptions` | `object` | — | 滚动条选项 |
| `verticalScrollbarOptions` | `object` | — | 垂直滚动条选项 |
| `horizontalScrollbarOptions` | `object` | — | 水平滚动条选项 |

### 额外属性

| 属性 | 类型 | 描述 |
|------|------|------|
| `scrollTop` | `number` | 垂直滚动位置 |
| `scrollLeft` | `number` | 水平滚动位置 |
| `scrollWidth` | `number` | 内容总宽度 |
| `scrollHeight` | `number` | 内容总高度 |

### 方法

```typescript
scrollbox.scrollBy(amount: number)
scrollbox.scrollTo(position: number)
scrollbox.scrollChildIntoView(id: string)
```

### 内部子组件

| 属性 | 类型 | 描述 |
|------|------|------|
| `scrollbox.wrapper` | `Renderable` | 外层包装器 |
| `scrollbox.viewport` | `Renderable` | 视口容器 |
| `scrollbox.content` | `Renderable` | 内容容器 |
| `scrollbox.horizontalScrollBar` | `Renderable` | 水平滚动条 |
| `scrollbox.verticalScrollBar` | `Renderable` | 垂直滚动条 |

---

## ScrollBar — 滚动条

独立可用的滚动条组件。

### 基本使用

```typescript
import { ScrollBar } from "@opentui/core"

const scrollBar = ScrollBar({
  orientation: "vertical",
  scrollSize: 100,
  viewportSize: 20,
  scrollPosition: 0,
  scrollStep: 1,
  onChange: (newPosition: number) => {},
})
```

### 属性

| 属性 | 类型 | 描述 |
|------|------|------|
| `orientation` | `"vertical" \| "horizontal"` | 方向 |
| `showArrows` | `boolean` | 是否显示箭头按钮 |
| `arrowOptions` | `object` | 箭头样式选项 |
| `trackOptions` | `object` | 轨道样式选项 |
| `scrollSize` | `number` | 内容总大小 |
| `viewportSize` | `number` | 视口大小 |
| `scrollPosition` | `number` | 当前滚动位置 |
| `scrollStep` | `number` | 滚动步长 |
| `onChange` | `function` | 滚动位置变化回调 |

---

## Slider — 滑动条

数值滑动条组件。

### 基本使用

```typescript
import { Slider } from "@opentui/core"

const slider = Slider({
  orientation: "horizontal",
  min: 0,
  max: 100,
  value: 50,
  viewPortSize: 20,
  onChange: (value: number) => {
    console.log("当前值:", value)
  },
})
```

### 属性

| 属性 | 类型 | 默认值 | 描述 |
|------|------|--------|------|
| `orientation` | `"vertical" \| "horizontal"` | — | 方向 |
| `value` | `number` | — | 当前值 |
| `min` | `number` | `0` | 最小值 |
| `max` | `number` | `100` | 最大值 |
| `viewPortSize` | `number` | — | 滑道可视大小 |
| `backgroundColor` | `string \| RGBA` | — | 背景色（滑道） |
| `foregroundColor` | `string \| RGBA` | — | 前景色（滑块） |
| `onChange` | `function` | — | 值变化回调 |

---

## Code — 语法高亮代码

基于 Tree-sitter 的语法高亮代码显示组件。

### 基本使用

```typescript
import { Code, SyntaxStyle, RGBA } from "@opentui/core"

const style = SyntaxStyle.fromStyles({
  keyword: { fg: RGBA.fromHex("#FF7B72"), bold: true },
  string: { fg: RGBA.fromHex("#A5D6FF") },
  comment: { fg: RGBA.fromHex("#8B949E"), italic: true },
  function: { fg: RGBA.fromHex("#D2A8FF") },
  number: { fg: RGBA.fromHex("#79C0FF") },
  type: { fg: RGBA.fromHex("#FFA657") },
  default: { fg: RGBA.fromHex("#E6EDF3") },
})

const code = Code({
  content: `function hello() {\n  console.log("Hello World")\n}`,
  filetype: "typescript",
  syntaxStyle: style,
  wrapMode: "none",
})
```

### 属性

| 属性 | 类型 | 默认值 | 描述 |
|------|------|--------|------|
| `content` | `string` | — | 代码内容 |
| `filetype` | `string` | — | 文件类型/语言 |
| `syntaxStyle` | `SyntaxStyle` | **必需** | 语法高亮样式 |
| `streaming` | `boolean` | `false` | 是否流式渲染 |
| `conceal` | `boolean` | `true` | 是否隐藏语法标记（如树枝字符） |
| `drawUnstyledText` | `boolean` | `true` | 是否绘制无样式文本 |
| `treeSitterClient` | `object` | — | Tree-sitter 客户端实例 |
| `fg` | `string \| RGBA` | — | 前景色 |
| `bg` | `string \| RGBA` | — | 背景色 |
| `selectable` | `boolean` | — | 是否可选中 |
| `selectionBg` | `string \| RGBA` | — | 选中背景色 |
| `selectionFg` | `string \| RGBA` | — | 选中前景色 |
| `wrapMode` | `string` | — | 换行模式 |
| `tabIndicator` | `string` | — | Tab 指示符 |

### 额外属性

| 属性 | 类型 | 描述 |
|------|------|------|
| `lineCount` | `number` | 行数 |
| `scrollY` | `number` | 垂直滚动位置 |
| `scrollX` | `number` | 水平滚动位置 |
| `scrollWidth` | `number` | 内容总宽度 |
| `scrollHeight` | `number` | 内容总高度 |
| `isHighlighting` | `boolean` | 是否正在高亮 |
| `plainText` | `string` | 纯文本内容 |

### Markdown 相关节点样式前缀

在 SyntaxStyle 中，Markdown 节点使用以下前缀：

| 样式键 | 描述 |
|--------|------|
| `markup.heading` | 标题 |
| `markup.bold` | 粗体 |
| `markup.italic` | 斜体 |
| `markup.list` | 列表 |
| `markup.quote` | 引用 |
| `markup.raw` | 行内代码 |
| `markup.link` | 链接 |
| `markup.strikethrough` | 删除线 |

---

## Markdown — Markdown 渲染

渲染 Markdown 内容为终端可读的格式化文本。

### 基本使用

```typescript
import { Markdown, SyntaxStyle, RGBA } from "@opentui/core"

const style = SyntaxStyle.fromStyles({
  "markup.heading": { fg: RGBA.fromHex("#FF7B72"), bold: true },
  "markup.bold": { bold: true },
  "markup.italic": { italic: true },
  "markup.list": { fg: RGBA.fromHex("#79C0FF") },
  "markup.quote": { fg: RGBA.fromHex("#8B949E"), italic: true },
  "markup.raw": { fg: RGBA.fromHex("#A5D6FF") },
  "markup.link": { fg: RGBA.fromHex("#58A6FF"), underline: true },
  default: { fg: RGBA.fromHex("#E6EDF3") },
})

const md = Markdown({
  content: `# 标题\n\n这是**粗体**和*斜体*文本。\n\n- 列表项 1\n- 列表项 2`,
  syntaxStyle: style,
})
```

### 属性

| 属性 | 类型 | 默认值 | 描述 |
|------|------|--------|------|
| `content` | `string` | — | Markdown 内容 |
| `syntaxStyle` | `SyntaxStyle` | — | 语法样式 |
| `fg` | `string \| RGBA` | — | 前景色 |
| `bg` | `string \| RGBA` | — | 背景色 |
| `conceal` | `boolean` | `true` | 是否隐藏标记字符 |
| `concealCode` | `boolean` | `false` | 是否隐藏代码栅栏标记 |
| `streaming` | `boolean` | `false` | 是否流式渲染 |
| `tableOptions` | `TableOptions` | — | 表格渲染选项 |
| `internalBlockMode` | `"coalesced" \| "top-level"` | `"coalesced"` | 内部块处理模式 |
| `treeSitterClient` | `object` | — | Tree-sitter 客户端 |
| `renderNode` | `function` | — | 自定义节点渲染函数 |

### TableOptions 表格选项

| 属性 | 类型 | 描述 |
|------|------|------|
| `style` | `"grid" \| "columns"` | 表格样式：网格或列 |
| `widthMode` | `"content" \| "full"` | 宽度模式 |
| `columnFitter` | `"proportional" \| "balanced"` | 列宽调整算法 |
| `wrapMode` | `string` | 列内换行模式 |
| `cellPadding` | `number` | 单元格内边距 |
| `borders` | `boolean \| object` | 边框设置 |
| `outerBorder` | `boolean` | 是否显示外边框 |
| `borderStyle` | `string` | 边框样式 |
| `borderColor` | `string \| RGBA` | 边框颜色 |
| `selectable` | `boolean` | 是否可选中 |

### 代码栅栏语言标准化

```typescript
import { infoStringToFiletype } from "@opentui/core"

// 获取文件类型
const ft = infoStringToFiletype("tsx")

// 扩展映射表
extensionToFiletype.set(".myext", "mylanguage")
basenameToFiletype.set("Makefile", "makefile")
```

---

## LineNumber — 行号

行号槽组件，常与代码编辑器搭配使用。

### 基本使用

```typescript
import { LineNumber, Code, SyntaxStyle } from "@opentui/core"

const lineNum = LineNumber({
  target: codeRenderable,  // 实现 LineInfoProvider 的组件
  minWidth: 3,
  paddingRight: 1,
  fg: "#8B949E",
})
```

### 属性

| 属性 | 类型 | 默认值 | 描述 |
|------|------|--------|------|
| `target` | `Renderable & LineInfoProvider` | **必需** | 关联的目标组件 |
| `fg` | `string \| RGBA` | — | 行号前景色 |
| `bg` | `string \| RGBA` | — | 行号背景色 |
| `minWidth` | `number` | `3` | 最小宽度（位数） |
| `paddingRight` | `number` | `1` | 右侧内边距 |
| `lineColors` | `Map` | — | 行颜色映射 |
| `lineSigns` | `Map` | — | 行标记映射 |
| `lineNumberOffset` | `number` | — | 行号偏移量 |
| `hideLineNumbers` | `boolean` | — | 是否隐藏行号 |
| `lineNumbers` | `number[]` | — | 行号数组 |
| `showLineNumbers` | `boolean` | — | 是否显示行号 |

### 方法

```typescript
lineNum.setLineColor(line: number, color: string)
lineNum.clearLineColor(line: number)
lineNum.setLineSign(line: number, sign: string)
lineNum.clearLineSign(line: number)
lineNum.setLineNumbers(numbers: number[])
lineNum.setHideLineNumbers(hide: boolean)
```

---

## FrameBuffer — 帧缓冲

低级别渲染表面，用于直接绘制字符、颜色和像素级操作。

### 基本使用

```typescript
import { FrameBuffer } from "@opentui/core"

const canvas = FrameBuffer({
  width: 50,
  height: 20,
  respectAlpha: true,
})

// 写入像素
canvas.frameBuffer.setCell(10, 5, "@", "#FF0000", "#000000")
canvas.frameBuffer.drawText("Hello", 0, 0, "#FFFFFF")
```

### 属性

| 属性 | 类型 | 描述 |
|------|------|------|
| `width` | `number` | 宽度 |
| `height` | `number` | 高度（必需） |
| `respectAlpha` | `boolean` | 是否启用 Alpha 通道 |
| `position` | `Position` | 位置 |

### 方法

```typescript
// 设置单个单元格
framebuffer.setCell(x, y, char, fg, bg, attributes?)
framebuffer.setCellWithAlphaBlending(x, y, char, fg, bg)

// 绘制文本
framebuffer.drawText(text, x, y, fg, bg?, attributes?)

// 填充矩形
framebuffer.fillRect(x, y, width, height, color)

// 帧缓冲间复制
framebuffer.drawFrameBuffer(destX, destY, sourceBuffer, srcX?, srcY?, srcW?, srcH?)

// 颜色矩阵变换
framebuffer.colorMatrix(matrix, cellMask, strength, target)
framebuffer.colorMatrixUniform(matrix, strength, target)
```

### TargetChannel 颜色矩阵目标通道

| 常量 | 值 | 描述 |
|------|-----|------|
| `TargetChannel.FG` | `1` | 仅前景 |
| `TargetChannel.BG` | `2` | 仅背景 |
| `TargetChannel.Both` | `3` | 前景和背景 |

### 预定义颜色矩阵

```typescript
import { INVERT_MATRIX, SEPIA_MATRIX } from "@opentui/core"

// 反转颜色
canvas.frameBuffer.colorMatrix(INVERT_MATRIX, TargetChannel.Both, 1.0)

// 棕褐色滤镜
canvas.frameBuffer.colorMatrix(SEPIA_MATRIX, TargetChannel.Both, 0.8)
```

### 性能建议

- **批量更新**：合并多次像素写入以减少重绘
- **重用 RGBA 对象**：避免在循环中频繁创建 `RGBA` 实例
- **避免在循环中创建 RGBA**：预定义颜色对象并在循环外创建

---

## ASCIIFont — ASCII 艺术字体

将文本渲染为 ASCII 艺术字体。

### 基本使用

```typescript
import { ASCIIFont } from "@opentui/core"

const ascii = ASCIIFont({
  text: "OPEN",
  font: "tiny",
  color: "#00FF00",
})
```

### 属性

| 属性 | 类型 | 描述 |
|------|------|------|
| `text` | `string` | 要渲染的文本 |
| `font` | `ASCIIFontName` | ASCII 字体名称（见下方） |
| `color` | `ColorInput \| ColorInput[]` | 单个颜色或逐字符颜色数组 |
| `backgroundColor` | `string \| RGBA` | 背景色 |
| `selectable` | `boolean` | 是否可选中 |
| `selectionBg` | `string \| RGBA` | 选中背景色 |
| `selectionFg` | `string \| RGBA` | 选中前景色 |
| `x` | `number` | X 偏移 |
| `y` | `number` | Y 偏移 |

### 可用字体

| 字体名 | 描述 |
|--------|------|
| `"tiny"` | 极简小字体 |
| `"block"` | 块状字体 |
| `"shade"` | 阴影字体 |
| `"slick"` | 流畅字体 |
| `"huge"` | 大号字体 |
| `"grid"` | 网格字体 |
| `"pallet"` | 调色板字体 |

### 示例

```typescript
// 单色
ASCIIFont({ text: "TUI", font: "block", color: "#FF7B72" })

// 逐字着色
ASCIIFont({
  text: "RGB",
  font: "huge",
  color: ["#FF0000", "#00FF00", "#0000FF"],
})
```

---

## Diff — Diff 对比

统一或分屏并排显示 diff 对比。

### 基本使用

```typescript
import { Diff, SyntaxStyle } from "@opentui/core"

const diffView = Diff({
  diff: `--- a/file.ts
+++ b/file.ts
@@ -1,3 +1,4 @@
-const x = 1
+const x = 2
 console.log("hello")
+console.log("world")`,
  view: "split",
  filetype: "typescript",
  syntaxStyle: style,
})
```

### 属性

| 属性 | 类型 | 默认值 | 描述 |
|------|------|--------|------|
| `diff` | `string` | — | Diff 字符串（unified format） |
| `view` | `"unified" \| "split"` | `"unified"` | 视图模式：统一或分屏 |
| `syncScroll` | `boolean` | — | 分屏时同步滚动 |
| `filetype` | `string` | — | 文件类型（语法高亮用） |
| `fg` | `string \| RGBA` | — | 前景色 |
| `syntaxStyle` | `SyntaxStyle` | — | 语法高亮样式 |
| `wrapMode` | `string` | — | 换行模式 |
| `conceal` | `boolean` | — | 是否隐藏语法标记 |
| `selectionBg` | `string \| RGBA` | — | 选中区域背景色 |
| `selectionFg` | `string \| RGBA` | — | 选中区域前景色 |
| `treeSitterClient` | `object` | — | Tree-sitter 客户端 |
| `showLineNumbers` | `boolean` | `true` | 是否显示行号 |
| `lineNumberFg` | `string \| RGBA` | — | 行号前景色 |
| `lineNumberBg` | `string \| RGBA` | — | 行号背景色 |
| `addedBg` | `string` | `"#1a4d1a"` | 新增行背景色 |
| `removedBg` | `string` | `"#4d1a1a"` | 删除行背景色 |
| `contextBg` | `string \| RGBA` | — | 上下文行背景色 |
| `addedSignColor` | `string \| RGBA` | — | 新增标记颜色 |
| `removedSignColor` | `string \| RGBA` | — | 删除标记颜色 |
| 以及其他行号/内容背景颜色属性 | — | — | 更多定制颜色 |

---

> **注意**：所有组件均支持通过 `id` 属性标识自身，在 Construct API 中支持方法链排队，在 Renderable API 中支持直接方法调用。更多关于两种 API 的选择，请参阅 [Renderables 和 Constructs 参考](./renderables-and-constructs.md)。
