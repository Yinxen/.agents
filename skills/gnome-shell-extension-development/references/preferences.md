# Preferences and GSettings

## GSettings Schema

### Create Schema File
```xml
<!-- schemas/org.gnome.shell.extensions.example.gschema.xml -->
<?xml version="1.0" encoding="utf-8"?>
<schemalist>
  <schema id="org.gnome.shell.extensions.example"
          path="/org/gnome/shell/extensions/example/">
    <key name="show-indicator" type="b">
      <default>true</default>
      <summary>Show Indicator</summary>
      <description>Whether to show the panel indicator</description>
    </key>
    <key name="padding-inner" type="i">
      <default>8</default>
      <summary>Inner padding</summary>
    </key>
    <key name="animate" type="b">
      <default>true</default>
    </key>
  </schema>
</schemalist>
```

### Compile Schema
```bash
glib-compile-schemas schemas/
# GNOME 44+ auto-compiles for extensions installed via gnome-extensions tool
```

### metadata.json Integration
```json
{
    "settings-schema": "org.gnome.shell.extensions.example"
}
```

## Using GSettings

### In extension.js
```javascript
import { Extension } from 'resource:///org/gnome/shell/extensions/extension.js';
import Gio from 'gi://Gio';

export default class MyExtension extends Extension {
    enable() {
        this._settings = this.getSettings();

        // Bind to widget property
        this._settings.bind('show-indicator', this._indicator, 'visible',
            Gio.SettingsBindFlags.DEFAULT);

        // Watch for changes
        this._settings.connect('changed::show-indicator', (settings, key) => {
            console.debug(`${key} = ${settings.get_value(key).print(true)}`);
        });

        // Get values
        const bool = this._settings.get_boolean('show-indicator');
        const int = this._settings.get_int('padding-inner');
        const string = this._settings.get_string('key-name');

        // Set values
        this._settings.set_boolean('show-indicator', false);
    }

    disable() {
        this._settings = null;
    }
}
```

### In prefs.js
```javascript
import { ExtensionPreferences } from 'resource:///org/gnome/Shell/Extensions/js/extensions/prefs.js';
import Gio from 'gi://Gio';

export default class MyPrefs extends ExtensionPreferences {
    fillPreferencesWindow(window) {
        window._settings = this.getSettings();

        const row = new Adw.SwitchRow({ title: _('Show Indicator') });
        window._settings.bind('show-indicator', row, 'active',
            Gio.SettingsBindFlags.DEFAULT);

        // For GVariant values
        window._settings.bind('some-variant', widget, 'property',
            Gio.SettingsBindFlags.DEFAULT);
    }
}
```

## GTK4/Adwaita Preferences Window

```javascript
import Gtk from 'gi://Gtk?version=4.0';
import Adw from 'gi://Adw';
import { ExtensionPreferences, gettext as _ } from 'resource:///org/gnome/Shell/Extensions/js/extensions/prefs.js';

export default class MyPrefs extends ExtensionPreferences {
    fillPreferencesWindow(window) {
        // Page -> Group -> Rows
        const page = new Adw.PreferencesPage({
            title: _('General'),
            icon_name: 'dialog-information-symbolic',
        });
        window.add(page);

        const group = new Adw.PreferencesGroup({
            title: _('Appearance'),
            description: _('Configure the extension'),
        });
        page.add(group);

        // Switch Row
        const switchRow = new Adw.SwitchRow({
            title: _('Show Indicator'),
            subtitle: _('Toggle indicator visibility'),
        });
        group.add(switchRow);

        // Spin Row
        const spinRow = new Adw.SpinRow({
            title: _('Padding'),
            subtitle: _('Inner padding value'),
            adjustment: new Gtk.Adjustment({
                lower: 0,
                upper: 100,
                stepIncrement: 1,
            }),
        });
        group.add(spinRow);

        // Action Row
        const actionRow = Adw.ActionRow.new_with_icon(
            _('Open Settings'),
            'dialog-information-symbolic'
        );
        actionRow.connect('activated', () => {
            // Open something
        });
        group.add(actionRow);

        // Bind settings
        window._settings.bind('show-indicator', switchRow, 'active',
            Gio.SettingsBindFlags.DEFAULT);
        window._settings.bind('padding-inner', spinRow, 'value',
            Gio.SettingsBindFlags.DEFAULT);
    }
}
```

## Debugging Preferences

```bash
# prefs.js runs in separate gjs process
journalctl -f -o cat /usr/bin/gjs

# Watch dconf path
dconf watch /org/gnome/shell/extensions/example/
```

## Open Preferences from Extension
```javascript
this.openPreferences();  // Built-in method from Extension class
```