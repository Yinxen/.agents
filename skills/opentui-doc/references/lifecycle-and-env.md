# 生命周期和环境变量参考

## 生命周期与清理

OpenTUI 不会在 `process.exit` 或未捕获错误时自动清理。必须显式调用销毁。

### destroy()

```typescript
renderer.destroy()
```

使用 try/finally 确保清理：

```typescript
const renderer = await createCliRenderer()
try {
  // 应用代码
} finally {
  renderer.destroy()
}
```

### 销毁清理的内容

- 移除信号和进程监听器
- 清除定时器和渲染循环
- 销毁树中的所有 renderable
- 恢复 stdin 原始模式
- 重置终端状态（光标、备用屏幕等）
- 释放原生资源

### 信号处理

默认处理的信号：`SIGINT`、`SIGTERM`、`SIGQUIT`、`SIGABRT`、`SIGHUP`、`SIGBREAK`、`SIGPIPE`、`SIGBUS`

```typescript
// 自定义信号列表
const renderer = await createCliRenderer({
  exitSignals: ["SIGINT", "SIGTERM"],
})

// 禁用信号清理
const renderer = await createCliRenderer({
  exitSignals: [],
})
```

### Ctrl+C 行为

```typescript
const renderer = await createCliRenderer({
  exitOnCtrlC: false,
  exitSignals: ["SIGTERM"],
})

renderer.keyInput.on("keypress", (key) => {
  if (key.ctrl && key.name === "c") {
    // 自定义处理
  }
})
```

### 销毁回调

```typescript
const renderer = await createCliRenderer({
  onDestroy: () => { console.log("Renderer destroyed") },
})
```

### 故障排查

终端在崩溃后处于损坏状态时：
1. 运行 `reset` 恢复终端
2. 在应用中添加 `uncaughtException` 和 `unhandledRejection` 处理
3. 确保在所有退出路径中调用 `renderer.destroy()`

## 控制台覆盖层

捕获所有 `console.log` / `info` / `warn` / `error` / `debug` 调用。

```typescript
import { createCliRenderer, ConsolePosition } from "@opentui/core"

const renderer = await createCliRenderer({
  consoleOptions: {
    position: ConsolePosition.BOTTOM,
    sizePercent: 30,
    colorInfo: "#00FFFF",
    colorWarn: "#FFFF00",
    colorError: "#FF0000",
    startInDebugMode: false,
  },
})
```

### 控制台位置

```typescript
ConsolePosition.TOP
ConsolePosition.BOTTOM
ConsolePosition.LEFT
ConsolePosition.RIGHT
```

### 切换控制台

```typescript
renderer.console.toggle()
```

控制台快捷键（聚焦时）：方向键滚动、`+`/- 调整大小

### 环境变量

| 变量 | 描述 |
|------|------|
| `OTUI_USE_CONSOLE=false` | 禁用 console.* 捕获 |
| `SHOW_CONSOLE=true` | 启动时显示控制台 |
| `OTUI_DUMP_CAPTURES=true` | 退出时转储捕获输出 |

## 桌面通知

```typescript
const ok = renderer.triggerNotification("Build finished", "OpenTUI")

if (renderer.capabilities?.notifications) {
  renderer.triggerNotification("Tests passed", "CI")
}
```

## 原生音频

基于 miniaudio 的音频引擎。

```typescript
import { Audio } from "@opentui/core"

const audio = Audio.create({ autoStart: false })

const sound = await audio.loadSoundFile("click.wav")
if (sound != null && audio.start()) {
  audio.play(sound, { volume: 0.8, pan: 0, loop: false })
}
```

### 配置选项

| 选项 | 默认 | 描述 |
|------|------|------|
| `autoStart` | `false` | 创建时自动 start() |
| `sampleRate` | `48000` | 采样率 |
| `playbackChannels` | `2` | 回放通道数 |

### 方法

| 方法 | 描述 |
|------|------|
| `loadSound(data)` | 解码字节数据 |
| `loadSoundFile(path)` | 读取并解码文件 |
| `play(sound, options?)` | 开始播放 |
| `stopVoice(voice)` | 停止声音 |
| `group(name)` | 创建/复用命名分组 |
| `setMasterVolume(volume)` | 设置主音量 |

### Bun 独立可执行文件

```typescript
import { file } from "bun"
import { Audio } from "@opentui/core"
import clickPath from "./click.wav" with { type: "file" }

const audio = Audio.create({ autoStart: false })
const clickBytes = await file(clickPath).bytes()
const click = audio.loadSound(clickBytes)
audio.start()
audio.play(click)
```

## 键盘输入

```typescript
const keyHandler = renderer.keyInput

keyHandler.on("keypress", (key: KeyEvent) => {
  console.log(key.name, key.ctrl, key.shift, key.meta)
})

// 粘贴事件
const textDecoder = new TextDecoder()
keyHandler.on("paste", (event: PasteEvent) => {
  console.log(textDecoder.decode(event.bytes))
})
```

### KeyEvent 属性

| 属性 | 类型 | 描述 |
|------|------|------|
| `name` | `string` | 键名（如 "a", "escape", "f1"） |
| `sequence` | `string` | 原始转义序列 |
| `ctrl` | `boolean` | 是否按住 Ctrl |
| `shift` | `boolean` | 是否按住 Shift |
| `meta` | `boolean` | 是否按住 Alt/Meta |
| `option` | `boolean` | 是否按住 Option (macOS) |

### 键别名

- `enter` -> `return`
- `esc` -> `escape`
- 数字小键盘键映射到主键盘等效键

### Kitty 键盘协议

```typescript
const renderer = await createCliRenderer({
  useKittyKeyboard: {
    disambiguate: true,
    alternateKeys: true,
    events: false,
    allKeysAsEscapes: false,
    reportText: false,
  },
})
```

## 环境变量参考

| 变量 | 类型 | 默认 | 描述 |
|------|------|------|------|
| `OTUI_TS_STYLE_WARN` | boolean | false | 启用缺少语法样式的警告 |
| `OTUI_TREE_SITTER_WORKER_PATH` | string | "" | Tree-sitter worker 路径 |
| `OTUI_PALETTE_IDLE_TIMEOUT_MS` | number | 300 | 调色板查询后的静默超时 |
| `OTUI_DEBUG_FFI` | boolean | false | FFI 调试日志 |
| `OTUI_SHOW_STATS` | boolean | false | 启动时显示调试覆盖层 |
| `OTUI_TRACE_FFI` | boolean | false | FFI 追踪 |
| `OPENTUI_FORCE_WCWIDTH` | boolean | false | 使用 wcwidth 计算字符宽度 |
| `OPENTUI_FORCE_UNICODE` | boolean | false | 强制 Mode 2026 Unicode |
| `OPENTUI_GRAPHICS` | boolean | true | 启用 Kitty 图形协议检测 |
| `OTUI_USE_CONSOLE` | boolean | true | 启用全局 console.* 捕获 |
| `SHOW_CONSOLE` | boolean | false | 启动时打开控制台 |
| `OTUI_DUMP_CAPTURES` | boolean | false | 退出时转储捕获输出 |
| `OTUI_NO_NATIVE_RENDER` | boolean | false | 跳过 Zig 原生渲染器 |
| `OTUI_DEBUG` | boolean | false | 捕获所有原始 stdin 输入 |
