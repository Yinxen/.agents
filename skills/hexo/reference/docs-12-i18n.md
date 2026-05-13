# 国际化 (i18n)

## 配置语言

```yaml
# _config.yml
language: zh-CN
```

或多个语言（按顺序为默认语言）：

```yaml
language:
  - zh-tw
  - en
```

## 语言文件

放在主题的 `languages/` 目录：

```yaml
# languages/zh-CN.yml
index:
  title: 首页
  read_more: 阅读更多

archive:
  title: 归档

category:
  title: 分类

tag:
  title: 标签
```

支持 YAML 和 JSON 格式。

## 模板中使用

### 翻译字符串

```ejs
<%= __('index.title') %>
```

### 复数形式

```ejs
<%= _p('items.count', 5) %>
```

## 语言文件格式

```yaml
# en.yml
index:
  title: Home
  add: Add
  video:
    zero: No videos
    one: One video
    other: %d videos
```

```yaml
# zh-CN.yml
index:
  title: 首页
  add: 添加
  video:
    zero: 没有视频
    one: 一个视频
    other: '%d 个视频'
```

## 路径检测

Hexo 根据 URL 自动检测语言：

```
/index.html          => en
/archives/index.html => en
/zh-tw/index.html    => zh-tw
```

> 只有在语言文件中存在的字符串才会被识别为语言

## printf 格式

语言文件支持 printf 格式：

```yaml
greeting: Hello, %s!
```

```ejs
<%= __('greeting', 'World') %>
// => Hello, World!
```