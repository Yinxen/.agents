# 迁移指南

## RSS

```bash
npm install hexo-migrator-rss --save
hexo migrate rss <source>
```

`<source>` 可以是文件路径或网址。

## Jekyll

1. 复制 `_posts` 到 `source/_posts`
2. 修改 `_config.yml`:
   ```yaml
   new_post_name: :year-:month-:day-:title.md
   ```

## Octopress

1. 复制 `source/_posts` 到 `source/_posts`
2. 修改 `_config.yml`:
   ```yaml
   new_post_name: :year-:month-:day-:title.md
   ```

## WordPress

```bash
npm install hexo-migrator-wordpress --save
```

1. WordPress 仪表盘导出 (Tools → Export → WordPress)
2. 运行：
   ```bash
   hexo migrate wordpress <source>
   ```

`<source>` 可以是文件路径或网址。

## Joomla

```bash
npm install hexo-migrator-joomla --save
```

1. 用 [J2XML](http://extensions.joomla.org/extensions/migration-a-conversion/data-import-a-export/12816) 导出文章
2. 运行：
   ```bash
   hexo migrate joomla <source>
   ```

## 其他系统

如果 Hexo 没有对应迁移器，可以：

1. 导出为 Markdown/RSS
2. 编写脚本转换为 Hexo 格式
3. 或手动迁移