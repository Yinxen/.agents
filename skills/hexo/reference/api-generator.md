# 生成器 (Generator)

生成器根据处理后的原始文件建立路由。

## 概要

```javascript
hexo.extend.generator.register(name, function (locals) {
  // ...
});
```

`locals` 参数会被传递到此函数，其中包含网站变量。 请尽量利用此参数取得网站数据，避免直接访问数据库。

## 更新路由

```javascript
hexo.extend.generator.register("test", function (locals) {
  // Object
  return {
    path: "foo",
    data: "foo",
  };

  // Array
  return [
    { path: "foo", data: "foo" },
    { path: "bar", data: "bar" },
  ];
});
```

| 属性 | 描述 |
|------|------|
| `path` | 路径。 不可包含开头的 `/`。 |
| `data` | 数据 |
| `layout` | 布局。 指定用于渲染的布局。 该值可以是一个字符串或数组。 |

## 示例

### 归档页面

```javascript
hexo.extend.generator.register("archive", function (locals) {
  return {
    path: "archives/index.html",
    data: locals,
    layout: ["archive", "index"],
  };
});
```

### 有分页的归档页面

您可以通过 [hexo-pagination](https://github.com/hexojs/hexo-pagination) 来建立分页归档。

```javascript
var pagination = require("hexo-pagination");

hexo.extend.generator.register("archive", function (locals) {
  return pagination("archives", locals.posts, {
    perPage: 10,
    layout: ["archive", "index"],
    data: {},
  });
});
```

### 生成所有文章

```javascript
hexo.extend.generator.register("post", function (locals) {
  return locals.posts.map(function (post) {
    return {
      path: post.path,
      data: post,
      layout: "post",
    };
  });
});
```

### 复制文件

```javascript
var fs = require("hexo-fs");

hexo.extend.generator.register("asset", function (locals) {
  return {
    path: "file.txt",
    data: function () {
      return fs.createReadStream("path/to/file.txt");
    },
  };
});
```
