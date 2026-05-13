# 部署指南

## 一键部署

安装部署器后，一条命令部署：

```bash
hexo deploy
```

### 部署器列表

| 部署器 | 安装命令 |
|--------|----------|
| Git | `npm install hexo-deployer-git --save` |
| Heroku | `npm install hexo-deployer-heroku --save` |
| Rsync | `npm install hexo-deployer-rsync --save` |
| FTP | `npm install hexo-deployer-ftpsync --save` |
| SFTP | `npm install hexo-deployer-sftp --save` |

## GitHub Pages

### 方式一：GitHub Actions (推荐)

1. 创建仓库 `username.github.io`
2. 推送代码到 main 分支
3. 仓库设置 → Pages → Source 选择 GitHub Actions

创建 `.github/workflows/pages.yml`：

```yaml
name: Pages

on:
  push:
    branches:
      - main

jobs:
  build:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4
        with:
          token: ${{ secrets.GITHUB_TOKEN }}
          submodules: recursive
      - name: Use Node.js 20
        uses: actions/setup-node@v4
        with:
          node-version: "20"
      - name: Cache NPM
        uses: actions/cache@v4
        with:
          path: node_modules
          key: ${{ runner.OS }}-npm-cache
      - name: Install
        run: npm install
      - name: Build
        run: npm run build
      - name: Upload artifact
        uses: actions/upload-pages-artifact@v3
        with:
          path: ./public
  deploy:
    needs: build
    permissions:
      pages: write
      id-token: write
    environment:
      name: github-pages
      url: ${{ steps.deployment.outputs.page_url }}
    runs-on: ubuntu-latest
    steps:
      - name: Deploy
        uses: actions/deploy-pages@v4
```

### 方式二：一键部署

```bash
npm install hexo-deployer-git --save
```

```yaml
# _config.yml
deploy:
  type: git
  repo: https://github.com/username/username.github.io
  branch: gh-pages
  message: Site updated: {{ now('YYYY-MM-DD HH:mm:ss') }}
```

```bash
hexo clean && hexo deploy
```

### 项目页面

1. 创建任意名称仓库如 `blog`
2. 编辑 `_config.yml`:
   ```yaml
   url: https://username.github.io/blog
   root: /blog/
   ```
3. 部署到 `gh-pages` 分支
4. 访问 `https://username.github.io/blog`

### 自定义域名

在 `source/` 添加 `CNAME` 文件：

```
example.com
```

## GitLab Pages

1. 创建仓库
2. 编辑 `_config.yml`:
   ```yaml
   url: https://username.gitlab.io/repository
   root: /repository/
   ```
3. 创建 `.gitlab-ci.yml`:
   ```yaml
   image: node:16-alpine
   cache:
     paths:
       - node_modules/
   before_script:
     - npm install hexo-cli -g
     - npm install
   pages:
     script:
       - npm run build
     artifacts:
       paths:
         - public
     rules:
       - if: $CI_COMMIT_BRANCH == $CI_DEFAULT_BRANCH
   ```

## Vercel

```bash
# package.json 添加脚本
{
  "scripts": {
    "build": "hexo generate"
  }
}
```

然后通过 Git 导入 Vercel。

## Netlify

通过网页界面导入 Git 仓库，或使用 CLI：

```bash
npm install -g netlify-cli
netlify init
```

## Rsync

```bash
npm install hexo-deployer-rsync --save
```

```yaml
deploy:
  type: rsync
  host: <host>
  user: <user>
  root: <root>
  port: [port]
  delete: [true|false]
```

## FTP/SFTP

```bash
npm install hexo-deployer-ftpsync --save
# 或
npm install hexo-deployer-sftp --save
```

## 其他方法

Hexo 生成的文件在 `public/` 目录，可手动复制到任意位置。