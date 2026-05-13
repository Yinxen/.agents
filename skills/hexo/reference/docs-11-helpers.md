# 辅助函数参考

在模板中使用 `<%- helper_name() %>` 调用。

## 网址辅助

### url_for

返回带根路径的 URL：

```ejs
<%- url_for(path, [relative]) %>
```

### relative_url

取得相对路径：

```ejs
<%- relative_url(from, to) %>
```

### full_url_for

返回带域名的完整 URL：

```ejs
<%- full_url_for(path) %>
```

### gravatar

返回 Gravatar 头像：

```ejs
<%- gravatar(email, [options]) %>
```

选项：`s` (大小), `d` (默认图), `f` (强制默认), `r` (评级)

## HTML 标签

### css

```ejs
<%- css(path, ...) %>
<%- css(['style.css', 'screen.css']) %>
<%- css({ href: 'style.css', integrity: 'foo' }) %>
```

### js

```ejs
<%- js(path, ...) %>
```

### link_to

```ejs
<%- link_to(path, [text], [options]) %>
```

选项：`external`, `class`, `id`

### mail_to

```ejs
<%- mail_to(path, [text], [options]) %>
```

选项：`class`, `id`, `subject`, `cc`, `bcc`, `body`

### image_tag

```ejs
<%- image_tag(path, [options]) %>
```

选项：`alt`, `class`, `id`, `width`, `height`

### favicon_tag

```ejs
<%- favicon_tag(path) %>
```

### feed_tag

```ejs
<%- feed_tag([path], [options]) %>
```

## 条件标签

```ejs
<%- is_current(path, [strict]) %>
<%- is_home() %>
<%- is_post() %>
<%- is_page() %>
<%- is_archive() %>
<%- is_year() %>
<%- is_month() %>
<%- is_category() %>
<%- is_category('hobby') %>
<%- is_tag() %>
<%- is_tag('hobby') %>
```

## 字符串处理

### trim

```ejs
<%- trim(string) %>
```

### strip_html

移除 HTML 标签：

```ejs
<%- strip_html(string) %>
```

### titlecase

转为 Title Case：

```ejs
<%- titlecase(string) %>
```

### markdown

解析 Markdown：

```ejs
<%- markdown(str) %>
```

### render

解析字符串：

```ejs
<%- render(str, engine, [options]) %>
```

### word_wrap

每行不超过指定长度：

```ejs
<%- word_wrap(str, [length]) %>
```

### truncate

截断字符串：

```ejs
<%- truncate(text, [options]) %>
```

选项：`length` (默认30), `separator`, `omission`

### escape_html

转义 HTML 实体：

```ejs
<%- escape_html(str) %>
```

## 模板

### partial

加载局部模板：

```ejs
<%- partial(layout, [locals], [options]) %>
```

选项：`cache`, `only`

### fragment_cache

局部缓存：

```ejs
<%- fragment_cache(id, fn) %>
```

## 日期与时间

所有日期函数接受 UNIX 时间、ISO 字符串、Date 或 Moment.js 对象。

### date

```ejs
<%- date(date, [format]) %>
```

默认格式：`YYYY-MM-DD`

### date_xml

XML 格式：

```ejs
<%- date_xml(date) %>
```

### time

```ejs
<%- time(date, [format]) %>
```

默认格式：`HH:mm:ss`

### full_date

完整日期时间：

```ejs
<%- full_date(date, [format]) %>
```

### relative_date

相对时间：

```ejs
<%- relative_date(date) %>
```

### time_tag

时间标签：

```ejs
<%- time_tag(date, [format]) %>
```

### moment

[Moment.js](http://momentjs.com/) 对象：

```ejs
<%- moment() %>
```

## 列表

### list_categories

```ejs
<%- list_categories([options]) %>
```

选项：`orderby`, `order`, `show_count`, `style`, `separator`, `depth`, `class`, `transform`, `suffix`

### list_tags

```ejs
<%- list_tags(tags, [options]) %>
```

选项：`orderby`, `order`, `show_count`, `style`, `separator`, `class`, `amount`, `transform`

### list_archives

```ejs
<%- list_archives([options]) %>
```

选项：`type`, `order`, `show_count`, `format`, `style`, `separator`, `class`, `transform`

### list_posts

```ejs
<%- list_posts([options]) %>
```

选项：`orderby`, `order`, `style`, `separator`, `class`, `amount`, `transform`

### tagcloud

```ejs
<%- tagcloud([tags], [options]) %>
```

选项：`min_font`, `max_font`, `unit`, `amount`, `orderby`, `order`, `color`, `start_color`, `end_color`, `class`, `level`

## 分页

### paginator

```ejs
<%- paginator(options) %>
```

选项：`base`, `format`, `total`, `current`, `prev_text`, `next_text`, `space`, `prev_next`, `end_size`, `mid_size`, `show_all`, `escape`

## 其他

### search_form

```ejs
<%- search_form([options]) %>
```

### number_format

```ejs
<%- number_format(number, [options]) %>
```

选项：`precision`, `delimiter`, `separator`

### meta_generator

```ejs
<%- meta_generator() %>
```

### open_graph

```ejs
<%- open_graph([options]) %>
```

选项：`title`, `type`, `url`, `image`, `author`, `date`, `updated`, `language`, `site_name`, `description`, `twitter_card`, `twitter_id`, `twitter_site`, `twitter_image`, `google_plus`, `fb_admins`, `fb_app_id`

### toc

解析目录：

```ejs
<%- toc(str, [options]) %>
```

选项：`class`, `list_number`, `max_depth`, `min_depth`, `max_items`