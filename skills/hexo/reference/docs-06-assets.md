# 资源文件夹与数据文件

## 资源文件夹

### 全局资源文件夹

将图片等资源放在 `source/images`，通过 Markdown 引用：

```markdown
![](/images/image.jpg)
```

### 文章资源文件夹

启用后，每次创建文章会自动创建同名文件夹：

```yaml
# _config.yml
post_asset_folder: true
```

```bash
hexo new "My Gallery"
# 创建:
# source/_posts/my-gallery.md
# source/_posts/my-gallery/  (同名文件夹)
```

#### 使用相对路径引用

使用标签插件而非 Markdown：

```markdown
{% asset_img example.jpg "示例图片" %}
{% asset_path example.jpg %}
{% asset_link example.jpg %}
```

#### Markdown 嵌入图片 (hexo-renderer-marked 3.1.0+)

```yaml
# _config.yml
post_asset_folder: true
marked:
  prependRoot: true
  postAsset: true
```

启用后可直接使用 Markdown：

```markdown
![](image.jpg)
# 自动解析为 <img src="/2024/01/02/hello/image.jpg">
```

## 数据文件夹

用于在模板中复用数据。

### 创建数据文件

```yaml
# source/_data/menu.yml
Home: /
Gallery: /gallery/
Archives: /archives/
```

### 模板中使用

```ejs
<% for (var link in site.data.menu) { %>
  <a href="<%= site.data.menu[link] %>"><%= link %></a>
<% } %>
```

渲染结果：

```html
<a href="/">Home</a>
<a href="/gallery/">Gallery</a>
<a href="/archives/">Archives</a>
```

### 支持格式

- YAML (.yml, .yaml)
- JSON (.json)

### 应用场景

- 导航菜单
- 社交链接
- 侧边栏内容
- 任何需要复用的结构化数据