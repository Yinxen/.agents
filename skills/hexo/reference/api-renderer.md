# 渲染器 (Renderer)

渲染器用于渲染内容。

## 概要

```javascript
hexo.extend.renderer.register(
  name,
  output,
  function (data, options) {
    // ...
  },
  sync,
);
```

| 参数 | 描述 |
|------|------|
| `name` | 输入的扩展名（小写，不含开头的 `.`） |
| `output` | 输出的扩展名（小写，不含开头的 `.`） |
| `sync` | 同步模式 |

| 参数 | 描述 |
|------|------|
| `data` | 包含 `path` 和 `text` 属性 |
| `option` | 选项 |
| `callback` | 回调函数 |

## 示例

### 异步模式

```javascript
var stylus = require("stylus");

// Callback
hexo.extend.renderer.register(
  "styl",
  "css",
  function (data, options, callback) {
    stylus(data.text).set("filename", data.path).render(callback);
  },
);

// Promise
hexo.extend.renderer.register("styl", "css", function (data, options) {
  return new Promise(function (resolve, reject) {
    resolve("test");
  });
});
```

### 同步模式

```javascript
var ejs = require("ejs");

hexo.extend.renderer.register(
  "ejs",
  "html",
  function (data, options) {
    options.filename = data.path;
    return ejs.render(data.text, options);
  },
  true,
);
```

### 禁用 Nunjucks 标签

```javascript
function lessFn(data, options) {
  // do something
}

lessFn.disableNunjucks = true;

hexo.extend.renderer.register("less", "css", lessFn);
```
