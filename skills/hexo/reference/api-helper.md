# 辅助函数 (Helper)

辅助函数帮助您在模板中快速插入内容。 建议您把复杂的代码放在辅助函数而非模板中。

## 概要

```javascript
hexo.extend.helper.register(name, function () {
  // ...
});
```

## 示例

```javascript
hexo.extend.helper.register("js", function (path) {
  return '<script src="' + path + '"></script>';
});
```

在模板中使用：

```ejs
<%- js('script.js') %>
// <script src="script.js"></script>
```

## 常见问题

### 自定义 helper 应该放在哪里？

请放在 `scripts/` 或 `themes/<yourtheme>/scripts/` 目录中。

### 如何在我的自定义 helper 中使用另外一个已经注册的 helper？

```javascript
hexo.extend.helper.register("lorem", function (path) {
  return '<script src="' + this.url_for(path) + '"></script>';
});
```

### 如何在另一个扩展中使用注册的 helper？

```javascript
const url_for = hexo.extend.helper.get("url_for").bind(hexo);
```
