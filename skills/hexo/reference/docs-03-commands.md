# 命令详解

## hexo init

```bash
hexo init [folder]
```

新建网站。如果没有设置 `folder`，会在当前目录创建。

相当于执行：
1. Git clone hexo-starter 和 hexo-theme-landscape
2. 使用 Yarn/pnpm/npm 安装依赖

## hexo new

```bash
hexo new [layout] <title>
```

新建文章。默认使用 `default_layout` 布局。

### 选项

| 选项 | 描述 |
|------|------|
| `-p`, `--path` | 自定义文章路径 |
| `-r`, `--replace` | 替换现有文章 |
| `-s`, `--slug` | 自定义文章别名 |

### 示例

```bash
# 基本用法
hexo new "Hello World"
hexo new "My Post" --lang tw    # 创建多语言版本

# 自定义路径
hexo new page --path about/me "About me"

# 错误示例
hexo new page --path about/me   # 会创建 source/_posts/about/me.md，标题为 "page"
```

> **注意**: title 是必须指定的参数

## hexo generate

```bash
hexo generate
```

生成静态文件。

### 选项

| 选项 | 描述 |
|------|------|
| `-d`, `--deploy` | 生成后部署 |
| `-w`, `--watch` | 监视文件变动 |
| `-b`, `--bail` | 异常时抛出错误 |
| `-f`, `--force` | 强制重新生成 |
| `-c`, `--concurrency` | 同时生成的最大文件数 |

### 监视文件

```bash
hexo generate --watch
# 或
hexo g --watch
```

Hexo 会比对文件 SHA1 checksum，只写入变动的文件。

## hexo publish

```bash
hexo publish [layout] <filename>
```

发表草稿。相当于移动到 `_posts`。

## hexo server

```bash
hexo server
```

启动服务器，默认 `http://localhost:4000`。

### 选项

| 选项 | 描述 |
|------|------|
| `-p`, `--port` | 指定端口 |
| `-s`, `--static` | 静态模式（只处理 public 文件） |
| `-l`, `--log` | 启用日志 |

### 示例

```bash
hexo server              # 默认 4000 端口
hexo server -p 5000      # 指定端口
hexo server -s            # 静态模式
hexo server -i 192.168.1.1  # 自定义 IP
```

## hexo deploy

```bash
hexo deploy
```

部署网站。

### 选项

| 选项 | 描述 |
|------|------|
| `-g`, `--generate` | 部署前生成 |

## hexo render

```bash
hexo render <file1> [file2] ...
```

渲染文件。

### 选项

| 选项 | 描述 |
|------|------|
| `-o`, `--output` | 输出目标地址 |

## hexo migrate

```bash
hexo migrate <type>
```

从其他博客系统迁移。

```bash
hexo migrate rss <source>
```

## hexo clean

```bash
hexo clean
```

清除缓存 (`db.json`) 和已生成的静态文件 (`public`)。

## hexo list

```bash
hexo list <type>
```

列出所有路由。type 可以是 `page`, `post`, `route`, `tag`, `category`。

## hexo version

```bash
hexo version
```

显示版本信息。

## hexo config

```bash
hexo config [key] [value]
```

查看或修改配置。

```bash
hexo config          # 显示所有配置
hexo config title    # 显示 title 配置
hexo config title "My Site"  # 设置 title
```

## 全局选项

| 选项 | 描述 |
|------|------|
| `--safe` | 安全模式，不加载插件 |
| `--debug` | 调试模式，输出到 debug.log |
| `--silent` | 安静模式，不显示信息 |
| `--config custom.yml` | 指定配置文件 |
| `--draft` | 显示草稿 |
| `--cwd /path/to/cwd` | 自定义当前工作目录 |