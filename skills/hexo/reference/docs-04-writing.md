# 写作指南

## 创建文章

```bash
hexo new "标题"           # 默认布局 post
hexo new page --path about/me "关于我"  # 创建独立页面
hexo new draft "草稿"    # 创建草稿到 _drafts
hexo new layout "draft" "草稿标题"  # 指定布局创建
```

### 创建时的目录行为

| 命令 | 文件位置 | 说明 |
|------|----------|------|
| `hexo new "My Post"` | `source/_posts/my-post.md` | 标题为 "My Post" |
| `hexo new page --path a/b "Title"` | `source/a/b.md` | 独立页面 |
| `hexo new page "Title"` | `source/title/index.md` | 独立页面在子目录 |

## Front-matter

Front-matter 是文件开头的 YAML 或 JSON 代码块。

### YAML 格式

```yaml
---
title: Hello World
date: 2013/7/13 20:46:25
updated: 2013/7/14 18:00:00
comments: true
tags:
  - 标签1
  - 标签2
categories:
  - 分类1
  - 子分类
permalink: custom-url/
excerpt: 摘要文字
disableNunjucks: false
lang: zh-CN
published: true
---
```

### JSON 格式

```json
"title": "Hello World",
"date": "2013/7/13 20:46:25",
"tags": ["tag1", "tag2"],
"categories": ["category1"]
;;;
```

### Front-matter 字段

| 字段 | 描述 | 默认值 |
|------|------|--------|
| `layout` | 布局 | `default_layout` |
| `title` | 标题 | 文章文件名 |
| `date` | 建立日期 | 文件建立日期 |
| `updated` | 更新日期 | 文件更新日期 |
| `comments` | 开启评论 | `true` |
| `tags` | 标签 | - |
| `categories` | 分类 | - |
| `permalink` | 永久链接 | - |
| `excerpt` | 纯文本摘要 | - |
| `disableNunjucks` | 禁用 Nunjucks | `false` |
| `lang` | 语言 | 继承自 `_config.yml` |
| `published` | 是否发布 | `_posts` 为 `true`，`_drafts` 为 `false` |

## 分类和标签

### 简单分类

```yaml
categories:
  - Sports
  - Baseball
```

### 多级分类

```yaml
categories:
  - [Sports, Baseball]        # Sports > Baseball
  - [MLB, American League]    # MLB > American League
```

### 标签

```yaml
tags:
  - Injury
  - Fight
  - Shocking
```

## 布局 (Layout)

Hexo 有三种默认布局：

| 布局 | 路径 |
|------|------|
| `post` | `source/_posts` |
| `page` | `source` |
| `draft` | `source/_drafts` |

### 禁用布局

在 front-matter 中设置 `layout: false`，文章不会使用主题处理，但仍会被渲染引擎解析。

## 文件名称变量

| 占位符 | 描述 |
|--------|------|
| `:title` | 标题（小写，空格变短杠） |
| `:year` | 年份 (4位数) |
| `:month` | 月份（2位数，有前导零） |
| `:i_month` | 月份（无前导零） |
| `:day` | 日期（2位数） |
| `:i_day` | 日期（无前导零） |
| `:hour` | 小时 |
| `:minute` | 分钟 |
| `:second` | 秒 |
| `:id` | 文章 ID |

### 配置示例

```yaml
# _config.yml
new_post_name: :title.md           # Hello World -> Hello-World.md
new_post_name: :year-:month-:day-:title.md  # 添加日期前缀
```

## 草稿

```bash
hexo new draft "我的草稿"   # 创建到 source/_drafts
hexo publish "我的草稿"     # 发布到 source/_posts
```

默认不显示草稿。使用 `--draft` 选项或设置 `render_drafts: true` 显示草稿。

## 支持的格式

Hexo 支持任何格式，只需安装对应渲染插件：

| 格式 | 渲染器包 |
|------|----------|
| Markdown | hexo-renderer-marked (默认) |
| EJS | hexo-renderer-ejs |
| Pug | hexo-renderer-pug |
| AsciiDoc | hexo-renderer-asciidoc |

安装后只需更改文件扩展名：

```bash
mv post.md post.ejs   # Hexo 会使用 EJS 渲染
```