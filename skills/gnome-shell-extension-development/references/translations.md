# Translations and i18n

## Setup

### metadata.json
```json
{
    "gettext-domain": "example@gjs.guide"
}
```

### Initialize Translations

**GNOME 45+ (in constructor or at module level):**
```javascript
import { Extension, gettext as _ } from 'resource:///org/gnome/shell/extensions/extension.js';

export default class MyExtension extends Extension {
    constructor(metadata) {
        super(metadata);
        this.initTranslations();
    }
}
```

**GNOME 44 and earlier:**
```javascript
const ExtensionUtils = imports.misc.extensionUtils;

function init() {
    ExtensionUtils.initTranslations();
    return new Extension();
}
```

## Translation Functions

```javascript
import { Extension, gettext as _, ngettext, pgettext } from 'resource:///org/gnome/shell/extensions/extension.js';

// Simple translation
const hello = _('Hello World');

// Plural forms
const items = ngettext('%d item', '%d items', count).format(count);

// Context (for disambiguation)
const verbRead = pgettext('verb', 'Read');   // "to read"
const nounRead = pgettext('noun', 'Read');   // "a reading"

// With format
const message = _('Hello %s').format(username);
```

## Scanning for Strings

```bash
cd ~/.local/share/gnome-shell/extensions/uuid@domain/
xgettext --from-code=UTF-8 --output=po/uuid.pot *.js
```

### Generated .pot file
```pot
#: extension.js:24
msgctxt "menu item"
msgid "Notify"
msgstr ""

#: extension.js:28
msgid "Notification"
msgstr ""

#: extension.js:31
#, javascript-format
msgid "You have been notified %d time"
msgid_plural "You have been notified %d times"
msgstr[0] ""
msgstr[1] ""
```

## Compiling Translations

### Using gnome-extensions tool
```bash
gnome-extensions pack --podir=po extensionDirectory
```

### Manual compilation
```bash
# Create directory structure
mkdir -p locale/de/LC_MESSAGES/

# Compile .po to .mo
msgfmt po/de.po -o locale/de/LC_MESSAGES/example.mo
```

## Translation Workflow

1. Mark strings with `_()`, `ngettext()`, `pgettext()`
2. Run `xgettext` to generate `.pot` file
3. Translators create `.po` files from `.pot`
4. Compile `.po` to `.mo` files
5. Include in extension zip with `gnome-extensions pack --podir=po`

## Complete Example

```javascript
import St from 'gi://St';
import { Extension, gettext as _, ngettext, pgettext } from 'resource:///org/gnome/shell/extensions/extension.js';
import * as Main from 'resource:///org/gnome/shell/ui/main.js';
import * as PanelMenu from 'resource:///org/gnome/shell/ui/panelMenu.js';

export default class TranslateExtension extends Extension {
    constructor(metadata) {
        super(metadata);
        this.initTranslations();
        this._count = 0;
    }

    enable() {
        this._indicator = new PanelMenu.Button(0.0, this.metadata.name, false);

        const icon = new St.Icon({
            icon_name: 'dialog-information-symbolic',
            style_class: 'system-status-icon',
        });
        this._indicator.add_child(icon);

        // Menu item with context
        this._indicator.menu.addAction(pgettext('menu', 'Notify'), () => {
            this._count++;
            const title = _('Notification');
            const body = ngettext(
                'You have been notified %d time',
                'You have been notified %d times',
                this._count
            ).format(this._count);
            Main.notify(title, body);
        });

        Main.panel.addToStatusArea(this.uuid, this._indicator);
    }

    disable() {
        this._indicator?.destroy();
        this._indicator = null;
    }
}
```