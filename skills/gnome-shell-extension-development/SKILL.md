---
name: gnome-shell-extension-development
description: Comprehensive guide for developing GNOME Shell Extensions with GJS. Covers extension anatomy, ESModules (GNOME 45+), PanelMenu, PopupMenu, Quick Settings, Dialogs, Notifications, Search Providers, GSettings, translations, accessibility, debugging, and TypeScript LSP setup. Use when creating, debugging, or maintaining GNOME Shell extensions.
---

# GNOME Shell Extensions Development Guide

This skill provides comprehensive documentation for developing GNOME Shell Extensions using GJS (GNOME JavaScript).

## Quick Reference

### Extension Structure
```
extensionUUID@domain/
├── metadata.json    # Required: UUID, name, shell-version, url
├── extension.js     # Required: Extension class with enable()/disable()
├── prefs.js         # Optional: Preferences window (GTK4/Adwaita)
├── stylesheet.css   # Optional: Custom styling
├── schemas/         # Optional: GSettings schemas
│   └── org.gnome.shell.extensions.extension.gschema.xml
├── locale/          # Optional: Gettext translations
│   └── de/LC_MESSAGES/extension.mo
└── po/              # Optional: Translation source files
```

### Core Imports (GNOME 45+)
```javascript
import { Extension } from 'resource:///org/gnome/shell/extensions/extension.js';
import * as Main from 'resource:///org/gnome/shell/ui/main.js';
import * as PanelMenu from 'resource:///org/gnome/shell/ui/panelMenu.js';
import * as PopupMenu from 'resource:///org/gnome/shell/ui/popupMenu.js';
import St from 'gi://St';
import Gio from 'gi://Gio';
import GObject from 'gi://GObject';
```

### Basic Extension Pattern (GNOME 45+)
```javascript
import St from 'gi://St';
import { Extension } from 'resource:///org/gnome/shell/extensions/extension.js';
import * as Main from 'resource:///org/gnome/shell/ui/main.js';
import * as PanelMenu from 'resource:///org/gnome/shell/ui/panelMenu.js';

export default class ExampleExtension extends Extension {
    enable() {
        this._indicator = new PanelMenu.Button(0.0, this.metadata.name, false);
        const icon = new St.Icon({
            icon_name: 'face-laugh-symbolic',
            style_class: 'system-status-icon',
        });
        this._indicator.add_child(icon);
        Main.panel.addToStatusArea(this.uuid, this._indicator);
    }

    disable() {
        this._indicator?.destroy();
        this._indicator = null;
    }
}
```

### Minimal metadata.json
```json
{
    "uuid": "example@gjs.guide",
    "name": "Example Extension",
    "description": "An example extension",
    "shell-version": ["45"],
    "url": "https://github.com/user/example"
}
```

## Key Concepts

### ESModules (GNOME 45+)
Extensions use ESModules. Import paths:
- GNOME Shell modules: `resource:///org/gnome/shell/...`
- Extension's own files: `./module.js` (relative path)

### Extension Lifecycle
1. **Constructor**: Only static initialization (cache, constants). NO widgets, signals, or main loop sources.
2. **enable()**: Create widgets, connect signals, add main loop sources
3. **disable()**: Destroy widgets, disconnect signals, remove main loop sources

### Panel Menu Button Pattern
```javascript
const button = new PanelMenu.Button(0.0, 'IndicatorName', false);
// Add menu items
button.menu.addAction('Action', () => doSomething());
// Add to panel
Main.panel.addToStatusArea(uniqueId, button);
```

### Popup Menu Items
- `PopupMenu.PopupMenuItem(text)` - Simple text item
- `PopupMenu.PopupImageMenuItem(text, iconName)` - With icon
- `PopupMenu.PopupSwitchMenuItem(text, active)` - Toggle switch
- `PopupMenu.PopupSeparatorMenuItem()` - Separator
- `PopupMenu.PopupSubMenuMenuItem(text, wantIcon)` - Submenu

## Common Patterns

### GSettings Integration
```javascript
// In enable()
this._settings = this.getSettings();
this._settings.bind('key-name', widget, 'property', Gio.SettingsBindFlags.DEFAULT);

// Watch for changes
this._settings.connect('changed::key-name', (settings, key) => {
    console.debug(`${key} = ${settings.get_value(key).print(true)}`);
});
```

### Quick Settings Toggle (GNOME 45+)
```javascript
const ExampleToggle = GObject.registerClass(
class ExampleToggle extends QuickSettings.QuickToggle {
    constructor(extensionObject) {
        super({
            title: _('Title'),
            iconName: 'icon-name-symbolic',
            toggleMode: true,
        });
        this._settings = extensionObject.getSettings();
        this._settings.bind('feature-enabled', this, 'checked',
            Gio.SettingsBindFlags.DEFAULT);
    }
});

// Add to system indicator
const indicator = new QuickSettings.SystemIndicator();
indicator._indicator = indicator._addIndicator();
indicator._indicator.icon_name = 'icon-name-symbolic';
indicator.quickSettingsItems.push(new ExampleToggle(this));
Main.panel.statusArea.quickSettings.addExternalIndicator(indicator);
```

### Modal Dialog
```javascript
import * as ModalDialog from 'resource:///org/gnome/shell/ui/modalDialog.js';

const dialog = new ModalDialog.ModalDialog({ destroyOnClose: false });
dialog.setButtons([{
    label: 'Close',
    action: () => dialog.close(global.get_current_time()),
}, {
    label: 'Confirm',
    isDefault: true,
    action: () => { /* do something */ dialog.close(); }
}]);
dialog.open(global.get_current_time());
```

### Notification
```javascript
// Simple
Main.notify('Title', 'Body');

// With source
const source = MessageTray.getSystemSource();
const notification = new MessageTray.Notification({
    source: source,
    title: _('Title'),
    body: _('Body'),
    iconName: 'dialog-information',
    urgency: MessageTray.Urgency.NORMAL,
});
source.addNotification(notification);
```

### Translation Functions
```javascript
import { Extension, gettext as _, ngettext, pgettext } from 'resource:///org/gnome/shell/extensions/extension.js';

// Regular string
const translated = _('Hello');

// Plural
const count = 5;
const plural = ngettext('%d item', '%d items', count).format(count);

// With context
const context = pgettext('verb', 'Read'); // distinguishes from noun 'Read'
```

## Development Workflow

### Create Extension
```bash
# Interactive creation
gnome-extensions create --interactive

# Or manually
mkdir -p ~/.local/share/gnome-shell/extensions/uuid@domain/
touch metadata.json extension.js
```

### Test Extension (Wayland)
```bash
# Start nested session
dbus-run-session gnome-shell --devkit --wayland

# In nested session
gnome-extensions enable uuid@domain
```

### Test Extension (X11)
```bash
# Press Alt+F2, type 'restart', press Enter
gnome-extensions enable uuid@domain
journalctl -f -o cat /usr/bin/gnome-shell
```

### Debug
```bash
# Looking Glass (Alt+F2, type 'lg')
# GJS Console
gjs-console

# Logs
journalctl -f -o cat /usr/bin/gnome-shell
journalctl -f -o cat /usr/bin/gjs  # For prefs.js
```

### Environment Variables for Debugging
```bash
SHELL_DEBUG=backtrace-warnings  # Print JS stack on warnings
SHELL_DEBUG=backtrace-segfaults # Print JS stack on crashes
SHELL_DEBUG=all                 # Enable all debugging
```

## Reference

For detailed documentation on specific topics, see:
- @path references/anatomy.md - Extension file structure, metadata.json fields
- @path references/extension-class.md - Extension, ExtensionBase, ExtensionPreferences classes
- @path references/panel-menu.md - PanelMenu.Button and menu items
- @path references/quick-settings.md - Quick Settings API (GNOME 45+)
- @path references/dialogs.md - Dialog, ModalDialog classes
- @path references/notifications.md - MessageTray notifications
- @path references/preferences.md - GSettings, GTK4/Adwaita preferences
- @path references/translations.md - Gettext, i18n workflow
- @path references/search-provider.md - Search provider implementation
- @path references/debugging.md - Debugging techniques and tools
- @path references/typescript.md - TypeScript LSP setup
- @path references/session-modes.md - Session mode handling
- @path references/accessibility.md - Atk roles, states, relationships
- @path references/upgrading.md - Porting between GNOME versions
- @path references/review-guidelines.md - ego.gnome.org review requirements