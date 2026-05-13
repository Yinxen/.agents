# 注入器 (Injector)

注入器被用于将静态代码片段注入生成的 HTML 的 `<head>` 和/或 `<body>` 中。

## 概要

```javascript
hexo.extend.injector.register(entry, value, to);
```

### entry

在 HTML 中的注入代码的位置。

支持这些值：
- `head_begin`: 注入在 `<head>` 之后（默认）
- `head_end`: 注入在 `</head>` 之前
- `body_begin`: 注入在 `<body>` 之后
- `body_end`: 注入在 `</body>` 之前

### value

除了字符串，也支持返回值为字符串的函数。

### to

哪些页面会被注入代码：
- `default`: 注入到每个页面（默认值）
- `home`: 只注入到主页
- `post`: 只注入到文章页面
- `page`: 只注入到独立页面
- `archive`: 只注入到归档页面
- `category`: 只注入到分类页面
- `tag`: 只注入到标签页面
- 或是其他自定义 layout 名称

## 示例

```javascript
const css = hexo.extend.helper.get("css").bind(hexo);
const js = hexo.extend.helper.get("js").bind(hexo);

hexo.extend.injector.register(
  "head_end",
  () => {
    return css(
      "https://cdn.jsdelivr.net/npm/aplayer@1.10.1/dist/APlayer.min.css",
    );
  },
  "music",
);

hexo.extend.injector.register(
  "body_end",
  '<script src="https://cdn.jsdelivr.net/npm/aplayer@1.10.1/dist/APlayer.min.js">',
  "music",
);
```

## 访问用户配置

```javascript
hexo.extend.injector.register("head_end", () => {
  const { cssPath } = hexo.config.fooPlugin;
  return css(cssPath);
});
```
