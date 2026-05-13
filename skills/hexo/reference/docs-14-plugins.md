# 插件开发

## 插件类型

| 类型 | 描述 |
|------|------|
| Console | 控制台命令 |
| Deployer | 部署器 |
| Filter | 过滤器 |
| Generator | 生成器 |
| Helper | 辅助函数 |
| Injector | 注入器 |
| Migrator | 迁移器 |
| Processor | 处理器 |
| Renderer | 渲染器 |
| Tag | 标签插件 |

## 脚本方式

简单的插件可放在 `scripts/` 目录：

```javascript
// scripts/my-plugin.js
hexo.extend.helper.register("hello", function() {
  return "Hello!";
});
```

## 包方式

创建 npm 包：

```
node_modules/
└── hexo-my-plugin/
    ├── index.js
    └── package.json
```

### package.json

```json
{
  "name": "hexo-my-plugin",
  "version": "0.0.1",
  "main": "index"
}
```

### index.js

```javascript
module.exports = function(hexo) {
  // 注册扩展
};
```

## Console

```javascript
hexo.extend.console.register('config', 'Display config', function(args) {
  console.log(hexo.config);
});
```

## Deployer

```javascript
hexo.extend.deployer.register('git', function(args) {
  // args.repo, args.branch, args.message
});
```

## Filter

```javascript
hexo.extend.filter.register('after_post_render', function(data) {
  data.content = data.content.replace(/@(\d+)/g, '<a href="http://twitter.com/$1">#$1</a>');
  return data;
}, 9);  // priority
```

### 内置过滤器

- `before_post_render` - 文章渲染前
- `after_post_render` - 文章渲染后
- `before_exit` - Hexo 退出前
- `before_generate` - 生成前
- `after_generate` - 生成后
- `template_locals` - 模板变量
- `after_init` - 初始化后
- `new_post_path` - 新文章路径
- `post_permalink` - 文章永久链接
- `after_render` - 渲染后
- `after_clean` - 清理后
- `server_middleware` - 服务器中间件

## Generator

```javascript
hexo.extend.generator.register('archive', function(locals) {
  return {
    path: 'archives/index.html',
    data: locals,
    layout: ['archive', 'index']
  };
});
```

## Helper

```javascript
hexo.extend.helper.register('hello', function() {
  return 'Hello!';
});
```

在模板中：`'<%- hello() %>'`

## Injector

```javascript
hexo.extend.injector.register('head_end', '<script src="/js/jquery.js"></script>');
hexo.extend.injector.register('body_end', '<script src="/app.js"></script>', 'page');
```

### 注入位置

- `head_begin` - `<head>` 后
- `head_end` - `</head>` 前
- `body_begin` - `<body>` 后
- `body_end` - `</body>` 前

### 注入目标

- `default` - 所有页面
- `home` - 首页
- `post` - 文章
- `page` - 独立页面
- `archive` - 归档
- `category` - 分类
- `tag` - 标签
- 自定义 layout

## Migrator

```javascript
hexo.extend.migrator.register('rss', function(args) {
  // 从 RSS 迁移
});
```

使用：`hexo migrate rss <source>`

## Processor

```javascript
hexo.extend.processor.register('data/:path*', function(file) {
  // 处理文件
});
```

## Renderer

```javascript
// 异步
hexo.extend.renderer.register('styl', 'css', function(data, options, callback) {
  stylus(data.text).render(callback);
});

// 同步
hexo.extend.renderer.register('ejs', 'html', function(data, options) {
  return ejs.render(data.text, options);
}, true);
```

## Tag

```javascript
// 无结束标签
hexo.extend.tag.register('youtube', function(args) {
  return '<iframe src="http://youtube.com/embed/' + args[0] + '"></iframe>';
});

// 有结束标签
hexo.extend.tag.register('quote', function(args, content) {
  return '<blockquote>' + content + '</blockquote>';
}, { ends: true });

// 异步
hexo.extend.tag.register('gist', function(args) {
  return '<script src="https://gist.github.com/' + args[0] + '.js"></script>';
}, { async: true });
```

## 官方工具包

- [hexo-fs](https://github.com/hexojs/hexo-fs) - 文件 IO
- [hexo-util](https://github.com/hexojs/hexo-util) - 工具函数
- [hexo-i18n](https://github.com/hexojs/hexo-i18n) - 国际化
- [hexo-pagination](https://github.com/hexojs/hexo-pagination) - 生成分页

## 发布插件

1. Fork [hexojs/site](https://github.com/hexojs/site)
2. 在 `source/_data/plugins/` 创建 `<plugin-name>.yml`:
   ```yaml
   description: Server module for Hexo.
   link: https://github.com/hexojs/hexo-server
   tags:
     - official
     - server
   ```
3. 提交 PR