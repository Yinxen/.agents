---
name: hexo
description: Hexo 博客框架技能 - 涵盖安装、配置、写作、部署、主题开发、插件开发。使用场景：创建 Hexo 博客、写作文章、配置主题、部署到 GitHub/GitLab Pages、开发 Hexo 插件。
---

# Hexo 博客框架

Hexo 是一个快速、简洁且高效的静态博客框架，使用 Markdown 解析文章，秒级生成静态网页。

## 快速开始

```bash
# 安装 Hexo
npm install -g hexo-cli

# 初始化博客
hexo init myblog && cd myblog && npm install

# 常用命令
hexo new "文章标题"    # 创建文章
hexo generate          # 生成静态文件
hexo server           # 启动服务器
hexo deploy           # 部署
```

## 目录结构

```
.
├── _config.yml     # 网站配置
├── package.json
├── scaffolds/      # 文章模板
├── source/          # 源文件 (_posts, _drafts)
└── themes/          # 主题
```

## 核心命令

| 命令 | 简写 | 说明 |
|------|------|------|
| `hexo init [folder]` | - | 初始化网站 |
| `hexo new [layout] <title>` | `hexo n` | 创建文章 |
| `hexo generate` | `hexo g` | 生成静态文件 |
| `hexo server` | `hexo s` | 启动服务器 (4000端口) |
| `hexo deploy` | `hexo d` | 部署网站 |
| `hexo clean` | - | 清除缓存 |

**选项**: `--safe` (安全模式), `--debug` (调试), `--config` (自定义配置)

## 写作

```bash
hexo new "标题"           # 创建文章
hexo new page --path about/me "关于我"  # 创建页面
hexo new draft "草稿"     # 创建草稿
hexo publish "草稿"        # 发布草稿
```

## 部署

```yaml
# _config.yml
deploy:
  type: git
  repo: https://github.com/user/repo
  branch: gh-pages
```

```bash
hexo clean && hexo deploy
```

## 详细文档

参考 `@path reference/` 目录获取完整文档：

**用户文档：**
- `@path reference/docs-01-installation.md` - 安装与目录结构
- `@path reference/docs-02-configuration.md` - 完整配置参考
- `@path reference/docs-03-commands.md` - 所有命令详解
- `@path reference/docs-04-writing.md` - 写作指南 (Front-matter, 布局)
- `@path reference/docs-05-tag-plugins.md` - 标签插件完整参考
- `@path reference/docs-06-assets.md` - 资源文件夹与数据文件
- `@path reference/docs-07-deployment.md` - 部署指南 (GitHub/GitLab/Vercel 等)
- `@path reference/docs-08-permalinks.md` - 永久链接配置
- `@path reference/docs-09-themes.md` - 主题开发
- `@path reference/docs-10-variables.md` - 模板变量参考
- `@path reference/docs-11-helpers.md` - 辅助函数完整参考
- `@path reference/docs-12-i18n.md` - 国际化配置
- `@path reference/docs-13-syntax-highlight.md` - 代码高亮配置
- `@path reference/docs-14-plugins.md` - 插件开发
- `@path reference/docs-15-migration.md` - 从其他系统迁移
- `@path reference/docs-16-troubleshooting.md` - 故障排除

**API 文档：**
- `@path reference/api-core.md` - 核心 API (初始化、加载、命令、退出)
- `@path reference/api-events.md` - 事件
- `@path reference/api-locals.md` - 本地变量
- `@path reference/api-router.md` - 路由
- `@path reference/api-box.md` - Box 文件处理
- `@path reference/api-rendering.md` - 渲染
- `@path reference/api-posts.md` - 文章
- `@path reference/api-scaffolds.md` - 脚手架
- `@path reference/api-themes.md` - 主题
- `@path reference/api-console.md` - 控制台
- `@path reference/api-deployer.md` - 部署器
- `@path reference/api-filter.md` - 过滤器
- `@path reference/api-generator.md` - 生成器
- `@path reference/api-helper.md` - 辅助函数
- `@path reference/api-injector.md` - 注入器
- `@path reference/api-migrator.md` - 迁移器
- `@path reference/api-processor.md` - 处理器
- `@path reference/api-renderer.md` - 渲染器
- `@path reference/api-tag.md` - 标签

## 资源链接

- 官方文档: https://hexo.io/zh-cn/docs/
- API 文档: https://hexo.io/zh-cn/api/
- 主题列表: https://hexo.io/themes/
- 插件列表: https://hexo.io/plugins/