# 本地变量 (Locals)

局部变量用于模版渲染，也就是模版中的 `site` 变量。

## 默认变量

| 变量 | 描述 |
|------|------|
| `posts` | 所有文章 |
| `pages` | 所有分页 |
| `categories` | 所有分类 |
| `tags` | 所有标签 |

## 获取变量

```javascript
hexo.locals.get("posts");
```

## 设置变量

```javascript
hexo.locals.set('posts', function(){
  return ...
});
```

## 移除变量

```javascript
hexo.locals.remove("posts");
```

## 获取所有变量

```javascript
hexo.locals.toObject();
```

## 清除缓存

```javascript
hexo.locals.invalidate();
```
