# Debugging

## Environment Variables

```bash
# Enable backtrace on warnings
SHELL_DEBUG=backtrace-warnings

# Enable backtrace on segfaults
SHELL_DEBUG=backtrace-segfaults

# Enable all debugging
SHELL_DEBUG=all

# Usage
SHELL_DEBUG=backtrace-warnings dbus-run-session gnome-shell --devkit --wayland
```

## Looking Glass

**Open:** Press `Alt+F2`, type `lg`, press Enter

### Pages:
- **Evaluator** - REPL for running JavaScript
  ```javascript
  Main.panel // Access objects
  stage     // global.stage alias
  inspect(x, y)  // Get actor at coordinates
  r(index)       // Get previous return value
  ```
- **Windows** - Inspect open windows
- **Extensions** - View extension status, errors, source
- **Actors** - Browse UI tree
- **Flags** - Debug options (use carefully)

### Evaluator Examples
```javascript
// Multi-line expressions
const sum = 2 + 2; const sq = sum * sum; return `Sum: ${sum}, Square: ${sq}`;

// Access return values
r(0)

// Inspect actor at position
inspect(1028, 26)

// Import modules (already imported: GLib, GObject, Gio, Clutter, Meta, St, Shell, Main)
```

## GJS Console

```bash
gjs-console

# In console:
gjs> log('message');
gjs> try { throw Error('test'); } catch(e) { logError(e, 'Prefix'); }
gjs> ^C  // Exit
```

Note: Runs in separate process, no access to gnome-shell

## Logging

```javascript
console.debug('Debug message');    // LEVEL_DEBUG
console.warn('Warning message');    // LEVEL_WARNING
console.error('Error message');      // LEVEL_CRITICAL

// With SHELL_DEBUG=backtrace-warnings, warnings/errors print JS stack
```

## Nested Shell (Wayland)

```bash
# GNOME 49+
dbus-run-session gnome-shell --devkit --wayland

# GNOME 48 and earlier
dbus-run-session gnome-shell --nested --wayland

# Full debugging script
#!/bin/sh -e
export G_MESSAGES_DEBUG=all
export SHELL_DEBUG=all
if [ "$(gnome-shell --version | awk '{print int($3)}')" -ge 49 ]; then
    dbus-run-session gnome-shell --devkit --wayland
else
    dbus-run-session gnome-shell --nested --wayland
fi
```

## Restart Shell (X11)

1. Press `Alt+F2`
2. Type `restart`
3. Press Enter

## Journal Logs

```bash
# GNOME Shell logs
journalctl -f -o cat /usr/bin/gnome-shell

# Preferences (prefs.js) logs
journalctl -f -o cat /usr/bin/gjs

# All GJS
journalctl -f -o cat /usr/bin/gjs-console
```

## GDB Debugging

```bash
# Start shell in GDB
dbus-run-session -- gdb --args gnome-shell --devkit --wayland

# In GDB:
run

# When breakpoint hit:
call (void)gjs_dumpstack()

# Break on warnings/criticals
set env G_DEBUG=fatal-warnings
# or
set env G_DEBUG=fatal-criticals
```

## System.breakpoint()

```javascript
import System from 'system';

export default class MyExtension extends Extension {
    enable() {
        System.breakpoint();  // Halts if debugger attached
    }
}
```

## Extension Source Location

```javascript
// Find extension directory
this.metadata.path        // String path
this.metadata.dir         // Gio.File

// Open in file manager
import Gio from 'gi://Gio';
Gio.app_info_launch_default_for_uri(`file://${this.metadata.path}`);
```

## dconf for Settings

```bash
# Watch extension settings
dconf watch /org/gnome/shell/extensions/example/

# Reset to defaults
dconf reset -f /org/gnome/shell/extensions/example/
```