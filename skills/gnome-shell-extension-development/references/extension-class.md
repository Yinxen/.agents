# Extension Classes (ESModule)

## ExtensionBase

Base class for Extension and ExtensionPreferences.

### Static Methods

- `Extension.lookupByUUID(uuid)` → ExtensionBase|null
- `Extension.lookupByURL(url)` → ExtensionBase|null

### Instance Properties

- `metadata` - ExtensionMetadata object (uuid, name, description, shell-version, dir, path)
- `dir` - Gio.File for extension directory
- `path` - String path to extension directory
- `uuid` - Extension UUID string

### Methods

- `getSettings(schema?)` → Gio.Settings
  - If schema omitted, uses metadata['settings-schema']
- `initTranslations(domain?)` → void
  - If domain omitted, uses metadata['gettext-domain']
- `gettext(str)` → string
- `ngettext(str, plural, n)` → string
- `pgettext(context, str)` → string

## Extension

Main extension class.

```javascript
import { Extension } from 'resource:///org/gnome/shell/extensions/extension.js';

export default class MyExtension extends Extension {
    enable() { /* setup UI */ }
    disable() { /* cleanup */ }
}
```

### Inheritance Chain
`Extension` → `ExtensionBase` → `GObject.Object`

## ExtensionPreferences

Preferences window class.

```javascript
import { ExtensionPreferences, gettext as _ } from 'resource:///org/gnome/Shell/Extensions/js/extensions/prefs.js';

export default class MyPrefs extends ExtensionPreferences {
    fillPreferencesWindow(window) {
        // window is Adw.PreferencesWindow
        const page = new Adw.PreferencesPage({ title: _('General') });
        window.add(page);
    }
}
```

### Two Implementation Styles

1. **fillPreferencesWindow(window)** - Full control over window
2. **getPreferencesWidget()** - Returns single GtkWidget (wrapped in Adw.PreferencesPage automatically)

## InjectionManager

For monkey-patching GNOME Shell methods.

```javascript
import { Extension, InjectionManager } from 'resource:///org/gnome/shell/extensions/extension.js';
import * as PanelMenu from 'resource:///org/gnome/shell/ui/panelMenu.js';

export default class MyExtension extends Extension {
    enable() {
        this._injectionManager = new InjectionManager();

        // Arrow function preserves 'this'
        this._injectionManager.overrideMethod(Panel.prototype, 'toggleCalendar',
            original => args => {
                console.debug('toggling calendar');
                original.call(Main.panel, ...args);
            });
    }

    disable() {
        this._injectionManager.clear();
        this._injectionManager = null;
    }
}
```

## ExtensionMetadata

Passed to constructor, available as `this.metadata`:

| Property | Type | Description |
|----------|------|-------------|
| uuid | String | Global unique identifier |
| name | String | Display name |
| description | String | Extension description |
| shell-version | Array(String) | Supported GNOME versions |
| dir | Gio.File | Extension directory |
| path | String | Extension path as string |