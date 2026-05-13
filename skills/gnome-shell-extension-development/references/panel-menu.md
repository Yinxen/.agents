# Panel Menu and Menu Items

## PanelMenu.Button

```javascript
import * as PanelMenu from 'resource:///org/gnome/shell/ui/panelMenu.js';
import * as Main from 'resource:///org/gnome/shell/ui/main.js';

const button = new PanelMenu.Button(alignment, name, isFirstButton);
// alignment: 0.0 = left, 1.0 = right
// isFirstButton: whether it's the first button in the area

// Add icon
const icon = new St.Icon({
    icon_name: 'face-laugh-symbolic',
    style_class: 'system-status-icon',
});
button.add_child(icon);

// Add menu items
button.menu.addAction('Label', callback);
button.menu.addMenuItem(popupMenuItem, position);

// Add to panel
Main.panel.addToStatusArea(uuid, button, index, side);
// side: St.Side.TOP, St.Side.BOTTOM, St.Side.LEFT, St.Side.RIGHT
```

## Menu Item Types

### PopupMenuItem
```javascript
const item = new PopupMenu.PopupMenuItem('Label', params);
// params: { active, can_focus, hover, reactive, style_class }

// Properties
item.label  // St.Label

// Set ornament
item.setOrnament(PopupMenu.Ornament.NONE | DOT | CHECK | HIDDEN);

// Activate signal
item.connect('activate', (item, event) => {
    // event is Clutter.Event
    return Clutter.EVENT_PROPAGATE; // or Clutter.EVENT_STOP
});
```

### PopupImageMenuItem
```javascript
const item = new PopupMenu.PopupImageMenuItem('Label', 'icon-name', params);
// or icon as Gio.Icon

item.icon    // St.Icon
item.label   // St.Label
item.setIcon('new-icon');
```

### PopupSwitchMenuItem
```javascript
const item = new PopupMenu.PopupSwitchMenuItem('Label', initialState, params);

item.label    // St.Label
item.state    // boolean (read-only)

item.connect('toggled', (item, state) => { /* ... */ });
item.setToggleState(state);
item.toggle();
item.setStatusText('On/Off status'); // or null to remove
```

### PopupSeparatorMenuItem
```javascript
const item = new PopupMenu.PopupSeparatorMenuItem('Optional Label');
item.label.text = 'New Label';
```

### PopupSubMenuMenuItem
```javascript
const item = new PopupMenu.PopupSubMenuMenuItem('Label', wantIcon);
item.icon        // St.Icon if wantIcon was true
item.label       // St.Label
item.menu        // PopupSubMenu (submenu)

// Add to submenu
item.menu.addAction('Submenu Item', () => {});
item.menu.addMenuItem(subItem);

// Open/close submenu
item.setSubmenuShown(true);
```

## Ornament Types
```javascript
PopupMenu.Ornament.NONE   // No ornament
PopupMenu.Ornament.DOT    // Radio button dot
PopupMenu.Ornament.CHECK  // Check mark
PopupMenu.Ornament.HIDDEN // Hides ornament area
```

## Menu Operations

```javascript
// Add items
menu.addAction(title, callback, icon);
menu.addSettingsAction(title, desktopFile);
menu.addMenuItem(menuItem, position);
menu.moveMenuItem(menuItem, position);

// Open/close
menu.open(BoxPointer.PopupAnimation.SLIDE | FADE | FULL | NONE);
menu.close(BoxPointer.PopupAnimation.SLIDE | FADE | FULL | NONE);
menu.toggle();

// Check state
menu.isEmpty();
menu.numMenuItems;
menu.firstMenuItem;

// Remove items
menu.removeAll();
menuItem.destroy();
```

## PopupMenuBase Signals

- `activate(menu, menuItem)` - When item activated
- `active-changed(menu, menuItem)` - Active item changed
- `open-state-changed(menu, open)` - Menu opened/closed
- `notify::sensitive` - Sensitivity changed
- `destroy(menu)` - Menu destroyed

## BoxPointer PopupAnimation

```javascript
import * as BoxPointer from 'resource:///org/gnome/shell/ui/boxpointer.js';

BoxPointer.PopupAnimation.NONE  // No animation
BoxPointer.PopupAnimation.SLIDE // Slide in/out
BoxPointer.PopupAnimation.FADE  // Fade in/out
BoxPointer.PopupAnimation.FULL  // Slide and fade
```