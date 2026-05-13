# CliRenderer 渲染器参考

`CliRenderer` 是 OpenTUI 的驱动核心。它管理终端输出、处理输入事件、运行渲染循环，并提供创建 renderable 的上下文。

## 创建渲染器

```typescript
import { createCliRenderer } from "@opentui/core"

const renderer = await createCliRenderer({
  exitOnCtrlC: true,
  targetFps: 30,
})
```

工厂函数做三件事：
1. 加载原生 Zig 渲染库
2. 配置终端设置（鼠标、键盘协议和屏幕模式）
3. 返回初始化的 `CliRenderer` 实例

## 配置选项

| 选项 | 类型 | 默认值 | 描述 |
|------|------|--------|------|
| `screenMode` | `ScreenMode` | `"alternate-screen"` | 终端空间使用方式 |
| `footerHeight` | `number` | `12` | split-footer 模式下的底部区域行数 |
| `externalOutputMode` | `ExternalOutputMode` | 随模式变化 | stdout.write 的处理方式 |
| `consoleMode` | `ConsoleMode` | `"console-overlay"` | 内置控制台覆盖层行为 |
| `exitOnCtrlC` | `boolean` | `true` | Ctrl+C 时调用 destroy() |
| `exitSignals` | `NodeJS.Signals[]` | 见下文 | 触发清理的信号 |
| `clearOnShutdown` | `boolean` | `true` | suspend/destroy 时清除渲染区域 |
| `targetFps` | `number` | `30` | 渲染循环目标帧率 |
| `maxFps` | `number` | `60` | 即时重渲染的最大 FPS |
| `useMouse` | `boolean` | `true` | 启用鼠标输入 |
| `autoFocus` | `boolean` | `true` | 左键点击时自动聚焦 |
| `enableMouseMovement` | `boolean` | `true` | 跟踪鼠标移动 |
| `useKittyKeyboard` | `KittyKeyboardOptions` | `{}` | Kitty 键盘协议设置 |
| `backgroundColor` | `ColorInput` | transparent | 渲染缓冲区背景色 |
| `consoleOptions` | `ConsoleOptions` | - | 控制台覆盖层选项 |
| `openConsoleOnError` | `boolean` | `true` (dev) | 未捕获错误时打开控制台 |

## 屏幕模式 (ScreenMode)

### `"alternate-screen"`（默认）
切换到终端的备用屏幕缓冲区。退出时恢复原始滚动内容。全屏 TUI 应用的标准模式。

### `"main-screen"`
在主屏幕上渲染。OpenTUI 仍通过滚动终端内容保留渲染区域。适用于测试、基准测试或短时工具。

### `"split-footer"`
将渲染器固定在终端底部的保留区域。上方区域可供正常程序输出使用。使用 `footerHeight` 控制底部行数（默认 12）。

```typescript
const renderer = await createCliRenderer({
  screenMode: "split-footer",
  footerHeight: 20,
})
renderer.footerHeight = 15 // 运行时更改
```

## 写入滚动区 (Scrollback)

在 split-footer 模式下且 `externalOutputMode: "capture-stdout"` 时使用。

### renderer.writeToScrollback(writer)
渲染 renderable 树到离屏缓冲区并提交为滚动快照。

```typescript
import { TextRenderable } from "@opentui/core"

renderer.writeToScrollback((ctx) => {
  const root = new TextRenderable(ctx.renderContext, {
    content: "api responded in 12ms",
    fg: "#8BD5CA",
  })
  return { root, width: ctx.width, height: 1, startOnNewLine: true, trailingNewline: true }
})
```

### renderer.createScrollbackSurface(options?)
用于流式输出（逐 token 代码高亮、markdown 块逐步解析）。

```typescript
const surface = renderer.createScrollbackSurface({ startOnNewLine: true })
// ... render into surface
surface.commitRows(0, surface.height)
surface.destroy()
```

## 渲染循环控制

### 自动模式（默认）
仅在组件树变化时重新渲染。

### 连续模式
```typescript
renderer.start()  // 开始连续渲染
renderer.stop()   // 停止渲染循环
renderer.targetFps = 60
renderer.maxFps = 120
```

### 实时渲染（动画）
```typescript
renderer.requestLive()  // 增加内部计数
renderer.dropLive()     // 减少计数
```

### 暂停和挂起
```typescript
renderer.pause()
renderer.suspend()  // 完全挂起（禁用鼠标、输入和原始模式）
renderer.resume()   // 恢复
```

## 关键属性

| 属性 | 类型 | 描述 |
|------|------|------|
| `root` | `RootRenderable` | 组件树的根节点 |
| `width` / `height` | `number` | 当前渲染宽度/高度 |
| `console` | `TerminalConsole` | 内置控制台覆盖层 |
| `keyInput` | `KeyHandler` | 键盘输入处理器 |
| `isRunning` | `boolean` | 渲染循环是否活跃 |
| `isDestroyed` | `boolean` | 渲染器是否已销毁 |
| `screenMode` | `ScreenMode` | 屏幕模式（可运行时赋值） |
| `themeMode` | `ThemeMode` | 检测到的终端主题（dark/light） |

## 事件

```typescript
renderer.on("resize", (width, height) => {})
renderer.on("focus", () => {})
renderer.on("blur", () => {})
renderer.on("theme_mode", (mode) => {})
renderer.on("palette", (colors) => {})
renderer.on("selection", (selection) => {})
renderer.on("destroy", () => {})
```

## 主题模式检测

```typescript
const mode = renderer.themeMode
renderer.on("theme_mode", (nextMode) => {})

// 等待主题检测
const mode = await renderer.waitForThemeMode(1000)
```

## 终端集成

```typescript
renderer.setTerminalTitle("My App")
renderer.setBackgroundColor("#0D1117")
renderer.resetTerminalBgColor()

// OSC 52 剪贴板
renderer.copyToClipboardOSC52("https://opentui.dev")
renderer.clearClipboardOSC52()

// 桌面通知
renderer.triggerNotification("Build finished", "OpenTUI")

// 光标控制
renderer.setCursorPosition(10, 5, true)
renderer.setCursorStyle({ style: "block", blinking: true })
```

## 输入处理

```typescript
renderer.addInputHandler((sequence) => {
  if (sequence === "\x1b[A") return true // handled
  return false
})
```

## 调试覆盖层

```typescript
renderer.toggleDebugOverlay()
renderer.configureDebugOverlay({ enabled: true, corner: DebugOverlayCorner.topRight })
```

## 清理

```typescript
renderer.destroy()  // 恢复终端状态，销毁所有资源
```

OpenTUI 不会在 `process.exit` 或未捕获错误时自动清理。请始终在退出路径中调用 `renderer.destroy()`。
