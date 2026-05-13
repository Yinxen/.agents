# 主题开发

## 主题结构

```
themes/
└── my-theme/
    ├── _config.yml    # 主题配置
    ├── languages/     # 语言文件
    ├── layout/         # 模板文件
    │   ├── index.ejs
    │   ├── post.ejs
    │   ├── page.ejs
    │   └── layout.ejs
    ├── scripts/       # 脚本
    └── source/        # 资源文件 (CSS, JS, 图片)
```

## 配置文件

`_config.yml` 修改时会自动更新，无需重启服务器。

## 语言文件

语言文件放在 `languages/` 目录：

```
languages/
├── en.yml
├── zh-CN.yml
└── zh-TW.yml
```

## 模板 (Layout)

### 模板类型

| 模板 | 页面 | 回退 |
|------|------|------|
| `index` | 首页 | - |
| `post` | 文章 | `index` |
| `page` | 分页/独立页面 | `index` |
| `archive` | 归档 | `index` |
| `category` | 分类归档 | `archive` |
| `tag` | 标签归档 | `archive` |

### 布局 (Layout)

用于共享结构：

```ejs
<!-- layout.ejs -->
<!doctype html>
<html>
  <body>
    <%- body %>
  </body>
</html>
```

```ejs
<!-- index.ejs -->
<h1>Home Page</h1>
<%- partial('footer') %>
```

## Partials (局部模板)

```ejs
<!-- partial/header.ejs -->
<h1 id="logo"><%= config.title %></h1>
```

```ejs
<%- partial('partial/header') %>
<%- partial('partial/header', {title: 'Hello World'}) %>
```

### 带局部变量

```ejs
<!-- partial/header.ejs -->
<h1 id="logo"><%= title %></h1>
```

```ejs
<%- partial('partial/header', {title: 'Hello World'}) %>
```

## 局部缓存 (Fragment Caching)

减少重复渲染：

```ejs
<%- fragment_cache('header', function(){
  return '<header></header>';
}); %>

<%- partial('header', {}, {cache: true}); %>
```

> 注意：不同页面的渲染结果必须相同时才使用

## 脚本 (Scripts)

启动时加载 `scripts/` 下的 JavaScript 文件。

```javascript
// scripts/hello.js
hexo.extend.helper.register("hello", function() {
  return "Hello!";
});
```

## 资源文件

`source/` 下的文件会被处理：
- 可渲染文件（CSS, JS）→ 解析后放到 `public/`
- 不可渲染文件 → 直接复制到 `public/`

开头为 `_` 或隐藏的文件会被忽略。

## 发布主题

1. Fork [hexojs/site](https://github.com/hexojs/site)
2. 在 `source/_data/themes/` 创建 `<theme-name>.yml`:
   ```yaml
   description: A theme for Hexo.
   link: https://github.com/username/hexo-theme-xxx
   preview: http://example.com/theme-preview.png
   tags:
     - official
     - responsive
   ```
3. 添加截图 `source/themes/screenshots/<theme-name>.png` (800x500)
4. 提交 PR