# 代码高亮

Hexo 内建支持 Highlight.js 和 PrismJS。

## 配置

### v7.0.0 以下

```yaml
highlight:
  enable: true
  auto_detect: false
  line_number: true
  line_threshold: 0
  tab_replace: ""
  exclude_languages:
    - example
  wrap: true
  hljs: false

prismjs:
  enable: false
  preprocess: true
  line_number: true
  line_threshold: 0
  tab_replace: ""
```

### v7.0.0 及以上

```yaml
syntax_highlighter: highlight.js  # 或 prismjs

highlight:
  auto_detect: false
  line_number: true
  line_threshold: 0
  tab_replace: "  "
  exclude_languages:
    - example
  wrap: true
  hljs: false

prismjs:
  preprocess: true
  line_number: true
  line_threshold: 0
  tab_replace: ""
```

## Highlight.js

### 选项说明

| 选项 | 描述 |
|------|------|
| `enable` | 启用 |
| `auto_detect` | 自动检测语言（耗费资源） |
| `line_number` | 显示行号（用 figure/table 包裹） |
| `line_threshold` | 超过此行数才显示行号 |
| `tab_replace` | 替换 Tab 为指定字符串 |
| `exclude_languages` | 排除的语言 |
| `wrap` | 用 table 包裹（需要配合 line_number） |
| `hljs` | 添加 `hljs-` 前缀 |

### 输出示例

启用 `line_number` 时：

```html
<figure class="highlight yaml">
  <table>
    <tr>
      <td class="gutter">
        <pre><span class="line">1</span><br></pre>
      </td>
      <td class="code">
        <pre><span class="line"><span class="attr">hello:</span><span class="string">hexo</span></span><br></pre>
      </td>
    </tr>
  </table>
</figure>
```

## PrismJS

### 选项说明

| 选项 | 描述 |
|------|------|
| `enable` | 启用（v7.0.0+ 用 `syntax_highlighter`） |
| `preprocess` | 服务端预处理（可用部分插件） |
| `line_number` | 显示行号 |
| `line_threshold` | 超过此行数才显示行号 |
| `tab_replace` | 替换 Tab |

### 使用 `preprocess: false`

需要引入 `prism-line-numbers.css` 和 `prism-line-numbers.js`。

## 禁用高亮

### v7.0.0 以下

```yaml
highlight:
  enable: false
prismjs:
  enable: false
```

### v7.0.0 及以上

```yaml
syntax_highlighter: # 留空
```

禁用后，代码块输出由渲染器控制，`<code class="language-xxx">`。

## 主题

Highlight.js：
https://github.com/highlightjs/highlight.js/tree/master/src/styles

PrismJS：
https://github.com/PrismJS/prism-themes