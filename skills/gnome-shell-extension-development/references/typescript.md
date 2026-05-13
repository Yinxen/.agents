# TypeScript and LSP Setup

## Overview

TypeScript provides type checking and IDE auto-completion for GJS development.

## Project Structure

```
my-extension/
├── package.json
├── tsconfig.json
├── ambient.d.ts
├── extension.ts
├── prefs.ts
├── metadata.json
├── schemas/
│   └── org.gnome.shell.extensions.my-extension.gschema.xml
└── Makefile
```

## package.json

```json
{
  "name": "my-extension",
  "version": "0.0.0",
  "description": "A TypeScript GNOME Extension",
  "type": "module",
  "private": true,
  "scripts": {
    "build": "tsc"
  }
}
```

```bash
npm install --save-dev typescript
npm install @girs/gjs @girs/gnome-shell
```

## tsconfig.json

```json
{
  "compilerOptions": {
    "module": "NodeNext",
    "moduleResolution": "NodeNext",
    "outDir": "./dist",
    "sourceMap": false,
    "strict": true,
    "skipLibCheck": true,
    "target": "ES2023",
    "lib": ["ES2023"]
  },
  "include": ["ambient.d.ts"],
  "files": ["extension.ts", "prefs.ts"]
}
```

## ambient.d.ts

Enables imports without `@girs/` prefix.

```typescript
import "@girs/gjs";
import "@girs/gjs/dom";
import "@girs/gnome-shell/ambient";
import "@girs/gnome-shell/extensions/global";
```

## extension.ts

```typescript
import GLib from 'gi://GLib';
import Gio from 'gi://Gio';
import Meta from 'gi://Meta';
import Shell from 'gi://Shell';
import * as Main from 'resource:///org/gnome/shell/ui/main.js';
import { Extension } from 'resource:///org/gnome/shell/extensions/extension.js';

export default class MyExtension extends Extension {
    gsettings?: Gio.Settings;
    animationsEnabled: boolean = true;

    enable() {
        this.gsettings = this.getSettings();
        this.animationsEnabled = this.gsettings.get_boolean('animate') ?? true;
    }

    disable() {
        this.gsettings = undefined;
    }
}
```

## prefs.ts

```typescript
import Gtk from 'gi://Gtk';
import Adw from 'gi://Adw';
import Gio from 'gi://Gio';
import { ExtensionPreferences, gettext as _ } from 'resource:///org/gnome/Shell/Extensions/js/extensions/prefs.js';

export default class MyPrefs extends ExtensionPreferences {
    _settings?: Gio.Settings;

    fillPreferencesWindow(window: Adw.PreferencesWindow): Promise<void> {
        this._settings = this.getSettings();

        const page = new Adw.PreferencesPage({
            title: _('General'),
            iconName: 'dialog-information-symbolic',
        });

        const group = new Adw.PreferencesGroup({
            title: _('Animation'),
            description: _('Configure animation'),
        });
        page.add(group);

        const animationEnabled = new Adw.SwitchRow({
            title: _('Enabled'),
            subtitle: _('Wether to animate'),
        });
        group.add(animationEnabled);

        window.add(page);

        this._settings!.bind('animate', animationEnabled, 'active', Gio.SettingsBindFlags.DEFAULT);
        return Promise.resolve();
    }
}
```

## Makefile

```makefile
NAME=my-extension

.PHONY: all pack install clean

all: dist/extension.js dist/prefs.js

node_modules/.package-lock.json: package.json
	npm install

dist/extension.js dist/prefs.js: node_modules/.package-lock.json *.ts
	npm run build

schemas/gschemas.compiled: schemas/org.gnome.shell.extensions.$(NAME).gschema.xml
	glib-compile-schemas schemas

$(NAME).zip: dist/extension.js dist/prefs.js schemas/gschemas.compiled
	cp -r schemas dist/
	cp metadata.json dist/
	cd dist && zip ../$(NAME).zip -9r .

pack: $(NAME).zip

install: $(NAME).zip
	gnome-extensions install --force $(NAME).zip

clean:
	rm -rf dist node_modules $(NAME).zip
```

## Build Workflow

```bash
make        # Compile TypeScript
make pack   # Create zip for distribution
make install # Install extension
make clean  # Remove generated files
```

## Notes

- TypeScript compiles to JavaScript; generated files go in `dist/`
- GNOME Shell doesn't support TypeScript natively - requires build step
- `@girs/` packages provide type definitions for GJS
- ESLint can still be used on generated JavaScript files