# Session Modes

## Overview

Session modes allow extensions to run in different GNOME Shell states (login screen, unlock dialog, user session).

## metadata.json Configuration

```json
{
    "session-modes": ["user", "unlock-dialog"]
}
```

## Available Session Modes

| Mode | Description |
|------|-------------|
| `user` | Normal logged-in desktop session (default if not specified) |
| `unlock-dialog` | Lock screen / unlock dialog |
| `gdm` | Login screen (system extensions only) |

## Session Mode Detection

```javascript
import * as Main from 'resource:///org/gnome/shell/ui/main.js';

export default class MyExtension extends Extension {
    enable() {
        this._sessionId = Main.sessionMode.connect('updated',
            this._onSessionModeChanged.bind(this));
        this._onSessionModeChanged(Main.sessionMode);
    }

    _onSessionModeChanged(session) {
        // Check both current and parent mode
        if (session.currentMode === 'user' || session.parentMode === 'user') {
            // Normal user session
            this._showUI();
        } else if (session.currentMode === 'unlock-dialog') {
            // Lock screen
            this._hideUI();
        }
    }

    disable() {
        if (this._sessionId) {
            Main.sessionMode.disconnect(this._sessionId);
            this._sessionId = null;
        }
    }
}
```

## Complete Example

```javascript
import GLib from 'gi://GLib';
import St from 'gi://St';
import { Extension } from 'resource:///org/gnome/shell/extensions/extension.js';
import * as Main from 'resource:///org/gnome/shell/ui/main.js';
import * as PanelMenu from 'resource:///org/gnome/shell/ui/panelMenu.js';

export default class ReminderExtension extends Extension {
    constructor(metadata) {
        super(metadata);
        this._indicator = null;
        this._timeoutId = null;
        this._sessionId = null;
    }

    _addIndicator() {
        if (!this._indicator) {
            this._indicator = new PanelMenu.Button(0.0, 'Reminder', false);
            const icon = new St.Icon({
                icon_name: 'preferences-system-time-symbolic',
                style_class: 'system-status-icon',
            });
            this._indicator.add_child(icon);
            Main.panel.addToStatusArea('Reminder', this._indicator);
        }
    }

    _removeIndicator() {
        if (this._indicator) {
            this._indicator.destroy();
            this._indicator = null;
        }
    }

    _onSessionModeChanged(session) {
        if (session.currentMode === 'user' || session.parentMode === 'user')
            this._addIndicator();
        else if (session.currentMode === 'unlock-dialog')
            this._removeIndicator();
    }

    enable() {
        this._onSessionModeChanged(Main.sessionMode);
        this._sessionId = Main.sessionMode.connect('updated',
            this._onSessionModeChanged.bind(this));

        this._timeoutId = GLib.timeout_add_seconds(GLib.PRIORITY_DEFAULT,
            60 * 60, () => {
                Main.notify('Reminder', 'An hour has passed!');
                return GLib.SOURCE_CONTINUE;
            });
    }

    disable() {
        if (this._timeoutId) {
            GLib.Source.remove(this._timeoutId);
            this._timeoutId = null;
        }
        if (this._sessionId) {
            Main.sessionMode.disconnect(this._sessionId);
            this._sessionId = null;
        }
        this._removeIndicator();
    }
}
```

## Important Notes

- Extensions in `user` + `unlock-dialog` must handle `disable()` being called at any time
- Always check `session.parentMode` as well as `session.currentMode`
- Extensions on lock screen may need to disable keyboard-related signals
- `session-modes` field is optional; defaults to `["user"]` only