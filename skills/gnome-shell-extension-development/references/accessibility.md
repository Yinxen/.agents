# Accessibility (Atk)

## Overview

GNOME Shell uses Atk (Accessibility Toolkit) for accessibility support. Clutter and St have built-in accessibility.

## Key Concepts

1. **Roles** - Semantic meaning (button, menu item, etc.)
2. **Relationships** - Links between elements (label → widget)
3. **States** - Current condition (sensitive, visible, checked)

## St.Widget Accessibility

```javascript
import Atk from 'gi://Atk';

// Set accessible role
widget.accessible_role = Atk.Role.BUTTON;
widget.accessible_role = Atk.Role.CHECK_BOX;
widget.accessible_role = Atk.Role.MENU_ITEM;
widget.accessible_role = Atk.Role.LABEL;

// Get Atk object for custom relationships
const atkObj = widget.get_accessible();
atkObj.add_relationship(Atk.RelationType.DESCRIPTION_FOR, otherWidget.get_accessible());
```

## States

```javascript
// Add/remove states
widget.add_accessible_state(Atk.StateType.SENSITIVE);
widget.remove_accessible_state(Atk.StateType.SENSITIVE);

// Common states
Atk.StateType.SENSITIVE      // Widget can be selected
Atk.StateType.VISIBLE        // Widget is visible
Atk.StateType.FOCUSABLE      // Can receive focus
Atk.StateType.FOCUSED        // Has focus
Atk.StateType.CHECKED        // For checkboxes/radio
Atk.StateType.SELECTED       // Is selected
Atk.StateType.EXPANDABLE     // Can be expanded
```

## Label Relationships

Connect label to its widget using `label_actor`:

```javascript
const label = new St.Label({ text: 'My Label' });
const entry = new St.Entry();

// Tell Atk that 'label' describes 'entry'
entry.label_actor = label;
```

## Complete Example: Custom Switch

```javascript
const Switch = GObject.registerClass({
    Properties: {
        'state': GObject.ParamSpec.boolean(
            'state', 'state', 'state',
            GObject.ParamFlags.READWRITE, false),
    },
}, class Switch extends St.Bin {
    constructor(state) {
        super({
            style_class: 'toggle-switch',
            accessible_role: Atk.Role.CHECK_BOX,
            state,
        });
        this._state = false;
    }

    get state() { return this._state; }

    set state(state) {
        if (this._state === state) return;
        if (state)
            this.add_style_pseudo_class('checked');
        else
            this.remove_style_pseudo_class('checked');
        this._state = state;
        this.notify('state');
    }

    toggle() { this.state = !this.state; }
});
```

## Complete Example: PopupSwitchMenuItem

```javascript
const PopupSwitchMenuItem = GObject.registerClass({
    Signals: { 'toggled': { param_types: [GObject.TYPE_BOOLEAN] } },
}, class PopupSwitchMenuItem extends PopupBaseMenuItem {
    constructor(text, active, params) {
        super(params);

        this.label = new St.Label({
            text,
            y_expand: true,
            y_align: Clutter.ActorAlign.CENTER,
        });
        this._switch = new Switch(active);

        this.accessible_role = Atk.Role.CHECK_MENU_ITEM;
        this.checkAccessibleState();
        this.label_actor = this.label;

        this.add_child(this.label);

        this._statusBin = new St.Bin({
            x_align: Clutter.ActorAlign.END,
            x_expand: true,
        });
        this.add_child(this._statusBin);

        this._statusLabel = new St.Label({
            text: '',
            style_class: 'popup-status-menu-item',
            y_expand: true,
            y_align: Clutter.ActorAlign.CENTER,
        });
        this._statusBin.child = this._switch;
    }

    setStatus(text) {
        if (text != null) {
            this._statusLabel.text = text;
            this._statusBin.child = this._statusLabel;
            this.reactive = false;
            this.accessible_role = Atk.Role.MENU_ITEM;
        } else {
            this._statusBin.child = this._switch;
            this.reactive = true;
            this.accessible_role = Atk.Role.CHECK_MENU_ITEM;
        }
        this.checkAccessibleState();
    }

    activate(event) {
        if (this._switch.mapped)
            this.toggle();
        if (event.type() === Clutter.EventType.KEY_PRESS &&
            event.get_key_symbol() === Clutter.KEY_space)
            return;
        super.activate(event);
    }

    toggle() {
        this._switch.toggle();
        this.emit('toggled', this._switch.state);
        this.checkAccessibleState();
    }

    checkAccessibleState() {
        switch (this.accessible_role) {
        case Atk.Role.CHECK_MENU_ITEM:
            if (this._switch.state)
                this.add_accessible_state(Atk.StateType.CHECKED);
            else
                this.remove_accessible_state(Atk.StateType.CHECKED);
            break;
        default:
            this.remove_accessible_state(Atk.StateType.CHECKED);
        }
    }
});
```

## CSS Pseudo-classes for States

St automatically applies states based on CSS:
- `:checked` → Atk.StateType.CHECKED
- `:selected` → Atk.StateType.SELECTED

## Key Atk Roles

| Role | Use |
|------|-----|
| BUTTON | Clickable element |
| CHECK_BOX | Binary toggle |
| CHECK_MENU_ITEM | Menu item with check |
| MENU_ITEM | Regular menu item |
| LABEL | Text label |
| RADIO_BUTTON | Radio button |
| LIST | List container |
| LIST_ITEM | List item |
| TABLE | Table container |
| TABLE_CELL | Table cell |