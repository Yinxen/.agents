# 故障排除

## YAML 解析错误

### 错误信息

```
JS-YAML: incomplete explicit mapping pair; a key node is missed at line 18, column 29
JS-YAML: bad indentation of a mapping entry at line 18, column 31
```

### 解决方案

- 字符串含冒号用引号：`"key: value"`
- 使用空格缩进（不是 Tab）
- 冒号后加空格

## EMFILE 错误 (too many open files)

### 错误信息

```
Error: EMFILE, too many open files
```

### 解决方案

```bash
# Linux
ulimit -n 10000

# 或修改 /etc/security/limits.conf:
* - nofile 10000
```

重启后生效。

## 内存溢出

### 错误信息

```
FATAL ERROR: CALL_AND_RETRY_LAST Allocation failed - process out of memory
```

### 解决方案

```bash
# 在 hexo-cli 第一行添加
#!/usr/bin/env node --max_old_space_size=8192
```

或

```bash
NODE_OPTIONS="--max-old-space-size=8192" hexo generate
```

## Git 部署失败

### RPC 失败

```
error: RPC failed; result=22, HTTP code = 403
fatal: 'username.github.io' does not appear to be a git repository
```

检查 git 配置，或改用 HTTPS 仓库地址。

### ENOENT

```
Error: ENOENT: no such file or directory
```

文件名大小写不一致导致的。解决方案：

1. 修正标签/分类大小写
2. 提交更改
3. 清理并重新生成：`hexo clean && hexo generate`

## EADDRINUSE

```
Error: listen EADDRINUSE
```

端口被占用。解决方案：

```bash
hexo server -p 5000
# 或
lsof -i :4000  # 查找占用进程
kill <PID>
```

## 插件安装失败

```
npm ERR! node-waf configure build
```

缺少编译器。安装对应语言的编译器（如 GCC）。

## DTrace 错误 (Mac)

```
Cannot find module './build/Release/DTraceProviderBindings'
```

```bash
npm install hexo --no-optional
```

## Jade/Swig 遍历数据

Hexo 使用 Warehouse 存储数据，不是普通数组：

```ejs
{% for post in site.posts.toArray() %}
{% endfor %}
```

## 数据没有更新

```bash
hexo clean
```

## 命令不执行

检查 `package.json` 是否有 `hexo` 字段：

```json
{
  "hexo": {
    "version": "3.2.2"
  }
}
```

## 转义内容

避免 `{{ }}` 或 `{% %}` 被解析：

```markdown
{% raw %}
{{ content }}
{% endraw %}

`{{ content }}`
```

## ENOSPC 错误 (Linux)

```bash
echo fs.inotify.max_user_watches=524288 | sudo tee -a /etc/sysctl.conf
sudo sysctl -p
```

## EMPERM 错误 (WSL)

WSL 不支持文件系统监视。解决方案：

```bash
hexo generate
hexo server -s  # 静态模式
```

## 模板渲染错误

```
Template render error: (unknown path)
```

检查文件是否有不可见字符，或标签语法错误。

## YAMLException (Hexo 6.1.0+)

升级 `js-yaml`：

```bash
npm install js-yaml@latest
# 或
yarn add js-yaml@latest
```