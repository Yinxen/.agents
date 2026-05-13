# Quick Settings (GNOME 45+)

## SystemIndicator

Container for quick settings items, manages the indicator icon.

```javascript
import * as QuickSettings from 'resource:///org/gnome/shell/ui/quickSettings.js';
import * as Main from 'resource:///org/gnome/shell/ui/main.js';

const indicator = GObject.registerClass(
class ExampleIndicator extends QuickSettings.SystemIndicator {
    constructor(extensionObject) {
        super();

        // Create and configure indicator icon
        this._indicator = this._addIndicator();
        this._indicator.icon_name = 'selection-mode-symbolic';

        // Show/hide based on settings
        this._settings = extensionObject.getSettings();
        this._settings.bind('feature-enabled', this._indicator, 'visible',
            Gio.SettingsBindFlags.DEFAULT);

        // Add toggle/menu items
        this.quickSettingsItems.push(new ExampleToggle(extensionObject));
    }

    destroy() {
        this.quickSettingsItems.forEach(item => item.destroy());
        super.destroy();
    }
});

// Register with quick settings
export default class ExampleExtension extends Extension {
    enable() {
        this._indicator = new ExampleIndicator(this);
        Main.panel.statusArea.quickSettings.addExternalIndicator(this._indicator);
    }

    disable() {
        this._indicator.destroy();
        this._indicator = null;
    }
}
```

## QuickToggle

Simple toggle button.

```javascript
const ExampleToggle = GObject.registerClass(
class ExampleToggle extends QuickSettings.QuickToggle {
    constructor(extensionObject) {
        super({
            title: _('Feature Title'),
            subtitle: _('Feature subtitle'),
            iconName: 'selection-mode-symbolic',
            toggleMode: true,
        });

        this._settings = extensionObject.getSettings();
        this._settings.bind('feature-enabled', this, 'checked',
            Gio.SettingsBindFlags.DEFAULT);
    }
});
```

## QuickMenuToggle

Toggle with a popup menu.

```javascript
const ExampleMenuToggle = GObject.registerClass(
class ExampleMenuToggle extends QuickSettings.QuickMenuToggle {
    constructor(extensionObject) {
        super({
            title: _('Menu Title'),
            subtitle: _('Menu subtitle'),
            iconName: 'selection-mode-symbolic',
            toggleMode: true,
        });

        // Set header (recommended for consistency)
        this.menu.setHeader('selection-mode-symbolic', _('Title'), _('Subtitle'));

        // Add header suffix icon
        const warningIcon = new St.Icon({ iconName: 'dialog-warning-symbolic' });
        this.menu.addHeaderSuffix(warningIcon);

        // Add menu items section
        this._itemsSection = new PopupMenu.PopupMenuSection();
        this._itemsSection.addAction(_('Menu Item 1'),
            () => console.debug('Item 1 activated!'));
        this._itemsSection.addAction(_('Menu Item 2'),
            () => console.debug('Item 2 activated!'));
        this.menu.addMenuItem(this._itemsSection);

        // Add settings entry point
        this.menu.addMenuItem(new PopupMenu.PopupSeparatorMenuItem());
        const settingsItem = this.menu.addAction(_('Settings'),
            () => extensionObject.openPreferences());

        // Hide settings when screen is locked
        settingsItem.visible = Main.sessionMode.allowSettings;
        this.menu._settingsActions[extensionObject.uuid] = settingsItem;
    }
});
```

## QuickSlider

Slider for values like brightness/volume.

```javascript
const ExampleSlider = GObject.registerClass(
class ExampleSlider extends QuickSettings.QuickSlider {
    constructor(extensionObject) {
        super({
            iconName: 'selection-mode-symbolic',
            iconLabel: _('Accessible Label'),
        });

        // Watch for slider changes
        this._sliderChangedId = this.slider.connect('notify::value',
            this._onSliderChanged.bind(this));
        this.slider.accessible_name = _('Example Slider');

        // Make icon clickable (e.g., mute toggle)
        this.iconReactive = true;
        this._iconClickedId = this.connect('icon-clicked',
            () => console.debug('Icon clicked!'));

        // Bind to GSettings (0-100 -> 0-1)
        this._settings = extensionObject.getSettings();
        this._settings.connect('changed::slider-value',
            this._onSettingsChanged.bind(this));
        this._onSettingsChanged();
    }

    _onSettingsChanged() {
        this.slider.block_signal_handler(this._sliderChangedId);
        this.slider.value = this._settings.get_uint('slider-value') / 100.0;
        this.slider.unblock_signal_handler(this._sliderChangedId);
    }

    _onSliderChanged() {
        const percent = Math.floor(this.slider.value * 100);
        this._settings.set_uint('slider-value', percent);
    }
});
```

### Adding Slider to Menu (spans two columns)
```javascript
Main.panel.statusArea.quickSettings.addExternalIndicator(indicator, 2);
```

## QuickSettingsItem

Base class for action buttons at top of quick settings.

```javascript
const ExampleButton = GObject.registerClass(
class ExampleButton extends QuickSettings.QuickSettingsItem {
    constructor() {
        super({
            style_class: 'icon-button',
            can_focus: true,
            icon_name: 'selection-mode-symbolic',
            accessible_name: _('Example Action'),
        });
        this.connect('clicked', () => console.log('activated'));
    }
});

// Manual addition to system actions area
const QuickSettingsActions = QuickSettingsMenu._system._indicator.child;
QuickSettingsActions.add_child(new ExampleButton());
```

## Important Notes

- Quick Settings items run in GNOME Shell process
- Use `Main.panel.statusArea.quickSettings.addExternalIndicator()` for extension indicators
- For two-column layout (sliders), pass `2` as second argument
- Menu items should use PopupMenu classes
- Settings should be hidden when `Main.sessionMode.allowSettings` is false