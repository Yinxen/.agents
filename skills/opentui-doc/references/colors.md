# 颜色系统参考

OpenTUI 使用 `RGBA` 类表示颜色。每个颜色还携带**颜色意图**：RGB 快照、索引 ANSI 槽或终端默认值。

## 创建颜色

```typescript
import { RGBA } from "@opentui/core"

// 从整数 (0-255)
const red = RGBA.fromInts(255, 0, 0, 255)

// 从浮点数 (0.0-1.0)
const green = RGBA.fromValues(0.0, 1.0, 0.0, 1.0)

// 从十六进制字符串
const purple = RGBA.fromHex("#800080")
const withAlpha = RGBA.fromHex("#FF000080")

// 字符串颜色（大部分组件属性接受）
Text({ content: "Hello", fg: "#00FF00" })
Box({ backgroundColor: "red", borderColor: "white" })
Box({ backgroundColor: "transparent" })
```

## parseColor 工具

```typescript
import { parseColor } from "@opentui/core"

const color1 = parseColor("#FF0000")       // 十六进制
const color2 = parseColor("blue")          // CSS 颜色名
const color3 = parseColor("transparent")   // 透明
const color4 = parseColor(RGBA.fromInts(255, 0, 0, 255)) // 直接传递
```

## 颜色意图 (ColorIntent)

每个颜色存储意图元数据，渲染器根据意图决定输出哪个 ANSI 序列：

| 意图 | 渲染器输出 | 描述 |
|------|-----------|------|
| `"rgb"` | `38;2;r;g;b` / `48;2;r;g;b` | 字面 RGB 值 |
| `"default"` | `39` / `49` (SGR default) | 终端默认前景/背景 |
| `"indexed"` | `38;5;n` / `48;5;n` | 索引 ANSI 色 |

```typescript
// 默认前景/背景
const fg = RGBA.defaultForeground()
const bg = RGBA.defaultBackground()
const fg = RGBA.defaultForeground("#E6EDF3") // 带 fallback RGB

// 索引 ANSI 颜色
const ansiRed = RGBA.fromIndex(1)
const ansiBrightBlue = RGBA.fromIndex(12)
const themed = RGBA.fromIndex(4, "#1F6FEB") // 带自定义 RGB 快照

// 检查意图
fg.intent    // => "default"
indexed.intent // => "indexed"
indexed.slot   // => 10
literal.intent // => "rgb"
```

## 终端调色板检测

```typescript
const colors = await renderer.getPalette({ size: 256 })
console.log(colors.palette[1])           // 调色板中的红色
console.log(colors.defaultForeground)    // 默认前景色
console.log(colors.defaultBackground)    // 默认背景色

renderer.paletteDetectionStatus          // "idle" | "detecting" | "cached"
renderer.clearPaletteCache()             // 清除缓存
renderer.on("palette", handler)          // 调色板变更事件
```

## Alpha 混合

```typescript
import { FrameBufferRenderable, RGBA } from "@opentui/core"

const canvas = new FrameBufferRenderable(renderer, { id: "canvas", width: 50, height: 20 })
const semiTransparent = RGBA.fromValues(1.0, 0.0, 0.0, 0.5)
canvas.frameBuffer.setCellWithAlphaBlending(10, 5, " ", transparent, semiTransparent)
```

## 文本属性 + 颜色

```typescript
import { TextRenderable, TextAttributes, RGBA } from "@opentui/core"

const styledText = new TextRenderable(renderer, {
  content: "Important",
  fg: RGBA.fromHex("#FFFF00"),
  bg: RGBA.fromHex("#333333"),
  attributes: TextAttributes.BOLD | TextAttributes.UNDERLINE,
})
```

## 导出常量

| 导出 | 描述 |
|------|------|
| `DEFAULT_FOREGROUND_RGB` | `[255, 255, 255]` 默认前景 fallback |
| `DEFAULT_BACKGROUND_RGB` | `[0, 0, 0]` 默认背景 fallback |
| `ColorIntent` | `"rgb" \| "indexed" \| "default"` |
| `ansi256IndexToRgb(index)` | 转换 ANSI 256 索引到 RGB |

## 打包传输

`RGBA.buffer` 是一个 `Uint16Array(4)`，低字节存储 r/g/b/a，高字节存储 32 位元数据。这使得原生缓冲区可以通过精确整数相等性比较帧颜色。
