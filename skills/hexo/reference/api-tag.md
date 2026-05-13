# 标签插件 (Tag)

标签插件帮助开发者在文章中快速插入内容。

## 概要

```javascript
hexo.extend.tag.register(
  name,
  function (args, content) {
    // ...
  },
  options,
);
```

标签函数会传入两个参数：`args` 和 `content`。 `args` 包含传入标签插件的参数，`content` 是标签插件所覆盖的内容。

## 移除标签插件

使用 `unregister()` 来用自定义函数替换现有的标签插件。

```javascript
hexo.extend.tag.unregister(name);
```

## Options

### ends

使用结束标签。 此选项默认为 `false`。

### async

启用异步模式。 此选项默认为 `false`。

## 示例

### 没有结束标签

```javascript
hexo.extend.tag.register("youtube", function (args) {
  var id = args[0];
  return (
    '<div class="video-container"><iframe width="560" height="315" src="http://www.youtube.com/embed/' +
    id +
    '" frameborder="0" allowfullscreen></iframe></div>'
  );
});
```

### 有结束标签

```javascript
hexo.extend.tag.register(
  "pullquote",
  function (args, content) {
    var className = args.join(" ");
    return (
      '<blockquote class="pullquote' +
      className +
      '">' +
      content +
      "</blockquote>"
    );
  },
  { ends: true },
);
```

### 异步渲染

```javascript
var fs = require("hexo-fs");
var pathFn = require("path");

hexo.extend.tag.register(
  "include_code",
  function (args) {
    var filename = args[0];
    var path = pathFn.join(hexo.source_dir, filename);

    return fs.readFile(path).then(function (content) {
      return "<pre><code>" + content + "</code></pre>";
    });
  },
  { async: true },
);
```

## Front-matter 和用户配置

```javascript
hexo.extend.tag.register('foo', function (args) {
  const [firstArg] = args;

  // User config
  const { config } = hexo;
  const editor = config.author + firstArg;

  // Theme config
  const { config: themeCfg } = hexo.theme;
  if (themeCfg.fancybox) // do something...

  // Front-matter
  const { title } = this; // article's title

  // Article's content
  const { _content } = this; // original content
  const { content } = this; // HTML-rendered content

  return 'foo';
});
```
