# 模板变量参考

## 全局变量

| 变量 | 描述 | 类型 |
|------|------|------|
| `site` | 全站信息 | object |
| `page` | 页面内容 + front-matter | object |
| `config` | 网站配置 | object |
| `theme` | 主题配置 | object |
| `path` | 当前路径（不含根路径） | string |
| `url` | 完整 URL | string |
| `env` | 环境变量 | - |

## 网站变量 (site)

| 变量 | 描述 |
|------|------|
| `site.posts` | 所有文章 |
| `site.pages` | 所有分页 |
| `site.categories` | 所有分类 (Query object) |
| `site.tags` | 所有标签 (Query object) |

## 页面变量 (page)

### 通用页面 (page)

| 变量 | 描述 | 类型 |
|------|------|------|
| `page.title` | 标题 | string |
| `page.date` | 建立日期 | Moment.js |
| `page.updated` | 更新日期 | Moment.js |
| `page.comments` | 评论是否启用 | boolean |
| `page.layout` | 布局名称 | string |
| `page.content` | 完整内容 | string |
| `page.excerpt` | 摘要 | string |
| `page.more` | 摘要后的内容 | string |
| `page.source` | 源文件路径 | string |
| `page.full_source` | 完整原始路径 | string |
| `page.path` | 页面路径 | string |
| `page.permalink` | 完整 URL | string |
| `page.prev` | 上一页 | - |
| `page.next` | 下一页 | - |
| `page.raw` | 原始内容 | - |

### 文章 (post)

继承 page，并新增：

| 变量 | 描述 |
|------|------|
| `page.published` | 是否已发布（非草稿） |
| `page.categories` | 所有分类 |
| `page.tags` | 所有标签 |

### 首页 (index)

| 变量 | 描述 | 类型 |
|------|------|------|
| `page.per_page` | 每页文章数 | number |
| `page.total` | 总页数 | number |
| `page.current` | 当前页数 | number |
| `page.current_url` | 当前分页 URL | string |
| `page.posts` | 本页文章 | object |
| `page.prev` | 上一页页数 (0 表示没有) | number |
| `page.prev_link` | 上一页 URL | string |
| `page.next` | 下一页页数 | number |
| `page.next_link` | 下一页 URL | string |

### 分类归档 (category)

| 变量 | 描述 |
|------|------|
| `page.archive` | 是否归档 (true) |
| `page.year` | 年份 (4位数) |
| `page.month` | 月份 (无前导零) |

### 标签归档 (tag)

| 变量 | 描述 |
|------|------|
| `page.tag` | 标签名称 |

### 归档 (archive)

同 index，新增：

| 变量 | 描述 |
|------|------|
| `page.archive` | true |