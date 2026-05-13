# Tree-sitter 集成参考

OpenTUI 集成 Tree-sitter 实现快速准确的语法高亮。

## 全局添加解析器

```typescript
import { addDefaultParsers, getTreeSitterClient } from "@opentui/core"

addDefaultParsers([
  {
    filetype: "python",
    wasm: "https://github.com/tree-sitter/tree-sitter-python/releases/download/v0.23.6/tree-sitter-python.wasm",
    queries: {
      highlights: ["https://raw.githubusercontent.com/tree-sitter/tree-sitter-python/master/queries/highlights.scm"],
    },
  },
])

const client = getTreeSitterClient()
await client.initialize()
```

## 按客户端添加解析器

```typescript
import { TreeSitterClient } from "@opentui/core"

const client = new TreeSitterClient({ dataPath: "./cache" })
await client.initialize()

client.addFiletypeParser({
  filetype: "rust",
  wasm: "https://github.com/tree-sitter/tree-sitter-rust/releases/download/v0.23.2/tree-sitter-rust.wasm",
  queries: {
    highlights: ["https://raw.githubusercontent.com/tree-sitter/tree-sitter-rust/master/queries/highlights.scm"],
  },
})
```

## Parser 配置

```typescript
interface FiletypeParserOptions {
  filetype: string
  aliases?: string[]
  wasm: string
  queries: {
    highlights: string[]
    injections?: string[]
  }
  injectionMapping?: {
    nodeTypes?: Record<string, string>
    infoStringMap?: Record<string, string>
  }
}
```

## 语言注入

```typescript
client.addFiletypeParser({
  filetype: "markdown",
  wasm: "https://github.com/tree-sitter-grammars/tree-sitter-markdown/releases/download/v0.5.1/tree-sitter-markdown.wasm",
  queries: {
    highlights: ["./assets/markdown/highlights.scm"],
    injections: ["https://raw.githubusercontent.com/nvim-treesitter/.../markdown/injections.scm"],
  },
  injectionMapping: {
    nodeTypes: { inline: "markdown_inline", pipe_table_cell: "markdown_inline" },
    infoStringMap: { js: "javascript", jsx: "javascriptreact", ts: "typescript", tsx: "typescriptreact" },
  },
})
```

## 使用本地文件

```typescript
import pythonWasm from "./parsers/tree-sitter-python.wasm" with { type: "file" }
import pythonHighlights from "./queries/python/highlights.scm" with { type: "file" }

addDefaultParsers([{
  filetype: "python",
  wasm: pythonWasm,
  queries: { highlights: [pythonHighlights] },
}])
```

## 自动资产管理

### CLI 使用
```json
{
  "scripts": {
    "prebuild": "bun ./node_modules/@opentui/core/lib/tree-sitter/assets/update.ts --config ./parsers-config.json --assets ./src/parsers --output ./src/parsers.ts"
  }
}
```

### 编程使用
```typescript
import { updateAssets } from "@opentui/core"
await updateAssets({
  configPath: "./parsers-config.json",
  assetsDir: "./src/parsers",
  outputPath: "./src/parsers.ts",
})
```

## 在 CodeRenderable 中使用

```typescript
import { CodeRenderable, RGBA, SyntaxStyle, getTreeSitterClient } from "@opentui/core"

const client = getTreeSitterClient()
await client.initialize()

const syntaxStyle = SyntaxStyle.fromStyles({
  default: { fg: RGBA.fromHex("#E6EDF3") },
})

const code = new CodeRenderable(renderer, {
  content: "const x = 1",
  filetype: "typescript",
  syntaxStyle,
  treeSitterClient: client,
})
```

## 缓存

```typescript
const client = new TreeSitterClient({ dataPath: "./my-cache" })
```

## 文件类型解析

```typescript
import { pathToFiletype, extToFiletype, infoStringToFiletype } from "@opentui/core"

const ft1 = pathToFiletype("src/main.rs")
const ft2 = extToFiletype("ts")

// 扩展映射
import { extensionToFiletype, basenameToFiletype } from "@opentui/core"
extensionToFiletype.set("templ", "html")
basenameToFiletype.set("mytoolrc", "yaml")
```
