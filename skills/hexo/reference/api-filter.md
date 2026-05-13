# 过滤器 (Filter)

过滤器用于修改某些指定的数据。 Hexo 将数据按顺序传递给过滤器，然后过滤器逐个修改数据。

## 概要

```javascript
hexo.extend.filter.register(type, function() {
  // User configuration
  const { config } = this;
  if (config.external_link.enable) // do something...

  // Theme configuration
  const { config: themeCfg } = this.theme;
  if (themeCfg.fancybox) // do something...

}, priority);
```

您可以指定过滤器的优先级 `priority`。 `priority` 值越低，过滤器会越早执行。 默认的 `priority` 是 10。

## 执行过滤器

```javascript
hexo.extend.filter.exec(type, data, options);
hexo.extend.filter.execSync(type, data, options);
```

| 选项 | 描述 |
|------|------|
| `context` | 內容 |
| `args` | 参数。 必须为数组。 |

您还可以使用以下方法来执行过滤器：

```javascript
hexo.execFilter(type, data, options);
hexo.execFilterSync(type, data, options);
```

## 移除过滤器

```javascript
hexo.extend.filter.unregister(type, filter);
```

## 过滤器列表

### before_post_render

在文章开始渲染前执行。

```javascript
hexo.extend.filter.register("before_post_render", function (data) {
  data.title = data.title.toLowerCase();
  return data;
});
```

### after_post_render

在文章渲染完成后执行。

### before_exit

在 Hexo 即将结束时执行。

### before_generate

在生成器解析前执行。

### after_generate

在生成完成后执行。

### template_locals

修改模板的局部变量。

```javascript
hexo.extend.filter.register("template_locals", function (locals) {
  locals.now = Date.now();
  return locals;
});
```

### after_init

在 Hexo 初始化完成后执行。

### new_post_path

用来决定新建文章的路径。

### post_permalink

用于确定帖子的永久链接。

### after_render

在渲染后执行。

### after_clean

在使用 `hexo clean` 命令删除生成的文件和缓存后执行。

### server_middleware

向服务器添加中间件（Middleware）。

```javascript
hexo.extend.filter.register("server_middleware", function (app) {
  app.use(function (req, res, next) {
    res.setHeader("X-Powered-By", "Hexo");
    next();
  });
});
```
