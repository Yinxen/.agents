# 渲染 (Rendering)

在 Hexo 中，有两个方法可用于渲染文件或字符串，分别是异步的 `hexo.render.render` 和同步的 `hexo.render.renderSync`。

## 渲染字符串

在渲染字符串时，您必须指定 `engine`，如此一来 Hexo 才知道该使用哪个渲染引擎来渲染。

```javascript
hexo.render.render({ text: "example", engine: "swig" }).then(function (result) {
  // ...
});
```

## 渲染文件

在渲染文件时，您无须指定 `engine`，Hexo 会自动根据扩展名猜测所要使用的渲染引擎。

```javascript
hexo.render.render({ path: "path/to/file.swig" }).then(function (result) {
  // ...
});
```

## 渲染选项

您可以将选项对象作为第二个参数传入。

```javascript
hexo.render.render({ text: "" }, { foo: "foo" }).then(function (result) {
  // ...
});
```

## after_render 过滤器

在渲染完成后，Hexo 会自动执行相对应的 `after_render` 过滤器。 举例来说，我们可以通过这个功能实现 JavaScript 的压缩。

```javascript
var UglifyJS = require("uglify-js");

hexo.extend.filter.register("after_render:js", function (str, data) {
  var result = UglifyJS.minify(str);
  return result.code;
});
```

## 检查文件是否可被渲染

您可以通过 `isRenderable` 或 `isRenderableSync` 两个方法检查文件路径是否可以被渲染。

```javascript
hexo.render.isRenderable("layout.swig"); // true
hexo.render.isRenderable("image.png"); // false
```

## 获取文件的输出扩展名

使用 `getOutput` 方法来获取渲染输出的扩展名。

```javascript
hexo.render.getOutput("layout.swig"); // html
hexo.render.getOutput("image.png"); // ''
```

## 禁用 Nunjucks 标签

如果你没有使用 [标签插件](/zh-cn/docs/tag-plugins) 并且想要在你的文章中使用 `{{ }}` 或 `{% %}`：

```javascript
const renderer = hexo.render.renderer.get("md");
if (renderer) {
  renderer.disableNunjucks = true;
  hexo.extend.renderer.register("md", "html", renderer);
}
```
