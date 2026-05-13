# 文章 (Posts)

## 创建一个文章

```javascript
hexo.post.create(data, replace);
```

| 参数 | 描述 |
|------|------|
| `data` | 数据 |
| `replace` | 替换现有文件 |

帖子的属性可以在 `data` 中定义。

| Data | 描述 |
|------|------|
| `title` | 标题 |
| `slug` | 网址 |
| `layout` | 布局。 默认为 `default_layout` 参数。 |
| `path` | 路径。 默认会根据 `new_post_path` 参数创建文章路径。 |
| `date` | 日期。 默认为当前时间。 |

## 发布草稿

```javascript
hexo.post.publish(data, replace);
```

| 参数 | 描述 |
|------|------|
| `data` | 数据 |
| `replace` | 替换现有文件 |

## 渲染

```javascript
hexo.post.render(source, data);
```

| 参数 | 描述 |
|------|------|
| `source` | 文件的完整路径（可忽略） |
| `data` | 数据 |

此函数的执行顺序为：
1. 执行 `before_post_render` 过滤器
2. 使用 Markdown 或其他渲染器渲染
3. 使用 Nunjucks 渲染
4. 执行 `after_post_render` 过滤器
