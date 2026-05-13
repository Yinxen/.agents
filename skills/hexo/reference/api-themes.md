# 主题 (Themes)

`hexo.theme` 除了继承 [Box](/zh-cn/api/box) 外，还具有存储模板的功能。

## 获取视图

```javascript
hexo.theme.getView(path);
```

## 设置视图

```javascript
hexo.theme.setView(path, data);
```

## 移除视图

```javascript
hexo.theme.removeView(path);
```

## 视图

模板本身有两个方法可供使用：`render` 和 `renderSync`。

```javascript
var view = hexo.theme.getView("layout.swig");

view.render({ foo: 1, bar: 2 }).then(function (result) {
  // ...
});
```

您可以向 `render` 方法传入对象作为参数，`render` 方法会先使用对应的渲染引擎进行解析，并加载辅助函数。 当渲染完成时，它将尝试查找布局是否存在。 如果 `layout` 为 `false` 或者如果它不存在，将直接返回结果。
