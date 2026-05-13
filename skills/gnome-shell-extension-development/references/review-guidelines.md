# Review Guidelines (extensions.gnome.org)

## General Rules

1. **Only use initialization for static resources**
   - `constructor()`: NO widgets, signals, main loop sources
   - `enable()`: Create objects, connect signals, add sources
   - `disable()`: Destroy, disconnect, remove - must match enable()

2. **Destroy all objects** in `disable()`
3. **Disconnect all signals** in `disable()`
4. **Remove all main loop sources** in `disable()`

## Code Patterns

### Correct (GNOME 45+)
```javascript
export default class MyExtension extends Extension {
    constructor(metadata) {
        super(metadata);
        // Only static initialization - Maps, arrays, constants
    }

    enable() {
        this._widget = new St.Widget();
        this._handlerId = someSignal.connect(() => {});
        this._sourceId = GLib.timeout_add(0, 1000, () => {});
    }

    disable() {
        this._widget?.destroy();
        this._widget = null;
        if (this._handlerId) {
            someSignal.disconnect(this._handlerId);
            this._handlerId = null;
        }
        if (this._sourceId) {
            GLib.Source.remove(this._sourceId);
            this._sourceId = null;
        }
    }
}
```

### Correct (GNOME 44 and earlier)
```javascript
class MyExtension {
    enable() {
        this._widget = new St.Widget();
    }

    disable() {
        if (this._widget) {
            this._widget.destroy();
            this._widget = null;
        }
    }
}

function init() {
    return new MyExtension();
}
```

## Prohibited

- Importing GTK/Gdk/Adw in extension.js (GNOME Shell process)
- Importing Clutter/Meta/St/Shell in prefs.js (separate process)
- Using deprecated modules:
  - `ByteArray` → use TextDecoder/TextEncoder
  - `Lang` → use ES6 classes
  - `Mainloop` → use GLib.timeout_add or setTimeout
- Obfuscated or minified code
- Excessive logging
- Telemetry/tracking tools
- AI-generated code (will be rejected if obvious)

## Requirements

### metadata.json
- `name`: Unique, not conflicting
- `uuid`: `extension-id@namespace` format
- `description`: Reasonable length
- `shell-version`: Only stable releases + one dev release
- `url`: GitHub/GitLab repository
- `session-modes`: Only if NOT just "user"
- `donations`: Only valid keys, or omit

### GSettings Schema
- ID: `org.gnome.shell.extensions.<name>`
- Path: `/org/gnome/shell/extensions/<name>/`
- Include XML file in zip
- Filename: `<schema-id>.gschema.xml`

### Code Quality
- Readable, structured code
- No minification
- ESLint recommended
- TypeScript must be transpiled to readable JS

## Session Modes

If using `unlock-dialog`:
- Must be necessary for operation
- All keyboard signals must be disconnected in unlock-dialog
- `disable()` must have comment explaining why

## Clipboard

- Must declare clipboard access in description
- Must NOT share data without explicit user action
- Must NOT ship with clipboard-related keyboard shortcuts

## Scripts/Binaries

- No binary executables or libraries
- Processes must exit cleanly
- Scripts should be GJS unless absolutely necessary
- External packages require explicit user installation

## Legal

- GPL-2.0-or-later compatible license
- If code from another extension, must attribute original
- No copyrighted/trademarked content without permission
- No political statements
- Must follow GNOME Code of Conduct

## Recommendations

- Follow GNOME HIG for preferences UI
- Use ESLint with GNOME Shell lint rules
- Don't include unnecessary files
- Test before submission

## Getting Help

- Matrix: #extensions:gnome.org
- Discourse: discourse.gnome.org (tag: extensions)
- StackOverflow: gnome-shell-extensions + gjs tags