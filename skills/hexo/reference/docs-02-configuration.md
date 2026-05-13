# 配置参考

Hexo 配置在 `_config.yml` 或替代配置文件中修改。

## 网站配置

```yaml
# 网站信息
title: 我的网站
subtitle: 网站副标题
description: 网站描述
keywords: 关键词1, 关键词2
author: 你的名字
language: zh-CN
timezone: Asia/Shanghai
```

## 网址配置

```yaml
# 网址
url: https://example.com
root: /
permalink: :year/:month/:day/:title/
permalink_defaults:
  lang: en

# URL 美化
pretty_urls:
  trailing_index: false  # 移除 URL 尾部的 index.html
  trailing_html: false    # 移除 URL 尾部的 .html
```

> **子目录部署**: 如果网站放在子目录如 `/blog`，设置 `url: http://example.com/blog` 和 `root: /blog/`

## 目录配置

```yaml
source_dir: source        # 源文件目录
public_dir: public        # 生成的静态站点目录
tag_dir: tags            # 标签文件夹
archive_dir: archives      # 归档文件夹
category_dir: categories   # 分类文件夹
code_dir: downloads/code   # 代码文件夹
i18n_dir: :lang          # 国际化文件夹
skip_render: "mypage/**/*.html"  # 跳过渲染的文件
```

### skip_render 示例

```yaml
skip_render:
  - "mypage/**/*"           # 跳过 source/mypage/ 下的所有文件
  - "_posts/test-post.md"   # 跳过特定文章
```

## 文章配置

```yaml
# 文章文件命名
new_post_name: :title.md

# 默认布局
default_layout: post

# 标题转换
titlecase: false

# 外部链接
external_link:
  enable: true
  field: site
  exclude: ['www.example.com']

# 文件名大小写 (0: 原样, 1: 小写, 2: 大写)
filename_case: 0

# 显示草稿
render_drafts: false

# 启用资源文件夹
post_asset_folder: true

# 相对链接
relative_link: false

# 显示未来文章
future: true

# 代码高亮
syntax_highlighter: highlight.js
highlight:
  line_number: true
  auto_detect: false
  tab_replace: "  "
  wrap: true
  hljs: false
```

### 外部链接选项

| 选项 | 描述 | 默认值 |
|------|------|--------|
| `enable` | 是否开启 | `true` |
| `field` | 生效范围：`site` (整个站点) 或 `post` (仅文章) | `site` |
| `exclude` | 排除的域名 | `[]` |

## 首页设置

```yaml
index_generator:
  path: ''              # 博客索引页面的根路径
  per_page: 10          # 每页显示帖子数
  order_by: -date       # 排列顺序 (降序)
  pagination_dir: page   # URL 格式
```

## 分类 & 标签

```yaml
default_category: uncategorized
category_map:
  "yesterday's thoughts": yesterdays-thoughts
tag_map:
```

## 日期 / 时间格式

```yaml
date_format: YYYY-MM-DD
time_format: HH:mm:ss

# updated 字段取值方式
updated_option: mtime  # 'mtime', 'date', 或 'empty'
```

> `updated_option` 控制 front-matter 中没有指定 updated 时的行为：
> - `mtime`: 使用文件最后修改时间
> - `date`: 使用 date 作为 updated
> - `empty`: 删除 updated

## 分页

```yaml
per_page: 10           # 每页显示帖子数，0 关闭分页
pagination_dir: page   # URL 格式
```

### 分页示例

```yaml
pagination_dir: 'page'
# http://example.com/page/2

pagination_dir: 'awesome-page'
# http://example.com/awesome-page/2
```

## 扩展

```yaml
theme: landscape       # 当前主题
theme_config:          # 主题配置
  bio: "我的简介"
deploy:                # 部署配置
  type: git
```

## 包括/排除目录和文件

```yaml
include:
  - ".nojekyll"           # 包含隐藏文件
  - "css/_typing.css"     # 包含特定路径

exclude:
  - "js/test.js"           # 排除特定文件
  - "js/*"                 # 排除文件夹下所有文件

ignore:
  - "**/foo"               # 忽略所有 foo 文件夹
  - "**/themes/*/foo"     # 忽略 themes 下每个 foo 文件夹
```

## 多配置文件

```bash
# 使用自定义配置
hexo server --config custom.yml

# 合并多个配置（后者优先）
hexo server --config custom.yml,custom2.json
```

> 注意：列表中不允许有空格

## 主题配置

支持三种方式（优先级从高到低）：

1. `theme_config` (站点 _config.yml)
2. `_config.[theme].yml` (独立文件)
3. `themes/[theme]/_config.yml` (主题内)