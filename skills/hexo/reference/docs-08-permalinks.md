# 永久链接

## 配置

在 `_config.yml` 中设置：

```yaml
permalink: :year/:month/:day/:title/
```

或每篇文章的 Front-matter 中指定：

```yaml
permalink: custom-url/
```

## 变量

| 变量 | 描述 |
|------|------|
| `:year` | 年份 (4位数) |
| `:month` | 月份 (2位数) |
| `:i_month` | 月份（无前导零） |
| `:day` | 日期 (2位数) |
| `:i_day` | 日期（无前导零） |
| `:hour` | 小时 |
| `:minute` | 分钟 |
| `:second` | 秒 |
| `:title` | 文件名（相对于 `_posts`） |
| `:name` | 文件名（不含扩展名） |
| `:post_title` | 文章标题 |
| `:id` | 文章 ID |
| `:category` | 分类，没有则为 `default_category` |
| `:hash` | SHA1 哈希值（12位16进制） |

## 默认值

```yaml
permalink_defaults:
  lang: en
```

## 示例

### 文章文件

```markdown
# source/_posts/hello-world.md
title: Hello World
date: 2013-07-14 17:01:34
categories:
  - foo
  - bar
```

### URL 结果

| 设置 | 结果 |
|------|------|
| `:year/:month/:day/:title/` | `2013/07/14/hello-world/` |
| `:year-:month-:day-:title.html` | `2013-07-14-hello-world.html` |
| `:category/:title/` | `foo/bar/hello-world/` |
| `:title-:hash/` | `hello-world-a2c8ac003b43/` |

### 子目录文章

```markdown
# source/_posts/lorem/hello-world.md
title: Hello World
date: 2013-07-14 17:01:34
```

| 设置 | 结果 |
|------|------|
| `:year/:month/:day/:title/` | `2013/07/14/lorem/hello-world/` |
| `:year/:month/:day/:name/` | `2013/07/14/hello-world/` |

## 多语言支持

```yaml
new_post_name: :lang/:title.md
permalink: :lang/:title/
```

```bash
hexo new "Hello World" --lang tw
# => source/_posts/tw/Hello-World.md
# URL: http://localhost:4000/tw/hello-world/
```

## 美化 URL

```yaml
# _config.yml
pretty_urls:
  trailing_index: false  # 移除 index.html
  trailing_html: false   # 移除 .html
```