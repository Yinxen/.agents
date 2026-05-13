# 标签插件参考

标签插件从 Octopress 移植，用于快速插入特定内容。**不应被 Markdown 语法包裹**。

## 引用块 blockquote

```markdown
{% blockquote %}
引用内容
{% endblockquote %}

{% blockquote author, source %}
引用内容
{% endblockquote %}

{% blockquote author, source link source_link_title %}
引用内容
{% endblockquote %}
```

### 示例

```markdown
{% blockquote David Levithan, Wide Awake %}
Do not just seek happiness for yourself.
{% endblockquote %}
```

## 代码块 codeblock

```markdown
{% codeblock [title] [lang:language] [url] [link text] [additional options] %}
code snippet
{% endcodeblock %}
```

### 选项

| 选项 | 描述 | 默认值 |
|------|------|--------|
| `line_number` | 显示行号 | `true` |
| `line_threshold` | 超过此行数才显示行号 | `0` |
| `highlight` | 启用代码高亮 | `true` |
| `first_line` | 起始行号 | `1` |
| `mark` | 高亮特定行 | - |
| `wrap` | 用 table 包裹 | `true` |

### 示例

```markdown
{% codeblock lang:objc %}
[rectangle setX: 10 y: 10 width: 20 height: 20];
{% endcodeblock %}

{% codeblock Array.map %}
array.map(callback[, thisArg])
{% endcodeblock %}

{% codeblock _.compact http://underscorejs.org/#compact Underscore.js %}
_.compact([0, 1, false, 2, '', 3]);
{% endcodeblock %}
```

## 反引号代码块

````markdown
```[language] [title] [url] [link text]
code snippet
```
````

## Pull Quote

```markdown
{% pullquote [class] %}
内容
{% endpullquote %}
```

## iframe

```markdown
{% iframe url [width] [height] %}
```

## 图片

```markdown
{% img [class names] /path/to/image [width] [height] '"title text" "alt text"' %}

{% asset_img example.jpg "图片说明" %}
```

### asset_img 选项

```markdown
{% asset_img foo.jpg %}                           # 默认
{% asset_img post-image foo.jpg %}                  # 自定义 class
{% asset_img foo.jpg 500 400 %}                    # 尺寸
{% asset_img foo.jpg "title" %}                   # title 和 alt
```

## 链接

```markdown
{% link text url [external] [title] %}
```

自动给外部链接添加 `target="_blank"`。

## 包含代码 include_code

```markdown
{% include_code [title] [lang:language] [from:line] [to:line] path/to/file %}
```

> 文件放在 `source/downloads/code` 目录（可配置 `code_dir`）

### 示例

```markdown
{% include_code lang:javascript test.js %}
{% include_code from:3 to:3 test.js %}      # 仅第 3 行
{% include_code from:5 to:8 test.js %}        # 第 5-8 行
{% include_code from:5 test.js %}             # 第 5 行到结尾
{% include_code to:8 test.js %}                # 第 1-8 行
```

## 包含帖子

```markdown
{% post_path filename %}
{% post_link filename [title] [escape] %}
```

### 示例

```markdown
{% post_link hexo-3-8-released %}

{% post_link hexo-3-8-released 'Link to a post' %}

{% post_link hexo-4-released '<b>bold</b> custom title' false %}
```

## 包含资源

```markdown
{% asset_path filename %}
{% asset_img [class] slug [width] [height] [title text alt text] %}
{% asset_link filename [title] [escape] %}
```

## URL 辅助 (7.0.0+)

```markdown
{% url_for text path [relative] %}

{% full_url_for text path %}
```

### 示例

```yaml
# _config.yml
root: /blog/
```

```markdown
{% url_for blog index.html %}
# => <a href="/blog/index.html">blog</a>

{% url_for blog index.html false %}
# => <a href="/index.html">blog</a> (禁用 relative_link)
```

## Raw

避免内容被解析：

```markdown
{% raw %}
{{ content }} {# 不会被解析 #}
{% endraw %}
```

## 帖子摘要

```markdown
摘要文字
<!-- more -->
正文内容
```

## 嵌入多媒体

### YouTube (已移除，用 hexo-tag-embed)

```markdown
{% youtube video_id [type] [cookie] %}
{% youtube lJIrF4YjHfQ %}
{% youtube PL9hW1uS6HUfscJ9DHkOSoOX45MjXduUxo 'playlist' %}
{% youtube lJIrF4YjHfQ false %}  # 隐私模式
```

### Vimeo (已移除，用 hexo-tag-embed)

```markdown
{% vimeo video_id [width] [height] %}
```

### jsFiddle (v7.0.0 移除)

```markdown
{% jsfiddle shorttag [tabs] [skin] [width] [height] %}
```

### Gist (v7.0.0 移除)

```markdown
{% gist gist_id [filename] %}
```