# 安装与目录结构

## 安装要求

- **Node.js**: 版本 >= 10.13（建议 >= 12.0）
- **Git**: 用于版本控制

## 安装 Hexo

```bash
# 安装 Hexo
npm install -g hexo-cli

# 初始化博客
hexo init myblog
cd myblog
npm install
```

## 进阶安装

```bash
# 仅局部安装 hexo 包
npm install hexo

# 使用 npx 执行
npx hexo <command>

# Linux 添加到 PATH
echo 'PATH="$PATH:./node_modules/.bin"' >> ~/.profile
```

## 目录结构

```
.
├── _config.yml     # 网站配置
├── package.json
├── scaffolds/      # 文章模板
│   ├── draft.md
│   ├── page.md
│   └── post.md
├── source/          # 源文件
│   ├── _drafts/    # 草稿
│   └── _posts/     # 已发布文章
└── themes/          # 主题
```

## 文件说明

| 文件/目录 | 描述 |
|-----------|------|
| `_config.yml` | 网站配置，可配置大部分参数 |
| `package.json` | 应用信息，EJS/Stylus/Markdown 渲染器已默认安装 |
| `scaffolds/` | 模板文件夹，新建文章时根据模板创建 |
| `source/` | 用户资源，Markdown/HTML 被解析到 public，其他文件直接复制 |
| `themes/` | 主题文件夹，Hexo 根据主题生成静态页面 |

## package.json 示例

```json
{
  "name": "hexo-site",
  "version": "0.0.0",
  "private": true,
  "hexo": { "version": "" },
  "dependencies": {
    "hexo": "^7.0.0",
    "hexo-generator-archive": "^2.0.0",
    "hexo-generator-category": "^2.0.0",
    "hexo-generator-index": "^3.0.0",
    "hexo-generator-tag": "^2.0.0",
    "hexo-renderer-ejs": "^2.0.0",
    "hexo-renderer-stylus": "^3.0.0",
    "hexo-renderer-marked": "^6.0.0",
    "hexo-server": "^3.0.0",
    "hexo-theme-landscape": "^1.0.0"
  }
}
```

## Node.js 版本限制

| Hexo 版本 | 最低 Node.js | 最高 Node.js |
|-----------|-------------|--------------|
| 8.0+ | 20.19.0 | latest |
| 7.0+ | 14.0.0 | latest |
| 6.2+ | 12.13.0 | latest |
| 6.0+ | 12.13.0 | 18.5.0 |
| 5.0+ | 10.13.0 | 12.0.0 |

## Node.js 版本检测

```bash
node --version
```

建议安装最新版本的 Hexo 和推荐的 Node.js 版本。