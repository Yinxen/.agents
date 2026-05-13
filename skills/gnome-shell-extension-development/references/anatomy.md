# Extension Anatomy

## File Structure

```
extensionUUID@domain/
├── metadata.json          # Required: Extension metadata
├── extension.js           # Required: Main extension code
├── prefs.js               # Optional: Preferences window
├── stylesheet.css         # Optional: Custom styles
├── schemas/               # Optional: GSettings schemas
│   ├── gschemas.compiled  # Compiled schema (auto in GNOME 44+)
│   └── org.gnome.shell.extensions.example.gschema.xml
├── locale/                # Optional: Compiled translations
│   └── de/LC_MESSAGES/example.mo
└── po/                    # Optional: Translation source
    └── example.pot
```

## metadata.json

### Required Fields

```json
{
    "uuid": "unique-id@domain.com",
    "name": "Display Name",
    "description": "What the extension does",
    "shell-version": ["45"],
    "url": "https://github.com/user/repo"
}
```

### Optional Fields

```json
{
    "gettext-domain": "extension-name",
    "settings-schema": "org.gnome.shell.extensions.example",
    "session-modes": ["user", "unlock-dialog"],
    "donations": {
        "github": "username",
        "paypal": "username"
    },
    "version-name": "1.0"
}
```

### shell-version Guidelines
- GNOME 40+: Just major version (e.g., "40", "45")
- GNOME 3.x: Include minor (e.g., "3.38", "3.36")
- List tested versions; GNOME Shell validates against this

### UUID Format
- Pattern: `extension-id@namespace`
- Allowed: letters, numbers, period, underscore, hyphen
- NOT allowed: `gnome.org` namespace (requires permission)

## extension.js

### ESModule Pattern (GNOME 45+)

```javascript
import { Extension } from 'resource:///org/gnome/shell/extensions/extension.js';
import * as Main from 'resource:///org/gnome/shell/ui/main.js';

export default class MyExtension extends Extension {
    constructor(metadata) {
        super(metadata);
        // Static only - no widgets, signals, or sources
    }

    enable() {
        // Create objects, connect signals, add sources
    }

    disable() {
        // Destroy, disconnect, remove - MUST match enable()
    }
}
```

### Legacy Pattern (GNOME 44 and earlier)

```javascript
const ExtensionUtils = imports.misc.extensionUtils;

class MyExtension {
    constructor() {
        // No GObject, no widgets
    }

    enable() {
        // Create widgets, connect signals
    }

    disable() {
        // Cleanup
    }
}

function init() {
    ExtensionUtils.initTranslations();
    return new MyExtension();
}
```

## prefs.js

Runs in SEPARATE process - no Clutter/St/Meta/Shell imports!

```javascript
import Gtk from 'gi://Gtk?version=4.0';
import Adw from 'gi://Adw';
import { ExtensionPreferences, gettext as _ } from 'resource:///org/gnome/Shell/Extensions/js/extensions/prefs.js';

export default class ExamplePreferences extends ExtensionPreferences {
    fillPreferencesWindow(window) {
        // Build GTK4/Adwaita UI
        const page = new Adw.PreferencesPage({ title: _('General') });
        window.add(page);

        const group = new Adw.PreferencesGroup({ title: _('Settings') });
        page.add(group);

        const row = new Adw.SwitchRow({
            title: _('Enable Feature'),
            subtitle: _('Toggle the feature'),
        });
        group.add(row);

        // Bind to GSettings
        const settings = this.getSettings();
        settings.bind('feature-enabled', row, 'active', Gio.SettingsBindFlags.DEFAULT);
    }
}
```

## stylesheet.css

Only affects GNOME Shell, NOT preferences.

```css
/* Target all StLabel */
StLabel { color: red; }

/* Target by style_class */
.my-style { color: green; }

/* Target specific widget + class */
StLabel.my-style { color: blue; }

/* Target GTypeName (from GObject.registerClass) */
ExampleLabel { color: yellow; }
```